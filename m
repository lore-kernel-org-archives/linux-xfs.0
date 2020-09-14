Return-Path: <SRS0=9PeN=CX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC7FC433E2
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 09:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EDB5207C3
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Sep 2020 09:00:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mdlmvEim"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgINJAN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 05:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgINJAL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Sep 2020 05:00:11 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01499C061788
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2020 02:00:10 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id o20so12039647pfp.11
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2020 02:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FjgeZB202I/h1vNHogL3wYy2FuQQGeSHFKuxvRcQH+w=;
        b=mdlmvEimRfhHrlzrqsMsLsBXIl7o7urtNwsCFu6vcruj6+uSEWuZLdVO9RhuMUukCY
         i+TsvJOgvwiY3zPYzdp0NArYtjlvQeRyDx2GFR6SScIe+QB3WahgKQd4a6nbPETDCO8S
         YF0bFPQKLCR/xU+17Z002k6qYXNLi2kL6zsKmbtGttRTWmaCQxUshydZk0H6v00Bl6Zu
         vLTI9N8cTCEwZMARkwO/4cu+PuJuQMOII3zKZLsLYmXR4r0SmrwGQGkiKCSlYolQaObN
         GwXQyl7RkDTD0ZsRIbObXwz4XrxJ54pG9BGWRB7o48jtfSmLtksade9uls6YtoXq57dI
         0C6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FjgeZB202I/h1vNHogL3wYy2FuQQGeSHFKuxvRcQH+w=;
        b=FR2uHnos7+A8rglFXs8Cj7Bn6y8ZioXG9gO60q4GnS0kmAfuHKrEkV3vH7Qg+odtSj
         QRIsdrD39F/o2OA3vhlhFzsXwSC8Ty10Jh7L8ZJ8paWnkM6QsIsNmSxrPjAjkJUcI/fj
         eZbTPU9UjkIEkn4OTwHUt34buCu+I/kuCCdm7gK/CWZmOMw3amhQsVhxHjf5rl3aYUZS
         eKul3Lt2BNppBd4N9j/mTCz02CSEpklp5WjD/uXUsh5K4ASiT3ycnAPIUez3+2CZLve/
         62s2+6DBSatdS5+O3GHppKtdEzlVW54wqBNKf+0+FPQ1gS/q9SBGlzcGxMfgW+cx3ID5
         d1jg==
X-Gm-Message-State: AOAM530Em3xy15T9nOvSsDzqYuwuX9SNf7edg3ohvlvpOtonjz8xu4wH
        48kMNFNU/8Pid17CtLDWfFhZQRr9Oc8=
X-Google-Smtp-Source: ABdhPJxFEL5jSNEkZUmP+Pvu1+ekdDw4Mi76pmMgMT/2xYL9tltBSwx1C+NmITEAqrpl6Jtx3hG3lQ==
X-Received: by 2002:a17:902:6bc1:: with SMTP id m1mr12727824plt.75.1600074009984;
        Mon, 14 Sep 2020 02:00:09 -0700 (PDT)
Received: from localhost.localdomain ([122.182.251.12])
        by smtp.gmail.com with ESMTPSA id a18sm7797271pgw.50.2020.09.14.02.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 02:00:09 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V2] xfs: Set xfs_buf type flag when growing summary/bitmap files
Date:   Mon, 14 Sep 2020 14:29:44 +0530
Message-Id: <20200914085944.7167-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The following sequence of commands,

  mkfs.xfs -f -m reflink=0 -r rtdev=/dev/loop1,size=10M /dev/loop0
  mount -o rtdev=/dev/loop1 /dev/loop0 /mnt
  xfs_growfs  /mnt

... causes the following call trace to be printed on the console,

XFS: Assertion failed: (bip->bli_flags & XFS_BLI_STALE) || (xfs_blft_from_flags(&bip->__bli_format) > XFS_BLFT_UNKNOWN_BUF && xfs_blft_from_flags(&bip->__bli_format) < XFS_BLFT_MAX_BUF), file: fs/xfs/xfs_buf_item.c, line: 331
Call Trace:
 xfs_buf_item_format+0x632/0x680
 ? kmem_alloc_large+0x29/0x90
 ? kmem_alloc+0x70/0x120
 ? xfs_log_commit_cil+0x132/0x940
 xfs_log_commit_cil+0x26f/0x940
 ? xfs_buf_item_init+0x1ad/0x240
 ? xfs_growfs_rt_alloc+0x1fc/0x280
 __xfs_trans_commit+0xac/0x370
 xfs_growfs_rt_alloc+0x1fc/0x280
 xfs_growfs_rt+0x1a0/0x5e0
 xfs_file_ioctl+0x3fd/0xc70
 ? selinux_file_ioctl+0x174/0x220
 ksys_ioctl+0x87/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x3e/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This occurs because the buffer being formatted has the value of
XFS_BLFT_UNKNOWN_BUF assigned to the 'type' subfield of
bip->bli_formats->blf_flags.

This commit fixes the issue by assigning one of XFS_BLFT_RTSUMMARY_BUF
and XFS_BLFT_RTBITMAP_BUF to the 'type' subfield of
bip->bli_formats->blf_flags before committing the corresponding
transaction.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---

Changelog:
  V1 -> V2: Convert ternary statement into a regular if/else statement.
  
 fs/xfs/xfs_rtalloc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6209e7b6b895..04b953c3ffa7 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -767,8 +767,14 @@ xfs_growfs_rt_alloc(
 	struct xfs_bmbt_irec	map;		/* block map output */
 	int			nmap;		/* number of block maps */
 	int			resblks;	/* space reservation */
+	enum xfs_blft		buf_type;
 	struct xfs_trans	*tp;
 
+	if (ip == mp->m_rsumip)
+		buf_type = XFS_BLFT_RTSUMMARY_BUF;
+	else
+		buf_type = XFS_BLFT_RTBITMAP_BUF;
+
 	/*
 	 * Allocate space to the file, as necessary.
 	 */
@@ -830,6 +836,8 @@ xfs_growfs_rt_alloc(
 					mp->m_bsize, 0, &bp);
 			if (error)
 				goto out_trans_cancel;
+
+			xfs_trans_buf_set_type(tp, bp, buf_type);
 			memset(bp->b_addr, 0, mp->m_sb.sb_blocksize);
 			xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 			/*
-- 
2.28.0

