Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34028 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932180AbeFJFKW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:22 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A56IvV094976
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:22 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2jg7hwstd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:22 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5ALK9004986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:21 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5A5AKR6030493
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:20 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 23/27] xfsprogs: Do not use namechecks on parent pointers
Date: Sat,  9 Jun 2018 22:07:48 -0700
Message-Id: <1528607272-11122-24-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Attribute names of parent pointers are not strings.  So
avoid doing namechecks for these attributes.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 repair/attr_repair.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 8b1b8a7..b8b0768 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -308,8 +308,9 @@ process_shortform_attr(
 		/* namecheck checks for / and null terminated for file names.
 		 * attributes names currently follow the same rules.
 		*/
-		if (namecheck((char *)&currententry->nameval[0],
-						currententry->namelen))  {
+		if (!(currententry->flags & XFS_ATTR_PARENT) &&
+			namecheck((char *)&currententry->nameval[0],
+			currententry->namelen))  {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
 			junkit = 1;
@@ -470,8 +471,9 @@ process_leaf_attr_local(
 	xfs_attr_leaf_name_local_t *local;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
-	if (local->namelen == 0 || namecheck((char *)&local->nameval[0],
-							local->namelen)) {
+	if (!(entry->flags & XFS_ATTR_PARENT) &&
+		(local->namelen == 0 || namecheck((char *)&local->nameval[0],
+		local->namelen))) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -525,13 +527,15 @@ process_leaf_attr_remote(
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
 
-	if (remotep->namelen == 0 || namecheck((char *)&remotep->name[0],
-						remotep->namelen) ||
+	if (!(entry->flags & XFS_ATTR_PARENT) &&
+			(remotep->namelen == 0 ||
+			namecheck((char *)&remotep->name[0],
+				remotep->namelen) ||
 			be32_to_cpu(entry->hashval) !=
 				libxfs_da_hashname((unsigned char *)&remotep->name[0],
 						remotep->namelen) ||
 			be32_to_cpu(entry->hashval) < last_hashval ||
-			be32_to_cpu(remotep->valueblk) == 0) {
+			be32_to_cpu(remotep->valueblk) == 0)) {
 		do_warn(
 	_("inconsistent remote attribute entry %d in attr block %u, ino %" PRIu64 "\n"), i, da_bno, ino);
 		return -1;
-- 
2.7.4

