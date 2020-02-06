Return-Path: <SRS0=lRpT=32=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A694EC33CAC
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 08:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CF1020720
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Feb 2020 08:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580977208;
	bh=x/Z+3ox+n70Ij8MeDWggupUpPb7A+5YTIm3ylIbHhtA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=gApQwCMTZYu6Dx4VujEn3Rm/WjuE7bUyjuIAqE80fApfc0Dmt1VqOj91GnfIPE0xB
	 U0HGL0LXg9cR3WV9JYtDPqSHuRSeCr/1jVvUfJrnWCUj7uBGEVbD1Kk7Zw5jAonPQl
	 HFMbFtZDOrnTWZ3jzWsnZIitr25+kM5JDSiApMPA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgBFIUE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 03:20:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:39540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgBFIUE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Feb 2020 03:20:04 -0500
Subject: Re: [GIT PULL] xfs: moar new code for 5.6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580977204;
        bh=x/Z+3ox+n70Ij8MeDWggupUpPb7A+5YTIm3ylIbHhtA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=DU+UAj81Y/UawspfOXA8cN/k+sZk/YfCXLNjYG1WyJ6yHfn4EHT4vjsim8drkw5eP
         hMIvLswTlEqeKU0e+uTnLBpFphkQU/wbzGjETaHf26fpNO2FqP/gaRNvCFwjf5c5cT
         A5lwYanNzOIcpTS9psEtHe9gOzt/qI3oq5yid1yk=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200205224303.GF6870@magnolia>
References: <20200205224303.GF6870@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200205224303.GF6870@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.6-merge-8
X-PR-Tracked-Commit-Id: cdbcf82b86ea24aa942991b4233cd8ddf13f590c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 99be3f60989b4813f625b5421427fa9ab01e3a23
Message-Id: <158097720405.4470.3412212509981376071.pr-tracker-bot@kernel.org>
Date:   Thu, 06 Feb 2020 08:20:04 +0000
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

The pull request you sent on Wed, 5 Feb 2020 14:43:04 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.6-merge-8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/99be3f60989b4813f625b5421427fa9ab01e3a23

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
