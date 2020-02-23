Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E8DC35673
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A98A920707
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lSRFAf9X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgBWCGE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbgBWCGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N219wD188896
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=t1hp1TcVcoOJrPcrMQC+jL3ZQAvzCk9eOwPQqE/O9v8=;
 b=lSRFAf9XCAUX/q+UAhtdC0FOg1Kvi4EQvIniOpkkiQ2wMbsl5SSTt357Gv4KpSQ4pnKo
 UfZaNeMcXOM0QYntjIlFnXkRqnHTfopg+s2Vo2hD9rZlDEwDvFsBLRizs4GO4regtHHB
 a3TJCh7H1JQV17TinkFazyxlsARi+Z4c6kGOSxxoYkuF2QuYSDr7BUAO5ro+Jjef7lUd
 dVT7beRLAdO0sI5w1y3l3jSM8G+BWxr69kUm+mVU04PDkRQpyHV2g36hKMMeJ1DysnEU
 ez6SAMSHN88nsffpJPRUHIdw0fzEuy+T1N8hRvNT7iTwnQx4xYHmFLZDxL0uimKOQVOw QQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2yauqu21ww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1we3J054527
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2ybe38mcs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 01N260kw013060
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:00 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:05:59 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 01/20] xfsprogs: Remove all strlen in all xfs_attr_* functions for attr names.
Date:   Sat, 22 Feb 2020 19:05:35 -0700
Message-Id: <20200223020554.1731-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 adultscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This helps to pre-simplify the extra handling of the null terminator in delayed
operations which use memcpy rather than strlen.  Later when we introduce parent
pointers, attribute names will become binary, so strlen will not work at all.
Removing uses of strlen now will help reduce complexities later

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/attrset.c         |  4 ++--
 libxfs/libxfs_priv.h |  9 +++++----
 libxfs/xfs_attr.c    | 12 ++++++++----
 libxfs/xfs_attr.h    |  8 +++++---
 4 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 5697250..5c0ec6e9 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -146,7 +146,7 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name,
+	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
 				(unsigned char *)value, valuelen, flags)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
@@ -222,7 +222,7 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, (unsigned char *)name, flags)) {
+	if (libxfs_attr_remove(ip, (unsigned char *)name, strlen(name), flags)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index d944efc0..c25c5de 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -610,11 +610,12 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-                unsigned char **value, int *valuelenp, int flags);
+		 size_t namelen, unsigned char **value, int *valuelenp,
+		 int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-                 unsigned char *value, int valuelen, int flags);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
-
+		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
+		    size_t namelen, int flags);
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ada1b5f..925094d 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -61,6 +61,7 @@ xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 
@@ -73,7 +74,7 @@ xfs_attr_args_init(
 	args->dp = dp;
 	args->flags = flags;
 	args->name = name;
-	args->namelen = strlen((const char *)name);
+	args->namelen = namelen;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -138,6 +139,7 @@ int
 xfs_attr_get(
 	struct xfs_inode	*ip,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		**value,
 	int			*valuelenp,
 	int			flags)
@@ -153,7 +155,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, flags);
+	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -337,6 +339,7 @@ int
 xfs_attr_set(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -352,7 +355,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
@@ -441,6 +444,7 @@ int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
 	const unsigned char	*name,
+	size_t			namelen,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -452,7 +456,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, flags);
+	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 94badfa..106a2f2 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -145,11 +145,13 @@ int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 unsigned char **value, int *valuelenp, int flags);
+		 size_t namelen, unsigned char **value, int *valuelenp,
+		 int flags);
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 unsigned char *value, int valuelen, int flags);
+		 size_t namelen, unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
+		    size_t namelen, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-- 
2.7.4

