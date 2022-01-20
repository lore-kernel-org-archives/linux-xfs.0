Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D20BC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345268AbiATAYn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357802AbiATAYl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD27C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D9A36150C
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB36BC004E1;
        Thu, 20 Jan 2022 00:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638280;
        bh=vMv8nZ53aQ0LHgJKen8/xl1qEZSCpPsaBDx79Bg06SU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ovEzGiPKe8s+PBy7zjrfR3s7ccyTc9ESY5PAIfsnpHBPb7yOWdk6RtDxV0kLY2RpB
         PTic/nY47ogeEYlp3AAS2aOocdlkrs5P0ZFi8W80frrBgtlcDYfmKuudiccZryK6Co
         FVJWCyME9ZPzZebUUIaptb4Z9n6adJfWcSPyDxr+sqV7EFOtySz7u6zqBLfQoZzDUe
         Wapg3yxEY+TCng0EgmjcWR/JrFbvVYOJflMZXouNvGhRrTAs4NS9rysyDpFCiq7ZR6
         gX60XAhsv5EF63bAS8lNCPE+KUMteAAE3hM2TkLt65ecFAsAijpVuApCJIG2vEcSks
         hMulul0Bd7WaQ==
Subject: [PATCH 16/48] xfs: rearrange xfs_btree_cur fields for better packing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:40 -0800
Message-ID: <164263828041.865554.10591791910056583870.stgit@magnolia>
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

Source kernel commit: 69724d920e7c30ca4421af615c499e92cfcc550b

Reduce the size of the btree cursor structure some more by rearranging
fields to eliminate unused space.  While we're at it, fix the ragged
indentation and a spelling error.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 0181fc98..eaffd822 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -234,11 +234,11 @@ struct xfs_btree_cur
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
 	const struct xfs_btree_ops *bc_ops;
-	uint			bc_flags; /* btree features - below */
+	unsigned int		bc_flags; /* btree features - below */
+	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
-	uint8_t		bc_nlevels;	/* number of levels in the tree */
-	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
-	int		bc_statoff;	/* offset of btre stats array */
+	uint8_t			bc_nlevels; /* number of levels in the tree */
+	int			bc_statoff; /* offset of btree stats array */
 
 	/*
 	 * Short btree pointers need an agno to be able to turn the pointers

