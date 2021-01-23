Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB7DC433E6
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C4AC22EBE
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbhAWSxt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726348AbhAWSxr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:53:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87D5722D2B;
        Sat, 23 Jan 2021 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611428011;
        bh=y0v/JbXj+JIQ9DROAvWA66hWDxPqU4X2MfI4OiaRPyo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RaVOMUkjEDEkEUgnzRPCBg1pJSZoUI6l8thtGzPO77DRzUZNIpKE5jRpP49vc/tWQ
         HcocWe2daeJxw8X/0yHOcC6HsGUKfoIuIdMCmwRgPoE36WY6WOMfC30oyF4q5MCJk7
         8bOTs2qmrZihviLIWlkAKd/UhlBhi9pkKUiEUJ7dZQDQAVBlVATunE6PMnxIsew0x2
         miEYQggrFEEK08Z4Rp6ZiuG3XQ2ZjGXF771ctC7MZ2DaQVvWEiAQK3+UdwX9opxtYq
         WGtgNGdVaQE604Q/m3hKXvhnK+9CxTvMuU2lZoF/14zwv8Y56Tt/B2oMym5VmFQSck
         mzWpwEQFYVwyA==
Subject: [PATCH 2/9] xfs: hide xfs_icache_free_eofblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:33 -0800
Message-ID: <161142801309.2173480.14698096027536542728.stgit@magnolia>
In-Reply-To: <161142800187.2173480.17415824680111946713.stgit@magnolia>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change the one remaining caller of xfs_icache_free_eofblocks to use our
new combined blockgc scan function instead, since we will soon be
combining the two scans.  This introduces a slight behavior change,
since the XFS_IOC_FREE_EOFBLOCKS now clears out speculative CoW
reservations in addition to post-eof blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_icache.h |    1 -
 fs/xfs/xfs_ioctl.c  |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5dda039b1433..4137ad853b17 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1324,7 +1324,7 @@ xfs_inode_free_eofblocks(
 	return ret;
 }
 
-int
+static int
 xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 583c132ae0fb..c23e49aab683 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -61,7 +61,6 @@ int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
 void xfs_eofblocks_worker(struct work_struct *);
 void xfs_queue_eofblocks(struct xfs_mount *);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index da407934364c..9559a06b865f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2359,7 +2359,7 @@ xfs_file_ioctl(
 		trace_xfs_ioc_free_eofblocks(mp, &keofb, _RET_IP_);
 
 		sb_start_write(mp->m_super);
-		error = xfs_icache_free_eofblocks(mp, &keofb);
+		error = xfs_blockgc_free_space(mp, &keofb);
 		sb_end_write(mp->m_super);
 		return error;
 	}

