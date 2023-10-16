Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C63FCDB465
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Oct 2023 15:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231896AbjJPP27 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Oct 2023 11:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjJPP27 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Oct 2023 11:28:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51A8AB
        for <linux-xfs@vger.kernel.org>; Mon, 16 Oct 2023 08:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=mpGkS0A1Uo88qiRRllPf4kllljvQSo3Wy0qBqa6CdU0=; b=idt/rnO6WhgTdw//BbpQOiYlqX
        wO7Q9BprarP1eSK+KtJNvc4/tDTtdnLNBf3LSj92aqs+8tomOouN6egkBdNxsbb/CwV+GMyE+uN3/
        Ew6Al28fns99BmQpNdcLg5V6kH0KUQDddGDmSDdQLoPI4XGk21mUhfXUF0hlAWGSoid7GCPipzeXo
        xfHK1gYzlA+P9bx/1H6vMMQHQDUHMYedNkgqMMgw/cofSACrO/2LoKgVqOKY8cmc1eW76s6N1tURT
        PzK6uJ1fj1kSR8KflVWFYiw2ko1Z8ck+fDpFp044PfV5anws+CWXvcvdjOIGnwGG7/8KrZb8fOl0c
        NcvNyZqw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qsPWa-009ynL-0z
        for linux-xfs@vger.kernel.org;
        Mon, 16 Oct 2023 15:28:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: only remap the written blocks in xfs_reflink_end_cow_extent
Date:   Mon, 16 Oct 2023 17:28:52 +0200
Message-Id: <20231016152852.1021679-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_reflink_end_cow_extent looks up the COW extent and the data fork
extent at offset_fsb, and then proceeds to remap the common subset
between the two.

It does however not limit the remapped extent to the passed in
[*offset_fsbm end_fsb] range and thus potentially remaps more blocks than
the one handled by the current I/O completion.  This means that with
sufficiently large data and COW extents we could be remapping COW fork
mappings that have not been written to, leading to a stale data exposure
on a powerfail event.

We use to have a xfs_trim_range to make the remap fit the I/O completion
range, but that got (apparently accidentally) removed in commit
df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents").

Note that I've only found this by code inspection, and a test case would
probably require very specific delay and error injection.

Fixes: df2fd88f8ac7 ("xfs: rewrite xfs_reflink_end_cow to use intents")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index eb9102453affbf..0611af06771589 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -784,6 +784,7 @@ xfs_reflink_end_cow_extent(
 		}
 	}
 	del = got;
+	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
 	/* Grab the corresponding mapping in the data fork. */
 	nmaps = 1;
-- 
2.39.2

