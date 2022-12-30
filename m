Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C95B5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbiLaDUz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiLaDUy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:20:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C18B6383
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:20:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB3C061D5E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227A1C433D2;
        Sat, 31 Dec 2022 03:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456853;
        bh=Nk3hMpyaUOzgKF6BgQzK6A/LePH8jsCGrm+Iw3m68/Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XhB+YA7s87CQ/SiK90oP3Bz4XcSMoGwJhIPyrBdfRlLx1EdOImgoGEJcA16nLdDT4
         PPg/m6KYRSGO1ofMadrLQZhqvElDI1IQTm+nqlnVDMVNPiwYm4NeqRLSUWrSXQucR4
         Y7bgZkuwgSshQePs4JUgaVI/7pH7y71HUnkY536jXgSUX9sikiLg10cpg8hzgkIFzD
         YV+op/3wqnleSZOosdekTe4WRQeV02bPx1yVXY00d1NbqFBkyxebszFfW4INAQBQ1h
         Cr582s0TOVieEauIqTmBA6Q9eiwfbqOJ+qDj/uuCqq/QqIAd3usL/uFyoYEd4PF9hz
         I6FcX6iGrKDxw==
Subject: [PATCHSET 0/2] xfs: defragment free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:30 -0800
Message-ID: <167243877005.727784.16278955284134985550.stgit@magnolia>
In-Reply-To: <Y69Uw6W5aclS115x@magnolia>
References: <Y69Uw6W5aclS115x@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These patches contain experimental code to enable userspace to defragment
the free space in a filesystem.  Two purposes are imagined for this
functionality: clearing space at the end of a filesystem before
shrinking it, and clearing free space in anticipation of making a large
allocation.

The first patch adds a new fallocate mode that allows userspace to
allocate free space from the filesystem into a file.  The goal here is
to allow the filesystem shrink process to prevent allocation from a
certain part of the filesystem while a free space defragmenter evacuates
all the files from the doomed part of the filesystem.

The second patch amends the online repair system to allow the sysadmin
to forcibly rebuild metadata structures, even if they're not corrupt.
Without adding an ioctl to move metadata btree blocks, this is the only
way to dislodge metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defrag-freespace

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=defrag-freespace
---
 fs/open.c                   |    5 +
 fs/xfs/libxfs/xfs_alloc.c   |   88 ++++++++++++
 fs/xfs/libxfs/xfs_alloc.h   |    4 +
 fs/xfs/libxfs/xfs_bmap.c    |  150 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h    |    3 
 fs/xfs/xfs_bmap_util.c      |  315 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_bmap_util.h      |    7 +
 fs/xfs/xfs_file.c           |   39 +++++
 fs/xfs/xfs_rtalloc.c        |   49 +++++++
 fs/xfs/xfs_rtalloc.h        |   12 ++
 fs/xfs/xfs_trace.h          |   72 +++++++++-
 include/linux/falloc.h      |    3 
 include/uapi/linux/falloc.h |    8 +
 13 files changed, 742 insertions(+), 13 deletions(-)

