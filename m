Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5D8B7F6F
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 09:38:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65E9EAC006
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2014 07:38:54 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0lDRtUE6e4MqefF6 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 Oct 2014 07:38:52 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 01/12] quota: Remove const from function declarations
Date: Tue, 21 Oct 2014 16:38:25 +0200
Message-Id: <1413902316-17997-2-git-send-email-jack@suse.cz>
In-Reply-To: <1413902316-17997-1-git-send-email-jack@suse.cz>
References: <1413902316-17997-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, hch@lst.de, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

We don't use const through VFS too much so just remove it from quota
function declarations.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c         | 4 ++--
 include/linux/quotaops.h | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 8b663b2d9562..8a6b95e9bf3d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1643,7 +1643,7 @@ EXPORT_SYMBOL(__dquot_alloc_space);
 /*
  * This operation can block, but only after everything is updated
  */
-int dquot_alloc_inode(const struct inode *inode)
+int dquot_alloc_inode(struct inode *inode)
 {
 	int cnt, ret = 0, index;
 	struct dquot_warn warn[MAXQUOTAS];
@@ -1784,7 +1784,7 @@ EXPORT_SYMBOL(__dquot_free_space);
 /*
  * This operation can block, but only after everything is updated
  */
-void dquot_free_inode(const struct inode *inode)
+void dquot_free_inode(struct inode *inode)
 {
 	unsigned int cnt;
 	struct dquot_warn warn[MAXQUOTAS];
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index 1d3eee594cd6..f23538a6e411 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -64,10 +64,10 @@ void dquot_destroy(struct dquot *dquot);
 int __dquot_alloc_space(struct inode *inode, qsize_t number, int flags);
 void __dquot_free_space(struct inode *inode, qsize_t number, int flags);
 
-int dquot_alloc_inode(const struct inode *inode);
+int dquot_alloc_inode(struct inode *inode);
 
 int dquot_claim_space_nodirty(struct inode *inode, qsize_t number);
-void dquot_free_inode(const struct inode *inode);
+void dquot_free_inode(struct inode *inode);
 void dquot_reclaim_space_nodirty(struct inode *inode, qsize_t number);
 
 int dquot_disable(struct super_block *sb, int type, unsigned int flags);
@@ -213,12 +213,12 @@ static inline void dquot_drop(struct inode *inode)
 {
 }
 
-static inline int dquot_alloc_inode(const struct inode *inode)
+static inline int dquot_alloc_inode(struct inode *inode)
 {
 	return 0;
 }
 
-static inline void dquot_free_inode(const struct inode *inode)
+static inline void dquot_free_inode(struct inode *inode)
 {
 }
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
