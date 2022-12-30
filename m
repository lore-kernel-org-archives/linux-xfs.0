Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7670FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:03:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiL3XDF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiL3XDE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:03:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4761A07F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:03:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7695061C16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA2EC433EF;
        Fri, 30 Dec 2022 23:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441382;
        bh=pE5WsYpuURDW9BJoa1EmYGhFGoW899TzjkYqBLuIxAQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YkB8Y1a6CMnLt8JrDqQfl9pil1E9m0NJ1t0A9HdSn8UohIFoVJdNdfpFwU0bU+IEa
         l6SUllv1WMp27MgKjT4ua0ieYwo8ZTk9D2Tcll2qH7opHo2RCizW9jTQCc+WWFifb+
         9gWCgptWT6U3P1POeG3zrfE3JRuZMSCwa5Jpk580NroFtiPaoS8mgMmYfyzSOeiAOT
         rugOcRzTy9O3JocLSa2smRc38DOqppmXE5Xv9QgbyGAOpdnwFJ28oOkB0OWb3ybs0w
         iQj88pKpN0RBhs9akSOZZSBTuMyRezf45mwq3qXvT4vzloRl7I3JdlobzTUmNYjKHp
         9Yomg8Oun77Rw==
Subject: [PATCHSET v24.0 0/5] xfs: online repair of file link counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:10 -0800
Message-ID: <167243839062.695835.16105316950703126803.stgit@magnolia>
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

Now that we've created the infrastructure to perform live scans of every
file in the filesystem and the necessary hook infrastructure to observe
live updates, use it to scan directories to compute the correct link
counts for files in the filesystem, and reset those link counts.

This patchset creates a tailored readdir implementation for scrub
because the regular version has to cycle ILOCKs to copy information to
userspace.  We can't cycle the ILOCK during the nlink scan and we don't
need all the other VFS support code (maintaining a readdir cursor and
translating XFS structures to VFS structures and back) so it was easier
to duplicate the code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-nlinks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-nlinks

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-nlinks
---
 fs/xfs/Makefile               |    5 
 fs/xfs/libxfs/xfs_da_format.h |   11 
 fs/xfs/libxfs/xfs_dir2.c      |    6 
 fs/xfs/libxfs/xfs_dir2.h      |    1 
 fs/xfs/libxfs/xfs_fs.h        |    4 
 fs/xfs/libxfs/xfs_health.h    |    4 
 fs/xfs/scrub/common.c         |    3 
 fs/xfs/scrub/common.h         |    1 
 fs/xfs/scrub/dir.c            |  173 ++------
 fs/xfs/scrub/health.c         |    1 
 fs/xfs/scrub/nlinks.c         |  929 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.h         |   99 ++++
 fs/xfs/scrub/nlinks_repair.c  |  226 ++++++++++
 fs/xfs/scrub/parent.c         |   90 +---
 fs/xfs/scrub/readdir.c        |  375 +++++++++++++++++
 fs/xfs/scrub/readdir.h        |   19 +
 fs/xfs/scrub/repair.h         |    2 
 fs/xfs/scrub/scrub.c          |    9 
 fs/xfs/scrub/scrub.h          |    5 
 fs/xfs/scrub/trace.c          |    2 
 fs/xfs/scrub/trace.h          |  193 ++++++++-
 fs/xfs/xfs_health.c           |    1 
 fs/xfs/xfs_inode.c            |  210 +++++++++
 fs/xfs/xfs_inode.h            |   35 ++
 fs/xfs/xfs_mount.h            |    2 
 fs/xfs/xfs_super.c            |    2 
 fs/xfs/xfs_symlink.c          |    1 
 27 files changed, 2219 insertions(+), 190 deletions(-)
 create mode 100644 fs/xfs/scrub/nlinks.c
 create mode 100644 fs/xfs/scrub/nlinks.h
 create mode 100644 fs/xfs/scrub/nlinks_repair.c
 create mode 100644 fs/xfs/scrub/readdir.c
 create mode 100644 fs/xfs/scrub/readdir.h

