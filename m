Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EFCC001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Aug 2023 15:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbjHJP3c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbjHJP3c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2023 11:29:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFABD10C7
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 08:29:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43F5E66023
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 15:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3ACC433C7;
        Thu, 10 Aug 2023 15:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691681370;
        bh=aVRTIYVNp3E7baUjxE0BEIl6IyYsve0l3ipn8MMbzR4=;
        h=Date:From:To:Cc:Subject:From;
        b=U8aa4pdWt5CBoTyPqJAt+tg8tk17v/gnDexBfq+qATn3qOhlen2w8emP/moensFwN
         K45dA1QEpH0LPxu+6qCg5LnEXRUIxDh/BdUV7a4dtKCqDyo/75O2Q7lCVFRzPj1zo2
         JHJ8jsucqyeA3DEuj43Sxt72lfou6ZPjrK8RWvlDN3obOEZl8L75cR59+8sm1aEkgC
         Xtrtea1RKSGUE3sBqwsgtT9Emh7wfi3z9iTRlLmxUuVbRTPVSb7A6fHDpXkP0Rgdly
         3oxNAZkb7iOu4Ou03n8ggCvnEswfhGv5Qox3pbvpw+ixx7jmUIGwdfkWqif6OVTlgl
         /QnGePFefLMBw==
Date:   Thu, 10 Aug 2023 08:29:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@oracle.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 9/9] xfs: fixes for the block mapping checker
Message-ID: <169168058524.1060601.3805776959124380374.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit a634c0a60b9c7942630b4f68b0af55c62d74b8fc:

xfs: fix agf_fllast when repairing an empty AGFL (2023-08-10 07:48:11 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-bmap-fixes-6.6_2023-08-10

for you to fetch changes up to e27a1369a9c1907086e6bf8735504a88394074c9:

xfs: don't check reflink iflag state when checking cow fork (2023-08-10 07:48:13 -0700)

----------------------------------------------------------------
xfs: fixes for the block mapping checker [v26.1]

This series amends the file extent map checking code so that nonexistent
cow/attr forks get the ENOENT return they're supposed to; and fixes some
incorrect logic about the presence of a cow fork vs. reflink iflag.

This has been running on the djcloud for years with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: hide xfs_inode_is_allocated in scrub common code
xfs: rewrite xchk_inode_is_allocated to work properly
xfs: simplify returns in xchk_bmap
xfs: don't check reflink iflag state when checking cow fork

fs/xfs/scrub/bmap.c   |  33 +++++------
fs/xfs/scrub/common.c | 152 ++++++++++++++++++++++++++++++++++++++++++++++++++
fs/xfs/scrub/common.h |   3 +
fs/xfs/scrub/ialloc.c |   3 +-
fs/xfs/scrub/trace.h  |  22 ++++++++
fs/xfs/xfs_icache.c   |  38 -------------
fs/xfs/xfs_icache.h   |   4 --
7 files changed, 193 insertions(+), 62 deletions(-)
