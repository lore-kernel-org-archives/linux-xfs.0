Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE69C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 20:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 549A12245D
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 20:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569528611;
	bh=+x3DUTHt3YlyUZuJCVAKU35Ueg50pzR2e0NcxH6OBDo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=yZHVVL3C9ms7+d8d7hRjNU3C7BRvl63T7wjZff04P4ufEgXse1YGpWpnzT+yOpkYn
	 8hDkj0168r4JbvO8hQFfpzfTb+kCxZR0DfU0R4biM+Yi6uZppOPVmehhRRo2slPBPE
	 YM07b8SyW2fYmVyBLre1NjqNZ2T+Pe9y3hj2aypo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfIZUKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 16:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbfIZUKH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 16:10:07 -0400
Subject: Re: [GIT PULL] xfs: fixes for 5.4-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569528606;
        bh=+x3DUTHt3YlyUZuJCVAKU35Ueg50pzR2e0NcxH6OBDo=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=PT1ux7Fn0ha1+EnehjELJKiI5aGADaGSAbBGFpkWEygQdp5i6qVjcrVSnS+XVKVDF
         BR0oqSlldz+H4K1153T3ofIWIEKTV6H/zgrdA6CDICbHUS8TDAbbjs43RnLdxhxDgB
         PnJVZqGoj3VS6d0MksJinxXCFAMJ7eHZ2LvK3+qM=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190926160206.GB9916@magnolia>
References: <20190926160206.GB9916@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190926160206.GB9916@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.4-merge-8
X-PR-Tracked-Commit-Id: 88d32d3983e72f2a7de72a49b701e2529c48e9c1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2268419e4c9559ec1e80ee7ae7bd54f8976234cb
Message-Id: <156952860689.24871.16492371830116475907.pr-tracker-bot@kernel.org>
Date:   Thu, 26 Sep 2019 20:10:06 +0000
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

The pull request you sent on Thu, 26 Sep 2019 09:02:07 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.4-merge-8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2268419e4c9559ec1e80ee7ae7bd54f8976234cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
