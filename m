Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6836C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A65B523159
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbhAWSwP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:52:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbhAWSwO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:52:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B2BD224DE;
        Sat, 23 Jan 2021 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427893;
        bh=qIQdHADMvOygeMWtA66i0gCmTQ+uYQ4mVuBIx17LJpc=;
        h=Subject:From:To:Cc:Date:From;
        b=mFLUxYhuHLjJn34btgwCyGr1r/Sp2KbalSGtjjZntdA32FMokhjS4y+kfJUoTOPBd
         CvixzPeR4DtKY4CS0PQTz7jaku3aooz9SYXdbeTGWv7SRRH/7Oas1ESv9RhXstO2SO
         uqIBfiV4U/WEZE4gEEuex3BN0QiwprOq4uBNiW+1kRbY6FxsoZT/ANXWa4eBEZnqmQ
         7DO3CbXXmR+WGVbX6C/3EqyAeCWC8lIXdBpUuq1uVLN4emeCamJQvco3VQb8j0W63b
         fBrT8S8vpVszX8gcKUOEfqhXZWPOf3BXJF/cf2GlZEvLvMai8Rt4pkggAy4dPmx+lT
         tlTKKfyPaXB5A==
Subject: [PATCHSET v2 0/4] xfs: minor cleanups of the quota functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:51:35 -0800
Message-ID: <161142789504.2170981.1372317837643770452.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series reworks some of the internal quota APIs and cleans up some
of the function calls so that we have a clean(er) place to start the
space reclamation patchset.  There should be no behavioral changes in
this series.

v2: rework the xfs_quota_reserve_blkres calling conventions per hch

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=quota-function-cleanups-5.12
---
 fs/xfs/libxfs/xfs_bmap.c |   13 ++++++-------
 fs/xfs/xfs_bmap_util.c   |    4 ++--
 fs/xfs/xfs_inode.c       |    8 ++++----
 fs/xfs/xfs_quota.h       |   41 ++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_reflink.c     |    6 +++---
 fs/xfs/xfs_symlink.c     |    4 ++--
 fs/xfs/xfs_trans_dquot.c |   21 +++++++++++++++++++++
 7 files changed, 74 insertions(+), 23 deletions(-)

