Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 604ADC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbiLaA4G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235815AbiLaA4F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:56:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BF9CF3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:56:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9580161D62
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:56:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E82C433D2;
        Sat, 31 Dec 2022 00:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448164;
        bh=/kmJQcs71yex9BZKuS+eMc5GoKJmMmo4Iiltc7aIKKk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Y4OzBMQr+HBmQDdK9bdqnaCKSGkF5RmcLNk2JLpNLboBs4y1TpBhaImJ0Jc2Aln7D
         gIiJUtm749BvDv6IegYptjWcP1NDJQ5BTZVsidJxvJmr+YedQoCIhuaeG7n4sqD+qx
         3IYvj3NzZf8HAmc91Ao+AZV7OFW9WKOaDO6BTcdkO1WXC12GkLl0qLcnNdVyoUEKZc
         wrId6ORd6N83ljR3HXN2rJKYO6U3HEAiBomtqKBmU7dN2zh2tJdDoc/b3xxkXa3ut6
         Dd9CrV4eYR6lz90ZTHh3mYkZkNu6Mm7uzoFUhE/Z5VZekPVNzeQPR45OLgWKpEeacS
         aw3c3AC/gUs8Q==
Subject: [PATCHSET v1.0 0/7] xfs: refactor rt extent unit conversions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:40 -0800
Message-ID: <167243866067.711673.17279545989126573423.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series replaces all the open-coded integer division and
multiplication conversions between rt blocks and rt extents with calls
to static inline helpers.  Having cleaned all that up, the helpers are
augmented to skip the expensive operations in favor of bit shifts and
masking if the rt extent size is a power of two.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rt-unit-conversions

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=refactor-rt-unit-conversions
---
 fs/xfs/libxfs/xfs_bmap.c        |   19 +++-----
 fs/xfs/libxfs/xfs_rtbitmap.c    |    4 +-
 fs/xfs/libxfs/xfs_rtbitmap.h    |   88 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |    2 +
 fs/xfs/libxfs/xfs_swapext.c     |    7 ++-
 fs/xfs/libxfs/xfs_trans_inode.c |    3 +
 fs/xfs/libxfs/xfs_trans_resv.c  |    3 +
 fs/xfs/scrub/inode.c            |    3 +
 fs/xfs/scrub/inode_repair.c     |    3 +
 fs/xfs/scrub/rtbitmap.c         |   18 +++-----
 fs/xfs/scrub/rtsummary.c        |    4 +-
 fs/xfs/xfs_bmap_util.c          |   38 +++++++----------
 fs/xfs/xfs_fsmap.c              |   12 +++--
 fs/xfs/xfs_ioctl.c              |    5 +-
 fs/xfs/xfs_linux.h              |   12 +++++
 fs/xfs/xfs_mount.h              |    2 +
 fs/xfs/xfs_rtalloc.c            |   16 ++++---
 fs/xfs/xfs_super.c              |    3 +
 fs/xfs/xfs_trans.c              |    9 +++-
 fs/xfs/xfs_xchgrange.c          |    4 +-
 20 files changed, 178 insertions(+), 77 deletions(-)

