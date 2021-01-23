Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AABC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C502B230FC
	for <linux-xfs@archiver.kernel.org>; Sat, 23 Jan 2021 18:52:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbhAWSw5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 Jan 2021 13:52:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbhAWSwz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:52:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ADDE22EBE;
        Sat, 23 Jan 2021 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611427918;
        bh=JsV6tTw+mnZayqA04vzLlLWRLDv6/fF6RnAKn6tlNVc=;
        h=Subject:From:To:Cc:Date:From;
        b=i2e/Px4C+KeDQcdCOb5k0FLqXB1gsDp+TsAuT6dbSSrM/izsKnSsZKuVTchvoHasS
         Wxf2M7tQETENgSVbO7XqUz6ezPmHbxDWnmjz5ltoy6eJ0bxbcB0ajpGhcGff/R/aZp
         G42htgYG6yrOXn39B158MN+JHLHSFNiqljOqJjxRMdr3p/F+TQZzlLVkyovWn7sJfy
         5xiJmuvh90M321ZH6B83VgslQnAUCcA2ONyzcICzVscKtNWtaIqGeVv1IZPXmdNwEx
         LCmqd0U4OKcgtnos03yCn8cTEPREmj7GfP8diM2X7Nf1tCcTUgDu/tu5s0BmKKRjSf
         GWmBCib5oxRGw==
Subject: [PATCHSET v4 00/11] xfs: try harder to reclaim space when we run out
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:51:59 -0800
Message-ID: <161142791950.2171939.3320927557987463636.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Historically, when users ran out of space or quota when trying to write
to the filesystem, XFS didn't try very hard to reclaim space that it
might have speculatively allocated for the purpose of speeding up
front-end filesystem operations (appending writes, cow staging).  The
upcoming deferred inactivation series will greatly increase the amount
of allocated space that isn't actively being used to store user data.

Therefore, try to reduce the circumstances where we return EDQUOT or
ENOSPC to userspace by teaching the write paths to try to clear space
and retry the operation one time before giving up.

v2: clean up and rebase against 5.11.
v3: restructure the retry loops per dchinner suggestion
v4: simplify the calling convention of xfs_trans_reserve_quota_nblks

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reclaim-space-harder-5.12
---
 fs/xfs/libxfs/xfs_attr.c |    8 +-
 fs/xfs/libxfs/xfs_bmap.c |    8 +-
 fs/xfs/xfs_bmap_util.c   |   17 +++-
 fs/xfs/xfs_file.c        |   21 ++---
 fs/xfs/xfs_icache.c      |  185 ++++++++++++++++++++++++++++++----------------
 fs/xfs/xfs_icache.h      |    7 +-
 fs/xfs/xfs_inode.c       |   17 +++-
 fs/xfs/xfs_ioctl.c       |   14 +++
 fs/xfs/xfs_iomap.c       |   19 ++++-
 fs/xfs/xfs_iops.c        |   13 ++-
 fs/xfs/xfs_qm.c          |   34 ++++++--
 fs/xfs/xfs_quota.h       |   41 ++++++----
 fs/xfs/xfs_reflink.c     |   16 +++-
 fs/xfs/xfs_symlink.c     |    8 +-
 fs/xfs/xfs_trace.c       |    1 
 fs/xfs/xfs_trace.h       |   40 ++++++++++
 fs/xfs/xfs_trans.c       |   20 +++++
 fs/xfs/xfs_trans_dquot.c |  109 +++++++++++++++++++++++----
 18 files changed, 430 insertions(+), 148 deletions(-)

