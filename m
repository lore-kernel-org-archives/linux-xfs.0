Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE74C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjEZCBy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjEZCBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33507A3
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC8D561298
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:01:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFC0C433D2;
        Fri, 26 May 2023 02:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066511;
        bh=hC5MsDl+dVT9X+BkCNjC+koeXesdtn16lbBeGdIa8RM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lkCsBA7OHqoIu133Q7gNAcGEJE32r2C7IZps9DiFGHxWfHnH5W43ZALVGoHXbJL6D
         GTwqrzsq9QaPWpklPBCV+bIpkbeVAs87QEwvchr9JtTjduOVm5wCb8TLurN59CEUax
         wujqjl70FDGcmoT5fLMlH1tG0YNhKGsmHWCQpuT3pU0bT3bdZfn7yBFWquwdp66Bqh
         W5mONPxHvXS81VdR73Kv32HQhXb9fF3DihvoaDehCZ4LBDM4XyNX71w6lndchtVPj6
         ufJQ60wglbfLNDC4mm/IdRINi7cXopo9t5zOvFilB5MsDf3nIvGvOv9GTwrY0PJjWh
         lV4B3FZJsUHFQ==
Date:   Thu, 25 May 2023 19:01:50 -0700
Subject: [PATCHSET v12.0 00/30] xfsprogs: Parent Pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Mark Tinguely <tinguely@sgi.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000710.GG11642@frogsfrogsfrogs>
References: <20230526000710.GG11642@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the latest parent pointer attributes for xfs.  The goal of this
patch set is to add a parent pointer attribute to each inode.  The
attribute name containing the parent inode, generation, and directory
offset, while the  attribute value contains the file name.  This feature
will enable future optimizations for online scrub, shrink, nfs handles,
verity, or any other feature that could make use of quickly deriving an
inodes path from the mount point.

At this point, Allison is moving on to other things, so I've merged her
patchset into djwong-dev for merging.

Updates since v11 [djwong]:

Rebase on 6.4-rc and make some tweaks and bugfixes to enable the repair
prototypes.  Merge with djwong-dev and make online repair actually work.

Updates since v10 [djwong]:

Merge in the ondisk format changes to get rid of the diroffset conflicts
with the parent pointer repair code, rebase the entire series with the
attr vlookup changes first, and merge all the other random fixes.

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

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs
---
 db/attr.c                |   67 ++++++
 db/attrshort.c           |   51 ++++
 db/metadump.c            |  316 +++++++++++++++++++++++++++-
 db/namei.c               |  335 +++++++++++++++++++++++++++++
 include/handle.h         |    1 
 include/libxfs.h         |    1 
 include/xfs_inode.h      |    6 +
 io/parent.c              |  527 ++++++++++++++++------------------------------
 libfrog/Makefile         |    2 
 libfrog/fsgeom.c         |    4 
 libfrog/getparents.c     |  345 ++++++++++++++++++++++++++++++
 libfrog/getparents.h     |   36 +++
 libfrog/paths.c          |  167 +++++++++++++++
 libfrog/paths.h          |   25 ++
 libhandle/handle.c       |    7 -
 libxfs/Makefile          |    3 
 libxfs/init.c            |    7 +
 libxfs/libxfs_api_defs.h |   14 +
 libxfs/libxfs_priv.h     |    6 -
 libxfs/util.c            |   14 +
 libxfs/xfs_attr.c        |   21 +-
 libxfs/xfs_attr.h        |   14 +
 libxfs/xfs_attr_leaf.c   |    6 -
 libxfs/xfs_attr_sf.h     |    1 
 libxfs/xfs_da_format.h   |   34 +++
 libxfs/xfs_format.h      |    4 
 libxfs/xfs_fs.h          |    2 
 libxfs/xfs_fs_staging.h  |   66 ++++++
 libxfs/xfs_log_format.h  |    1 
 libxfs/xfs_log_rlimit.c  |   53 +++++
 libxfs/xfs_parent.c      |  325 ++++++++++++++++++++++++++++
 libxfs/xfs_parent.h      |  101 +++++++++
 libxfs/xfs_sb.c          |    4 
 libxfs/xfs_trans_resv.c  |  324 ++++++++++++++++++++++++----
 libxfs/xfs_trans_space.c |  121 +++++++++++
 libxfs/xfs_trans_space.h |   25 +-
 logprint/log_redo.c      |   81 +++++++
 man/man3/xfsctl.3        |   63 +++++
 man/man8/xfs_db.8        |    9 +
 man/man8/xfs_io.8        |   30 ++-
 man/man8/xfs_spaceman.8  |    7 +
 mkfs/proto.c             |   63 ++++-
 mkfs/xfs_mkfs.c          |   31 ++-
 repair/attr_repair.c     |   25 +-
 repair/phase6.c          |   14 +
 scrub/common.c           |   41 +++-
 spaceman/Makefile        |    4 
 spaceman/file.c          |    7 +
 spaceman/health.c        |   53 ++++-
 spaceman/space.h         |    3 
 50 files changed, 2968 insertions(+), 499 deletions(-)
 create mode 100644 libfrog/getparents.c
 create mode 100644 libfrog/getparents.h
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h
 create mode 100644 libxfs/xfs_trans_space.c

