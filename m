Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7422EC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235468AbiL3XBt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiL3XBs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:01:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDD815FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:01:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11418B81D84
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB5DC433EF;
        Fri, 30 Dec 2022 23:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441304;
        bh=YhTSVtnbklavs/diNIEsSuabZvuRWZinaFaYzMdd4Vw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NOG4jH30LoDBizyTGQXKWs0JZW5EuXrXhto6dTAoDq1q7+zmiEpK0g+FiVSSJOrl4
         uJWCyHY2XRr84FveHuT9Eqe2ZP66foI2qNAB+C7Xi5CPV9tBCxhl/LpyE8QJRVs2+I
         nt5Vvstsk6ZU4BKrFwTF0r3f4p9cvxte1FBqln7QmrsrhuoJDeq+4eQa45vaiWHhwH
         XDZqGK6OtiqspTd7z3eINqKSaQUx9VcIdDth29Uby80I4SbHFlpYnWIt7CkatYJvrU
         4/inG5UIbW1t4xYTnWKadaf4CTGIss2FZ4FWDi/kvoXq6e/jA5G6rpU+GsLjbOQfQu
         zm8AG8dRWnATg==
Subject: [PATCHSET v24.0 0/6] xfs: online repair of inodes and forks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:52 -0800
Message-ID: <167243837231.694402.7473901938296662729.stgit@magnolia>
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

In this series, online repair gains the ability to repair inode records.
To do this, we must repair the ondisk inode and fork information enough
to pass the iget verifiers and hence make the inode igettable again.
Once that's done, we can perform higher level repairs on the incore
inode.  The fstests counterpart of this patchset implements stress
testing of repair.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inodes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-inodes
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_attr_leaf.c      |   32 -
 fs/xfs/libxfs/xfs_attr_leaf.h      |    2 
 fs/xfs/libxfs/xfs_bmap.c           |   22 -
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h      |    2 
 fs/xfs/libxfs/xfs_dir2_sf.c        |   29 -
 fs/xfs/libxfs/xfs_format.h         |    3 
 fs/xfs/libxfs/xfs_shared.h         |    1 
 fs/xfs/libxfs/xfs_symlink_remote.c |   21 
 fs/xfs/scrub/alloc.c               |    2 
 fs/xfs/scrub/bmap.c                |    4 
 fs/xfs/scrub/common.c              |   26 +
 fs/xfs/scrub/common.h              |    8 
 fs/xfs/scrub/dir.c                 |   21 
 fs/xfs/scrub/inode.c               |   14 
 fs/xfs/scrub/inode_repair.c        | 1565 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c              |   11 
 fs/xfs/scrub/repair.c              |   47 +
 fs/xfs/scrub/repair.h              |   28 +
 fs/xfs/scrub/rtbitmap.c            |    4 
 fs/xfs/scrub/rtsummary.c           |    4 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |  174 ++++
 24 files changed, 1982 insertions(+), 43 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c

