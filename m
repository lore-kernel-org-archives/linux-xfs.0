Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 14DC97FBB
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 10:21:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F0F178F8066
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:21:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AyzUhkB48RC6nHdD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:21:08 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v11 23/48] xfs: Make xfs_set_mode non-static
Date: Fri, 16 Oct 2015 17:18:01 +0200
Message-Id: <1445008706-15115-24-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
References: <1445008706-15115-1-git-send-email-agruenba@redhat.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org

Make xfs_set_mode non-static and move it from xfs_acl.c into xfs_inode.c.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xfs/xfs_acl.c   | 18 ------------------
 fs/xfs/xfs_inode.c | 24 ++++++++++++++++++++++++
 fs/xfs/xfs_inode.h |  2 ++
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index e87fd3f..7b03383 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -232,24 +232,6 @@ __xfs_set_acl(struct inode *inode, int type, struct posix_acl *acl)
 }
 
 static int
-xfs_set_mode(struct inode *inode, umode_t mode)
-{
-	int error = 0;
-
-	if (mode != inode->i_mode) {
-		struct iattr iattr;
-
-		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
-		iattr.ia_mode = mode;
-		iattr.ia_ctime = current_fs_time(inode->i_sb);
-
-		error = xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
-	}
-
-	return error;
-}
-
-static int
 xfs_acl_exists(struct inode *inode, unsigned char *name)
 {
 	int len = XFS_ACL_MAX_SIZE(XFS_M(inode->i_sb));
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index dc40a6d..644fa04 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3587,3 +3587,27 @@ xfs_iflush_int(
 corrupt_out:
 	return -EFSCORRUPTED;
 }
+
+/*
+ * Set an inode's file mode.
+ *
+ * Called when updating an inode's file mode as part of setting an ACL only.
+ * The VFS goes through the setattr inode operation instead.
+ */
+int
+xfs_set_mode(struct inode *inode, umode_t mode)
+{
+	int error = 0;
+
+	if (mode != inode->i_mode) {
+		struct iattr iattr;
+
+		iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
+		iattr.ia_mode = mode;
+		iattr.ia_ctime = current_fs_time(inode->i_sb);
+
+		error = xfs_setattr_nonsize(XFS_I(inode), &iattr, XFS_ATTR_NOACL);
+	}
+
+	return error;
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index ca9e119..7b22db0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -424,6 +424,8 @@ int		xfs_dir_ialloc(struct xfs_trans **, struct xfs_inode *, umode_t,
 int		xfs_droplink(struct xfs_trans *, struct xfs_inode *);
 int		xfs_bumplink(struct xfs_trans *, struct xfs_inode *);
 
+int		xfs_set_mode(struct inode *, umode_t);
+
 /* from xfs_file.c */
 enum xfs_prealloc_flags {
 	XFS_PREALLOC_SET	= (1 << 1),
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
