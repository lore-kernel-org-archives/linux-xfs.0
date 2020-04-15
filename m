Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045E8C2BA2B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 04:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1D622084D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 04:17:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wv++gabe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388697AbgDOERk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 00:17:40 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47790 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgDOERi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Apr 2020 00:17:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F4Dg43073719;
        Wed, 15 Apr 2020 04:17:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=FLMVuarYOdhrGwqQm91wj7d1LffBTn/w2YkXd7i/q9k=;
 b=Wv++gaberLNRqmkOskYBAtqJp+R+AdwlGlZ/6BXHY6JOxLQMdEiuT1f0G2lzo1wVsYlM
 Rpxl9gyMtC/ZtqpOKG21Wou42Mzr6F2ycaYw9xj1wHVZ2gEL+v59NH6j1R1IPCsvrjTE
 np65QYvAIhPzdkm2uLwDD7d74McraTku4m5GLfrP+CrkST/OOg97Jo2BuWL1m7ejMcSB
 OOo05rQ0OL7OAj+MYud0d1tDowcY4tB/VXIIuoQvJkGksK4YCbm99cjcRoUdeYEZOwPj
 wf+geh7J0WnV9jlBKroicAanBZ96A/cgQ6SyIQZFuTKzIFHIKSfFndYkaunbHpiXvSya ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30dn9t8yyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 04:17:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03F4C2W4037168;
        Wed, 15 Apr 2020 04:15:33 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30dn9ad7tc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 04:15:32 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03F4FVPG000818;
        Wed, 15 Apr 2020 04:15:31 GMT
Received: from localhost (/10.159.240.205)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Apr 2020 21:15:31 -0700
Date:   Tue, 14 Apr 2020 21:15:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: move inode flush to the sync workqueue
Message-ID: <20200415041529.GL6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=3 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004150030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9591 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=3
 phishscore=0 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150030
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
ratelimit race after even another thread freed space.

Fixes: bdd4ee4f8407 ("xfs: ratelimit inode flush on buffered write ENOSPC")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: run it on the sync workqueue
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
index abf06bf9c3f3..424bb9a2d532 100644
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
+	queue_work(mp->m_sync_workqueue, &mp->m_flush_inodes_work);
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
