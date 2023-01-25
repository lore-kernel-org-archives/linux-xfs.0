Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB5FC54E94
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Jan 2023 17:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbjAYRLd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 12:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236077AbjAYRLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 12:11:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057705B594
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 09:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A9AE61590
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 17:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E80C433D2;
        Wed, 25 Jan 2023 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674666622;
        bh=JgA6VZg01TgkUW2X71AOHkJSP21GHqHUBr92FEXPJwc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YneFVNqSc51ykYpADu7Yq81uTsVawop9Qm1f8SX5EFXgiNvVJgBMtkUhKpnPbUaPs
         r53EsLUW1K4jTJ6XqeRCmHauFYYYSa/YdcXEAFXAxon5Teuzzwfqrdv3IScKnUZrxV
         biFCLh/JPeYwu7zx+hx1MpLEADNArqidLmdQZiKvlMx9CWgblQRlGxTGemSVUQvk6B
         iT/dr2XJ73Y/i5FGhKc6o1bkCdpCaakgYmztddACUltRHfY4VKj95ypHs9NQ1T+gjP
         5xRbBekjMqGftry3O2gda+5mGhGvkSc/gRa+Vzvf4MhadvLqSdqPH2K6NGsWjdxRwy
         M2kL+w5Cf8geg==
Date:   Wed, 25 Jan 2023 09:10:21 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v8 00/27] Parent Pointers
Message-ID: <Y9FifTUeIW+Mj1+B@magnolia>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
 <Y89g0uSTIMpP4yGB@magnolia>
 <82afbd55a23019e6dd29862a17f813d7ef35788d.camel@oracle.com>
 <Y9CCrQ7IL1/R3ECD@magnolia>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/pup0NAS9+tMmKeX"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y9CCrQ7IL1/R3ECD@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--/pup0NAS9+tMmKeX
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jan 24, 2023 at 05:15:25PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 24, 2023 at 07:38:57AM +0000, Allison Henderson wrote:
> > On Mon, 2023-01-23 at 20:38 -0800, Darrick J. Wong wrote:
> > > On Mon, Jan 23, 2023 at 06:35:53PM -0700,
> > > allison.henderson@oracle.com wrote:
> > > > From: Allison Henderson <allison.henderson@oracle.com>
> > > > 
> > > > Hi all,
> > > > 
> > > > This is the latest parent pointer attributes for xfs.
> > > > The goal of this patch set is to add a parent pointer attribute to
> > > > each inode.
> > > > The attribute name containing the parent inode, generation, and
> > > > directory
> > > > offset, while the  attribute value contains the file name.  This
> > > > feature will
> > > > enable future optimizations for online scrub, shrink, nfs handles,
> > > > verity, or
> > > > any other feature that could make use of quickly deriving an inodes
> > > > path from
> > > > the mount point.  
> > > > 
> > > > This set can be viewed on github here
> > > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv8_r1__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8uSz6Ss5$
> > > >  
> > > 
> > > I ran the kernel v8r1 branch through fstests and it came up with
> > > this:
> > > https://urldefense.com/v3/__https://djwong.org/fstests/output/.e2ecf3cd98a7b55bfe8b9d7f33d2ef9549ccb6526765421fd929cf6b1fa82265/.238f7848578c98c24e6347e59963548102fe83037127e44802014e48281a8ccc/?C=M;O=A__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8vEH_S-U$
> > 
> > Alrighty, I'll take a look, I had run it through a night or so ago, and
> > hadnt noticed the same failures you list here.  Some of these fail out
> > of the box for me, so I didnt think them associated with pptr changes.
> 
> <nod> Some of those are just problems resulting from hardcoding xfs_db
> and mkfs output.
> 
> I noticed that the shutdowns are a result of reservationless link/rename
> operations; it's easier just to get rid of that nonfeature.
> 
> Also, there's a huge memory leak of xfs_parent_defer objects.
> 
> That's at least what I've found so far.  Will send the whole mess
> through fstests tonight.

No disasters reported, which means that the rest of the test failures
are (I think) either the result of mkfs failures (x/306) or different
xattrs (x/021).  I don't know why generic/050 fails, and ignore the
xfs/060 failure because the xfsdump tests fail randomly and nobody knows
why.

https://djwong.org/fstests/output/.e2ecf3cd98a7b55bfe8b9d7f33d2ef9549ccb6526765421fd929cf6b1fa82265/.27de2687d36a762c08d51a0f4a90e89b8ec852e883834bea47edffbfb03428eb/?C=M;O=A

I've attached a tarball of the patches I applied to your kernel,
xfsprogs, and fstests trees to generate the fstests results.  Most of
the problems I found were a result of turning on KASAN, kmemcheck, or
lockdep.  It's up to you if you want to rebase the patch changes into
your branch or simply tack them on the end.

--D

> > >  
> > > 
> > > Looks better than v7, though I haven't tracked down why the fs goes
> > > down
> > > in generic/083 yet.  I think it's the same "rename doesn't reserve
> > > enough blocks" problem I was muttering about last time.  I think I
> > > need
> > > to look through the block reservation calculations again.
> > > 
> > > That said, I *did* finally write the code that scans the parent
> > > pointers
> > > to generate new directories.  It works for simple stupid cases where
> > > fsstress isn't running, but the live hooks part doesn't work because
> > > I
> > > haven't though through the locking model yet! :)
> > > 
> > > > And the corresponding xfsprogs code is here
> > > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v8_r1__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8nOCLP-H$
> > > >  
> > > 
> > > Will rebase xfsprogs against v8r1 tomorrow.
> > I think you had a scrub patch for this I forgot to add.  will do
> > that...  Aside from that, not much change there tho
> 
> <nod>
> 
> > > 
> > > > This set has been tested with the below parent pointers tests
> > > > https://urldefense.com/v3/__https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/*t__;Iw!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8ilcWlei$
> > > >  
> > > 
> > > And fix fstests after that.
> > The testcase i had saved as something Catherine could work on, but
> > there's no rush on it.  The testcase tends to get tossed around any
> > time there are api changes so it made sense to land at least kernel
> > side first, though hopefully things should be decently firm at this
> > point.
> 
> <nod> I'll not pay too much attention to xfs/018 then.
> 
> --D
> 
> > Allison
> > 
> > > 
> > > --D
> > > 
> > > > Updates since v7:
> > > > 
> > > > xfs: Increase XFS_QM_TRANS_MAXDQS to 5
> > > >   Modified xfs_dqlockn to sort dquotes before locking
> > > >   
> > > > xfs: Hold inode locks in xfs_trans_alloc_dir
> > > >    Modified xfs_trans_alloc_dir to release locks before retrying
> > > > trans allocation
> > > >    
> > > > xfs: Hold inode locks in xfs_rename
> > > >    Modified xfs_rename to release locks before retrying trans
> > > > allocation
> > > > 
> > > > xfs: Expose init_xattrs in xfs_create_tmpfile
> > > >    Fixed xfs_generic_create to init attr tree
> > > > 
> > > > xfs: add parent pointer support to attribute code
> > > >    Updated xchk_xattr_rec with new XFS_ATTR_PARENT flag
> > > >   
> > > > xfs: Add parent pointer ioctl
> > > >    Include xfs_parent_utils.h in xfs_parent_utils.c to quiet
> > > > compiler warnings 
> > > >    
> > > > Questions comments and feedback appreciated!
> > > > 
> > > > Thanks all!
> > > > Allison
> > > > 
> > > > Allison Henderson (27):
> > > >   xfs: Add new name to attri/d
> > > >   xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
> > > >   xfs: Increase XFS_QM_TRANS_MAXDQS to 5
> > > >   xfs: Hold inode locks in xfs_ialloc
> > > >   xfs: Hold inode locks in xfs_trans_alloc_dir
> > > >   xfs: Hold inode locks in xfs_rename
> > > >   xfs: Expose init_xattrs in xfs_create_tmpfile
> > > >   xfs: get directory offset when adding directory name
> > > >   xfs: get directory offset when removing directory name
> > > >   xfs: get directory offset when replacing a directory name
> > > >   xfs: add parent pointer support to attribute code
> > > >   xfs: define parent pointer xattr format
> > > >   xfs: Add xfs_verify_pptr
> > > >   xfs: extend transaction reservations for parent attributes
> > > >   xfs: parent pointer attribute creation
> > > >   xfs: add parent attributes to link
> > > >   xfs: add parent attributes to symlink
> > > >   xfs: remove parent pointers in unlink
> > > >   xfs: Indent xfs_rename
> > > >   xfs: Add parent pointers to rename
> > > >   xfs: Add parent pointers to xfs_cross_rename
> > > >   xfs: Add the parent pointer support to the  superblock version 5.
> > > >   xfs: Add helper function xfs_attr_list_context_init
> > > >   xfs: Filter XFS_ATTR_PARENT for getfattr
> > > >   xfs: Add parent pointer ioctl
> > > >   xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
> > > >   xfs: drop compatibility minimum log size computations for reflink
> > > > 
> > > >  fs/xfs/Makefile                 |   2 +
> > > >  fs/xfs/libxfs/xfs_attr.c        |  71 +++++-
> > > >  fs/xfs/libxfs/xfs_attr.h        |  13 +-
> > > >  fs/xfs/libxfs/xfs_da_btree.h    |   3 +
> > > >  fs/xfs/libxfs/xfs_da_format.h   |  38 ++-
> > > >  fs/xfs/libxfs/xfs_defer.c       |  28 ++-
> > > >  fs/xfs/libxfs/xfs_defer.h       |   8 +-
> > > >  fs/xfs/libxfs/xfs_dir2.c        |  21 +-
> > > >  fs/xfs/libxfs/xfs_dir2.h        |   7 +-
> > > >  fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
> > > >  fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
> > > >  fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
> > > >  fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
> > > >  fs/xfs/libxfs/xfs_format.h      |   4 +-
> > > >  fs/xfs/libxfs/xfs_fs.h          |  75 ++++++
> > > >  fs/xfs/libxfs/xfs_log_format.h  |   7 +-
> > > >  fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
> > > >  fs/xfs/libxfs/xfs_parent.c      | 207 +++++++++++++++
> > > >  fs/xfs/libxfs/xfs_parent.h      |  46 ++++
> > > >  fs/xfs/libxfs/xfs_sb.c          |   4 +
> > > >  fs/xfs/libxfs/xfs_trans_resv.c  | 324 ++++++++++++++++++++----
> > > >  fs/xfs/libxfs/xfs_trans_space.h |   8 -
> > > >  fs/xfs/scrub/attr.c             |   4 +-
> > > >  fs/xfs/xfs_attr_item.c          | 142 +++++++++--
> > > >  fs/xfs/xfs_attr_item.h          |   1 +
> > > >  fs/xfs/xfs_attr_list.c          |  17 +-
> > > >  fs/xfs/xfs_dquot.c              |  38 +++
> > > >  fs/xfs/xfs_dquot.h              |   1 +
> > > >  fs/xfs/xfs_file.c               |   1 +
> > > >  fs/xfs/xfs_inode.c              | 428 +++++++++++++++++++++++++---
> > > > ----
> > > >  fs/xfs/xfs_inode.h              |   3 +-
> > > >  fs/xfs/xfs_ioctl.c              | 148 +++++++++--
> > > >  fs/xfs/xfs_ioctl.h              |   2 +
> > > >  fs/xfs/xfs_iops.c               |   3 +-
> > > >  fs/xfs/xfs_ondisk.h             |   4 +
> > > >  fs/xfs/xfs_parent_utils.c       | 126 ++++++++++
> > > >  fs/xfs/xfs_parent_utils.h       |  11 +
> > > >  fs/xfs/xfs_qm.c                 |   4 +-
> > > >  fs/xfs/xfs_qm.h                 |   2 +-
> > > >  fs/xfs/xfs_super.c              |   4 +
> > > >  fs/xfs/xfs_symlink.c            |  58 ++++-
> > > >  fs/xfs/xfs_trans.c              |   9 +-
> > > >  fs/xfs/xfs_trans_dquot.c        |  15 +-
> > > >  fs/xfs/xfs_xattr.c              |   5 +-
> > > >  fs/xfs/xfs_xattr.h              |   1 +
> > > >  45 files changed, 1731 insertions(+), 246 deletions(-)
> > > >  create mode 100644 fs/xfs/libxfs/xfs_parent.c
> > > >  create mode 100644 fs/xfs/libxfs/xfs_parent.h
> > > >  create mode 100644 fs/xfs/xfs_parent_utils.c
> > > >  create mode 100644 fs/xfs/xfs_parent_utils.h
> > > > 
> > > > -- 
> > > > 2.25.1
> > > > 
> > 

--/pup0NAS9+tMmKeX
Content-Type: application/x-xz
Content-Disposition: attachment; filename="ach.tar.xz"
Content-Transfer-Encoding: base64

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
WVo=

--/pup0NAS9+tMmKeX--
