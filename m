Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B9AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbiATAVP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345138AbiATAVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED68DC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:21:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD08BB81AD5
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72965C004E1;
        Thu, 20 Jan 2022 00:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638069;
        bh=fbVqAtnv1kEwurU9SQzWkFaOjBsUlYfFzYgQqsdRr3k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mfp0k33pOk0SzyN4iLmT9IcxyicNV3EUgwufApzjGY6ZHD1xowyLE0x9Ri/aZFdWL
         o7ChVEUxBS3NsHxC4yBg3zmhQ+/6mRs29f6xNv0qROQvxl+5cZTTMClc2RJpiPlhfv
         6w2eFdq0OF+o1FtER3jD0bgzCTTFbs2SF0NMJ59ETGvH/nOfsIKpzOnx9k93xJ/pSv
         nDlIDXHnyve2EZbRoeE4xnI3qn5BpOsGZztB8QmMm2HS55QTejh2NX3m1mznDrum4Z
         7qH1Q3v/GEaIC6JnwMBPoGDNxK9br9pJpFVIQy3T1Ch7z0JFBrNuiQqippJ3w4/hwF
         zGlRRHvrSv4mA==
Subject: [PATCH 41/45] libxfs: always initialize internal buffer map
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:21:09 -0800
Message-ID: <164263806915.860211.11553766371419430734.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
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
index 5086bdbc..a55e3a79 100644
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

