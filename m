Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9DAC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjEZAhx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241821AbjEZAhu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:37:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8351B3
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:37:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A82B264AFD
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17EEDC433D2;
        Fri, 26 May 2023 00:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061467;
        bh=CBz0IXR9O9StcsajZtX4t/VC7D4TzxYxzjShrYeaN0Y=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gXIUgz7gG6KzRDAdAfEUmL5w28A1hYbhPM04+xpyqItwtppucsK68zpa/2XQDSNxf
         VH9lDMg22s8Ih34Bk+XY4r+h9B58S7PBBByxCutgqmTimYk5fjBhqtnKIlFi+09n6g
         kOv0XVGkUwQAcAdIdEz20xTl2Mj9Hg0KF9SGeEc6TQYP9VlXsYoH/QB8Csd9vOYFtw
         ptWi76jVesGCf1Su49pA2MMk/YASL6e0pbWUgYeiCDbd7q/Vjni7LcWLOya2aI7mrZ
         xBTe8nDqAU/deJVh9vwmn+eSd6DPXDjwEXtOppJSuO3RMS5vGbqXaGjR63KmETQTov
         mkyn5Fjk6ERpA==
Date:   Thu, 25 May 2023 17:37:46 -0700
Subject: [PATCHSET v25.0 0/4] xfs: relax AGF locks during fstrim
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506069715.3738451.3754446921976634655.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Congratulations!  You have made it to the final patchset of the main
online fsck feature!  This patchset fixes some stalling behavior that I
observed when running FITRIM against large flash-based filesystems with
very heavily fragmented free space data.  In summary -- the current
fstrim implementation optimizes for trimming the largest free extents
first, and holds the AGF lock for the duration of the operation.  This
is great if fstrim is being run as a foreground process by a sysadmin.

For xfs_scrub, however, this isn't so good -- we don't really want to
block on one huge kernel call while reporting no progress information.
We don't want to hold the AGF so long that background processes stall.
These problems are easily fixable by issuing smaller FITRIM calls, but
there's still the problem of walking the entire cntbt.  To solve that
second problem, we introduce a new sub-AG FITRIM implementation.  To
solve the first problem, make it relax the AGF periodically.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=discard-relax-locks
---
 fs/xfs/xfs_discard.c |  262 ++++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_trace.h   |    1 
 2 files changed, 222 insertions(+), 41 deletions(-)

