Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33552 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752682AbeEHEnc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 00:43:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w484fAq6066291
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:32 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2hs426eur0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 04:43:32 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w484hVV5024217
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w484hVR9025149
        for <linux-xfs@vger.kernel.org>; Tue, 8 May 2018 04:43:31 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH 18/21] xfsprogs: Add parent pointer flag to cmd
Date: Mon,  7 May 2018 21:41:16 -0700
Message-Id: <1525754479-12177-19-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
References: <1525754479-12177-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 mkfs/xfs_mkfs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 78d0ce5..554e1bf 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -129,6 +129,7 @@ enum {
 	M_UUID,
 	M_RMAPBT,
 	M_REFLINK,
+	M_PARENT,
 	M_MAX_OPTS,
 };
 
@@ -663,6 +664,7 @@ struct opt_params mopts = {
 		[M_UUID] = "uuid",
 		[M_RMAPBT] = "rmapbt",
 		[M_REFLINK] = "reflink",
+		[M_PARENT] = "parent",
 	},
 	.subopt_params = {
 		{ .index = M_CRC,
@@ -693,6 +695,13 @@ struct opt_params mopts = {
 		  .maxval = 1,
 		  .defaultval = 1,
 		},
+		{ .index = M_PARENT,
+		  .conflicts = { {NULL, LAST_CONFLICT } },
+		  .minval = 0,
+		  .maxval = 1,
+		  .defaultval = 0,
+		},
+
 	},
 };
 
@@ -865,7 +874,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
-/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1]\n\
+/* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,parent=0|1]\n\
 /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
 			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
 			    sectsize=num\n\
@@ -1586,6 +1595,9 @@ meta_opts_parser(
 	case M_REFLINK:
 		cli->sb_feat.reflink = getnum(value, opts, subopt);
 		break;
+	case M_PARENT:
+		cli->sb_feat.parent_pointers = getnum(value, &mopts, M_PARENT);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -2887,6 +2899,8 @@ sb_set_features(
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	if (fp->reflink)
 		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_REFLINK;
+	if (fp->parent_pointers)
+		sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_PARENT;
 
 	/*
 	 * Sparse inode chunk support has two main inode alignment requirements.
-- 
2.7.4

