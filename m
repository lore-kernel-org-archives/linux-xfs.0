Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AD0C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiL3XDV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XDU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:03:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E59C15FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:03:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29AAB61C16
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC01C433D2;
        Fri, 30 Dec 2022 23:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441398;
        bh=A0/U1KKkaHq6G1Jo3pIEUhuqBI81p1XsUrL6q6bKCx8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sMibii5qo8JxwciKVH1fs4BnWINVCK4SQxg6aeDsELeobA1Z4okEmBrwCekyBsatJ
         b6QEz9XOF34t6PT9Z9neYp3MKJI/bPD+wuPvW0mquE/V9aPzwMKstFKyZPv3Xuqe/a
         UFtbBv62xnBPzXysF0k3oEVSMS/WsJirrY8SldmIsYFTHOHlACmAfJLpE9CwrUt1Gs
         cUfotZrRE5aASTkBFNzRhOdx1VrXprBgBGzsS9w7LDhzEwPgG6ND1YPJQskOKerL6U
         PbICmySj5hYhDXgAJ/phftoO//sjv2KrtdsFDyS4Pox8lduE73/t8jxFY+mHwO+Sy/
         lhGM8FoSReZvQ==
Subject: [PATCHSET v24.0 00/11] xfs: report corruption to the health trackers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:14 -0800
Message-ID: <167243839445.695999.12861421643354894719.stgit@magnolia>
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

Any time that the runtime code thinks it has found corrupt metadata, it
should tell the health tracking subsystem that the corresponding part of
the filesystem is sick.  These reports come primarily from two places --
code that is reading a buffer that fails validation, and higher level
pieces that observe a conflict involving multiple buffers.  This
patchset uses automated scanning to update all such callsites with a
mark_sick call.

Doing this enables the health system to record problem observed at
runtime, which (for now) can prompt the sysadmin to run xfs_scrub, and
(later) may enable more targetted fixing of the filesystem.

Note: Earlier reviewers of this patchset suggested that the verifier
functions themselves should be responsible for calling _mark_sick.  In a
higher level language this would be easily accomplished with lambda
functions and closures.  For the kernel, however, we'd have to create
the necessary closures by hand, pass them to the buf_read calls, and
then implement necessary state tracking to detach the xfs_buf from the
closure at the necessary time.  This is far too much work and complexity
and will not be pursued further.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=corruption-health-reports

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=corruption-health-reports

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=corruption-health-reports
---
 fs/xfs/libxfs/xfs_ag.c          |    5 +
 fs/xfs/libxfs/xfs_alloc.c       |  105 ++++++++++++++++++++----
 fs/xfs/libxfs/xfs_attr_leaf.c   |    4 +
 fs/xfs/libxfs/xfs_attr_remote.c |   35 +++++---
 fs/xfs/libxfs/xfs_bmap.c        |  123 +++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.c       |   39 ++++++++-
 fs/xfs/libxfs/xfs_da_btree.c    |   37 +++++++-
 fs/xfs/libxfs/xfs_dir2.c        |    5 +
 fs/xfs/libxfs/xfs_dir2_block.c  |    2 
 fs/xfs/libxfs/xfs_dir2_data.c   |    3 +
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    3 +
 fs/xfs/libxfs/xfs_dir2_node.c   |    7 ++
 fs/xfs/libxfs/xfs_health.h      |   35 +++++++-
 fs/xfs/libxfs/xfs_ialloc.c      |   57 +++++++++++--
 fs/xfs/libxfs/xfs_inode_buf.c   |   12 ++-
 fs/xfs/libxfs/xfs_inode_fork.c  |    8 ++
 fs/xfs/libxfs/xfs_refcount.c    |   43 +++++++++-
 fs/xfs/libxfs/xfs_rmap.c        |   83 ++++++++++++++++++-
 fs/xfs/libxfs/xfs_rtbitmap.c    |    9 ++
 fs/xfs/libxfs/xfs_sb.c          |    2 
 fs/xfs/scrub/health.c           |   20 +++--
 fs/xfs/scrub/refcount_repair.c  |    9 ++
 fs/xfs/xfs_attr_inactive.c      |    4 +
 fs/xfs/xfs_attr_list.c          |   18 +++-
 fs/xfs/xfs_dir2_readdir.c       |    7 +-
 fs/xfs/xfs_discard.c            |    2 
 fs/xfs/xfs_dquot.c              |   30 +++++++
 fs/xfs/xfs_health.c             |  172 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.c             |    9 ++
 fs/xfs/xfs_inode.c              |   17 +++-
 fs/xfs/xfs_iomap.c              |   15 +++
 fs/xfs/xfs_iwalk.c              |    5 +
 fs/xfs/xfs_mount.c              |    5 +
 fs/xfs/xfs_qm.c                 |    8 +-
 fs/xfs/xfs_reflink.c            |    6 +
 fs/xfs/xfs_rtalloc.c            |    6 +
 fs/xfs/xfs_symlink.c            |   12 ++-
 37 files changed, 860 insertions(+), 102 deletions(-)

