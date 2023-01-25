Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C607C54E94
	for <linux-xfs@archiver.kernel.org>; Wed, 25 Jan 2023 01:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjAYBPb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 20:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjAYBPa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jan 2023 20:15:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551F01734
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jan 2023 17:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02E51B81731
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 01:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C3AC433D2;
        Wed, 25 Jan 2023 01:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674609325;
        bh=rpBsF6YpgZLjgYABEFoXteQXhYZGLxSneqcj+mMq0go=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QWcvyRgZtkqiU31G+3sm7iXVCqjMa+JE+6xfLmqACJVceYCcJxgIRJFMCRa8w2FIu
         qy3Q/bHLFUXPP0VvIzhlMtJb492Q89awzeqXYiEVbmsBzjGSt5+yqVD6U/CWAeIov1
         t1RxEMcBYdLkphQ9g0bozZMPX27YD+NHhEX1U4geyChJSD56xTJQka+gbNKHJC2UMQ
         ZCYn+su4QvsEUtx+3cUH3Z7wJNUISmx6ONqIR+RWSYpJei+sPX79bdmBbd88juFN58
         w94UgoL4L2raMzhfpnuSOSsmdt+WcspnrX0FJmID+tG+2mrdne3HxWgGzwpXji+PZI
         93p0MV3tkef5Q==
Date:   Tue, 24 Jan 2023 17:15:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v8 00/27] Parent Pointers
Message-ID: <Y9CCrQ7IL1/R3ECD@magnolia>
References: <20230124013620.1089319-1-allison.henderson@oracle.com>
 <Y89g0uSTIMpP4yGB@magnolia>
 <82afbd55a23019e6dd29862a17f813d7ef35788d.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82afbd55a23019e6dd29862a17f813d7ef35788d.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 24, 2023 at 07:38:57AM +0000, Allison Henderson wrote:
> On Mon, 2023-01-23 at 20:38 -0800, Darrick J. Wong wrote:
> > On Mon, Jan 23, 2023 at 06:35:53PM -0700,
> > allison.henderson@oracle.com wrote:
> > > From: Allison Henderson <allison.henderson@oracle.com>
> > > 
> > > Hi all,
> > > 
> > > This is the latest parent pointer attributes for xfs.
> > > The goal of this patch set is to add a parent pointer attribute to
> > > each inode.
> > > The attribute name containing the parent inode, generation, and
> > > directory
> > > offset, while the  attribute value contains the file name.  This
> > > feature will
> > > enable future optimizations for online scrub, shrink, nfs handles,
> > > verity, or
> > > any other feature that could make use of quickly deriving an inodes
> > > path from
> > > the mount point.  
> > > 
> > > This set can be viewed on github here
> > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfs/tree/xfs_new_pptrsv8_r1__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8uSz6Ss5$
> > >  
> > 
> > I ran the kernel v8r1 branch through fstests and it came up with
> > this:
> > https://urldefense.com/v3/__https://djwong.org/fstests/output/.e2ecf3cd98a7b55bfe8b9d7f33d2ef9549ccb6526765421fd929cf6b1fa82265/.238f7848578c98c24e6347e59963548102fe83037127e44802014e48281a8ccc/?C=M;O=A__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8vEH_S-U$
> 
> Alrighty, I'll take a look, I had run it through a night or so ago, and
> hadnt noticed the same failures you list here.  Some of these fail out
> of the box for me, so I didnt think them associated with pptr changes.

<nod> Some of those are just problems resulting from hardcoding xfs_db
and mkfs output.

I noticed that the shutdowns are a result of reservationless link/rename
operations; it's easier just to get rid of that nonfeature.

Also, there's a huge memory leak of xfs_parent_defer objects.

That's at least what I've found so far.  Will send the whole mess
through fstests tonight.

> >  
> > 
> > Looks better than v7, though I haven't tracked down why the fs goes
> > down
> > in generic/083 yet.  I think it's the same "rename doesn't reserve
> > enough blocks" problem I was muttering about last time.  I think I
> > need
> > to look through the block reservation calculations again.
> > 
> > That said, I *did* finally write the code that scans the parent
> > pointers
> > to generate new directories.  It works for simple stupid cases where
> > fsstress isn't running, but the live hooks part doesn't work because
> > I
> > haven't though through the locking model yet! :)
> > 
> > > And the corresponding xfsprogs code is here
> > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v8_r1__;!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8nOCLP-H$
> > >  
> > 
> > Will rebase xfsprogs against v8r1 tomorrow.
> I think you had a scrub patch for this I forgot to add.  will do
> that...  Aside from that, not much change there tho

<nod>

> > 
> > > This set has been tested with the below parent pointers tests
> > > https://urldefense.com/v3/__https://lore.kernel.org/fstests/20221012013812.82161-1-catherine.hoang@oracle.com/T/*t__;Iw!!ACWV5N9M2RV99hQ!N2nNiERMG5LB2c5JRplSXXpgpp6yVFE8n22VEStqjIgbSm7yY0m92DEvfpPkD7XfwguuE49Sclb-8ilcWlei$
> > >  
> > 
> > And fix fstests after that.
> The testcase i had saved as something Catherine could work on, but
> there's no rush on it.  The testcase tends to get tossed around any
> time there are api changes so it made sense to land at least kernel
> side first, though hopefully things should be decently firm at this
> point.

<nod> I'll not pay too much attention to xfs/018 then.

--D

> Allison
> 
> > 
> > --D
> > 
> > > Updates since v7:
> > > 
> > > xfs: Increase XFS_QM_TRANS_MAXDQS to 5
> > >   Modified xfs_dqlockn to sort dquotes before locking
> > >   
> > > xfs: Hold inode locks in xfs_trans_alloc_dir
> > >    Modified xfs_trans_alloc_dir to release locks before retrying
> > > trans allocation
> > >    
> > > xfs: Hold inode locks in xfs_rename
> > >    Modified xfs_rename to release locks before retrying trans
> > > allocation
> > > 
> > > xfs: Expose init_xattrs in xfs_create_tmpfile
> > >    Fixed xfs_generic_create to init attr tree
> > > 
> > > xfs: add parent pointer support to attribute code
> > >    Updated xchk_xattr_rec with new XFS_ATTR_PARENT flag
> > >   
> > > xfs: Add parent pointer ioctl
> > >    Include xfs_parent_utils.h in xfs_parent_utils.c to quiet
> > > compiler warnings 
> > >    
> > > Questions comments and feedback appreciated!
> > > 
> > > Thanks all!
> > > Allison
> > > 
> > > Allison Henderson (27):
> > >   xfs: Add new name to attri/d
> > >   xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
> > >   xfs: Increase XFS_QM_TRANS_MAXDQS to 5
> > >   xfs: Hold inode locks in xfs_ialloc
> > >   xfs: Hold inode locks in xfs_trans_alloc_dir
> > >   xfs: Hold inode locks in xfs_rename
> > >   xfs: Expose init_xattrs in xfs_create_tmpfile
> > >   xfs: get directory offset when adding directory name
> > >   xfs: get directory offset when removing directory name
> > >   xfs: get directory offset when replacing a directory name
> > >   xfs: add parent pointer support to attribute code
> > >   xfs: define parent pointer xattr format
> > >   xfs: Add xfs_verify_pptr
> > >   xfs: extend transaction reservations for parent attributes
> > >   xfs: parent pointer attribute creation
> > >   xfs: add parent attributes to link
> > >   xfs: add parent attributes to symlink
> > >   xfs: remove parent pointers in unlink
> > >   xfs: Indent xfs_rename
> > >   xfs: Add parent pointers to rename
> > >   xfs: Add parent pointers to xfs_cross_rename
> > >   xfs: Add the parent pointer support to the  superblock version 5.
> > >   xfs: Add helper function xfs_attr_list_context_init
> > >   xfs: Filter XFS_ATTR_PARENT for getfattr
> > >   xfs: Add parent pointer ioctl
> > >   xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
> > >   xfs: drop compatibility minimum log size computations for reflink
> > > 
> > >  fs/xfs/Makefile                 |   2 +
> > >  fs/xfs/libxfs/xfs_attr.c        |  71 +++++-
> > >  fs/xfs/libxfs/xfs_attr.h        |  13 +-
> > >  fs/xfs/libxfs/xfs_da_btree.h    |   3 +
> > >  fs/xfs/libxfs/xfs_da_format.h   |  38 ++-
> > >  fs/xfs/libxfs/xfs_defer.c       |  28 ++-
> > >  fs/xfs/libxfs/xfs_defer.h       |   8 +-
> > >  fs/xfs/libxfs/xfs_dir2.c        |  21 +-
> > >  fs/xfs/libxfs/xfs_dir2.h        |   7 +-
> > >  fs/xfs/libxfs/xfs_dir2_block.c  |   9 +-
> > >  fs/xfs/libxfs/xfs_dir2_leaf.c   |   8 +-
> > >  fs/xfs/libxfs/xfs_dir2_node.c   |   8 +-
> > >  fs/xfs/libxfs/xfs_dir2_sf.c     |   6 +
> > >  fs/xfs/libxfs/xfs_format.h      |   4 +-
> > >  fs/xfs/libxfs/xfs_fs.h          |  75 ++++++
> > >  fs/xfs/libxfs/xfs_log_format.h  |   7 +-
> > >  fs/xfs/libxfs/xfs_log_rlimit.c  |  53 ++++
> > >  fs/xfs/libxfs/xfs_parent.c      | 207 +++++++++++++++
> > >  fs/xfs/libxfs/xfs_parent.h      |  46 ++++
> > >  fs/xfs/libxfs/xfs_sb.c          |   4 +
> > >  fs/xfs/libxfs/xfs_trans_resv.c  | 324 ++++++++++++++++++++----
> > >  fs/xfs/libxfs/xfs_trans_space.h |   8 -
> > >  fs/xfs/scrub/attr.c             |   4 +-
> > >  fs/xfs/xfs_attr_item.c          | 142 +++++++++--
> > >  fs/xfs/xfs_attr_item.h          |   1 +
> > >  fs/xfs/xfs_attr_list.c          |  17 +-
> > >  fs/xfs/xfs_dquot.c              |  38 +++
> > >  fs/xfs/xfs_dquot.h              |   1 +
> > >  fs/xfs/xfs_file.c               |   1 +
> > >  fs/xfs/xfs_inode.c              | 428 +++++++++++++++++++++++++---
> > > ----
> > >  fs/xfs/xfs_inode.h              |   3 +-
> > >  fs/xfs/xfs_ioctl.c              | 148 +++++++++--
> > >  fs/xfs/xfs_ioctl.h              |   2 +
> > >  fs/xfs/xfs_iops.c               |   3 +-
> > >  fs/xfs/xfs_ondisk.h             |   4 +
> > >  fs/xfs/xfs_parent_utils.c       | 126 ++++++++++
> > >  fs/xfs/xfs_parent_utils.h       |  11 +
> > >  fs/xfs/xfs_qm.c                 |   4 +-
> > >  fs/xfs/xfs_qm.h                 |   2 +-
> > >  fs/xfs/xfs_super.c              |   4 +
> > >  fs/xfs/xfs_symlink.c            |  58 ++++-
> > >  fs/xfs/xfs_trans.c              |   9 +-
> > >  fs/xfs/xfs_trans_dquot.c        |  15 +-
> > >  fs/xfs/xfs_xattr.c              |   5 +-
> > >  fs/xfs/xfs_xattr.h              |   1 +
> > >  45 files changed, 1731 insertions(+), 246 deletions(-)
> > >  create mode 100644 fs/xfs/libxfs/xfs_parent.c
> > >  create mode 100644 fs/xfs/libxfs/xfs_parent.h
> > >  create mode 100644 fs/xfs/xfs_parent_utils.c
> > >  create mode 100644 fs/xfs/xfs_parent_utils.h
> > > 
> > > -- 
> > > 2.25.1
> > > 
> 
