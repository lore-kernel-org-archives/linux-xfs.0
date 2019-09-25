Return-Path: <SRS0=XLdA=XU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFFBC4360D
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 17:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C73B5207E0
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Sep 2019 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569433217;
	bh=/w//plmTVfb+jD8Ts2mXorTsUriRLt0L6daqDu4/6EY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=uKP+pO27SMYP4evksTC8JrFo9a1tJ0KYsWNuu+EnbnBj/XrlnDN/hw5TlWdWe/Byr
	 4Vs23MRh9H4rH8trge5d1tKQog17gCfp1AtiHihjoSiTSmV1tT/WvpeQOcAxalmZE0
	 JNb80AcKQkQRxbHBq81gLpK4dafS9T1pPapXNjNE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443045AbfIYRkF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Sep 2019 13:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2443032AbfIYRkE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Sep 2019 13:40:04 -0400
Subject: Re: [GIT PULL] iomap: (far less) new code for 5.4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569433204;
        bh=/w//plmTVfb+jD8Ts2mXorTsUriRLt0L6daqDu4/6EY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=drJdohMAPFDyY+lsGSHUixoJM/qIqY7aHvtrLYjmiB4FOpDEkTa5lWrdcTKfG+/5X
         erRK42cKLp4gL4x4cDPFcBN23BeqsnQo4loJK4tkGbf6IeiVYN92iRnLtL3BkguxLX
         IuNGn79SP7yl2Kyh4/+Cpijm833oDVz5lq8lXeh4=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20190924170248.GZ2229799@magnolia>
References: <20190924170248.GZ2229799@magnolia>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20190924170248.GZ2229799@magnolia>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
 tags/iomap-5.4-merge-6
X-PR-Tracked-Commit-Id: 838c4f3d7515efe9d0e32c846fb5d102b6d8a29d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4ef5b13a294c136c9673a8e04e6afea333c7f755
Message-Id: <156943320431.26797.4088494249840572183.pr-tracker-bot@kernel.org>
Date:   Wed, 25 Sep 2019 17:40:04 +0000
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

The pull request you sent on Tue, 24 Sep 2019 10:02:48 -0700:

> git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/iomap-5.4-merge-6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4ef5b13a294c136c9673a8e04e6afea333c7f755

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
