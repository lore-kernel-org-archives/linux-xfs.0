Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D70BC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F5E60F5C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhG2SoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhG2SoY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 798A960F4B;
        Thu, 29 Jul 2021 18:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584261;
        bh=t+aC/V1yMvyMzNISw+jhpHjqNCc7aIDzdaQZV1NqIWM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NF7acc+HbHCNdqUPme1D4jfMrSbhb2GdkncAVJ6RSP7bPtgn+v1X4etlIdywl7zy2
         wTqcNeS02nn3NHjK0+RX/WOjyj26sABzDn+WC/QK38rFv5lx6cATYMQ5hiYTleErKG
         YRc7pXWwy602/Guq5tln8E35DL3JHKPmeilDBcl79KPpvOoDUPtlDjZ8KgibtVekvp
         QGXHQ+La4DevAZanE6owYz1Rk6cszwT72V/U6zfz/6f74umUgUeZgAtaOMBvpnqL3J
         xgBuHU7XSTM5ia26i55wTTFE1X/UxUpAOsn4WF1m/EuTr5VhhgMkvgV2NKfTemLdKI
         H+wwauuTsxvZA==
Subject: [PATCH 05/20] xfs: don't throttle memory reclaim trying to queue
 inactive inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:21 -0700
Message-ID: <162758426119.332903.15684757078028586033.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the means to throttle queueing of inactive inodes and
push the background workers when memory gets tight, stop forcing tasks
that are evicting inodes from a memory reclaim context to wait for the
inodes to inactivate.

There's not much reason to make reclaimers wait, because it can take
quite a long time to inactivate an inode (particularly deleted ones) and
wait for the metadata updates to push through the logs until the incore
inode can be reclaimed.  In other words, memory allocations will no
longer stall on XFS when inode eviction requires metadata updates.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3e2302a44c69..82f0db311ef9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -355,6 +355,15 @@ xfs_inodegc_want_throttle(
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
+	/*
+	 * If we're in memory reclaim context, we don't want to wait for inode
+	 * inactivation to finish because it can take a very long time to
+	 * commit all the metadata updates and push the inodes through memory
+	 * reclamation.  Also, we might be the background inodegc thread.
+	 */
+	if (current->reclaim_state != NULL)
+		return false;
+
 	/* Throttle if memory reclaim anywhere has triggered us. */
 	if (atomic_read(&mp->m_inodegc_reclaim) > 0) {
 		trace_xfs_inodegc_throttle_mempressure(mp);

