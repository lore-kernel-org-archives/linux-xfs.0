Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD4DC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbiLMTD2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbiLMTDG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:03:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9769F28
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 11:02:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB167B815BA
        for <linux-xfs@vger.kernel.org>; Tue, 13 Dec 2022 19:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75274C433F1;
        Tue, 13 Dec 2022 19:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670958160;
        bh=Ae9hEnvCYSXUnZZ95C632MlV6FVU32KLQe1TmuDyXLw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=UxJShnRhJL8j3NZ8acwsh4YryQIHB9wO3ivPjpfsaOpMe2o8hYDqGoaqRTkp/FceC
         OGNdn2Z64c+GEfbOXT8LgG/xLVJD83vkKfx2EZjJWljRMtb5m4pqkT1n6G+ROSpmuH
         ozu27vwx7nix50q/RWLH3fKcrydDFhX2XJ7U4V93gfmQiwPATZGOdwLq1Ys1/ArfSc
         jKnnfJZo0JdRRig5OmK8L3QQLriFT4szwnqZsKyrSYz2BmN8jX0XZD/mlBh//kMHV0
         Fq09JznRxgzmqAD3KUcLQC3sN5cgF1GRDO+svRnRBxeY8NCStQJNqMDDssgP8LGqE+
         SNk3PmGH6dt1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 639A7C00445;
        Tue, 13 Dec 2022 19:02:40 +0000 (UTC)
Subject: Re: [GIT PULL] iomap: new code for 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <167095574533.1670001.7908839050223801763.stg-ugh@magnolia>
References: <167095574533.1670001.7908839050223801763.stg-ugh@magnolia>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <167095574533.1670001.7908839050223801763.stg-ugh@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.2-merge-1
X-PR-Tracked-Commit-Id: f1bd37a4735286585751dbd9db330b48525cb193
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d523ec4c6af4314575d6ab8b52629ae3e2039a50
Message-Id: <167095816040.20557.13807889303425499008.pr-tracker-bot@kernel.org>
Date:   Tue, 13 Dec 2022 19:02:40 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, djwong@kernel.org, hch@lst.de,
        torvalds@linux-foundation.org, bvanassche@acm.org,
        kbusch@kernel.org, kch@nvidia.com, linux-xfs@vger.kernel.org,
        willy@infradead.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Tue, 13 Dec 2022 10:22:53 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.2-merge-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d523ec4c6af4314575d6ab8b52629ae3e2039a50

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
