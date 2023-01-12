Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82FBCC54EBD
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Jan 2023 06:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjALGS1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Jan 2023 01:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbjALGSZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jan 2023 01:18:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237CF1263E
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 22:18:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D76F8B81C0B
        for <linux-xfs@vger.kernel.org>; Thu, 12 Jan 2023 06:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2F9C433EF;
        Thu, 12 Jan 2023 06:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673504301;
        bh=0bpnJ3j+VLKxxvLogkw89OAo1vXSvRZPqYmrheN2UUg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QZfQbbPVUm4qMnVelWdD+puGICha6qHz15MdUydV3I3WXPbt9vUcWKwDWG1vK9ZyK
         e2XqYjMTm/KPiHONReLCT+iduHgP0sqZLAoRkTXn28Q1lQetqB3TeQukujW0LJ3dKf
         n2Gk2xiJm2jdPRbE1y5TXUbucV+XKyNWRE2CnFinHAUCqS/yF0VlKqoKpGMxW45Kw7
         J86Yxe40XVDTQ07r+Chsr7+2WtxGILt3U9O0bwdHWbbLWgY7Dxyixl91QOHM3f6FA+
         df9DwYDe5eBdSNfzWK6sEicHWtEAXqrD5RyTu8mgI/AaGLsOfudK2gitcl3zX6WgR7
         VL2MUADaicDtQ==
Date:   Wed, 11 Jan 2023 22:18:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 00/27] Parent Pointers
Message-ID: <Y7+mLDIc+4gQy7QE@magnolia>
References: <20221218100306.76408-1-allison.henderson@oracle.com>
 <Y79UyH0aAKeaKLLU@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y79UyH0aAKeaKLLU@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 11, 2023 at 04:31:04PM -0800, Darrick J. Wong wrote:
> On Sun, Dec 18, 2022 at 03:02:39AM -0700, allison.henderson@oracle.com wrote:
> > From: Allison Henderson <allison.henderson@oracle.com>
> > 
> > Hi all,
> > 
> > This is the latest parent pointer attributes for xfs.
> > The goal of this patch set is to add a parent pointer attribute to each inode.
> > The attribute name containing the parent inode, generation, and directory
> > offset, while the  attribute value contains the file name.  This feature will
> > enable future optimizations for online scrub, shrink, nfs handles, verity, or
> > any other feature that could make use of quickly deriving an inodes path from
> > the mount point.  
> > 
> > This set can be viewed on github here
> > https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv7
> > 
> > And the corresponding xfsprogs code is here
> > https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v7
> > 
> > This set has been tested with the below parent pointers tests
> > https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/#t
> 
> I pulled v7 and rebased your patches atop 6.2-rc3.  generic/476 failed
> with quotas enabled:
> 
> XFS: Assertion failed: q[j].qt_dquot->q_id > d->q_id, file: fs/xfs/xfs_dquot.c, line: 1351
> <repeat>
> 
> I suspect this is becuase xfs_dqlockn needs to sort the dqtrx structures
> by quotaid?
> 
> So I turned off quotas and the kernel quieted down.  Good. :)
> 
> Next up was xfs_scrub, which complained about *something* in the xattr
> structures.  I'm guessing that it probably doesn't know how to deal with
> the new pptr namespace or the zeroes that can be present in the pptr
> attr name?
> 
> Other than that, looks promising.  I'll fix up the scrub and quota
> problems and start prototyping fsck code from there.

Second followup: two of the fstest vms are stuck spinning in unmount on
xfs/113; and the other two are stuck trying to grab ilocks in
generic/681 and generic/682.

--D

> --D
> 
> > Updates since v6:
> > Andry had reported intermittent hangs on unmount while running stress tests.
> > Reviewed and corrected unlocks in the case of error conditions.
> > 
> > xfs: parent pointer attribute creation
> >   Fixed dp to unlock on error
> >   
> > xfs: Hold inode locks in xfs_ialloc
> >   Fixed ip to unlock on create error
> >   
> > xfs: add parent attributes to symlink
> >   Hold and release dp across pptr operation
> >   
> > Questions comments and feedback appreciated!
> > 
> > Thanks all!
> > Allison
> > 
> > 
> > Allison Henderson (27):
> >   xfs: Add new name to attri/d
> >   xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
> >   xfs: Increase XFS_QM_TRANS_MAXDQS to 5
> >   xfs: Hold inode locks in xfs_ialloc
> >   xfs: Hold inode locks in xfs_trans_alloc_dir
> >   xfs: Hold inode locks in xfs_rename
> >   xfs: Expose init_xattrs in xfs_create_tmpfile
> >   xfs: get directory offset when adding directory name
> >   xfs: get directory offset when removing directory name
> >   xfs: get directory offset when replacing a directory name
> >   xfs: add parent pointer support to attribute code
> >   xfs: define parent pointer xattr format
> >   xfs: Add xfs_verify_pptr
> >   xfs: extend transaction reservations for parent attributes
> >   xfs: parent pointer attribute creation
> >   xfs: add parent attributes to link
> >   xfs: add parent attributes to symlink
> >   xfs: remove parent pointers in unlink
> >   xfs: Indent xfs_rename
> >   xfs: Add parent pointers to rename
> >   xfs: Add parent pointers to xfs_cross_rename
> >   xfs: Add the parent pointer support to the  superblock version 5.
> >   xfs: Add helper function xfs_attr_list_context_init
> >   xfs: Filter XFS_ATTR_PARENT for getfattr
> >   xfs: Add parent pointer ioctl
> >   xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
> >   xfs: drop compatibility minimum log size computations for reflink
> > 
> >  fs/xfs/Makefile                 |   2 +
> >  fs/xfs/libxfs/xfs_attr.c        |  71 +++++-
> >  fs/xfs/libxfs/xfs_attr.h        |  13 +-
> >  fs/xfs/libxfs/xfs_da_btree.h    |   3 +
> >  fs/xfs/libxfs/xfs_da_format.h   |  38 ++-
> >  fs/xfs/libxfs/xfs_defer.c       |  28 ++-
> >  fs/xfs/libxfs/xfs_defer.h       |   8 +-
> >  fs/xfs/libxfs/xfs_dir2.c        |  21 +-
> >  fs/xfs/libxfs/xfs_dir2.h        |   7 +-
> >  fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
> >  fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
> >  fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
> >  fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
> >  fs/xfs/libxfs/xfs_format.h      |   4 +-
> >  fs/xfs/libxfs/xfs_fs.h          |  75 ++++++
> >  fs/xfs/libxfs/xfs_log_format.h  |   7 +-
> >  fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
> >  fs/xfs/libxfs/xfs_parent.c      | 207 ++++++++++++++++
> >  fs/xfs/libxfs/xfs_parent.h      |  46 ++++
> >  fs/xfs/libxfs/xfs_sb.c          |   4 +
> >  fs/xfs/libxfs/xfs_trans_resv.c  | 324 ++++++++++++++++++++----
> >  fs/xfs/libxfs/xfs_trans_space.h |   8 -
> >  fs/xfs/scrub/attr.c             |   2 +-
> >  fs/xfs/xfs_attr_item.c          | 142 +++++++++--
> >  fs/xfs/xfs_attr_item.h          |   1 +
> >  fs/xfs/xfs_attr_list.c          |  17 +-
> >  fs/xfs/xfs_dquot.c              |  25 ++
> >  fs/xfs/xfs_dquot.h              |   1 +
> >  fs/xfs/xfs_file.c               |   1 +
> >  fs/xfs/xfs_inode.c              | 427 +++++++++++++++++++++++++-------
> >  fs/xfs/xfs_inode.h              |   3 +-
> >  fs/xfs/xfs_ioctl.c              | 148 +++++++++--
> >  fs/xfs/xfs_ioctl.h              |   2 +
> >  fs/xfs/xfs_iops.c               |   3 +-
> >  fs/xfs/xfs_ondisk.h             |   4 +
> >  fs/xfs/xfs_parent_utils.c       | 125 ++++++++++
> >  fs/xfs/xfs_parent_utils.h       |  11 +
> >  fs/xfs/xfs_qm.c                 |   4 +-
> >  fs/xfs/xfs_qm.h                 |   2 +-
> >  fs/xfs/xfs_super.c              |   4 +
> >  fs/xfs/xfs_symlink.c            |  58 ++++-
> >  fs/xfs/xfs_trans.c              |   6 +-
> >  fs/xfs/xfs_trans_dquot.c        |  15 +-
> >  fs/xfs/xfs_xattr.c              |   5 +-
> >  fs/xfs/xfs_xattr.h              |   1 +
> >  45 files changed, 1712 insertions(+), 245 deletions(-)
> >  create mode 100644 fs/xfs/libxfs/xfs_parent.c
> >  create mode 100644 fs/xfs/libxfs/xfs_parent.h
> >  create mode 100644 fs/xfs/xfs_parent_utils.c
> >  create mode 100644 fs/xfs/xfs_parent_utils.h
> > 
> > -- 
> > 2.25.1
> > 
