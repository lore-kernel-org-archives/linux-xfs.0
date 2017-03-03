Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752159AbdCCXOY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:24 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 5/9] mkfs.xfs: move mopts to struct mkfs_xfs_opts
Date: Fri,  3 Mar 2017 15:13:12 -0800
Message-Id: <20170303231316.12716-6-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

This moves all main() mopts to struct mkfs_xfs_opts in
order to help with clutter and later enable re-parsing
options for other purposes.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 78 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 40 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index cd52b525f824..52392c4e2c50 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -772,6 +772,7 @@ struct mkfs_xfs_opts {
 	int			lvflag;
 	int			lslflag;
 	int			lssflag;
+	uuid_t			uuid;
 };
 
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
@@ -1651,6 +1652,39 @@ parse_subopts(
 			}
 		}
 		break;
+	case 'm':
+		while (*p != '\0') {
+			switch (getsubopt(&p, (char **)mopts.subopts, &value)) {
+			case M_CRC:
+				params->sb_feat.crcs_enabled =
+					getnum(value, &mopts, M_CRC);
+				if (params->sb_feat.crcs_enabled)
+					params->sb_feat.dirftype = true;
+				break;
+			case M_FINOBT:
+				params->sb_feat.finobt =
+					getnum(value, &mopts, M_FINOBT);
+				break;
+			case M_UUID:
+				if (!value || *value == '\0')
+					reqval('m', (char **)mopts.subopts,
+					       M_UUID);
+				if (platform_uuid_parse(value, &params->uuid))
+					illegal(optarg, "m uuid");
+				break;
+			case M_RMAPBT:
+				params->sb_feat.rmapbt =
+					getnum(value, &mopts, M_RMAPBT);
+				break;
+			case M_REFLINK:
+				params->sb_feat.reflink =
+					getnum(value, &mopts, M_REFLINK);
+				break;
+			default:
+				unknown('m', value);
+			}
+		}
+		break;
 	default:
 		usage();
 	}
@@ -1721,7 +1755,6 @@ main(
 	xfs_sb_t		*sbp;
 	__uint64_t		sector_mask;
 	__uint64_t		tmp_agsize;
-	uuid_t			uuid;
 	int			worst_freelist;
 	struct fs_topology	ft;
 	struct mkfs_xfs_opts params;
@@ -1730,7 +1763,7 @@ main(
 	memset(&params, 0, sizeof(params));
 	init_sb_feat_args_default(sb_feat);
 
-	platform_uuid_generate(&uuid);
+	platform_uuid_generate(&params.uuid);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -1765,6 +1798,7 @@ main(
 		case 'd':
 		case 'i':
 		case 'l':
+		case 'm':
 			p = optarg;
 			parse_subopts(c, p, &params);
 			break;
@@ -1773,42 +1807,6 @@ main(
 				illegal(optarg, "L");
 			label = optarg;
 			break;
-		case 'm':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)mopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case M_CRC:
-					sb_feat->crcs_enabled =
-						getnum(value, &mopts, M_CRC);
-					if (sb_feat->crcs_enabled)
-						sb_feat->dirftype = true;
-					break;
-				case M_FINOBT:
-					sb_feat->finobt = getnum(
-						value, &mopts, M_FINOBT);
-					break;
-				case M_UUID:
-					if (!value || *value == '\0')
-						reqval('m', subopts, M_UUID);
-					if (platform_uuid_parse(value, &uuid))
-						illegal(optarg, "m uuid");
-					break;
-				case M_RMAPBT:
-					sb_feat->rmapbt = getnum(
-						value, &mopts, M_RMAPBT);
-					break;
-				case M_REFLINK:
-					sb_feat->reflink = getnum(
-						value, &mopts, M_REFLINK);
-					break;
-				default:
-					unknown('m', value);
-				}
-			}
-			break;
 		case 'n':
 			p = optarg;
 			while (*p != '\0') {
@@ -2843,9 +2841,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_dblocks = dblocks;
 	sbp->sb_rblocks = rtblocks;
 	sbp->sb_rextents = rtextents;
-	platform_uuid_copy(&sbp->sb_uuid, &uuid);
+	platform_uuid_copy(&sbp->sb_uuid, &params.uuid);
 	/* Only in memory; libxfs expects this as if read from disk */
-	platform_uuid_copy(&sbp->sb_meta_uuid, &uuid);
+	platform_uuid_copy(&sbp->sb_meta_uuid, &params.uuid);
 	sbp->sb_logstart = logstart;
 	sbp->sb_rootino = sbp->sb_rbmino = sbp->sb_rsumino = NULLFSINO;
 	sbp->sb_rextsize = rtextblocks;
-- 
2.11.0

