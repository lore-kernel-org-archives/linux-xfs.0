Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4ADFC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBPU3E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBPU3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:29:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE679196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:29:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 578F460A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9149C433D2;
        Thu, 16 Feb 2023 20:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579341;
        bh=9eGCp89037JxAqcbR62/KEsfGFI/GQkZUt7NeiNOUpQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hwRqc/LgY8WMf0v8FdFaARqrSExpT4L+LtiflYk/aWUgGhtJNSVHqZDXsJ/CeJaB7
         YG6RRLvX0XV3vdxoRg/lB+ss70clPt32ZvTWn5ZEWuLHJlZusFc+SHq0WEiAzZH5DT
         mvft+OJjzdoN41IUgQPO3MZfIZNfLVJ1d4Fj6E8g2OdF2PDcmTqIdA5goZDLioGH8B
         Jd+RM1eNiBoWU+rqevSHVcqcxGf/EBEipAcQ5SLi18c1K65IX68y3nnMP82fL5cDho
         BOJxWCgxHpYNEbkE46JIZp9XTS3gwHxovNkXjCyKNqclskr9eTcjnQ5UukcEvIj6as
         ehziUIKziQ/gQ==
Date:   Thu, 16 Feb 2023 12:29:01 -0800
Subject: [PATCHSET v9r2d1 00/25] xfsprogs: Parent Pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Mark Tinguely <tinguely@sgi.com>,
        Allison Collins <allison.henderson@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657878885.3476112.11949206434283274332.stgit@magnolia>
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

NOTE: Darrick has tweaked some of these patches to match the kernel
code.

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
 db/attr.c                |    3 
 db/attrshort.c           |    3 
 include/handle.h         |    2 
 include/parent.h         |   25 ++
 io/parent.c              |  505 ++++++++++++++--------------------------------
 libfrog/fsgeom.c         |    4 
 libfrog/paths.c          |  136 ++++++++++++
 libfrog/paths.h          |   21 ++
 libhandle/Makefile       |    2 
 libhandle/handle.c       |    7 -
 libhandle/parent.c       |  361 +++++++++++++++++++++++++++++++++
 libxfs/Makefile          |    2 
 libxfs/libxfs_priv.h     |    5 
 libxfs/xfs_attr.c        |   71 ++++++
 libxfs/xfs_attr.h        |   13 +
 libxfs/xfs_da_btree.h    |    3 
 libxfs/xfs_da_format.h   |   26 ++
 libxfs/xfs_defer.c       |   28 ++-
 libxfs/xfs_defer.h       |    8 +
 libxfs/xfs_dir2.c        |   21 ++
 libxfs/xfs_dir2.h        |    7 -
 libxfs/xfs_dir2_block.c  |    9 -
 libxfs/xfs_dir2_leaf.c   |    8 +
 libxfs/xfs_dir2_node.c   |    8 +
 libxfs/xfs_dir2_sf.c     |    6 +
 libxfs/xfs_format.h      |    4 
 libxfs/xfs_fs.h          |   75 +++++++
 libxfs/xfs_log_format.h  |    7 -
 libxfs/xfs_log_rlimit.c  |   53 +++++
 libxfs/xfs_parent.c      |  204 +++++++++++++++++++
 libxfs/xfs_parent.h      |   84 ++++++++
 libxfs/xfs_sb.c          |    4 
 libxfs/xfs_trans_resv.c  |  322 +++++++++++++++++++++++++----
 libxfs/xfs_trans_space.h |    8 -
 logprint/log_redo.c      |  212 +++++++++++++++++--
 logprint/logprint.h      |    5 
 man/man3/xfsctl.3        |   55 +++++
 mkfs/proto.c             |   50 +++--
 mkfs/xfs_mkfs.c          |   31 ++-
 repair/attr_repair.c     |   19 +-
 repair/phase6.c          |   24 +-
 scrub/inodes.c           |   26 ++
 scrub/inodes.h           |    2 
 43 files changed, 1957 insertions(+), 512 deletions(-)
 create mode 100644 libhandle/parent.c
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h

