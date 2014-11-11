Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DED847F6A
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 15:04:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CDF15304039
	for <xfs@oss.sgi.com>; Tue, 11 Nov 2014 13:04:47 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 6c7cKeV43AAeAxp9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Nov 2014 13:04:46 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/11] ocfs2: Use generic helpers for quotaon and quotaoff
Date: Tue, 11 Nov 2014 22:04:22 +0100
Message-Id: <1415739865-2438-9-git-send-email-jack@suse.cz>
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

Ocfs2 can just use the generic helpers provided by quota code for turning
quotas on and off when quota files are stored as system inodes. The only
difference is the feature test in ocfs2_quota_on() and that is covered
by dquot_sysquota_on() checking whether usage tracking is enabled (which
can happen only if the filesystem has the quota feature set).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/super.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 93c85bc745e1..1cfedaa24a9d 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -993,29 +993,9 @@ static void ocfs2_disable_quotas(struct ocfs2_super *osb)
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
 static const struct quotactl_ops ocfs2_quotactl_ops = {
-	.quota_on_meta	= ocfs2_quota_on,
-	.quota_off	= ocfs2_quota_off,
+	.sysquota_on	= dquot_sysquota_on,
+	.sysquota_off	= dquot_sysquota_off,
 	.quota_sync	= dquot_quota_sync,
 	.get_info	= dquot_get_dqinfo,
 	.set_info	= dquot_set_dqinfo,
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
