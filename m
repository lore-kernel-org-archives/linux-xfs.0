Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46596C2BA19
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 19:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37202082D
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 19:15:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O3jQ9T6s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgDITPJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 15:15:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:48916 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgDITPJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 15:15:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039J9x7W084912;
        Thu, 9 Apr 2020 19:15:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=DAB1ZK2tymwX9YNFa21Dcn4gi0vZlV6mrnkte3bULmA=;
 b=O3jQ9T6s8x41hzV/PeyOTAyswgBwPpRQKfLawxsN48a/nvw5Hxw334bDgmr70l6QxKKE
 pI06YNs3VcoZlVvx5p56xkOWTO7VF0h+cLG+qAN1+EtDeEgLZxrDTXtVPeVfGYDkGoBe
 K5Z1vOTHGzFG1Nh+OeQBB73oBzVAaa35dVH2sPGJOAvP6AdJytVlNeccX0oT0vOG8qU9
 Of4bwB2nJSd8Bm7Ajrhn//mx4R1rsp7Mvox0UsRTZd6Au4pC0Zf/nVLwR4isJtmliHOd
 WQ++Qox41cUYqPDgW/3nfYmFYtJ8Hu2hFhbSNTRIYBG4JGNQ0mOSzee24TO5DbHtrQgc qA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3091m13cqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 19:15:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 039J7m0v023717;
        Thu, 9 Apr 2020 19:15:06 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3091m4yq2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Apr 2020 19:15:06 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 039JF5ak010658;
        Thu, 9 Apr 2020 19:15:05 GMT
Received: from localhost (/10.159.243.40)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Apr 2020 12:15:05 -0700
Date:   Thu, 9 Apr 2020 12:15:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH] xfs: move inode flush to a workqueue
Message-ID: <20200409191504.GO6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=2
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090136
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=2 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004090136
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the inode dirty data flushing to a workqueue so that multiple
threads can take advantage of a single thread's flushing work.  The
ratelimiting technique used in bdd4ee4 was not successful, because
threads that skipped the inode flush scan due to ratelimiting would
ENOSPC early, which caused occasional (but noticeable) changes in
behavior and sporadic fstest regressions.

Therfore, make all the writer threads wait on a single inode flush,
which eliminates both the stampeding hoards of flushers and the small
window in which a write could fail with ENOSPC because it lost the
ratelimit race even after another thread freed space.

Fixes: bdd4ee4f8407 ("xfs: ratelimit inode flush on buffered write ENOSPC")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.h |    6 +++++-
 fs/xfs/xfs_super.c |   40 ++++++++++++++++++++++------------------
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 50c43422fa17..b2e4598fdf7d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -167,8 +167,12 @@ typedef struct xfs_mount {
 	struct xfs_kobj		m_error_meta_kobj;
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
-	struct ratelimit_state	m_flush_inodes_ratelimit;
 
+	/*
+	 * Workqueue item so that we can coalesce multiple inode flush attempts
+	 * into a single flush.
+	 */
+	struct work_struct	m_flush_inodes_work;
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index abf06bf9c3f3..dced03a4571d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -516,6 +516,20 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_buf_workqueue);
 }
 
+static void
+xfs_flush_inodes_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(work, struct xfs_mount,
+						   m_flush_inodes_work);
+	struct super_block	*sb = mp->m_super;
+
+	if (down_read_trylock(&sb->s_umount)) {
+		sync_inodes_sb(sb);
+		up_read(&sb->s_umount);
+	}
+}
+
 /*
  * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
  * or a page lock. We use sync_inodes_sb() here to ensure we block while waiting
@@ -526,15 +540,15 @@ void
 xfs_flush_inodes(
 	struct xfs_mount	*mp)
 {
-	struct super_block	*sb = mp->m_super;
-
-	if (!__ratelimit(&mp->m_flush_inodes_ratelimit))
+	/*
+	 * If flush_work() returns true then that means we waited for a flush
+	 * which was already in progress.  Don't bother running another scan.
+	 */
+	if (flush_work(&mp->m_flush_inodes_work))
 		return;
 
-	if (down_read_trylock(&sb->s_umount)) {
-		sync_inodes_sb(sb);
-		up_read(&sb->s_umount);
-	}
+	schedule_work(&mp->m_flush_inodes_work);
+	flush_work(&mp->m_flush_inodes_work);
 }
 
 /* Catch misguided souls that try to use this interface on XFS */
@@ -1369,17 +1383,6 @@ xfs_fc_fill_super(
 	if (error)
 		goto out_free_names;
 
-	/*
-	 * Cap the number of invocations of xfs_flush_inodes to 16 for every
-	 * quarter of a second.  The magic numbers here were determined by
-	 * observation neither to cause stalls in writeback when there are a
-	 * lot of IO threads and the fs is near ENOSPC, nor cause any fstest
-	 * regressions.  YMMV.
-	 */
-	ratelimit_state_init(&mp->m_flush_inodes_ratelimit, HZ / 4, 16);
-	ratelimit_set_flags(&mp->m_flush_inodes_ratelimit,
-			RATELIMIT_MSG_ON_RELEASE);
-
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
 		goto out_close_devices;
@@ -1752,6 +1755,7 @@ static int xfs_init_fs_context(
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
+	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
