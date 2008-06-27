Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 05:43:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5RCgvE5002216
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 05:42:58 -0700
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix disabled XFS POSIX ACL handling
Date: Fri, 27 Jun 2008 13:43:54 +0100
Message-ID: <20080627124354.18978.72867.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: hch@infradead.org, tes@sgi.com, lachlan@sgi.com
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, dhowells@redhat.com

Fix XFS POSIX ACL handling when it's not enabled.  xfs_decode_acl() refers to
return types that aren't defined under those circumstances.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/xfs/linux-2.6/xfs_xattr.c |   14 --------------
 fs/xfs/xfs_acl.c             |   13 +++++++++++++
 fs/xfs/xfs_acl.h             |    2 ++
 3 files changed, 15 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/linux-2.6/xfs_xattr.c b/fs/xfs/linux-2.6/xfs_xattr.c
index b4acb68..fe93f41 100644
--- a/fs/xfs/linux-2.6/xfs_xattr.c
+++ b/fs/xfs/linux-2.6/xfs_xattr.c
@@ -30,20 +30,6 @@
 
 
 /*
- * ACL handling.  Should eventually be moved into xfs_acl.c
- */
-
-static int
-xfs_decode_acl(const char *name)
-{
-	if (strcmp(name, "posix_acl_access") == 0)
-		return _ACL_TYPE_ACCESS;
-	else if (strcmp(name, "posix_acl_default") == 0)
-		return _ACL_TYPE_DEFAULT;
-	return -EINVAL;
-}
-
-/*
  * Get system extended attributes which at the moment only
  * includes Posix ACLs.
  */
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 93057af..24bcbf5 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -51,6 +51,19 @@ kmem_zone_t *xfs_acl_zone;
 
 
 /*
+ * ACL handling.
+ */
+int
+xfs_decode_acl(const char *name)
+{
+	if (strcmp(name, "posix_acl_access") == 0)
+		return _ACL_TYPE_ACCESS;
+	else if (strcmp(name, "posix_acl_default") == 0)
+		return _ACL_TYPE_DEFAULT;
+	return -EINVAL;
+}
+
+/*
  * Test for existence of access ACL attribute as efficiently as possible.
  */
 int
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index 332a772..7bf8ef5 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -57,6 +57,7 @@ extern struct kmem_zone *xfs_acl_zone;
 		(zone) = kmem_zone_init(sizeof(xfs_acl_t), (name))
 #define xfs_acl_zone_destroy(zone)	kmem_zone_destroy(zone)
 
+extern int xfs_decode_acl(const char *);
 extern int xfs_acl_inherit(bhv_vnode_t *, mode_t mode, xfs_acl_t *);
 extern int xfs_acl_iaccess(struct xfs_inode *, mode_t, cred_t *);
 extern int xfs_acl_vtoacl(bhv_vnode_t *, xfs_acl_t *, xfs_acl_t *);
@@ -80,6 +81,7 @@ extern int xfs_acl_vremove(bhv_vnode_t *, int);
 #define _ACL_FREE(a)		((a)? kmem_zone_free(xfs_acl_zone, (a)):(void)0)
 
 #else
+#define xfs_decode_acl(name)	(-EINVAL)
 #define xfs_acl_zone_init(zone,name)
 #define xfs_acl_zone_destroy(zone)
 #define xfs_acl_vset(v,p,sz,t)	(-EOPNOTSUPP)
