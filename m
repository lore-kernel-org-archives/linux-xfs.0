Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935828AbdGTJwJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:52:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1BE4961E4C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 09:52:09 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 4/5] mkfs: replace variables with opts table: -n options
Date: Thu, 20 Jul 2017 11:51:55 +0200
Message-Id: <20170720095156.35417-5-jtulak@redhat.com>
In-Reply-To: <20170720095156.35417-1-jtulak@redhat.com>
References: <20170720095156.35417-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Remove variables that can be replaced with a direct access to the opts
table, so we have it all in a single place, accessible from anywhere.

In future, we can remove some instances where we are passing values as
arguments to helper functions, when we have the values in the opts
struct and could pass only the struct.  But for now, limit the changes
to simple replacement without any change in the logic.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1bc3351f..8c582b87 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1476,8 +1476,6 @@ main(
 	int			dasize;
 	xfs_rfsblock_t		dblocks;
 	char			*dfile;
-	int			dirblocklog;
-	int			dirblocksize;
 	bool			force_overwrite;
 	struct fsxattr		fsx;
 	int			ilflag;
@@ -1557,7 +1555,6 @@ main(
 	liflag = laflag = lsflag = lsuflag = lsunitflag = ldflag = lvflag = false;
 	logblocks = rtblocks = rtextblocks = 0;
 	Nflag = nlflag = nsflag = nvflag = false;
-	dirblocklog = dirblocksize = 0;
 	qflag = false;
 	dfile = logfile = rtfile = NULL;
 	protofile = NULL;
@@ -1923,26 +1920,23 @@ main(
 				char	**subopts =
 						(char **)opts[OPT_N].subopts;
 				char	*value;
+				uint64_t tmp;
 
 				switch (getsubopt(&p, subopts, &value)) {
 				case N_LOG:
-					dirblocklog = parse_conf_val(OPT_N,
+					tmp = parse_conf_val(OPT_N,
 								     N_LOG,
 								     value);
-					dirblocksize = 1 << dirblocklog;
+					set_conf_val(OPT_N, N_SIZE, 1 << tmp);
 					nlflag = 1;
-					set_conf_val(OPT_N, N_SIZE,
-						     dirblocksize);
 					break;
 				case N_SIZE:
-					dirblocksize = parse_conf_val(OPT_N,
+					tmp = parse_conf_val(OPT_N,
 								      N_SIZE,
 								      value);
-					dirblocklog =
-						libxfs_highbit32(dirblocksize);
-					nsflag = 1;
 					set_conf_val(OPT_N, N_LOG,
-						     dirblocklog);
+						     libxfs_highbit32(tmp));
+					nsflag = 1;
 					break;
 				case N_VERSION:
 					value = getstr(value, &opts[OPT_N],
@@ -2342,18 +2336,19 @@ _("rmapbt not supported with realtime devices\n"));
 	}
 
 	if (nsflag || nlflag) {
-		if (dirblocksize < get_conf_val(OPT_B, B_SIZE) ||
-					dirblocksize > XFS_MAX_BLOCKSIZE) {
-			fprintf(stderr, _("illegal directory block size %d\n"),
-				dirblocksize);
+		if (get_conf_val(OPT_N, N_SIZE) <
+		    get_conf_val(OPT_B, B_SIZE) ||
+		    get_conf_val(OPT_N, N_SIZE) > XFS_MAX_BLOCKSIZE) {
+			fprintf(stderr, _("illegal directory block size %lld\n"),
+				get_conf_val(OPT_N, N_SIZE));
 			usage();
 		}
 	} else {
 		if (get_conf_val(OPT_B, B_SIZE) < (1 << XFS_MIN_REC_DIRSIZE))
-			dirblocklog = XFS_MIN_REC_DIRSIZE;
+			set_conf_val(OPT_N, N_LOG, XFS_MIN_REC_DIRSIZE);
 		else
-			dirblocklog = get_conf_val(OPT_B, B_LOG);
-		dirblocksize = 1 << dirblocklog;
+			set_conf_val(OPT_N, N_LOG, get_conf_val(OPT_B, B_LOG));
+		set_conf_val(OPT_N, N_SIZE, 1 << get_conf_val(OPT_N, N_LOG));
 	}
 
 
@@ -2931,7 +2926,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 				   sb_feat.crcs_enabled, sb_feat.dir_version,
 				   get_conf_val(OPT_D, D_SECTLOG),
 				   get_conf_val(OPT_B, B_LOG),
-				   get_conf_val(OPT_I, I_LOG), dirblocklog,
+				   get_conf_val(OPT_I, I_LOG),
+				   get_conf_val(OPT_N, N_LOG),
 				   sb_feat.log_version,
 				   get_conf_val(OPT_L, L_SUNIT),
 				   sb_feat.finobt,
@@ -3122,7 +3118,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 			get_conf_val(OPT_I, I_MAXPCT),
 			"", get_conf_val(OPT_D, D_SUNIT),
 			get_conf_val(OPT_D, D_SWIDTH),
-			sb_feat.dir_version, (long long)dirblocksize, sb_feat.nci,
+			sb_feat.dir_version,
+			get_conf_val(OPT_N, N_SIZE), sb_feat.nci,
 				sb_feat.dirftype,
 			logfile, 1 << get_conf_val(OPT_B, B_LOG), (long long)logblocks,
 			sb_feat.log_version, "",
@@ -3174,7 +3171,8 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_qflags = 0;
 	sbp->sb_unit = get_conf_val(OPT_D, D_SUNIT);
 	sbp->sb_width = get_conf_val(OPT_D, D_SWIDTH);
-	sbp->sb_dirblklog = dirblocklog - get_conf_val(OPT_B, B_LOG);
+	sbp->sb_dirblklog = get_conf_val(OPT_N, N_LOG) -
+		get_conf_val(OPT_B, B_LOG);
 	if (sb_feat.log_version == 2) {	/* This is stored in bytes */
 		set_conf_val(OPT_L, L_SUNIT,
 			     (get_conf_val(OPT_L, L_SUNIT) == 0) ?
-- 
2.11.0

