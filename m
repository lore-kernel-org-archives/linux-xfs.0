Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfBFTSj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Feb 2019 14:18:39 -0500
Date: Wed, 6 Feb 2019 14:18:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 7/9] xfs: use verifier magic field in dir2 leaf
 verifiers
Message-ID: <20190206191836.GE55658@bfoster>
References: <20190204145231.47034-1-bfoster@redhat.com>
 <20190204145231.47034-8-bfoster@redhat.com>
 <20190206174526.GO7991@magnolia>
 <20190206184122.GC55658@bfoster>
 <20190206190343.GY7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190206190343.GY7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Feb 06, 2019 at 11:03:43AM -0800, Darrick J. Wong wrote:
> On Wed, Feb 06, 2019 at 01:41:22PM -0500, Brian Foster wrote:
> > On Wed, Feb 06, 2019 at 09:45:26AM -0800, Darrick J. Wong wrote:
> > > On Mon, Feb 04, 2019 at 09:52:29AM -0500, Brian Foster wrote:
> > > > The dir2 leaf verifiers share the same underlying structure
> > > > verification code, but implement six accessor functions to multiplex
> > > > the code across the two verifiers. Further, the magic value isn't
> > > > sufficiently abstracted such that the common helper has to manually
> > > > fix up the magic from the caller on v5 filesystems.
> > > > 
> > > > Use the magic field in the verifier structure to eliminate the
> > > > duplicate code and clean this all up. No functional change.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_dir2_leaf.c | 88 ++++++++---------------------------
> > > >  1 file changed, 20 insertions(+), 68 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > > index 1728a3e6f5cf..a99ae2cd292e 100644
> > > > --- a/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > > +++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
> > > > @@ -142,41 +142,32 @@ xfs_dir3_leaf_check_int(
> > > >   */
> > > >  static xfs_failaddr_t
> > > >  xfs_dir3_leaf_verify(
> > > > -	struct xfs_buf		*bp,
> > > > -	uint16_t		magic)
> > > > +	struct xfs_buf		*bp)
> > > >  {
> > > >  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > > >  	struct xfs_dir2_leaf	*leaf = bp->b_addr;
> > > >  
> > > > -	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
> > > > +	if (!xfs_verify_magic(bp, leaf->hdr.info.magic))
> > > > +		return __this_address;
> > > >  
> > > >  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > > >  		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
> > > > -		uint16_t		magic3;
> > > >  
> > > > -		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
> > > > -							 : XFS_DIR3_LEAFN_MAGIC;
> > > > -
> > > > -		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
> > > > -			return __this_address;
> > > > +		ASSERT(leaf3->info.hdr.magic == leaf->hdr.info.magic);
> > > 
> > > leaf2 and leaf3 directory block headers are supposed to have the magic
> > > at the same offset in the buffer, right?  When would this assert fail?
> > > 
> > 
> > Hopefully never.. ;P I added the assert as a mechanical defense measure
> > simply because these are technically different structures and this
> > refactoring dictates that we access the magic value through one of the
> > two rather than both independently. I just wanted to make sure that this
> > dependency was encoded somewhere because it's not obvious in the code.
> 
> <nod>
> 
> > > Could we replace this with a BUILD_BUG_ON check of the leaf2/leaf3 magic
> > > number buffer offset in xfs_ondisk.h?
> > > 
> > 
> > BUILD_BUG_ON() probably makes more sense for this than an assert in
> > principle. Is there a clean enough way to encode the offset checks
> > through multiple structures though? We could do something with NULL
> > pointers:
> > 
> > 	BUILD_BUG_ON(&((struct xfs_da3_blkinfo *)NULL)->hdr.magic !=
> > 		     &((struct xfs_da_blkinfo *)NULL)->magic);
> > 
> > ... to check the offsets, but that's ugly. I'm not sure manually adding
> > up the offsetof() results is any better. That said, after this code is
> > refactored by the last patch this particular instance could probably be
> > reduced to a simple:
> > 
> > 	BUILD_BUG_ON(offsetof(struct xfs_da3_blkinfo, hdr) != 0);
> > 
> > ... in xfs_da3_blkinfo_verify(). So perhaps the right approach is just
> > to add a separate BUILD_BUG_ON() for each such layer in the
> > encapsulating structures. I'll take a closer look at that and see how
> > far I get.
> 
> <nod> afaict offsetof can look through substructures, since it all just
> turns into a bunch of pointer arithmetic goop.
> 
> > Also, any particular reason to put it in xfs_ondisk.h vs. where the
> > asserts currently are?
> 
> Hmm... we established xfs_ondisk.h to contain all the offset and
> structure size checks so that they'd all be in one place instead of
> scattered around in the verifiers and whatnot.  The macro soup emits
> prettier diagnostic data in case someone on an unfamiliar arch hits a
> build error and reports it.  So if we add this to xfs_ondisk.h:
> 
> XFS_CHECK_OFFSET(struct xfs_dir3_leaf_hdr, info.hdr.magic, 8);
> XFS_CHECK_OFFSET(struct xfs_dir2_leaf_hdr, info.magic, 8);
> 
> Then the compiler will emit:
> 
> include/linux/compiler.h:344:38: error: call to
> ‘__compiletime_assert_58’ declared with attribute error: XFS:
> offsetof(struct xfs_dir3_leaf_hdr, info.hdr.magic) is wrong, expected 8
> 
> I guess the strongest argument I have for xfs_ondisk.h is because
> "that's where all the other offset and size build checks go".
> 

Ok. Maybe it's just simplest to hardcode the relevant offsets like this.
A comment that explains that the verifier magic checks are the primary
motivation for the magic-specific offset checks mostly addresses my
concern over context. I'll give that a shot.

> > To me this is more context for the verifier code
> > than some broader requirement (since we're explicitly checking the magic
> > field), but maybe there are broader header alignment/offset expectations
> > elsewhere too.
> 
> Heh, I think this is a hair-splitting thing: are we checking that the
> offsets are the same (which indeed is a relational thing that ought to
> be in the verifier), or checking that ttwo offsets equal some value,
> where the value just happens to be the same number?
> 

The intent was really to check the offsets. The implementation did that
indirectly/hackily via the value comparison.

Brian

> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > >  		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_meta_uuid))
> > > >  			return __this_address;
> > > >  		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
> > > >  			return __this_address;
> > > >  		if (!xfs_log_check_lsn(mp, be64_to_cpu(leaf3->info.lsn)))
> > > >  			return __this_address;
> > > > -	} else {
> > > > -		if (leaf->hdr.info.magic != cpu_to_be16(magic))
> > > > -			return __this_address;
> > > >  	}
> > > >  
> > > >  	return xfs_dir3_leaf_check_int(mp, NULL, NULL, leaf);
> > > >  }
> > > >  
> > > >  static void
> > > > -__read_verify(
> > > > -	struct xfs_buf  *bp,
> > > > -	uint16_t	magic)
> > > > +xfs_dir3_leaf_read_verify(
> > > > +	struct xfs_buf  *bp)
> > > >  {
> > > >  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > > >  	xfs_failaddr_t		fa;
> > > > @@ -185,23 +176,22 @@ __read_verify(
> > > >  	     !xfs_buf_verify_cksum(bp, XFS_DIR3_LEAF_CRC_OFF))
> > > >  		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
> > > >  	else {
> > > > -		fa = xfs_dir3_leaf_verify(bp, magic);
> > > > +		fa = xfs_dir3_leaf_verify(bp);
> > > >  		if (fa)
> > > >  			xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> > > >  	}
> > > >  }
> > > >  
> > > >  static void
> > > > -__write_verify(
> > > > -	struct xfs_buf  *bp,
> > > > -	uint16_t	magic)
> > > > +xfs_dir3_leaf_write_verify(
> > > > +	struct xfs_buf  *bp)
> > > >  {
> > > >  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > > >  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> > > >  	struct xfs_dir3_leaf_hdr *hdr3 = bp->b_addr;
> > > >  	xfs_failaddr_t		fa;
> > > >  
> > > > -	fa = xfs_dir3_leaf_verify(bp, magic);
> > > > +	fa = xfs_dir3_leaf_verify(bp);
> > > >  	if (fa) {
> > > >  		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
> > > >  		return;
> > > > @@ -216,60 +206,22 @@ __write_verify(
> > > >  	xfs_buf_update_cksum(bp, XFS_DIR3_LEAF_CRC_OFF);
> > > >  }
> > > >  
> > > > -static xfs_failaddr_t
> > > > -xfs_dir3_leaf1_verify(
> > > > -	struct xfs_buf	*bp)
> > > > -{
> > > > -	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAF1_MAGIC);
> > > > -}
> > > > -
> > > > -static void
> > > > -xfs_dir3_leaf1_read_verify(
> > > > -	struct xfs_buf	*bp)
> > > > -{
> > > > -	__read_verify(bp, XFS_DIR2_LEAF1_MAGIC);
> > > > -}
> > > > -
> > > > -static void
> > > > -xfs_dir3_leaf1_write_verify(
> > > > -	struct xfs_buf	*bp)
> > > > -{
> > > > -	__write_verify(bp, XFS_DIR2_LEAF1_MAGIC);
> > > > -}
> > > > -
> > > > -static xfs_failaddr_t
> > > > -xfs_dir3_leafn_verify(
> > > > -	struct xfs_buf	*bp)
> > > > -{
> > > > -	return xfs_dir3_leaf_verify(bp, XFS_DIR2_LEAFN_MAGIC);
> > > > -}
> > > > -
> > > > -static void
> > > > -xfs_dir3_leafn_read_verify(
> > > > -	struct xfs_buf	*bp)
> > > > -{
> > > > -	__read_verify(bp, XFS_DIR2_LEAFN_MAGIC);
> > > > -}
> > > > -
> > > > -static void
> > > > -xfs_dir3_leafn_write_verify(
> > > > -	struct xfs_buf	*bp)
> > > > -{
> > > > -	__write_verify(bp, XFS_DIR2_LEAFN_MAGIC);
> > > > -}
> > > > -
> > > >  const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops = {
> > > >  	.name = "xfs_dir3_leaf1",
> > > > -	.verify_read = xfs_dir3_leaf1_read_verify,
> > > > -	.verify_write = xfs_dir3_leaf1_write_verify,
> > > > -	.verify_struct = xfs_dir3_leaf1_verify,
> > > > +	.magic = { cpu_to_be16(XFS_DIR2_LEAF1_MAGIC),
> > > > +		   cpu_to_be16(XFS_DIR3_LEAF1_MAGIC) },
> > > > +	.verify_read = xfs_dir3_leaf_read_verify,
> > > > +	.verify_write = xfs_dir3_leaf_write_verify,
> > > > +	.verify_struct = xfs_dir3_leaf_verify,
> > > >  };
> > > >  
> > > >  const struct xfs_buf_ops xfs_dir3_leafn_buf_ops = {
> > > >  	.name = "xfs_dir3_leafn",
> > > > -	.verify_read = xfs_dir3_leafn_read_verify,
> > > > -	.verify_write = xfs_dir3_leafn_write_verify,
> > > > -	.verify_struct = xfs_dir3_leafn_verify,
> > > > +	.magic = { cpu_to_be16(XFS_DIR2_LEAFN_MAGIC),
> > > > +		   cpu_to_be16(XFS_DIR3_LEAFN_MAGIC) },
> > > > +	.verify_read = xfs_dir3_leaf_read_verify,
> > > > +	.verify_write = xfs_dir3_leaf_write_verify,
> > > > +	.verify_struct = xfs_dir3_leaf_verify,
> > > >  };
> > > >  
> > > >  int
> > > > -- 
> > > > 2.17.2
> > > > 
