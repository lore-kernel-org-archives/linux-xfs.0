Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfBFSu6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Feb 2019 13:50:58 -0500
Date: Wed, 6 Feb 2019 13:50:55 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 0/9] xfs: fix [f]inobt magic value verification
Message-ID: <20190206185054.GD55658@bfoster>
References: <20190204145231.47034-1-bfoster@redhat.com>
 <20190206182331.GW7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190206182331.GW7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 06, 2019 at 10:23:31AM -0800, Darrick J. Wong wrote:
> On Mon, Feb 04, 2019 at 09:52:22AM -0500, Brian Foster wrote:
> > Hi all,
> > 
> > Here's v3 of the verifier magic value fixup series. This version adds a
> > couple more patches to separate and convert the allocation btree buffer
> > verifier to the new magic value verification scheme. The allocbt is
> > similar to the inobt verifier in that it currently uses the same
> > verifier code for multiple magic values. This change allows the verifier
> > to ensure that bnobt/cntbt blocks have the appropriate magic value for
> > v4 and v5 filesytems. The only other change from v2 is a fixup to
> > include parameter names in function declarations.
> > 
> > Thoughts, reviews, flames appreciated.
> 
> I noticed that inode and quota buf_ops still don't have magic numbers in
> them.  I think it's fairly trivial to add them to the buffer ops
> definitions, though actually using them looks a little tricky for
> dquots.  I'll send along a couple of patches to add that and clean up
> some of the repair code magic handling.
> 

The inode one looks pretty straightforward. I didn't think it worth the
refactoring for the dquot ops, but it could be done if consistency is
important. I guess I never really viewed this as a wholesale change as
opposed to an optional mechanism to be used where needed (and/or
convenient).

Brian

> --D
> 
> > Brian
> > 
> > v3:
> > - Fix function declarations to include parameter names.
> > - Convert allocbt buffer verifier.
> > v2: https://marc.info/?l=linux-xfs&m=154894958207167&w=2
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
> > Brian Foster (8):
> >   xfs: always check magic values in on-disk byte order
> >   xfs: create a separate finobt verifier
> >   xfs: distinguish between inobt and finobt magic values
> >   xfs: split up allocation btree verifier
> >   xfs: distinguish between bnobt and cntbt magic values
> >   xfs: use verifier magic field in dir2 leaf verifiers
> >   xfs: miscellaneous verifier magic value fixups
> >   xfs: factor xfs_da3_blkinfo verification into common helper
> > 
> > Darrick J. Wong (1):
> >   xfs: set buffer ops when repair probes for btree type
> > 
> >  fs/xfs/libxfs/xfs_ag.c             |   6 +-
> >  fs/xfs/libxfs/xfs_alloc.c          |  12 ++--
> >  fs/xfs/libxfs/xfs_alloc_btree.c    |  74 ++++++++++-----------
> >  fs/xfs/libxfs/xfs_attr_leaf.c      |  21 ++----
> >  fs/xfs/libxfs/xfs_attr_remote.c    |   8 ++-
> >  fs/xfs/libxfs/xfs_bmap_btree.c     |  13 ++--
> >  fs/xfs/libxfs/xfs_da_btree.c       |  50 ++++++++++-----
> >  fs/xfs/libxfs/xfs_da_format.h      |   3 +
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
> >  fs/xfs/libxfs/xfs_shared.h         |   4 +-
> >  fs/xfs/libxfs/xfs_symlink_remote.c |   3 +-
> >  fs/xfs/scrub/agheader_repair.c     |   6 +-
> >  fs/xfs/scrub/repair.c              |  11 +++-
> >  fs/xfs/xfs_buf.c                   |  41 ++++++++++--
> >  fs/xfs/xfs_buf.h                   |   4 +-
> >  fs/xfs/xfs_log_recover.c           |  12 ++--
> >  fs/xfs/xfs_trans_buf.c             |   2 +-
> >  26 files changed, 229 insertions(+), 215 deletions(-)
> > 
> > -- 
> > 2.17.2
> > 
