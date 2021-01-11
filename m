Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AD4C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E52722DFB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 00:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390860AbhALAZz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:33650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404072AbhAKXYE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jan 2021 18:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAF3C22D07;
        Mon, 11 Jan 2021 23:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407402;
        bh=t+wDV2VIL7vJ6zAIiM2viMBgcSKyHr3NHpCQitJ4q5E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rXPPjp4Iba882rNRR9bfZpkXr5YGhgEE9pk5YYfw9dcnshB8ZCv52uiQgZnF+P+Ce
         0BcRyFME+Db0eQHBMPMaVD6xjelQcvcN+b3os8Izx84oUeW+fp3tAJeKhYTFwpT4hH
         4W971NoeJyt0NwSKVmRKL3jejRh+DilCpNZ41oiEYxGOms7NgHlOjc/RN4HRaXAulv
         KxzcX8KLRz0WX5JxU/q2ghIaVO6hSfdTxArr0ritjIcv10yXQJoL3/0EGtmpm9wrw7
         jFLTZhDWKzokeJ88nBHbzCFFTrQTLXTQlBaCbyRuFphj+Rgbpj8RG8d7E9i5UbDTjp
         4cSEHppfC3+7w==
Subject: [PATCH 1/7] xfs: increase the default parallelism levels of pwork
 clients
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 11 Jan 2021 15:23:21 -0800
Message-ID: <161040740189.1582286.17385075679159461086.stgit@magnolia>
In-Reply-To: <161040739544.1582286.11068012972712089066.stgit@magnolia>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
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
 fs/xfs/xfs_buf.c   |   34 ++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h   |    1 +
 fs/xfs/xfs_iwalk.c |    2 +-
 fs/xfs/xfs_mount.c |   39 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_pwork.c |   17 +++++------------
 fs/xfs/xfs_pwork.h |    2 +-
 7 files changed, 82 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f8400bbd6473..10d05c4522c9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -2384,3 +2384,37 @@ xfs_verify_magic16(
 		return false;
 	return dmagic == bp->b_ops->magic16[idx];
 }
+
+/* Estimate the amount of parallelism available for a given device. */
+unsigned int
+xfs_buftarg_guess_threads(
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
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 5d91a31298a4..fb0e0d89962c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -349,6 +349,7 @@ extern xfs_buftarg_t *xfs_alloc_buftarg(struct xfs_mount *,
 extern void xfs_free_buftarg(struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
+unsigned int xfs_buftarg_guess_threads(struct xfs_buftarg *btp);
 
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index eae3aff9bc97..2ab07d58c901 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -624,7 +624,7 @@ xfs_iwalk_threaded(
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
-	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
+	nr_threads = xfs_pwork_guess_threads(mp);
 	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
 			nr_threads);
 	if (error)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 7110507a2b6b..1e974106e58c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1358,3 +1358,42 @@ xfs_mod_delalloc(
 	percpu_counter_add_batch(&mp->m_delalloc_blks, delta,
 			XFS_DELALLOC_BATCH);
 }
+
+/*
+ * Estimate the amount of parallelism that is available for metadata operations
+ * on this filesystem.
+ */
+unsigned int
+xfs_guess_metadata_threads(
+	struct xfs_mount	*mp)
+{
+	unsigned int		threads;
+
+	/*
+	 * Estimate the amount of parallelism for metadata operations from the
+	 * least capable of the two devices that handle metadata.  Cap that
+	 * estimate to the number of AGs to avoid unnecessary lock contention.
+	 */
+	threads = xfs_buftarg_guess_threads(mp->m_ddev_targp);
+	if (mp->m_logdev_targp != mp->m_ddev_targp)
+		threads = min(xfs_buftarg_guess_threads(mp->m_logdev_targp),
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
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dfa429b77ee2..70f6c68c795f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -426,5 +426,6 @@ struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 void xfs_force_summary_recalc(struct xfs_mount *mp);
 void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
+unsigned int xfs_guess_metadata_threads(struct xfs_mount *mp);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index b03333f1c84a..5f1a5e575a48 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -118,19 +118,12 @@ xfs_pwork_poll(
 		touch_softlockup_watchdog();
 }
 
-/*
- * Return the amount of parallelism that the data device can handle, or 0 for
- * no limit.
- */
+/* Estimate how many threads we need for a parallel work queue. */
 unsigned int
-xfs_pwork_guess_datadev_parallelism(
+xfs_pwork_guess_threads(
 	struct xfs_mount	*mp)
 {
-	struct xfs_buftarg	*btp = mp->m_ddev_targp;
-
-	/*
-	 * For now we'll go with the most conservative setting possible,
-	 * which is two threads for an SSD and 1 thread everywhere else.
-	 */
-	return blk_queue_nonrot(btp->bt_bdev->bd_disk->queue) ? 2 : 1;
+	/* pwork queues are not unbounded, so we have to abide WQ_MAX_ACTIVE. */
+	return min_t(unsigned int, xfs_guess_metadata_threads(mp),
+			WQ_MAX_ACTIVE);
 }
diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
index 8133124cf3bb..f402920f7061 100644
--- a/fs/xfs/xfs_pwork.h
+++ b/fs/xfs/xfs_pwork.h
@@ -56,6 +56,6 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
 void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
 int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
 void xfs_pwork_poll(struct xfs_pwork_ctl *pctl);
-unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
+unsigned int xfs_pwork_guess_threads(struct xfs_mount *mp);
 
 #endif /* __XFS_PWORK_H__ */

