Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15353C54EBE
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Jan 2023 18:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236300AbjAHSbZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Jan 2023 13:31:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbjAHSbX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2023 13:31:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C991BCB5
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 10:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C840460DBD
        for <linux-xfs@vger.kernel.org>; Sun,  8 Jan 2023 18:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CAF1C433D2;
        Sun,  8 Jan 2023 18:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673202682;
        bh=lgXCkDD0m8ppWU4I96AmzazTjPqtedjGfPm3WViIMk8=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=OC80NNuJ/rtiXX8fri7E1cMy4uQq1RxZ7MKGERBngwgdk3nfQYpiRj3RGUhMLnouy
         VTAQMSk4tMa9W7P7qA9bh6gf93Vhx4L9WdjOagpdO1i/2nmQb5I6ZV5c7vHGdOFCSK
         3Hi5F9SlKOsYNC9jjoRL57pafyXrkQkiAM3uOLyqxELIZomi5h00R9BOPeqLiUPBOC
         IlI1in+4DWFJFT1tySplrRPC2AU3baB4SSo9lKTYlbx32ssvX7CHksNeH2cC+JhjpR
         WBnXNwgfdUSB5vb24x8Nf0CMfRJVBQ1SrzgzWjLok4O9NIvtyXJv7pKzvJwh7oXQIM
         dt1kQ3uiWyzUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1848DE57231;
        Sun,  8 Jan 2023 18:31:22 +0000 (UTC)
Subject: Re: [GIT PULL] xfs: bug fixes for 6.2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <167320037778.1795566.14815059333113369420.stg-ugh@magnolia>
References: <167320037778.1795566.14815059333113369420.stg-ugh@magnolia>
X-PR-Tracked-List-Id: <linux-xfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <167320037778.1795566.14815059333113369420.stg-ugh@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.2-fixes-2
X-PR-Tracked-Commit-Id: 601a27ea09a317d0fe2895df7d875381fb393041
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 1fe4fd6f5cad346e598593af36caeadc4f5d4fa9
Message-Id: <167320268209.21772.14411633672094894747.pr-tracker-bot@kernel.org>
Date:   Sun, 08 Jan 2023 18:31:22 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     djwong@kernel.org, torvalds@linux-foundation.org,
        david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, shiina.hironori@fujitsu.com,
        wen.gang.wang@oracle.com, wuguanghao3@huawei.com,
        zeming@nfschina.com
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sun, 8 Jan 2023 10:00:43 -0800:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.2-fixes-2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/1fe4fd6f5cad346e598593af36caeadc4f5d4fa9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
