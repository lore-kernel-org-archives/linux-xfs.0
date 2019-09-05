Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6BCC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A477B20825
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DF6vWxUT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391171AbfIEWTJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58914 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391119AbfIEWTJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJ8Cd049693
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=W0Rpav6y4yCAYNHpiuMqANcngv6yK3uru8QBwssvXGc=;
 b=DF6vWxUTzKlbjx8Wk/Mdy6fPaORj2IjCc2PCFVZaTv0ERoMxnlj/u27TgL3HEYI5JYPE
 D77geW5zFr/uG5dN50J05/GlOHNRQRsptZ0Lk7eCWMz+Nuj35th0xftOVi1WDSuNgai8
 skpD97aFxxvXez5/8WBinvKLjLs3VsF/AT8F04NY6WOr7zp22EmkgNwHp5sq37a67dpk
 oyeDvaFXq4YdKS+Ln7FelDFKCqOzzN2nrQVW6S/w+Bz7iDhQXj4toi+GiNx78Wkr0dgE
 ZtJ9cowxueutklZfLM/zJqqgAS/zHv57zyDTzHHxh4Ktz41HVfyPexLBaFkO9b2DfIvk UQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2uuarc81yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIOhf101602
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:49 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2uu1b946k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:18:49 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MInkU001642
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:18:49 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:18:48 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 16/19] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Thu,  5 Sep 2019 15:18:34 -0700
Message-Id: <20190905221837.17388-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221837.17388-1-allison.henderson@oracle.com>
References: <20190905221837.17388-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

These routines set up set and start a new deferred attribute
operation.  These functions are meant to be called by other
code needing to initiate a deferred attribute operation.
New helper function xfs_attr_item_init also added

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr.h |  5 +++
 2 files changed, 90 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 7680789..f502396 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,6 +25,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
 
 /*
  * xfs_attr.c
@@ -622,6 +623,70 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_inode	*dp,		/* inode for attr operation */
+	struct xfs_trans	*tp,		/* transaction for attr op */
+	struct xfs_name		*name,		/* attr name, len and flags */
+	const unsigned char	*value,		/* attr value */
+	unsigned int		valuelen,	/* attr value len */
+	int			op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+	char			*name_value;
+
+	/*
+	 * All set operations must have a name but not necessarily a value.
+	 */
+	if (!name->len) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	new = kmem_alloc_large(XFS_ATTR_ITEM_SIZEOF(name->len, valuelen),
+			 KM_NOFS);
+	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
+	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(name->len, valuelen));
+	new->xattri_ip = dp;
+	new->xattri_op_flags = op_flags;
+	new->xattri_name_len = name->len;
+	new->xattri_value_len = valuelen;
+	new->xattri_flags = name->type;
+	memcpy(&name_value[0], name->name, name->len);
+	new->xattri_name = name_value;
+	new->xattri_value = name_value + name->len;
+
+	if (valuelen > 0)
+		memcpy(&name_value[name->len], value, valuelen);
+
+	*attr = new;
+	return 0;
+}
+
+/* Sets an attribute for an inode as a deferred operation */
+int
+xfs_attr_set_deferred(
+	struct xfs_inode	*dp,
+	struct xfs_trans	*tp,
+	struct xfs_name		*name,
+	const unsigned char	*value,
+	unsigned int		valuelen)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(dp, tp, name, value, valuelen,
+				 XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
@@ -703,6 +768,26 @@ xfs_attr_remove(
 	return error;
 }
 
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_inode        *dp,
+	struct xfs_trans	*tp,
+	struct xfs_name		*name)
+{
+
+	struct xfs_attr_item *new;
+
+	int error  = xfs_attr_item_init(dp, tp, name, NULL, 0,
+				  XFS_ATTR_OP_FLAGS_REMOVE, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 1e0c25e..0dfec5c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -190,5 +190,10 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       struct xfs_name *name);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
+			  struct xfs_name *name, const unsigned char *value,
+			  unsigned int valuelen);
+int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
+			    struct xfs_name *name);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

