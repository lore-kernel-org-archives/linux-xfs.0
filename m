Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 33B437F51
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 17:27:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5710AC006
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 15:27:24 -0700 (PDT)
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id 9q4hcgB1Vz8C7lMI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Aug 2013 15:27:23 -0700 (PDT)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 6 Aug 2013 16:27:23 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 20DF31FF001D
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 16:21:55 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r76MRJFj360290 for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:19 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r76MRJOg011795
	for <xfs@oss.sgi.com>; Tue, 6 Aug 2013 16:27:19 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 3/3] gfs2: Add support for the Q_XGETQSTATV
Date: Tue,  6 Aug 2013 17:27:09 -0500
Message-Id: <1375828029-26360-4-git-send-email-sekharan@us.ibm.com>
In-Reply-To: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
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
To: xfs@oss.sgi.com
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Jan Kara <jack@suse.cz>, Chandra Seetharaman <sekharan@us.ibm.com>, Abhijith Das <adas@redhat.com>

For gfs2, add support for Q_XGETQSTATV quotactl command.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 fs/gfs2/quota.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 3768c2f..57f246d 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1462,6 +1462,32 @@ static int gfs2_quota_get_xstate(struct super_block *sb,
 	return 0;
 }
 
+static int gfs2_quota_get_xstatev(struct super_block *sb,
+				 struct fs_quota_statv *fqs)
+{
+	struct gfs2_sbd *sdp = sb->s_fs_info;
+
+	switch (sdp->sd_args.ar_quota) {
+	case GFS2_QUOTA_ON:
+		fqs->qs_flags |= (FS_QUOTA_UDQ_ENFD | FS_QUOTA_GDQ_ENFD);
+		/*FALLTHRU*/
+	case GFS2_QUOTA_ACCOUNT:
+		fqs->qs_flags |= (FS_QUOTA_UDQ_ACCT | FS_QUOTA_GDQ_ACCT);
+		break;
+	case GFS2_QUOTA_OFF:
+		break;
+	}
+
+	if (sdp->sd_quota_inode) {
+		fqs->qs_uquota.qfs_ino = GFS2_I(sdp->sd_quota_inode)->i_no_addr;
+		fqs->qs_uquota.qfs_nblks = sdp->sd_quota_inode->i_blocks;
+	}
+	fqs->qs_uquota.qfs_nextents = 1; /* unsupported */
+	fqs->qs_gquota = fqs->qs_uquota; /* its the same inode in both cases */
+	fqs->qs_incoredqs = atomic_read(&qd_lru_count);
+	return 0;
+}
+
 static int gfs2_get_dqblk(struct super_block *sb, struct kqid qid,
 			  struct fs_disk_quota *fdq)
 {
@@ -1604,6 +1630,7 @@ out_put:
 
 const struct quotactl_ops gfs2_quotactl_ops = {
 	.quota_sync     = gfs2_quota_sync,
+	.get_xstatev    = gfs2_quota_get_xstatev,
 	.get_xstate     = gfs2_quota_get_xstate,
 	.get_dqblk	= gfs2_get_dqblk,
 	.set_dqblk	= gfs2_set_dqblk,
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
