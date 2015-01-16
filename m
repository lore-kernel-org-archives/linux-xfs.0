Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7547E7F61
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 06:48:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 631BD8F804B
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2015 04:48:09 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id xvLKOn3SvhL04lof (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Jan 2015 04:48:06 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 13/17] gfs2: Convert to using ->get_state callback
Date: Fri, 16 Jan 2015 13:47:47 +0100
Message-Id: <1421412471-4747-14-git-send-email-jack@suse.cz>
In-Reply-To: <1421412471-4747-1-git-send-email-jack@suse.cz>
References: <1421412471-4747-1-git-send-email-jack@suse.cz>
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

Convert gfs2 to use ->get_state callback instead of ->get_xstate.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/gfs2/quota.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 3e193cb36996..aebfe50da6b1 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1467,32 +1467,34 @@ int gfs2_quotad(void *data)
 	return 0;
 }
 
-static int gfs2_quota_get_xstate(struct super_block *sb,
-				 struct fs_quota_stat *fqs)
+static int gfs2_quota_get_state(struct super_block *sb, struct qc_state *state)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
-	memset(fqs, 0, sizeof(struct fs_quota_stat));
-	fqs->qs_version = FS_QSTAT_VERSION;
+	memset(state, 0, sizeof(*state));
 
 	switch (sdp->sd_args.ar_quota) {
 	case GFS2_QUOTA_ON:
-		fqs->qs_flags |= (FS_QUOTA_UDQ_ENFD | FS_QUOTA_GDQ_ENFD);
+		state->s_state[USRQUOTA].flags |= QCI_LIMITS_ENFORCED;
+		state->s_state[GRPQUOTA].flags |= QCI_LIMITS_ENFORCED;
 		/*FALLTHRU*/
 	case GFS2_QUOTA_ACCOUNT:
-		fqs->qs_flags |= (FS_QUOTA_UDQ_ACCT | FS_QUOTA_GDQ_ACCT);
+		state->s_state[USRQUOTA].flags |= QCI_ACCT_ENABLED |
+						  QCI_SYSFILE;
+		state->s_state[GRPQUOTA].flags |= QCI_ACCT_ENABLED |
+						  QCI_SYSFILE;
 		break;
 	case GFS2_QUOTA_OFF:
 		break;
 	}
-
 	if (sdp->sd_quota_inode) {
-		fqs->qs_uquota.qfs_ino = GFS2_I(sdp->sd_quota_inode)->i_no_addr;
-		fqs->qs_uquota.qfs_nblks = sdp->sd_quota_inode->i_blocks;
+		state->s_state[USRQUOTA].ino =
+					GFS2_I(sdp->sd_quota_inode)->i_no_addr;
+		state->s_state[USRQUOTA].blocks = sdp->sd_quota_inode->i_blocks;
 	}
-	fqs->qs_uquota.qfs_nextents = 1; /* unsupported */
-	fqs->qs_gquota = fqs->qs_uquota; /* its the same inode in both cases */
-	fqs->qs_incoredqs = list_lru_count(&gfs2_qd_lru);
+	state->s_state[USRQUOTA].extents = 1;	/* unsupported */
+	state->s_state[GRPQUOTA] = state->s_state[USRQUOTA];
+	state->s_incoredqs = list_lru_count(&gfs2_qd_lru);
 	return 0;
 }
 
@@ -1637,7 +1639,7 @@ out_put:
 
 const struct quotactl_ops gfs2_quotactl_ops = {
 	.quota_sync     = gfs2_quota_sync,
-	.get_xstate     = gfs2_quota_get_xstate,
+	.get_state	= gfs2_quota_get_state,
 	.get_dqblk	= gfs2_get_dqblk,
 	.set_dqblk	= gfs2_set_dqblk,
 };
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
