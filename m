Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E30CAC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E1D64DD9
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 06:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhA1GFd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 01:05:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231272AbhA1GEf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:04:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50A3061492;
        Thu, 28 Jan 2021 06:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813834;
        bh=H7Ugtwv7kMPEUgjeVwzadUmG0RpKbypvn1ZxT81F6L0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZqOLWoywSbvVQJnm0hCLqE1Bb8q1tcVKoAcCUu6CVnqptdyg0byqbc66TXDWDeKqX
         e1yPCpM9OSpioU/v0WhVPo80RNZ0mNwvNXyTGDqJr53+uxn3YMXwQaSBmF3Prfk27B
         fWxpa187Wrut8tdX4xXUPlDhsQcg25bdqGMabcLFdcQgRnpzvOCqmD9YnG59ggeNUZ
         /b31V810TFs2F159ktLErHLPjpnn6TIeHfwP1fHGFZIvsIomWhgE/r/XIeZxzIEWoR
         ghndt52dT4wALBvmY4zQI56taU67snq71DKSxzyHBtWFZMYFqHlE4FTx5D5xb8cebp
         jiXu9y7sUTRig==
Subject: [PATCH 02/11] xfs: hide xfs_icache_free_eofblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:03:50 -0800
Message-ID: <161181383058.1525433.5618255378911179628.stgit@magnolia>
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
index 15dcf57b4b19..2e1b3887754a 100644
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
index cc6ddc6d22a0..7e22346e8ff5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2358,7 +2358,7 @@ xfs_file_ioctl(
 		trace_xfs_ioc_free_eofblocks(mp, &keofb, _RET_IP_);
 
 		sb_start_write(mp->m_super);
-		error = xfs_icache_free_eofblocks(mp, &keofb);
+		error = xfs_blockgc_free_space(mp, &keofb);
 		sb_end_write(mp->m_super);
 		return error;
 	}

