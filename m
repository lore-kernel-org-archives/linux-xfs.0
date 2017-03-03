Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdCCXOY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:24 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 6/9] mkfs.xfs: move nopts to struct mkfs_xfs_opts
Date: Fri,  3 Mar 2017 15:13:13 -0800
Message-Id: <20170303231316.12716-7-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

This moves all main() X-opts to struct mkfs_xfs_opts in
order to help with clutter and later enable re-parsing
options for other purposes.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 116 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 57 insertions(+), 59 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 52392c4e2c50..b2f4495d858d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -773,6 +773,12 @@ struct mkfs_xfs_opts {
 	int			lslflag;
 	int			lssflag;
 	uuid_t			uuid;
+
+	int			dirblocklog;
+	int			dirblocksize;
+	int			nlflag;
+	int			nvflag; /* unused */
+	int			nsflag;
 };
 
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
@@ -1685,6 +1691,43 @@ parse_subopts(
 			}
 		}
 		break;
+	case 'n':
+		while (*p != '\0') {
+			switch (getsubopt(&p, (char **)nopts.subopts, &value)) {
+			case N_LOG:
+				params->dirblocklog =
+					getnum(value, &nopts, N_LOG);
+				params->dirblocksize = 1 << params->dirblocklog;
+				params->nlflag = 1;
+				break;
+			case N_SIZE:
+				params->dirblocksize =
+					getnum(value, &nopts, N_SIZE);
+				params->dirblocklog =
+					libxfs_highbit32(params->dirblocksize);
+				params->nsflag = 1;
+				break;
+			case N_VERSION:
+				value = getstr(value, &nopts, N_VERSION);
+				if (!strcasecmp(value, "ci")) {
+					/* ASCII CI mode */
+					params->sb_feat.nci = true;
+				} else {
+					params->sb_feat.dir_version =
+						getnum(value, &nopts,
+						       N_VERSION);
+				}
+				params->nvflag = 1;
+				break;
+			case N_FTYPE:
+				params->sb_feat.dirftype =
+					getnum(value, &nopts, N_FTYPE);
+				break;
+			default:
+				unknown('n', value);
+			}
+		}
+		break;
 	default:
 		usage();
 	}
@@ -1723,8 +1766,6 @@ main(
 	int			c;
 	xfs_rfsblock_t		dblocks;
 	char			*dfile;
-	int			dirblocklog;
-	int			dirblocksize;
 	int			force_overwrite;
 	char			*label = NULL;
 	int			lalign;
@@ -1735,11 +1776,8 @@ main(
 	xfs_mount_t		*mp;
 	xfs_mount_t		mbuf;
 	xfs_extlen_t		nbmblocks;
-	int			nlflag;
 	int			norsflag;
 	xfs_alloc_rec_t		*nrec;
-	int			nsflag;
-	int			nvflag;
 	int			Nflag;
 	int			discard = 1;
 	char			*p;
@@ -1775,8 +1813,7 @@ main(
 	params.loginternal = 1;
 	lsflag = 0;
 	logblocks = rtblocks = rtextblocks = 0;
-	Nflag = nlflag = nsflag = nvflag = 0;
-	dirblocklog = dirblocksize = 0;
+	Nflag = 0;
 	qflag = 0;
 	dfile = rtfile = NULL;
 	rtsize = rtextsize = protofile = NULL;
@@ -1799,6 +1836,7 @@ main(
 		case 'i':
 		case 'l':
 		case 'm':
+		case 'n':
 			p = optarg;
 			parse_subopts(c, p, &params);
 			break;
@@ -1807,47 +1845,6 @@ main(
 				illegal(optarg, "L");
 			label = optarg;
 			break;
-		case 'n':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)nopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case N_LOG:
-					dirblocklog = getnum(value, &nopts,
-							     N_LOG);
-					dirblocksize = 1 << dirblocklog;
-					nlflag = 1;
-					break;
-				case N_SIZE:
-					dirblocksize = getnum(value, &nopts,
-							      N_SIZE);
-					dirblocklog =
-						libxfs_highbit32(dirblocksize);
-					nsflag = 1;
-					break;
-				case N_VERSION:
-					value = getstr(value, &nopts, N_VERSION);
-					if (!strcasecmp(value, "ci")) {
-						/* ASCII CI mode */
-						sb_feat->nci = true;
-					} else {
-						sb_feat->dir_version =
-							getnum(value, &nopts,
-							       N_VERSION);
-					}
-					nvflag = 1;
-					break;
-				case N_FTYPE:
-					sb_feat->dirftype = getnum(value, &nopts,
-								  N_FTYPE);
-					break;
-				default:
-					unknown('n', value);
-				}
-			}
-			break;
 		case 'N':
 			Nflag = 1;
 			break;
@@ -2168,19 +2165,19 @@ _("rmapbt not supported with realtime devices\n"));
 		sb_feat->rmapbt = false;
 	}
 
-	if (nsflag || nlflag) {
-		if (dirblocksize < blocksize ||
-					dirblocksize > XFS_MAX_BLOCKSIZE) {
+	if (params.nsflag || params.nlflag) {
+		if (params.dirblocksize < blocksize ||
+					params.dirblocksize > XFS_MAX_BLOCKSIZE) {
 			fprintf(stderr, _("illegal directory block size %d\n"),
-				dirblocksize);
+				params.dirblocksize);
 			usage();
 		}
 	} else {
 		if (blocksize < (1 << XFS_MIN_REC_DIRSIZE))
-			dirblocklog = XFS_MIN_REC_DIRSIZE;
+			params.dirblocklog = XFS_MIN_REC_DIRSIZE;
 		else
-			dirblocklog = params.blocklog;
-		dirblocksize = 1 << dirblocklog;
+			params.dirblocklog = params.blocklog;
+		params.dirblocksize = 1 << params.dirblocklog;
 	}
 
 
@@ -2660,7 +2657,7 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				   sb_feat->crcs_enabled, sb_feat->dir_version,
 				   params.sectorlog, params.blocklog,
 				   params.inodelog,
-				   dirblocklog,
+				   params.dirblocklog,
 				   sb_feat->log_version, params.lsunit,
 				   sb_feat->finobt,
 				   sb_feat->rmapbt, sb_feat->reflink);
@@ -2821,8 +2818,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			sb_feat->rmapbt, sb_feat->reflink,
 			"", blocksize, (long long)dblocks, params.imaxpct,
 			"", params.dsunit, params.dswidth,
-			sb_feat->dir_version, dirblocksize, sb_feat->nci,
-				sb_feat->dirftype,
+			sb_feat->dir_version, params.dirblocksize,
+			sb_feat->nci,
+			sb_feat->dirftype,
 			params.logfile, 1 << params.blocklog,
 			(long long)logblocks,
 			sb_feat->log_version, "", params.lsectorsize,
@@ -2870,7 +2868,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_qflags = 0;
 	sbp->sb_unit = params.dsunit;
 	sbp->sb_width = params.dswidth;
-	sbp->sb_dirblklog = dirblocklog - params.blocklog;
+	sbp->sb_dirblklog = params.dirblocklog - params.blocklog;
 	if (sb_feat->log_version == 2) {	/* This is stored in bytes */
 		params.lsunit = (params.lsunit == 0) ? 1 : XFS_FSB_TO_B(mp,
 									params.lsunit);
-- 
2.11.0

