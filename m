Return-Path: <SRS0=R4OI=CF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7756DC433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 590B620738
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Aug 2020 00:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l4J4TPWk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgH0Afa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 20:35:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40820 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgH0Af3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 20:35:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0TJNu165410
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fXh674qmcBj/GadcbWkoc0WCV/TeoPzCthhzxpv/phY=;
 b=l4J4TPWkfBWKcy6zEEn1GXjB5EYHLu9jhpVjxu/MIwnFPLjks4wLZh54Yzu/7nQq9/Tn
 Fm45EAQkDmaXNNCnMwxZiGvZ2HV/MmJrJLgt7ZKMD7VMcM+HWxfHTUhNo2ina19fsTUf
 moAc6lBQa1WEx9/kjJ4Vlo16ZX8Cnj4D6QrJ5gAvKJ+gcj6UEX6IPGpJBrzi/4MLW9uc
 LlmmYEAoebrUUXBpKJJvCcT3GdE9G/SZdOJlD++IKZvhbf/AT9Ah46aR9puBfvL7+kIR
 py+yx668AVSUOqhdvBPhYvqBFcWloexVamAkRWDF/vxizNjxPTb120jq3MtP3Hzy14hT PQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 333w6u20a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07R0UrC6066715
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 333r9mt21x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:26 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07R0ZQ5Q020447
        for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2020 00:35:26 GMT
Received: from localhost.localdomain (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 17:35:26 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v12 5/8] xfs: Add xfs_attr_set_deferred and xfs_attr_remove_deferred
Date:   Wed, 26 Aug 2020 17:35:15 -0700
Message-Id: <20200827003518.1231-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827003518.1231-1-allison.henderson@oracle.com>
References: <20200827003518.1231-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=1 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008270001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These routines to set up and start a new deferred attribute operations.
These functions are meant to be called by any routine needing to
initiate a deferred attribute operation as opposed to the existing
inline operations. New helper function xfs_attr_item_init also added.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr.h |  7 ++++
 2 files changed, 98 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index cf75742..7b79868 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -25,6 +25,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_attr_item.h"
+#include "xfs_attr.h"
 
 /*
  * xfs_attr.c
@@ -643,6 +644,96 @@ xfs_attr_set(
 	goto out_unlock;
 }
 
+STATIC int
+xfs_attr_item_init(
+	struct xfs_inode	*dp,		/* inode for attr operation */
+	struct xfs_trans	*tp,		/* transaction for attr op */
+	const unsigned char	*name,		/* attr name */
+	unsigned int		namelen,	/* attr namelen */
+	unsigned int		flags,		/* attr flags */
+	const unsigned char	*value,		/* attr value */
+	unsigned int		valuelen,	/* attr value len */
+	unsigned int		op_flags,	/* op flag (set or remove) */
+	struct xfs_attr_item	**attr)		/* new xfs_attr_item */
+{
+
+	struct xfs_attr_item	*new;
+	char			*name_value;
+
+	/*
+	 * All set operations must have a name but not necessarily a value.
+	 */
+	if (!namelen) {
+		ASSERT(0);
+		return -EINVAL;
+	}
+
+	new = kmem_alloc_large(XFS_ATTR_ITEM_SIZEOF(namelen, valuelen),
+			 KM_NOFS);
+	name_value = ((char *)new) + sizeof(struct xfs_attr_item);
+	memset(new, 0, XFS_ATTR_ITEM_SIZEOF(namelen, valuelen));
+	new->xattri_ip = dp;
+	new->xattri_op_flags = op_flags;
+	new->xattri_name_len = namelen;
+	new->xattri_value_len = valuelen;
+	new->xattri_flags = flags;
+	memcpy(&name_value[0], name, namelen);
+	new->xattri_name = name_value;
+	new->xattri_value = name_value + namelen;
+
+	if (valuelen > 0)
+		memcpy(&name_value[namelen], value, valuelen);
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
+	const unsigned char	*name,
+	unsigned int		namelen,
+	unsigned int		flags,
+	const unsigned char	*value,
+	unsigned int		valuelen)
+{
+	struct xfs_attr_item	*new;
+	int			error = 0;
+
+	error = xfs_attr_item_init(dp, tp, name, namelen, flags, value,
+				   valuelen, XFS_ATTR_OP_FLAGS_SET, &new);
+	if (error)
+		return error;
+
+	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
+
+	return 0;
+}
+
+/* Removes an attribute for an inode as a deferred operation */
+int
+xfs_attr_remove_deferred(
+	struct xfs_inode        *dp,
+	struct xfs_trans	*tp,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	unsigned int		flags)
+{
+
+	struct xfs_attr_item *new;
+
+	int error  = xfs_attr_item_init(dp, tp, name, namelen, flags, NULL, 0,
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
index 23b8308..4643b3f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -328,5 +328,12 @@ bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
+int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
+			  const unsigned char *name, unsigned int namelen,
+			  unsigned int flags, const unsigned char *value,
+			  unsigned int valuelen);
+int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
+			    const unsigned char *name, unsigned int namelen,
+			    unsigned int flags);
 
 #endif	/* __XFS_ATTR_H__ */
-- 
2.7.4

