Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F4457F72
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:48 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6FD508F8035
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:48 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id uieA65aZ1b0cp9tQ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:46 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 07/11] ext4: Use generic helpers for quotaon and quotaoff
Date: Tue, 11 Nov 2014 22:04:21 +0100
Message-Id: <1415739865-2438-8-git-send-email-jack@suse.cz>
In-Reply-To: <1415739865-2438-1-git-send-email-jack@suse.cz>
References: <1415739865-2438-1-git-send-email-jack@suse.cz>
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
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Ext4 can just use the generic helpers provided by quota code for turning
quotas on and off when quota files are stored as system inodes. The only
difference is the feature test in ext4_quota_on_sysfile() but the same
is achieved in dquot_sysquota_on() by checking whether usage tracking for
the corresponding quota type is enabled (which can happen only if quota
feature is set).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2c9e6864abd9..45be29119e42 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1055,10 +1055,7 @@ static int ext4_mark_dquot_dirty(struct dquot *dquot);
 static int ext4_write_info(struct super_block *sb, int type);
 static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 			 struct path *path);
-static int ext4_quota_on_sysfile(struct super_block *sb, int type,
-				 int format_id);
 static int ext4_quota_off(struct super_block *sb, int type);
-static int ext4_quota_off_sysfile(struct super_block *sb, int type);
 static int ext4_quota_on_mount(struct super_block *sb, int type);
 static ssize_t ext4_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
@@ -1090,8 +1087,8 @@ static const struct quotactl_ops ext4_qctl_operations = {
 };
 
 static const struct quotactl_ops ext4_qctl_sysfile_operations = {
-	.quota_on_meta	= ext4_quota_on_sysfile,
-	.quota_off	= ext4_quota_off_sysfile,
+	.sysquota_on	= dquot_sysquota_on,
+	.sysquota_off	= dquot_sysquota_off,
 	.quota_sync	= dquot_quota_sync,
 	.get_info	= dquot_get_dqinfo,
 	.set_info	= dquot_set_dqinfo,
@@ -5273,21 +5270,6 @@ static int ext4_enable_quotas(struct super_block *sb)
 	return 0;
 }
 
-/*
- * quota_on function that is used when QUOTA feature is set.
- */
-static int ext4_quota_on_sysfile(struct super_block *sb, int type,
-				 int format_id)
-{
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA))
-		return -EINVAL;
-
-	/*
-	 * USAGE was enabled at mount time. Only need to enable LIMITS now.
-	 */
-	return ext4_quota_enable(sb, type, format_id, DQUOT_LIMITS_ENABLED);
-}
-
 static int ext4_quota_off(struct super_block *sb, int type)
 {
 	struct inode *inode = sb_dqopt(sb)->files[type];
@@ -5314,18 +5296,6 @@ out:
 	return dquot_quota_off(sb, type);
 }
 
-/*
- * quota_off function that is used when QUOTA feature is set.
- */
-static int ext4_quota_off_sysfile(struct super_block *sb, int type)
-{
-	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb, EXT4_FEATURE_RO_COMPAT_QUOTA))
-		return -EINVAL;
-
-	/* Disable only the limits. */
-	return dquot_disable(sb, type, DQUOT_LIMITS_ENABLED);
-}
-
 /* Read data from quotafile - avoid pagecache and such because we cannot afford
  * acquiring the locks... As quota files are never truncated and quota code
  * itself serializes the operations (and no one else should touch the files)
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
