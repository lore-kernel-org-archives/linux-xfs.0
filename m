Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5OMMDbD049372 for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 17:22:13 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39AED1546212
	for <xfs@oss.sgi.com>; Thu, 24 Jun 2010 15:24:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	DCqePXt43nFrvEsr for <xfs@oss.sgi.com>;
	Thu, 24 Jun 2010 15:24:53 -0700 (PDT)
Received: from dastard (unverified [121.91.222.126])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	17549871-1927428
	for <xfs@oss.sgi.com>; Fri, 25 Jun 2010 07:54:52 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1ORuqn-00087a-67
	for xfs@oss.sgi.com; Fri, 25 Jun 2010 08:24:49 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1ORuqh-00065Z-ON
	for xfs@oss.sgi.com; Fri, 25 Jun 2010 08:24:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs_db: check for valid inode data pointer before
	dereferencing
Date: Fri, 25 Jun 2010 08:24:43 +1000
Message-Id: <1277418283-23381-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When processing an inode, the code checks various flags to determine
whether to output messages or not. When checking the CLI provided
inode numbers to be verbose about, we fail to check if the inode
data structre returned is valid or not before dereferencing it.
Hence running xfs_check with the "serious errors only" flag, xfs_db
will crash. Fix up the "should we output" logic to be safe.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/check.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/db/check.c b/db/check.c
index c62321b..4f8a62a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2619,6 +2619,7 @@ process_inode(
 	xfs_qcnt_t		ic = 0;
 	xfs_qcnt_t		rc = 0;
 	xfs_dqid_t		dqprid;
+	int			v = 0;
 	static char		okfmts[] = {
 		0,				/* type 0 unused */
 		1 << XFS_DINODE_FMT_DEV,	/* FIFO */
@@ -2653,15 +2654,16 @@ process_inode(
 		bno = XFS_INO_TO_FSB(mp, ino);
 		blkmap = NULL;
 	}
+	v = (!sflag || (id && id->ilist) || CHECK_BLIST(bno));
 	if (idic.di_magic != XFS_DINODE_MAGIC) {
-		if (!sflag || isfree || id->ilist || CHECK_BLIST(bno))
+		if (isfree || v)
 			dbprintf(_("bad magic number %#x for inode %lld\n"),
 				idic.di_magic, ino);
 		error++;
 		return;
 	}
 	if (!XFS_DINODE_GOOD_VERSION(idic.di_version)) {
-		if (!sflag || isfree || id->ilist || CHECK_BLIST(bno))
+		if (isfree || v)
 			dbprintf(_("bad version number %#x for inode %lld\n"),
 				idic.di_version, ino);
 		error++;
@@ -2669,7 +2671,7 @@ process_inode(
 	}
 	if (isfree) {
 		if (idic.di_nblocks != 0) {
-			if (!sflag || id->ilist || CHECK_BLIST(bno))
+			if (v)
 				dbprintf(_("bad nblocks %lld for free inode "
 					 "%lld\n"),
 					idic.di_nblocks, ino);
@@ -2680,21 +2682,22 @@ process_inode(
 		else
 			nlink = idic.di_nlink;
 		if (nlink != 0) {
-			if (!sflag || id->ilist || CHECK_BLIST(bno))
+			if (v)
 				dbprintf(_("bad nlink %d for free inode %lld\n"),
 					nlink, ino);
 			error++;
 		}
 		if (idic.di_mode != 0) {
-			if (!sflag || id->ilist || CHECK_BLIST(bno))
+			if (v)
 				dbprintf(_("bad mode %#o for free inode %lld\n"),
 					idic.di_mode, ino);
 			error++;
 		}
 		return;
 	}
+
 	if (be32_to_cpu(dip->di_next_unlinked) != NULLAGINO) {
-		if (!sflag || isfree || id->ilist || CHECK_BLIST(bno))
+		if (v)
 			dbprintf(_("bad next unlinked %#x for inode %lld\n"),
 				be32_to_cpu(dip->di_next_unlinked), ino);
 		error++;
@@ -2704,27 +2707,27 @@ process_inode(
 	 */
 	if ((((idic.di_mode & S_IFMT) >> 12) > 15) ||
 	    (!(okfmts[(idic.di_mode & S_IFMT) >> 12] & (1 << idic.di_format)))) {
-		if (!sflag || id->ilist || CHECK_BLIST(bno))
+		if (v)
 			dbprintf(_("bad format %d for inode %lld type %#o\n"),
 				idic.di_format, id->ino, idic.di_mode & S_IFMT);
 		error++;
 		return;
 	}
 	if ((unsigned int)XFS_DFORK_ASIZE(dip, mp) >= XFS_LITINO(mp))  {
-		if (!sflag || id->ilist)
+		if (v)
 			dbprintf(_("bad fork offset %d for inode %lld\n"),
 				idic.di_forkoff, id->ino);
 		error++;
 		return;
 	}
 	if ((unsigned int)idic.di_aformat > XFS_DINODE_FMT_BTREE)  {
-		if (!sflag || id->ilist)
+		if (v)
 			dbprintf(_("bad attribute format %d for inode %lld\n"),
 				idic.di_aformat, id->ino);
 		error++;
 		return;
 	}
-	if (verbose || id->ilist || CHECK_BLIST(bno))
+	if (verbose || (id && id->ilist) || CHECK_BLIST(bno))
 		dbprintf(_("inode %lld mode %#o fmt %s "
 			 "afmt %s "
 			 "nex %d anex %d nblk %lld sz %lld%s%s%s%s%s%s%s\n"),
@@ -2844,20 +2847,20 @@ process_inode(
 	}
 	totblocks = totdblocks + totiblocks + atotdblocks + atotiblocks;
 	if (totblocks != idic.di_nblocks) {
-		if (!sflag || id->ilist || CHECK_BLIST(bno))
+		if (v)
 			dbprintf(_("bad nblocks %lld for inode %lld, counted "
 				 "%lld\n"),
 				idic.di_nblocks, id->ino, totblocks);
 		error++;
 	}
 	if (nextents != idic.di_nextents) {
-		if (!sflag || id->ilist || CHECK_BLIST(bno))
+		if (v)
 			dbprintf(_("bad nextents %d for inode %lld, counted %d\n"),
 				idic.di_nextents, id->ino, nextents);
 		error++;
 	}
 	if (anextents != idic.di_anextents) {
-		if (!sflag || id->ilist || CHECK_BLIST(bno))
+		if (v)
 			dbprintf(_("bad anextents %d for inode %lld, counted "
 				 "%d\n"),
 				idic.di_anextents, id->ino, anextents);
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
