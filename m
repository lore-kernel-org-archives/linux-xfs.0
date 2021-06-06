Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A076C47096
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47FC76136D
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbhFFR4P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 13:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhFFR4O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 13:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9B36139A;
        Sun,  6 Jun 2021 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623002064;
        bh=jEd2HSnJPcfffPZqHeik0sEYqPbyZnRdn2UD82MvEPE=;
        h=Subject:From:To:Cc:Date:From;
        b=q5+NO0tfJNAEvn0B0BTLKNyM7AI/APouTSofhWDMu3LPOAn2enVj488znrFoqo6e9
         cmkCi8ICWeDo/JEroY/AVLTTyWjRTObMaT1zRBtwG46cTOC2nBH+R5BOzYhfL16Qzw
         yWxo47S0x5XJviDxNitmJ1tVj6WVGPKU2lSqv7cwYdKjRUTZ7EcFQtl/hcD8Ux4gY6
         3lhgf7bfx6VPWy85LxFMnLHtRuQWrUDxscsGejld6Ndicw9Q1vaG8QGHVqwYDHz32+
         kqAsbnym7ZJraKOP8DhJbcBLtgiyRsiJj4bQqbkvaEhnSWNazs0KxnDNlziRajidcv
         ZU1riHGW/IXEQ==
Subject: [PATCHSET v2 0/2] xfs: rename struct xfs_eofblocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 06 Jun 2021 10:54:24 -0700
Message-ID: <162300206433.1202657.5753685964265403056.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In the old days, struct xfs_eofblocks was an optional parameter to the
speculative post-EOF allocation garbage collector to narrow the scope of
a scan to files fitting specific criteria.  Nowadays it is used for all
other kinds of inode cache walks (reclaim, quotaoff, inactivation), so
the name is no longer fitting.  Change the flag namespace and rename the
structure to something more appropriate for what it does.

v2: separate the inode cache walk flag namespace from eofblocks

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rename-eofblocks-5.14
---
 fs/xfs/xfs_file.c   |    8 +-
 fs/xfs/xfs_icache.c |  178 ++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h |   31 ++++++---
 fs/xfs/xfs_ioctl.c  |   41 +++++++-----
 fs/xfs/xfs_trace.h  |   36 +++++-----
 5 files changed, 160 insertions(+), 134 deletions(-)

