Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF2757CC5
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2016 09:11:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B402AC003
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2016 07:11:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Hb2ELCmQgb9Cih80 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 25 Jul 2016 07:11:12 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v24 20/22] vfs: Move check_posix_acl and check_richacl out of
	fs/namei.c
Date: Mon, 25 Jul 2016 16:09:17 +0200
Message-Id: <1469455759-6141-21-git-send-email-agruenba@redhat.com>
In-Reply-To: <1469455759-6141-1-git-send-email-agruenba@redhat.com>
References: <1469455759-6141-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andreas Gruenbacher <agruenba@redhat.com>, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org, Trond Myklebust <trond.myklebust@primarydata.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, linux-ext4@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>

By moving those functions into fs/posix_acl.c and fs/richacl.c, the
ifdefs can be moved into include/linux/posix_acl.h and
include/linux/richacl.h.  This may be seen as a small improvement.

Suggested-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/namei.c                | 72 ++++-------------------------------------------
 fs/posix_acl.c            | 28 ++++++++++++++++++
 fs/richacl.c              | 28 ++++++++++++++++++
 include/linux/posix_acl.h |  5 ++++
 include/linux/richacl.h   |  8 ++++++
 5 files changed, 74 insertions(+), 67 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 48c9958..f1a58d03 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -257,73 +257,6 @@ void putname(struct filename *name)
 		__putname(name);
 }
 
-static int check_richacl(struct inode *inode, int mask)
-{
-#ifdef CONFIG_FS_RICHACL
-	if (mask & MAY_NOT_BLOCK) {
-		struct base_acl *base_acl;
-
-		base_acl = rcu_dereference(inode->i_acl);
-		if (!base_acl)
-			goto no_acl;
-		/* no ->get_richacl() calls in RCU mode... */
-		if (is_uncached_acl(base_acl))
-			return -ECHILD;
-		return richacl_permission(inode, richacl(base_acl),
-					  mask & ~MAY_NOT_BLOCK);
-	} else {
-		struct richacl *acl;
-
-		acl = get_richacl(inode);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		if (acl) {
-			int error = richacl_permission(inode, acl, mask);
-			richacl_put(acl);
-			return error;
-		}
-	}
-no_acl:
-#endif
-	if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
-		    MAY_CHMOD | MAY_SET_TIMES)) {
-		/* File permission bits cannot grant this. */
-		return -EACCES;
-	}
-	return -EAGAIN;
-}
-
-static int check_posix_acl(struct inode *inode, int mask)
-{
-#ifdef CONFIG_FS_POSIX_ACL
-	if (mask & MAY_NOT_BLOCK) {
-		struct base_acl *base_acl;
-
-		base_acl = rcu_dereference(inode->i_acl);
-	        if (!base_acl)
-	                return -EAGAIN;
-		/* no ->get_acl() calls in RCU mode... */
-		if (is_uncached_acl(base_acl))
-			return -ECHILD;
-	        return posix_acl_permission(inode, posix_acl(base_acl),
-					    mask & ~MAY_NOT_BLOCK);
-	} else {
-		struct posix_acl *acl;
-
-		acl = get_acl(inode, ACL_TYPE_ACCESS);
-		if (IS_ERR(acl))
-			return PTR_ERR(acl);
-		if (acl) {
-			int error = posix_acl_permission(inode, acl, mask);
-			posix_acl_release(acl);
-			return error;
-		}
-	}
-#endif
-
-	return -EAGAIN;
-}
-
 /*
  * This does the basic permission checking
  */
@@ -343,6 +276,11 @@ static int acl_permission_check(struct inode *inode, int mask)
 		int error = check_richacl(inode, mask);
 		if (error != -EAGAIN)
 			return error;
+		if (mask & (MAY_DELETE_SELF | MAY_TAKE_OWNERSHIP |
+			    MAY_CHMOD | MAY_SET_TIMES)) {
+			/* File permission bits cannot grant this. */
+			return -EACCES;
+		}
 	}
 	if (likely(uid_eq(current_fsuid(), inode->i_uid)))
 		mode >>= 6;
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 1b685a1..ce2fd35 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -374,6 +374,34 @@ check_perm:
 	return -EACCES;
 }
 
+int check_posix_acl(struct inode *inode, int mask)
+{
+	if (mask & MAY_NOT_BLOCK) {
+		struct base_acl *base_acl;
+
+		base_acl = rcu_dereference(inode->i_acl);
+	        if (!base_acl)
+	                return -EAGAIN;
+		/* no ->get_acl() calls in RCU mode... */
+		if (is_uncached_acl(base_acl))
+			return -ECHILD;
+	        return posix_acl_permission(inode, posix_acl(base_acl),
+					    mask & ~MAY_NOT_BLOCK);
+	} else {
+		struct posix_acl *acl;
+
+		acl = get_acl(inode, ACL_TYPE_ACCESS);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (acl) {
+			int error = posix_acl_permission(inode, acl, mask);
+			posix_acl_release(acl);
+			return error;
+		}
+	}
+	return -EAGAIN;
+}
+
 /*
  * Modify acl when creating a new inode. The caller must ensure the acl is
  * only referenced once.
diff --git a/fs/richacl.c b/fs/richacl.c
index 1945691..ece9d0b 100644
--- a/fs/richacl.c
+++ b/fs/richacl.c
@@ -385,6 +385,34 @@ out:
 }
 EXPORT_SYMBOL_GPL(richacl_permission);
 
+int check_richacl(struct inode *inode, int mask)
+{
+	if (mask & MAY_NOT_BLOCK) {
+		struct base_acl *base_acl;
+
+		base_acl = rcu_dereference(inode->i_acl);
+		if (!base_acl)
+			return -EAGAIN;
+		/* no ->get_richacl() calls in RCU mode... */
+		if (is_uncached_acl(base_acl))
+			return -ECHILD;
+		return richacl_permission(inode, richacl(base_acl),
+					  mask & ~MAY_NOT_BLOCK);
+	} else {
+		struct richacl *acl;
+
+		acl = get_richacl(inode);
+		if (IS_ERR(acl))
+			return PTR_ERR(acl);
+		if (acl) {
+			int error = richacl_permission(inode, acl, mask);
+			richacl_put(acl);
+			return error;
+		}
+	}
+	return -EAGAIN;
+}
+
 /*
  * Note: functions like richacl_allowed_to_who(), richacl_group_class_allowed(),
  * and richacl_compute_max_masks() iterate through the entire acl in reverse
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index daf84fa..2b62017 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -94,6 +94,7 @@ extern struct posix_acl *get_posix_acl(struct inode *, int);
 extern int set_posix_acl(struct inode *, int, struct posix_acl *);
 
 #ifdef CONFIG_FS_POSIX_ACL
+extern int check_posix_acl(struct inode *, int);
 extern int posix_acl_chmod(struct inode *, umode_t);
 extern int posix_acl_create(struct inode *, umode_t *, struct posix_acl **,
 		struct posix_acl **);
@@ -112,6 +113,10 @@ static inline void cache_no_acl(struct inode *inode)
 	inode->i_default_acl = NULL;
 }
 #else
+static inline int check_posix_acl(struct inode *inode, int mask) {
+	return -EAGAIN;
+}
+
 static inline int posix_acl_chmod(struct inode *inode, umode_t mode)
 {
 	return 0;
diff --git a/include/linux/richacl.h b/include/linux/richacl.h
index 7530920..368e918 100644
--- a/include/linux/richacl.h
+++ b/include/linux/richacl.h
@@ -207,4 +207,12 @@ extern struct richacl *richacl_inherit(const struct richacl *, int);
 extern struct richacl *richacl_create(umode_t *, struct inode *);
 extern int set_richacl(struct inode *, struct richacl *);
 
+#ifdef CONFIG_FS_RICHACL
+extern int check_richacl(struct inode *, int);
+#else
+static inline int check_richacl(struct inode *inode, int mask) {
+	return -EAGAIN;
+}
+#endif  /* CONFIG_FS_RICHACL */
+
 #endif /* __RICHACL_H */
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
