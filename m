Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73463C6FA99
	for <linux-xfs@archiver.kernel.org>; Sun, 12 Mar 2023 16:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjCLQ6C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 12 Mar 2023 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCLQ6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 12 Mar 2023 12:58:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB126171B
        for <linux-xfs@vger.kernel.org>; Sun, 12 Mar 2023 09:57:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 460BF60F64
        for <linux-xfs@vger.kernel.org>; Sun, 12 Mar 2023 16:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B949C433EF;
        Sun, 12 Mar 2023 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678640277;
        bh=aOz46fcKQVeyJWNS8wG/QlmCVSI0vSAthrKu9lRKOoE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Em45Hm3hpwndeMGGowF464PD+Y54EeShGdvAbUrMCi/W1w2V8Kf4eLneHjzpJB+PK
         n4wVIKYSt+hHtSs/CRxirOcPVpfJIydQmsCy6cq7B5PugJBP03+vwUfNq63dsvyDkq
         eDVI0JqjnQjT5Xqh9KJsDTEaBHqqiQgNjAQDe5ZRsV77RJ9qcbm/SVa6BjrkrkV19W
         3daBZctPAcuTYarEx4nMHAWRUeQ5ksKNs+1fYXdZD+8TjX5LODB3n+tBiLgTkMm9R4
         wdssWSd1PQUNDpPv6HIjKVut8eklNft1rSM2DCdlZGUlxBNqXb6p4I1KufgotplbJj
         TfGkJzgaOmSYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8695BE61B75;
        Sun, 12 Mar 2023 16:57:57 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: bug fixes for 6.3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <167863926526.335292.4073445070513678525.stg-ugh@magnolia>
References: <167863926526.335292.4073445070513678525.stg-ugh@magnolia>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <167863926526.335292.4073445070513678525.stg-ugh@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-1
X-PR-Tracked-Commit-Id: 8ac5b996bf5199f15b7687ceae989f8b2a410dda
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2e545d69bd43a97879309493864529194661bb43
Message-Id: <167864027754.31549.15812821776983882005.pr-tracker-bot@kernel.org>
Date:   Sun, 12 Mar 2023 16:57:57 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     djwong@kernel.org, torvalds@linux-foundation.org,
        david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, pengfei.xu@intel.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sun, 12 Mar 2023 09:44:10 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2e545d69bd43a97879309493864529194661bb43

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
