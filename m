Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163251AbdDWSzS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 Apr 2017 14:55:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D82E6C059729
        for <linux-xfs@vger.kernel.org>; Sun, 23 Apr 2017 18:55:17 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 09/12] mkfs: replace variables with opts table: -i options
Date: Sun, 23 Apr 2017 20:55:00 +0200
Message-Id: <20170423185503.31415-10-jtulak@redhat.com>
In-Reply-To: <20170423185503.31415-1-jtulak@redhat.com>
References: <20170423185503.31415-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Remove variables that can be replaced with a direct access to the opts table,
so we have it all in a single place, acessible from anywhere.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 86 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6857c30..a5e7c7e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1499,13 +1499,9 @@ main(
 	bool			force_overwrite;
 	struct fsxattr		fsx;
 	bool			ilflag;
-	uint64_t		imaxpct;
 	bool			imflag;
-	uint64_t		inodelog;
-	uint64_t		inopblock;
 	bool			ipflag;
 	bool			isflag;
-	uint64_t		isize;
 	char			*label = NULL;
 	bool			laflag;
 	uint64_t		lalign;
@@ -1591,7 +1587,6 @@ main(
 	Nflag = nlflag = nsflag = nvflag = false;
 	dirblocklog = dirblocksize = 0;
 	qflag = false;
-	imaxpct = inodelog = inopblock = isize = 0;
 	dfile = logfile = rtfile = NULL;
 	protofile = NULL;
 	rtbytes = rtextbytes = logbytes = 0;
@@ -1767,6 +1762,7 @@ main(
 				char	**subopts =
 						(char **)opts[OPT_I].subopts;
 				char	*value;
+				uint64_t tmp;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case I_ALIGN:
@@ -1775,30 +1771,26 @@ main(
 							       value);
 					break;
 				case I_LOG:
-					inodelog = parse_conf_val(OPT_I, I_LOG,
-								  value);
-					isize = 1 << inodelog;
+					tmp = parse_conf_val(OPT_I, I_LOG,
+							     value);
+					set_conf_val(OPT_I, I_SIZE, 1 << tmp);
 					ilflag = 1;
-					set_conf_val(OPT_I, I_SIZE, isize);
 					break;
 				case I_MAXPCT:
-					imaxpct = parse_conf_val(OPT_I,
-								 I_MAXPCT,
-								 value);
+					parse_conf_val(OPT_I, I_MAXPCT, value);
 					imflag = 1;
 					break;
 				case I_PERBLOCK:
-					inopblock = parse_conf_val(OPT_I,
-								   I_PERBLOCK,
-								   value);
+					parse_conf_val(OPT_I, I_PERBLOCK,
+						       value);
 					ipflag = 1;
 					break;
 				case I_SIZE:
-					isize = parse_conf_val(OPT_I, I_SIZE,
+					tmp = parse_conf_val(OPT_I, I_SIZE,
 							       value);
-					inodelog = libxfs_highbit32(isize);
+					set_conf_val(OPT_I, I_LOG,
+						     libxfs_highbit32(tmp));
 					isflag = 1;
-					set_conf_val(OPT_I, I_LOG, inodelog);
 					break;
 				case I_ATTR:
 					sb_feat.attr_version =
@@ -2289,7 +2281,8 @@ _("block size %"PRIu64" cannot be smaller than logical sector size %d\n"),
 	 */
 	if (sb_feat.crcs_enabled) {
 		/* minimum inode size is 512 bytes, ipflag checked later */
-		if ((isflag || ilflag) && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+		if ((isflag || ilflag) &&
+		    get_conf_val(OPT_I, I_LOG) < XFS_DINODE_DFL_CRC_LOG) {
 			fprintf(stderr,
 _("Minimum inode size for CRCs is %d bytes\n"),
 				1 << XFS_DINODE_DFL_CRC_LOG);
@@ -2413,15 +2406,17 @@ _("rmapbt not supported with realtime devices\n"));
 					   get_conf_val(OPT_B, B_LOG)));
 	}
 	if (ipflag) {
-		inodelog = get_conf_val(OPT_B, B_LOG) -
-			libxfs_highbit32(inopblock);
-		isize = 1 << inodelog;
+		set_conf_val(OPT_I, I_LOG, get_conf_val(OPT_B, B_LOG) -
+			libxfs_highbit32(get_conf_val(OPT_I, I_PERBLOCK)));
+		set_conf_val(OPT_I, I_SIZE, 1 << get_conf_val(OPT_I, I_LOG));
 	} else if (!ilflag && !isflag) {
-		inodelog = sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
-						: XFS_DINODE_DFL_LOG;
-		isize = 1 << inodelog;
+		set_conf_val(OPT_I, I_LOG,
+			     sb_feat.crcs_enabled ? XFS_DINODE_DFL_CRC_LOG
+						: XFS_DINODE_DFL_LOG);
+		set_conf_val(OPT_I, I_SIZE, 1 << get_conf_val(OPT_I, I_LOG));
 	}
-	if (sb_feat.crcs_enabled && inodelog < XFS_DINODE_DFL_CRC_LOG) {
+	if (sb_feat.crcs_enabled && get_conf_val(OPT_I, I_LOG) <
+	    XFS_DINODE_DFL_CRC_LOG) {
 		fprintf(stderr,
 		_("Minimum inode size for CRCs is %d bytes\n"),
 			1 << XFS_DINODE_DFL_CRC_LOG);
@@ -2508,12 +2503,14 @@ _("rmapbt not supported with realtime devices\n"));
 	/*
 	 * Check some argument sizes against mins, maxes.
 	 */
-	if (isize > get_conf_val(OPT_B, B_SIZE) / XFS_MIN_INODE_PERBLOCK ||
-	    isize < XFS_DINODE_MIN_SIZE ||
-	    isize > XFS_DINODE_MAX_SIZE) {
+	if (get_conf_val(OPT_I, I_SIZE) >
+	    get_conf_val(OPT_B, B_SIZE) / XFS_MIN_INODE_PERBLOCK ||
+	    get_conf_val(OPT_I, I_SIZE) < XFS_DINODE_MIN_SIZE ||
+	    get_conf_val(OPT_I, I_SIZE) > XFS_DINODE_MAX_SIZE) {
 		int	maxsz;
 
-		fprintf(stderr, _("illegal inode size %"PRIu64"\n"), isize);
+		fprintf(stderr, _("illegal inode size %"PRIu64"\n"),
+			get_conf_val(OPT_I, I_SIZE));
 		maxsz = MIN(get_conf_val(OPT_B, B_SIZE) /
 			    XFS_MIN_INODE_PERBLOCK,
 			    XFS_DINODE_MAX_SIZE);
@@ -2919,8 +2916,9 @@ an AG size that is one stripe unit smaller, for example %"PRIu64".\n"),
 			     get_conf_val(OPT_D, D_AGCOUNT));
 
 	if (!imflag)
-		imaxpct = calc_default_imaxpct(get_conf_val(OPT_B, B_LOG),
-					       dblocks);
+		set_conf_val(OPT_I, I_MAXPCT,
+			     calc_default_imaxpct(get_conf_val(OPT_B, B_LOG),
+					       dblocks));
 
 	/*
 	 * check that log sunit is modulo fsblksize or default it to D_SUNIT.
@@ -2953,7 +2951,7 @@ an AG size that is one stripe unit smaller, for example %"PRIu64".\n"),
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
 				   get_conf_val(OPT_D, D_SECTLOG),
 				   get_conf_val(OPT_B, B_LOG),
-				   inodelog, dirblocklog,
+				   get_conf_val(OPT_I, I_LOG), dirblocklog,
 				   sb_feat.log_version, lsunit, sb_feat.finobt,
 				   sb_feat.rmapbt, sb_feat.reflink);
 	ASSERT(min_logblocks);
@@ -3120,14 +3118,17 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 		   "log      =%-22s bsize=%-6d blocks=%"PRIu64", version=%d\n"
 		   "         =%-22s sectsz=%-5lu sunit=%"PRIu64" blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%"PRIu64", rtextents=%"PRIu64"\n"),
-			dfile, isize, get_conf_val(OPT_D, D_AGCOUNT),
+			dfile, get_conf_val(OPT_I, I_SIZE),
+			get_conf_val(OPT_D, D_AGCOUNT),
 			get_conf_val(OPT_D, D_AGSIZE),
 			"", get_conf_val(OPT_D, D_SECTSIZE),
 			sb_feat.attr_version,
 				    !sb_feat.projid16bit,
 			"", sb_feat.crcs_enabled, sb_feat.finobt, sb_feat.spinodes,
 			sb_feat.rmapbt, sb_feat.reflink,
-			"", get_conf_val(OPT_B, B_SIZE), dblocks, imaxpct,
+			"", get_conf_val(OPT_B, B_SIZE),
+			dblocks,
+			get_conf_val(OPT_I, I_MAXPCT),
 			"", get_conf_val(OPT_D, D_SUNIT),
 			get_conf_val(OPT_D, D_SWIDTH),
 			sb_feat.dir_version, dirblocksize, sb_feat.nci,
@@ -3158,16 +3159,18 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 	sbp->sb_rbmblocks = nbmblocks;
 	sbp->sb_logblocks = (xfs_extlen_t)logblocks;
 	sbp->sb_sectsize = (__uint16_t)get_conf_val(OPT_D, D_SECTSIZE);
-	sbp->sb_inodesize = (__uint16_t)isize;
-	sbp->sb_inopblock = (__uint16_t)(get_conf_val(OPT_B, B_SIZE) / isize);
+	sbp->sb_inodesize = (__uint16_t)get_conf_val(OPT_I, I_SIZE);
+	sbp->sb_inopblock = (__uint16_t)(get_conf_val(OPT_B, B_SIZE) /
+					 get_conf_val(OPT_I, I_SIZE));
 	sbp->sb_sectlog = (__uint8_t)get_conf_val(OPT_D, D_SECTLOG);
-	sbp->sb_inodelog = (__uint8_t)inodelog;
-	sbp->sb_inopblog = (__uint8_t)(get_conf_val(OPT_B, B_LOG) - inodelog);
+	sbp->sb_inodelog = (__uint8_t)get_conf_val(OPT_I, I_LOG);
+	sbp->sb_inopblog = (__uint8_t)(get_conf_val(OPT_B, B_LOG) -
+				       get_conf_val(OPT_I, I_LOG));
 	sbp->sb_rextslog =
 		(__uint8_t)(rtextents ?
 			libxfs_highbit32((unsigned int)rtextents) : 0);
 	sbp->sb_inprogress = 1;	/* mkfs is in progress */
-	sbp->sb_imax_pct = imaxpct;
+	sbp->sb_imax_pct = get_conf_val(OPT_I, I_MAXPCT);
 	sbp->sb_icount = 0;
 	sbp->sb_ifree = 0;
 	sbp->sb_fdblocks = dblocks -
@@ -3187,7 +3190,8 @@ _("size %s specified for log subvolume is too large, maximum is %"PRIu64" blocks
 	if (sb_feat.inode_align) {
 		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
 		if (sb_feat.crcs_enabled)
-			cluster_size *= isize / XFS_DINODE_MIN_SIZE;
+			cluster_size *= get_conf_val(OPT_I, I_SIZE) /
+				XFS_DINODE_MIN_SIZE;
 		sbp->sb_inoalignmt = cluster_size >> get_conf_val(OPT_B, B_LOG);
 		sb_feat.inode_align = sbp->sb_inoalignmt != 0;
 	} else
-- 
2.1.4

