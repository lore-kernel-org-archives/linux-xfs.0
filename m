Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KKAFnG012442 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 14:10:15 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A6B4A35C7
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 12:10:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id KfQrvWvD15GqLFP1 for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2009 12:10:14 -0800 (PST)
Date: Tue, 20 Jan 2009 14:38:27 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <20090118173144.GA1999@infradead.org>
Message-ID: <Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
	<20090118173144.GA1999@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Sun, 18 Jan 2009, Christoph Hellwig wrote:

> On Tue, Jan 13, 2009 at 11:28:58PM -0500, Mikulas Patocka wrote:
> > The result must not depend on magic timer values. If it does, you end up 
> > with undebbugable nondeterministic failures.
> > 
> > Why don't you change that 500ms wait to "wait until the flush finishes"? 
> > That would be correct.
> 
> Yes, this probably would better.  Could I motivate you to come up with
> a patch for that?
> 

Hi

I looked at the source and found out that it uses sync_blockdev for 
syncing --- but sync_blockdev writes only metadata buffers, it doesn't 
touch inodes and pages and doesn't resolve delayed allocations. So it 
really doesn't sync anything.

I replaced it with correct syncing of all inodes. With this patch it 
passes my testcase (no more spurious -ENOSPCs), but it still isn't 
correct, there is that 500ms delay --- if the machine was so overloaded 
that it couldn't sync withing 500ms, you still get spurious -ENOSPC.

There are notions about possible deadlocks (the syncer may lock against 
the process that is waiting for the sync to finish), that's why removing 
that 500ms delay isn't that easy as it seems. I don't have XFS knowledge 
to check for the deadlocks, it should be done by XFS developers. Also, 
when you resolve the deadlocks and drop the timeout, replace WB_SYNC_NONE 
with WB_SYNC_ALL in this patch.

Mikulas

---

Properly sync when the filesystem runs out of space because of delayed
allocation overaccounting.

Note that sync_blockdev writes just dirty metadata buffers, it doesn't touch
inodes or data buffers --- so it had no effect.

WB_SYNC_ALL should be used instead of WB_SYNC_NONE, but WB_SYNC_ALL gets worse
results --- it is likely because WB_SYNC_ALL sync locks against the process
doing the write, stalling the whole sync. This needs to be further investigated
by XFS developers. Also, further investigation is needed to remove that
delay(msecs_to_jiffies(500)).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 fs/xfs/linux-2.6/xfs_sync.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.29-rc1-devel/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.29-rc1-devel.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-01-20 20:13:32.000000000 +0100
+++ linux-2.6.29-rc1-devel/fs/xfs/linux-2.6/xfs_sync.c	2009-01-20 20:24:31.000000000 +0100
@@ -446,7 +446,13 @@ xfs_flush_device_work(
 	void		*arg)
 {
 	struct inode	*inode = arg;
-	sync_blockdev(mp->m_super->s_bdev);
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_NONE,
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.nr_to_write = LONG_MAX,
+	};
+	generic_sync_sb_inodes(mp->m_super, &wbc);
 	iput(inode);
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
