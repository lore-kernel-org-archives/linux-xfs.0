Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA87A8012
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 04:45:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78FB230406A
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 02:45:39 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id JGiIawBAjzDPNqeL (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 02:45:38 -0800 (PST)
Message-Id: <20131211104526.648135334@bombadil.infradead.org>
Date: Wed, 11 Dec 2013 02:42:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/18] fs: add get_acl helper
References: <20131211104243.148113893@bombadil.infradead.org>
Content-Disposition: inline; filename=0002-fs-add-get_acl-helper.patch
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
To: viro@zeniv.linux.org.uk
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Factor out the code to get an ACL either from the inode or disk from
check_acl, so that it can be used elsewhere later on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/namei.c                |   24 +++---------------------
 fs/posix_acl.c            |   26 ++++++++++++++++++++++++++
 include/linux/posix_acl.h |    2 ++
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c53d3a9..8acd1e8 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -235,27 +235,9 @@ static int check_acl(struct inode *inode, int mask)
 	        return posix_acl_permission(inode, acl, mask & ~MAY_NOT_BLOCK);
 	}
 
-	acl = get_cached_acl(inode, ACL_TYPE_ACCESS);
-
-	/*
-	 * A filesystem can force a ACL callback by just never filling the
-	 * ACL cache. But normally you'd fill the cache either at inode
-	 * instantiation time, or on the first ->get_acl call.
-	 *
-	 * If the filesystem doesn't have a get_acl() function at all, we'll
-	 * just create the negative cache entry.
-	 */
-	if (acl == ACL_NOT_CACHED) {
-	        if (inode->i_op->get_acl) {
-			acl = inode->i_op->get_acl(inode, ACL_TYPE_ACCESS);
-			if (IS_ERR(acl))
-				return PTR_ERR(acl);
-		} else {
-		        set_cached_acl(inode, ACL_TYPE_ACCESS, NULL);
-		        return -EAGAIN;
-		}
-	}
-
+	acl = get_acl(inode, ACL_TYPE_ACCESS);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
 	if (acl) {
 	        int error = posix_acl_permission(inode, acl, mask);
 	        posix_acl_release(acl);
diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 8bd2135..f2c48f8 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -418,3 +418,29 @@ posix_acl_chmod(struct posix_acl **acl, gfp_t gfp, umode_t mode)
 	return err;
 }
 EXPORT_SYMBOL(posix_acl_chmod);
+
+struct posix_acl *get_acl(struct inode *inode, int type)
+{
+	struct posix_acl *acl;
+
+	acl = get_cached_acl(inode, type);
+	if (acl != ACL_NOT_CACHED)
+		return acl;
+
+	if (!IS_POSIXACL(inode))
+		return NULL;
+
+	/*
+	 * A filesystem can force a ACL callback by just never filling the
+	 * ACL cache. But normally you'd fill the cache either at inode
+	 * instantiation time, or on the first ->get_acl call.
+	 *
+	 * If the filesystem doesn't have a get_acl() function at all, we'll
+	 * just create the negative cache entry.
+	 */
+	if (!inode->i_op->get_acl) {
+		set_cached_acl(inode, type, NULL);
+		return ERR_PTR(-EAGAIN);
+	}
+	return inode->i_op->get_acl(inode, type);
+}
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 7931efe..a8d9918 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -175,4 +175,6 @@ static inline void cache_no_acl(struct inode *inode)
 #endif
 }
 
+struct posix_acl *get_acl(struct inode *inode, int type);
+
 #endif  /* __LINUX_POSIX_ACL_H */
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
