Return-Path: <SRS0=Wl19=BE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E941AC433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 23:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD361206C1
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jul 2020 23:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DWSdJIRa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGYXGw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Jul 2020 19:06:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43016 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbgGYXGw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jul 2020 19:06:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PN6p73100331
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:06:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Q+MUwB/53yPyhwWBgFwNFDXvTfxE9ft2NKDtbJvhEaQ=;
 b=DWSdJIRaBuRI3oBNPPZ5GAVvi156fybu2Uhh7COEbEYEInVaYdSUf0LDgVpqFHkCTjLi
 iX5oGqf9sIizq5iFamT2rid6TubCeQhNrSc4GcUz3tYWbgxAsznEvVpCOMyAsH7dnapH
 qRiyF0OakO95WgJvv8u3LBCcGE5q2OAbUvZqTEUe2gS1F4X5ct436BfrQIfP7YPrvlCH
 4Vrexs+UOQBnEVaQpV78Auxu9LmoK6MzT23eO61R2bGGrv7WA7yzFGfXbjqgl06Sz4SL
 Z/FbYGQoayDC59Fg1/4Dl1K9R1c7ZMucHEZXluQ3p2tGBKzWG/60uFryBTl9NTXQUvda mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 32gx46g01b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:06:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06PN4Cks103659
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:04:50 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 32gw39s64c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:04:07 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06PN19GF006870
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 23:01:09 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 16:01:08 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: Fix compiler warning in xfs_attr_shortform_add
Date:   Sat, 25 Jul 2020 16:01:02 -0700
Message-Id: <20200725230102.22192-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200725230102.22192-1-allison.henderson@oracle.com>
References: <20200725230102.22192-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 adultscore=0 suspectscore=1 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250191
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9693 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 suspectscore=1 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250191
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix compiler warning: variable 'error' set but not used in
xfs_attr_shortform_add

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      |  3 +--
 fs/xfs/libxfs/xfs_attr_leaf.c | 11 ++++++++---
 fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 4ef0020..3428f8b 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -562,8 +562,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	if (!forkoff)
 		return -ENOSPC;
 
-	xfs_attr_shortform_add(args, forkoff);
-	return 0;
+	return xfs_attr_shortform_add(args, forkoff);
 }
 
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ad7b351..d0653bb 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -708,7 +708,7 @@ xfs_attr_sf_findname(
  * Add a name/value pair to the shortform attribute list.
  * Overflow from the inode has already been checked for.
  */
-void
+int
 xfs_attr_shortform_add(
 	struct xfs_da_args		*args,
 	int				forkoff)
@@ -730,7 +730,8 @@ xfs_attr_shortform_add(
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 	error = xfs_attr_sf_findname(args, &sfe, NULL);
-	ASSERT(error != -EEXIST);
+	if (error == -EEXIST)
+		return error;
 
 	offset = (char *)sfe - (char *)sf;
 	size = XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
@@ -748,6 +749,8 @@ xfs_attr_shortform_add(
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_ADATA);
 
 	xfs_sbversion_add_attr2(mp, args->trans);
+
+	return 0;
 }
 
 /*
@@ -1151,7 +1154,9 @@ xfs_attr3_leaf_to_shortform(
 		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
 		nargs.hashval = be32_to_cpu(entry->hashval);
 		nargs.attr_filter = entry->flags & XFS_ATTR_NSP_ONDISK_MASK;
-		xfs_attr_shortform_add(&nargs, forkoff);
+		error = xfs_attr_shortform_add(&nargs, forkoff);
+		if (error)
+			goto out;
 	}
 	error = 0;
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 9b1c59f..e0027bb 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -46,7 +46,7 @@ struct xfs_attr3_icleaf_hdr {
  * Internal routines when attribute fork size < XFS_LITINO(mp).
  */
 void	xfs_attr_shortform_create(struct xfs_da_args *args);
-void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
+int	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
 int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
-- 
2.7.4

