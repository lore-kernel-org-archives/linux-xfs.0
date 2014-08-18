Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F34517F3F
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 14:02:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7EA20AC002
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 12:02:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id mRsPlZaU4Ar8fucV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 18 Aug 2014 12:02:07 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7IJ25YT016134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 15:02:05 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s7IJ25rs008143
	for <xfs@oss.sgi.com>; Mon, 18 Aug 2014 15:02:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: mark all internal workqueues as freezable
Date: Mon, 18 Aug 2014 15:02:03 -0400
Message-Id: <1408388523-3684-1-git-send-email-bfoster@redhat.com>
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

Workqueues must be explicitly set as freezable to ensure they are frozen
in the assocated part of the hibernation/suspend sequence. Freezing of
workqueues and kernel threads is important to ensure that modifications
are not made on-disk after the hibernation image has been created.
Otherwise, the in-memory state can become inconsistent with what is on
disk and eventually lead to filesystem corruption. We have reports of
free space btree corruptions that occur immediately after restore from
hibernate that suggest the xfs-eofblocks workqueue could be causing
such problems if it races with hibernation.

Mark all of the internal XFS workqueues as freezable to ensure nothing
changes on-disk once the freezer infrastructure freezes kernel threads
and creates the hibernation image.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reported-by: Carlos E. R. <carlos.e.r@opensuse.org>
---

Hi all,

Unfortunately I still haven't been able to reproduce the specific
corruption. The best I've been able to do is reproduce a hang/crash on
hibernate if I coordinate hibernate with background eofblocks scans, but
I couldn't get any output as to what was going on. I ran some similar
test cycles with this change and didn't reproduce that hang, so this
appears to be effective at least.

I reproduce other such problems running hibernation while doing stress
level I/O, so to be honest I'm not sure how trustworthy/reliable
hibernate is in general. This appears like the right thing to do to
reduce chances of corruptions in any event.

Brian

 fs/xfs/xfs_buf.c       |  2 +-
 fs/xfs/xfs_mru_cache.c |  3 ++-
 fs/xfs/xfs_super.c     | 15 ++++++++-------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cd7b8ca..ec65050 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1884,7 +1884,7 @@ xfs_buf_init(void)
 		goto out;
 
 	xfslogd_workqueue = alloc_workqueue("xfslogd",
-					WQ_MEM_RECLAIM | WQ_HIGHPRI, 1);
+				WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_FREEZABLE, 1);
 	if (!xfslogd_workqueue)
 		goto out_free_buf_zone;
 
diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 1eb6f3d..30ecca3 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -304,7 +304,8 @@ _xfs_mru_cache_reap(
 int
 xfs_mru_cache_init(void)
 {
-	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache", WQ_MEM_RECLAIM, 1);
+	xfs_mru_reap_wq = alloc_workqueue("xfs_mru_cache",
+				WQ_MEM_RECLAIM|WQ_FREEZABLE, 1);
 	if (!xfs_mru_reap_wq)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index b194652..bc9ec44 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -838,32 +838,32 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_data_workqueue = alloc_workqueue("xfs-data/%s",
-			WQ_MEM_RECLAIM, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_data_workqueue)
 		goto out;
 
 	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
-			WQ_MEM_RECLAIM, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_data_iodone_queue;
 
 	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
-			WQ_MEM_RECLAIM, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
 
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-			0, 0, mp->m_fsname);
+			WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
 	mp->m_log_workqueue = alloc_workqueue("xfs-log/%s",
-			0, 0, mp->m_fsname);
+			WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_log_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
-			0, 0, mp->m_fsname);
+			WQ_FREEZABLE, 0, mp->m_fsname);
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_log;
 
@@ -1715,7 +1715,8 @@ xfs_init_workqueues(void)
 	 * AGs in all the filesystems mounted. Hence use the default large
 	 * max_active value for this workqueue.
 	 */
-	xfs_alloc_wq = alloc_workqueue("xfsalloc", WQ_MEM_RECLAIM, 0);
+	xfs_alloc_wq = alloc_workqueue("xfsalloc",
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0);
 	if (!xfs_alloc_wq)
 		return -ENOMEM;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
