Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C20C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Nov 2022 20:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiKDUfr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Nov 2022 16:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKDUfq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2022 16:35:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B8845A19
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 13:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78FCB62335
        for <linux-xfs@vger.kernel.org>; Fri,  4 Nov 2022 20:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C3BC433C1;
        Fri,  4 Nov 2022 20:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667594144;
        bh=m7m3DAiPRROVBIgigleIdfTN5wRZji5ThwK77W/oIq8=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ivtaJLqecEGB1uQTlHThDYmAnVdpRtlixd83Csy6sZcYEflIncfDTeA752GefuKTl
         GNk8T0p63TbNcpmurNvaaIWmrkasTPVBNaJfUY0b0LemMO/00BOYqwjPYkJfWtfB97
         j6cerORNZyJr8hEmO9Shd60+MGE0uM36ghsZvwGqGJd/9NuHpdK4zFisVZmc6ABsOl
         2ptjA/7vD4FfIyAKW4YlWCTIxFS9cnGjvs1GpehiC4ZMKZXoGLg/tv+paMof2fZFse
         lK8OWiQkTTvgQICb/PjhjEl98OEMpV0+IQSWWdPu2xO07E6NXWx9cowiFIySglnOgK
         HK9DBG6ZORPkQ==
Date:   Fri, 4 Nov 2022 13:35:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v23.2 4/4] xfs: don't return -EFSCORRUPTED from repair when
 resources cannot be grabbed
Message-ID: <Y2V3oOMM85/MwK0i@magnolia>
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
v23.2: fix the commit message to discuss what's really going on in this
       patch.
---
 fs/xfs/scrub/repair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7323bd9fddfb..86f770af6737 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -69,9 +69,9 @@ xrep_attempt(
 		/*
 		 * We tried harder but still couldn't grab all the resources
 		 * we needed to fix it.  The corruption has not been fixed,
-		 * so report back to userspace.
+		 * so exit to userspace with the corruption flags still set.
 		 */
-		return -EFSCORRUPTED;
+		return 0;
 	default:
 		/*
 		 * EAGAIN tells the caller to re-scrub, so we cannot return
