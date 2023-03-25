Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00080C6FD1C
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 20:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjCYUUW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 16:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjCYUUV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 16:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CF3D309
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 13:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1DE960C8C
        for <linux-xfs@vger.kernel.org>; Sat, 25 Mar 2023 20:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25662C4339C;
        Sat, 25 Mar 2023 20:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679775620;
        bh=gppFKAq6T0g/QriSFFllpvls+KD+zCYiIpqlLDD3lLE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=KxJ47qpa/I258VD1yAQbFn8BdTPSLjqjswQcdFCnmKsYUz+KGc1IxWYWMm9teSD0i
         rFswRKbnyCt5nU5dTwN+iNBs+Gbcdh8OGcMkHr34KIocmddM+BaneoKW+lJrqyLOrt
         dpXOKze8APU1GebO9NwaCp+Wd8MaKVzC8pZCl21Kr6frSiLmQPi1KQz5Mrvqv2ylNP
         yDsHOVYrj6MiAX1sg13OUcfTTRsA6n8ElyRR7Yc06aS74Aqr9cuuDH6uc92UjNp9jb
         kz6XNZZ2wNQ0pe+P1DTW/T1mGGsVvRXfIctCp26/bFfw1rrUl/PrRPitSl8Q8KZi1Q
         f93C+EQZ0lQ4w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 127D0E4D021;
        Sat, 25 Mar 2023 20:20:20 +0000 (UTC)
Subject: Re: [GIT PULL 2/3] xfs: percpu counter bug fixes for 6.3-rc3
From:   pr-tracker-bot@kernel.org
In-Reply-To: <167976583201.986322.4007693111843261305.stg-ugh@frogsfrogsfrogs>
References: <167976583201.986322.4007693111843261305.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <167976583201.986322.4007693111843261305.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-4
X-PR-Tracked-Commit-Id: e9b60c7f97130795c7aa81a649ae4b93a172a277
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fcde88af6a783d32e735dd2615528e2bf7a0f533
Message-Id: <167977562007.2542.13800150750317936349.pr-tracker-bot@kernel.org>
Date:   Sat, 25 Mar 2023 20:20:20 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     djwong@kernel.org, torvalds@linux-foundation.org,
        david@fromorbit.com, dchinner@redhat.com, linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 25 Mar 2023 11:33:16 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.3-fixes-4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fcde88af6a783d32e735dd2615528e2bf7a0f533

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
