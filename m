Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC2E27F54
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 609DCAC005
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:25 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	1DWzUrPLEuNHhOOJ for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004m2-R4
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-00014c-QB
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 11/15] xfs: move v1 inode conversion to xfs_inode_from_disk
Date: Wed, 17 Feb 2016 18:20:48 +1100
Message-Id: <1455693652-3899-12-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit faeb4e4715be017e88e630bda84477afc1dff38b

So we don't have to carry an di_onlink variable around anymore, move
the inode conversion from v1 inode format to v2 inode format into
xfs_inode_from_disk(). This means we can remove the di_onlink fields
from the struct xfs_icdinode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 db/check.c               | 19 ++++++-------------
 libxfs/util.c            |  1 -
 libxfs/xfs_inode_buf.c   | 41 ++++++++++++++++++++---------------------
 libxfs/xfs_inode_buf.h   |  1 -
 libxfs/xfs_log_format.h  |  2 +-
 logprint/log_print_all.c |  5 ++---
 6 files changed, 29 insertions(+), 40 deletions(-)

diff --git a/db/check.c b/db/check.c
index 95a68d4..412ab3d 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2623,7 +2623,6 @@ process_inode(
 	inodata_t		*id = NULL;
 	xfs_ino_t		ino;
 	xfs_extnum_t		nextents = 0;
-	int			nlink;
 	int			security;
 	xfs_rfsblock_t		totblocks;
 	xfs_rfsblock_t		totdblocks = 0;
@@ -2694,14 +2693,10 @@ process_inode(
 					xino.i_d.di_nblocks, ino);
 			error++;
 		}
-		if (xino.i_d.di_version == 1)
-			nlink = xino.i_d.di_onlink;
-		else
-			nlink = xino.i_d.di_nlink;
-		if (nlink != 0) {
+		if (dip->di_nlink != 0) {
 			if (v)
 				dbprintf(_("bad nlink %d for free inode %lld\n"),
-					nlink, ino);
+					be32_to_cpu(dip->di_nlink), ino);
 			error++;
 		}
 		if (xino.i_d.di_mode != 0) {
@@ -2801,12 +2796,10 @@ process_inode(
 		type = DBM_UNKNOWN;
 		break;
 	}
-	if (xino.i_d.di_version == 1)
-		setlink_inode(id, xino.i_d.di_onlink, type == DBM_DIR, security);
-	else {
-		sbversion |= XFS_SB_VERSION_NLINKBIT;
-		setlink_inode(id, xino.i_d.di_nlink, type == DBM_DIR, security);
-	}
+
+	sbversion |= XFS_SB_VERSION_NLINKBIT;
+	setlink_inode(id, be32_to_cpu(dip->di_nlink), type == DBM_DIR, security);
+
 	switch (xino.i_d.di_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		process_lclinode(id, dip, type, &totdblocks, &totiblocks,
diff --git a/libxfs/util.c b/libxfs/util.c
index a893c3a..bbaf790 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -218,7 +218,6 @@ libxfs_ialloc(
 	ASSERT(ip != NULL);
 
 	ip->i_d.di_mode = (__uint16_t)mode;
-	ip->i_d.di_onlink = 0;
 	ip->i_d.di_nlink = nlink;
 	ASSERT(ip->i_d.di_nlink == nlink);
 	ip->i_d.di_uid = cr->cr_uid;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index 5a7a118..66a827a 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -213,13 +213,25 @@ xfs_inode_from_disk(
 
 	to->di_mode = be16_to_cpu(from->di_mode);
 	to->di_version = from ->di_version;
+
+	/*
+	 * Convert v1 inodes immediately to v2 inode format as this is the
+	 * minimum inode version format we support in the rest of the code.
+	 */
+	if (to->di_version == 1) {
+		to->di_nlink = be16_to_cpu(from->di_onlink);
+		to->di_projid_lo = 0;
+		to->di_projid_hi = 0;
+		to->di_version = 2;
+	} else {
+		to->di_nlink = be32_to_cpu(from->di_nlink);
+		to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
+		to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
+	}
+
 	to->di_format = from->di_format;
-	to->di_onlink = be16_to_cpu(from->di_onlink);
 	to->di_uid = be32_to_cpu(from->di_uid);
 	to->di_gid = be32_to_cpu(from->di_gid);
-	to->di_nlink = be32_to_cpu(from->di_nlink);
-	to->di_projid_lo = be16_to_cpu(from->di_projid_lo);
-	to->di_projid_hi = be16_to_cpu(from->di_projid_hi);
 	to->di_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
@@ -265,11 +277,11 @@ xfs_inode_to_disk(
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
+	to->di_onlink = 0;
 
 	to->di_mode = cpu_to_be16(from->di_mode);
 	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_onlink = cpu_to_be16(from->di_onlink);
 	to->di_uid = cpu_to_be32(from->di_uid);
 	to->di_gid = cpu_to_be32(from->di_gid);
 	to->di_nlink = cpu_to_be32(from->di_nlink);
@@ -319,9 +331,9 @@ xfs_log_dinode_to_disk(
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
 	to->di_mode = cpu_to_be16(from->di_mode);
-	to->di_version = from ->di_version;
+	to->di_version = from->di_version;
 	to->di_format = from->di_format;
-	to->di_onlink = cpu_to_be16(from->di_onlink);
+	to->di_onlink = 0;
 	to->di_uid = cpu_to_be32(from->di_uid);
 	to->di_gid = cpu_to_be32(from->di_gid);
 	to->di_nlink = cpu_to_be32(from->di_nlink);
@@ -501,20 +513,7 @@ xfs_iread(
 		ip->i_d.di_mode = 0;
 	}
 
-	/*
-	 * Automatically convert version 1 inode formats in memory to version 2
-	 * inode format. If the inode is modified, it will get logged and
-	 * rewritten as a version 2 inode. We can do this because we set the
-	 * superblock feature bit for v2 inodes unconditionally during mount
-	 * and it means the reast of the code can assume the inode version is 2
-	 * or higher.
-	 */
-	if (ip->i_d.di_version == 1) {
-		ip->i_d.di_version = 2;
-		ip->i_d.di_nlink = ip->i_d.di_onlink;
-		ip->i_d.di_onlink = 0;
-		xfs_set_projid(&ip->i_d, 0);
-	}
+	ASSERT(ip->i_d.di_version >= 2);
 
 	ip->i_delayed_blks = 0;
 
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 974d060..489b96e 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -31,7 +31,6 @@ struct xfs_icdinode {
 	__uint16_t	di_mode;	/* mode and type of file */
 	__int8_t	di_version;	/* inode version */
 	__int8_t	di_format;	/* format of di_c data */
-	__uint16_t	di_onlink;	/* old number of links to file */
 	__uint16_t	di_flushiter;	/* incremented on flush */
 	__uint32_t	di_uid;		/* owner's user id */
 	__uint32_t	di_gid;		/* owner's group id */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 85d4732..40005bf 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -369,7 +369,7 @@ struct xfs_log_dinode {
 	__uint16_t	di_mode;	/* mode and type of file */
 	__int8_t	di_version;	/* inode version */
 	__int8_t	di_format;	/* format of di_c data */
-	__uint16_t	di_onlink;	/* old number of links to file */
+	__uint8_t	di_pad3[2];	/* unused in v2/3 inodes */
 	__uint32_t	di_uid;		/* owner's user id */
 	__uint32_t	di_gid;		/* owner's group id */
 	__uint32_t	di_nlink;	/* number of links to file */
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index 1bc18af..f95f4aa 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -255,10 +255,9 @@ xlog_recover_print_inode_core(
 	printf(_("	CORE inode:\n"));
 	if (!print_inode)
 		return;
-	printf(_("		magic:%c%c  mode:0x%x  ver:%d  format:%d  "
-	     "onlink:%d\n"),
+	printf(_("		magic:%c%c  mode:0x%x  ver:%d  format:%d\n"),
 	       (di->di_magic>>8) & 0xff, di->di_magic & 0xff,
-	       di->di_mode, di->di_version, di->di_format, di->di_onlink);
+	       di->di_mode, di->di_version, di->di_format);
 	printf(_("		uid:%d  gid:%d  nlink:%d projid:0x%04x%04x\n"),
 	       di->di_uid, di->di_gid, di->di_nlink,
 	       di->di_projid_hi, di->di_projid_lo);
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
