Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbfBGTmn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 14:42:43 -0500
Date: Thu, 7 Feb 2019 14:42:41 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v4 7/8] xfs: miscellaneous verifier magic value fixups
Message-ID: <20190207194240.GC61958@bfoster>
References: <20190207184105.17064-1-bfoster@redhat.com>
 <20190207184105.17064-8-bfoster@redhat.com>
 <20190207191313.GK7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207191313.GK7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 11:13:13AM -0800, Darrick J. Wong wrote:
> On Thu, Feb 07, 2019 at 01:41:04PM -0500, Brian Foster wrote:
> > Most buffer verifiers have hardcoded magic value checks
> > conditionalized on the version of the filesystem. The magic value
> > field of the verifier structure facilitates abstraction of some of
> > this code. Populate the ->magic field of various verifiers to take
> > advantage of this abstraction. No functional changes.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c          | 12 ++++++++----
> >  fs/xfs/libxfs/xfs_attr_leaf.c      | 11 +++++------
> >  fs/xfs/libxfs/xfs_attr_remote.c    |  8 +++++---
> >  fs/xfs/libxfs/xfs_bmap_btree.c     | 13 ++++++-------
> >  fs/xfs/libxfs/xfs_da_btree.c       | 11 +++++------
> >  fs/xfs/libxfs/xfs_dir2_block.c     | 10 +++++-----
> >  fs/xfs/libxfs/xfs_dir2_data.c      | 12 +++++++-----
> >  fs/xfs/libxfs/xfs_dir2_node.c      | 10 +++++-----
> >  fs/xfs/libxfs/xfs_ialloc.c         |  3 ++-
> >  fs/xfs/libxfs/xfs_refcount_btree.c |  3 ++-
> >  fs/xfs/libxfs/xfs_rmap_btree.c     |  3 ++-
> >  fs/xfs/libxfs/xfs_sb.c             |  4 +++-
> >  fs/xfs/libxfs/xfs_symlink_remote.c |  3 ++-
> >  fs/xfs/xfs_ondisk.h                |  6 ++++++
> >  14 files changed, 63 insertions(+), 46 deletions(-)
> > 
...
> > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > index 0209f3e91254..881af4f7ed89 100644
> > --- a/fs/xfs/xfs_ondisk.h
> > +++ b/fs/xfs/xfs_ondisk.h
> > @@ -136,6 +136,12 @@ xfs_check_ondisk_structs(void)
> >  	 */
> >  	XFS_CHECK_OFFSET(struct xfs_dir2_leaf, hdr.info.magic,		8);
> >  	XFS_CHECK_OFFSET(struct xfs_dir3_leaf_hdr, info.hdr.magic,	8);
> > +	XFS_CHECK_OFFSET(struct xfs_attr_leafblock, hdr.info.magic,	8);
> 
> > +	XFS_CHECK_OFFSET(struct xfs_da3_node_hdr, info.hdr.magic,	8);
> > +	XFS_CHECK_OFFSET(struct xfs_da_intnode, hdr.info.magic,		8);
> 
> Should there be a check for struct xfs_da3_intnode too?
> 

I think this is the same deal as the previous patch. The verifier uses
xfs_da_intnode (where I suppose it could use either).

> > +	XFS_CHECK_OFFSET(struct xfs_da3_node_hdr, info.hdr.magic,	8);
> 
> Is one of these supposed to be struct xfs_da_node_hdr?
> 

Is that used in one of the verifiers (as opposed to xfs_da_intnode I
suspect)? I replaced 3 asserts in this patch and replaced each with the
magic value as accessed via the associated verifier on v4 and v5.

> Granted these all end up comparing the same thing, so maybe it's
> overkill to check da_node_hdr/da_intnode and da3_node_hdr/da3_intnode?
> 

The intent is just to cover the fact that the verifiers expect these
magic values to reside at the same offset, not so much that they're at
some particular offset. That's the reason for the comment above.

Perhaps it's better just to remove all of this entirely since this is
1.) not going to change without breaking v4/v5 fs' 2.) still technically
doesn't encode the requirement of the verifier and 3.) is kind of
getting beyond the scope of this series. Some of these verifiers used
the magic value itself to distinguish between v4 and v5 already, after
all. The original asserts were really just added as a quick mechanism to
make sure nothing obvious was broken by the changes that collapsed a few
of the verifiers with separate but similar magic checks.

Brian

> --D
> 
> > +	XFS_CHECK_OFFSET(struct xfs_dir2_free_hdr, magic,		0);
> > +	XFS_CHECK_OFFSET(struct xfs_dir3_blk_hdr, magic,		0);
> >  }
> >  
> >  #endif /* __XFS_ONDISK_H */
> > -- 
> > 2.17.2
> > 
