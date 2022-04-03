Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29894C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Apr 2022 12:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357213AbiDCMDa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Apr 2022 08:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiDCMD2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Apr 2022 08:03:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00C62E9E0
        for <linux-xfs@vger.kernel.org>; Sun,  3 Apr 2022 05:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=SOXUETRYbT9+piFnzlJz2dX6Wg8QdGknM/4VGJvFyj8=; b=Vqq0pQoFL6m6SAFFUYUYO3+OpS
        arBRQuPeaFFjxk0dbYrB2FMY/xuGx3QDIB6ihgdxzNNtlSGzUioumS1EEqoybOX3z4hJsFuykqtOU
        GJKYnVRN21188jijzqhQKYjBKnHGDNeLip6SHoN9zlrv2SpaWodjPD8ToUMhIhjXOV3Z7FOf3hVB0
        sO53PEbWWa+DFniJtFhSechw62pf8yckFRQwB49Te/uPKrkarfbjTB5GgegWl7Hc0ZhHfksfkEOGR
        sm/uBBfaoBp0h5HCoGjL0ZDYu9xUzIRYaa/2otC2N2NDneKfyIifiQNFLwyDvXPv/AccN4Jx25GHp
        PSLRD/GA==;
Received: from [2001:4bb8:184:7553:31f9:976f:c3b1:7920] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nayvF-00BK43-O5; Sun, 03 Apr 2022 12:01:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 4/5] xfs: reduce the number of atomic when locking a buffer after lookup
Date:   Sun,  3 Apr 2022 14:01:18 +0200
Message-Id: <20220403120119.235457-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220403120119.235457-1-hch@lst.de>
References: <20220403120119.235457-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Avoid an extra atomic operation in the non-trylock case by only doing a
trylock if the XBF_TRYLOCK flag is set. This follows the pattern in the
IO path with NOWAIT semantics where the "trylock-fail-lock" path showed
5-10% reduced throughput compared to just using single lock call when not
under NOWAIT conditions. So make that same change here, too.

See commit 942491c9e6d6 ("xfs: fix AIM7 regression") for details.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index ef645e15935369..dd68aee52118c2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -636,12 +636,13 @@ xfs_buf_get_map(
 	}
 	xfs_perag_put(pag);
 
-	if (!xfs_buf_trylock(bp)) {
-		if (flags & XBF_TRYLOCK) {
+	if (flags & XBF_TRYLOCK) {
+		if (!xfs_buf_trylock(bp)) {
 			xfs_buf_rele(bp);
 			XFS_STATS_INC(mp, xb_busy_locked);
 			return -EAGAIN;
 		}
+	} else {
 		xfs_buf_lock(bp);
 		XFS_STATS_INC(mp, xb_get_locked_waited);
 	}
-- 
2.30.2

