Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C50537F4E
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 22:29:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A7C778F8050
	for <xfs@oss.sgi.com>; Wed, 13 May 2015 20:29:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TySeFxquI71GUYVj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 13 May 2015 20:29:46 -0700 (PDT)
Message-ID: <555416A6.4020401@redhat.com>
Date: Wed, 13 May 2015 22:29:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: properly detect reserved attribute names
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Zach Brown <zab@zabbo.net>

This function in xfs_repair tries to make sure that if an attr
name reserved for acls exists in the root namespace, then its
value is a valid acl.

However, because it only compares up to the length of the
reserved name, superstrings may match and cause false positive
xfs_repair errors.

Ensure that both the length and the content match before
flagging it as an error.

Spotted-by: Zach Brown <zab@zabbo.net>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index 27442c4..89a5bbf 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -747,9 +747,10 @@ valuecheck(
 	void *valuep;
 	int clearit = 0;
 
-	if ((strncmp(namevalue, SGI_ACL_FILE, SGI_ACL_FILE_SIZE) == 0) ||
-			(strncmp(namevalue, SGI_ACL_DEFAULT,
-				SGI_ACL_DEFAULT_SIZE) == 0)) {
+	if ((namelen == SGI_ACL_FILE_SIZE &&
+	     strncmp(namevalue, SGI_ACL_FILE, SGI_ACL_FILE_SIZE) == 0) ||
+	    (namelen == SGI_ACL_DEFAULT_SIZE &&
+	     strncmp(namevalue, SGI_ACL_DEFAULT, SGI_ACL_DEFAULT_SIZE) == 0)) {
 		if (value == NULL) {
 			valuep = malloc(valuelen);
 			if (!valuep)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
