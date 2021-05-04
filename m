Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D19C433ED
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 16:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39148613BC
	for <linux-xfs@archiver.kernel.org>; Tue,  4 May 2021 16:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhEDQ3g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 May 2021 12:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231694AbhEDQ3Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 May 2021 12:29:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F53561153
        for <linux-xfs@vger.kernel.org>; Tue,  4 May 2021 16:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620145710;
        bh=VJGAubJEXX4VgK97p4K0FGe24Zf849TY/NY9koMoLWs=;
        h=Date:From:To:Subject:From;
        b=gYthPtdO40cw0bdz+trj7IJCLYkPqRmLs/FT7tVGUU175F05olL/c/yaz7MhYJ4Cn
         6PU/kFkGKmhfn1EVqbhcBD48VGPzu9JjYxslWJUhc5BZFOV2755j+rCtkXt1Wwda6K
         1bu2QXY/bWkf97rd/khF83wLk7Qpw2mvOsAyhZBYtR7NdLz0CRDwdOEYqGwisdXVnV
         pT2+oaPNk2gyN4mPVPtqnb/macbeBLjeDmKM2Uy+2IeEfrScu9R/2JnSAVSTZqE4o+
         BN2YPX3prJGdg2NgYeq+SnfZ89NF/olX92wHQG0zJvUl5sfloRfR3DX9qyARsv2XlD
         AqIIky1IizUng==
Date:   Tue, 4 May 2021 09:28:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 8e9800f9f2b8
Message-ID: <20210504162829.GB8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  This is the last push of this merge window; I decided
to add one more fix to prevent the log from covering itself when the
data device is readonly but the log device itself is not.

The new head of the for-next branch is commit:

8e9800f9f2b8 xfs: don't allow log writes if the data device is readonly

New Commits:

Brian Foster (3):
      [2675ad3890db] xfs: unconditionally read all AGFs on mounts with perag reservation
      [16eaab839a92] xfs: introduce in-core global counter of allocbt blocks
      [fd43cf600cf6] xfs: set aside allocation btree blocks from block reservation

Christoph Hellwig (2):
      [6fc277c7c935] xfs: rename xfs_ictimestamp_t
      [732de7dbdbd3] xfs: rename struct xfs_legacy_ictimestamp

Darrick J. Wong (5):
      [1aec7c3d0567] xfs: remove obsolete AGF counter debugging
      [e6c01077ec2d] xfs: don't check agf_btreeblks on pre-lazysbcount filesystems
      [e147a756ab26] xfs: count free space btree blocks when scrubbing pre-lazysbcount fses
      [d4f74e162d23] xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range
      [8e9800f9f2b8] xfs: don't allow log writes if the data device is readonly

Dave Chinner (1):
      [6543990a168a] xfs: update superblock counters correctly for !lazysbcount


Code Diffstat:

 fs/xfs/libxfs/xfs_ag_resv.c     | 34 +++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_alloc.c       | 17 ++++++++++++++---
 fs/xfs/libxfs/xfs_alloc_btree.c |  4 ++--
 fs/xfs/libxfs/xfs_log_format.h  | 12 ++++++------
 fs/xfs/libxfs/xfs_rmap_btree.c  |  2 --
 fs/xfs/libxfs/xfs_sb.c          | 16 +++++++++++++---
 fs/xfs/scrub/agheader.c         |  7 ++++++-
 fs/xfs/scrub/fscounters.c       | 40 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_fsops.c              |  2 --
 fs/xfs/xfs_inode_item.c         |  8 ++++----
 fs/xfs/xfs_inode_item_recover.c |  6 +++---
 fs/xfs/xfs_log.c                | 10 ++++++----
 fs/xfs/xfs_mount.c              | 15 ++++++++++++++-
 fs/xfs/xfs_mount.h              |  6 ++++++
 fs/xfs/xfs_ondisk.h             |  4 ++--
 fs/xfs/xfs_reflink.c            |  3 ++-
 fs/xfs/xfs_trans.c              | 10 +++-------
 fs/xfs/xfs_trans.h              | 15 ---------------
 18 files changed, 143 insertions(+), 68 deletions(-)
