Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CE1C4167D
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Oct 2023 09:51:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbjJaJvu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Oct 2023 05:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbjJaJvJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2023 05:51:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F9DD50
        for <linux-xfs@vger.kernel.org>; Tue, 31 Oct 2023 02:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=IplXfwz/WVY8bieZu4VbYzO/A3iOxklUtZz3J1EW/Y0=; b=oI1Ka8CD6LphrHo57SpKEEh1+a
        RrqR5AfKCvOWfeLTWaprdXNYuhQmXu/VN+x9DVHDAACOLO5hTjyGiDFsYhBcKI0ncHodRQbMYGf4y
        jGXFPpPN/lvD4xpJ0DkYxRhGtGyM+PCbgYiXla7tAm+JC3nJpiOz9MnVvbNnP+mAtPJQ7RFMRcBcg
        LITOoMuhuF6zTIh05QShnXZHbhrjaLOXFcByLLis9sjmPj3rBkY2grsI5gvN0JHhgwaSqWFpf5Tj7
        A78RZ7Ull/NU+w/jkF2FJHxxg4OGIQGBlC3Ev7qAyFkrd/jId+RfIZ/yrVavQQYTgVC342oi/xugD
        9MhmrBjg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qxlOV-004tkY-0O;
        Tue, 31 Oct 2023 09:50:43 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH, realtime-rmap branch] xfs: lock the RT bitmap inode in xfs_efi_item_recover
Date:   Tue, 31 Oct 2023 10:50:38 +0100
Message-Id: <20231031095038.1559309-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_trans_free_extent expects the rtbitmap and rtsum inodes to be locked.
Ensure that is the case during log recovery as well.

Fixes: 3ea32f5cc5f9 ("xfs: support logging EFIs for realtime extents")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---

I found this when testing the realtime-rmap branch with additional
patches on top.  Probably makes sense to just fold it in for the next
rebase of that branch.

 fs/xfs/xfs_extfree_item.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 5b3e7dca4e1ba0..070070b6401d66 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -768,6 +768,8 @@ xfs_efi_item_recover(
 
 		if (!requeue_only) {
 			xfs_extent_free_get_group(mp, &fake);
+			if (xfs_efi_is_realtime(&fake))
+				xfs_rtbitmap_lock(tp, mp);
 			error = xfs_trans_free_extent(tp, efdp, &fake);
 			xfs_extent_free_put_group(&fake);
 		}
-- 
2.39.2

