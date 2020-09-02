Return-Path: <SRS0=53rf=CL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED35FC433E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 20:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C981220BED
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Sep 2020 20:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599077290;
	bh=n3axoKh6/pUGmjmZRHjq3qC/NB8zWjAq+HQe74tViAI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=S+PqQ45EXoNtUDkhAw6pVBAKcUldj4lzWpubiNmzKogynJV9ZnHe8bxhnDdmaEh+m
	 OeoqrXBwPNxiJnYbheUKGquPcw8XFni7G1F6/f6N9xHMG7tMLEJuIT+dU6KtIXn1Lz
	 p1/1nywQPlKJ1vtT2T28VZVGSxa022U1pWgU1Sbo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIBUIK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Sep 2020 16:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgIBUIK (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Sep 2020 16:08:10 -0400
Subject: Re: [GIT PULL] xfs: small fixes for 5.9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599077288;
        bh=n3axoKh6/pUGmjmZRHjq3qC/NB8zWjAq+HQe74tViAI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=DvPnqkyphcisB+f2t1hDjR0zvHCfDaAltWA4+wcYi8x98KiYH4jgrWIuxaMJCXtoq
         WZmekutpuHjOU7jpf3cHWm4mIJwj5DPdL+vI24lCORIAOOOIX/qepd42Cp3rjT0aoB
         ECn8x1hzOZM5KMXtfuTYZwYz18UqUW7kU3NJxvd0=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200902170019.GO6096@magnolia>
References: <20200902170019.GO6096@magnolia>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200902170019.GO6096@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.9-fixes-1
X-PR-Tracked-Commit-Id: 125eac243806e021f33a1fdea3687eccbb9f7636
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e1d0126ca3a66c284a02b083a42e2b39558002cd
Message-Id: <159907728850.15646.6826562872672961490.pr-tracker-bot@kernel.org>
Date:   Wed, 02 Sep 2020 20:08:08 +0000
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

The pull request you sent on Wed, 2 Sep 2020 10:00:19 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.9-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e1d0126ca3a66c284a02b083a42e2b39558002cd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
