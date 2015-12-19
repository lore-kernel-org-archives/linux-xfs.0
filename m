Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DFA329E2A
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:09:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 343178F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:08 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id tsUd9RFqSlkVboFv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:09:06 -0800 (PST)
Subject: [PATCH 37/53] xfs_mkfs: initialize extra fields during mkfs, add docs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:09:03 -0800
Message-ID: <20151219090903.14255.92155.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Document the rmapbt options to mkfs, and initialize the
extra field we added.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man8/mkfs.xfs.8 |   20 ++++++++++++++++++++
 mkfs/xfs_mkfs.c     |    7 ++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)


diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 1fe510b..ffef906 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -173,6 +173,26 @@ is used, the free inode btree feature is not supported and is disabled.
 .BI uuid= value
 Use the given value as the filesystem UUID for the newly created filesystem.
 The default is to generate a random UUID.
+.TP
+.BI rmapbt= value
+This option enables the creation of a reverse-mapping btree index in each
+allocation group.  THe value is either 0 to disable the feature, or 1 to
+create the btree.
+.IP
+The reverse mapping btree maps filesystem blocks to the owner of the
+filesystem block.  Most of the mappings will be to an inode number and an
+offset, though there will also be mappings to filesystem metadata.  This
+secondary metadata can be used to validate the primary metadata or to
+pinpoint exactly which data has been lost when a disk error occurs.
+.IP
+By default,
+.B mkfs.xfs
+will not create reverse mapping btrees.  This feature is only available
+for filesystems created with the (default)
+.B \-m crc=1
+option set. When the option
+.B \-m crc=0
+is used, the reverse mapping btree feature is not supported and is disabled.
 .RE
 .TP
 .BI \-d " data_section_options"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b2b087f..15a3866 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3016,6 +3016,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_startblock = 0;
 			rrec->rm_blockcount = cpu_to_be32(XFS_BNO_BLOCK(mp));
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_FS);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account freespace btree root blocks */
@@ -3023,6 +3024,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
 			rrec->rm_blockcount = cpu_to_be32(2);
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account inode btree root blocks */
@@ -3031,6 +3033,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
 							XFS_IBT_BLOCK(mp));
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account for rmap btree root */
@@ -3038,6 +3041,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
 			rrec->rm_blockcount = cpu_to_be32(1);
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account for the log space */
@@ -3047,6 +3051,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 						XFS_FSB_TO_AGBNO(mp, logstart));
 				rrec->rm_blockcount = cpu_to_be32(logblocks);
 				rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
+				rrec->rm_offset = 0;
 				be16_add_cpu(&block->bb_numrecs, 1);
 			}
 
@@ -3290,7 +3295,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b log=n|size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectlog=n|sectsize=num\n\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
