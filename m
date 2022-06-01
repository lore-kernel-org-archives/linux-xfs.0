Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 693C5C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jun 2022 10:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352405AbiFAKqd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jun 2022 06:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352397AbiFAKqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jun 2022 06:46:12 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D411A814B4;
        Wed,  1 Jun 2022 03:46:05 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id h62-20020a1c2141000000b0039aa4d054e2so2780247wmh.1;
        Wed, 01 Jun 2022 03:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H8xbwTR16tvG4U/ddVZgdCLGD5EiTHqSz9fp9YwAxOk=;
        b=Q0b7TyXJI4zCLpmxgDcZKS6gSGJFCZ9kOQ+l1SYhd7Z5B3lI0x7mH0qai4YE8SiGYc
         fbwbv5kEEzSGhIzLzQc/oAy+cRNuPecBBTRyy6kcmGEa1DxPw/jP0JuN7mn2pPMgxGC8
         eUj7idUCqCrMiZ/gJBoSJbGTea+gd8eg/RF421N3tTuABkm1eT1kf+Sk9Zeb0b0KHMtD
         hzA/jqib2sQabDHCxmtBsXEZ3hs+zyTAmygL1fbgMYcb0I76jbM9KILbW7oiu2ijwOtT
         foIS1y7EASu11kuOyC8OU151Z7t3n3KLgU7/SwEWMoGwhBQeXrnPlyjUR8dkyWcVChdO
         Yz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8xbwTR16tvG4U/ddVZgdCLGD5EiTHqSz9fp9YwAxOk=;
        b=CGFKmmvbeRdgx1+Dw4k/hjtdqUNRAGVTucauqKpQnzJlcNp2C80tffdcRim+jNEl0v
         0ObBpn2+Fxs9ac3rLXRMqs1pg3y3lwa74qNsJchi5Ccd8dBRqgHLd2wlCC062nyKx2zx
         o2SSJnHXeFtBWVH22V/bD+cxqpW3uuW1nMyCESKyKotpyH0vqWtnk72I4uT3YdDo0VAV
         M8WN7LGRZaCB6ciZktvCD+zQW56tCvbeYoYdN38nEerD86iCNfI6lS3oMEg07jSojFRI
         vueRL3ePqPV5qeVBBqqlri7Qv066ExdfWu4F2VJPfJaN+zJ4VpNy2RQv6PyUFfVfNd61
         DEZg==
X-Gm-Message-State: AOAM5303oFS9UaBASlf6s+DobMD3tTpe693zs2UadF3daFf3sL2PAY01
        jKQrxSOzaDx3BjW2tpkUGJsj1hosoXH1nA==
X-Google-Smtp-Source: ABdhPJzfstTQw50S3DeNDxhSnp4O983WemhFLKSkRUSXRxdPvg7+3xH5nL/UoaNNXGaMMw4djdypew==
X-Received: by 2002:a05:600c:1c86:b0:39c:eeb:39a3 with SMTP id k6-20020a05600c1c8600b0039c0eeb39a3mr13973476wms.40.1654080364106;
        Wed, 01 Jun 2022 03:46:04 -0700 (PDT)
Received: from localhost.localdomain ([77.137.79.96])
        by smtp.gmail.com with ESMTPSA id h9-20020a5d4309000000b002102af52a2csm1562150wrq.9.2022.06.01.03.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 03:46:03 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Tyler Hicks <code@tyhicks.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH 5.10 CANDIDATE 7/8] xfs: consider shutdown in bmapbt cursor delete assert
Date:   Wed,  1 Jun 2022 13:45:46 +0300
Message-Id: <20220601104547.260949-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220601104547.260949-1-amir73il@gmail.com>
References: <20220601104547.260949-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 1cd738b13ae9b29e03d6149f0246c61f76e81fcf upstream.

The assert in xfs_btree_del_cursor() checks that the bmapbt block
allocation field has been handled correctly before the cursor is
freed. This field is used for accurate calculation of indirect block
reservation requirements (for delayed allocations), for example.
generic/019 reproduces a scenario where this assert fails because
the filesystem has shutdown while in the middle of a bmbt record
insertion. This occurs after a bmbt block has been allocated via the
cursor but before the higher level bmap function (i.e.
xfs_bmap_add_extent_hole_real()) completes and resets the field.

Update the assert to accommodate the transient state if the
filesystem has shutdown. While here, clean up the indentation and
comments in the function.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2d25bab68764..9f9f9feccbcd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -353,20 +353,17 @@ xfs_btree_free_block(
  */
 void
 xfs_btree_del_cursor(
-	xfs_btree_cur_t	*cur,		/* btree cursor */
-	int		error)		/* del because of error */
+	struct xfs_btree_cur	*cur,		/* btree cursor */
+	int			error)		/* del because of error */
 {
-	int		i;		/* btree level */
+	int			i;		/* btree level */
 
 	/*
-	 * Clear the buffer pointers, and release the buffers.
-	 * If we're doing this in the face of an error, we
-	 * need to make sure to inspect all of the entries
-	 * in the bc_bufs array for buffers to be unlocked.
-	 * This is because some of the btree code works from
-	 * level n down to 0, and if we get an error along
-	 * the way we won't have initialized all the entries
-	 * down to 0.
+	 * Clear the buffer pointers and release the buffers. If we're doing
+	 * this because of an error, inspect all of the entries in the bc_bufs
+	 * array for buffers to be unlocked. This is because some of the btree
+	 * code works from level n down to 0, and if we get an error along the
+	 * way we won't have initialized all the entries down to 0.
 	 */
 	for (i = 0; i < cur->bc_nlevels; i++) {
 		if (cur->bc_bufs[i])
@@ -374,17 +371,11 @@ xfs_btree_del_cursor(
 		else if (!error)
 			break;
 	}
-	/*
-	 * Can't free a bmap cursor without having dealt with the
-	 * allocated indirect blocks' accounting.
-	 */
-	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP ||
-	       cur->bc_ino.allocated == 0);
-	/*
-	 * Free the cursor.
-	 */
+
+	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
+	       XFS_FORCED_SHUTDOWN(cur->bc_mp));
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
-		kmem_free((void *)cur->bc_ops);
+		kmem_free(cur->bc_ops);
 	kmem_cache_free(xfs_btree_cur_zone, cur);
 }
 
-- 
2.25.1

