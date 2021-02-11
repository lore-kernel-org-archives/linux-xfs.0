Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02838C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 22:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B19C064E57
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 22:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhBKW7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 17:59:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhBKW7m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 17:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0471564E3E;
        Thu, 11 Feb 2021 22:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084342;
        bh=1ApqKkY5oLx8DidviOqfPqz2zuozGHD3fJ5shfXMtg4=;
        h=Subject:From:To:Cc:Date:From;
        b=ApI/87ijvf3tAeOxErjWVJmjB42SOwns47rM8+bYiFXNlBVmbARP3dfKA+MhhHYE3
         s4H3DA+KnIn/ZJqFNYFOBEwFNiGk2fI2KtQod4SnFC1l8Kz6cFOr46YREXG2UL2CCq
         39L+w9ZVAAj5TJA5ayeeH5j4zDBLaTs7N+xE+AW8qoC+k02kq2fOHzVEp/+Qok60r2
         CF/yOa0RCQb/PLsrqI5/pSxGxKU0vry0uOI+EhV6Fo88o+hCiA7ouAow5JNEqSCn0k
         MHo74PpSW+T4Mm1d3f3DarBaN6ZS94nYmBYgaHmowUep/dKDA9Lmh7pfOrOC0A8fQz
         ZPEHGwIxRRX/g==
Subject: [PATCHSET v5 00/11] xfs: add the ability to flag a fs for repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:01 -0800
Message-ID: <161308434132.3850286.13801623440532587184.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series adds a new incompat feature flag so that we can force a
sysadmin to run xfs_repair on a filesystem before mounting.  This will
be used in conjunction with v5 feature upgrades.

v2: tweak the "can't upgrade" behavior and repair messages
v3: improve documentation, define error codes for the upgrade process, and
    only force repair if NEEDSREPAIR is set
v4: move all the upgrader code to xfs_repair per Eric suggestion
v5: various fixes suggested by reviewers, and document deprecated V4 options

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=needsrepair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=needsrepair

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=needsrepair
---
 db/check.c           |    5 ++++
 db/sb.c              |   13 +++++++++
 db/xfs_admin.sh      |   15 ++++++-----
 include/xfs_mount.h  |    1 +
 libxfs/init.c        |   20 +++++++++-----
 man/man8/mkfs.xfs.8  |   16 +++++++++++
 man/man8/xfs_admin.8 |   40 +++++++++++++++++++++++++++++
 repair/agheader.c    |   21 +++++++++++++++
 repair/globals.c     |    3 ++
 repair/globals.h     |    4 +++
 repair/phase2.c      |   67 ++++++++++++++++++++++++++++++++++++++++++++++++
 repair/xfs_repair.c  |   70 ++++++++++++++++++++++++++++++++++++++++++++------
 12 files changed, 253 insertions(+), 22 deletions(-)

