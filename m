Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C9AC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbjEZBeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241716AbjEZBeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:34:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747DF125
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:34:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11B2F61A8E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DEA0C433D2;
        Fri, 26 May 2023 01:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064840;
        bh=LQ2Qf0pa7wyWOuAsrLQFfjsM86E62waqroqmh8dfcoI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Tw+P2JUu8SWsWl6pK29xGkc0Gal+jI2CLk+wS2sAMSdFFl+/v9ekqIusEAXC6rVH1
         0HdoBHx49gDlkHGRXL27xajDropTihZ9DJpXd/uWD5wC3FEHKqT5jqUxJuI9fb3qh+
         C2yhv1EklONAkoOJPXc+SLmLIZBlLbxlqD6PYDt4L84WJyEVXUQJ0pD6L7lRZhLdcG
         jrpV9R/57zGr3Pvq1J3Jd5RExf7Bw0DWkd2+bapCW1kuS20cZZ7S1/fOIo/12D4XVn
         xXMxUSW7MuLGKH0s9IY28cXDPJWu9Zrili7RhbEyntka+/9KzNeRAq2EH4bC7KpQHX
         KySHnjbdT6qnQ==
Date:   Thu, 25 May 2023 18:33:59 -0700
Subject: [PATCH 5/5] xfs: flag empty xattr leaf blocks for optimization
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066898.3737146.8274790344499205151.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066818.3737146.14391441616329630322.stgit@frogsfrogsfrogs>
References: <168506066818.3737146.14391441616329630322.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Empty xattr leaf blocks at offset zero are a waste of space but
otherwise harmless.  If we encounter one, flag it as an opportunity for
optimization.

If we encounter empty attr leaf blocks anywhere else in the attr fork,
that's corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c    |   11 +++++++++++
 fs/xfs/scrub/dabtree.h |    2 ++
 2 files changed, 13 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 7dccbc849b19..07e8ca840745 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -420,6 +420,17 @@ xchk_xattr_block(
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
 
+	/*
+	 * Empty xattr leaf blocks mapped at block 0 are probably a byproduct
+	 * of a race between setxattr and a log shutdown.  Anywhere else in the
+	 * attr fork is a corruption.
+	 */
+	if (leafhdr.count == 0) {
+		if (blk->blkno == 0)
+			xchk_da_set_preen(ds, level);
+		else
+			xchk_da_set_corrupt(ds, level);
+	}
 	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
 		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused > mp->m_attr_geo->blksize)
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index d654c125feb4..de291e3b77dd 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -37,6 +37,8 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
+
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		xchk_da_btree_rec_fn scrub_fn, void *private);

