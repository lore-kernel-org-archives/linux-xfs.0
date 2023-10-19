Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F92CDB482
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Oct 2023 16:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjJSQUA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Oct 2023 12:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjJSQT7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:19:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54476114
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:19:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83A6C433C7;
        Thu, 19 Oct 2023 16:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732398;
        bh=3dGPwiF2nRChXnmdgWsZhKugyZ8DDPbn7W8QALKRq9E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=AFeRftE+wghoiq6ah0vhMwNPuPNrkbBZFQhAe0LeDAEceiPekiMPals8AHk8MuEvH
         4AhUSEnVcoTR1O0MN/rSls3+Zk39ZrikQhMJ1tRb5fPELTaa1cVursow9t22zrKz82
         rccpDrrUwfZHP5La888E2gnvW+A4QX1znH96vhbpWysbbp1JkPLA5qBhg+ut1YxO8q
         XZqrYe9l017TEMBlHRTvjCVumjDrLc+A+/saxyjCyaqZamQnvqqSTx83WgMT1YlW8P
         XFZdoi+ev5g1kg9AZvDGbz1qYfvGI1a7soqLrvh2Lqv2dLNqoJNC2GUPJktCa7TViW
         EfuNsIEx5XNSA==
Date:   Thu, 19 Oct 2023 09:19:57 -0700
Subject: [PATCHSET v1.1 0/4] xfs: minor bugfixes for rt stuff
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
In-Reply-To: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
References: <169773138573.213752.7387744367680553167.stg-ugh@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a preparatory patchset that fixes a few miscellaneous bugs
before we start in on larger cleanups of realtime units usage.

v1.1: various cleanups suggested by hch

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-fixes-6.7
---
 fs/xfs/libxfs/xfs_bmap.c     |   19 +++----------------
 fs/xfs/libxfs/xfs_rtbitmap.c |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.h       |    2 +-
 fs/xfs/xfs_rtalloc.c         |    2 +-
 fs/xfs/xfs_rtalloc.h         |   27 ++++++++++++++++-----------
 5 files changed, 54 insertions(+), 29 deletions(-)

