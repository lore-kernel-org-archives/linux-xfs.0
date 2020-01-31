Return-Path: <SRS0=/Bg7=3U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BACBC33CB7
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 21:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EAAB20705
	for <linux-xfs@archiver.kernel.org>; Fri, 31 Jan 2020 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580505009;
	bh=MCkR/ng7bUbpozJhY4zARLxv1MqEKe/eRZIzdiuzBpY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=gova6Ey39A4t2YekIxVrI+qnEFgNCUiml409PdEkV+56NXjYktYASS5xjs0IwpYHr
	 Zmr/Ib32ns4z9VDxwhbIPJ2jpJ6RLjqtF20Ik+ssp53T96Hid+fmR5Xib+OApOSlX/
	 t6YrQeQFk223zHnI808AI1HFufUioGny924/bYks=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgAaVKE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 31 Jan 2020 16:10:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:44994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbgAaVKE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Jan 2020 16:10:04 -0500
Subject: Re: [GIT PULL] iomap: new code for 5.6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580505004;
        bh=MCkR/ng7bUbpozJhY4zARLxv1MqEKe/eRZIzdiuzBpY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=HZsATbrqIem72P9LB8QleE0QUROvKJ5Gl4owE8YRYhBDDRbjHL1kNlGHbXfEtiqJ8
         J08VkzmdwLvrygp/eV4g/5kz5mhFLq6cxrXaAmFLjnM803Q5XrvLKtIMuMdxby1vUz
         ZICGVt9Uaa1mHfs6XT9FXJROYwNXDcaPiPLmXp5U=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200131040753.GB6869@magnolia>
References: <20200131040753.GB6869@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200131040753.GB6869@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/iomap-5.6-merge-3
X-PR-Tracked-Commit-Id: 243145bc4336684c69f95de0a303b31f2e5bf264
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 677b60dcb68a0c43822b5a8ad97733b4193386b9
Message-Id: <158050500400.4115.17533922606838474963.pr-tracker-bot@kernel.org>
Date:   Fri, 31 Jan 2020 21:10:04 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de, agruenba@redhat.com,
        rpeterso@redhat.com, cluster-devel@redhat.com,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 30 Jan 2020 20:07:53 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.6-merge-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/677b60dcb68a0c43822b5a8ad97733b4193386b9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
