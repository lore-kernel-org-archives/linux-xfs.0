Return-Path: <SRS0=wgma=55=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD85FC2BB85
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:10:22 +0000 (UTC)
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 840B72064A
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Apr 2020 01:10:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="y16NzidZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 840B72064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-xfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgDMBKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Apr 2020 21:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbgDMBKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Apr 2020 21:10:21 -0400
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6BEC0A3BE0
        for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2020 18:10:20 -0700 (PDT)
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03D18epc131551
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Y5XTX805cR++iszeSVpWVbUMcgJMPVAoS5z4lDjTvNQ=;
 b=y16NzidZyo5y9e5qlOcXkAumwyM+onqV+zdyiH/rx2QAFsdt29JjQXv1sFfLBX1oEkPA
 S30S6oLWLDsBZn4PISIKBwsz+3Gq6HZtzdeqxsUCH42EcEPu3SopuORH6uuBYsVMZuSV
 AXY1OUWhrqpg0g9t73L97/YejBFRsndoOaXnyFoVKx/qcDy8bLBYD3wCQhGs09IEcgy1
 9KJOMU91a/KLljpnUQMJo4ZzhH41f4kfySacWR9hnEsTRtFPp1RN5T6QSm6XlmA7EIvB
 dg+rKtXoIgY6udF4weaKRsx9qvFBNIf/8D8pemJ3pV1yXhZKUBxLoZW5FwxjGwxw9i2B wQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 30b5aqv1cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:20 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03D16wUc035793
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 30bqkvj2j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:19 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03D1AJwr009962
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2020 01:10:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 12 Apr 2020 18:10:18 -0700
Subject: [PATCH 1/2] xfs: move inode flush to a workqueue
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 12 Apr 2020 18:10:17 -0700
Message-ID: <158674021749.3253017.16036198065081499968.stgit@magnolia>
In-Reply-To: <158674021112.3253017.16592621806726469169.stgit@magnolia>
References: <158674021112.3253017.16592621806726469169.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9589 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9589 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=3 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the inode dirty data flushing to a workqueue so that multiple
threads can take advantage of a single thread's flush work.  The
ratelimiting technique was not successful, because threads that skipped
the inode flush scan due to ratelimiting would ENOSPC early and
apparently now there are complaints about that.  So make everyone wait.

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

