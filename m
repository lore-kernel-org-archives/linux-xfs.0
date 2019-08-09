Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfHIVi1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYShK084522
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:26 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcPhw112258
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxkbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LcMAc010621
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:23 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v1 17/19] xfsprogs: Enable delayed attributes
Date: Fri,  9 Aug 2019 14:38:02 -0700
Message-Id: <20190809213804.32628-18-allison.henderson@oracle.com>
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Finally enable delayed attributes in xfs_attr_set and
xfs_attr_remove.  We only do this for v4 and up since we
cant add new log entries to old fs versions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ecc525c..dc38715 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -507,6 +507,7 @@ xfs_attr_set(
 	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (name->type & ATTR_ROOT) != 0;
@@ -565,7 +566,20 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args);
+	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
+		error = xfs_attr_set_args(&args);
+	else {
+		error = xfs_has_attr(&args);
+
+		if (error == -EEXIST && (name->type & ATTR_CREATE))
+			goto out_trans_cancel;
+
+		if (error == -ENOATTR && (name->type & ATTR_REPLACE))
+			goto out_trans_cancel;
+
+		error = xfs_attr_set_deferred(dp, args.trans, name, value,
+					      valuelen);
+	}
 	if (error)
 		goto out_trans_cancel;
 	if (!args.trans) {
@@ -650,6 +664,7 @@ xfs_attr_remove(
 	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	int			error;
 
@@ -691,7 +706,14 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_remove_args(&args);
+	error = xfs_has_attr(&args);
+	if (error == -ENOATTR)
+		goto out;
+
+	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
+		error = xfs_attr_remove_args(&args);
+	else
+		error = xfs_attr_remove_deferred(dp, args.trans, name);
 	if (error)
 		goto out;
 
-- 
2.7.4
