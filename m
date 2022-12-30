Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BE6C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiL3WuH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbiL3WuF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:50:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B57418E31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:50:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3603A61AC4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:50:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F1AC433EF;
        Fri, 30 Dec 2022 22:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440602;
        bh=Qv1mhyTVoLv/jc0yR4GIftjOASJkVm7qX2e2QCneAWw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DY6ejeVopo0wHjg+h+K+TFYzeTFaFBJ2z6UfkP2GLn+EKCFoym6oiCD92LS6xnn/r
         ojS5w73y0U5UcLNGwnSWwCwEPUSVTMUdnt7NP3KqBvBdXXHrRTP3z3eGEuSsrd6bMs
         QETNAAwgKfvUavhlBOn8wEFSk3gVv6HQ1aGXbMoKMtEXqRumJd6KGzTZYgKyywnPeO
         jAHKL2f3L/wSR41zshrROyTeLc7F617gILgGG23j1pC7ssQ9LIE0t9PNHU6Jtn/haK
         PEJVAa7PeHxU2Nw5+v+A+DysJOKaYF/IeDXfK2ykFNHuHqO8FinF+rTUndY2/67Dgu
         1OQh7GgRcKKFg==
Subject: [PATCH 07/11] xfs: remove flags argument from xchk_setup_xattr_buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:47 -0800
Message-ID: <167243830706.687022.10382893310472111770.stgit@magnolia>
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

All callers pass XCHK_GFP_FLAGS as the flags argument to
xchk_setup_xattr_buf, so get rid of the argument.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 98371daa1397..df2f21296b30 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -44,8 +44,7 @@ xchk_xattr_buf_cleanup(
 static int
 xchk_setup_xattr_buf(
 	struct xfs_scrub	*sc,
-	size_t			value_size,
-	gfp_t			flags)
+	size_t			value_size)
 {
 	size_t			bmp_sz;
 	struct xchk_xattr_buf	*ab = sc->buf;
@@ -56,17 +55,17 @@ xchk_setup_xattr_buf(
 	if (ab)
 		goto resize_value;
 
-	ab = kvzalloc(sizeof(struct xchk_xattr_buf), flags);
+	ab = kvzalloc(sizeof(struct xchk_xattr_buf), XCHK_GFP_FLAGS);
 	if (!ab)
 		return -ENOMEM;
 	sc->buf = ab;
 	sc->buf_cleanup = xchk_xattr_buf_cleanup;
 
-	ab->usedmap = kvmalloc(bmp_sz, flags);
+	ab->usedmap = kvmalloc(bmp_sz, XCHK_GFP_FLAGS);
 	if (!ab->usedmap)
 		return -ENOMEM;
 
-	ab->freemap = kvmalloc(bmp_sz, flags);
+	ab->freemap = kvmalloc(bmp_sz, XCHK_GFP_FLAGS);
 	if (!ab->freemap)
 		return -ENOMEM;
 
@@ -80,7 +79,7 @@ xchk_setup_xattr_buf(
 		ab->value_sz = 0;
 	}
 
-	new_val = kvmalloc(value_size, flags);
+	new_val = kvmalloc(value_size, XCHK_GFP_FLAGS);
 	if (!new_val)
 		return -ENOMEM;
 
@@ -102,8 +101,7 @@ xchk_setup_xattr(
 	 * without the inode lock held, which means we can sleep.
 	 */
 	if (sc->flags & XCHK_TRY_HARDER) {
-		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX,
-				XCHK_GFP_FLAGS);
+		error = xchk_setup_xattr_buf(sc, XATTR_SIZE_MAX);
 		if (error)
 			return error;
 	}
@@ -181,7 +179,7 @@ xchk_xattr_listent(
 	 * doesn't work, we overload the seen_enough variable to convey
 	 * the error message back to the main scrub function.
 	 */
-	error = xchk_setup_xattr_buf(sx->sc, valuelen, XCHK_GFP_FLAGS);
+	error = xchk_setup_xattr_buf(sx->sc, valuelen);
 	if (error == -ENOMEM)
 		error = -EDEADLOCK;
 	if (error) {
@@ -354,7 +352,7 @@ xchk_xattr_block(
 		return 0;
 
 	/* Allocate memory for block usage checking. */
-	error = xchk_setup_xattr_buf(ds->sc, 0, XCHK_GFP_FLAGS);
+	error = xchk_setup_xattr_buf(ds->sc, 0);
 	if (error == -ENOMEM)
 		return -EDEADLOCK;
 	if (error)

