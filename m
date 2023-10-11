Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0829ACDB482
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 20:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjJKUZ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 16:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235141AbjJKUZ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 16:25:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BC0A9
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 13:25:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40806C433C8;
        Wed, 11 Oct 2023 20:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697055956;
        bh=oMLQUbmEChogNs3XsRJzxE6/eUMeXiwM5vRpbrP6etA=;
        h=Date:From:To:Cc:Subject:From;
        b=XmagGqYadfP3+Ge7ELuv6r+sgPwdZMOoDaTDfkN6TTImItVVmmEMZWC/ive9ghcfT
         9p1XMmeSPu3vJ033ii7IM0hn7sWo5gMDCIbjl98D35vTb2qRj3aJnl29swUpISsHC6
         uyuvf7OASmgnWoEFU1EHhwZ800Mo7VAs5arsOjqEAlJwqgKRdRgp/d3qazB4NhmSHQ
         4qS84cP6ai6O0k+B8u0EeOmzvBf6HHdNN8SlluUZmux+9RDFEN6IsGaetMOwsYYQEI
         QnOrzND5BeTZBn9DyhMfNE6V+BndAOFup+mR6sDi+TVVdLA7OsvMjdZ0XC958oQvjd
         6KA5Dl7CA88Gw==
Date:   Wed, 11 Oct 2023 13:25:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandanbabu@kernel.org, djwong@kernel.org
Cc:     hch@lst.de, linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: random fixes for 6.6
Message-ID: <169705592352.1904383.16093106416173167857.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.6-rc6.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 94f6f0550c625fab1f373bb86a6669b45e9748b3:

Linux 6.6-rc5 (2023-10-08 13:49:43 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/random-fixes-6.6_2023-10-11

for you to fetch changes up to 442177be8c3b8edfc29e14837e59771181c590b3:

xfs: process free extents to busy list in FIFO order (2023-10-11 12:35:21 -0700)

----------------------------------------------------------------
xfs: random fixes for 6.6
Rollup of a couple of reviewed fixes.

This has been lightly tested with fstests.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: adjust the incore perag block_count when shrinking
xfs: process free extents to busy list in FIFO order

fs/xfs/libxfs/xfs_ag.c   | 6 ++++++
fs/xfs/xfs_extent_busy.c | 3 ++-
2 files changed, 8 insertions(+), 1 deletion(-)
