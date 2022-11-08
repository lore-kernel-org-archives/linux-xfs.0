Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B48C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 01:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbiKHBae (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 20:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiKHBaQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 20:30:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8322C67F
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 17:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 817FECE1877
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 01:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73B8C433D6;
        Tue,  8 Nov 2022 01:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667870921;
        bh=Uyc2dbbkFWmuu2ojbO+Uz2BPlMK7DyvPf01lZJxtPuo=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=sr4Ez2wqtRDulmFB6W6+NQNOLMK/wSous+2j1+bFGjBqvtUQ6uDp0W4VFc72iRSU9
         9wHM2OT2hS+SYuzl2T4r2PiZpqh1Vu5cELOCTioQ1/YUMPWtNEAv0BX2VWsiKAswG9
         pH160SEGa4Bjr9lGjDhBuWdzbJnuI2ZPhjulGDkt2qzQOkTtOsS82UyhtcLDD45lzF
         R9HmIZ/ZcZZPIJ5+ugojhTPEDFSFAYm2bHxbgEg9mHIVJpgy1rXcQT98eWZQc4nCcd
         KOyzj3lfTYTxqTbvS341Og8WrSns0adNufxgJSFmRu76oRzet8vGqxGRmh39v9BAvR
         QFrvdZWZWAVUw==
Date:   Mon, 7 Nov 2022 17:28:41 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v23.3 4/4] xfs: don't return -EFSCORRUPTED from repair when
 resources cannot be grabbed
Message-ID: <Y2mwyQ8VD3zX4goX@magnolia>
References: <166473479505.1083393.7049311366138032768.stgit@magnolia>
 <166473479567.1083393.7668585289114718845.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473479567.1083393.7668585289114718845.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we tried to repair something but the repair failed with -EDEADLOCK,
that means that the repair function couldn't grab some resource it
needed and wants us to try again.  If we try again (with TRY_HARDER) but
still can't get all the resources we need, the repair fails and errors
remain on the filesystem.

Right now, repair returns the -EDEADLOCK to the caller as -EFSCORRUPTED,
which results in XFS_SCRUB_OFLAG_CORRUPT being passed out to userspace.
This is not correct because repair has not determined that anything is
corrupt.  If the repair had been invoked on an object that could be
optimized but wasn't corrupt (OFLAG_PREEN), the inability to grab
resources will be reported to userspace as corrupt metadata, and users
will be unnecessarily alarmed that their suboptimal metadata turned into
a corruption.

Fix this by returning zero so that the results of the actual scrub will
be copied back out to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v23.3: fix vague wording of comment
v23.2: fix the commit message to discuss what's really going on in this
patch.
---
 fs/xfs/scrub/repair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7323bd9fddfb..4b92f9253ccd 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -69,9 +69,9 @@ xrep_attempt(
 		/*
 		 * We tried harder but still couldn't grab all the resources
 		 * we needed to fix it.  The corruption has not been fixed,
-		 * so report back to userspace.
+		 * so exit to userspace with the scan's output flags unchanged.
 		 */
-		return -EFSCORRUPTED;
+		return 0;
 	default:
 		/*
 		 * EAGAIN tells the caller to re-scrub, so we cannot return
