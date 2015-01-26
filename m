Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B3BD801D
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 08:34:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19EA9AC006
	for <xfs@oss.sgi.com>; Mon, 26 Jan 2015 06:34:44 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id xj5bROtwZHVNifvT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Jan 2015 06:34:44 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 13/16] quota: Remove ->get_xstate and ->get_xstatev callbacks
Date: Mon, 26 Jan 2015 15:34:30 +0100
Message-Id: <1422282873-3381-14-git-send-email-jack@suse.cz>
In-Reply-To: <1422282873-3381-1-git-send-email-jack@suse.cz>
References: <1422282873-3381-1-git-send-email-jack@suse.cz>
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
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

These callbacks are now unused. Remove them.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c      | 14 ++++----------
 include/linux/quota.h |  2 --
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 83939ff4c444..20d11cd21247 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -350,12 +350,9 @@ static int quota_getxstate(struct super_block *sb, void __user *addr)
 	struct fs_quota_stat fqs;
 	int ret;
 
-	if (!sb->s_qcop->get_xstate && !sb->s_qcop->get_state)
+	if (!sb->s_qcop->get_state)
 		return -ENOSYS;
-	if (sb->s_qcop->get_state)
-		ret = quota_getstate(sb, &fqs);
-	else
-		ret = sb->s_qcop->get_xstate(sb, &fqs);
+	ret = quota_getstate(sb, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
 	return ret;
@@ -414,7 +411,7 @@ static int quota_getxstatev(struct super_block *sb, void __user *addr)
 	struct fs_quota_statv fqs;
 	int ret;
 
-	if (!sb->s_qcop->get_xstatev && !sb->s_qcop->get_state)
+	if (!sb->s_qcop->get_state)
 		return -ENOSYS;
 
 	memset(&fqs, 0, sizeof(fqs));
@@ -428,10 +425,7 @@ static int quota_getxstatev(struct super_block *sb, void __user *addr)
 	default:
 		return -EINVAL;
 	}
-	if (sb->s_qcop->get_state)
-		ret = quota_getstatev(sb, &fqs);
-	else
-		ret = sb->s_qcop->get_xstatev(sb, &fqs);
+	ret = quota_getstatev(sb, &fqs);
 	if (!ret && copy_to_user(addr, &fqs, sizeof(fqs)))
 		return -EFAULT;
 	return ret;
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6ecac0f3b2ca..a07f2ed25284 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -408,8 +408,6 @@ struct quotactl_ops {
 	int (*get_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
 	int (*set_dqblk)(struct super_block *, struct kqid, struct qc_dqblk *);
 	int (*get_state)(struct super_block *, struct qc_state *);
-	int (*get_xstate)(struct super_block *, struct fs_quota_stat *);
-	int (*get_xstatev)(struct super_block *, struct fs_quota_statv *);
 	int (*rm_xquota)(struct super_block *, unsigned int);
 };
 
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
