Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93D5C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E5A664DD1
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhA1GGM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:06:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhA1GFU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:05:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E69E164DDB;
        Thu, 28 Jan 2021 06:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813880;
        bh=rCeDqS/414CAE5m7HLkNTPNjEtLTYMUPXF6m8ra+2D0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qE5JYCvX9oJHZ77Q4mnAxWyqQnKCdUHUToBzHTspL5Hwa27/SwoP7pQwXJvHupGF5
         rNMLJ4U0fxkRT5u/0b6nLJkqzP5UIilrReIIxFMZywnpl9YAni+emx013u9jY7Vsnl
         VCtl5sDBV8ase6W0STfqb8cN55y8zIwBov2kjjRoPtz2l+cDCWE4EOXVYT5lsR5ORC
         bZo+RXTGKp6jmMiTPglWuW0WcMTDuh4cxPr1+CQMPowsaLXdj3+8ulijyuchK9adV7
         OkN0OEAhU9cmScQlD2VBSc/wCIOy2PBt8YVXRPLKH5oOGis6/Evv0jN9VugyZUMzOa
         x/3AiRzq6DxQg==
Subject: [PATCH 10/11] xfs: expose the blockgc workqueue knobs publicly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:04:36 -0800
Message-ID: <161181387617.1525433.4270885610040303455.stgit@magnolia>
In-Reply-To: <161181381898.1525433.10723801103841220046.stgit@magnolia>
References: <161181381898.1525433.10723801103841220046.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Expose the workqueue sysfs knobs for the speculative preallocation gc
workers on all kernels, and update the sysadmin information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/admin-guide/xfs.rst |    3 +++
 fs/xfs/xfs_super.c                |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index b00b1eece9de..d2064a52811b 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -518,6 +518,9 @@ and the short name of the data device.  They all can be found in:
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

