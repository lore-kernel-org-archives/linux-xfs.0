Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E62C54E76
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Nov 2023 19:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjKRTpH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Nov 2023 14:45:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjKRTpF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Nov 2023 14:45:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC31A0
        for <linux-xfs@vger.kernel.org>; Sat, 18 Nov 2023 11:45:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73007C433C7;
        Sat, 18 Nov 2023 19:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700336702;
        bh=9e3eBP7cjzbVZa6uTDZMrsdlkh2e3SYO3z+2ij30YyE=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ctTXpXvLlL/7Q+A0vwMShn2V9G4rSC5w51KsZgNAzANY6uFutAj7a7Kc9T+xS27Sy
         2fkvI+LiP84gkH1CKeZTl4PiXnY6qs4GaBWSW5yM2w6rREMLaoZ5TYMRfSu/4ANnt+
         F0Ss0B9fV/G01o6QXZY+uTFGbqjyfABbAhC86YPAf48RfTgOgo9FcnDsOVPoPjExE2
         hAjXQJ7q2v3ykqv8ZX8M1/vSrEQ/pS6vEbxtPyRb8qFlUSbzMbEeEK44jumO7tZLKG
         GB5tThLpjq9vJ/zISQ2EvE+z/1cug+Hg7nlM5T5vJL8FBqtM+9G2It5gQ35RqSHxpm
         c1EBeZHItn6tw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5EA66EA6303;
        Sat, 18 Nov 2023 19:45:02 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: bug fixes for 6.7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <87zfzb31yl.fsf@debian-BULLSEYE-live-builder-AMD64>
References: <87zfzb31yl.fsf@debian-BULLSEYE-live-builder-AMD64>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <87zfzb31yl.fsf@debian-BULLSEYE-live-builder-AMD64>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.7-fixes-1
X-PR-Tracked-Commit-Id: 7930d9e103700cde15833638855b750715c12091
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b8f1fa2419c19c81bc386a6b350879ba54a573e1
Message-Id: <170033670238.17055.1005866990569291348.pr-tracker-bot@kernel.org>
Date:   Sat, 18 Nov 2023 19:45:02 +0000
To:     Chandan Babu R <chandanbabu@kernel.org>
Cc:     torvalds@linux-foundation.org, ailiop@suse.com,
        chandanbabu@kernel.org, dchinner@redhat.com, djwong@kernel.org,
        hch@lst.de, holger@applied-asynchrony.com, leah.rumancik@gmail.com,
        leo.lilong@huawei.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, osandov@fb.com, willy@infradead.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 18 Nov 2023 13:46:27 +0530:

> https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.7-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b8f1fa2419c19c81bc386a6b350879ba54a573e1

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
