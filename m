Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D28C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjBPU0g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBPU0e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:26:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E792639BBC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8532EB82992
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432AAC433EF;
        Thu, 16 Feb 2023 20:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579185;
        bh=+zCWlmf8kBf1tVP3wdtCWgtU9nOdbPi6QmIUEFSOsYs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=eTpfuUwRSBUAMODkOKY0NZhrQ1VJbZJdxB70hwYQsji3ic4WN9UuYgG4FkBl6MyGM
         V4P72TeWdpDf7rbQvF9lPy8wso2OnjIrj5rFIAQh4iTKcVO1or5mt4ePynfZCwKiV1
         UoHy/y6xfOg6t4IhqmIvfRs1KY6bnRDD3p14+I40ZFR/sb964CFvtpR084Y8x6BZ2z
         bQEBPlYT9fQdwWRMSpNXKg+fLNNyXn383NZKLv8pI5m6qcTyEWvDamI2dzdGlVkWtt
         GOAeR+vYje64rVj4uc/eV6nTlCZKYJv5Xtx11Zv8ERKRb8ncHzGL/p4b7jW6Kuj6DY
         GgxJwD6AOok1w==
Date:   Thu, 16 Feb 2023 12:26:24 -0800
Subject: [PATCHSET v9r2d1 00/28] xfs: Parent Pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Mark Tinguely <tinguely@sgi.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872335.3473407.14628732092515467392.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the latest parent pointer attributes for xfs.
The goal of this patch set is to add a parent pointer attribute to each inode.
The attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature will
enable future optimizations for online scrub, shrink, nfs handles, verity, or
any other feature that could make use of quickly deriving an inodes path from
the mount point.

This set can be viewed on github here
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv9_r2

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v9_r2

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t

Updates since v8:

xfs: parent pointer attribute creation
   Fix xfs_parent_init to release log assist on alloc fail
   Add slab cache for xfs_parent_defer
   Fix xfs_create to release after unlock
   Add xfs_parent_start and xfs_parent_finish wrappers
   removed unused xfs_parent_name_irec and xfs_init_parent_name_irec

xfs: add parent attributes to link
   Start/finish wrapper updates
   Fix xfs_link to disallow reservationless quotas
   
xfs: add parent attributes to symlink
   Fix xfs_symlink to release after unlock
   Start/finish wrapper updates
   
xfs: remove parent pointers in unlink
   Start/finish wrapper updates
   Add missing parent free

xfs: Add parent pointers to rename
   Start/finish wrapper updates
   Fix rename to only grab logged xattr once
   Fix xfs_rename to disallow reservationless quotas
   Fix double unlock on dqattach fail
   Move parent frees to out_release_wip
   
xfs: Add parent pointers to xfs_cross_rename
   Hoist parent pointers into rename

Questions comments and feedback appreciated!

Thanks all!
Allison

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs
---
 fs/xfs/Makefile                 |    2 
 fs/xfs/libxfs/xfs_attr.c        |   71 +++++-
 fs/xfs/libxfs/xfs_attr.h        |   13 +
 fs/xfs/libxfs/xfs_da_btree.h    |    3 
 fs/xfs/libxfs/xfs_da_format.h   |   26 ++
 fs/xfs/libxfs/xfs_defer.c       |   28 ++
 fs/xfs/libxfs/xfs_defer.h       |    8 +
 fs/xfs/libxfs/xfs_dir2.c        |   21 +-
 fs/xfs/libxfs/xfs_dir2.h        |    7 -
 fs/xfs/libxfs/xfs_dir2_block.c  |    9 -
 fs/xfs/libxfs/xfs_dir2_leaf.c   |    8 +
 fs/xfs/libxfs/xfs_dir2_node.c   |    8 +
 fs/xfs/libxfs/xfs_dir2_sf.c     |    6 +
 fs/xfs/libxfs/xfs_format.h      |    4 
 fs/xfs/libxfs/xfs_fs.h          |   75 +++++++
 fs/xfs/libxfs/xfs_log_format.h  |    7 -
 fs/xfs/libxfs/xfs_log_rlimit.c  |   53 +++++
 fs/xfs/libxfs/xfs_parent.c      |  203 ++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |   84 +++++++
 fs/xfs/libxfs/xfs_sb.c          |    4 
 fs/xfs/libxfs/xfs_trans_resv.c  |  324 ++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_trans_space.h |    8 -
 fs/xfs/scrub/attr.c             |    4 
 fs/xfs/xfs_attr_item.c          |  142 ++++++++++--
 fs/xfs/xfs_attr_item.h          |    1 
 fs/xfs/xfs_attr_list.c          |   17 +
 fs/xfs/xfs_dquot.c              |   38 +++
 fs/xfs/xfs_dquot.h              |    1 
 fs/xfs/xfs_file.c               |    1 
 fs/xfs/xfs_inode.c              |  447 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_inode.h              |    3 
 fs/xfs/xfs_ioctl.c              |  148 +++++++++++--
 fs/xfs/xfs_ioctl.h              |    2 
 fs/xfs/xfs_iops.c               |    3 
 fs/xfs/xfs_ondisk.h             |    4 
 fs/xfs/xfs_parent_utils.c       |  126 +++++++++++
 fs/xfs/xfs_parent_utils.h       |   11 +
 fs/xfs/xfs_qm.c                 |    4 
 fs/xfs/xfs_qm.h                 |    2 
 fs/xfs/xfs_super.c              |   14 +
 fs/xfs/xfs_symlink.c            |   58 ++++-
 fs/xfs/xfs_trans.c              |   13 +
 fs/xfs/xfs_trans_dquot.c        |   15 +
 fs/xfs/xfs_xattr.c              |    7 -
 fs/xfs/xfs_xattr.h              |    2 
 45 files changed, 1782 insertions(+), 253 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

