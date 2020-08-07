Return-Path: <SRS0=4IRk=BR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A10C433E1
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 18:01:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF23D2075D
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Aug 2020 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596823291;
	bh=+K6uo2vXfoM35kneAHG8QLTckjLRBhkJkxZr2m4oIXM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=MIaoWzI0e+Xr4bZz5VuY12HRsxXcQ7/j4wFJYLZvyB0Y40M8RGdeer16Hb1gASqX3
	 6wjJpzsMClr3aY+xHXNxJ9CbJZqwrOdnYLwyNbAGUkMgOAfqg4DGawYzsAqIcWfrZf
	 kncUoocG+JGOyWjR37P8K59Qy2jFomAXV7qzVGmQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgHGSB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Aug 2020 14:01:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgHGSB1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Aug 2020 14:01:27 -0400
Subject: Re: [GIT PULL] xfs: new code for 5.9-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596823287;
        bh=+K6uo2vXfoM35kneAHG8QLTckjLRBhkJkxZr2m4oIXM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=P0O3rW/4+Ugy2PB4py/qZJzb9DW5oglONMPEmr2hsdsBsJXjhUnChkyhwNgHdqH5D
         n6hCLGuNoa0PwF4zZL++X3WFMh6Hcxw16mXKeCzFySqj+GimaAIAYm75/ielYNrbUR
         QSI12DT3CuGWlaZOP+fjW9Nq6wRrsSNyW86L4Z8k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200807040817.GD6096@magnolia>
References: <20200807040817.GD6096@magnolia>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200807040817.GD6096@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.9-merge-7
X-PR-Tracked-Commit-Id: 818d5a91559ffe1e1f2095dcbbdb96c13fdb94ec
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5631c5e0eb9035d92ceb20fcd9cdb7779a3f5cc7
Message-Id: <159682328702.30890.11249398306478997606.pr-tracker-bot@kernel.org>
Date:   Fri, 07 Aug 2020 18:01:27 +0000
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

The pull request you sent on Thu, 6 Aug 2020 21:08:17 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.9-merge-7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5631c5e0eb9035d92ceb20fcd9cdb7779a3f5cc7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
