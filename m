Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40BEFC4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:18:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C22820736
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:18:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dUMyUDY/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgEGMS5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMS5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:18:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DE8C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EjaJw1j2Xvw9Gk+eU6sA4Le6fQn6YsA72iiV6/LzuKw=; b=dUMyUDY/c1uPwo5+h6OmDzr3WP
        vF7ir5Z2qsdlZjsI94hoWcjkRNAzHKYBiKzhGF6NJXxkcUBQtB+CZBi5lavizooBNM8IUIb9H0/uv
        rCenbV50sXHSTVxb9YIwvo7tdLZaHGWJpeVIJbsWaDAPm7SA7Od8n6fPGWg779sucY9SzWNDVpKBO
        BW18nLoLr5W9TKato4nfZH1M4z/9pR/AmWEktxkMEEklosFmoXNSnLwoPfQrdhI2gOoNkgGsGoE9m
        7ZK08qfbm46bJnw3/Rk0RZYXFxxoB/uydZTJbQIiTz5Uuqvna8AcvG1V9iszWPZUg5wEZXlRzbkkG
        NbXrYvZw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUO-00052v-VX; Thu, 07 May 2020 12:18:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Ren Xudong <renxudong1@huawei.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/58] xfs: add agf freeblocks verify in xfs_agf_verify
Date:   Thu,  7 May 2020 14:17:54 +0200
Message-Id: <20200507121851.304002-2-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

Source kernel commit: d0c7feaf87678371c2c09b3709400be416b2dc62

We recently used fuzz(hydra) to test XFS and automatically generate
tmp.img(XFS v5 format, but some metadata is wrong)

xfs_repair information(just one AG):
agf_freeblks 0, counted 3224 in ag 0
agf_longest 536874136, counted 3224 in ag 0
sb_fdblocks 613, counted 3228

Test as follows:
mount tmp.img tmpdir
cp file1M tmpdir
sync

In 4.19-stable, sync will stuck, the reason is:
xfs_mountfs
xfs_check_summary_counts
if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
!xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
return 0;  -->just return, incore sb_fdblocks still be 613
xfs_initialize_perag_data

cp file1M tmpdir -->ok(write file to pagecache)
sync -->stuck(write pagecache to disk)
xfs_map_blocks
xfs_iomap_write_allocate
while (count_fsb != 0) {
nimaps = 0;
while (nimaps == 0) { --> endless loop
nimaps = 1;
xfs_bmapi_write(..., &nimaps) --> nimaps becomes 0 again
xfs_bmapi_write
xfs_bmap_alloc
xfs_bmap_btalloc
xfs_alloc_vextent
xfs_alloc_fix_freelist
xfs_alloc_space_available -->fail(agf_freeblks is 0)

In linux-next, sync not stuck, cause commit c2b3164320b5 ("xfs:
use the latest extent at writeback delalloc conversion time") remove
the above while, dmesg is as follows:
[   55.250114] XFS (loop0): page discard on page ffffea0008bc7380, inode 0x1b0c, offset 0.

Users do not know why this page is discard, the better soultion is:
1. Like xfs_repair, make sure sb_fdblocks is equal to counted
(xfs_initialize_perag_data did this, who is not called at this mount)
2. Add agf verify, if fail, will tell users to repair

This patch use the second soultion.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: Ren Xudong <renxudong1@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index a92ca524..09db6693 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2854,6 +2854,13 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
 		return __this_address;
 
+	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
+		return __this_address;
+
+	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
+	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
+		return __this_address;
+
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
@@ -2865,6 +2872,10 @@ xfs_agf_verify(
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
 		return __this_address;
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
+		return __this_address;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2878,6 +2889,11 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return __this_address;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_blocks) >
+	    be32_to_cpu(agf->agf_length))
+		return __this_address;
+
 	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
 	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
-- 
2.26.2

