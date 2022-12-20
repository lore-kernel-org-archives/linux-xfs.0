Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4D0C10F1E
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 16:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiLTQBY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 11:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLTQBV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 11:01:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7141F389F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 08:01:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D2F3B81699
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 16:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3D1C433D2;
        Tue, 20 Dec 2022 16:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671552076;
        bh=WzAsbg85ckexzuV6s2NqZz44svOJI8g2CO65zJOdM+k=;
        h=Date:From:To:Cc:Subject:From;
        b=JvGsNN6p3hI5fH9HCr2x7d8jjl0hMs9T5lePF5yLEcc9trNXwgUfE4gByUrCcQDI5
         ZJ7FUgprf/yGm7wdOwsGn/e1qcDO2dm39RLWTWfL2ThcWD+AcbHJ3h0tIrw0WM5Bl3
         S35PMFvSS5racMD0CvJUWwpUs/sbApCd4EL0znxEnm0IA7xlWuvidGHWiHd0tYugKl
         Yzze9cXYdVe2lHritvHqSdQBjRh9keVmKErUVFCTc2J+eJB6g322K7/pywjFPU8lRq
         3rlJetJF4V6cWrRraCCLa/hSOW9RuypXq3WYGjGitNiNECQ4a8ihYL/N7/8+bk5xWN
         97JL3Cp+dm+9g==
Date:   Tue, 20 Dec 2022 08:01:15 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
        ruansy.fnst@fujitsu.com
Subject: [GIT PULL] fsdax,xfs: fix data corruption problems
Message-ID: <167155161011.40255.9717951395121213068.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with changes for xfs for 6.2-rc1.  As promised,
this second pull request contains data corruption fixes for fsdax
filesystems that support mapping pmem storage to multiple files.  (IOWs,
XFS, which is the only fs that uses it.)

I anticipate a third pull request in a couple of days to start the
stabilization phase of 6.2, though seeing as it's the last workweek of
the year I could just as well punt to January.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 52f31ed228212ba572c44e15e818a3a5c74122c0:

xfs: dquot shrinker doesn't check for XFS_DQFLAG_FREEING (2022-12-08 08:29:58 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.2-merge-9

for you to fetch changes up to 4883f57a2d861a68588aefbf592f86d1e059f1ec:

xfs: remove restrictions for fsdax and reflink (2022-12-08 08:29:59 -0800)

----------------------------------------------------------------
New XFS/fsdax code for 6.2, part 2:

- Fixes for some serious data corruption problems that were introduced
in the 6.0 series allowing for files to share pmem.  These include:

- Invalidate mapped pages whenever we write to a shared pmem page so
that all the involved processes take a page fault so that they can
actually set up the COW
- Fix missing zeroing around a file range that is about to be written
and is backed by shared pmem
- Set up fsdax mappings to be shared any time we notice shared
storage, even on a read operation
- Fix the dax dedupe comparison function misusing iterators and doing no
comparison at all
- Fix missing implementation of the fallocate funshare command which led
to callers using the pagecache implementation on fsdax(!)
- Fix some broken inode reflink/dax state handling in XFS

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Shiyang Ruan (8):
fsdax: introduce page->share for fsdax in reflink mode
fsdax: invalidate pages when CoW
fsdax: zero the edges if source is HOLE or UNWRITTEN
fsdax,xfs: set the shared flag when file extent is shared
fsdax: dedupe: iter two files at the same time
xfs: use dax ops for zero and truncate in fsdax mode
fsdax,xfs: port unshare to fsdax
xfs: remove restrictions for fsdax and reflink

fs/dax.c                   | 221 +++++++++++++++++++++++++++++++--------------
fs/xfs/xfs_ioctl.c         |   4 -
fs/xfs/xfs_iomap.c         |   6 +-
fs/xfs/xfs_iops.c          |   4 -
fs/xfs/xfs_reflink.c       |   8 +-
include/linux/dax.h        |   2 +
include/linux/mm_types.h   |   5 +-
include/linux/page-flags.h |   2 +-
8 files changed, 167 insertions(+), 85 deletions(-)
