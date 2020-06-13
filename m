Return-Path: <SRS0=EwQn=72=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877B4C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Jun 2020 19:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660E720789
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Jun 2020 19:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592077819;
	bh=k+djGvlAiR2dPOJFrAMMCAFoKzCyTdGmnQmF59oaoYA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Ew0EEsO8hp0CWNhHj4t/Iz8RqStYYUcu2lw95Joz4ZcQhkyINT0rMxYPxzqkqOwqn
	 7g95oGXHe2S3g1wCIuUtaPGl9MAp8t0IQTLtYgDDk6mhJQ1w7hShdJcbY9jwkQrNCX
	 0GABIvWryheOvxScerBDhWh4h7GPsgeirE3bEpl8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgFMTuH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Jun 2020 15:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgFMTuF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Jun 2020 15:50:05 -0400
Subject: Re: [GIT PULL] xfs: bug fixes for 5.8-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592077805;
        bh=k+djGvlAiR2dPOJFrAMMCAFoKzCyTdGmnQmF59oaoYA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Y1oTLC+t+/vRNvp/R0EYiMFzkqQZL1Jtiif0eRY2ulqDHIfzrNaJd7pMQkyuwoKhM
         7bqKl3omnz7Jott+e+fL5LBQILPU0WS1EEMB6AZu6DyItcX+V4M0jETdFNqdbC6Ytf
         mTzesDEGVZLr2+v/XyhpRpxyCM0+pmOYq1wF0DKE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200613054130.GK11245@magnolia>
References: <20200613054130.GK11245@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200613054130.GK11245@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.8-merge-9
X-PR-Tracked-Commit-Id: 8cc0072469723459dc6bd7beff81b2b3149f4cf4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c55572276834f8b17c859db7d20c224fe25b9eda
Message-Id: <159207780513.22916.12350877297644827494.pr-tracker-bot@kernel.org>
Date:   Sat, 13 Jun 2020 19:50:05 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Fri, 12 Jun 2020 22:41:30 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.8-merge-9

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c55572276834f8b17c859db7d20c224fe25b9eda

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
