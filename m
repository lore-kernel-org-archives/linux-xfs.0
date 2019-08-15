Return-Path: <SRS0=AwRW=WL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A38ADC3A589
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 19:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76D9F2083B
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Aug 2019 19:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565898308;
	bh=to1hUdVUSbeaMquXC+F9EI+rjV4vn9hUe3HUOhk280I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=A5bld7tzljoaJq+i/b7zW2ddw+zp4uS0ePikGDcB1WORbPO1atB1cye03edzZbCsS
	 56t+t85WPA6/XSnpnWkQM3WVLRur94lD5CYBT/xLWOssCEoqizGc3SB2p2fzSXWjDU
	 5UT3KId18NWiTkpGgq6Syf/F0Q7fS6g3MSKQMXHE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733128AbfHOTpD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Aug 2019 15:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730406AbfHOTpD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Aug 2019 15:45:03 -0400
Subject: Re: [GIT PULL] xfs: fixes for 5.3-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565898302;
        bh=to1hUdVUSbeaMquXC+F9EI+rjV4vn9hUe3HUOhk280I=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=R0u0aVFR+d8jd29IlC7i0ow+254Xk+aC1wqpBZbkw2jJJKDdMlk0xajsQWvSvhSDd
         ajiWklUd+xPPzmlSQb88QO3N79m+mEF6WtOQ+MKw6MYhYgrih3Z8FJ5P4Y52GiGTCy
         mi3vbX9S1jYHtqdxFCwnRASq3IzdWv4Lj3LpuCvg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190815171347.GD15186@magnolia>
References: <20190815171347.GD15186@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190815171347.GD15186@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.3-fixes-2
X-PR-Tracked-Commit-Id: 8612de3f7ba6e900465e340516b8313806d27b2d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a69e90512d9def6bd8064d84cff9ffd8b15eaa1b
Message-Id: <156589830195.13301.9419620703978124542.pr-tracker-bot@kernel.org>
Date:   Thu, 15 Aug 2019 19:45:01 +0000
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

The pull request you sent on Thu, 15 Aug 2019 10:13:47 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.3-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a69e90512d9def6bd8064d84cff9ffd8b15eaa1b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
