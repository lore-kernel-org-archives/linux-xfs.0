Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 669737F5D
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 04:24:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5560F30404E
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2014 02:24:08 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id dL2D5Dhv5O9ws9xp (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Nov 2014 02:24:07 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v4 5/7] vfs: add find_active_inode_nowait() function
Date: Wed, 26 Nov 2014 05:23:55 -0500
Message-Id: <1416997437-26092-6-git-send-email-tytso@mit.edu>
In-Reply-To: <1416997437-26092-1-git-send-email-tytso@mit.edu>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
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
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

Add a new function find_active_inode_nowait() which will never block.
If there is an inode being freed or is still being initialized, this
function will return NULL instead of blocking waiting for an inode to
be freed or to finish initializing.  Hence, a negative return from
this function does not mean that inode number is free for use.  It is
useful for callers that want to opportunistically do some work on an
inode only if it is present and available in the cache, and where
blocking is not an option.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/inode.c         | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  2 ++
 2 files changed, 38 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index b2fea60..0b4c6ae 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1283,6 +1283,42 @@ struct inode *ilookup(struct super_block *sb, unsigned long ino)
 }
 EXPORT_SYMBOL(ilookup);
 
+/**
+ * find_active_inode_nowait - find an active inode in the inode cache
+ * @sb:		super block of file system to search
+ * @ino:	inode number to search for
+ *
+ * Search for an active inode @ino in the inode cache, and if the
+ * inode is in the cache, the inode is returned with an incremented
+ * reference count.  If the inode is being freed or is newly
+ * initialized, return nothing instead of trying to wait for the inode
+ * initialization or destruction to be complete.
+ */
+struct inode *find_active_inode_nowait(struct super_block *sb,
+				       unsigned long ino)
+{
+	struct hlist_head *head = inode_hashtable + hash(sb, ino);
+	struct inode *inode, *ret_inode = NULL;
+
+	spin_lock(&inode_hash_lock);
+	hlist_for_each_entry(inode, head, i_hash) {
+		if ((inode->i_ino != ino) ||
+		    (inode->i_sb != sb))
+			continue;
+		spin_lock(&inode->i_lock);
+		if ((inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) == 0) {
+			__iget(inode);
+			ret_inode = inode;
+		}
+		spin_unlock(&inode->i_lock);
+		goto out;
+	}
+out:
+	spin_unlock(&inode_hash_lock);
+	return ret_inode;
+}
+EXPORT_SYMBOL(find_active_inode_nowait);
+
 int insert_inode_locked(struct inode *inode)
 {
 	struct super_block *sb = inode->i_sb;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d0a2181..dc615ec 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2419,6 +2419,8 @@ extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
 
 extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
 extern struct inode * iget_locked(struct super_block *, unsigned long);
+extern struct inode *find_active_inode_nowait(struct super_block *,
+					      unsigned long);
 extern int insert_inode_locked4(struct inode *, unsigned long, int (*test)(struct inode *, void *), void *);
 extern int insert_inode_locked(struct inode *);
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
