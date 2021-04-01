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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135CBC43462
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 18:03:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E043A6112E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Apr 2021 18:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbhDASDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbhDAR5R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Apr 2021 13:57:17 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D8AC031150
        for <linux-xfs@vger.kernel.org>; Thu,  1 Apr 2021 09:45:33 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id s21so1467511pjq.1
        for <linux-xfs@vger.kernel.org>; Thu, 01 Apr 2021 09:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f+anl2m9ZWMWpCmRcPfFGK1e1Rze610labL8K7bLAq8=;
        b=Fka/D6mzjuUF/a6NxLXu5NHSQ2bjwjn7U9I3WdWNggQ2gSO/3dHpMgzhSSAHET02VA
         wWVRmvl2oIRH3+xmkNskW/xvdcP8jMTV4fubYnjsscuYi6CmBW5qYVajQnspxpaNhCaB
         PfccEgH+PyHgIGKKwZ4dilva5NDm7x4MaxFEsmvpL0WkI5jVtqWSMimWFnGR2iAhACzk
         Zt+y5M4Cp2ZuVDGpvFw6txpzqa/4KSESDSajN412Y88aOG6KLNBWNaG+wYxZ5GIIYK2o
         BTo2+OabdSYbsrps+kRReIZ9q1FaNJibVkx/0bbvvRrkoJUOKnCFpIoM7+j73aF0EEEa
         ZvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f+anl2m9ZWMWpCmRcPfFGK1e1Rze610labL8K7bLAq8=;
        b=hqCuWehBfpo+dCcjrDT4cgdSmczDSwQ6YjCyXmf/ah25TOgSb0REhxyZLkeG9qTzYe
         UI6wXhSDCY65nG3aa76YlmVssoMlD02nNdWMrnj2RaiVBAJ9x83KFvWKl1O8vQoCfksK
         NdOfjUw0CEHzd5RRxWNmMD3kwpTBfII3GOJbyXXCL+LZVGztlaeiUWj2DJoDrANh1Zka
         A+1BvDhdOj7SRKOfiwsg5hF5zyCkxDJKDvWX3a6j6qLZl05EgdHYpwgTG5XnBzTSwi+E
         wHDEDl0x1P924cCOQkDxJWENB5BG7fjLgRK+4cMCWD7RfqL1FQau2j1k1WYDBUd8aZME
         6fjQ==
X-Gm-Message-State: AOAM533eqrZusIuBIyG3sUgGQ4m7mmXKaSXi9Vh1GwJKFb7e5kAHLMZk
        peccDQHeXh+eo1lfd85Qq12JISa1FYI=
X-Google-Smtp-Source: ABdhPJxSrziI2WCkVYTfFtb4s/DKpVda24CHlr52zDu0NeE0U7BHvIwdUqVGny/JgN52lrsMiFyRww==
X-Received: by 2002:a17:903:4106:b029:e7:49bd:4266 with SMTP id r6-20020a1709034106b02900e749bd4266mr8821117pld.56.1617295532812;
        Thu, 01 Apr 2021 09:45:32 -0700 (PDT)
Received: from localhost.localdomain ([122.182.240.228])
        by smtp.gmail.com with ESMTPSA id i10sm7052384pgo.75.2021.04.01.09.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:45:32 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>
Subject: [PATCH] xfs: Use struct xfs_bmdr_block instead of struct xfs_btree_block to calculate root node size
Date:   Thu,  1 Apr 2021 22:15:25 +0530
Message-Id: <20210401164525.8638-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The incore data fork of an inode stores the bmap btree root node as 'struct
xfs_btree_block'. However, the ondisk version of the inode stores the bmap
btree root node as a 'struct xfs_bmdr_block'.

xfs_bmap_add_attrfork_btree() checks if the btree root node fits inside the
data fork of the inode. However, it incorrectly uses 'struct xfs_btree_block'
to compute the size of the bmap btree root node. Since size of 'struct
xfs_btree_block' is larger than that of 'struct xfs_bmdr_block',
xfs_bmap_add_attrfork_btree() could end up unnecessarily demoting the current
root node as the child of newly allocated root node.

This commit optimizes space usage by modifying xfs_bmap_add_attrfork_btree()
to use 'struct xfs_bmdr_block' to check if the bmap btree root node fits
inside the data fork of the inode.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 585f7e795023..63fcac13d29c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -927,13 +927,16 @@ xfs_bmap_add_attrfork_btree(
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	int			*flags)		/* inode logging flags */
 {
+	struct xfs_btree_block	*block;
 	xfs_btree_cur_t		*cur;		/* btree cursor */
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* file system mount struct */
 	int			stat;		/* newroot status */
 
 	mp = ip->i_mount;
-	if (ip->i_df.if_broot_bytes <= XFS_IFORK_DSIZE(ip))
+	block = ip->i_df.if_broot;
+
+	if (XFS_BMAP_BMDR_SPACE(block) <= XFS_IFORK_DSIZE(ip))
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
-- 
2.29.2

