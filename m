Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0E5C63798
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 18:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36405221FE
	for <linux-xfs@archiver.kernel.org>; Sat, 21 Nov 2020 18:39:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKKYtREv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgKUSjE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 21 Nov 2020 13:39:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgKUSjD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Nov 2020 13:39:03 -0500
Subject: Re: [GIT PULL] xfs: fixes for 5.10-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605983943;
        bh=qChbQrSAvJIWDL8x5WgpxWaSK6Sgj8zjIa25WO4PD9k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=NKKYtREv9xZd6bbAw04xi18N2RIg45cVLEVO48INvVwOBj/Qp0fE/B5vycRospvj9
         mDbk6gm9Vtj/SVteJqiXlPtGo65L+rJEXD2YVyZ0tUJM2UNBUYmaliaO2c6lyJxwqt
         H93jRDkrtblSp7w4fu3gGihXthsDzb75zkiQh0/A=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201121171710.GA7179@magnolia>
References: <20201121171710.GA7179@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201121171710.GA7179@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.10-fixes-7
X-PR-Tracked-Commit-Id: eb8409071a1d47e3593cfe077107ac46853182ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a349e4c659609fd20e4beea89e5c4a4038e33a95
Message-Id: <160598394343.7589.11599465646793448804.pr-tracker-bot@kernel.org>
Date:   Sat, 21 Nov 2020 18:39:03 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 21 Nov 2020 09:17:10 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.10-fixes-7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a349e4c659609fd20e4beea89e5c4a4038e33a95

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
