Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FC01C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F9861A21
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 14:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhCYOEL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 10:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhCYOD7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Mar 2021 10:03:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42DF1C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 07:03:59 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id m11so2154616pfc.11
        for <linux-xfs@vger.kernel.org>; Thu, 25 Mar 2021 07:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xy3iwbs7ggKcHUTrKKUPiIQ1zW95J0vGHjor1UXhyVA=;
        b=f/CDkqJO+shcNEUTLjm2T1gyGhLHN+yBOx9++yZwvwqvaaNgH2ve9xy8h/ZMSxHjfd
         bfho88Xe+RAi474G2JV5UQ7ZjpiTdbwZ8OJsYv+iYuspjeeMJTqTQ97mM/Wpdk71IGAr
         lLS5lI0DIv1RfDeDmMlzRb6UMda54fwyJlIXDtEwV3PELuFT5Rh24tinHsUxLSccN+Uw
         eX2Rw5Go44X4i2sNtgovzFJoahp5vT9uub3zjQBQpYDJhrX0ACIyYB+KqyeTXsa8R7qK
         TT/CVWb4Z2Xo6+uCBEm1MAfoldMiRko90+ud31Ts1ED9vgpWr6ONRCXJqXbdUZ+6jDd8
         EwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xy3iwbs7ggKcHUTrKKUPiIQ1zW95J0vGHjor1UXhyVA=;
        b=ZrqJbXGmefNHEz1AKGWYbGMzw9kbh7B5gIpxZrELSGEDQmNgVE9EG06PnHVcePDXjz
         fFzj4bdLvfV6/G9kEpK8FrkIP9PcscVFCXWxbxUqgKvKUo3oJ8uW3EW5uy64kQ1vh2Bs
         guqTEsBzQ/hTrfLCS4aFm97iTXi6TdQBMehycIZz+IZcEmVdkGM+ihxl/ccw8xtF3wBd
         Ih0av11CBp/sZOqJLoC0/nFHPXp+cjo8BdDMcE6jbb6AlGKDin/JPZft4ekUEKEPp0/W
         gBIGGlTmQqbaaJmPpViFOa0gfNk8y/jZCEfhC/bZxn6/uB/U5Duu+Me/b3p0iBOHTYkD
         dUYg==
X-Gm-Message-State: AOAM531XFz8qFl9pvWkFnUHaAHNhlBMA4C9rHbabPiQ/iYMisXhLL5YX
        tuSE+hjUfv+ewJwRgE5bHOvDMLSARt4=
X-Google-Smtp-Source: ABdhPJy1ffgZ0y5kWtv5A9DOzSV7ZVxZkgNvZsiBqEWSZ0kI7Nu+5zCxbvoeMO3+e9sGq/r10gvVEw==
X-Received: by 2002:a63:1e20:: with SMTP id e32mr7634678pge.345.1616681038506;
        Thu, 25 Mar 2021 07:03:58 -0700 (PDT)
Received: from localhost.localdomain ([122.171.175.121])
        by smtp.gmail.com with ESMTPSA id x2sm5876379pgb.89.2021.03.25.07.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 07:03:58 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH 1/2] xfs: Initialize xfs_alloc_arg->total correctly when allocating minlen extents
Date:   Thu, 25 Mar 2021 19:33:38 +0530
Message-Id: <20210325140339.6603-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/538 can cause the following call trace to be printed when executing on a
multi-block directory configuration,

 WARNING: CPU: 1 PID: 2578 at fs/xfs/libxfs/xfs_bmap.c:717 xfs_bmap_extents_to_btree+0x520/0x5d0
 Call Trace:
  ? xfs_buf_rele+0x4f/0x450
  xfs_bmap_add_extent_hole_real+0x747/0x960
  xfs_bmapi_allocate+0x39a/0x440
  xfs_bmapi_write+0x507/0x9e0
  xfs_da_grow_inode_int+0x1cd/0x330
  ? up+0x12/0x60
  xfs_dir2_grow_inode+0x62/0x110
  ? xfs_trans_log_inode+0x234/0x2d0
  xfs_dir2_sf_to_block+0x103/0x940
  ? xfs_dir2_sf_check+0x8c/0x210
  ? xfs_da_compname+0x19/0x30
  ? xfs_dir2_sf_lookup+0xd0/0x3d0
  xfs_dir2_sf_addname+0x10d/0x910
  xfs_dir_createname+0x1ad/0x210
  xfs_create+0x404/0x620
  xfs_generic_create+0x24c/0x320
  path_openat+0xda6/0x1030
  do_filp_open+0x88/0x130
  ? kmem_cache_alloc+0x50/0x210
  ? __cond_resched+0x16/0x40
  ? kmem_cache_alloc+0x50/0x210
  do_sys_openat2+0x97/0x150
  __x64_sys_creat+0x49/0x70
  do_syscall_64+0x33/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xae

This occurs because xfs_bmap_exact_minlen_extent_alloc() initializes
xfs_alloc_arg->total to xfs_bmalloca->minlen. In the context of
xfs_bmap_exact_minlen_extent_alloc(), xfs_bmalloca->minlen has a value of 1
and hence the space allocator could choose an AG which has less than
xfs_bmalloca->total number of free blocks available. As the transaction
proceeds, one of the future space allocation requests could fail due to
non-availability of free blocks in the AG that was originally chosen.

This commit fixes the bug by assigning xfs_alloc_arg->total to the value of
xfs_bmalloca->total.

Fixes: 301519674699 ("xfs: Introduce error injection to allocate only minlen size extents for files")
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e0905ad171f0..585f7e795023 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3586,7 +3586,8 @@ xfs_bmap_exact_minlen_extent_alloc(
 	args.fsbno = ap->blkno;
 	args.oinfo = XFS_RMAP_OINFO_SKIP_UPDATE;
 	args.type = XFS_ALLOCTYPE_FIRST_AG;
-	args.total = args.minlen = args.maxlen = ap->minlen;
+	args.minlen = args.maxlen = ap->minlen;
+	args.total = ap->total;
 
 	args.alignment = 1;
 	args.minalignslop = 0;
-- 
2.29.2

