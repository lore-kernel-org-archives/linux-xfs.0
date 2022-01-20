Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A058C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345270AbiATAYm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60642 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345222AbiATAYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4678861506
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07E0C340E4;
        Thu, 20 Jan 2022 00:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638269;
        bh=u6MAC080rbTQiXdhwVcHKNuOBKeulSvGZ/1GZDzIWYY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bc8fRZSUqwMBLrT7nm1juFLLWaVgBaMwwoWC4nu1VoZ4XYhBMwSgTCDMAiT7UscLS
         V+BWPBUsJadG3enz9k++NMF6TXjMePXQwl/PVXbGMHepJrVQWGhMziKnn4vLUuHaJY
         gXGDxcWXzr3BdkZVnkFQesWlr6pwuLpiLmkUoGBLxkrRvzvOc3Vu5eml0GK25ZvkTX
         QYtdeP0dcVKsTkq6+mE7OAc/WqMIOAP46UlFnnSfaPNjzPyT4XzibdVGEJtulHZznl
         oiOSCcJqLPu5r56eO+Y3HwcdcNFGp5MMTEX3TVPuJ92qBc0SN3HGZnQm3asfqOii1F
         GeLqG6xyp8qow==
Subject: [PATCH 14/48] xfs: reduce the size of nr_ops for refcount btree
 cursors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:29 -0800
Message-ID: <164263826932.865554.14589270185631642317.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: efb79ea31067ae3dd0f348eb06e6b9a5e9907078

We're never going to run more than 4 billion btree operations on a
refcount cursor, so shrink the field to an unsigned int to reduce the
structure size.  Fix whitespace alignment too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 49ecc496..1018bcc4 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -181,18 +181,18 @@ union xfs_btree_irec {
 
 /* Per-AG btree information. */
 struct xfs_btree_cur_ag {
-	struct xfs_perag	*pag;
+	struct xfs_perag		*pag;
 	union {
 		struct xfs_buf		*agbp;
 		struct xbtree_afakeroot	*afake;	/* for staging cursor */
 	};
 	union {
 		struct {
-			unsigned long nr_ops;	/* # record updates */
-			int	shape_changes;	/* # of extent splits */
+			unsigned int	nr_ops;	/* # record updates */
+			unsigned int	shape_changes;	/* # of extent splits */
 		} refc;
 		struct {
-			bool	active;		/* allocation cursor state */
+			bool		active;	/* allocation cursor state */
 		} abt;
 	};
 };

