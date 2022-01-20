Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7508C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345142AbiATAVg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345141AbiATAVg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFA4C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:21:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A049E61512
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0F0C004E1;
        Thu, 20 Jan 2022 00:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638095;
        bh=luQK+4MXqH9w/8C9FoEe46jE1TYyVy8+4Jo+ExF0WYc=;
        h=Subject:From:To:Cc:Date:From;
        b=ZyC3NCiMR4DkWhxXdiOP3C5H3i6YXAYYoiBiyObMRx5x70gFkYp3wq7m2NHR7q3O3
         zuEk9MUkRNaJTk8wYwTniF948ohia5UnZIL4RwNTBhsVppRPoOhK3Uw7ZF/3VaLMtn
         cam883DZIB+0P/yJJkt2bkF3pTepdNNvkOtxZQIjI0zRbXZzs94VjYaEZ/A0haeW+G
         4/fYPINR35lCy2J+8A+WTy6PXPA5YwWI8c3bbmDZk+MP51qmIX5uynSlwM0IO1MXmM
         hGhOHp3+A8a6nJ6acSLrGjT9w5pmvMZ/9CCzEyY8WR5U1PkhpWB+blDQNSAluWEmPJ
         jS5/hPWzUK3uQ==
Subject: [PATCHSET 00/17] xfsprogs: various 5.15 fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Date:   Wed, 19 Jan 2022 16:21:34 -0800
Message-ID: <164263809453.863810.8908193461297738491.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are a number of tooling changes for xfsprogs 5.15 that are not a
direct consequence of the 5.15 kernel.  This is a bit of a grab bag,
folks; bug fixes include:

 - editline should use emacs mode instead of vim mode
 - fix some UAF bugs in libxfs
 - stop duplicating kernel headers for GETFSMAP
 - write the secondary sbs after upgrading v5 features
 - fix memory corruption bugs when parsing mkfs config files
 - whitespace and formatting fixes

Straight-up enhancements include:

 - adding mkfs config files
 - enabling the inobtcount and bigtime features by default
 - having scrub report whether or not it supports unicode name checks

Enjoy!

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.15-fixes
---
 db/faddr.c               |    6 ++
 db/input.c               |    1 
 include/builddefs.in     |    2 +
 include/linux.h          |  105 -----------------------------------------
 io/crc32cselftest.c      |    2 -
 io/fsmap.c               |    1 
 io/io.h                  |    5 --
 libfrog/Makefile         |    1 
 libfrog/crc32.c          |    2 -
 libfrog/crc32cselftest.h |   21 ++++++--
 libfrog/fsmap.h          |  117 ++++++++++++++++++++++++++++++++++++++++++++++
 libxcmd/input.c          |    1 
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/rdwr.c            |   23 +++++----
 libxfs/trans.c           |   19 +++++++
 man/man8/Makefile        |    7 +++
 man/man8/mkfs.xfs.8.in   |    8 +++
 man/man8/xfs_repair.8    |    4 ++
 mkfs/Makefile            |   11 ++++
 mkfs/dax_x86_64.conf     |   19 +++++++
 mkfs/lts_4.19.conf       |   13 +++++
 mkfs/lts_5.10.conf       |   13 +++++
 mkfs/lts_5.15.conf       |   13 +++++
 mkfs/lts_5.4.conf        |   13 +++++
 mkfs/xfs_mkfs.c          |   27 +++++++++--
 repair/dir2.c            |    2 -
 repair/globals.c         |    1 
 repair/globals.h         |    1 
 repair/init.c            |    5 ++
 repair/phase2.c          |   38 +++++++--------
 repair/quotacheck.c      |    9 ++--
 repair/xfs_repair.c      |   15 ++++++
 scrub/phase6.c           |    1 
 scrub/phase7.c           |    1 
 scrub/spacemap.c         |    1 
 scrub/xfs_scrub.c        |   12 ++++-
 spaceman/freesp.c        |    1 
 spaceman/space.h         |    4 --
 tools/libxfs-apply       |   42 +++++++----------
 39 files changed, 379 insertions(+), 190 deletions(-)
 create mode 100644 libfrog/fsmap.h
 rename man/man8/{mkfs.xfs.8 => mkfs.xfs.8.in} (99%)
 create mode 100644 mkfs/dax_x86_64.conf
 create mode 100644 mkfs/lts_4.19.conf
 create mode 100644 mkfs/lts_5.10.conf
 create mode 100644 mkfs/lts_5.15.conf
 create mode 100644 mkfs/lts_5.4.conf

