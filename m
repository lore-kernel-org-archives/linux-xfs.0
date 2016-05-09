Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 499A57CB5
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 17:03:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4729AC008
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 15:03:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mCwcbCyVbPWU87N9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 15:03:25 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v21 03/22] vfs: Add MAY_DELETE_SELF and MAY_DELETE_CHILD
	permission flags
Date: Tue, 10 May 2016 00:02:36 +0200
Message-Id: <1462831375-23017-4-git-send-email-agruenba@redhat.com>
In-Reply-To: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
References: <1462831375-23017-1-git-send-email-agruenba@redhat.com>
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

Normally, deleting a file requires MAY_WRITE access to the parent
directory.  With richacls, a file may be deleted with MAY_DELETE_CHILD access
to the parent directory or with MAY_DELETE_SELF access to the file.

To support that, pass the MAY_DELETE_CHILD mask flag to inode_permission()
when checking for delete access inside a directory, and MAY_DELETE_SELF
when checking for delete access to a file itelf.

The MAY_DELETE_SELF permission overrides the sticky directory check.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: J. Bruce Fields <bfields@redhat.com>
Reviewed-by: Steve French <steve.french@primarydata.com>
---
 fs/namei.c         | 20 ++++++++++++--------
 include/linux/fs.h |  2 ++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b013950..858ed96 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -453,9 +453,9 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
  * this, letting us set arbitrary permissions for filesystem access without
  * changing the "normal" UIDs which are used for other things.
  *
- * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FILE, or
- * MAY_CREATE_DIR are set.  That way, file systems that don't support these
- * permissions will check for MAY_WRITE instead.
+ * MAY_WRITE must be set in @mask whenever MAY_APPEND, MAY_CREATE_FILE,
+ * MAY_CREATE_DIR, or MAY_DELETE_CHILD are set.  That way, file systems that
+ * don't support these permissions will check for MAY_WRITE instead.
  */
 int inode_permission(struct inode *inode, int mask)
 {
@@ -2603,14 +2603,18 @@ static int may_delete_or_replace(struct inode *dir, struct dentry *victim,
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(dir, victim, AUDIT_TYPE_CHILD_DELETE);
 
-	error = inode_permission(dir, mask);
+	error = inode_permission(dir, mask | MAY_WRITE | MAY_DELETE_CHILD);
+	if (!error && check_sticky(dir, inode))
+		error = -EPERM;
+	if (error && IS_RICHACL(inode) &&
+	    inode_permission(inode, MAY_DELETE_SELF) == 0 &&
+	    inode_permission(dir, mask) == 0)
+		error = 0;
 	if (error)
 		return error;
 	if (IS_APPEND(dir))
 		return -EPERM;
-
-	if (check_sticky(dir, inode) || IS_APPEND(inode) ||
-	    IS_IMMUTABLE(inode) || IS_SWAPFILE(inode))
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode) || IS_SWAPFILE(inode))
 		return -EPERM;
 	if (isdir) {
 		if (!d_is_dir(victim))
@@ -2628,7 +2632,7 @@ static int may_delete_or_replace(struct inode *dir, struct dentry *victim,
 
 static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 {
-	return may_delete_or_replace(dir, victim, isdir, MAY_WRITE | MAY_EXEC);
+	return may_delete_or_replace(dir, victim, isdir, MAY_EXEC);
 }
 
 static int may_replace(struct inode *dir, struct dentry *victim, bool isdir)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0b6d5ff..0807a9c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -87,6 +87,8 @@ typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
 #define MAY_NOT_BLOCK		0x00000080
 #define MAY_CREATE_FILE		0x00000100
 #define MAY_CREATE_DIR		0x00000200
+#define MAY_DELETE_CHILD	0x00000400
+#define MAY_DELETE_SELF		0x00000800
 
 /*
  * flags in file.f_mode.  Note that FMODE_READ and FMODE_WRITE must correspond
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
