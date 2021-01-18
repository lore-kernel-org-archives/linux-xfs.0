Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7A5C43381
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF33E207C4
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388191AbhARWOO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:14:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:34468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732974AbhARWOK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:14:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 218B722DFB;
        Mon, 18 Jan 2021 22:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611008009;
        bh=hcBSPhB9+wDzT8ljDn3G4d5RWDDaMMWxm0ktf+185Ck=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TVpoBKbaMvkMZHd9z/WW5Ts45/KiLqKMLfrPpWQoXE5tHLfK045zgcxLg82relZDW
         RFCBkeMMaA7qYAFSDIP172rIwcrKxX66t5cy5/DIH7HqAl5T1CC3AvhX0miosHT7Y2
         bYUxDEc/NdbRhWyIMSdsHZpGXQxVu5390HQAfSl6o5r4nNgFt1AfJbKYY2uZ9RAPMn
         pMnoDw/p9oxQLpzdxjCxsvJ09NW6b9S6pQZ3B1CDfQhSvZURX5cFstQMK/JofAYwmg
         q87XstuidPKstvVUV9CrJLwkV2SONf9/KNknrSa2irNn9hC1f8iabfwDdIJ24+5VIs
         frAvtTZj5FY0A==
Subject: [PATCH 05/10] xfs: increase the default parallelism levels of pwork
 clients
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:13:28 -0800
Message-ID: <161100800882.90204.6003697594198832699.stgit@magnolia>
In-Reply-To: <161100798100.90204.7839064495063223590.stgit@magnolia>
References: <161100798100.90204.7839064495063223590.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Increase the default parallelism level for pwork clients so that we can
take advantage of computers with a lot of CPUs and a lot of hardware.
The posteof/cowblocks cleanup series will use the functionality
presented in this patch to constrain the number of background per-ag gc
threads to our best estimate of the amount of parallelism that the
filesystem can sustain.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iwalk.c |    2 +
 fs/xfs/xfs_pwork.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_pwork.h |    3 +-
 3 files changed, 76 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index eae3aff9bc97..bb31ef870cdc 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -624,7 +624,7 @@ xfs_iwalk_threaded(
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
-	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
+	nr_threads = xfs_pwork_guess_workqueue_threads(mp);
 	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
 			nr_threads);
 	if (error)
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index b03333f1c84a..53606397ff54 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -118,19 +118,85 @@ xfs_pwork_poll(
 		touch_softlockup_watchdog();
 }
 
+/* Estimate the amount of parallelism available for a storage device. */
+static unsigned int
+xfs_guess_buftarg_parallelism(
+	struct xfs_buftarg	*btp)
+{
+	int			iomin;
+	int			ioopt;
+
+	/*
+	 * The device tells us that it is non-rotational, and we take that to
+	 * mean there are no moving parts and that the device can handle all
+	 * the CPUs throwing IO requests at it.
+	 */
+	if (blk_queue_nonrot(btp->bt_bdev->bd_disk->queue))
+		return num_online_cpus();
+
+	/*
+	 * The device has a preferred and minimum IO size that suggest a RAID
+	 * setup, so infer the number of disks and assume that the parallelism
+	 * is equal to the disk count.
+	 */
+	iomin = bdev_io_min(btp->bt_bdev);
+	ioopt = bdev_io_opt(btp->bt_bdev);
+	if (iomin > 0 && ioopt > iomin)
+		return ioopt / iomin;
+
+	/*
+	 * The device did not indicate that it has any capabilities beyond that
+	 * of a rotating disk with a single drive head, so we estimate no
+	 * parallelism at all.
+	 */
+	return 1;
+}
+
 /*
- * Return the amount of parallelism that the data device can handle, or 0 for
- * no limit.
+ * Estimate the amount of parallelism that is available for metadata operations
+ * on this filesystem.
  */
 unsigned int
-xfs_pwork_guess_datadev_parallelism(
+xfs_pwork_guess_metadata_threads(
 	struct xfs_mount	*mp)
 {
-	struct xfs_buftarg	*btp = mp->m_ddev_targp;
+	unsigned int		threads;
 
 	/*
-	 * For now we'll go with the most conservative setting possible,
-	 * which is two threads for an SSD and 1 thread everywhere else.
+	 * Estimate the amount of parallelism for metadata operations from the
+	 * least capable of the two devices that handle metadata.  Cap that
+	 * estimate to the number of AGs to avoid unnecessary lock contention.
 	 */
-	return blk_queue_nonrot(btp->bt_bdev->bd_disk->queue) ? 2 : 1;
+	threads = xfs_guess_buftarg_parallelism(mp->m_ddev_targp);
+	if (mp->m_logdev_targp != mp->m_ddev_targp)
+		threads = min(xfs_guess_buftarg_parallelism(mp->m_logdev_targp),
+			      threads);
+	threads = min(mp->m_sb.sb_agcount, threads);
+
+	/* If the storage told us it has fancy capabilities, we're done. */
+	if (threads > 1)
+		goto clamp;
+
+	/*
+	 * Metadata storage did not even hint that it has any parallel
+	 * capability.  If the filesystem was formatted with a stripe unit and
+	 * width, we'll treat that as evidence of a RAID setup and estimate
+	 * the number of disks.
+	 */
+	if (mp->m_sb.sb_unit > 0 && mp->m_sb.sb_width > mp->m_sb.sb_unit)
+		threads = mp->m_sb.sb_width / mp->m_sb.sb_unit;
+
+clamp:
+	/* Don't return an estimate larger than the CPU count. */
+	return min(num_online_cpus(), threads);
+}
+
+/* Estimate how many threads we need for a parallel work queue. */
+unsigned int
+xfs_pwork_guess_workqueue_threads(
+	struct xfs_mount	*mp)
+{
+	/* pwork queues are not unbounded, so we have to abide WQ_MAX_ACTIVE. */
+	return min_t(unsigned int, xfs_pwork_guess_metadata_threads(mp),
+			WQ_MAX_ACTIVE);
 }
diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
index 8133124cf3bb..6320bca9c554 100644
--- a/fs/xfs/xfs_pwork.h
+++ b/fs/xfs/xfs_pwork.h
@@ -56,6 +56,7 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
 void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
 int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
 void xfs_pwork_poll(struct xfs_pwork_ctl *pctl);
-unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
+unsigned int xfs_pwork_guess_metadata_threads(struct xfs_mount *mp);
+unsigned int xfs_pwork_guess_workqueue_threads(struct xfs_mount *mp);
 
 #endif /* __XFS_PWORK_H__ */

