Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67C09FC6197
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37A6621848
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 01:29:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mxFYW0Hf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbfKGB3z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 20:29:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:42976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbfKGB3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 20:29:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SuPJ169964
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=ygYFoQLIamJ6/oUvnapd7ePXR3xXiaYKgWyX0YxFxYI=;
 b=mxFYW0HfvWrnb5irV+5Z1IwbLwcTvJQDxMzGrK9i6cOe5vicYI7/+wZQw12MArObgcul
 GNJ+QyBsb07rrJoguXoDR6glPUZv3SWa0dQcqPN/sCaDJ1nVBO1iciiCxcthtFwhh/5C
 p7KtlixekIwdIIcWTkR/mFs5AK30ZRnfwQhkT9mxlcMsXNqjKopX//bSj/+35BBCOa6S
 mF5YkbcxLdK5fS7O1hpbAUwrIIeIILf/PeBcfA0ip65owRI0RaLrvnZfKeIS6WYVIjXn
 49TuBgJIUsnsweNrH78M6Cbltx0KGOIeBIqdCX9OmHsfzZb83wDzk+8zVLPJ/oNcqyJL tg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w41w0tq1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA71SqL0174279
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w41w8ewg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 01:29:51 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA71TpWu011799
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 01:29:51 GMT
Received: from localhost.localdomain (/67.1.205.161)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 17:29:51 -0800
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 02/17] xfsprogs: Replace attribute parameters with struct xfs_name
Date:   Wed,  6 Nov 2019 18:29:30 -0700
Message-Id: <20191107012945.22941-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107012945.22941-1-allison.henderson@oracle.com>
References: <20191107012945.22941-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch replaces the attribute name and length parameters with a
single struct xfs_name parameter.  This helps to clean up the numbers of
parameters being passed around and pre-simplifies the code some.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 db/attrset.c         | 12 +++++++++---
 libxfs/libxfs_priv.h | 12 +++++-------
 libxfs/xfs_attr.c    | 22 +++++++++-------------
 libxfs/xfs_attr.h    | 12 +++++-------
 4 files changed, 28 insertions(+), 30 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 5c0ec6e9..f606d0a 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -68,6 +68,7 @@ attr_set_f(
 {
 	xfs_inode_t	*ip = NULL;
 	char		*name, *value, *sp;
+	struct xfs_name	xname;
 	int		c, valuelen = 0, flags = 0;
 
 	if (cur_typ == NULL) {
@@ -146,8 +147,10 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
-				(unsigned char *)value, valuelen, flags)) {
+	xname.name = name;
+	xname.len = strlen(name);
+	if (libxfs_attr_set(ip, &xname, (unsigned char *)value, valuelen,
+			    flags)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
@@ -172,6 +175,7 @@ attr_remove_f(
 {
 	xfs_inode_t	*ip = NULL;
 	char		*name;
+	struct xfs_name	xname;
 	int		c, flags = 0;
 
 	if (cur_typ == NULL) {
@@ -222,7 +226,9 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, (unsigned char *)name, strlen(name), flags)) {
+	xname.name = name;
+	xname.len = strlen(name);
+	if (libxfs_attr_remove(ip, &xname, flags)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index c06984b..e1a3c11 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -609,13 +609,11 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 /* Keep static checkers quiet about nonstatic functions by exporting */
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-                 size_t namelen, unsigned char *value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-                 size_t namelen, unsigned char *value, int valuelen, int flags);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char *value, int *valuelenp, int flags);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 158afe3..742575c 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -60,8 +60,7 @@ STATIC int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	int			flags)
 {
 
@@ -73,8 +72,8 @@ xfs_attr_args_init(
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
 	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
+	args->name = name->name;
+	args->namelen = name->len;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -119,8 +118,7 @@ xfs_attr_get_ilocked(
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
 	int			*valuelenp,
 	int			flags)
@@ -134,7 +132,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
+	error = xfs_attr_args_init(&args, ip, name, flags);
 	if (error)
 		return error;
 
@@ -305,8 +303,7 @@ xfs_attr_remove_args(
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -322,7 +319,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name, flags);
 	if (error)
 		return error;
 
@@ -410,8 +407,7 @@ out_trans_cancel:
 int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -423,7 +419,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name, flags);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 69493b5..ad62d3f 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -142,14 +142,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char *value, int *valuelenp, int flags);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-- 
2.7.4

