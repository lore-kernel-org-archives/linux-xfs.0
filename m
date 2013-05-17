Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AFAF529E2F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 06:14:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B8B6AC006
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 04:14:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	niFvvhnbLHtPTNlc for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 04:14:13 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UdIbi-0008Sl-0d
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:54 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UdIbh-0005Fa-I8
	for xfs@oss.sgi.com; Fri, 17 May 2013 21:13:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 23/30] patch xfsprogs-mkfs-crc-support-2
Date: Fri, 17 May 2013 21:13:18 +1000
Message-Id: <1368789205-19969-24-git-send-email-david@fromorbit.com>
In-Reply-To: <1368789205-19969-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
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

---
 libxfs/xfs_mount.c   |   10 +++--
 libxfs/xfs_symlink.c |    4 +-
 mkfs/maxtrres.c      |    4 +-
 mkfs/xfs_mkfs.c      |  114 ++++++++++++++++++++++++++++++++++++++++----------
 mkfs/xfs_mkfs.h      |   12 +++---
 5 files changed, 111 insertions(+), 33 deletions(-)

diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c
index f66f63d..e7e7445 100644
--- a/libxfs/xfs_mount.c
+++ b/libxfs/xfs_mount.c
@@ -369,7 +369,8 @@ xfs_sb_to_disk(
 
 static int
 xfs_sb_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf	*bp,
+	bool		verbose)
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_sb	sb;
@@ -380,7 +381,8 @@ xfs_sb_verify(
 	 * Only check the in progress field for the primary superblock as
 	 * mkfs.xfs doesn't clear it from secondary superblocks.
 	 */
-	return xfs_mount_validate_sb(mp, &sb, bp->b_bn == XFS_SB_DADDR);
+	return xfs_mount_validate_sb(mp, &sb,
+				     verbose && bp->b_bn == XFS_SB_DADDR);
 }
 
 /*
@@ -413,7 +415,7 @@ xfs_sb_read_verify(
 			goto out_error;
 		}
 	}
-	error = xfs_sb_verify(bp);
+	error = xfs_sb_verify(bp, true);
 
 out_error:
 	if (error) {
@@ -452,7 +454,7 @@ xfs_sb_write_verify(
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 	int			error;
 
-	error = xfs_sb_verify(bp);
+	error = xfs_sb_verify(bp, false);
 	if (error) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, bp->b_addr);
 		xfs_buf_ioerror(bp, error);
diff --git a/libxfs/xfs_symlink.c b/libxfs/xfs_symlink.c
index e018abc..a3da965 100644
--- a/libxfs/xfs_symlink.c
+++ b/libxfs/xfs_symlink.c
@@ -27,9 +27,9 @@ xfs_symlink_blocks(
 }
 
 /*
- * XXX: this need to be used by mkfs/proto.c to create symlinks.
+ * This is used by mkfs/proto.c to create symlinks.
  */
-static int
+int
 xfs_symlink_hdr_set(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
index f12cc70..d571d77 100644
--- a/mkfs/maxtrres.c
+++ b/mkfs/maxtrres.c
@@ -67,6 +67,7 @@ max_trans_res_by_mount(
 
 int
 max_trans_res(
+	int		crcs_enabled,
 	int		dirversion,
 	int		sectorlog,
 	int		blocklog,
@@ -90,7 +91,8 @@ max_trans_res(
 	sbp->sb_inodesize = 1 << inodelog;
 	sbp->sb_inopblock = 1 << (blocklog - inodelog);
 	sbp->sb_dirblklog = dirblocklog - blocklog;
-	sbp->sb_versionnum = XFS_SB_VERSION_4 |
+	sbp->sb_versionnum =
+			(crcs_enabled ? XFS_SB_VERSION_5 : XFS_SB_VERSION_4) |
 			(dirversion == 2 ? XFS_SB_VERSION_DIRV2BIT : 0);
 
 	libxfs_mount(&mount, sbp, 0,0,0,0);
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3864932..291bab4 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -178,6 +178,12 @@ char	*sopts[] = {
 	NULL
 };
 
+char	*mopts[] = {
+#define	M_CRC		0
+	"crc",
+	NULL
+};
+
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((__uint64_t)(count) << (30 - (blog)))
 #define MEGABYTES(count, blog)	((__uint64_t)(count) << (20 - (blog)))
@@ -952,6 +958,7 @@ main(
 	libxfs_init_t		xi;
 	struct fs_topology	ft;
 	int			lazy_sb_counters;
+	int			crcs_enabled;
 
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
@@ -983,13 +990,14 @@ main(
 	force_overwrite = 0;
 	worst_freelist = 0;
 	lazy_sb_counters = 1;
+	crcs_enabled = 0;
 	memset(&fsx, 0, sizeof(fsx));
 
 	memset(&xi, 0, sizeof(xi));
 	xi.isdirect = LIBXFS_DIRECT;
 	xi.isreadonly = LIBXFS_EXCLUSIVELY;
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:n:KNp:qr:s:CfV")) != EOF) {
+	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
 		case 'C':
 		case 'f':
@@ -1455,6 +1463,25 @@ main(
 				illegal(optarg, "L");
 			label = optarg;
 			break;
+		case 'm':
+			p = optarg;
+			while (*p != '\0') {
+				char	*value;
+
+				switch (getsubopt(&p, (constpp)mopts, &value)) {
+				case M_CRC:
+					if (!value || *value == '\0')
+						reqval('m', mopts, M_CRC);
+					c = atoi(value);
+					if (c < 0 || c > 1)
+						illegal(value, "m crc");
+					crcs_enabled = c;
+					break;
+				default:
+					unknown('m', value);
+				}
+			}
+			break;
 		case 'n':
 			p = optarg;
 			while (*p != '\0') {
@@ -1774,9 +1801,17 @@ _("block size %d cannot be smaller than logical sector size %d\n"),
 		inodelog = blocklog - libxfs_highbit32(inopblock);
 		isize = 1 << inodelog;
 	} else if (!ilflag && !isflag) {
-		inodelog = XFS_DINODE_DFL_LOG;
+		inodelog = crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
+					: XFS_DINODE_DFL_LOG;
 		isize = 1 << inodelog;
 	}
+	if (crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+		fprintf(stderr,
+		_("Minimum inode size for CRCs is %d bytes\n"),
+			1 << XFS_DINODE_DFL_CRC_LOG);
+		usage();
+	}
+
 	if (xi.lisfile && (!logsize || !xi.logname)) {
 		fprintf(stderr,
 		_("if -l file then -l name and -l size are required\n"));
@@ -2025,7 +2060,7 @@ reported by the device (%u).\n"),
 			sectorsize, xi.rtbsize);
 	}
 
-	max_tr_res = max_trans_res(dirversion,
+	max_tr_res = max_trans_res(crcs_enabled, dirversion,
 				   sectorlog, blocklog, inodelog, dirblocklog);
 	ASSERT(max_tr_res);
 	min_logblocks = max_tr_res * XFS_MIN_LOG_FACTOR;
@@ -2295,7 +2330,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		 */
 		if (!logsize) {
 			logblocks = MIN(logblocks,
-					agsize - XFS_PREALLOC_BLOCKS(mp));
+					XFS_ALLOC_AG_MAX_USABLE(mp));
 		}
 		if (logblocks > agsize - XFS_PREALLOC_BLOCKS(mp)) {
 			fprintf(stderr,
@@ -2338,6 +2373,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		printf(_(
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
+		   "         =%-22s crc=%-5u\n"
 		   "data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
 		   "         =%-22s sunit=%-6u swidth=%u blks\n"
 		   "naming   =version %-14u bsize=%-6u ascii-ci=%d\n"
@@ -2346,6 +2382,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
 			dfile, isize, (long long)agcount, (long long)agsize,
 			"", sectorsize, attrversion, projid32bit,
+			"", crcs_enabled,
 			"", blocksize, (long long)dblocks, imaxpct,
 			"", dsunit, dswidth,
 			dirversion, dirblocksize, nci,
@@ -2411,9 +2448,10 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		sbp->sb_logsectlog = 0;
 		sbp->sb_logsectsize = 0;
 	}
-	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(lazy_sb_counters,
+	sbp->sb_features2 = XFS_SB_VERSION2_MKFS(crcs_enabled, lazy_sb_counters,
 					attrversion == 2, projid32bit == 1, 0);
-	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(iaflag, dsunit != 0,
+	sbp->sb_versionnum = XFS_SB_VERSION_MKFS(crcs_enabled, iaflag,
+					dsunit != 0,
 					logversion == 2, attrversion == 1,
 					(sectorsize != BBSIZE ||
 							lsectorsize != BBSIZE),
@@ -2494,6 +2532,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 * kernel/userspace header initialisation code the same.
 	 */
 	for (agno = 0; agno < agcount; agno++) {
+		struct xfs_agfl	*agfl;
+		int		bucket;
+
 		/*
 		 * Superblock.
 		 */
@@ -2530,6 +2571,9 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		nbmblocks = (xfs_extlen_t)(agsize - XFS_PREALLOC_BLOCKS(mp));
 		agf->agf_freeblks = cpu_to_be32(nbmblocks);
 		agf->agf_longest = cpu_to_be32(nbmblocks);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			platform_uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_uuid);
+
 		if (loginternal && agno == logagno) {
 			be32_add_cpu(&agf->agf_freeblks, -logblocks);
 			agf->agf_longest = cpu_to_be32(agsize -
@@ -2540,6 +2584,26 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 
 		/*
+		 * AG freelist header block
+		 */
+		buf = libxfs_getbuf(mp->m_ddev_targp,
+				XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
+				XFS_FSS_TO_BB(mp, 1));
+		buf->b_ops = &xfs_agfl_buf_ops;
+		agfl = XFS_BUF_TO_AGFL(buf);
+		/* setting to 0xff results in initialisation to NULLAGBLOCK */
+		memset(agfl, 0xff, sectorsize);
+		if (xfs_sb_version_hascrc(&mp->m_sb)) {
+			agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
+			agfl->agfl_seqno = cpu_to_be32(agno);
+			platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_uuid);
+			for (bucket = 0; bucket < XFS_AGFL_SIZE(mp); bucket++)
+				agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
+		}
+
+		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+
+		/*
 		 * AG header block: inodes
 		 */
 		buf = libxfs_getbuf(mp->m_ddev_targp,
@@ -2558,6 +2622,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		agi->agi_freecount = 0;
 		agi->agi_newino = cpu_to_be32(NULLAGINO);
 		agi->agi_dirino = cpu_to_be32(NULLAGINO);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			platform_uuid_copy(&agi->agi_uuid, &mp->m_sb.sb_uuid);
 		for (c = 0; c < XFS_AGI_UNLINKED_BUCKETS; c++)
 			agi->agi_unlinked[c] = cpu_to_be32(NULLAGINO);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
@@ -2571,11 +2637,13 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		buf->b_ops = &xfs_allocbt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
-		block->bb_magic = cpu_to_be32(XFS_ABTB_MAGIC);
-		block->bb_level = 0;
-		block->bb_numrecs = cpu_to_be16(1);
-		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, buf, XFS_ABTB_CRC_MAGIC, 0, 1,
+						agno, XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, buf, XFS_ABTB_MAGIC, 0, 1,
+						agno, 0);
+
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		if (loginternal && agno == logagno) {
@@ -2624,11 +2692,13 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		buf->b_ops = &xfs_allocbt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
-		block->bb_magic = cpu_to_be32(XFS_ABTC_MAGIC);
-		block->bb_level = 0;
-		block->bb_numrecs = cpu_to_be16(1);
-		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, buf, XFS_ABTC_CRC_MAGIC, 0, 1,
+						agno, XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, buf, XFS_ABTC_MAGIC, 0, 1,
+						agno, 0);
+
 		arec = XFS_ALLOC_REC_ADDR(mp, block, 1);
 		arec->ar_startblock = cpu_to_be32(XFS_PREALLOC_BLOCKS(mp));
 		if (loginternal && agno == logagno) {
@@ -2667,11 +2737,12 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 		buf->b_ops = &xfs_inobt_buf_ops;
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, blocksize);
-		block->bb_magic = cpu_to_be32(XFS_IBT_MAGIC);
-		block->bb_level = 0;
-		block->bb_numrecs = 0;
-		block->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
-		block->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
+		if (xfs_sb_version_hascrc(&mp->m_sb))
+			xfs_btree_init_block(mp, buf, XFS_IBT_CRC_MAGIC, 0, 0,
+						agno, XFS_BTREE_CRC_BLOCKS);
+		else
+			xfs_btree_init_block(mp, buf, XFS_IBT_MAGIC, 0, 0,
+						agno, 0);
 		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
 	}
 
@@ -2908,6 +2979,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b log=n|size=num]\n\
+/* metadata */		[-m crc=[0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num),\n\
 			    sectlog=n|sectsize=num\n\
diff --git a/mkfs/xfs_mkfs.h b/mkfs/xfs_mkfs.h
index f25a7f3..d10e444 100644
--- a/mkfs/xfs_mkfs.h
+++ b/mkfs/xfs_mkfs.h
@@ -23,9 +23,9 @@
                  XFS_SB_VERSION_EXTFLGBIT | \
                  XFS_SB_VERSION_DIRV2BIT)
 
-#define XFS_SB_VERSION_MKFS(ia,dia,log2,attr1,sflag,ci,more) (\
-	((ia)||(dia)||(log2)||(attr1)||(sflag)||(ci)||(more)) ? \
-	( XFS_SB_VERSION_4 |						\
+#define XFS_SB_VERSION_MKFS(crc,ia,dia,log2,attr1,sflag,ci,more) (\
+	((crc)||(ia)||(dia)||(log2)||(attr1)||(sflag)||(ci)||(more)) ? \
+	(((crc) ? XFS_SB_VERSION_5 : XFS_SB_VERSION_4) |		\
 		((ia) ? XFS_SB_VERSION_ALIGNBIT : 0) |			\
 		((dia) ? XFS_SB_VERSION_DALIGNBIT : 0) |		\
 		((log2) ? XFS_SB_VERSION_LOGV2BIT : 0) |		\
@@ -36,15 +36,17 @@
 	        XFS_DFL_SB_VERSION_BITS |                               \
 	0 ) : XFS_SB_VERSION_1 )
 
-#define XFS_SB_VERSION2_MKFS(lazycount, attr2, projid32bit, parent) (\
+#define XFS_SB_VERSION2_MKFS(crc, lazycount, attr2, projid32bit, parent) (\
 	((lazycount) ? XFS_SB_VERSION2_LAZYSBCOUNTBIT : 0) |		\
 	((attr2) ? XFS_SB_VERSION2_ATTR2BIT : 0) |			\
 	((projid32bit) ? XFS_SB_VERSION2_PROJID32BIT : 0) |		\
 	((parent) ? XFS_SB_VERSION2_PARENTBIT : 0) |			\
+	((crc) ? XFS_SB_VERSION2_CRCBIT : 0) |				\
 	0 )
 
 #define	XFS_DFL_BLOCKSIZE_LOG	12		/* 4096 byte blocks */
 #define	XFS_DINODE_DFL_LOG	8		/* 256 byte inodes */
+#define	XFS_DINODE_DFL_CRC_LOG	9		/* 512 byte inodes for CRCs */
 #define	XFS_MIN_DATA_BLOCKS	100
 #define	XFS_MIN_INODE_PERBLOCK	2		/* min inodes per block */
 #define	XFS_DFL_IMAXIMUM_PCT	25		/* max % of space for inodes */
@@ -79,7 +81,7 @@ extern void parse_proto (xfs_mount_t *mp, struct fsxattr *fsx, char **pp);
 extern void res_failed (int err);
 
 /* maxtrres.c */
-extern int max_trans_res (int dirversion,
+extern int max_trans_res (int crcs_enabled, int dirversion,
 		int sectorlog, int blocklog, int inodelog, int dirblocklog);
 
 #endif	/* __XFS_MKFS_H__ */
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
