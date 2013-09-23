Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B16429DFB
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 22:34:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0D003AC003
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 20:34:29 -0700 (PDT)
Received: from e28smtp05.in.ibm.com (e28smtp05.in.ibm.com [122.248.162.5]) by
	cuda.sgi.com with ESMTP id 1GGmIMMmd8Jm0MyF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 20:34:24 -0700 (PDT)
Received: from /spool/local
	by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Mon, 23 Sep 2013 09:04:20 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id BE7FB1258051
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 09:04:29 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8N3aZD441091274
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 09:06:35 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8N3YIum008823 for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 09:04:18 +0530
Message-ID: <1379907255.3246.4.camel@ThinkPad-T5421>
Subject: [RFC PATCH] xfsprogs: add hex offset for superblock structure
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Mon, 23 Sep 2013 11:34:15 +0800
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfsprogs <xfs@oss.sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

It would be a little bit easier if somebody uses something like hexdump 
to check the superblock of one device.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 include/xfs_sb.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/xfs_sb.h b/include/xfs_sb.h
index c8d8898..bb9e2df 100644
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -185,27 +185,27 @@ typedef struct xfs_sb {
  * Must be padded to 64 bit alignment.
  */
 typedef struct xfs_dsb {
-	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
+/*00*/	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
 	__be32		sb_blocksize;	/* logical block size, bytes */
 	__be64		sb_dblocks;	/* number of data blocks */
-	__be64		sb_rblocks;	/* number of realtime blocks */
+/*10*/	__be64		sb_rblocks;	/* number of realtime blocks */
 	__be64		sb_rextents;	/* number of realtime extents */
-	uuid_t		sb_uuid;	/* file system unique id */
-	__be64		sb_logstart;	/* starting block of log if internal */
+/*20*/	uuid_t		sb_uuid;	/* file system unique id */
+/*30*/	__be64		sb_logstart;	/* starting block of log if internal */
 	__be64		sb_rootino;	/* root inode number */
-	__be64		sb_rbmino;	/* bitmap inode for realtime extents */
+/*40*/	__be64		sb_rbmino;	/* bitmap inode for realtime extents */
 	__be64		sb_rsumino;	/* summary inode for rt bitmap */
-	__be32		sb_rextsize;	/* realtime extent size, blocks */
+/*50*/	__be32		sb_rextsize;	/* realtime extent size, blocks */
 	__be32		sb_agblocks;	/* size of an allocation group */
 	__be32		sb_agcount;	/* number of allocation groups */
 	__be32		sb_rbmblocks;	/* number of rt bitmap blocks */
-	__be32		sb_logblocks;	/* number of log blocks */
+/*60*/	__be32		sb_logblocks;	/* number of log blocks */
 	__be16		sb_versionnum;	/* header version == XFS_SB_VERSION */
 	__be16		sb_sectsize;	/* volume sector size, bytes */
 	__be16		sb_inodesize;	/* inode size, bytes */
 	__be16		sb_inopblock;	/* inodes per block */
-	char		sb_fname[12];	/* file system name */
-	__u8		sb_blocklog;	/* log2 of sb_blocksize */
+/*6C*/	char		sb_fname[12];	/* file system name */
+/*78*/	__u8		sb_blocklog;	/* log2 of sb_blocksize */
 	__u8		sb_sectlog;	/* log2 of sb_sectsize */
 	__u8		sb_inodelog;	/* log2 of sb_inodesize */
 	__u8		sb_inopblog;	/* log2 of sb_inopblock */
@@ -219,22 +219,22 @@ typedef struct xfs_dsb {
 	 * want to change their layout, make sure you fix the
 	 * code in xfs_trans_apply_sb_deltas().
 	 */
-	__be64		sb_icount;	/* allocated inodes */
+/*80*/	__be64		sb_icount;	/* allocated inodes */
 	__be64		sb_ifree;	/* free inodes */
-	__be64		sb_fdblocks;	/* free data blocks */
+/*90*/	__be64		sb_fdblocks;	/* free data blocks */
 	__be64		sb_frextents;	/* free realtime extents */
 	/*
 	 * End contiguous fields.
 	 */
-	__be64		sb_uquotino;	/* user quota inode */
+/*A0*/	__be64		sb_uquotino;	/* user quota inode */
 	__be64		sb_gquotino;	/* group quota inode */
-	__be16		sb_qflags;	/* quota flags */
+/*B0*/	__be16		sb_qflags;	/* quota flags */
 	__u8		sb_flags;	/* misc. flags */
 	__u8		sb_shared_vn;	/* shared version number */
 	__be32		sb_inoalignmt;	/* inode chunk alignment, fsblocks */
 	__be32		sb_unit;	/* stripe or raid unit */
 	__be32		sb_width;	/* stripe or raid width */
-	__u8		sb_dirblklog;	/* log2 of dir block size (fsbs) */
+/*C0*/	__u8		sb_dirblklog;	/* log2 of dir block size (fsbs) */
 	__u8		sb_logsectlog;	/* log2 of the log sector size */
 	__be16		sb_logsectsize;	/* sector size for the log, bytes */
 	__be32		sb_logsunit;	/* stripe unit size for the log */
@@ -250,16 +250,16 @@ typedef struct xfs_dsb {
 	/* version 5 superblock fields start here */
 
 	/* feature masks */
-	__be32		sb_features_compat;
+/*D0*/	__be32		sb_features_compat;
 	__be32		sb_features_ro_compat;
 	__be32		sb_features_incompat;
 	__be32		sb_features_log_incompat;
 
-	__le32		sb_crc;		/* superblock crc */
+/*E0*/	__le32		sb_crc;		/* superblock crc */
 	__be32		sb_pad;
 
 	__be64		sb_pquotino;	/* project quota inode */
-	__be64		sb_lsn;		/* last write sequence */
+/*F0*/	__be64		sb_lsn;		/* last write sequence */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
-- 
1.8.1.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
