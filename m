Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7FAC77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344227AbjD0Wpo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbjD0Wpn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:45:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733C32106
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08436630FC
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62703C433EF;
        Thu, 27 Apr 2023 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635541;
        bh=6YhAhdf8h3lp+bZn0lcNfDuHx4HATO8vHMsX7SgfVWA=;
        h=Date:From:To:Cc:Subject:From;
        b=mb2DCJ8i16y7ZKldPMoWQSqTf7OE8G1y/M2fuxhFT9NrLYYO6QQftln4lILVhzQlu
         BRM/0QkhjmM5AjG7oTCQlWnhILxPUDtKzK1K9HZt6NgKD4d0elMSHEn/mFcUA8V0ZN
         YkxsroS35WD31w5c88aTaUs55ymSmiPD9LRJGv/gZCCCleJzAO/ji3D40X/gFNgQuW
         qfDhEWHfXxh66WGJNh14gHDsBNBiAQ95zI+Jsmz+5vBMY0WuJE4kgQcamiK3chxUbM
         hDg8zmdWc2drg5iZQIGosb+z05CSIVQt3bSb9WZKQWxNGjEM+4QZlgcLaPz8zZtOuZ
         b3giqiTro7bFg==
Date:   Thu, 27 Apr 2023 15:45:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] mkfs: warning about misaligned AGs and RAID stripes is not
 an error
Message-ID: <20230427224540.GE59213@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I've noticed a fair number of fstests failures when we create a scratch
device on a RAID device and the test specifies an explicit AG count or
AG size:

--- /tmp/fstests/tests/xfs/042.out	2022-09-01 15:09:11.484679979 -0700
+++ /var/tmp/fstests/xfs/042.out.bad	2023-04-25 19:59:04.040000000 -0700
@@ -1,5 +1,8 @@
 QA output created by 042
-Make a 96 megabyte filesystem on SCRATCH_DEV and mount... done
+Make a 96 megabyte filesystem on SCRATCH_DEV and mount... Warning: AG size is a multiple of stripe width.  This can cause performance
+problems by aligning all AGs on the same disk.  To avoid this, run mkfs with
+an AG size that is one stripe unit smaller or larger, for example 8160.
+done

Emitting this warning on stderr is silly -- nothing has failed, and we
aren't going to abort the format either.  Send the warning to stdout.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6dc0f335..2f2995e1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3167,11 +3167,12 @@ _("agsize rounded to %lld, sunit = %d\n"),
 
 		if (cli_opt_set(&dopts, D_AGCOUNT) ||
 		    cli_opt_set(&dopts, D_AGSIZE)) {
-			fprintf(stderr, _(
+			printf(_(
 "Warning: AG size is a multiple of stripe width.  This can cause performance\n\
 problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
 an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
 				(unsigned long long)cfg->agsize - dsunit);
+			fflush(stdout);
 			goto validate;
 		}
 
