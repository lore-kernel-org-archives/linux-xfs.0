Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09148C47257
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA9AA20774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:49:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LpL6W0p6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgD3WtK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:49:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:49944 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbgD3WtK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:49:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMlarC050811
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ueqWvFV0kzE5X3SDYHn1mgE/Oh2YY3Sn27HLcAiIz1I=;
 b=LpL6W0p60JYHxFCkYXBzgJTtKvH4HuIyIUzyqu3YQXkLVXd+Up4pErt6m7jsKGbeEIrc
 CQFielxfTBp0eI7Iam7aaQpK6vwI0vVb9YCUUKIncbTXDTX+kdnwBdJ7tDHjZ74s9Umr
 VsGjjvFDJiAPJ4VM8T04XuRablBvvBVnkph6s9P544GmBSJxjwdVt2cHeqc0ixVyXxbh
 +alGn+GzHfoIZng9kq5/RVnPB7dqvMLSUpRPl78yjl0LqVy2x/fa4c6hMyk+nhjt/Kk0
 g2yPh68fkFpDFqWifdT6Gumr2BsP527pa3OzpCqKLRG7AeChV4lB4wnd5lj08kkUPT8K +A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30r7f5r2e3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:49:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhPI6181214
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30r7fes28h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:08 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UMl7QM011739
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:07 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:07 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 08/43] xfsprogs: remove the xfs_inode argument to xfs_attr_get_ilocked
Date:   Thu, 30 Apr 2020 15:46:25 -0700
Message-Id: <20200430224700.4183-9-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=1 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The inode can easily be derived from the args structure.  Also
don't bother with else statements after early returns.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 15 +++++++--------
 libxfs/xfs_attr.h |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 9aead7c..72c03f67 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -77,19 +77,18 @@ xfs_inode_hasattr(
  */
 int
 xfs_attr_get_ilocked(
-	struct xfs_inode	*ip,
 	struct xfs_da_args	*args)
 {
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	ASSERT(xfs_isilocked(args->dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
 
-	if (!xfs_inode_hasattr(ip))
+	if (!xfs_inode_hasattr(args->dp))
 		return -ENOATTR;
-	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+
+	if (args->dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_getvalue(args);
-	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
+	if (xfs_bmap_one_block(args->dp, XFS_ATTR_FORK))
 		return xfs_attr_leaf_get(args);
-	else
-		return xfs_attr_node_get(args);
+	return xfs_attr_node_get(args);
 }
 
 /*
@@ -133,7 +132,7 @@ xfs_attr_get(
 		args->op_flags |= XFS_DA_OP_ALLOCVAL;
 
 	lock_mode = xfs_ilock_attr_map_shared(args->dp);
-	error = xfs_attr_get_ilocked(args->dp, args);
+	error = xfs_attr_get_ilocked(args);
 	xfs_iunlock(args->dp, lock_mode);
 
 	/* on error, we have to clean up allocated value buffers */
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index be77d13..b8c4ed2 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -145,7 +145,7 @@ int xfs_attr_inactive(struct xfs_inode *dp);
 int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
-int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
+int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
-- 
2.7.4

