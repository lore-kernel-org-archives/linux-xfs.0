Return-Path: <SRS0=cf1J=2M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C263EC2D0D4
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Dec 2019 19:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98232207FF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Dec 2019 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577041804;
	bh=CCLPMaCkI2p2cTu6Tk8zuYnLnqVdnOGsLQ4omFiZ/jU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Ia6dcb4lHnCh/PmEO+zD7YO2PHwPLa/yNhw6kBB7SNGxeA73oE4ZlTdI8+8gT6D82
	 8PVtvBOHug4aps0ZfgTQiIVMojsBwJ7wHp+ZY9cauelPtg97vXLdRtchzurSDGtnVL
	 kzS9LGJg8/0sXvpBN55GFHgUeHCQJ5LuhIHt5blE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfLVTKD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Dec 2019 14:10:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbfLVTKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 22 Dec 2019 14:10:03 -0500
Subject: Re: [GIT PULL] xfs: fixes for 5.5-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577041803;
        bh=CCLPMaCkI2p2cTu6Tk8zuYnLnqVdnOGsLQ4omFiZ/jU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=MeOZiH+Z0UnDU5Nl2QbpGYm3YJKUJdUAV32hMzPmdcsMEzzrnLg4p9hGZtR+/BC9/
         wXEqt1RZMVQ6VTj8ra1H3VFnLtz40olB0+R2gT+ISiIUg5yEhasXg0LrocgyBqfMV6
         pymPpWZkpJMvJypB/XZ6pDmkpESDIaC1NUKJLgf8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20191222163218.GR7489@magnolia>
References: <20191222163218.GR7489@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20191222163218.GR7489@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.5-fixes-2
X-PR-Tracked-Commit-Id: 5084bf6b2006fcd46f1e44e3c51b687507b362e2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c60174717544aa8959683d7e19d568309c3a0c65
Message-Id: <157704180292.1067.15216175845431149488.pr-tracker-bot@kernel.org>
Date:   Sun, 22 Dec 2019 19:10:02 +0000
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

The pull request you sent on Sun, 22 Dec 2019 08:32:18 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.5-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c60174717544aa8959683d7e19d568309c3a0c65

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
