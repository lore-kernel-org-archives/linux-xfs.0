Return-Path: <SRS0=V8GW=V7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE0BC433FF
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Aug 2019 18:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A15A214AE
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Aug 2019 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564856703;
	bh=W63KeKcvsCsWsH7W36Bbackx+e/UA+/F2PmXbbz2fFk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=Aj9jh1x5MZA2BqQ5XnKm2hxKMcfMErTtHVgYrVi8Y/zEEDE3VfZobjCKvov/pluiC
	 E1npg46we4Rj5gb7ScHxPe4d95JRdWGVadAghe3dDzHY4eG1fXhWuV7L6UsjVusSxD
	 QlCbYSV8Op8G/NF/EFHFJlYwXOZJBTsh0honWOS4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbfHCSZC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Aug 2019 14:25:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728600AbfHCSZC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 3 Aug 2019 14:25:02 -0400
Subject: Re: [GIT PULL] xfs: cleanups for 5.3-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564856701;
        bh=W63KeKcvsCsWsH7W36Bbackx+e/UA+/F2PmXbbz2fFk=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=kzNYq10+nsi+u09gfzu/p7IEL4CQvhn2q5FJGK+0Zbtro/NR2txaVO23Dd8nV4yd+
         pVR77UoZpSbEImYf91L4MS3n7HA/TU4Pb+bC5hUMr7xEAET9NkxtLR1W8wmNIjRst7
         TveUa21dl6d7nDeRZ3mKb4kdWQPkQ7uO8AXtPX2g=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190803163312.GK7138@magnolia>
References: <20190803163312.GK7138@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190803163312.GK7138@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/xfs-5.3-fixes-1
X-PR-Tracked-Commit-Id: afa1d96d1430c2138c545fb76e6dcb21222098d4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e12b243de76dcc24a904a48a2efda94fdc4cdf07
Message-Id:
 <156485670157.25774.15292161755260080253.pr-tracker-bot@kernel.org>
Date:   Sat, 03 Aug 2019 18:25:01 +0000
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
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190803182501.Writ7g6dEuIG_9H68MnKYIE40Ae4925aL7MjM9X_WCA@z>

The pull request you sent on Sat, 3 Aug 2019 09:33:12 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-5.3-fixes-1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e12b243de76dcc24a904a48a2efda94fdc4cdf07

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
