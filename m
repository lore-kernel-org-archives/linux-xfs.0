Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D02BC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4978722E01
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 22:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbhARWNa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 17:13:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387918AbhARWN1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 17:13:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98C1222CB1;
        Mon, 18 Jan 2021 22:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611007992;
        bh=eTNAzLm4XBy6anfXIFN2WMIrRVbKgcavNiE4gjCW3z4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pfeyTC8yi2xhyetvWYKj/o49OdPJQPAd3oYef0wtXtEVsWjt34HBi4JKt3YYLRywW
         tkoxhl1yo1TvCjxtSuQaasj+1ur0u0Ti5dUOX75hvQ1dhxuE/3RU41d0Cr+NkxNzeq
         3n441rbEFDNpfTM3i0w7h0YISoBrN28Esyu1L9U0588Fo/IdMGmWJ1rCx1XCtZSLnq
         5smcgEAMFLl0xfmDu91ovp1ZroQXKmMPtBnjhoKjENunSnJ+lczfH/GSr4++8foYEv
         cT0q5DncfVu2tJsqVtmhDdXBLPBNvLDyKL10RnKsvyDuDx243pXdJA+voGw5z+jz8z
         ALwdrHTEH2qWQ==
Subject: [PATCH 02/10] xfs: hide xfs_icache_free_eofblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 18 Jan 2021 14:13:12 -0800
Message-ID: <161100799230.90204.6358063643921626790.stgit@magnolia>
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

Change the one remaining caller of xfs_icache_free_eofblocks to use our
new combined blockgc scan function instead, since we will soon be
combining the two scans.  This introduces a slight behavior change,
since the XFS_IOC_FREE_EOFBLOCKS now clears out speculative CoW
reservations in addition to post-eof blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |    2 +-
 fs/xfs/xfs_icache.h |    1 -
 fs/xfs/xfs_ioctl.c  |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7d33bdd5ed86..e80adadcf81a 100644
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
index 56ae668dcdcf..b31155c9087c 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -63,7 +63,6 @@ int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-int xfs_icache_free_eofblocks(struct xfs_mount *, struct xfs_eofblocks *);
 void xfs_eofblocks_worker(struct work_struct *);
 void xfs_queue_eofblocks(struct xfs_mount *);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index ccff1f9ca6e9..823a7090ffd9 100644
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

