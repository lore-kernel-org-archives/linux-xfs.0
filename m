Return-Path: <SRS0=AwRW=WL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBECC3A589
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 19:45:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D80C2083B
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 19:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565898311;
	bh=RkhfQrIe9++zikgZHlw+Y2EP8lb+hIuXuKwjYaod2tE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=A7zK4le9bkL7+2FiJhfeCQwT+eSem1dCfRVT0rhi2jkH6HslzFxGg+XWpGI8j05rD
	 OyO54IqPDa+BkM4AO+GQsOWSHGi49pyhwkd64SSgr4h9sG+2JiMJtdSznNQZXAmJ+E
	 tQyW/3EY1cE1lLOROBbRdSt4Rh9kcQT4jX3qIN+c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733111AbfHOTpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Aug 2019 15:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:36364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729843AbfHOTpC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Aug 2019 15:45:02 -0400
Subject: Re: [GIT PULL] iomap: small fixes for 5.3-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565898301;
        bh=RkhfQrIe9++zikgZHlw+Y2EP8lb+hIuXuKwjYaod2tE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=FU15IwHNgUSzGHHvSttuAz59jyQqAyFRFW6DOHoS4bZGt0QZXKJRziVhvm7//RNvI
         ccROhx0nhKZxJHXH7xZVG9U+l6oaWd6eoH4JloHMtucS4s+G2lUpTK2M+JFI+jm5/D
         7Kz1WVQRDF8SksJdkVz8SrwUQ+T0B1IEwkvcHpyY=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190815171024.GC15186@magnolia>
References: <20190719162221.GF7093@magnolia> <20190815171024.GC15186@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190815171024.GC15186@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/iomap-5.3-fixes-1
X-PR-Tracked-Commit-Id: 9a67b72552f8d019948453e56ca7db8c7e5a94ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4ec1fa692dc7dc915c3485a7fad928924fc13de2
Message-Id: <156589830158.13301.5783532201325925027.pr-tracker-bot@kernel.org>
Date:   Thu, 15 Aug 2019 19:45:01 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de, agruenba@redhat.com,
        rpeterso@redhat.com, cluster-devel@redhat.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 15 Aug 2019 10:10:24 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.3-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4ec1fa692dc7dc915c3485a7fad928924fc13de2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
