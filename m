Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEAEC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A60342312F
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbhAWSxY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:35292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbhAWSxW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF3552312F;
        Sat, 23 Jan 2021 18:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427986;
        bh=eCfcAOWo8xyU/sFfF9L06WxBfmZWpwoZblGwwnFk73o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XhRofj7wKNl/V7K6sDVzjve3OmuKc7WPDqeig1DwJEWwbYaJ/9UJwhs1Shh9vo3AN
         uvteScFXiaoBqU1vF37kFeYeWYEW23Hu53EWGUfK8VKh1Wv2ffKeBMNKz7nAGf4Wdv
         eauzLk+3tkv4CRyIEnByBLfzgdONLY+oFBOlbMeBlnnFvPS+V0+zul225vRQ8jxvWg
         vFIcqCktFruKEh/MxTTg3hzRY2cLAZeYT3Ii/8eGAVUX3pEf1sWR47Y6oOQfR4DhSn
         Ko89FfD9m+vkJRhxQCs3TvApvnzCM1gv+AWrj5EgVlL7JKgunEvnIRA+vlxR658snD
         q2/w/U93qQgmQ==
Subject: [PATCH 1/3] xfs: increase the default parallelism levels of pwork
 clients
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:08 -0800
Message-ID: <161142798840.2173328.10025204233532508235.stgit@magnolia>
In-Reply-To: <161142798284.2173328.11591192629841647898.stgit@magnolia>
References: <161142798284.2173328.11591192629841647898.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Increase the parallelism level for pwork clients to the workqueue
defaults so that we can take advantage of computers with a lot of CPUs
and a lot of hardware.  On fast systems this will speed up quotacheck by
a large factor, and the following posteof/cowblocks cleanup series will
use the functionality presented in this patch to run garbage collection
as quickly as possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iwalk.c |    5 +----
 fs/xfs/xfs_pwork.c |   17 -----------------
 fs/xfs/xfs_pwork.h |    1 -
 3 files changed, 1 insertion(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index eae3aff9bc97..fc5ea8eb701f 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -618,15 +618,12 @@ xfs_iwalk_threaded(
 {
 	struct xfs_pwork_ctl	pctl;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
-	unsigned int		nr_threads;
 	int			error;
 
 	ASSERT(agno < mp->m_sb.sb_agcount);
 	ASSERT(!(flags & ~XFS_IWALK_FLAGS_ALL));
 
-	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
-	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
-			nr_threads);
+	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk", 0);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
index b03333f1c84a..33fe952cdaf8 100644
--- a/fs/xfs/xfs_pwork.c
+++ b/fs/xfs/xfs_pwork.c
@@ -117,20 +117,3 @@ xfs_pwork_poll(
 				atomic_read(&pctl->nr_work) == 0, HZ) == 0)
 		touch_softlockup_watchdog();
 }
-
-/*
- * Return the amount of parallelism that the data device can handle, or 0 for
- * no limit.
- */
-unsigned int
-xfs_pwork_guess_datadev_parallelism(
-	struct xfs_mount	*mp)
-{
-	struct xfs_buftarg	*btp = mp->m_ddev_targp;
-
-	/*
-	 * For now we'll go with the most conservative setting possible,
-	 * which is two threads for an SSD and 1 thread everywhere else.
-	 */
-	return blk_queue_nonrot(btp->bt_bdev->bd_disk->queue) ? 2 : 1;
-}
diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
index 8133124cf3bb..e72676c0c285 100644
--- a/fs/xfs/xfs_pwork.h
+++ b/fs/xfs/xfs_pwork.h
@@ -56,6 +56,5 @@ int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
 void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
 int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
 void xfs_pwork_poll(struct xfs_pwork_ctl *pctl);
-unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
 
 #endif /* __XFS_PWORK_H__ */

