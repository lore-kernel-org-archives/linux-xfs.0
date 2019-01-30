Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11595 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726878AbfA3CPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 21:15:35 -0500
Date: Wed, 30 Jan 2019 13:15:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC v2 2/3] xfs: distinguish between inobt and finobt
 magic values
Message-ID: <20190130021529.GH4205@dastard>
References: <20190128152034.21080-1-bfoster@redhat.com>
 <20190128152034.21080-3-bfoster@redhat.com>
 <20190128225426.GU4205@dastard>
 <20190129140136.GC24998@bfoster>
 <20190129211655.GY4205@dastard>
 <20190130010552.GA28304@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130010552.GA28304@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 29, 2019 at 08:05:53PM -0500, Brian Foster wrote:
> On Wed, Jan 30, 2019 at 08:16:55AM +1100, Dave Chinner wrote:
> > On Tue, Jan 29, 2019 at 09:01:36AM -0500, Brian Foster wrote:
> > > On Tue, Jan 29, 2019 at 09:54:26AM +1100, Dave Chinner wrote:
> > > I agree that the magic value itself is a bit obfuscated with this
> > > change, but that's still the case with a lookup table.
> > 
> > The difference with the lookup table is that you know what the magic
> > number is supposed to be by looking at the code that calls it...
> > 
> 
> Indeed. What I didn't realize until later today is that some verifiers
> (xfs_sb_buf_ops, xfs_attr3_leaf_buf_ops, xfs_da3_node_buf_ops) check
> already converted in-core structures and thus actually verify against
> cpu endian magic values. This means said verifiers would require further
> tweaks to either check the underlying buffer, another conversion back to
> disk endian, or we'd otherwise need four of these arrays. :/

That was purely convenience, because we had to convert to the incore
header to check a bunch of other stuff, so the magic number got
converted for free.

I'd prefer if we are going to use a generic method of checking magic
numbers that it does it in on-disk format so that we don't need to
convert just for the magic number check.

> > I'd like all the verifiers to use the same mechanism so we maintain
> > consistency between them.
> > 
> 
> I'd like that too, but I think we need to make some kind of tradeoff or
> compromise to fix this problem given the current, rather ad-hoc nature
> of the verifier code. Some check in-core structs, some don't and may or
> may not use the compile time conversion optimization.

Ypup, so lets get them all on to checking the on-disk magic number
before conversion.

> > > --- 8< ---
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > index 1728a3e6f5cf..f602307d2fa0 100644
> > > --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > @@ -142,41 +142,32 @@ xfs_dir3_leaf_check_int(
> > >   */
> > >  static xfs_failaddr_t
> > >  xfs_dir3_leaf_verify(
> > > -	struct xfs_buf		*bp,
> > > -	uint16_t		magic)
> > > +	struct xfs_buf		*bp)
> > >  {
> > >  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > >  	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> > >  
> > > -	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
> > > +	if (!xfs_verify_magic(bp, be16_to_cpu(leaf->hdr.info.magic)))
> > > +		return __this_address;
> > >  
> > >  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > >  		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
> > > -		uint16_t		magic3;
> > >  
> > > -		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
> > > -							 : XFS_DIR3_LEAFN_MAGIC;
> > > -
> > > -		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
> > > -			return __this_address;
> > > +		ASSERT(leaf3->info.hdr.magic == leaf->hdr.info.magic);
> > >  		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
> > >  			return __this_address;
> > >  		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
> > >  			return __this_address;
> > >  		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
> > >  			return __this_address;
> > > -	} else {
> > > -		if (leaf->hdr.info.magic != cpu_to_be16(magic))
> > > -			return __this_address;
> > >  	}
> > >  
> > >  	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
> > >  }
> > 
> > .....
> > 
> > Ok, that removes a lot more existing code than I ever thought it
> > would. If you clean up the macro mess and use encoded magic numbers
> > in the ops structure, then consider my objections removed. :)
> > 
> 
> I'll kill off the macro..
> 
> By encoded, I assume you mean on-disk order(?).

Yup.

> > (And that then leads to factoring of xfs_dablk_info_verify() as dir
> > leaf, danode and attribute leaf blocks all use the same struct
> > xfs_da3_blkinfo header, and now the magic number is abstracted they
> > can use the same code....)
> > 
> 
> Not sure I follow..?

They all do the same thing. Taking your converted code:

	if (!xfs_verify_magic(bp, be16_to_cpu(leaf->hdr.info.magic)))
		return __this_address;

	if (xfs_sb_version_hascrc(&mp->m_sb)) {
		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;

		ASSERT(leaf3->info.hdr.magic == leaf->hdr.info.magic);
		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
			return __this_address;
		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
			return __this_address;
		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
			return __this_address;
	}

The only thing they need is mp, &leaf->hdr, and bp. They don't
actually need to know that its a dir2/dir3 leaf block now the magic
number is encoded in bp->b_ops.

i.e. that boiler plate can be factored out of multiple verifiers...

> > Brian, to help prevent stupid people like me wasting your time in
> > future, can you post the entire patch set you have so we can see the
> > same picture you have for the overall change, even if there's only a
> > small chunk you are proposing for merge? That way we'll be able to
> > judge the change on the merits of the entire work, rather than just
> > the small chunk that was posted? 
> > 
> 
> That was the entire patchset at the time. ;) I intentionally made the
> isolated finobt change and posted that to try and get big picture
> feedback before making mechanical changes to the rest of the verifiers.
> I probably had most of the rest done shortly after posting the rfcv2,
> but it wasn't tested until today (re: the v1 post) so I just included
> the above snippet to demonstrate the cleanup.

OK, so somewhat crossed wires while changes were still being made.
Such is life...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
