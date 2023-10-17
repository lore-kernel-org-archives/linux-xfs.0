Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFB2CDB474
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbjJQPqK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbjJQPqA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:46:00 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF1E109
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:45:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5C7C433C7;
        Tue, 17 Oct 2023 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557545;
        bh=3dGPwiF2nRChXnmdgWsZhKugyZ8DDPbn7W8QALKRq9E=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hX6QK+h3dDLQFhMs/F4WqoIw/gbPKT7XCOv3HB1BIPAbZhSgm8vq5cVwyt78gisea
         cNQ+GBL5Crp6t/2pYmvHy9v1rPwVkSiQf/KDvaKm48Dl8MmnNyNGNuadM9A8RHDUPN
         9i61mIrHGEd5qCsbP5tObas6YCYV589STa1/QM0KcyLm8eRz+XpEDxYw/bawF5v3kq
         0h7egWcPujBDLrF/cgFSreRQut1aMDdcPfKZVXr7z4y+qY01q0T/wFDxz72ykG/rg8
         FMEayIO3JRO3fGgWa+zBZG0ak9xg/+OjtV2IyaMcyUNtrVdPvg/G7/IWJJVyBXlK2B
         AaeInXlOIrHSQ==
Date:   Tue, 17 Oct 2023 08:45:45 -0700
Subject: [PATCHSET RFC v1.1 0/4] xfs: minor bugfixes for rt stuff
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755740893.3165385.15959700242470322359.stgit@frogsfrogsfrogs>
In-Reply-To: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
References: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
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

