Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B6BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiLTAFH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiLTAFF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:05:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B07E63D0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 16:05:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 270A0611B5
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 00:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888B3C433EF;
        Tue, 20 Dec 2022 00:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494703;
        bh=KH8Y3AkHr50y+3+ZvEQmov8I9/Wt90XaGqePN/QS1M0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kq6k4dn9C2xA9kj1bnq++m5RmiJDjwE44TLDVyAmVP8ZAed62YchzlCRIslA21Ig/
         rWPrBPyprjA9GV955wIDFzxT6RDeUU5GtxP24rPhcYzG5Jg+mNJv5YHDhIV0PZXcd3
         JErfWpKIx9Sf3G0FT3ewqhKGywkPO1VYACsIVai3RcFmPRA7/u5e6P1cNJsiKmnj4i
         1ciZqYjyEx+zgZsR9SjgOdjKUGjUyau4QrDUR0nAI8M/XcUy9xYlyVPy3V4up1608R
         NTmR1B1I2nkW8fMYiw0XV91Nk7a0PQdjTo+RDycD0NWi5DdIgiTK1mAn8diXQww/c1
         V26mtKJheJMPQ==
Subject: [PATCH 1/4] xfs: don't assert if cmap covers imap after cycling lock
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 19 Dec 2022 16:05:03 -0800
Message-ID: <167149470312.336919.14005739948269903315.stgit@magnolia>
In-Reply-To: <167149469744.336919.13748690081866673267.stgit@magnolia>
References: <167149469744.336919.13748690081866673267.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In xfs_reflink_fill_cow_hole, there's a debugging assertion that trips
if (after cycling the ILOCK to get a transaction) the requeried cow
mapping overlaps the start of the area being written.  IOWs, it trips if
the hole in the cow fork that it's supposed to fill has been filled.

This is trivially possible since we cycled ILOCK_EXCL.  If we trip the
assertion, then we know that cmap is a delalloc extent because @found is
false.  Fortunately, the bmapi_write call below will convert the
delalloc extent to a real unwritten cow fork extent, so all we need to
do here is remove the assertion.

It turns out that generic/095 trips this pretty regularly with alwayscow
mode enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |    2 --
 1 file changed, 2 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index fe46bce8cae6..5535778a98f9 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -416,8 +416,6 @@ xfs_reflink_fill_cow_hole(
 		goto convert;
 	}
 
-	ASSERT(cmap->br_startoff > imap->br_startoff);
-
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,

