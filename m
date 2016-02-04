Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 495267CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 08:28:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AE3A8F8049
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 06:28:10 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id cfWHEEL8R6M9RUqs (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2016 06:28:07 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] ocfs2: Implement get_next_id()
Date: Thu,  4 Feb 2016 15:28:07 +0100
Message-Id: <1454596087-6814-4-git-send-email-jack@suse.cz>
In-Reply-To: <1454596087-6814-1-git-send-email-jack@suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
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
Cc: Mark Fasheh <mfasheh@suse.com>, Jan Kara <jack@suse.cz>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

Implement get_next_id() callback to enable use of Q_GETNEXTQUOTA
quotactl for OCFS2.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/ocfs2_trace.h  |  2 ++
 fs/ocfs2/quota_global.c | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 6cb019b7c6a8..a52a2dbc064e 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -2035,6 +2035,8 @@ DEFINE_OCFS2_UINT_INT_EVENT(ocfs2_release_dquot);
 
 DEFINE_OCFS2_UINT_INT_EVENT(ocfs2_acquire_dquot);
 
+DEFINE_OCFS2_UINT_INT_EVENT(ocfs2_get_next_id);
+
 DEFINE_OCFS2_UINT_INT_EVENT(ocfs2_mark_dquot_dirty);
 
 /* End of trace events for fs/ocfs2/quota_global.c. */
diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index fde9ef18cff3..8c903ce08e95 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -860,6 +860,30 @@ out:
 	return status;
 }
 
+static int ocfs2_get_next_id(struct super_block *sb, struct kqid *qid)
+{
+	int type = qid->type;
+	struct ocfs2_mem_dqinfo *info = sb_dqinfo(sb, type)->dqi_priv;
+	int status = 0;
+
+	trace_ocfs2_get_next_id(from_kqid(&init_user_ns, *qid), type);
+	status = ocfs2_lock_global_qf(info, 0);
+	if (status < 0)
+		goto out;
+	status = ocfs2_qinfo_lock(info, 0);
+	if (status < 0)
+		goto out_global;
+	status = qtree_get_next_id(&info->dqi_gi, qid);
+	ocfs2_qinfo_unlock(info, 0);
+out_global:
+	ocfs2_unlock_global_qf(info, 0);
+out:
+	/* Avoid logging ENOENT since it just means there isn't next ID */
+	if (status && status != -ENOENT)
+		mlog_errno(status);
+	return status;
+}
+
 static int ocfs2_mark_dquot_dirty(struct dquot *dquot)
 {
 	unsigned long mask = (1 << (DQ_LASTSET_B + QIF_ILIMITS_B)) |
@@ -968,4 +992,5 @@ const struct dquot_operations ocfs2_quota_operations = {
 	.write_info	= ocfs2_write_info,
 	.alloc_dquot	= ocfs2_alloc_dquot,
 	.destroy_dquot	= ocfs2_destroy_dquot,
+	.get_next_id	= ocfs2_get_next_id,
 };
-- 
2.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
