Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66DBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbiL3Wst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiL3Wsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:48:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75D418E1D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 829EC61B98
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E316BC433D2;
        Fri, 30 Dec 2022 22:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440524;
        bh=ZRhF/CD3vj+W3jHqDsyOgm+hjdQ+XWFt4fKnNFf7MgA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ejd7a4EtVEih2YfJAQRseXzt9JCck/o/yvBCQGjLESOY5/DuyctkPpHnQ3XDRxYDR
         9I7s9vvfbp/gz5JqbnSxMUVcVX2jvWf1jA2yC8Uam7SYVqS0kslQkerM3vbNIXaM1w
         tKBlZ9EpNgTrLHtckC+RAEGSqhdYfaIWQjKJRbJHdCWezgMQE0+qNscVDbAl6nsimP
         2/oWZbj2EeAMEIjdYLtRtFLQCaty2iN/ADbPfhgfBQqv7dT2s304lWge77QnVfvOBX
         wjNv8zpi4u59dbT3J8iXk/jfFcD0aMXIxogQALEdL1Fpyxs3T+/58aUwZUc3qQPI8l
         PGfKK9oaMsH7Q==
Subject: [PATCH 02/11] xfs: don't shadow @leaf in xchk_xattr_block
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:46 -0800
Message-ID: <167243830637.687022.2082036540508178837.stgit@magnolia>
In-Reply-To: <167243830598.687022.17067931640967897645.stgit@magnolia>
References: <167243830598.687022.17067931640967897645.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't shadow the leaf variable here, because it's misleading to have one
place in the codebase where two variables with different types have the
same name.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 95752e300105..3020892b796e 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -342,10 +342,10 @@ xchk_xattr_block(
 
 	/* Check all the padding. */
 	if (xfs_has_crc(ds->sc->mp)) {
-		struct xfs_attr3_leafblock	*leaf = bp->b_addr;
+		struct xfs_attr3_leafblock	*leaf3 = bp->b_addr;
 
-		if (leaf->hdr.pad1 != 0 || leaf->hdr.pad2 != 0 ||
-		    leaf->hdr.info.hdr.pad != 0)
+		if (leaf3->hdr.pad1 != 0 || leaf3->hdr.pad2 != 0 ||
+		    leaf3->hdr.info.hdr.pad != 0)
 			xchk_da_set_corrupt(ds, level);
 	} else {
 		if (leaf->hdr.pad1 != 0 || leaf->hdr.info.pad != 0)

