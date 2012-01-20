Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0KKYxPv125561 for <xfs@oss.sgi.com>; Fri, 20 Jan 2012 14:34:59 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id dujsbiA8xtzK7uJj for <xfs@oss.sgi.com>;
	Fri, 20 Jan 2012 12:34:57 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/8] ext4: Protect ext4_page_mkwrite & ext4_setattr with
	sb_start_write - sb_end_write
Date: Fri, 20 Jan 2012 21:34:41 +0100
Message-Id: <1327091686-23177-4-git-send-email-jack@suse.cz>
In-Reply-To: <1327091686-23177-1-git-send-email-jack@suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-ext4@vger.kernel.org

Since ext4_page_mkwrite() calls into __block_page_mkwrite() it has to
provide freezing protection on it's own. Also ext4_setattr() needs protection
because ext4_truncate() can modify last page of the file.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 848f436..05d6328 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4225,6 +4225,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 	if (error)
 		return error;
 
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
 	if (is_quota_modification(inode, attr))
 		dquot_initialize(inode);
 	if ((ia_valid & ATTR_UID && attr->ia_uid != inode->i_uid) ||
@@ -4327,6 +4328,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 		rc = ext4_acl_chmod(inode);
 
 err_out:
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 	ext4_std_error(inode->i_sb, error);
 	if (!error)
 		error = rc;
@@ -4733,11 +4735,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	get_block_t *get_block;
 	int retries = 0;
 
-	/*
-	 * This check is racy but catches the common case. We rely on
-	 * __block_page_mkwrite() to do a reliable check.
-	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	sb_start_write(inode->i_sb, SB_FREEZE_WRITE);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
@@ -4805,5 +4803,6 @@ retry_alloc:
 out_ret:
 	ret = block_page_mkwrite_return(ret);
 out:
+	sb_end_write(inode->i_sb, SB_FREEZE_WRITE);
 	return ret;
 }
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
