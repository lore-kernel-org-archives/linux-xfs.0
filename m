Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA732C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiL3XP1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiL3XPY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:15:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D6A1D0C6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:15:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A0CBB81DA2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60ADC433EF;
        Fri, 30 Dec 2022 23:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442120;
        bh=seId326mtSm5ElsLLH8Jn5ze+9lxwq8mkyxgaEZDakM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CvZITDUF8dPTSGIJYdfzbfYBk8RHp3NJIaGgrMuQMa0oFyF2/2xRjyM/GC0IN3xeE
         lH+8y4lU6cGjgSNSKZBGYkkWAiacuR6PLviWnNkI5V953CDi7fZSdp5t4sqcJC+43g
         bMJMt1TPvvBX6hiKjmDkl/W3Lz3f7tdNoc80cctR8DUpy2T9spgh4OTwXzau5MX9P9
         9ZnkIx+7eu/OP5UlYJkkduD67sbJmbzKePvBNBBzdNbAIovlcTiLuv9nLRO47bSqRz
         W9iDizCdm9aTZqV1OPGn0ExFyhn7vOwIXpsMwuy6deioR9ZThki0MFyCOUY6590gGf
         vtI1Zdr+gCwXA==
Subject: [PATCHSET v24.0 0/2] xfs_scrub: automatic optimization by default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:41 -0800
Message-ID: <167243872112.718904.9124514098518120883.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This final patchset in the online fsck series enables the background
service to optimize filesystems by default.  This is the first step
towards enabling repairs by default.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-optimize-by-default

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-optimize-by-default
---
 man/man8/xfs_scrub.8 |    6 +++++-
 scrub/Makefile       |    2 +-
 scrub/phase1.c       |   13 +++++++++++++
 scrub/phase4.c       |    6 ++++++
 scrub/repair.c       |   37 ++++++++++++++++++++++++++++++++++++-
 scrub/repair.h       |    2 ++
 scrub/scrub.c        |    4 ++--
 scrub/xfs_scrub.c    |   21 +++++++++++++++++++--
 scrub/xfs_scrub.h    |    1 +
 9 files changed, 85 insertions(+), 7 deletions(-)

