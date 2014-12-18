Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A97A7F74
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:38:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 08394AC010
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:38:00 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QpnmhE2ErwKqgfAz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:37:59 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/25] quota: Store maximum space limit in bytes
Date: Thu, 18 Dec 2014 16:37:25 +0100
Message-Id: <1418917059-23870-12-git-send-email-jack@suse.cz>
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

Currently maximum space limit quota format supports is in blocks however
since we store space limits in bytes, this is somewhat confusing. So
store the maximum limit in bytes as well. Also rename the field to match
the new unit and related inode field to match the new naming scheme.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/quota_local.c |  4 ++--
 fs/quota/dquot.c       | 18 ++++--------------
 fs/quota/quota_v1.c    |  4 ++--
 fs/quota/quota_v2.c    | 10 +++++-----
 include/linux/quota.h  |  4 ++--
 5 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index 10b653930ee2..465223b7592e 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -701,8 +701,8 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	/* We don't need the lock and we have to acquire quota file locks
 	 * which will later depend on this lock */
 	mutex_unlock(&sb_dqopt(sb)->dqio_mutex);
-	info->dqi_maxblimit = 0x7fffffffffffffffLL;
-	info->dqi_maxilimit = 0x7fffffffffffffffLL;
+	info->dqi_max_spc_limit = 0x7fffffffffffffffLL;
+	info->dqi_max_ino_limit = 0x7fffffffffffffffLL;
 	oinfo = kmalloc(sizeof(struct ocfs2_mem_dqinfo), GFP_NOFS);
 	if (!oinfo) {
 		mlog(ML_ERROR, "failed to allocate memory for ocfs2 quota"
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index eb830950c904..1fa9ba3b504d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2467,16 +2467,6 @@ out_err:
 }
 EXPORT_SYMBOL(dquot_quota_disable);
 
-static inline qsize_t qbtos(qsize_t blocks)
-{
-	return blocks << QIF_DQBLKSIZE_BITS;
-}
-
-static inline qsize_t stoqb(qsize_t space)
-{
-	return (space + QIF_DQBLKSIZE - 1) >> QIF_DQBLKSIZE_BITS;
-}
-
 /* Generic routine for getting common part of quota structure */
 static void do_get_dqblk(struct dquot *dquot, struct qc_dqblk *di)
 {
@@ -2526,13 +2516,13 @@ static int do_set_dqblk(struct dquot *dquot, struct qc_dqblk *di)
 		return -EINVAL;
 
 	if (((di->d_fieldmask & QC_SPC_SOFT) &&
-	     stoqb(di->d_spc_softlimit) > dqi->dqi_maxblimit) ||
+	     di->d_spc_softlimit > dqi->dqi_max_spc_limit) ||
 	    ((di->d_fieldmask & QC_SPC_HARD) &&
-	     stoqb(di->d_spc_hardlimit) > dqi->dqi_maxblimit) ||
+	     di->d_spc_hardlimit > dqi->dqi_max_spc_limit) ||
 	    ((di->d_fieldmask & QC_INO_SOFT) &&
-	     (di->d_ino_softlimit > dqi->dqi_maxilimit)) ||
+	     (di->d_ino_softlimit > dqi->dqi_max_ino_limit)) ||
 	    ((di->d_fieldmask & QC_INO_HARD) &&
-	     (di->d_ino_hardlimit > dqi->dqi_maxilimit)))
+	     (di->d_ino_hardlimit > dqi->dqi_max_ino_limit)))
 		return -ERANGE;
 
 	spin_lock(&dq_data_lock);
diff --git a/fs/quota/quota_v1.c b/fs/quota/quota_v1.c
index 469c6848b322..8fe79beced5c 100644
--- a/fs/quota/quota_v1.c
+++ b/fs/quota/quota_v1.c
@@ -169,8 +169,8 @@ static int v1_read_file_info(struct super_block *sb, int type)
 	}
 	ret = 0;
 	/* limits are stored as unsigned 32-bit data */
-	dqopt->info[type].dqi_maxblimit = 0xffffffff;
-	dqopt->info[type].dqi_maxilimit = 0xffffffff;
+	dqopt->info[type].dqi_max_spc_limit = 0xffffffffULL << QUOTABLOCK_BITS;
+	dqopt->info[type].dqi_max_ino_limit = 0xffffffff;
 	dqopt->info[type].dqi_igrace =
 			dqblk.dqb_itime ? dqblk.dqb_itime : MAX_IQ_TIME;
 	dqopt->info[type].dqi_bgrace =
diff --git a/fs/quota/quota_v2.c b/fs/quota/quota_v2.c
index 02751ec695c5..d1a8054bba9a 100644
--- a/fs/quota/quota_v2.c
+++ b/fs/quota/quota_v2.c
@@ -117,12 +117,12 @@ static int v2_read_file_info(struct super_block *sb, int type)
 	qinfo = info->dqi_priv;
 	if (version == 0) {
 		/* limits are stored as unsigned 32-bit data */
-		info->dqi_maxblimit = 0xffffffff;
-		info->dqi_maxilimit = 0xffffffff;
+		info->dqi_max_spc_limit = 0xffffffffULL << QUOTABLOCK_BITS;
+		info->dqi_max_ino_limit = 0xffffffff;
 	} else {
-		/* used space is stored as unsigned 64-bit value */
-		info->dqi_maxblimit = 0xffffffffffffffffULL;	/* 2^64-1 */
-		info->dqi_maxilimit = 0xffffffffffffffffULL;
+		/* used space is stored as unsigned 64-bit value in bytes */
+		info->dqi_max_spc_limit = 0xffffffffffffffffULL; /* 2^64-1 */
+		info->dqi_max_ino_limit = 0xffffffffffffffffULL;
 	}
 	info->dqi_bgrace = le32_to_cpu(dinfo.dqi_bgrace);
 	info->dqi_igrace = le32_to_cpu(dinfo.dqi_igrace);
diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6cbff709b212..4a086724d1b3 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -216,8 +216,8 @@ struct mem_dqinfo {
 	unsigned long dqi_flags;
 	unsigned int dqi_bgrace;
 	unsigned int dqi_igrace;
-	qsize_t dqi_maxblimit;
-	qsize_t dqi_maxilimit;
+	qsize_t dqi_max_spc_limit;
+	qsize_t dqi_max_ino_limit;
 	void *dqi_priv;
 };
 
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
