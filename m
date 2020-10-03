Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98A3C4363C
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 01:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154332074B
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 01:21:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RE3YVJAF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgJCBVM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 21:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCBVM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 21:21:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5086DC0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 18:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=nz8ixFeYbySNRdzjyuN8toP2356F+Glvg5k+pmiR9a8=; b=RE3YVJAF9pC7lDOnSmUlisFZ86
        KDuRGL4Cx7gpQkDnEiGG/V0EZhXQNBntxImhvLZzSy9V8fI4Tmo2vtML2L93i+rS0ENGu6IONLXSW
        7t3P4Zpm/wsguGUIHm252PXzcONAuaQqulH634+elV8oAfsk7NKVsko64o7/ui5VGHmeHVk34BdUR
        hGDPGosAmjDjF4W6IuZEH/XMCcOfQ9iUv9ZFhSxmATS0jVzYGw/YDN2ljxWiZu65E8XLFlsc5ro+7
        Fz4CsRkXRvjs9JCEdYJ6egjlLB44OtyKGrvahDLkbEAMxIsiNL04+g29HpxvyoVMJTglxfvf2/xuP
        RX8JRHpg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kOWEY-0000ej-Fj
        for linux-xfs@vger.kernel.org; Sat, 03 Oct 2020 01:21:10 +0000
Date:   Sat, 3 Oct 2020 02:21:10 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-xfs@vger.kernel.org
Subject: Randomly fail readahead I/Os
Message-ID: <20201003012110.GC20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I have a patch in my THP development tree that fails 10% of the readahead
I/Os in order to make sure the fallback paths are tested.  This has
exposed three distinct problems so far, resulted in three patches that
are scheduled for 5.10:

    iomap: Set all uptodate bits for an Uptodate page
    iomap: Mark read blocks uptodate in write_begin
    iomap: Clear page error before beginning a write

I've hit a fourth problem when running generic/127:

XFS (sdb): Internal error isnullstartblock(got.br_startblock) at line 5807 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_bmap_collapse_extents+0x2bd/0x370
CPU: 4 PID: 4493 Comm: fsx Kdump: loaded Not tainted 5.9.0-rc3-00178-g35daf53935c9-dirty #765
Call Trace:
 xfs_corruption_error+0x7c/0x80
 xfs_bmap_collapse_extents+0x2e7/0x370
 xfs_collapse_file_space+0x133/0x1e0
 xfs_file_fallocate+0x110/0x480
 vfs_fallocate+0x128/0x270

That finally persuaded me to port the patch to the current iomap for-next
tree (see below).  Unfortunately, it doesn't reproduce, but I wonder
if it's simply that a 4kB page size is too small.  Would anyone like to
give this a shot on a 64kB page size system?  It usually takes less than
15 minutes to reproduce with my THP patchset, but doesn't reproduce in
2 hours without the THP patchset.

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 8180061b9e16..2e67631a12ce 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -193,6 +193,8 @@ iomap_read_end_io(struct bio *bio)
 	struct bio_vec *bvec;
 	struct bvec_iter_all iter_all;
 
+	if (bio->bi_private == (void *)7)
+		error = -EIO;
 	bio_for_each_segment_all(bvec, bio, iter_all)
 		iomap_read_page_end_io(bvec, error);
 	bio_put(bio);
@@ -286,6 +288,12 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
 		ctx->bio = bio_alloc(gfp, min(BIO_MAX_PAGES, nr_vecs));
+		if (ctx->rac) {
+			static int error = 0;
+			ctx->bio->bi_private = (void *)(error++);
+			if (error == 10)
+				error = 0;
+		}
 		/*
 		 * If the bio_alloc fails, try it again for a single page to
 		 * avoid having to deal with partial page reads.  This emulates
