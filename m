Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 40B547F72
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:38:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1160D304087
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:38:01 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QrfjZKjApdh0Up4v (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:37:59 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/25] ocfs2: Use generic helpers for quotaon and quotaoff
Date: Thu, 18 Dec 2014 16:37:22 +0100
Message-Id: <1418917059-23870-9-git-send-email-jack@suse.cz>
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
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

Ocfs2 can just use the generic helpers provided by quota code for
turning quotas on and off when quota files are stored as system inodes.
The only difference is the feature test in ocfs2_quota_on() and that is
covered by dquot_quota_enable() checking whether usage tracking is
enabled (which can happen only if the filesystem has the quota feature
set).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 83723179e1ec..706c71c2955d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1000,36 +1000,6 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
 	}
 }
 
-/* Handle quota on quotactl */
-static int ocfs2_quota_on(struct super_block *sb, int type, int format_id)
-{
-	unsigned int feature[OCFS2_MAXQUOTAS] = {
-					OCFS2_FEATURE_RO_COMPAT_USRQUOTA,
-					OCFS2_FEATURE_RO_COMPAT_GRPQUOTA};
-
-	if (!OCFS2_HAS_RO_COMPAT_FEATURE(sb, feature[type]))
-		return -EINVAL;
-
-	return dquot_enable(sb_dqopt(sb)->files[type], type,
-			    format_id, DQUOT_LIMITS_ENABLED);
-}
-
-/* Handle quota off quotactl */
-static int ocfs2_quota_off(struct super_block *sb, int type)
-{
-	return dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
-}
-
-static const struct quotactl_ops ocfs2_quotactl_ops = {
-	.quota_on_meta	= ocfs2_quota_on,
-	.quota_off	= ocfs2_quota_off,
-	.quota_sync	= dquot_quota_sync,
-	.get_info	= dquot_get_dqinfo,
-	.set_info	= dquot_set_dqinfo,
-	.get_dqblk	= dquot_get_dqblk,
-	.set_dqblk	= dquot_set_dqblk,
-};
-
 static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dentry *root;
@@ -2079,7 +2049,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	sb->s_op = &ocfs2_sops;
 	sb->s_d_op = &ocfs2_dentry_ops;
 	sb->s_export_op = &ocfs2_export_ops;
-	sb->s_qcop = &ocfs2_quotactl_ops;
+	sb->s_qcop = &dquot_quotactl_sysfile_ops;
 	sb->dq_op = &ocfs2_quota_operations;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP;
 	sb->s_xattr = ocfs2_xattr_handlers;
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
