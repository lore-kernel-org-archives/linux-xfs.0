Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA0CC61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 22:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjBVW12 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 17:27:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbjBVW1X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 17:27:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BF746171
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 14:27:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12331615B9
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 22:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 829BDC433D2;
        Wed, 22 Feb 2023 22:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677104830;
        bh=fcIsN5KC2BrUpaQzkk5bsCg6rVC6JHYIRll3pxiDg6Y=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=qBdbfukpPFQC++onQ9NHwA2lWIDfE5NuK+D4u4v1QnPOSnMe8qYxP+Sjskbn/ftV8
         h5DjuvB5zL8EZAi3r/xxAHM4ct1eS4QiE0TVHsF7i8eDRpdOBIABW4fl0QUZFz2CjU
         eOJ40UTN10ir4zMG+lK6B+evQYk6jqPSQ3ISQWLhc/wLmlLUgK9dtLqj91nK+ijpWg
         ESidtUpjfOy6k4EMHnjaZ0JRPui5FtEBHQJZOQ8vAE8hdn1HioYjdTQdiXOifM/fMo
         znqbE/R6AVNOmUTtEbWbrIeBjGrfS9z52SZBlXun4quL6foAvX7vokKCv/djxQU1CO
         iJ5kRH4cN38Mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68820C43151;
        Wed, 22 Feb 2023 22:27:10 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: new code for 6.3, part 1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <167703988328.1924095.8788731347369739159.stg-ugh@magnolia>
References: <167703988328.1924095.8788731347369739159.stg-ugh@magnolia>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <167703988328.1924095.8788731347369739159.stg-ugh@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-merge-2
X-PR-Tracked-Commit-Id: dd07bb8b6baf2389caff221f043d9188ce6bab8c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 28e335208ce90c2cca9990543983b97ccc66f302
Message-Id: <167710483042.21044.2583122541908227182.pr-tracker-bot@kernel.org>
Date:   Wed, 22 Feb 2023 22:27:10 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     djwong@kernel.org, torvalds@linux-foundation.org,
        dchinner@redhat.com, ddouwsma@redhat.com,
        linux-xfs@vger.kernel.org, linux@weissschuh.net,
        syzbot+898115bc6d7140437215@syzkaller.appspotmail.com,
        xu.panda@zte.com.cn, yang.yang29@zte.com.cn
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Tue, 21 Feb 2023 20:36:34 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-merge-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/28e335208ce90c2cca9990543983b97ccc66f302

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
