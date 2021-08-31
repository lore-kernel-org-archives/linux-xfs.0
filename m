Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D391C43214
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F416109E
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:19:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbhHaSU2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:32924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236670AbhHaSU1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 14:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0977D610A2;
        Tue, 31 Aug 2021 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630433972;
        bh=bYOm9k54W81A+1Vn8yp1T3a/DjAUIAUvtrbwF6XPC84=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Tk0B73ZMO/e2fjFDAvgwCuWrvclcS4MCaCPmR3VWQEB3CC9sp3ioRMkmFuYiyEmVo
         88WfbrUBoHKz2D8u4Jps69JR18qbnIxEgW2PFhqUeW7ewn4SE37dnM1I5Lzrx1yWnm
         3ZllQ7iUb6W0CrKYP8Cs98E5nYQ+8I6C35++WycTBSa5TgP4mLs57LZLm/nrtwPihb
         bR/eA/t7BMzfHAKKht94l6W10zSkI54j2Zr4RPER/T1y7iaYp1RodkhDD0rYbq8YmW
         QfIqade7K+ql1Oe0Kg1DVPfinb1E/Jjo+OvkKH99xv3q3HwB5e45glgxPjT/6UKNbY
         cJiM2mVbEGpHw==
Subject: Re: [GIT PULL] vfs: new code for 5.15
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210831162355.GA9959@magnolia>
References: <20210831162355.GA9959@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210831162355.GA9959@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.15-merge-1
X-PR-Tracked-Commit-Id: d03ef4daf33a33da8d7c397102fff8ae87d04a93
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 916d636e0a2df48be48b573d8ec9070408d7681f
Message-Id: <163043397201.24672.9933339306647625236.pr-tracker-bot@kernel.org>
Date:   Tue, 31 Aug 2021 18:19:32 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Wang Shilong <wangshilong1991@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Wang Shilong <wshilong@ddn.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Tue, 31 Aug 2021 09:23:55 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.15-merge-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/916d636e0a2df48be48b573d8ec9070408d7681f

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
