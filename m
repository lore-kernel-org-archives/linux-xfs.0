Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17882C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 11:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E69EC61154
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 11:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhDBLvJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 07:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhDBLvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 07:51:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3EBC0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 04:51:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t20so2404600plr.13
        for <linux-xfs@vger.kernel.org>; Fri, 02 Apr 2021 04:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JVXzN1LiZ7nRWq/AzTH7sjCZzqzHP7NJTzcueTDgY7c=;
        b=MDkGTRmLoSPgpPVPxuX35u/GC6wmNhdvrS3IjWA6qTu8M1mbGcSidf2xJmg+FakT9G
         JOGErPas5sHxwVMwjtZPZkSEG5u3GQ6ufn8VTk4C0+tIv4Z1tT7tdp6guY2ftHqB1R2r
         4wUsnPutZFUB9YWVj++w9JgvLJtDLfqL9J1wFu/tJJiyh0W1DXiyuAq6zXZ4XPI/RqmP
         h9f5Hlknh5WjKzCkNPqnsLKE4Og6dIUuDdyh/2fANj/3xvXiue+JY6sULhWCWW9H0Tn5
         FmOEdRWzYv3mGkVD/VJo3slfwL7N4lRbTq4TdKrVsy58aJHQDPBzBQ0YuwLNoZWq7X+Y
         czVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JVXzN1LiZ7nRWq/AzTH7sjCZzqzHP7NJTzcueTDgY7c=;
        b=LYVKU0IvVydTFj1tYTOQM64tFwdBjwzdI2by+phxVtaguTS+0kYrdAy3MT17z3yxow
         Ui4N5EVjFKNkAWZpl0ub9POArJ5s3bZr5oG2Fg/OpvyVIw0glF3ljJ43wGdr3J5T58Ec
         sQ/3HRe6fFwT4phAZV/zTKicY5+/GtAD3yT1MqKdFuEw1tPtPx8EBNlm6pxYvHNl65QO
         ytGx4t156FRb3aergeJPu5p/qAYZaCCuUQYZAjMxN4l8MB6oiiv+xlAMP7TYO3ezKUkk
         uN85lLp1GJ55oKqdwo/BOet7LSn/TOgPo2+ZpY0VY/O79B2N4fHi1biqX5nIt6mrJFGi
         3rHA==
X-Gm-Message-State: AOAM531pnBFdqn0ODfFBWhqY+jTkSc2kH1F/RUfnu8aLLz84Htg6YG3V
        R8W9RE+ZURt0CULBoeaeAd41iMNfEyY=
X-Google-Smtp-Source: ABdhPJw7mOBMZcwdMEQ3Qb4p+T+XjiGRy6GpwCZhVeZRl2/qyXRPsDypXjEL9QFN1x6vFoVIoLHfRw==
X-Received: by 2002:a17:902:9a98:b029:e6:faf5:7bc2 with SMTP id w24-20020a1709029a98b02900e6faf57bc2mr12787177plp.61.1617364267140;
        Fri, 02 Apr 2021 04:51:07 -0700 (PDT)
Received: from localhost.localdomain ([122.171.33.103])
        by smtp.gmail.com with ESMTPSA id l14sm7572643pja.37.2021.04.02.04.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 04:51:06 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH V1.1] xfs: Use struct xfs_bmdr_block instead of struct xfs_btree_block to calculate root node size
Date:   Fri,  2 Apr 2021 17:21:00 +0530
Message-Id: <20210402115100.13478-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210401164525.8638-1-chandanrlinux@gmail.com>
References: <20210401164525.8638-1-chandanrlinux@gmail.com>
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
V1 -> V1.1
  1. Initialize "block" variable during declaration.
  
 fs/xfs/libxfs/xfs_bmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 585f7e795023..006dd2150a6f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -927,13 +927,15 @@ xfs_bmap_add_attrfork_btree(
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	int			*flags)		/* inode logging flags */
 {
+	struct xfs_btree_block	*block = ip->i_df.if_broot;
 	xfs_btree_cur_t		*cur;		/* btree cursor */
 	int			error;		/* error return value */
 	xfs_mount_t		*mp;		/* file system mount struct */
 	int			stat;		/* newroot status */
 
 	mp = ip->i_mount;
-	if (ip->i_df.if_broot_bytes <= XFS_IFORK_DSIZE(ip))
+
+	if (XFS_BMAP_BMDR_SPACE(block) <= XFS_IFORK_DSIZE(ip))
 		*flags |= XFS_ILOG_DBROOT;
 	else {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, XFS_DATA_FORK);
-- 
2.29.2

