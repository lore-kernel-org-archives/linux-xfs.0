Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A189C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjEZCAv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjEZCAu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:00:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5374189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:00:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44EFA64C47
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A301EC433D2;
        Fri, 26 May 2023 02:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066448;
        bh=q3OBSTE0hy1psrNqZLfd6bYXglPjrnDIopnvZpncw5Y=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=GCI5l+XerkfGZEbsWW2lgIeHmxeLGXaJqOj6w7mDbqJ9fQPz/AdcFgYHfs5Vl7clj
         /hTxOYs+wkq3K7O5qKurcYsXHCROdNfHj7sUNLzXrp2PaGs49vj9kW3JVjsNOYTy/y
         8jEqRuE8v6YhQLxl55dtCiR8OCFWj0lQ7FsS0UtBAv++yovb2r0T1kece157Q6AcRY
         tywSEpufPnrElIsQFZUdsuON1FPbqmc9Qfm+L/DESSoh/sB27R/K+6yvastaCE7dTH
         ZiaQwxC82ULbOcGnP99n+3orcEoJhyPpQQ1rJ36O1zXnwMn+c0dctF34f5aTmZI8mf
         zPxZ8/bb+h8lA==
Date:   Thu, 25 May 2023 19:00:48 -0700
Subject: [PATCHSET v12.0 00/18] xfs: Parent Pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Mark Tinguely <tinguely@sgi.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile                 |    3 
 fs/xfs/libxfs/xfs_attr.c        |   21 ++-
 fs/xfs/libxfs/xfs_attr.h        |   14 +-
 fs/xfs/libxfs/xfs_attr_leaf.c   |    6 -
 fs/xfs/libxfs/xfs_attr_sf.h     |    1 
 fs/xfs/libxfs/xfs_da_format.h   |   34 ++++
 fs/xfs/libxfs/xfs_format.h      |    4 
 fs/xfs/libxfs/xfs_fs.h          |    2 
 fs/xfs/libxfs/xfs_fs_staging.h  |   66 ++++++++
 fs/xfs/libxfs/xfs_log_format.h  |    1 
 fs/xfs/libxfs/xfs_log_rlimit.c  |   53 ++++++
 fs/xfs/libxfs/xfs_parent.c      |  324 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.h      |  101 ++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |    4 
 fs/xfs/libxfs/xfs_trans_resv.c  |  326 +++++++++++++++++++++++++++++++++------
 fs/xfs/libxfs/xfs_trans_space.c |  121 ++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |   25 ++-
 fs/xfs/scrub/attr.c             |    4 
 fs/xfs/scrub/dir_repair.c       |    2 
 fs/xfs/scrub/orphanage.c        |    6 -
 fs/xfs/scrub/parent_repair.c    |    3 
 fs/xfs/scrub/symlink_repair.c   |    2 
 fs/xfs/scrub/tempfile.c         |    2 
 fs/xfs/xfs_attr_item.c          |   24 +++
 fs/xfs/xfs_attr_list.c          |   25 ++-
 fs/xfs/xfs_inode.c              |  266 +++++++++++++++++++++++++-------
 fs/xfs/xfs_ioctl.c              |  135 ++++++++++++++++
 fs/xfs/xfs_ondisk.h             |    4 
 fs/xfs/xfs_parent_utils.c       |  159 +++++++++++++++++++
 fs/xfs/xfs_parent_utils.h       |   20 ++
 fs/xfs/xfs_super.c              |   14 ++
 fs/xfs/xfs_symlink.c            |   29 +++
 fs/xfs/xfs_trace.c              |    1 
 fs/xfs/xfs_trace.h              |   76 +++++++++
 fs/xfs/xfs_xattr.c              |    8 +
 fs/xfs/xfs_xattr.h              |    2 
 36 files changed, 1722 insertions(+), 166 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_parent.c
 create mode 100644 fs/xfs/libxfs/xfs_parent.h
 create mode 100644 fs/xfs/libxfs/xfs_trans_space.c
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h

