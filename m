Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfA3BF4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 Jan 2019 20:05:56 -0500
Date: Tue, 29 Jan 2019 20:05:53 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC v2 2/3] xfs: distinguish between inobt and finobt
 magic values
Message-ID: <20190130010552.GA28304@bfoster>
References: <20190128152034.21080-1-bfoster@redhat.com>
 <20190128152034.21080-3-bfoster@redhat.com>
 <20190128225426.GU4205@dastard>
 <20190129140136.GC24998@bfoster>
 <20190129211655.GY4205@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190129211655.GY4205@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 30, 2019 at 08:16:55AM +1100, Dave Chinner wrote:
> On Tue, Jan 29, 2019 at 09:01:36AM -0500, Brian Foster wrote:
> > On Tue, Jan 29, 2019 at 09:54:26AM +1100, Dave Chinner wrote:
> > > On Mon, Jan 28, 2019 at 10:20:33AM -0500, Brian Foster wrote:
> > > > The inode btree verifier code is shared between the inode btree and
> > > > free inode btree because the underlying metadata formats are
> > > > essentially equivalent. A side effect of this is that the verifier
> > > > cannot determine whether a particular btree block should have an
> > > > inobt or finobt magic value.
> > > > 
> > > > This logic allows an unfortunate xfs_repair bug to escape detection
> > > > where certain level > 0 nodes of the finobt are stamped with inobt
> > > > magic by xfs_repair finobt reconstruction. This is fortunately not a
> > > > severe problem since the inode btree magic values do not contribute
> > > > to any changes in kernel behavior, but we do need a means to detect
> > > > and prevent this problem in the future.
> > > > 
> > > > Add a field to xfs_buf_ops to store the v4 and v5 superblock magic
> > > > values expected by a particular verifier. Add a helper to check an
> > > > on-disk magic value against the value expected by the verifier. Call
> > > > the helper from the shared [f]inobt verifier code for magic value
> > > > verification. This ensures that the inode btree blocks each have the
> > > > appropriate magic value based on specific tree type and superblock
> > > > version.
> > > 
> > > I still really don't like this code :(
> > > 
> > 
> > Enough to explain why, perhaps?
> 
> I did in the past thread - it adds runtime overhead in performance
> critical paths, and it requires verfiers to have a dependecy on
> bp->b_ops being set.
> 

Fair points, but seem like nits to me when you consider the unfortunate
lack of decent alternatives. And the ->b_ops thing is really just a
happenstance bit of scrub logic that needs to be tweaked.

> > > > @@ -387,4 +388,22 @@ extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int);
> > > >  
> > > >  int xfs_buf_ensure_ops(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
> > > >  
> > > > +/*
> > > > + * Verify an on-disk magic value against the magic value specified in the
> > > > + * verifier structure.
> > > > + */
> > > > +static inline bool
> > > > +xfs_buf_ops_verify_magic(
> > > > +	struct xfs_buf		*bp,
> > > > +	__be32			dmagic,
> > > > +	bool			crc)
> > > > +{
> > > > +	if (unlikely(WARN_ON(!bp->b_ops || !bp->b_ops->magic[crc])))
> > > > +		return false;
> > > > +	return dmagic == cpu_to_be32(bp->b_ops->magic[crc]);
> > > > +}
> > > > +#define xfs_verify_magic(bp, dmagic)		\
> > > > +	xfs_buf_ops_verify_magic(bp, dmagic,	\
> > > > +			xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb))
> > > 
> > > That, IMO, is even worse....
> > > 
> > 
> > Worse than what and why?
> 
> Worse that the last patch, because it now adds a needless macro that
> only serves to obfuscate the code. This:
> 

That is easy enough to address (using your logic below) regardless of
how we access the magic value.

> static inline bool
> xfs_verify_magic(
> 	struct xfs_mount	*mp,
> 	__be32			dmagic,
> 	int			idx)
> {
> 	__be32			magic;
> 
> 	if (xfs_sb_version_hascrc(&mp->m_sb))
> 		magic = xfs_v5_disk_magic[idx];
> 	magic = xfs_v4_disk_magic[idx];
> 
> 	return dmagic == magic;
> }
> 
> is much cleaner and easier to understand....
> 
> > Note that I've removed the endian conversion from here. Otherwise, this
> > is basically just a wrapper to factor out the sb version lookup and
> > provide some common error checking.
> > 
> > > Ok, here's a different option. Store all the magic numbers in a pair
> > > of tables - one for v4, one for v5. They can be static const and
> > > in on-disk format.
> > > 
> > > Then use some simple 1-line wrappers for the verifier definitions to
> > > specify the table index for the magic numbers. e.g:
> > > 
> > > __be32 xfs_disk_magic(mp, idx)
> > > {
> > > 	if (xfs_sb_version_hascrc(&mp->m_sb))
> > > 		return xfs_v5_disk_magic[idx];
> > > 	return xfs_v4_disk_magic[idx];
> > > }
> > > 
> > 
> > Seems reasonable enough... but where/how is the index encoded?
> 
> I was thinking in fs/xfs/libxfs/xfs_types.[ch], via an index similar
> to xfs_btnum_t indexes (could even use it to begin with).
> 
> static const xfs_v5_disk_magic[] = {
> 	cpu_to_be32(XFS_ABTB_CRC_MAGIC),
> 	cpu_to_be32(XFS_ABTC_CRC_MAGIC),
> 	cpu_to_be32(XFS_ITB_CRC_MAGIC),
> 	cpu_to_be32(XFS_FITB_CRC_MAGIC),
> 	.....
> }
> 
> You could do the same thing to the verfier op definition to
> remove the need on-the-fly endian conversion just for the magic
> number checks, which gets rid of that concern.
> 
> > > And this can be extended to all the verifiers - it handles crc and
> > > non CRC variants transparently, and can be used for the cnt/bno free
> > > space btrees, too.
> > > 
> > > Yes, it's a bit more boiler plate code, but IMO it is easier to
> > > follow and understand than encoding multiple magic numbers into the
> > > verifier and adding a dependency on the buffer having an ops
> > > structure attached to be able to check the magic number...
> > 
> > This code duplication is what I was hoping to avoid. We already have
> > similar proliferation of boilerplate code in some of the verifiers that
> > handle multiple object types. See the appended hunk related to the dir
> > leaf verifier code, for example.
> 
> Personally I prefer code duplication first, then factor later once
> the code settles down. In hindsight, we've probably factored the
> verifiers too much too soon...
> 
> > I agree that the magic value itself is a bit obfuscated with this
> > change, but that's still the case with a lookup table.
> 
> The difference with the lookup table is that you know what the magic
> number is supposed to be by looking at the code that calls it...
> 

Indeed. What I didn't realize until later today is that some verifiers
(xfs_sb_buf_ops, xfs_attr3_leaf_buf_ops, xfs_da3_node_buf_ops) check
already converted in-core structures and thus actually verify against
cpu endian magic values. This means said verifiers would require further
tweaks to either check the underlying buffer, another conversion back to
disk endian, or we'd otherwise need four of these arrays. :/

> > Another angle to this is that we don't necessarily have to use the
> > xfs_buf_ops->magic field for every verifier. I could just add it to the
> > finobt case, perhaps the directory case below, and leave the rest alone
> > until we come up with something more agreeable. Then it basically just
> > supports a couple corner cases and is easy enough to remove down the
> > road.
> 
> I'd like all the verifiers to use the same mechanism so we maintain
> consistency between them.
> 

I'd like that too, but I think we need to make some kind of tradeoff or
compromise to fix this problem given the current, rather ad-hoc nature
of the verifier code. Some check in-core structs, some don't and may or
may not use the compile time conversion optimization.

> > --- 8< ---
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > index 1728a3e6f5cf..f602307d2fa0 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > @@ -142,41 +142,32 @@ xfs_dir3_leaf_check_int(
> >   */
> >  static xfs_failaddr_t
> >  xfs_dir3_leaf_verify(
> > -	struct xfs_buf		*bp,
> > -	uint16_t		magic)
> > +	struct xfs_buf		*bp)
> >  {
> >  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> >  	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> >  
> > -	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
> > +	if (!xfs_verify_magic(bp, be16_to_cpu(leaf->hdr.info.magic)))
> > +		return __this_address;
> >  
> >  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> >  		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
> > -		uint16_t		magic3;
> >  
> > -		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
> > -							 : XFS_DIR3_LEAFN_MAGIC;
> > -
> > -		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
> > -			return __this_address;
> > +		ASSERT(leaf3->info.hdr.magic == leaf->hdr.info.magic);
> >  		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
> >  			return __this_address;
> >  		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
> >  			return __this_address;
> >  		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
> >  			return __this_address;
> > -	} else {
> > -		if (leaf->hdr.info.magic != cpu_to_be16(magic))
> > -			return __this_address;
> >  	}
> >  
> >  	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
> >  }
> 
> .....
> 
> Ok, that removes a lot more existing code than I ever thought it
> would. If you clean up the macro mess and use encoded magic numbers
> in the ops structure, then consider my objections removed. :)
> 

I'll kill off the macro..

By encoded, I assume you mean on-disk order(?). Given that some
verifiers use the cpu endian value, I thought it more clear for the
helper to expect a cpu endian value. We could technically store any
endian we want, including different endian on a per verifier basis and
pass the values all the way through, but I'd find that rather confusing
(and a nightmare to review and maintain).

> (And that then leads to factoring of xfs_dablk_info_verify() as dir
> leaf, danode and attribute leaf blocks all use the same struct
> xfs_da3_blkinfo header, and now the magic number is abstracted they
> can use the same code....)
> 

Not sure I follow..?

> Brian, to help prevent stupid people like me wasting your time in
> future, can you post the entire patch set you have so we can see the
> same picture you have for the overall change, even if there's only a
> small chunk you are proposing for merge? That way we'll be able to
> judge the change on the merits of the entire work, rather than just
> the small chunk that was posted? 
> 

That was the entire patchset at the time. ;) I intentionally made the
isolated finobt change and posted that to try and get big picture
feedback before making mechanical changes to the rest of the verifiers.
I probably had most of the rest done shortly after posting the rfcv2,
but it wasn't tested until today (re: the v1 post) so I just included
the above snippet to demonstrate the cleanup.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
