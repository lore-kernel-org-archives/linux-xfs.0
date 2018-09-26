Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55480 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbeIZQiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANhTb087676
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:53 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2mndpphh7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPpGx013257
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPpER032168
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 26/30] xfsprogs: Add xfs_verify_pptr
Date: Wed, 26 Sep 2018 03:23:29 -0700
Message-Id: <1537957413-10630-27-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Attribute names of parent pointers are not strings.  So we
need to modify attr_namecheck to verify parent pointer
records when the XFS_ATTR_PARENT flag is set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 repair/attr_repair.c | 21 +++++++++++----------
 repair/da_util.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 repair/da_util.h     | 12 ++++++++++++
 3 files changed, 66 insertions(+), 10 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 1d04500..df27fa4 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -292,13 +292,14 @@ process_shortform_attr(
 			}
 		}
 
-		/* namecheck checks for / and null terminated for file names.
-		 * attributes names currently follow the same rules.
-		*/
-		if (namecheck((char *)&currententry->nameval[0],
-						currententry->namelen))  {
+		/* namecheck checks for / and null terminated for file names,
+		 * or verifies parent pointer record in the case of a parent
+		 * pointer attribute.
+		 */
+		if (attr_namecheck(mp, (char *)&currententry->nameval[0],
+		       currententry->namelen, currententry->flags))  {
 			do_warn(
-	_("entry contains illegal character in shortform attribute name\n"));
+	_("entry contains illegal shortform attribute name\n"));
 			junkit = 1;
 		}
 
@@ -458,8 +459,8 @@ process_leaf_attr_local(
 	xfs_attr_leaf_name_local_t *local;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
-	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
-							local->namelen)) {
+	if (attr_namecheck(mp, (char *)&local->nameval[0],
+	       local->namelen, entry->flags)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -513,8 +514,8 @@ process_leaf_attr_remote(
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
-	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
-						remotep->namelen) ||
+	if (attr_namecheck(mp, (char *)&remotep->name[0],
+				remotep->namelen, entry->flags) ||
 			be32_to_cpu(entry->hashval) !=
 				libxfs_da_hashname((unsigned char *)&remotep->name[0],
 						remotep->namelen) ||
diff --git a/repair/da_util.c b/repair/da_util.c
index 1450767..d94a31c 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -13,6 +13,49 @@
 #include "da_util.h"
 
 /*
+ * Verify parent pointer attribute is valid.
+ * Return 0 on success or 1 on failure
+ */
+int
+xfs_verify_pptr(struct xfs_mount *mp, struct xfs_parent_name_rec *rec)
+{
+	xfs_ino_t p_ino = (xfs_ino_t)be64_to_cpu(rec->p_ino);
+	xfs_dir2_dataptr_t p_diroffset =
+			(xfs_dir2_dataptr_t)be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return 1;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return 1;
+
+	return 0;
+}
+
+/*
+ * Check if an attribute name is valid
+ * Returns 0 on success and 1 on failure
+ */
+int
+attr_namecheck(struct xfs_mount *mp, char *name, int length, int flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return 1;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	if (length == 0)
+		return 1;
+
+	/*
+	 * namecheck checks for / and null terminated for file names.
+	 * attributes names currently follow the same rules.
+	 */
+	return namecheck(name, length);
+}
+
+/*
  * takes a name and length (name need not be null-terminated)
  * and returns 1 if the name contains a '/' or a \0, returns 0
  * otherwise
diff --git a/repair/da_util.h b/repair/da_util.h
index d36dfd0..53ba843 100644
--- a/repair/da_util.h
+++ b/repair/da_util.h
@@ -25,6 +25,18 @@ typedef struct da_bt_cursor {
 } da_bt_cursor_t;
 
 int
+xfs_verify_pptr(
+	struct xfs_mount *mp,
+	struct xfs_parent_name_rec *rec);
+
+int
+attr_namecheck(
+	struct xfs_mount	*mp,
+	char			*name,
+	int			length,
+	int			flags);
+
+int
 namecheck(
 	char		*name,
 	int		length);
-- 
2.7.4
