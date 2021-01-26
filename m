Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE3FC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71BB920679
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jan 2021 23:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbhAZXDk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728525AbhAZFNy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 00:13:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9C2520732;
        Tue, 26 Jan 2021 05:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611637993;
        bh=/AOyA3P8XOJxQa83bPZA2CXeEvPJNs5oZNdbyZyQQvE=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=jWETJd/fqGMHb/w8mhBuU7jp+QpuJnMmD9y6HPJLf8jgIzzSDkg4Rn8riMSWgnlaZ
         A0/GcEsT+o2Tw/BBWZMsa6vROPgIlYbcbR0vXhwldJVwswHnm1VEpiqbuQpuZ9rwhD
         pM1VDHe5uHUYKqz30ylNYzd6wKymGE5l1aWIr8mCw6CUq2rxvYggMsOPGj3/i5Xnrh
         H3UK6iudPxRxb4RB+NXzzv1NR9rYWYgnxuA1TU8K/gkZDXblKKTdYPrXC3kJ0csPcW
         QjlScsNLibMJOIo4Fo2aKYpqXLoNBk64WQMGK8nvA8u3li2svz1P5wUByAc/42mbVn
         w4bdbX9TjyPiQ==
Date:   Mon, 25 Jan 2021 21:13:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: [PATCH 10/9] xfs: expose the blockgc workqueue knobs publicly
Message-ID: <20210126051313.GV7698@magnolia>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161142800187.2173480.17415824680111946713.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Expose the workqueue sysfs knobs for the speculative preallocation gc
workers on all kernels, and update the sysadmin information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    3 +++
 fs/xfs/xfs_super.c                |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 5fd14556c6fe..09365464ad9d 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -513,6 +513,9 @@ and the short name of the data device.  They all can be found in:
 ================  ===========
   xfs_iwalk-$pid  Inode scans of the entire filesystem. Currently limited to
                   mount time quotacheck.
+  xfs-blockgc     Background garbage collection of disk space that have been
+                  speculatively allocated beyond EOF or for staging copy on
+                  write operations.
 ================  ===========
 
 For example, the knobs for the quotacheck workqueue for /dev/nvme0n1 would be
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2b04818627e9..21b1d034aca3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -520,7 +520,7 @@ xfs_init_mount_workqueues(
 		goto out_destroy_cil;
 
 	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
-			XFS_WQFLAGS(WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM),
+			WQ_SYSFS | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM,
 			0, mp->m_super->s_id);
 	if (!mp->m_blockgc_workqueue)
 		goto out_destroy_reclaim;
