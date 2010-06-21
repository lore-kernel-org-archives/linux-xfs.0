Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L5Zdv0105773 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 00:35:39 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1E2F150F615
	for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 22:38:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	o1pLWImu0LqKI8b7 for <xfs@oss.sgi.com>;
	Sun, 20 Jun 2010 22:38:17 -0700 (PDT)
Date: Mon, 21 Jun 2010 15:38:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: segment fault when running xfs_check -s
Message-ID: <20100621053803.GK6590@dastard>
References: <1277088918.20616.81.camel@redfuture-desktop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1277088918.20616.81.camel@redfuture-desktop>
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
To: xiaowei hu <xiaowei.hu@oracle.com>
Cc: wen.gang.wang@oracle.com, xfs@oss.sgi.com

On Mon, Jun 21, 2010 at 10:55:18AM +0800, xiaowei hu wrote:
> Hi,
> 
> Recently I was playing with xfsprogs, and did some test on xfs_check
> tools in this mothod:
> 1.make a xfs fs on one partition.
> mkfs.xfs -f /dev/sda2
> 2.randomly modify some blocks on this volume using xfs_db.
> xfs_db -x -c blockget -c "blocktrash -3 -s 36 -n 81" /dev/sda2
> 3.run xfs_check -s
> xfs_check -s /dev/sda2
> 
> the output saying:
> [root@test1 ~]# xfs_check -s /dev/sda2
> bad version number 0x78 for inode 135
> bad magic number 0xa855 for inode 154
> bad magic number 0x5024 for inode 165
> /usr/local/bin/xfs_check: line 28:   769 Segmentation fault      xfs_db
> $DBOPTS -F -i -p xfs_check -c "blockget$OPTS" $1
> 
> if I run xfs_check without -s option, don't have this fault.
> 
> Is this a known problem?

No.

> I tried the latest code ,also have this problem.

Yeah, the code determining whether to output a message is broken:

2651         if (!isfree) {
2652                 id = find_inode(ino, 1);
2653                 bno = XFS_INO_TO_FSB(mp, ino);
2654                 blkmap = NULL;
2655         }

find_inode() checks a list created by the "-i <ino #>" command line
option, so will always return NULL for this test case. Most of the checks
do this:

2657                 if (!sflag || isfree || id->ilist || CHECK_BLIST(bno))

sflag is set by the "-s" command line option, which is why this
problem requires that to be set - the output checks don't get past
this otherwise.

isfree is a parameter passed into to say whether the inode is
allocated or not. The code hence assumes that if !isfree, then id !=
NULL, which is certainly not the case. Hence it can blow up if id =
NULL.

The line it crashed on:

2670         if (isfree) {
2671                 if (idic.di_nblocks != 0) {
2672  >>>>>>                 if (!sflag || id->ilist || CHECK_BLIST(bno))

Looks like a clear case of copy-n-paste error - if isfree is set, the
id _must_ be null and we go kaboom.

It looks like none of the code in this function actually checks for
whether id is valid or not after find_inode and dereferencing the
reurn pointer.

The patch below should fix the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

---
 db/check.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/db/check.c b/db/check.c
index 7620d9c..e0dcf63 100644
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
+	if (verbose || v)
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
