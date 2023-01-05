Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7A5AC3DA7A
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Jan 2023 19:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjAETyZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Jan 2023 14:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbjAETyV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2023 14:54:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3127917E0A
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2023 11:54:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD049B81BAA
        for <linux-xfs@vger.kernel.org>; Thu,  5 Jan 2023 19:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D952C433D2;
        Thu,  5 Jan 2023 19:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672948457;
        bh=GP2X5BBynwKnD3hz7FmZhxkjZGwK2QOKBeAbZcS0k+s=;
        h=Date:From:To:Cc:Subject:From;
        b=Upz+tN8aRNbcDRkOOt7OI5xrv4jIbdqLZ8rfmWSYGB4tUuaRV4psiFa6bF9L6vMWT
         2M6OZEHTBDnkGrDnkp9MTx6/N0r82ZpjKS+ovqMQvHjWwsYYtV4Z412ZUUsTqomkt8
         YbKHVW7Yc7cobTAvQBu0G2LIIGP3zNau2XLVP6c9fLYg5oZN7f2Hj10dMdX1t8T0SL
         nPZESHfDSqXaOceUUfSWX49ghTY8iBplxr3lyzM4zSHseby4qKPeDpglq4GbaBA6ZF
         Q2VZQT1tlEBxZAB1MVooE/5diAk5GaO5PKf96TpzTINhADJCkld6k3SKKHw7bVNzCv
         DpQk4B6W8k7vg==
Date:   Thu, 5 Jan 2023 11:54:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, shiina.hironori@fujitsu.com,
        wen.gang.wang@oracle.com, wuguanghao3@huawei.com,
        zeming@nfschina.com
Subject: [ANNOUNCE] xfs-linux: for-next updated to 601a27ea09a3
Message-ID: <167293465078.4137380.6100661782655055993.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

601a27ea09a3 xfs: fix extent busy updating

7 new commits:

Darrick J. Wong (3):
[26870c3f5b15] xfs: don't assert if cmap covers imap after cycling lock
[d4542f314507] xfs: make xfs_iomap_page_ops static
[c0f399ff5149] xfs: fix off-by-one error in xfs_btree_space_to_height

Hironori Shiina (1):
[817644fa4525] xfs: get root inode correctly at bulkstat

Li zeming (1):
[e195605ed28b] xfs: xfs_qm: remove unnecessary ‘0’ values from error

Wengang Wang (1):
[601a27ea09a3] xfs: fix extent busy updating

Wu Guanghao (1):
[4da112513c01] xfs: Fix deadlock on xfs_inodegc_worker

Code Diffstat:

fs/xfs/libxfs/xfs_btree.c |  7 ++++++-
fs/xfs/xfs_extent_busy.c  |  1 +
fs/xfs/xfs_icache.c       | 10 ++++++++++
fs/xfs/xfs_ioctl.c        |  4 ++--
fs/xfs/xfs_iomap.c        |  2 +-
fs/xfs/xfs_qm.c           |  2 +-
fs/xfs/xfs_reflink.c      |  2 --
7 files changed, 21 insertions(+), 7 deletions(-)
