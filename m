Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50495C43214
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A66E610CE
	for <linux-xfs@archiver.kernel.org>; Tue, 31 Aug 2021 18:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbhHaSU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:32940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238065AbhHaSU1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 31 Aug 2021 14:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2EAA76109E;
        Tue, 31 Aug 2021 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630433972;
        bh=5JRGNUqDLlpsDyvNZyIQGizw+zFGYfPkJEsRlCg7bnI=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=lrMPIWdk2Ucr8TAbnA4IA9eDl5C6Nd+KAR2Enat6P+x4mDz0Hf0i1io8njXdtX3TI
         xSsl55uimudZ7CPLrWd7tHJ72uNLhwtQlybQ9m1Q2lm0ZBboKPxWVfvPJ98EIe+U7h
         CFWx9EOELgXG6yh+8fGEIpfqGJ+YQtKO65f3dHoqCWY7fq6pta1DYIcfrK76ThYkO3
         Juel3fazyWe+lMXjzsyQj5S9nR/1Oo4FoI2zPzBQUh/DyhJwKc/m/VxeLq0yc5ivzK
         Qz52ttZXpDGW40HxfV8/n868d5MBlbA1tqoxaw0gGtV+dkzHIb2FZnTqh8k7rkT0i2
         L5KSiSiekuS5w==
Subject: Re: [GIT PULL] iomap: new code for 5.15
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20210831170147.GB9959@magnolia>
References: <20210831170147.GB9959@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20210831170147.GB9959@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.15-merge-4
X-PR-Tracked-Commit-Id: 03b8df8d43ecc3c5724e6bfb80bc0b9ea2aa2612
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0ee7c3e25d8c28845fceb4dd1c3cb5f50b9c45a9
Message-Id: <163043397216.24672.17374153932329919522.pr-tracker-bot@kernel.org>
Date:   Tue, 31 Aug 2021 18:19:32 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de, hsiangkao@linux.alibaba.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Tue, 31 Aug 2021 10:01:47 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.15-merge-4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0ee7c3e25d8c28845fceb4dd1c3cb5f50b9c45a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
