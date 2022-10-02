Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821D8C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiJBSbm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiJBSbl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:31:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910D33C152
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:31:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CADF60F07
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83362C433C1;
        Sun,  2 Oct 2022 18:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735499;
        bh=WyJhOcFVDH3DYL/05V69WOaZXRLFUSc9QLiI0fotiuQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DqsBy9yd6sFffNl/KyjifdNT+lFG6864gU0PVKf6Bx+G1WwW6k7FxOf8u8GpqvwRn
         i8dEsiU14F8tMPdq6qmM7+ydve9r5gD5Tpnk8GwZu0CqPB/Z/vd5jP6ktKKqP2/GUh
         4z9O33rmXTEF7YeqPtdRVr2e0ZPdu0UjQqlBouU4uoGyUAKsN1ZcAtzueXkPWs0XI4
         m3uCFhEw/oIVknKzi0n5YGi6InFq0DPyZes4LE4RydkdifjB6JPV6lV9ktbepEkgCV
         m+J2li2ZhV78/InVclSS0yNgK7qSPZ9YWDZ4uocljyQgKDmbtyA7ihOHfSCSCVdbqo
         xy3MCblcGxztw==
Subject: [PATCH 5/6] xfs: check that CoW fork extents are not shared
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:09 -0700
Message-ID: <166473480943.1083927.15910341627217842210.stgit@magnolia>
In-Reply-To: <166473480864.1083927.11062319917293302327.stgit@magnolia>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Ensure that extents in an inode's CoW fork are not marked as shared in
the refcount btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 6986aef80002..c3dd231eea1c 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -338,6 +338,8 @@ xchk_bmap_iextent_xref(
 	case XFS_COW_FORK:
 		xchk_xref_is_cow_staging(info->sc, agbno,
 				irec->br_blockcount);
+		xchk_xref_is_not_shared(info->sc, agbno,
+				irec->br_blockcount);
 		break;
 	}
 

