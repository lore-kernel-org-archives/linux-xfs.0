Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F30C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 786222075E
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lYgWYGAF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgHTFof (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgHTFoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:34 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CE3C061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s14so538999plp.4
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eHUYKe1vuTxgO0DxzELBSxXT4SwhAPsSh5gu81qEa3M=;
        b=lYgWYGAFdY/ySXHFo6C5Vq7B22Sy19D3prv9FFv4X41MaKdPTAb9PBcr/yovzWkS+L
         4jbWGVUgWwMvtOHAGHBd0Q3Zb4gk4yGGkq84erj1NFImnhmHbzYO1mS9b7uImtJvZoXw
         vRkdUeMfglyv05esFvOHfNIlOPPRTaQSgAY3w5n/3l5173K0Oq33aSqZsB8NdsutP0Bp
         dBkeZYWBX7TtF3YBA9i0OpuhU/5QOwdj11XmZeyK1XCSkUT2AF61rRv9eREk8+dJadu8
         LtUxnEjN7OFn8RBKj+lchZeVbmA+dR2f6XSjQ5SPDCEkzOOeRgc6OsP+HR2KsI5s3e1e
         WDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eHUYKe1vuTxgO0DxzELBSxXT4SwhAPsSh5gu81qEa3M=;
        b=AkudH2ayPGMZe9GYjiSqIA3O0NqgAU6hlVQzCuxZTZ6vynILbWDZ5Y69VW5sSIzkAG
         0AnOA6lv8O6Szjlm7BkeCxveXPSJ7VwXWhD1inpnSPzOzhQTFvGDKDm/YSfxilP3UDUm
         Kr900c9TEefDF77HVG+HNiURnS3DmfMKMtiutnNttxCJXjW7WO3dYGhM3W7NroDurL3Z
         Z4froEaFEwnUg3yMOC8pPzlb0grLZ4DU0ERN6violA17bPZelF1t0RNShe0wS2N/Hqip
         VGexNj8p3aCKqQzScoupH7Z4T8zklPSr81lUUgLJSda7wOVuhH6ivTbSG9A/XFIeVz2v
         2MLQ==
X-Gm-Message-State: AOAM53226eRaT3MmcpB7L+sCG01LC5zY4DAaGIpDTWYtIfbMHirL26cT
        MyJsWuDTlT04AnSgcMPlv6W+csMuNKU=
X-Google-Smtp-Source: ABdhPJx8WqpPLfK4X+L4Se4lU/fNPSr0a7Uj3wPy0TU3rID39JMcrJ776EP4qo9V7WD3OK3Q5efjRw==
X-Received: by 2002:a17:902:e905:: with SMTP id k5mr1333491pld.342.1597902273927;
        Wed, 19 Aug 2020 22:44:33 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:33 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 10/10] xfs: Check for extent overflow when swapping extents
Date:   Thu, 20 Aug 2020 11:13:49 +0530
Message-Id: <20200820054349.5525-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  6 ++++++
 fs/xfs/xfs_bmap_util.c         | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index d1c675cf803a..4219b01f1034 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -100,6 +100,12 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_REFLINK_REMAP_CNT(smap_real, dmap_written) \
 	(((smap_real) ? 1 : 0) + ((dmap_written) ? 1 : 0))
+/*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index e682eecebb1f..7105525dadd5 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1375,6 +1375,17 @@ xfs_swap_extent_rmap(
 		/* Unmap the old blocks in the source file. */
 		while (tirec.br_blockcount) {
 			ASSERT(tp->t_firstblock == NULLFSBLOCK);
+
+			error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+					XFS_IEXT_SWAP_RMAP_CNT);
+			if (error)
+				goto out;
+
+			error = xfs_iext_count_may_overflow(tip, XFS_DATA_FORK,
+					XFS_IEXT_SWAP_RMAP_CNT);
+			if (error)
+				goto out;
+
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &tirec);
 
 			/* Read extent from the source file */
-- 
2.28.0

