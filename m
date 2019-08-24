Return-Path: <SRS0=f2ny=WU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC2CC3A59E
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 18:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75BE42146E
	for <linux-xfs@archiver.kernel.org>; Sat, 24 Aug 2019 18:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566672303;
	bh=gHyDCE3aCptXa2E6OKMDFE/9jBwzksomog71PhkwAgk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=fGwpfM21cRXivCmns6vZaho3zdtyRbnuE0CYvYSn5VkawjGaNsBcJwCf69H/Eaw6C
	 ESu/xepLf7SChtJslLLDqjWgRPYz/JkoQrvwh59BjyADECmr1eWXjmeC7smSAdpmzF
	 mB+WliU2+nlfpXoMB/heaEBrco4COqTCYCEllgEo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfHXSpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Aug 2019 14:45:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727019AbfHXSpC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 24 Aug 2019 14:45:02 -0400
Subject: Re: [GIT PULL] xfs: fix for 5.3-rc6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566672301;
        bh=gHyDCE3aCptXa2E6OKMDFE/9jBwzksomog71PhkwAgk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=GO1ZetpsTXMRFk4fK1FYEgwA3m3vwqwGrG5DUf06Plj3qmAzwVPkMxYG8nBK8ptAv
         /nBM0uLqQcbF+8Zs1TtzzNFaGO4X/bQNXiD1AGatoQ7VOrzM1IFc6HbN2E9A/5EKgS
         xmp/8xyI/wCuaLl2uID+bFOh4ppm9mUdhlvGaJuU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190824162705.GM1037350@magnolia>
References: <20190824162705.GM1037350@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190824162705.GM1037350@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.3-fixes-6
X-PR-Tracked-Commit-Id: 1fb254aa983bf190cfd685d40c64a480a9bafaee
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8942230a7e1c5277969adb0fbaad50dec9b4651b
Message-Id: <156667230161.2337.16202262875866242315.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Aug 2019 18:45:01 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pull request you sent on Sat, 24 Aug 2019 09:27:05 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.3-fixes-6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8942230a7e1c5277969adb0fbaad50dec9b4651b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
