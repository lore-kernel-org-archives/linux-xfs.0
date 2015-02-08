Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 765717F6B
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 15:57:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E8FFEAC001
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2015 13:57:15 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	B9pzOImaNL5wOZEE for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2015 13:57:12 -0800 (PST)
Date: Mon, 9 Feb 2015 08:57:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 04/18] xfs: introduce inode record hole mask for
	sparse inode chunks
Message-ID: <20150208215710.GC4251@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-5-git-send-email-bfoster@redhat.com>
	<20150206231615.GQ12722@dastard>
	<20150208160600.GB2927@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150208160600.GB2927@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Feb 08, 2015 at 11:06:01AM -0500, Brian Foster wrote:
> On Sat, Feb 07, 2015 at 10:16:15AM +1100, Dave Chinner wrote:
> > On Fri, Feb 06, 2015 at 02:52:51PM -0500, Brian Foster wrote:
> > > The inode btrees track 64 inodes per record, regardless of inode size.
> > > Thus, inode chunks on disk vary in size depending on the size of the
> > > inodes. This creates a contiguous allocation requirement for new inode
> > > chunks that can be difficult to satisfy on an aged and fragmented (free
> > > space) filesystem.
> > > 
> > > The inode record freecount currently uses 4 bytes on disk to track the
> > > free inode count. With a maximum freecount value of 64, only one byte is
> > > required. Convert the freecount field to a single byte and use two of
> > > the remaining 3 higher order bytes left for the hole mask field. Use
> > > the final leftover byte for the total count field.
> > > 
> > > The hole mask field tracks holes in the chunks of physical space that
> > > the inode record refers to. This facilitates the sparse allocation of
> > > inode chunks when contiguous chunks are not available and allows the
> > > inode btrees to identify what portions of the chunk contain valid
> > > inodes. The total count field contains the total number of valid inodes
> > > referred to by the record. This can also be deduced from the hole mask.
> > > The count field provides clarity and redundancy for internal record
> > > verification.
> > > 
> > > Note that both fields are initialized to zero to maintain backwards
> > > compatibility with existing filesystems (e.g., the higher order bytes of
> > > freecount are always 0). Tracking holes means that the hole mask is
> > > initialized to zero and thus remains "valid" in accordance with a
> > > non-sparse inode fs when no sparse chunks are physically allocated.
> > > Update the inode record management functions to handle the new fields
> > > and initialize to zero.
> > > 
> > > [XXX: The count field breaks backwards compatibility with !sparseinode
> > > fs. Should we reconsider the addition of total count or the idea of
> > > converting back and forth between sparse inode fs with a feature bit?]
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h       |  8 ++++++--
> > >  fs/xfs/libxfs/xfs_ialloc.c       | 12 ++++++++++--
> > >  fs/xfs/libxfs/xfs_ialloc_btree.c |  4 +++-
> > >  3 files changed, 19 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 26e5d92..6c2f1be 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -1295,13 +1295,17 @@ static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
> > >   */
> > >  typedef struct xfs_inobt_rec {
> > >  	__be32		ir_startino;	/* starting inode number */
> > > -	__be32		ir_freecount;	/* count of free inodes (set bits) */
> > > +	__be16		ir_holemask;	/* hole mask for sparse chunks */
> > > +	__u8		ir_count;	/* total inode count */
> > > +	__u8		ir_freecount;	/* count of free inodes (set bits) */
> > >  	__be64		ir_free;	/* free inode mask */
> > >  } xfs_inobt_rec_t;
> > 
> > I think I'd prefer to see a union here so that we explicitly state
> > what the difference in the on-disk format is. i.e. similar to how we
> > express the difference in long and short btree block headers.
> > 
> > struct xfs_inobt_rec {
> > 	__be32		ir_startino;	/* starting inode number */
> > 	__be32		ir_freecount;	/* count of free inodes (set bits) */
> > 	union {
> > 		struct {
> > 			__be32	ir_freecount;
> > 		} f;
> > 		struct {
> > 			__be16	ir_holemask;	/* hole mask for sparse chunks */
> > 			__u8	ir_count;	/* total inode count */
> > 			__u8	ir_freecount;	/* count of free inodes (set bits) */
> > 		} sp;
> > 	}
> > 	__be64		ir_free;	/* free inode mask */
> > };
> > 
> > This will prevent us from using the wrong method of
> > referencing/modifying the record because we now need to be explicit
> > in how we modify it...
> > 
> 
> I agree in principle. This is definitely explicit in that there are two
> variants of this structure that must be handled in a particular way.
> That said, 'sparse' and 'full' aren't quite logical differentiators
> given that we now have the ir_count field and that it is used whenever
> sparse inode support is enabled. In other words, a sparse enabled fs'
> always uses the 'sp' variant of the inobt record, regardless of whether
> the record happens to sparse.

Sure, that's fine for the in memory code, but we've always been
explicit about the disk format and marshalling to/from it,
especially in the cases where the structure on disk can have
multiple formats.

> > > @@ -82,7 +84,9 @@ xfs_inobt_update(
> > >  	union xfs_btree_rec	rec;
> > >  
> > >  	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
> > > -	rec.inobt.ir_freecount = cpu_to_be32(irec->ir_freecount);
> > > +	rec.inobt.ir_holemask = cpu_to_be16(irec->ir_holemask);
> > > +	rec.inobt.ir_count = irec->ir_count;
> > > +	rec.inobt.ir_freecount = irec->ir_freecount;
> > >  	rec.inobt.ir_free = cpu_to_be64(irec->ir_free);
> > >  	return xfs_btree_update(cur, &rec);
> > >  }
> > 
> > Hmmm - perhaps a similar set of helpers for sparse inode enabled
> > filesystems
> > 
> 
> We could do that for the insert/update helpers, but note again the
> separate helpers would not split along the lines of sparse vs full
> chunks. Even if we were to change the design such that they do, that
> would have th effect of complicating some of the subsequent code. For

I suspect it might, but I really don't like the idea of writing
fields that don't actually exist (and hence are always zero) in
the on-disk format to disk. See, for example, the v5 superblock
field writes are conditional in xfs_sb_to_disk, the v3 inode field
writes are conditional in xfs_dinode_to_disk, etc.

> example, the merge/update code currently has no reason to care about
> whether it has created a full chunk out of multiple sparse chunks. This
> would require more code to make that distinction simply to pick the
> correct api, for something that can easily be done with a simple generic
> helper. The same goes for things like the finobt, where now
> lookup/update/insert has to make distinctions depending on the type of
> inode record.

That was another thing that wasn't clear to me - does the finobt
record format change on disk? I don't think it does, as it only
holds a free count and a free inode bitmask, so it doesn't care
which bits of the chunk are allocated or not....

> An alternate approach could be to stick with the generic helpers, but
> try and tweak them to use the appropriate on-disk format depending on
> the record. Then again, how can one really identify one from the other
> in the lookup or _get_rec() scenarios?

Solving these problem was exactly why I suggested different helpers
- the btree ops structure that is chosen for the cursor is in a
place where we know what format we are using, and that avoids
needing "if (xfs_sb_version...)" checks in the helpers to determine
what format we need to use.

> > > @@ -118,6 +124,8 @@ xfs_inobt_insert_rec(
> > >  	xfs_inofree_t		free,
> > >  	int			*stat)
> > >  {
> > > +	cur->bc_rec.i.ir_holemask = 0;
> > > +	cur->bc_rec.i.ir_count = 0; /* zero for backwards compatibility */
> > >  	cur->bc_rec.i.ir_freecount = freecount;
> > >  	cur->bc_rec.i.ir_free = free;
> > >  	return xfs_btree_insert(cur, stat);
> > 
> > That would make this sort of thing very clear - this doesn't look
> > like it would work for a sparse chunk record...
> 
> Right... but this is just a plumbing patch and effectively a placeholder
> for the subsequent patches that implement the mechanism. I suppose the
> api could have been pulled back sooner into this patch, but I'd rather
> not reshuffle things just for that intermediate state. That context
> probably wasn't quite clear to me at the time.
> 
> Before I go one way or another here with regard to the on-disk data
> structure, care to take a look at the subsequent patch(es) that use
> these helpers? Patch 10 in particular pretty much sums up how these
> helpers are used for sparse inode record management.

Yup, I'll get to it.

> FWIW, comments on the generic bitmap stuff is also appreciated as that's
> another area I'm not totally convinved is done right. :)

Why use the generic bitmap stuff rather than the existing XFS code?
If that's just an in-memory change to the free mask processing, then
it can be done separately to the sparse inode functionality, and
probably should be done first in the series....

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
