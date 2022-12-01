Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232E7C4321E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 17:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiLAReq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Dec 2022 12:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiLARej (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Dec 2022 12:34:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ADDAD9AD
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 09:34:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B703620AC
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 17:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3E8C433B5;
        Thu,  1 Dec 2022 17:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669916073;
        bh=mhinNx3dFfejiEDqlF/2peWOBSwe+65GgyLkcN+NVmw=;
        h=Date:From:To:Cc:Subject:From;
        b=SksfnTUXemv2Lf7zQ4jYYdCD8jfLHa6wE4G8ZRt21UVlMgxkbIYjO50z2wzivFV2j
         w+R1FE3v+JNORFO1QM58+E9COcszGQpasYijt2jE05rw9rXGj5Nz/K1zsggsbwJVh2
         JnTqMVAYj9mvu25mQ7k+isk3kE6mvXMkJbEc6ttdlzjttUFNayijZanLJW3/eKvl7W
         ygmnMnMTT2FlTDha622Nq2nkho4Pf+f/VkXBMBYW8K+LpAPiwMmH5bDmoKHUdAILZy
         tyL2ePcFjVpSLkdTZ1UT/2SR4QRLIl/kYMUWj2JVPjxynO9dTI4kLZgwAGeCYrU/U5
         boDEJyIE+0GUw==
Date:   Thu, 1 Dec 2022 09:34:33 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, yangx.jy@fujitsu.com
Subject: [GIT PULL] xfs: fix broken MAXREFCOUNT handling
Message-ID: <166991600827.671955.16596502896674132543.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Please pull this branch with changes for xfs for 6.2-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 4b4d11bbeca4e3ebb235c8c3c875a986a8c90427:

Merge tag 'random-fixes-6.2_2022-11-30' of git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.2-mergeC (2022-11-30 09:25:25 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/maxrefcount-fixes-6.2_2022-12-01

for you to fetch changes up to b25d1984aa884fc91a73a5a407b9ac976d441e9b:

xfs: estimate post-merge refcounts correctly (2022-12-01 09:32:04 -0800)

----------------------------------------------------------------
xfs: fix broken MAXREFCOUNT handling

This series fixes a bug in the refcount code where we don't merge
records correctly if the refcount is hovering around MAXREFCOUNT.  This
fixes regressions in xfs/179 when fsdax is enabled.  xfs/179 itself will
be modified to exploit the bug through the pagecache path.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: hoist refcount record merge predicates
xfs: estimate post-merge refcounts correctly

fs/xfs/libxfs/xfs_refcount.c | 146 ++++++++++++++++++++++++++++++++++++++-----
1 file changed, 130 insertions(+), 16 deletions(-)
