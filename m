Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80D5EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbiL3XF7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiL3XF6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:05:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956402DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:05:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E77AB81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C083C433EF;
        Fri, 30 Dec 2022 23:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441555;
        bh=GfDQRtoxPaQRKfYozjgM4ZoFUzX9fjnj69QgwArVQAU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a0qZw+BHA2z1rYcnnmqXoT/p5HuX/ab4qFgnMnQKwg3ZIsvzGpDGXRt1m+pmMEb+t
         vPYitnVquu6Ty2IxFZ9cQ8cuPkWyj0lFrp252+05lIp1EcunoU0iKhobTzRJCs26Tj
         SC+mbRbfxbbP4XELZnZYeh10RC9HM/4npeVtQXrKUmHnobTez1cDgE0SYy2QErecBe
         zFyZatyACNmtam1z+FM/+slolGkbj1YZJBR9FnuKkiT8GHDo5nlLKWZIhGhYQIx+Gw
         lhnOr/3+VEpi5ZhJDUJ4d5rnYYSyTH8tLqQ0FFcmwmXQUDgmJTVjIMWgJBq/0hLfYC
         RftSjhpJ3Ny8Q==
Subject: [PATCHSET v24.0 0/3] xfs: clean up symbolic link code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:51 -0800
Message-ID: <167243843134.699346.594115796077510288.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series cleans up a few bits of the symbolic link code as needed for
future projects.  Online repair requires the ability to commit fixed
fork-based filesystem metadata such as directories, xattrs, and symbolic
links atomically, so we need to rearrange the symlink code before we
land the atomic extent swapping.

Accomplish this by moving the remote symlink target block code and
declarations to xfs_symlink_remote.[ch].

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=symlink-cleanups

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=symlink-cleanups
---
 fs/xfs/libxfs/xfs_bmap.c           |    1 
 fs/xfs/libxfs/xfs_inode_fork.c     |    1 
 fs/xfs/libxfs/xfs_shared.h         |   14 ---
 fs/xfs/libxfs/xfs_symlink_remote.c |  155 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_symlink_remote.h |   27 ++++++
 fs/xfs/scrub/inode_repair.c        |    1 
 fs/xfs/scrub/symlink.c             |    3 -
 fs/xfs/xfs_symlink.c               |  144 +--------------------------------
 fs/xfs/xfs_symlink.h               |    1 
 9 files changed, 192 insertions(+), 155 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_symlink_remote.h

