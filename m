Return-Path: <SRS0=rMVI=7Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D586DC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 03:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0E492074B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Jun 2020 03:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591156203;
	bh=MhfjXAkhTH/N3OnW2cd/KvKMQ0Nj0eXu2N5+4V4PwDs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=TfjNfwJNa4q++8j01z1SXjfb8CMVoBMeIRPUM9kmcwee9wNwee8Dcn27nhb7KDDKZ
	 XYZMMkVbHgs7UiJWQGwt+bZVt1dSGQigrz6AD/I5+ROW2b9PQ0Y9QzKbqmHaZt2YSV
	 gJqmHst/Pk9vdlVlX+sa4A0HzT03Md/2pRJTctf0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbgFCDuD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 23:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgFCDuD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Jun 2020 23:50:03 -0400
Subject: Re: [GIT PULL] xfs: new code for 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591156202;
        bh=MhfjXAkhTH/N3OnW2cd/KvKMQ0Nj0eXu2N5+4V4PwDs=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=JaCFt7PIV/vrcezqeYF21HEOph1Ye89HFEkd/aBw+72moamK7bo7B8u2XPO/nLaiG
         s8mwHqkwjjNNEQbiUlfAQcg7Mzkr5nnG1Iuk1EvFWV9eN8R+cforFLBteEU9aIMeFn
         HacCCCGUbSlEEfzR28lsWHbQuLoR1/n9/x4+9cmw=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200602160908.GA8230@magnolia>
References: <20200602160908.GA8230@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200602160908.GA8230@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.8-merge-8
X-PR-Tracked-Commit-Id: 6dcde60efd946e38fac8d276a6ca47492103e856
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 16d91548d1057691979de4686693f0ff92f46000
Message-Id: <159115620262.30123.3393809374068382776.pr-tracker-bot@kernel.org>
Date:   Wed, 03 Jun 2020 03:50:02 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Tue, 2 Jun 2020 09:09:08 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.8-merge-8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/16d91548d1057691979de4686693f0ff92f46000

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
