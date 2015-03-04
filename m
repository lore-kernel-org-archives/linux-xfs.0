Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 446827F55
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 09:15:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3829AC005
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 07:15:26 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0m7qg3HaVrGwcJlO (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 07:15:25 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 8/8] quota: Hook up Q_XSETQLIM for id 0 to ->set_info
Date: Wed,  4 Mar 2015 16:15:13 +0100
Message-Id: <1425482113-1977-9-git-send-email-jack@suse.cz>
In-Reply-To: <1425482113-1977-1-git-send-email-jack@suse.cz>
References: <1425482113-1977-1-git-send-email-jack@suse.cz>
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
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

Setting timers or warning counts for id 0 via Q_XSETQLIM is used to
actually set time limits and warning limits for all users. Hook up
->set_info to this so that VFS quota time limits get set the same
way as XFS ones.

When doing this Q_XSETQLIM for XFS is effectively split into two
independent transactions - one for setting timers and warning limits and
one for setting space and inode limits. Although this is inefficient, it
is rare enough that it does not matter.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/quota.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 741d5a178268..86ded7375c21 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -517,6 +517,30 @@ static void copy_from_xfs_dqblk(struct qc_dqblk *dst, struct fs_disk_quota *src)
 		dst->d_fieldmask |= QC_RT_SPACE;
 }
 
+static void copy_qcinfo_from_xfs_dqblk(struct qc_info *dst,
+				       struct fs_disk_quota *src)
+{
+	memset(dst, 0, sizeof(*dst));
+	dst->i_spc_timelimit = src->d_btimer;
+	dst->i_ino_timelimit = src->d_itimer;
+	dst->i_rt_spc_timelimit = src->d_rtbtimer;
+	dst->i_ino_warnlimit = src->d_iwarns;
+	dst->i_spc_warnlimit = src->d_bwarns;
+	dst->i_rt_spc_warnlimit = src->d_rtbwarns;
+	if (src->d_fieldmask & FS_DQ_BWARNS)
+		dst->i_fieldmask |= QC_SPC_WARNS;
+	if (src->d_fieldmask & FS_DQ_IWARNS)
+		dst->i_fieldmask |= QC_INO_WARNS;
+	if (src->d_fieldmask & FS_DQ_RTBWARNS)
+		dst->i_fieldmask |= QC_RT_SPC_WARNS;
+	if (src->d_fieldmask & FS_DQ_BTIMER)
+		dst->i_fieldmask |= QC_SPC_TIMER;
+	if (src->d_fieldmask & FS_DQ_ITIMER)
+		dst->i_fieldmask |= QC_INO_TIMER;
+	if (src->d_fieldmask & FS_DQ_RTBTIMER)
+		dst->i_fieldmask |= QC_RT_SPC_TIMER;
+}
+
 static int quota_setxquota(struct super_block *sb, int type, qid_t id,
 			   void __user *addr)
 {
@@ -531,6 +555,21 @@ static int quota_setxquota(struct super_block *sb, int type, qid_t id,
 	qid = make_kqid(current_user_ns(), type, id);
 	if (!qid_valid(qid))
 		return -EINVAL;
+	/* Are we actually setting timer / warning limits for all users? */
+	if (from_kqid(&init_user_ns, qid) == 0 &&
+	    fdq.d_fieldmask & (FS_DQ_WARNS_MASK | FS_DQ_TIMER_MASK)) {
+		struct qc_info qinfo;
+		int ret;
+
+		if (!sb->s_qcop->set_info)
+			return -EINVAL;
+		copy_qcinfo_from_xfs_dqblk(&qinfo, &fdq);
+		ret = sb->s_qcop->set_info(sb, type, &qinfo);
+		if (ret)
+			return ret;
+		/* These are already done */
+		fdq.d_fieldmask &= ~(FS_DQ_WARNS_MASK | FS_DQ_TIMER_MASK);
+	}
 	copy_from_xfs_dqblk(&qdq, &fdq);
 	return sb->s_qcop->set_dqblk(sb, qid, &qdq);
 }
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
