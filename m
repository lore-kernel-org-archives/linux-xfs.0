Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbfAaSEB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:04:01 -0500
Date: Thu, 31 Jan 2019 13:03:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 0/7] xfs: fix [f]inobt magic value verification
Message-ID: <20190131180358.GA36239@bfoster>
References: <20190131154608.36837-1-bfoster@redhat.com>
 <20190131175404.GC5761@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131175404.GC5761@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 31, 2019 at 09:54:04AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 31, 2019 at 10:46:01AM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > Here's v2 of the verifier magic value cleanup. This is generally the
> > same idea as the previous version. The primary difference is that v2
> > first converts verifiers that use cpu order magic comparisons to use
> > on-disk (big endian) order and then stores/compares the verifier magic
> > values in on-disk order. The purpose of this change is to reduce the
> > number of byte swaps required at runtime for verifier magic value
> > checks. Further changes include some cleanups, additional refactoring
> > and the inclusion of Darrick's scrub ->b_ops fix with some modifications
> > from the original version.
> > 
> > This survives fstests on v4 and v5 filesystems on both little and big
> > endian systems without regressions. Thoughts, reviews, flames
> > appreciated.
> 
> One thing I was expecting to see but didn't -- are you going to convert
> the bnobt/cntbt verifiers so that we have tree-specific magic number
> checking?
> 

I originally skipped over that one because the hardcoded checks looked
convoluted. Looking again, we probably should include it simply because
it's a similar shared verifier case as for the inobt vs. finobt. We
might still have to keep around a couple hardcoded magic checks for the
pagf_levels thing, but I'll look into it and tack on a new patch for
xfs_allocbt_buf_ops.

Brian

> --D
> 
> > Brian
> > 
> > v2:
> > - Include djwong's ->b_ops patch w/ modifications.
> > - Added patch to fix up existing cpu endian magic checks, fold in typo
> >   fix.
> > - Replace static inline magic verifier helper with out of line variant,
> >   kill macro.
> > - Store on-disk byte order magics in ->b_ops.
> > - Added patch to refactor common xfs_da3_blkinfo checks.
> > v1: https://marc.info/?l=linux-xfs&m=154878684317178&w=2
> > - Remove endian conversion from helper.
> > - Drop finobt bad magic mitigation patch.
> > - Additional verifier magic fixups.
> > - Add verifier name typo fixup.
> > rfcv2: https://marc.info/?l=linux-xfs&m=154868884311668&w=2
> > - Split off finobt verifier into separate patch, assign it
> >   appropriately.
> > - Created helpers for xfs_buf_ops magic value verification.
> > - Added error mitigation patch for problematic finobt blocks.
> > rfcv1: https://marc.info/?l=linux-xfs&m=154834528212262&w=2
> > 
> > Brian Foster (6):
> >   xfs: always check magic values in on-disk byte order
> >   xfs: create a separate finobt verifier
> >   xfs: distinguish between inobt and finobt magic values
> >   xfs: use verifier magic field in dir2 leaf verifiers
> >   xfs: miscellaneous verifier magic value fixups
> >   xfs: factor xfs_da3_blkinfo verification into common helper
> > 
> > Darrick J. Wong (1):
> >   xfs: set buffer ops when repair probes for btree type
> > 
> >  fs/xfs/libxfs/xfs_ag.c             |   2 +-
> >  fs/xfs/libxfs/xfs_alloc.c          |  12 ++--
> >  fs/xfs/libxfs/xfs_attr_leaf.c      |  21 ++----
> >  fs/xfs/libxfs/xfs_attr_remote.c    |   8 ++-
> >  fs/xfs/libxfs/xfs_bmap_btree.c     |  13 ++--
> >  fs/xfs/libxfs/xfs_da_btree.c       |  50 ++++++++++-----
> >  fs/xfs/libxfs/xfs_da_format.h      |   2 +
> >  fs/xfs/libxfs/xfs_dir2_block.c     |  10 +--
> >  fs/xfs/libxfs/xfs_dir2_data.c      |  12 ++--
> >  fs/xfs/libxfs/xfs_dir2_leaf.c      | 100 ++++++-----------------------
> >  fs/xfs/libxfs/xfs_dir2_node.c      |  11 ++--
> >  fs/xfs/libxfs/xfs_ialloc.c         |   3 +-
> >  fs/xfs/libxfs/xfs_ialloc_btree.c   |  25 +++++---
> >  fs/xfs/libxfs/xfs_inode_buf.c      |   2 +-
> >  fs/xfs/libxfs/xfs_refcount_btree.c |   3 +-
> >  fs/xfs/libxfs/xfs_rmap_btree.c     |   3 +-
> >  fs/xfs/libxfs/xfs_sb.c             |   5 +-
> >  fs/xfs/libxfs/xfs_shared.h         |   1 +
> >  fs/xfs/libxfs/xfs_symlink_remote.c |   3 +-
> >  fs/xfs/scrub/agheader_repair.c     |   2 +-
> >  fs/xfs/scrub/repair.c              |  11 +++-
> >  fs/xfs/xfs_buf.c                   |  41 ++++++++++--
> >  fs/xfs/xfs_buf.h                   |   4 +-
> >  fs/xfs/xfs_log_recover.c           |   6 +-
> >  fs/xfs/xfs_trans_buf.c             |   2 +-
> >  25 files changed, 183 insertions(+), 169 deletions(-)
> > 
> > -- 
> > 2.17.2
> > 
