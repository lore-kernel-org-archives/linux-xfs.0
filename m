Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00A8C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbjDFTQC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjDFTQC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:16:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312D7F2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0BDE63F1A
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F58DC433D2;
        Thu,  6 Apr 2023 19:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680808560;
        bh=zyjsXY20/GS3cGNp0/g/zwhOhufaWtt3A8CBY0XFM7g=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=aO10qiWw85L9mRFyaBYFFMrwjNg6FhxRZqHbpvIIa8BNS4WEfmpKJG0xgHyZo0IFY
         MigqfgEncrQJ+a+dnhCrWr+VNymquoQZEGl2KhFLUoL1fqQP0+1ILtw0bW0ufiz4mI
         9LBAuK49b60L+eZe4R5lzIM1qxIivecDoXcxeck0MqoeIRPHNMnzDIL7ifk4Z/h0CT
         /BrzyCVbRHO1XYjWRkYWkoFiwTNNSelUuQV6TbVBjKbh5YWk+0x6A9U0K39wivnbX+
         2pG1w96yywBIl6D7EMIaMmCrh1si/h3EnRkVlsZu8UVAMVH0Qhc1IV4GeZa4SblyqU
         PaHQCLlLVJzgw==
Date:   Thu, 06 Apr 2023 12:15:59 -0700
Subject: [PATCHSET v11 00/32] xfsprogs: Parent Pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Mark Tinguely <tinguely@sgi.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
In-Reply-To: <20230406181038.GA360889@frogsfrogsfrogs>
References: <20230406181038.GA360889@frogsfrogsfrogs>
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
https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv10

And the corresponding xfsprogs code is here
https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v10

This set has been tested with the below parent pointers tests
https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t
Updates since v9:

Reordered patches 2 and 3 to be 6 and 7

xfs: Add xfs_verify_pptr
   moved parent pointer validators to xfs_parent

xfs: Add parent pointer ioctl
   Extra validation checks for fs id
   added missing release for the inode
   use GFP_KERNEL flags for malloc/realloc
   reworked ioctl to use pptr listenty and flex array

NEW
   xfs: don't remove the attr fork when parent pointers are enabled

NEW
   directory lookups should return diroffsets too

NEW
   xfs: move/add parent pointer validators to xfs_parent

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
 db/Makefile              |    2 
 db/attr.c                |   65 +++++
 db/attrshort.c           |   51 ++++
 db/hash.c                |  374 +++++++++++++++++++++++++++
 db/metadump.c            |  646 +++++++++++++++++++++-------------------------
 db/namei.c               |  335 ++++++++++++++++++++++++
 db/obfuscate.c           |  348 +++++++++++++++++++++++++
 db/obfuscate.h           |   16 +
 include/handle.h         |    1 
 include/libxfs.h         |    2 
 include/xfs.h            |    1 
 include/xfs_inode.h      |    6 
 io/parent.c              |  527 +++++++++++++-------------------------
 libfrog/Makefile         |    2 
 libfrog/fsgeom.c         |    4 
 libfrog/getparents.c     |  338 ++++++++++++++++++++++++
 libfrog/getparents.h     |   36 +++
 libfrog/paths.c          |  167 ++++++++++++
 libfrog/paths.h          |   25 ++
 libhandle/handle.c       |    7 
 libxfs/Makefile          |    3 
 libxfs/init.c            |    7 
 libxfs/libxfs_api_defs.h |    6 
 libxfs/libxfs_priv.h     |    6 
 libxfs/util.c            |   14 +
 libxfs/xfs_attr.c        |   21 +
 libxfs/xfs_attr.h        |   14 +
 libxfs/xfs_attr_leaf.c   |    6 
 libxfs/xfs_attr_sf.h     |    1 
 libxfs/xfs_da_format.h   |   34 ++
 libxfs/xfs_defer.c       |   28 ++
 libxfs/xfs_defer.h       |    8 -
 libxfs/xfs_format.h      |    4 
 libxfs/xfs_fs.h          |    2 
 libxfs/xfs_fs_staging.h  |   84 ++++++
 libxfs/xfs_log_format.h  |    1 
 libxfs/xfs_log_rlimit.c  |   53 ++++
 libxfs/xfs_parent.c      |  318 +++++++++++++++++++++++
 libxfs/xfs_parent.h      |  104 +++++++
 libxfs/xfs_sb.c          |    4 
 libxfs/xfs_trans_resv.c  |  324 +++++++++++++++++++----
 libxfs/xfs_trans_space.h |    8 -
 logprint/log_redo.c      |   81 ++++++
 man/man3/xfsctl.3        |   63 ++++
 man/man8/xfs_db.8        |   40 +++
 man/man8/xfs_io.8        |   30 +-
 mkfs/proto.c             |   48 +++
 mkfs/xfs_mkfs.c          |   31 ++
 repair/attr_repair.c     |   19 +
 repair/phase6.c          |    6 
 scrub/common.c           |   41 +++
 51 files changed, 3562 insertions(+), 800 deletions(-)
 create mode 100644 db/obfuscate.c
 create mode 100644 db/obfuscate.h
 create mode 100644 libfrog/getparents.c
 create mode 100644 libfrog/getparents.h
 create mode 100644 libxfs/xfs_fs_staging.h
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h

