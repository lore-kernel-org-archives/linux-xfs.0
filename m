Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F74C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1719610D1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbhINCou (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:44:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237565AbhINCou (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:44:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FFF9610D1;
        Tue, 14 Sep 2021 02:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587413;
        bh=UxQxJ4pMUx3E9hmdGz8f1royBn/yKmtMgQ/3n8+Whls=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Es0rR52+ZcRFOhG1HpqxU3K//FxFia2uC42J8tfHl2GkpWsXbhpI83LwgM+He2n2y
         JCMTjV5Fr4lQNDeLfLfoFU3HN6MK5PA5I5QKDP3fNtAMGBop86jZWHeAjPSvDtAHzK
         mdD6GjTFM1jjC9aCM4FAwxzjl/ckTZSUg/L5PQMFY4p69ow9tRRR5m8nJghMASUpRq
         Y+WUeNzQcKtM8Lbh+6rPqXQQ3zmAXjDyhy3EhmUR/0J3DWG5shBjXaQph6UF0JSio5
         mi873VaCi5UajGBIpkCoMh7aPyBYY2dEQ9wwH6tHhX62cQWAGynsPm8ukUIZ6mPGQv
         DdIO0CMFRf1Fw==
Subject: [PATCH 39/43] libxfs: always initialize internal buffer map
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:43:33 -0700
Message-ID: <163158741330.1604118.2384362360060613446.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The __initbuf function is responsible for initializing the fields of an
xfs_buf.  Buffers are always required to have a mapping, though in the
typical case there's only one mapping, so we can use the internal one.

The single-mapping b_maps init code at the end of the function doesn't
quite get this right though -- if a single-mapping buffer in the cache
was allowed to expire and now is being repurposed, it'll come out with
b_maps == &__b_map, in which case we incorrectly skip initializing the
map.  This has gone unnoticed until now because (AFAICT) the code paths
that use b_maps are the same ones that are called with multi-mapping
buffers, which are initialized correctly.

Anyway, the improperly initialized single-mappings will cause problems
in upcoming patches where we turn b_bn into the cache key and require
the use of b_maps[0].bm_bn for the buffer LBA.  Fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/rdwr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index f4e76029..03dc2917 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -251,9 +251,11 @@ __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 	bp->b_ops = NULL;
 	INIT_LIST_HEAD(&bp->b_li_list);
 
-	if (!bp->b_maps) {
-		bp->b_nmaps = 1;
+	if (!bp->b_maps)
 		bp->b_maps = &bp->__b_map;
+
+	if (bp->b_maps == &bp->__b_map) {
+		bp->b_nmaps = 1;
 		bp->b_maps[0].bm_bn = bp->b_bn;
 		bp->b_maps[0].bm_len = bp->b_length;
 	}

