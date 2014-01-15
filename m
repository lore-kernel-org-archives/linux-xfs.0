Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 19F7929E19
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E55F8F8037
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:53 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0UsdT003648
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:54 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000852.319706063@sgi.com>
Date: Wed, 15 Jan 2014 16:00:25 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 13/17] xfsprogs: add parent pointer support into Linux 3.10
	inode 3
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=01-xfsprogs-add-parent-pointers.patch
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

Add parent pointer support into the inode version 3 (CRC inode).
Make changes to mkfs.xfs to enable parent pointers using the
"-i parent=1" option.

---
 include/xfs_dinode.h     |    4 +++-
 include/xfs_log_format.h |    4 +++-
 include/xfs_sb.h         |   14 ++++++++++++--
 libxfs/xfs_ialloc.c      |   12 ++++++++++++
 man/man8/mkfs.xfs.8      |    6 ++++++
 mkfs/xfs_mkfs.c          |   24 +++++++++++++++++++-----
 6 files changed, 55 insertions(+), 9 deletions(-)

Index: b/include/xfs_dinode.h
===================================================================
--- a/include/xfs_dinode.h
+++ b/include/xfs_dinode.h
@@ -79,7 +79,9 @@ typedef struct xfs_dinode {
 	__be64		di_changecount;	/* number of attribute changes */
 	__be64		di_lsn;		/* flush sequence */
 	__be64		di_flags2;	/* more random flags */
-	__u8		di_pad2[16];	/* more padding for future expansion */
+	__be64		di_parent;	/* parent directory inode */
+	__be32		di_poffset;	/* offset into parent directory */
+	__u8		di_pad2[4];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_timestamp_t	di_crtime;	/* time created */
Index: b/include/xfs_log_format.h
===================================================================
--- a/include/xfs_log_format.h
+++ b/include/xfs_log_format.h
@@ -567,7 +567,9 @@ typedef struct xfs_icdinode {
 	__uint64_t	di_changecount;	/* number of attribute changes */
 	xfs_lsn_t	di_lsn;		/* flush sequence */
 	__uint64_t	di_flags2;	/* more random flags */
-	__uint8_t	di_pad2[16];	/* more padding for future expansion */
+	__uint64_t	di_parent;	/* parent directory inode */
+	__uint32_t	di_poffset;	/* offset into parent directory */
+	__uint8_t	di_pad2[4];	/* more padding for future expansion */
 
 	/* fields only written to during inode creation */
 	xfs_ictimestamp_t di_crtime;	/* time created */
Index: b/include/xfs_sb.h
===================================================================
--- a/include/xfs_sb.h
+++ b/include/xfs_sb.h
@@ -90,6 +90,7 @@ struct xfs_trans;
 	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
 	 XFS_SB_VERSION2_ATTR2BIT	| \
 	 XFS_SB_VERSION2_PROJID32BIT	| \
+	 XFS_SB_VERSION2_PARENTBIT	| \
 	 XFS_SB_VERSION2_FTYPE)
 #define	XFS_SB_VERSION2_OKSASHFBITS	\
 	(0)
@@ -328,7 +329,6 @@ typedef enum {
 	 XFS_SB_FEATURES_RO_COMPAT | XFS_SB_FEATURES_INCOMPAT | \
 	 XFS_SB_FEATURES_LOG_INCOMPAT | XFS_SB_PQUOTINO)
 
-
 /*
  * Misc. Flags - warning - these will be cleared by xfs_repair unless
  * a feature bit is set when the flag is used.
@@ -596,8 +596,10 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_PARENT	(2 << 0)	/* parent inode ptrs */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE)
+		(XFS_SB_FEAT_INCOMPAT_FTYPE | \
+		 XFS_SB_FEAT_INCOMPAT_PARENT)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -639,6 +641,14 @@ static inline int xfs_sb_version_hasftyp
 		 (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE));
 }
 
+static inline int xfs_sb_version_hasparent(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_PARENT)) ||
+		(xfs_sb_version_hasmorebits(sbp) &&
+		(sbp->sb_features2 & XFS_SB_VERSION2_PARENTBIT));
+}
+
 /*
  * end of superblock version macros
  */
Index: b/libxfs/xfs_ialloc.c
===================================================================
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -233,6 +233,18 @@ xfs_ialloc_inode_init(
 			free->di_next_unlinked = cpu_to_be32(NULLAGINO);
 
 			if (version == 3) {
+				if (xfs_sb_version_hasparent(&mp->m_sb) &&
+					   (mp->m_sb.sb_rootino == NULLFSINO ||
+					    mp->m_sb.sb_rootino == ino)) {
+					/*
+					 * set the parent pointer information
+					 * in the root inode.
+					 */
+					free->di_parent = cpu_to_be64(ino);
+					free->di_poffset =
+					    cpu_to_be32(xfs_dir3_data_dotdot_offset(mp)
+						    >> XFS_DIR2_DATA_ALIGN_LOG);
+				}
 				free->di_ino = cpu_to_be64(ino);
 				ino++;
 				uuid_copy(&free->di_uuid, &mp->m_sb.sb_uuid);
Index: b/man/man8/mkfs.xfs.8
===================================================================
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -364,6 +364,12 @@ This is used to enable 32bit quota proje
 is either 0 or 1, with 1 signifying that 32bit projid are to be enabled.
 If the value is omitted, 1 is assumed.  (This default changed
 in release version 3.2.0.)
+.TP
+.BI parent[= value ]
+This is used to enable parent inode pointers in CRC enabled filesystems. The
+.I value
+is either 0 or 1, with 1 signifying that parent inode pointers are to be enabled.
+If the value is omitted, 0 is assumed.
 .RE
 .TP
 .BI \-l " log_section_options"
Index: b/mkfs/xfs_mkfs.c
===================================================================
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -109,6 +109,8 @@ char	*iopts[] = {
 	"attr",
 #define	I_PROJID32BIT	6
 	"projid32bit",
+#define	I_PARENT	7
+	"parent",
 	NULL
 };
 
@@ -149,7 +151,7 @@ char	*nopts[] = {
 	"version",
 #define	N_FTYPE		3
 	"ftype",
-	NULL,
+	NULL
 };
 
 char	*ropts[] = {
@@ -962,6 +964,7 @@ main(
 	struct fs_topology	ft;
 	int			lazy_sb_counters;
 	int			crcs_enabled;
+	int			parent;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -995,6 +998,7 @@ main(
 	worst_freelist = 0;
 	lazy_sb_counters = 1;
 	crcs_enabled = 0;
+	parent = 0;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
@@ -1316,6 +1320,14 @@ main(
 						illegal(value, "i projid32bit");
 					projid16bit = c ? 0 : 1;
 					break;
+				case I_PARENT:
+					if (!value || *value == '\0')
+						value = "0";
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "i parent");
+					parent = c;
+					break;
 				default:
 					unknown('i', value);
 				}
@@ -2463,12 +2475,14 @@ _("size %s specified for log subvolume i
 	if (crcs_enabled) {
 		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
 		dirftype = 1;
-	}
+		if (parent)
+			sbp->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_PARENT;
+	 }
 
 	if (!qflag || Nflag) {
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
-		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
+		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u, parent=%d\n"
 		   "         =%-22s crc=%u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
@@ -2477,7 +2491,7 @@ _("size %s specified for log subvolume i
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
-			"", sectorsize, attrversion, !projid16bit,
+			"", sectorsize, attrversion, !projid16bit, parent,
 			"", crcs_enabled,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
@@ -3085,7 +3099,7 @@ usage( void )
 			    sectlog=n|sectsize=num\n\
 /* force overwrite */	[-f]\n\
 /* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
-			    projid32bit=0|1]\n\
+			    projid32bit=0|1,parent==0|1]\n\
 /* no discard */	[-K]\n\
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectlog=n|sectsize=num,\n\


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
