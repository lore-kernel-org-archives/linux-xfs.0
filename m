Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 683F7C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Oct 2022 03:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJKDn1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Oct 2022 23:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJKDnT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Oct 2022 23:43:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A757F25D
        for <linux-xfs@vger.kernel.org>; Mon, 10 Oct 2022 20:43:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04559B811DA
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2022 03:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B8D3BC433D6;
        Tue, 11 Oct 2022 03:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665459795;
        bh=F20sfqIuhjs5mDYfEWDXqkKIIWH8jT+hn3mP6/JkS7k=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=dvCjyyHLwMaEJXnxlmKDmKCw/tWCOWcPKZnd3+d/PXazO2HRt8IpmK6sPuHHcLXgH
         XYB/oRTHKAco9tJUy/Lbbycm79bQGPHYuEutal+uNyDioZSZ6dSa6zRkQRTttROmHJ
         E+1x02dRaAATYk8tN0kDKAK+o9KVSkqFhm/tGW6bxLywqiL3rVOMx1Hl38eolIq5qj
         WAdC2mvb/RRty1ZJtzDSDpvr8D7wl9JYgGYxpIfAikMzGwZ6FBoSZaq11YmiOU8LLx
         xmxg/TsKh4g5bugCe7DhweVXRpo6QzjGPM+Lu/Qp/IXNtpbVB51kCtmb1x5be/BA8d
         Ha/4m5tmzqKhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A84BCE29F33;
        Tue, 11 Oct 2022 03:43:15 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: updates for 6.1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20221010213827.GD2703033@dread.disaster.area>
References: <20221010213827.GD2703033@dread.disaster.area>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20221010213827.GD2703033@dread.disaster.area>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.1-for-linus
X-PR-Tracked-Commit-Id: e033f40be262c4d227f8fbde52856e1d8646872b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 60bb8154d1d77042a5d43d335a68fdb202302cbe
Message-Id: <166545979568.4678.13835752517871607728.pr-tracker-bot@kernel.org>
Date:   Tue, 11 Oct 2022 03:43:15 +0000
To:     Dave Chinner <david@fromorbit.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, djwong@kernel.org,
        linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Tue, 11 Oct 2022 08:38:27 +1100:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.1-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/60bb8154d1d77042a5d43d335a68fdb202302cbe

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
