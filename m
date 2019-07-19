Return-Path: <SRS0=I0PM=VQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63BEC7618F
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jul 2019 19:45:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A02AE21880
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jul 2019 19:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563565514;
	bh=AjkeX1/9njlH2GZEKu5i9tUHylTBdJ3HoQAtY022+5I=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=dSFszzMltxPqgETbjN9TOfmuK3kEu1ok+++q2Rg/qmxPOjPXXRATkkYmx+RvmBiIM
	 +L0agCmGvr9nPTq6GPusDd3BDHEC7qY7aQIUD1Dz/TiyBJR5iaiRB/mwt1VtsD18xx
	 olXEi9VUi1QSZBR9NACuaZrx5wFRTfbwFq1t2kKc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733223AbfGSTpI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jul 2019 15:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:34312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733285AbfGSTpH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Jul 2019 15:45:07 -0400
Subject: Re: [GIT PULL] iomap: cleanups for 5.3 (part 2)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563565506;
        bh=AjkeX1/9njlH2GZEKu5i9tUHylTBdJ3HoQAtY022+5I=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=oNvioO0AyHC5kfH0Rx8UoFpkg3m8AWmabEj7fsNBS4XTtiD7yycdc8EjQU1W4Agp9
         B9+KfmnyoM1RBs5BZmU7oWmicoQrxZpzJ7+0CYrdlk1+vT/sh7/2/VYO/hSoIP+Rrb
         Wn0GzEjCH070ys+CgsoRqO2MmE8jssOHBsCvx8mg=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190719162221.GF7093@magnolia>
References: <20190719162221.GF7093@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190719162221.GF7093@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/iomap-5.3-merge-4
X-PR-Tracked-Commit-Id: 5d907307adc14cd5148b07629c2b4535acd06062
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 26473f83703e6bc56114ce4b045000de6efcfff7
Message-Id:
 <156356550679.25668.5508035864440295283.pr-tracker-bot@kernel.org>
Date:   Fri, 19 Jul 2019 19:45:06 +0000
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        sandeen@sandeen.net, hch@lst.de, agruenba@redhat.com,
        rpeterso@redhat.com, cluster-devel@redhat.com
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190719194506.QjxILnbLQRGXe3YLZ9zzUaHu3u_4GotEx6VJWsDAihA@z>

The pull request you sent on Fri, 19 Jul 2019 09:22:21 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.3-merge-4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/26473f83703e6bc56114ce4b045000de6efcfff7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
