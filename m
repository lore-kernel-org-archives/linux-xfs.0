Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75EBEB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 18:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjGTSBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 14:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbjGTSBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 14:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FCF2709
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 11:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25BA961B86
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 18:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FD15C433C7;
        Thu, 20 Jul 2023 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689876082;
        bh=yMJsnBQPniBNd2arFeGqR1a1tHIT/D/1RjguYZi12dw=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=F8GermyjbBrkkC/Vy59sT5nNPeyOk/OfJbSWRXLtLOrXBXbx9DPSUT/GkFSqZbVHA
         XIw7wCBf80Enyb9N3lmo3DFc2FwEYg7F5swozQnXjSOe3Q+wC6WXLO0pP5JtMYkoKy
         jzDziQRid6U6BhImq77iccqNlyJpvCT5O8bcMfPKpb4q/LqgQ41UviiFtDMmTDN5yy
         5SIjyy2kxvkPTzqryNh0yp8UAJ0HCxKeoIWpf3yMet3ugRw3qV91jU3h9fHftX2eTq
         iXP5DjVIEmBkkuN0bHXw938oN3NFjB/+4r7XOAjVM0YBaYubTl/24s5PJEm9cBdpAB
         hCA1KjaCV8HWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6BDE2E21EF6;
        Thu, 20 Jul 2023 18:01:22 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: ubsan fixes for 6.5-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <168987105684.3204878.5341349915656531912.stg-ugh@frogsfrogsfrogs>
References: <168987105684.3204878.5341349915656531912.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <168987105684.3204878.5341349915656531912.stg-ugh@frogsfrogsfrogs>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.5-fixes-1
X-PR-Tracked-Commit-Id: f6250e205691a58c81be041b1809a2e706852641
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 69435880cf138484c3012f6c38dcbc5605de39ee
Message-Id: <168987608243.6871.6272996322832343500.pr-tracker-bot@kernel.org>
Date:   Thu, 20 Jul 2023 18:01:22 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     djwong@kernel.org, torvalds@linux-foundation.org,
        david@fromorbit.com, hch@lst.de, keescook@chromium.org,
        linux-xfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Thu, 20 Jul 2023 09:46:30 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.5-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/69435880cf138484c3012f6c38dcbc5605de39ee

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
