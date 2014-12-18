Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B6E107F83
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:38:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39429AC00D
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:38:02 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ahsJ7u5xP3kOcfH5 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:38:00 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 14/25] ocfs2: Move OLQF_CLEAN flag out of generic quota flags
Date: Thu, 18 Dec 2014 16:37:28 +0100
Message-Id: <1418917059-23870-15-git-send-email-jack@suse.cz>
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

OLQF_CLEAN flag is used by OCFS2 on disk to recognize whether quota
recovery is needed or not. We also somewhat abuse mem_dqinfo->dqi_flags
to pass this flag around. Use private flags for this to avoid clashes
with other quota flags / not pollute generic quota flag namespace.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota.h       |  1 +
 fs/ocfs2/quota_local.c | 10 +++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/quota.h b/fs/ocfs2/quota.h
index 1eae330193a6..b6d51333ad02 100644
--- a/fs/ocfs2/quota.h
+++ b/fs/ocfs2/quota.h
@@ -48,6 +48,7 @@ struct ocfs2_quota_recovery {
 /* In-memory structure with quota header information */
 struct ocfs2_mem_dqinfo {
 	unsigned int dqi_type;		/* Quota type this structure describes */
+	unsigned int dqi_flags;		/* Flags OLQF_* */
 	unsigned int dqi_chunks;	/* Number of chunks in local quota file */
 	unsigned int dqi_blocks;	/* Number of blocks allocated for local quota file */
 	unsigned int dqi_syncms;	/* How often should we sync with other nodes */
diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 465223b7592e..89c0b2620814 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -292,7 +292,7 @@ static void olq_update_info(struct buffer_head *bh, void *private)
 	ldinfo = (struct ocfs2_local_disk_dqinfo *)(bh->b_data +
 						OCFS2_LOCAL_INFO_OFF);
 	spin_lock(&dq_data_lock);
-	ldinfo->dqi_flags = cpu_to_le32(info->dqi_flags & DQF_MASK);
+	ldinfo->dqi_flags = cpu_to_le32(oinfo->dqi_flags);
 	ldinfo->dqi_chunks = cpu_to_le32(oinfo->dqi_chunks);
 	ldinfo->dqi_blocks = cpu_to_le32(oinfo->dqi_blocks);
 	spin_unlock(&dq_data_lock);
@@ -737,13 +737,13 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	}
 	ldinfo = (struct ocfs2_local_disk_dqinfo *)(bh->b_data +
 						OCFS2_LOCAL_INFO_OFF);
-	info->dqi_flags = le32_to_cpu(ldinfo->dqi_flags);
+	oinfo->dqi_flags = le32_to_cpu(ldinfo->dqi_flags);
 	oinfo->dqi_chunks = le32_to_cpu(ldinfo->dqi_chunks);
 	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
 	oinfo->dqi_libh = bh;
 
 	/* We crashed when using local quota file? */
-	if (!(info->dqi_flags & OLQF_CLEAN)) {
+	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
 		rec = OCFS2_SB(sb)->quota_rec;
 		if (!rec) {
 			rec = ocfs2_alloc_quota_recovery();
@@ -772,7 +772,7 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	}
 
 	/* Now mark quota file as used */
-	info->dqi_flags &= ~OLQF_CLEAN;
+	oinfo->dqi_flags &= ~OLQF_CLEAN;
 	status = ocfs2_modify_bh(lqinode, bh, olq_update_info, info);
 	if (status < 0) {
 		mlog_errno(status);
@@ -857,7 +857,7 @@ static int ocfs2_local_free_info(struct super_block *sb, int type)
 		goto out;
 
 	/* Mark local file as clean */
-	info->dqi_flags |= OLQF_CLEAN;
+	oinfo->dqi_flags |= OLQF_CLEAN;
 	status = ocfs2_modify_bh(sb_dqopt(sb)->files[type],
 				 oinfo->dqi_libh,
 				 olq_update_info,
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
