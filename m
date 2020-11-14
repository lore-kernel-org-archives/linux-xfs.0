Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028F1C6379F
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC58221EB
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="cu8895YJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgKNAPU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgKNAPG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 13 Nov 2020 19:15:06 -0500
Subject: Re: [GIT PULL] vfs: fs freeze fix for 5.10-rc4 (part 2)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605312905;
        bh=k4/PnQ+p2Jl24eNJPehdrcmwj0CoVQL2vFP8EMZRcWI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=cu8895YJUmZ4IrFcVJmnnc3BoYASjxzpQw3KTcVzQG1ktZiznv5cNtRruwn3EjHdA
         5p9YQxVp0XogzFvOXBMiYSp6Er/UpxcZijW/4XGLERsjItwfqJGsksBdsSFh9I3wSs
         x2qFmoCrY+P9sKHeKlO7xntIaxtNocc1E92cE0JU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20201114000129.GY9695@magnolia>
References: <20201114000129.GY9695@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20201114000129.GY9695@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.10-fixes-2
X-PR-Tracked-Commit-Id: 9b8523423b23ee3dfd88e32f5b7207be56a4e782
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f01c30de86f1047e9bae1b1b1417b0ce8dcd15b1
Message-Id: <160531290586.27003.15952867949757303905.pr-tracker-bot@kernel.org>
Date:   Sat, 14 Nov 2020 00:15:05 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, fdmanana@kernel.org,
        linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Fri, 13 Nov 2020 16:01:29 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/vfs-5.10-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f01c30de86f1047e9bae1b1b1417b0ce8dcd15b1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
