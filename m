Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FFDC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiJBShV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiJBShU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:37:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBD23C8D7
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3FA260F06
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD7BC433D6;
        Sun,  2 Oct 2022 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735837;
        bh=zzKJCJHj8quOHRvqIRaJ5CmVnK6kJ7kw/5/No8lPvGE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ec1q6Xlai1JrHRv04SOw67d8hEJ70OTHNdNJbMt7Bn8D+ngeuiH7mz4KwehThSx0p
         A6gB3Xqd3EzC6xuCcd+q6dqB0ooO9cv4B5s8GTnzJbnlrRyZHdzivolHqOqLNntBVw
         s2w1MC4xgyO7G93Jlu+6LZy+WlDQ0YVYhbK1tQxN1biJm08XHkm/oVSbdyOlImHjT4
         YfjpR3mkiEiESKDecbwQKobnlOU5ZCG/UAXfhl7+I90ysoamkg/ZEkCM8/N23mkukZ
         AxRI0iizIy74pnsrm+r7IHSxnsIfIh8gafsWhhnCY95lWrvH2Wv8atZbI7ICm6+CC/
         vr1uWQy8h3fjg==
Subject: [PATCH 5/9] xfs: remove flags argument from xchk_setup_xattr_buf
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:40 -0700
Message-ID: <166473484066.1085108.16936297806265537411.stgit@magnolia>
In-Reply-To: <166473483982.1085108.101544412199880535.stgit@magnolia>
References: <166473483982.1085108.101544412199880535.stgit@magnolia>
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
index 71164a0373f1..80f39a2c377f 100644
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
@@ -175,7 +173,7 @@ xchk_xattr_listent(
 	 * doesn't work, we overload the seen_enough variable to convey
 	 * the error message back to the main scrub function.
 	 */
-	error = xchk_setup_xattr_buf(sx->sc, valuelen, XCHK_GFP_FLAGS);
+	error = xchk_setup_xattr_buf(sx->sc, valuelen);
 	if (error == -ENOMEM)
 		error = -EDEADLOCK;
 	if (error) {
@@ -348,7 +346,7 @@ xchk_xattr_block(
 		return 0;
 
 	/* Allocate memory for block usage checking. */
-	error = xchk_setup_xattr_buf(ds->sc, 0, XCHK_GFP_FLAGS);
+	error = xchk_setup_xattr_buf(ds->sc, 0);
 	if (error == -ENOMEM)
 		return -EDEADLOCK;
 	if (error)

