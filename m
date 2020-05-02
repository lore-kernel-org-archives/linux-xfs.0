Return-Path: <SRS0=mmaA=6Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 275A5C47254
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 18:45:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09D5320731
	for <linux-xfs@archiver.kernel.org>; Sat,  2 May 2020 18:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588445107;
	bh=s0z1+Ustle/5LPDXfg8sKPJ5kKTcNvfSNnMWHuEwuuU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=J+wZWmDi5Epoujn0RFotmaGzNPHwMoo62yK4BGfVEaJcgbFpOxVoatlzu4l+m0ylZ
	 wmHFLNzyoknTK4tnE7PWR07IpHm/pg8kvRVcj/u1za6vl87+gagsIwvZ9omFrDjh/Z
	 ez8hGgLbYkf9r4cGqC1sSj+fy+Je5ME0hcUYz26c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbgEBSpF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 2 May 2020 14:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728411AbgEBSpC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 2 May 2020 14:45:02 -0400
Subject: Re: [GIT PULL] iomap: bug fix for 5.7-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588445102;
        bh=s0z1+Ustle/5LPDXfg8sKPJ5kKTcNvfSNnMWHuEwuuU=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=i0mBLSUMC3B9vy3S+iQqaYTjH6CEA1GVLEXSCN8WSiGxKKzM8TJCIOwz+7jKmS08S
         hpQoRNGDFZ1CY4poq2blHx5GPpxzWf2UAlbFZxdnjzLFomL3LmZY08J8p43RRts2iY
         w9wWrXzXlRYjJge2H7wK2OQtcStXNbx3o3PctmbQ=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200502170801.GB6742@magnolia>
References: <20200502170801.GB6742@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200502170801.GB6742@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/iomap-5.7-fixes-1
X-PR-Tracked-Commit-Id: b75dfde1212991b24b220c3995101c60a7b8ae74
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f66ed1ebbfde37631fba289f7c399eaa70632abf
Message-Id: <158844510226.26966.830662685597317444.pr-tracker-bot@kernel.org>
Date:   Sat, 02 May 2020 18:45:02 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>, riteshh@linux.ibm.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 2 May 2020 10:08:01 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.7-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f66ed1ebbfde37631fba289f7c399eaa70632abf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
