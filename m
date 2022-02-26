Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19B5AC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Feb 2022 19:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiBZTI7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 26 Feb 2022 14:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232122AbiBZTI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 26 Feb 2022 14:08:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDD96382;
        Sat, 26 Feb 2022 11:08:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CAB660EE7;
        Sat, 26 Feb 2022 19:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9BE07C340E8;
        Sat, 26 Feb 2022 19:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645902502;
        bh=lMQvOE2XB+IvTQAjRNY2MMLF3TtPNi22iNqOT/TvVws=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=LpucbKeMzZy5R4dKGjDM6dk0Z6EkbcOxJlpPs96FPjrUM3jH4lJxGxyJQgJ4mKbQu
         58dVpNjBRfpE5NpCIqiE+N2waxubFmDb4DKWkubkBg6xiS5S9z30qclpftjJNOb+6D
         5PxaxKrWuekhvkG0MBWj/ZRUm7kfGQuOCMgsAenrEyiqB+DFQLOS0Z2JU9/FNBuzC0
         4Yel5nauzXwkEIs/dk6L24mQArZmmnU+VZtz5uv7+VPWwnEI1pYmBejdS+s/yYfluO
         nM9AbjDhnIK9uG+XnqHnJwVW0BVfaBCp7lNR6R2kypzzQcLkqt67acRGB7o/JPF4+i
         f455ER4NibTZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 859DDEAC095;
        Sat, 26 Feb 2022 19:08:22 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: fixes for 5.17-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20220226050421.GZ8313@magnolia>
References: <20220226050421.GZ8313@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20220226050421.GZ8313@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.17-fixes-2
X-PR-Tracked-Commit-Id: b97cca3ba9098522e5a1c3388764ead42640c1a5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3bd9dd813820a258fdd7df5444b550b2b1a71db6
Message-Id: <164590250253.22829.8421551678388979175.pr-tracker-bot@kernel.org>
Date:   Sat, 26 Feb 2022 19:08:22 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Fri, 25 Feb 2022 21:04:21 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.17-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3bd9dd813820a258fdd7df5444b550b2b1a71db6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
