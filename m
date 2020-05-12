Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F05AFC47255
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 02:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C38C6206D7
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 02:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgELC76 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 22:59:58 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55154 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728073AbgELC75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 22:59:57 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 65BA53A3648
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 12:59:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYL97-00023B-8H
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 12:59:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jYL96-007aCb-VL
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 12:59:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: separate read-only variables in struct xfs_mount
Date:   Tue, 12 May 2020 12:59:48 +1000
Message-Id: <20200512025949.1807131-2-david@fromorbit.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9
In-Reply-To: <20200512025949.1807131-1-david@fromorbit.com>
References: <20200512025949.1807131-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=6bWVlVJL7jcz4EFoCGYA:9
        a=T7BEPd9-KIUQysAa:21 a=DsDIQ_qJmw4xj2vw:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Seeing massive cpu usage from xfs_agino_range() on one machine;
instruction level profiles look similar to another machine running
the same workload, only one machien is consuming 10x as much CPU as
the other and going much slower. The only real difference between
the two machines is core count per socket. Both are running
identical 16p/16GB virtual machine configurations

Machine A:

  25.83%  [k] xfs_agino_range
  12.68%  [k] __xfs_dir3_data_check
   6.95%  [k] xfs_verify_ino
   6.78%  [k] xfs_dir2_data_entry_tag_p
   3.56%  [k] xfs_buf_find
   2.31%  [k] xfs_verify_dir_ino
   2.02%  [k] xfs_dabuf_map.constprop.0
   1.65%  [k] xfs_ag_block_count

And takes around 13 minutes to remove 50 million inodes.

Machine B:

  13.90%  [k] __pv_queued_spin_lock_slowpath
   3.76%  [k] do_raw_spin_lock
   2.83%  [k] xfs_dir3_leaf_check_int
   2.75%  [k] xfs_agino_range
   2.51%  [k] __raw_callee_save___pv_queued_spin_unlock
   2.18%  [k] __xfs_dir3_data_check
   2.02%  [k] xfs_log_commit_cil

And takes around 5m30s to remove 50 million inodes.

Suspect is cacheline contention on m_sectbb_log which is used in one
of the macros in xfs_agino_range. This is a read-only variable but
shares a cacheline with m_active_trans which is a global atomic that
gets bounced all around the machine.

The workload is trying to run hundreds of thousands of transactions
per second and hence cacheline contention will be occuring on this
atomic counter. Hence xfs_agino_range() is likely just be an
innocent bystander as the cache coherency protocol fights over the
cacheline between CPU cores and sockets.

On machine A, this rearrangement of the struct xfs_mount
results in the profile changing to:

   9.77%  [kernel]  [k] xfs_agino_range
   6.27%  [kernel]  [k] __xfs_dir3_data_check
   5.31%  [kernel]  [k] __pv_queued_spin_lock_slowpath
   4.54%  [kernel]  [k] xfs_buf_find
   3.79%  [kernel]  [k] do_raw_spin_lock
   3.39%  [kernel]  [k] xfs_verify_ino
   2.73%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock

Vastly less CPU usage in xfs_agino_range(), but still 3x the amount
of machine B and still runs substantially slower than it should.

Current rm -rf of 50 million files:

		vanilla		patched
machine A	13m20s		8m30s
machine B	5m30s		5m02s

It's an improvement, hence indicating that separation and further
optimisation of read-only global filesystem data is worthwhile, but
it clearly isn't the underlying issue causing this specific
performance degradation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h | 50 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index aba5a15792792..712b3e2583316 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -88,21 +88,12 @@ typedef struct xfs_mount {
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
-	int			m_bsize;	/* fs logical block size */
 	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
 	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
 	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
-	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	uint			m_allocsize_log;/* min write size log bytes */
-	uint			m_allocsize_blocks; /* min write size blocks */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
 	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
 	struct xlog		*m_log;		/* log specific stuff */
-	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
-	int			m_logbufs;	/* number of log buffers */
-	int			m_logbsize;	/* size of each log buffer */
-	uint			m_rsumlevels;	/* rt summary levels */
-	uint			m_rsumsize;	/* size of rt summary, bytes */
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
 	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
@@ -117,9 +108,15 @@ typedef struct xfs_mount {
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
 	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
+
+	/*
+	 * Read-only variables that are pre-calculated at mount time.
+	 */
+	int ____cacheline_aligned m_bsize;	/* fs logical block size */
 	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
 	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
+	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -138,20 +135,35 @@ typedef struct xfs_mount {
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
-	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
-	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
-	struct mutex		m_growlock;	/* growfs mutex */
+	int			m_dalign;	/* stripe unit */
+	int			m_swidth;	/* stripe width */
+	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
+	uint			m_allocsize_log;/* min write size log bytes */
+	uint			m_allocsize_blocks; /* min write size blocks */
+	int			m_logbufs;	/* number of log buffers */
+	int			m_logbsize;	/* size of each log buffer */
+	uint			m_rsumlevels;	/* rt summary levels */
+	uint			m_rsumsize;	/* size of rt summary, bytes */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
-	uint64_t		m_flags;	/* global mount flags */
-	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
+	uint64_t		m_flags;	/* global mount flags */
+	int64_t			m_low_space[XFS_LOWSP_MAX];
+	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
+						/* low free space thresholds */
+	bool			m_always_cow;
+	bool			m_fail_unmount;
+	bool			m_finobt_nores; /* no per-AG finobt resv. */
+	/*
+	 * End of pre-calculated read-only variables
+	 */
+
+	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
+	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
+	struct mutex		m_growlock;	/* growfs mutex */
 	uint64_t		m_resblks;	/* total reserved blocks */
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
-	int			m_dalign;	/* stripe unit */
-	int			m_swidth;	/* stripe width */
-	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
@@ -160,8 +172,6 @@ typedef struct xfs_mount {
 	struct delayed_work	m_cowblocks_work; /* background cow blocks
 						     trimming */
 	bool			m_update_sb;	/* sb needs update in mount */
-	int64_t			m_low_space[XFS_LOWSP_MAX];
-						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -191,8 +201,6 @@ typedef struct xfs_mount {
 	 */
 	uint32_t		m_generation;
 
-	bool			m_always_cow;
-	bool			m_fail_unmount;
 #ifdef DEBUG
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
-- 
2.26.1.301.g55bc3eb7cb9

