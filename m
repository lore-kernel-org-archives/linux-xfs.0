Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D06C2BA1B
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EE992078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Siisx7Bz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbgDCWKJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:10:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45468 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgDCWKJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:10:09 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033MA8Oc083000
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=5iZ3kZtH3a6tQNE8l5DNVTs/K3RhAi61CQT1fTfrwd4=;
 b=Siisx7BzDvVKTxoEfnS2ojaeG8vkh/JFp2z7PA0MsRW6OBEM746v85jAlW+SRqJ054j2
 XUhSr6qv0CJXWxMtcVjvi15PB3bWkWuaJp1uUDwUk1nxxMyn/e4l59E8Dt7ZIV0I5N+t
 ZC/2/bs1mA4ZX+JhGkpD/oisJESiN/3odJvF+gTwEbeyWEd6xd4mxh5FvG4FzjwDcPNT
 zJoQYRMeFmDr08h/LDUoD5oIGWpLmzAgBqZPsySA8fH4xmKgzXUEdAJXGhkiPwx0KWwc
 XhyXHPdF+R1aZMNVx/qaseK+FvO7bQ+e89gHDKp5QSvqchhFpMDy647vk0f91v+BDg9P Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 303cevkdhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7A89170961
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:07 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 302g2p2bs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:07 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MA7aq009854
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:07 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:06 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 09/39] xfsprogs: remove ATTR_KERNOVAL
Date:   Fri,  3 Apr 2020 15:09:28 -0700
Message-Id: <20200403220958.4944-10-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 adultscore=0
 clxscore=1015 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We can just pass down the Linux convention of a zero valuelen to just
query for the existance of an attribute to the low-level code instead.
The use in the legacy xfs_attr_list code only used by the ioctl
interface was already dead code, as the callers check that the flag
is not present.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c        |  8 ++++----
 libxfs/xfs_attr.h        |  4 +---
 libxfs/xfs_attr_leaf.c   | 14 +++++++-------
 libxfs/xfs_attr_remote.c |  2 +-
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 72c03f67..db724af 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -94,9 +94,9 @@ xfs_attr_get_ilocked(
 /*
  * Retrieve an extended attribute by name, and its value if requested.
  *
- * If ATTR_KERNOVAL is set in args->flags, then the caller does not want the
- * value, just an indication whether the attribute exists and the size of the
- * value if it exists. The size is returned in args.valuelen.
+ * If args->valuelen is zero, then the caller does not want the value, just an
+ * indication whether the attribute exists and the size of the value if it
+ * exists. The size is returned in args.valuelen.
  *
  * If the attribute is found, but exceeds the size limit set by the caller in
  * args->valuelen, return -ERANGE with the size of the attribute that was found
@@ -115,7 +115,7 @@ xfs_attr_get(
 	uint			lock_mode;
 	int			error;
 
-	ASSERT((args->flags & (ATTR_ALLOC | ATTR_KERNOVAL)) || args->value);
+	ASSERT((args->flags & ATTR_ALLOC) || !args->valuelen || args->value);
 
 	XFS_STATS_INC(args->dp->i_mount, xs_attr_get);
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index b8c4ed2..fe064cd 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -34,12 +34,11 @@ struct xfs_attr_list_context;
 #define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
 
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
-#define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
 #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
 
 #define ATTR_KERNEL_FLAGS \
-	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
+	(ATTR_KERNOTIME | ATTR_ALLOC)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
@@ -49,7 +48,6 @@ struct xfs_attr_list_context;
 	{ ATTR_CREATE,		"CREATE" }, \
 	{ ATTR_REPLACE,		"REPLACE" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
-	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
 	{ ATTR_ALLOC,		"ALLOC" }
 
 /*
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 541a1ff..8e07e2a 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -461,7 +461,7 @@ xfs_attr_copy_value(
 	/*
 	 * No copy if all we have to do is get the length
 	 */
-	if (args->flags & ATTR_KERNOVAL) {
+	if (!args->valuelen) {
 		args->valuelen = valuelen;
 		return 0;
 	}
@@ -827,9 +827,9 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 /*
  * Retrieve the attribute value and length.
  *
- * If ATTR_KERNOVAL is specified, only the length needs to be returned.
- * Unlike a lookup, we only return an error if the attribute does not
- * exist or we can't retrieve the value.
+ * If args->valuelen is zero, only the length needs to be returned.  Unlike a
+ * lookup, we only return an error if the attribute does not exist or we can't
+ * retrieve the value.
  */
 int
 xfs_attr_shortform_getvalue(
@@ -2441,9 +2441,9 @@ xfs_attr3_leaf_lookup_int(
  * Get the value associated with an attribute name from a leaf attribute
  * list structure.
  *
- * If ATTR_KERNOVAL is specified, only the length needs to be returned.
- * Unlike a lookup, we only return an error if the attribute does not
- * exist or we can't retrieve the value.
+ * If args->valuelen is zero, only the length needs to be returned.  Unlike a
+ * lookup, we only return an error if the attribute does not exist or we can't
+ * retrieve the value.
  */
 int
 xfs_attr3_leaf_getvalue(
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index b2a0156..a9a48b30 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -396,7 +396,7 @@ xfs_attr_rmtval_get(
 
 	trace_xfs_attr_rmtval_get(args);
 
-	ASSERT(!(args->flags & ATTR_KERNOVAL));
+	ASSERT(args->valuelen != 0);
 	ASSERT(args->rmtvaluelen == args->valuelen);
 
 	valuelen = args->rmtvaluelen;
-- 
2.7.4

