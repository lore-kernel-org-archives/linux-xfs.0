Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF692C43214
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 931E9610A8
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 07:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236746AbhHEHA6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Aug 2021 03:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229869AbhHEHA5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Aug 2021 03:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7A5260ED6;
        Thu,  5 Aug 2021 07:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628146843;
        bh=/08fWGeAM7cDSpGGRzeMCN/x8l/dAe2ml38NeWoVmyg=;
        h=Subject:From:To:Cc:Date:From;
        b=EkLrjKJS5AK34WuAQbySb1hB+ZXURz8OKSpOjoVX20KZL3BSku1sFeWMEr6QnNj8l
         zCJutELhWsf3Znf+lzcN9hCaCow8LjsIvLF3czj1BfTgLtri+8Ve0+7ZSj7D/YbmXX
         rhDHsh8ktMhmbuMLP3JHOem+x/VcxR0CclGytJQs6581a8ML16nLdyMP01OBlrK6gM
         5D1Bc1LCDh+epSf9KAbYgAUwrORmT/lTkvYSBMS89UhwmvuXk1h1irZxYAWmDzgG0q
         E6UJ9M7iZ4sCJfFzcZAqXBOuH2+EqSBBixhq67+vR3jrMSwbCdrfnSf1BPtPFbofIr
         Goq2Qqx/57nvA==
Subject: [PATCHSET 0/5] xfs: other stuff for 5.15
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Bill O'Donnell <billodo@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Thu, 05 Aug 2021 00:00:43 -0700
Message-ID: <162814684332.2777088.14593133806068529811.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the usual grab bag of miscellaneous things for 5.15: continued
cleanups of the perag iteration code, dropping EXPERIMENTAL warnings,
making log recovery fail louder, dorky whitespace fixes, etc.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=other-stuff-for-5.15
---
 fs/xfs/Makefile                |    3 ++
 fs/xfs/libxfs/xfs_ag.h         |   66 +++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_attr_leaf.c  |    2 +
 fs/xfs/libxfs/xfs_format.h     |    2 +
 fs/xfs/libxfs/xfs_ialloc.c     |    2 +
 fs/xfs/libxfs/xfs_rmap_btree.h |    2 +
 fs/xfs/libxfs/xfs_sb.c         |   17 +++++-----
 fs/xfs/libxfs/xfs_types.c      |    6 +---
 fs/xfs/scrub/agheader.c        |   23 ++++++++++----
 fs/xfs/scrub/agheader_repair.c |    3 --
 fs/xfs/scrub/bmap.c            |   10 ++----
 fs/xfs/scrub/btree.c           |    2 +
 fs/xfs/scrub/common.c          |   48 ++++++++++++-----------------
 fs/xfs/scrub/common.h          |   18 ++++++++++-
 fs/xfs/scrub/fscounters.c      |   43 ++++++++++++--------------
 fs/xfs/scrub/inode.c           |    2 +
 fs/xfs/xfs_bmap_item.c         |    3 ++
 fs/xfs/xfs_extent_busy.c       |   11 +++----
 fs/xfs/xfs_extfree_item.c      |    3 ++
 fs/xfs/xfs_fsmap.c             |   25 +++++----------
 fs/xfs/xfs_fsops.c             |   12 ++-----
 fs/xfs/xfs_health.c            |    9 ++---
 fs/xfs/xfs_icache.c            |   27 +++++-----------
 fs/xfs/xfs_iwalk.c             |   41 ++++++++++---------------
 fs/xfs/xfs_log_recover.c       |   21 +++++--------
 fs/xfs/xfs_refcount_item.c     |    3 ++
 fs/xfs/xfs_reflink.c           |   10 ++----
 fs/xfs/xfs_rmap_item.c         |    3 ++
 fs/xfs/xfs_super.c             |    8 -----
 29 files changed, 207 insertions(+), 218 deletions(-)

