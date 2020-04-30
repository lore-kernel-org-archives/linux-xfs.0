Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DA3C47258
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A5D20774
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Naxval/y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgD3WrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43726 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgD3WrM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgv7c128515
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=8witqzQLM6IHkx2UMA/PsasYekQfcSByJfT6ur5OnhY=;
 b=Naxval/ysTrWqohAyGNIlMs6lS/C0PR83uPxzYpVfGMJVLiz3CtNDezJ/0lvPQwfM+ii
 FpjUXdVpT3kvz7Z3jyVvszNQTrV9BaZFuo1K30EX9bP3DKquDx1ivOdOpxsHNbrpTgfX
 tvyUXQjWtPPLxuHk3li53m4LHlKBcZVR7bjime8NWkOeOyqTXHSJsMXnPt29IbrFEosS
 bVlIZi1M2W45JIVKm46LkDVDvQbt0hG9MpOAFqzwZ745JbiPVHlei0qUEdYRNJd5hFmK
 Uin2pl+PUGmko30Kvchqf88+YpODEAzUc29RxPgAAjW1iJV0Q48dkWeoYYegJipUGwlS KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30r7f3g235-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMgJVm141673
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30qtg23dsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMlAii012298
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:10 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:09 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 19/43] xfsprogs: embedded the attrlist cursor into struct xfs_attr_list_context
Date:   Thu, 30 Apr 2020 15:46:36 -0700
Message-Id: <20200430224700.4183-20-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The attrlist cursor only exists as part of an attr list context, so
embedd the structure instead of pointing to it.  Also give it a proper
xfs_ prefix and remove the obsolete typedef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h      | 6 +++---
 libxfs/xfs_attr_leaf.h | 1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index a6bedb0..0d2d059 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -31,14 +31,14 @@ struct xfs_attr_list_context;
 /*
  * Kernel-internal version of the attrlist cursor.
  */
-typedef struct attrlist_cursor_kern {
+struct xfs_attrlist_cursor_kern {
 	__u32	hashval;	/* hash value of next entry to add */
 	__u32	blkno;		/* block containing entry (suggestion) */
 	__u32	offset;		/* offset in list of equal-hashvals */
 	__u16	pad1;		/* padding to match user-level */
 	__u8	pad2;		/* padding to match user-level */
 	__u8	initted;	/* T/F: cursor has been initialized */
-} attrlist_cursor_kern_t;
+};
 
 
 /*========================================================================
@@ -53,7 +53,7 @@ typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
 	struct xfs_inode	*dp;		/* inode */
-	struct attrlist_cursor_kern *cursor;	/* position in list */
+	struct xfs_attrlist_cursor_kern cursor;	/* position in list */
 	void			*buffer;	/* output buffer */
 
 	/*
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 73615b1..6dd2d93 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
@@ -8,7 +8,6 @@
 #define	__XFS_ATTR_LEAF_H__
 
 struct attrlist;
-struct attrlist_cursor_kern;
 struct xfs_attr_list_context;
 struct xfs_da_args;
 struct xfs_da_state;
-- 
2.7.4

