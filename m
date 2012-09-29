Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8TMlvuG010782 for <xfs@oss.sgi.com>; Sat, 29 Sep 2012 17:47:57 -0500
Received: from mail-ie0-f181.google.com (mail-ie0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	YIQd4FKeRLxmnGE1 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 29 Sep 2012 15:49:18 -0700 (PDT)
Received: by iea16 with SMTP id 16so9913112iea.26
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2012 15:49:18 -0700 (PDT)
Date: Sat, 29 Sep 2012 16:49:03 -0600 (MDT)
From: Anand Tiwari <tiwarikanand@gmail.com>
Subject: Re: xfs_repair deleting realtime files.
In-Reply-To: <20120928064742.GE25626@dastard>
Message-ID: <alpine.DEB.2.02.1209291645330.7208@artemis>
References: <CAHt31_9K_vrzoqwSVsz-6VNVmMUzMyGCFEZfviRV-xPcUqv8-w@mail.gmail.com>
	<505BF45D.5050909@sandeen.net> <20120924075551.GF20960@dastard>
	<CAHt31_8rEc93vpnbbKngY4uS0kAct3Z5A+2G0LmBzv5rWKdSfA@mail.gmail.com>
	<CAHt31__s2TNhXPa9JfDLdWPqr60Te9VDPKb4ieORF8JAL07YmQ@mail.gmail.com>
	<20120926024403.GH29154@dastard>
	<CAHt31__FPLsDdVCVwwLO0Sh9v_KK2pzU577nywFPAmf_C-gRcQ@mail.gmail.com>
	<20120926061732.GI29154@dastard>
	<CAHt31__59_XJw9EF7MniiYH5sS6CX44q9gGwxiqxx43k5OFZ4A@mail.gmail.com>
	<20120928064742.GE25626@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Anand Tiwari <tiwarikanand@gmail.com>, xfs@oss.sgi.com



On Fri, 28 Sep 2012, Dave Chinner wrote:

> On Thu, Sep 27, 2012 at 07:27:16PM -0600, Anand Tiwari wrote:
> > On Wed, Sep 26, 2012 at 12:17 AM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > > On Tue, Sep 25, 2012 at 09:45:07PM -0600, Anand Tiwari wrote:
> > > > thanks Dave for prompt reply, I meant to implement option 2 as you
> > > > explained (option 3).  I will start working on it tomorrow. In the mean
> > > > time, I also had  to put something in xfs_repair for the files which
> > > > already exists on the disk. Would you guys willing to review/comment on
> > > > that ?
> > >
> > > Sure.
> > >
> > > Cheers,
> > >
> > > Dave.
> > > --
> > > Dave Chinner
> > > david@fromorbit.com
> > >
> >
> > following are my changes for xfs_repair. my goal  is to keep changes
> > minimum as they may not included in upstream. I had to do these changes as
> > we already have files with extent map not properly aligned.
> > As we know, this happens only when we are growing a file in a realtime
> > volume. by keeping this in mind, I am checking if start of a record in
> > extent map is not aligned, check previous record and if they are
> > contiguous, we can skip that part of record.
> >
> > let me know if you any issues with this or if someone has better approach.
> > I would like to use pointers for prev and irec but again, I wanted to keep
> > changes minimum
> >
> > thanks
> > anand
> >
> >
>
> Your mailer has removed all the whitespace from the patch. The files
> Documentation/SubmittingPatches and Documentation/email-clients.txt
> for help with how to send patches sanely via email. ;)
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

okay,here is my second attempt, hope this time it work.

>From 77f8dc66fa5ce6b004f95dbb794322be35d4190a Mon Sep 17 00:00:00 2001
From: Anand Tiwari <anand.tiwari@linux.com>
Date: Fri, 28 Sep 2012 15:45:55 -0600
Subject: [PATCH] xfs_repair: detect realtime extent shared by multiple
 records in extent map

XFS currently can have records in extent map, which starts from unaligned start block w.r.t rextsize.
xfs_repair considers this as a bug (multiple claims for a real-time extent) and deletes the file.
This patch addresses the issue, by comparing current and previous records and make sure they are
contiguous and not overlapped.

Signed-off-by: Anand Tiwari <anand.tiwari@linux.com>
---
 repair/dinode.c |   37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index 5a2da39..5537f1c 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -406,6 +406,7 @@ verify_agbno(xfs_mount_t	*mp,
 static int
 process_rt_rec(
 	xfs_mount_t		*mp,
+	xfs_bmbt_irec_t 	*prev,
 	xfs_bmbt_irec_t 	*irec,
 	xfs_ino_t		ino,
 	xfs_drfsbno_t		*tot,
@@ -413,8 +414,11 @@ process_rt_rec(
 {
 	xfs_dfsbno_t		b;
 	xfs_drtbno_t		ext;
+	xfs_drtbno_t		start_block;
+	xfs_filblks_t		block_count;
 	int			state;
 	int			pwe;		/* partially-written extent */
+	int 			rtext_remainder;	/* start block is not aligned w.r.t rextsize */

 	/*
 	 * check numeric validity of the extent
@@ -461,12 +465,32 @@ _("malformed rt inode extent [%" PRIu64 " %" PRIu64 "] (fs rtext size = %u)\n"),
 		return 1;
 	}

+	/* If we have start of record unaligned w.r.t to rextsize, see
+	 * if we are sharing this realtime extent with previous record. sharing is only
+	 * allowed with previous extent. fail otherwise.
+	 * Also, we above condition is true, align start block and block count
+	 */
+	rtext_remainder = irec->br_startblock % mp->m_sb.sb_rextsize;
+	if (rtext_remainder) {
+		do_warn(
+_("data fork in rt ino %" PRIu64 " has unalinged start block %"PRIu64 "\n"),
+		ino,
+		irec->br_startblock);
+		if ((prev->br_startoff + prev->br_blockcount == irec->br_startoff) &&
+		    (prev->br_startblock + prev->br_blockcount == irec->br_startblock)) {
+			start_block = irec->br_startblock + (mp->m_sb.sb_rextsize - rtext_remainder);
+			block_count = irec->br_blockcount - (mp->m_sb.sb_rextsize - rtext_remainder);
+		}
+	} else {
+		start_block = irec->br_startblock;
+		block_count = irec->br_blockcount;
+	}
+
 	/*
 	 * set the appropriate number of extents
 	 * this iterates block by block, this can be optimised using extents
 	 */
-	for (b = irec->br_startblock; b < irec->br_startblock +
-			irec->br_blockcount; b += mp->m_sb.sb_rextsize)  {
+	for (b = start_block; b < start_block + block_count; b += mp->m_sb.sb_rextsize)  {
 		ext = (xfs_drtbno_t) b / mp->m_sb.sb_rextsize;
 		pwe = xfs_sb_version_hasextflgbit(&mp->m_sb) &&
 				irec->br_state == XFS_EXT_UNWRITTEN &&
@@ -548,6 +572,7 @@ process_bmbt_reclist_int(
 	int			check_dups,
 	int			whichfork)
 {
+	xfs_bmbt_irec_t		prev;
 	xfs_bmbt_irec_t		irec;
 	xfs_dfilblks_t		cp = 0;		/* prev count */
 	xfs_dfsbno_t		sp = 0;		/* prev start */
@@ -574,6 +599,11 @@ process_bmbt_reclist_int(
 	else
 		ftype = _("regular");

+	prev.br_startoff = 0;
+	prev.br_blockcount = 0;
+	prev.br_startblock = 0;
+	prev.br_state = 0;
+
 	for (i = 0; i < *numrecs; i++) {
 		libxfs_bmbt_disk_get_all(rp + i, &irec);
 		if (i == 0)
@@ -610,12 +640,13 @@ _("zero length extent (off = %" PRIu64 ", fsbno = %" PRIu64 ") in ino %" PRIu64
 			 * realtime bitmaps don't use AG locks, so returning
 			 * immediately is fine for this code path.
 			 */
-			if (process_rt_rec(mp, &irec, ino, tot, check_dups))
+			if (process_rt_rec(mp, &prev, &irec, ino, tot, check_dups))
 				return 1;
 			/*
 			 * skip rest of loop processing since that'irec.br_startblock
 			 * all for regular file forks and attr forks
 			 */
+			memcpy(&prev, &irec, sizeof(xfs_bmbt_irec_t));
 			continue;
 		}

-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
