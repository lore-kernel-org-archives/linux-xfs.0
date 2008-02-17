Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 14:47:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1HMlb0i028680
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 14:47:40 -0800
Date: Mon, 18 Feb 2008 09:47:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
Message-ID: <20080217224736.GX155407@sgi.com>
References: <47B863A9.5070206@gmail.com> <6101e8c40802170851w73db8130t9bcfdc5cf053f0dc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6101e8c40802170851w73db8130t9bcfdc5cf053f0dc@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>

On Sun, Feb 17, 2008 at 05:51:08PM +0100, Oliver Pinter wrote:
> On 2/17/08, Török Edwin <edwintorok@gmail.com> wrote:
> > Hi,
> >
> > xfsaild is causing many wakeups, a quick investigation shows
> > xfsaild_push is always
> > returning 30 msecs timeout value.

That's a bug, and has nothing to do with power consumption. ;)

I can see that there is a dirty item in the filesystem:

Entering kdb (current=0xe00000b8f4fe0000, pid 30046) on processor 3 due to Breakpoint @ 0xa000000100454fc0
[3]kdb> bt
Stack traceback for pid 30046
0xe00000b8f4fe0000    30046        2  1    3   R  0xe00000b8f4fe0340 *xfsaild
0xa000000100454fc0 xfsaild_push
        args (0xe00000b8ffff9090, 0xe00000b8f4fe7e30, 0x31b)
....
[3]kdb> xail 0xe00000b8ffff9090
AIL for mp 0xe00000b8ffff9090, oldest first
[0] type buf flags: 0x1 <in ail >   lsn [1:13133]
   buf 0xe00000b880258800 blkno 0x0 flags: 0x2 <dirty >
   Superblock (at 0xe00000b8f9b3c000)
[3]kdb>

the superblock is dirty, and the lsn is well beyond the target
of the xfsaild hence it *should* be idling. However, it isn't
idling because there is a dirty item in the list and the idle trigger
of "is list empty" is not tripping.

I only managed to reproduce this on a lazy superblock counter
filesystem (i.e.  new mkfs and recent kernel), as it logs the
superblock every so often, and that is probably what is keeping the
fs dirty like this.

Can you see if the patch below fixes the problem.

---

Idle state is not being detected properly by the xfsaild push
code. The current idle state is detected by an empty list
which may never happen with mostly idle filesystem or one
using lazy superblock counters. A single dirty item in the
list will result repeated looping to push everything past
the target when everything because it fails to check if we
managed to push anything.

Fix by considering a dirty list with everything past the target
as an idle state and set the timeout appropriately.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/xfs_trans_ail.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_ail.c	2008-02-18 09:14:34.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c	2008-02-18 09:18:52.070682570 +1100
@@ -261,14 +261,17 @@ xfsaild_push(
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
 	}
 
-	/*
-	 * We reached the target so wait a bit longer for I/O to complete and
-	 * remove pushed items from the AIL before we start the next scan from
-	 * the start of the AIL.
-	 */
-	if ((XFS_LSN_CMP(lsn, target) >= 0)) {
+	if (count && (XFS_LSN_CMP(lsn, target) >= 0)) {
+		/*
+		 * We reached the target so wait a bit longer for I/O to
+		 * complete and remove pushed items from the AIL before we
+		 * start the next scan from the start of the AIL.
+		 */
 		tout += 20;
 		last_pushed_lsn = 0;
+	} else if (!count) {
+		/* We're past our target or empty, so idle */
+		tout = 1000;
 	} else if ((restarts > XFS_TRANS_PUSH_AIL_RESTARTS) ||
 		   (count && ((stuck * 100) / count > 90))) {
 		/*
