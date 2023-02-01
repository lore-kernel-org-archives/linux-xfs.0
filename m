Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA0CC636CC
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Feb 2023 01:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjBABMH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Jan 2023 20:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjBABMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jan 2023 20:12:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF7453549
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jan 2023 17:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7CD8609E9
        for <linux-xfs@vger.kernel.org>; Wed,  1 Feb 2023 01:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291CDC433EF;
        Wed,  1 Feb 2023 01:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675213924;
        bh=dBoUv19r/khXV1VX2Sc2dQFs9xTY4GzoRgbw/zlz4bI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tp/q3QCfbfvJdccp7qvQfeBmg5it0X7rv2bE+WBVh6yHKHftxWwCEUYnIC76Hrtfk
         kv33rZUl1nN+fjbp8qN0yJC5Ld3guXPDiq8ciCNvppfKX9SdpANU2Rn4CYuvZU/3kB
         UhEkUoFePTLmRGJb6WWdGWICF7y858jbru5bvKe51iXzHZC7Hj/+8BHaJulB9q+bwn
         09YOiYjR9KxyQF1bSFNWERt4aI1fke/E/Qs0SjsUOmr7dU6Nrv/F7RIBCeNyk433w/
         mgpwCmFPrxkyBTHEDKZ+wC/7T4ejT0Cx/4xDrObsZwEYIswYwJ8EhwH5wnOG1xTpUo
         8GkHf1htyPpIg==
Date:   Tue, 31 Jan 2023 17:12:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 00/27] Parent Pointers
Message-ID: <Y9m8YwiuyleeIVv+@magnolia>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
 <Y89g0uSTIMpP4yGB@magnolia>
 <82afbd55a23019e6dd29862a17f813d7ef35788d.camel@oracle.com>
 <Y9CCrQ7IL1/R3ECD@magnolia>
 <Y9FifTUeIW+Mj1+B@magnolia>
 <051142f8296c0ede594effd3a96e3ea474476775.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <051142f8296c0ede594effd3a96e3ea474476775.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 25, 2023 at 08:54:43PM +0000, Allison Henderson wrote:
> On Wed, 2023-01-25 at 09:10 -0800, Darrick J. Wong wrote:
> > On Tue, Jan 24, 2023 at 05:15:25PM -0800, Darrick J. Wong wrote:
> > > On Tue, Jan 24, 2023 at 07:38:57AM +0000, Allison Henderson wrote:
> > > > On Mon, 2023-01-23 at 20:38 -0800, Darrick J. Wong wrote:
> > > > > On Mon, Jan 23, 2023 at 06:35:53PM -0700,
> > > > > allison.henderson@oracle.com wrote:
> > > > > > From: Allison Henderson <allison.henderson@oracle.com>
> > > > > > 
> > > > > > Hi all,
> > > > > > 
> > > > > > This is the latest parent pointer attributes for xfs.
> > > > > > The goal of this patch set is to add a parent pointer
> > > > > > attribute to
> > > > > > each inode.
> > > > > > The attribute name containing the parent inode, generation,
> > > > > > and
> > > > > > directory
> > > > > > offset, while the  attribute value contains the file name. 
> > > > > > This
> > > > > > feature will
> > > > > > enable future optimizations for online scrub, shrink, nfs
> > > > > > handles,
> > > > > > verity, or
> > > > > > any other feature that could make use of quickly deriving an
> > > > > > inodes
> > > > > > path from
> > > > > > the mount point.  
> > > > > > 
> > > > > > This set can be viewed on github here
> > > > > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv8_r1__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8uSz6Ss5$
> > > > > >  
> > > > > 
> > > > > I ran the kernel v8r1 branch through fstests and it came up
> > > > > with
> > > > > this:
> > > > > https://urldefense.com/v3/__https://djwong.org/fstests/output/.e2ecf3cd98a7b55bfe8b9d7f33d2ef9549ccb6526765421fd929cf6b1fa82265/.238f7848578c98c24e6347e59963548102fe83037127e44802014e48281a8ccc/?C=M;O=A__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8vEH_S-U$
> > > > 
> > > > Alrighty, I'll take a look, I had run it through a night or so
> > > > ago, and
> > > > hadnt noticed the same failures you list here.  Some of these
> > > > fail out
> > > > of the box for me, so I didnt think them associated with pptr
> > > > changes.
> > > 
> > > <nod> Some of those are just problems resulting from hardcoding
> > > xfs_db
> > > and mkfs output.
> > > 
> > > I noticed that the shutdowns are a result of reservationless
> > > link/rename
> > > operations; it's easier just to get rid of that nonfeature.
> > > 
> > > Also, there's a huge memory leak of xfs_parent_defer objects.
> > > 
> > > That's at least what I've found so far.  Will send the whole mess
> > > through fstests tonight.
> > 
> > No disasters reported, which means that the rest of the test failures
> > are (I think) either the result of mkfs failures (x/306) or different
> > xattrs (x/021).  I don't know why generic/050 fails, and ignore the
> > xfs/060 failure because the xfsdump tests fail randomly and nobody
> > knows
> > why.
> > 
> > https://urldefense.com/v3/__https://djwong.org/fstests/output/.e2ecf3cd98a7b55bfe8b9d7f33d2ef9549ccb6526765421fd929cf6b1fa82265/.27de2687d36a762c08d51a0f4a90e89b8ec852e883834bea47edffbfb03428eb/?C=M;O=A__;!!ACWV5N9M2RV99hQ!OcZtPlljmYqvnoHdHzjtuvE_g97qocvSSOV2FuwqeUXaprNX-2n6gdnTsMQHvuzhgMKOH7GCxAjDUCmbKBcG$
> >  
> > 
> > I've attached a tarball of the patches I applied to your kernel,
> > xfsprogs, and fstests trees to generate the fstests results.  Most of
> > the problems I found were a result of turning on KASAN, kmemcheck, or
> > lockdep.  It's up to you if you want to rebase the patch changes into
> > your branch or simply tack them on the end.
> 
> Alrighty, I will go through what you have in here and find the
> appropriate patches to put them in, I think that's cleaner than adding
> more patches on top of the set.  I'll note in the cover letter which
> patches are updated.  Thanks!

All right.  I've been working closely with the v8r1 parent pointers
series for the past couple of weeks to clear out all the bugs I could
find and to implement fsck (online and offline) for the new feature.

Kernel:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-dir-check

Userspace:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-repair

Testing:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs

There's a fair amount of bugfixes in the first two branches, and those
should probably get folded into v9 or whatever comes next.  Some of them
I've already quietly sent to Allison.

(I have just barely managed to get it to pass fstests on the fast
machines.  Tonight I'll send it out to the cloud for the more intense
stuff.)

Two bugs (that I know of) remain -- I've noticed that generic/388 and
generic/475 consistently trip over xfs_repair complaining about symbolic
links that should be local format links but are instead extents format
links.  I suspect this is due to parent pointers but it's not clear if
this is a real bug somewhere in the logging/recovery code or merely a
latent defect in xfs_repair, since I don't have an easy way to create a
non-pptr filesystem with symlinks with large xattrs.  Curiously, the
reported inodes have zero link count.  Will have to triage this more.

The fsck functionality borrows heavily from online fsck part 1, so I
think it's about time for us to figure out how to deal with the
necessary parent pointer updates after the fact.  My next effort will be
to experiment with changing the diroffset to a hash of the dirent name
per willy's suggestion.

--D

> Allison
> 
> > 
> > --D
> > 
> > > > >  
> > > > > 
> > > > > Looks better than v7, though I haven't tracked down why the fs
> > > > > goes
> > > > > down
> > > > > in generic/083 yet.  I think it's the same "rename doesn't
> > > > > reserve
> > > > > enough blocks" problem I was muttering about last time.  I
> > > > > think I
> > > > > need
> > > > > to look through the block reservation calculations again.
> > > > > 
> > > > > That said, I *did* finally write the code that scans the parent
> > > > > pointers
> > > > > to generate new directories.  It works for simple stupid cases
> > > > > where
> > > > > fsstress isn't running, but the live hooks part doesn't work
> > > > > because
> > > > > I
> > > > > haven't though through the locking model yet! :)
> > > > > 
> > > > > > And the corresponding xfsprogs code is here
> > > > > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v8_r1__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8nOCLP-H$
> > > > > >  
> > > > > 
> > > > > Will rebase xfsprogs against v8r1 tomorrow.
> > > > I think you had a scrub patch for this I forgot to add.  will do
> > > > that...  Aside from that, not much change there tho
> > > 
> > > <nod>
> > > 
> > > > > 
> > > > > > This set has been tested with the below parent pointers tests
> > > > > > https://urldefense.com/v3/__https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/*t__;Iw!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8ilcWlei$
> > > > > >  
> > > > > 
> > > > > And fix fstests after that.
> > > > The testcase i had saved as something Catherine could work on,
> > > > but
> > > > there's no rush on it.  The testcase tends to get tossed around
> > > > any
> > > > time there are api changes so it made sense to land at least
> > > > kernel
> > > > side first, though hopefully things should be decently firm at
> > > > this
> > > > point.
> > > 
> > > <nod> I'll not pay too much attention to xfs/018 then.
> > > 
> > > --D
> > > 
> > > > Allison
> > > > 
> > > > > 
> > > > > --D
> > > > > 
> > > > > > Updates since v7:
> > > > > > 
> > > > > > xfs: Increase XFS_QM_TRANS_MAXDQS to 5
> > > > > >   Modified xfs_dqlockn to sort dquotes before locking
> > > > > >   
> > > > > > xfs: Hold inode locks in xfs_trans_alloc_dir
> > > > > >    Modified xfs_trans_alloc_dir to release locks before
> > > > > > retrying
> > > > > > trans allocation
> > > > > >    
> > > > > > xfs: Hold inode locks in xfs_rename
> > > > > >    Modified xfs_rename to release locks before retrying trans
> > > > > > allocation
> > > > > > 
> > > > > > xfs: Expose init_xattrs in xfs_create_tmpfile
> > > > > >    Fixed xfs_generic_create to init attr tree
> > > > > > 
> > > > > > xfs: add parent pointer support to attribute code
> > > > > >    Updated xchk_xattr_rec with new XFS_ATTR_PARENT flag
> > > > > >   
> > > > > > xfs: Add parent pointer ioctl
> > > > > >    Include xfs_parent_utils.h in xfs_parent_utils.c to quiet
> > > > > > compiler warnings 
> > > > > >    
> > > > > > Questions comments and feedback appreciated!
> > > > > > 
> > > > > > Thanks all!
> > > > > > Allison
> > > > > > 
> > > > > > Allison Henderson (27):
> > > > > >   xfs: Add new name to attri/d
> > > > > >   xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
> > > > > >   xfs: Increase XFS_QM_TRANS_MAXDQS to 5
> > > > > >   xfs: Hold inode locks in xfs_ialloc
> > > > > >   xfs: Hold inode locks in xfs_trans_alloc_dir
> > > > > >   xfs: Hold inode locks in xfs_rename
> > > > > >   xfs: Expose init_xattrs in xfs_create_tmpfile
> > > > > >   xfs: get directory offset when adding directory name
> > > > > >   xfs: get directory offset when removing directory name
> > > > > >   xfs: get directory offset when replacing a directory name
> > > > > >   xfs: add parent pointer support to attribute code
> > > > > >   xfs: define parent pointer xattr format
> > > > > >   xfs: Add xfs_verify_pptr
> > > > > >   xfs: extend transaction reservations for parent attributes
> > > > > >   xfs: parent pointer attribute creation
> > > > > >   xfs: add parent attributes to link
> > > > > >   xfs: add parent attributes to symlink
> > > > > >   xfs: remove parent pointers in unlink
> > > > > >   xfs: Indent xfs_rename
> > > > > >   xfs: Add parent pointers to rename
> > > > > >   xfs: Add parent pointers to xfs_cross_rename
> > > > > >   xfs: Add the parent pointer support to the  superblock
> > > > > > version 5.
> > > > > >   xfs: Add helper function xfs_attr_list_context_init
> > > > > >   xfs: Filter XFS_ATTR_PARENT for getfattr
> > > > > >   xfs: Add parent pointer ioctl
> > > > > >   xfs: fix unit conversion error in
> > > > > > xfs_log_calc_max_attrsetm_res
> > > > > >   xfs: drop compatibility minimum log size computations for
> > > > > > reflink
> > > > > > 
> > > > > >  fs/xfs/Makefile                 |   2 +
> > > > > >  fs/xfs/libxfs/xfs_attr.c        |  71 +++++-
> > > > > >  fs/xfs/libxfs/xfs_attr.h        |  13 +-
> > > > > >  fs/xfs/libxfs/xfs_da_btree.h    |   3 +
> > > > > >  fs/xfs/libxfs/xfs_da_format.h   |  38 ++-
> > > > > >  fs/xfs/libxfs/xfs_defer.c       |  28 ++-
> > > > > >  fs/xfs/libxfs/xfs_defer.h       |   8 +-
> > > > > >  fs/xfs/libxfs/xfs_dir2.c        |  21 +-
> > > > > >  fs/xfs/libxfs/xfs_dir2.h        |   7 +-
> > > > > >  fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
> > > > > >  fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
> > > > > >  fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
> > > > > >  fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
> > > > > >  fs/xfs/libxfs/xfs_format.h      |   4 +-
> > > > > >  fs/xfs/libxfs/xfs_fs.h          |  75 ++++++
> > > > > >  fs/xfs/libxfs/xfs_log_format.h  |   7 +-
> > > > > >  fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
> > > > > >  fs/xfs/libxfs/xfs_parent.c      | 207 +++++++++++++++
> > > > > >  fs/xfs/libxfs/xfs_parent.h      |  46 ++++
> > > > > >  fs/xfs/libxfs/xfs_sb.c          |   4 +
> > > > > >  fs/xfs/libxfs/xfs_trans_resv.c  | 324 ++++++++++++++++++++--
> > > > > > --
> > > > > >  fs/xfs/libxfs/xfs_trans_space.h |   8 -
> > > > > >  fs/xfs/scrub/attr.c             |   4 +-
> > > > > >  fs/xfs/xfs_attr_item.c          | 142 +++++++++--
> > > > > >  fs/xfs/xfs_attr_item.h          |   1 +
> > > > > >  fs/xfs/xfs_attr_list.c          |  17 +-
> > > > > >  fs/xfs/xfs_dquot.c              |  38 +++
> > > > > >  fs/xfs/xfs_dquot.h              |   1 +
> > > > > >  fs/xfs/xfs_file.c               |   1 +
> > > > > >  fs/xfs/xfs_inode.c              | 428
> > > > > > +++++++++++++++++++++++++---
> > > > > > ----
> > > > > >  fs/xfs/xfs_inode.h              |   3 +-
> > > > > >  fs/xfs/xfs_ioctl.c              | 148 +++++++++--
> > > > > >  fs/xfs/xfs_ioctl.h              |   2 +
> > > > > >  fs/xfs/xfs_iops.c               |   3 +-
> > > > > >  fs/xfs/xfs_ondisk.h             |   4 +
> > > > > >  fs/xfs/xfs_parent_utils.c       | 126 ++++++++++
> > > > > >  fs/xfs/xfs_parent_utils.h       |  11 +
> > > > > >  fs/xfs/xfs_qm.c                 |   4 +-
> > > > > >  fs/xfs/xfs_qm.h                 |   2 +-
> > > > > >  fs/xfs/xfs_super.c              |   4 +
> > > > > >  fs/xfs/xfs_symlink.c            |  58 ++++-
> > > > > >  fs/xfs/xfs_trans.c              |   9 +-
> > > > > >  fs/xfs/xfs_trans_dquot.c        |  15 +-
> > > > > >  fs/xfs/xfs_xattr.c              |   5 +-
> > > > > >  fs/xfs/xfs_xattr.h              |   1 +
> > > > > >  45 files changed, 1731 insertions(+), 246 deletions(-)
> > > > > >  create mode 100644 fs/xfs/libxfs/xfs_parent.c
> > > > > >  create mode 100644 fs/xfs/libxfs/xfs_parent.h
> > > > > >  create mode 100644 fs/xfs/xfs_parent_utils.c
> > > > > >  create mode 100644 fs/xfs/xfs_parent_utils.h
> > > > > > 
> > > > > > -- 
> > > > > > 2.25.1
> > > > > > 
> > > > 
> 
