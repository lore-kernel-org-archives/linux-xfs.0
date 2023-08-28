Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5761AC83F12
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Aug 2023 20:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjH1UPZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Aug 2023 16:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233695AbjH1UO6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2023 16:14:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306BC188;
        Mon, 28 Aug 2023 13:14:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3CD66511A;
        Mon, 28 Aug 2023 20:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24CC0C433C7;
        Mon, 28 Aug 2023 20:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693253694;
        bh=f98Z5GfN6KaBLFh1kcNW86lmFTO2uRrUu9nVcP28V9g=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=OYrpJlw3pks5527n1ty8cKsHrC5ND6/UIUkyKHHEr1P5FkmzZPHX6agL2mA6XKPjx
         SUWPSKDuHruRJqwpD5bP6IthPQZmiwGm5xncmkmJHzr2zoJEHGZv59D8O57FAQYPgI
         pfi2Vq15nA9iHiogefZNpBy169nfcR9EmRYQHyurs2qJvj2/H04aSWCkpCgmnx5i91
         rUid+re0SxFKWq/u5/B7pDqeId8vxZCntHzPnD4tBGapdw2EcRhpUeKA/a/7FA88Ax
         2Qh+9QsQD1ysZkA4GQVXrkP8czG1FT4AU7bQ9WdBLkQcMH8MbSH7cMHOaVPfcTh+SK
         yipoj4Mkbm9Bg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13C41C3959E;
        Mon, 28 Aug 2023 20:14:54 +0000 (UTC)
Subject: Re: [GIT PULL] iomap: new code for 6.6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <169318520367.1841050.6633820486162376921.stg-ugh@frogsfrogsfrogs>
References: <169318520367.1841050.6633820486162376921.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <169318520367.1841050.6633820486162376921.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.6-merge-3
X-PR-Tracked-Commit-Id: 377698d4abe2cd118dd866d5ef19e2f1aa6b9758
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6016fc9162245c5b109305841f76cca59c20a273
Message-Id: <169325369407.5740.3383086917750482909.pr-tracker-bot@kernel.org>
Date:   Mon, 28 Aug 2023 20:14:54 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     david@fromorbit.com, djwong@kernel.org,
        torvalds@linux-foundation.org, araherle@in.ibm.com,
        axboe@kernel.dk, bfoster@redhat.com, dchinner@redhat.com,
        hch@lst.de, kent.overstreet@linux.dev,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        ritesh.list@gmail.com, willy@infradead.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sun, 27 Aug 2023 18:26:34 -0700:

> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-6.6-merge-3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6016fc9162245c5b109305841f76cca59c20a273

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
