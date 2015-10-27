Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F4B97F5F
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 20:24:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C825EAC002
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 18:23:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uOoTTdH9veSlsxcD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 26 Oct 2015 18:23:56 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] xfs_repair: Check for invalid ACL types
Date: Tue, 27 Oct 2015 02:23:52 +0100
Message-Id: <1445909032-10974-1-git-send-email-agruenba@redhat.com>
References: <1445627828-14661-1-git-send-email-agruenba@redhat.com>
	<1445627828-14661-5-git-send-email-agruenba@redhat.com>
	<20151026225520.GK8773@dastard>
In-Reply-To: <20151026225520.GK8773@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Filesystems with the richacl feature are not supposed to contain POSIX
ACLs, and filesystems without the richacl feature are not supposed to
contain richacls.  Fix by removing unexpected attributes.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 repair/attr_repair.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index e7f03a8..8ded369 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -160,6 +160,8 @@ valuecheck(
 	int		namelen,
 	int		valuelen)
 {
+	const bool feature_richacl = xfs_sb_has_incompat_feature(&mp->m_sb,
+		XFS_SB_FEAT_INCOMPAT_RICHACL);
 	/* for proper alignment issues, get the structs and memmove the values */
 	xfs_mac_label_t macl;
 	void *valuep;
@@ -169,6 +171,13 @@ valuecheck(
 	     strncmp(namevalue, SGI_ACL_FILE, SGI_ACL_FILE_SIZE) == 0) ||
 	    (namelen == SGI_ACL_DEFAULT_SIZE &&
 	     strncmp(namevalue, SGI_ACL_DEFAULT, SGI_ACL_DEFAULT_SIZE) == 0)) {
+		if (feature_richacl) {
+			do_warn(_("filesystem feature %s set "
+				  "but attribute %.*s exists\n"),
+				"richacl", namelen, namevalue);
+			return 1;
+		}
+
 		if (value == NULL) {
 			valuep = malloc(valuelen);
 			if (!valuep)
@@ -211,6 +220,13 @@ valuecheck(
 		 strncmp(namevalue, XATTR_RICHACL, strlen(XATTR_RICHACL)) == 0) {
 		struct richacl *acl;
 
+		if (!feature_richacl) {
+			do_warn(_("filesystem feature %s not set "
+				  "but attribute %.*s exists\n"),
+				"richacl", namelen, namevalue);
+			return 1;
+		}
+
 		if (value == NULL) {
 			valuep = malloc(valuelen);
 			if (!valuep)
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
