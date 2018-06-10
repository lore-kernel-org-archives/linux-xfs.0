Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753729AbeFJFKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A58dBg072601
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:18 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2jg6b19w8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AI40024615
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:18 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A5AHE3030475
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:17 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 20/27] xfsprogs: Add parent pointer flag to cmd
Date: Sat,  9 Jun 2018 22:07:45 -0700
Message-Id: <1528607272-11122-21-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

mkfs: enable formatting with parent pointers
Enable parent pointer support in mkfs via the '-n parent' parameter.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 78d0ce5..b9a8b00 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -104,6 +104,7 @@ enum {
 	N_SIZE = 0,
 	N_VERSION,
 	N_FTYPE,
+	N_PARENT,
 	N_MAX_OPTS,
 };
 
@@ -550,6 +551,7 @@ struct opt_params nopts = {
 		[N_SIZE] = "size",
 		[N_VERSION] = "version",
 		[N_FTYPE] = "ftype",
+		[N_PARENT] = "parent",
 	},
 	.subopt_params = {
 		{ .index = N_SIZE,
@@ -572,6 +574,12 @@ struct opt_params nopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = N_PARENT,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -876,7 +884,7 @@ usage( void )
 /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
 			    sunit=value|su=num,sectsize=num,lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
-/* naming */		[-n size=num,version=2|ci,ftype=0|1]\n\
+/* naming */		[-n size=num,version=2|ci,ftype=0|1,parent=0|1]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
 /* quiet */		[-q]\n\
@@ -1615,6 +1623,9 @@ naming_opts_parser(
 	case N_FTYPE:
 		cli->sb_feat.dirftype = getnum(value, opts, subopt);
 		break;
+	case N_PARENT:
+		cli->sb_feat.parent_pointers = getnum(value, &nopts, N_PARENT);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2887,6 +2898,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	if (fp->reflink)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	if (fp->parent_pointers)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_PARENT;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
-- 
2.7.4

