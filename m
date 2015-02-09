Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67C447F96
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 10:04:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05CA2AC001
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 08:04:17 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QOALhUFBfo0snaFp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 08:04:16 -0800 (PST)
Date: Mon, 9 Feb 2015 10:15:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 08/18] xfs: helpers to convert holemask to/from
	generic bitmap
Message-ID: <20150209151521.GC18336@laptop.bfoster>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-9-git-send-email-bfoster@redhat.com>
	<20150208235448.GI4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150208235448.GI4251@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 09, 2015 at 10:54:48AM +1100, Dave Chinner wrote:
> On Fri, Feb 06, 2015 at 02:52:55PM -0500, Brian Foster wrote:
> > The inobt record holemask field is a condensed data type designed to fit
> > into the existing on-disk record and is zero based (allocated regions
> > are set to 0, sparse regions are set to 1) to provide backwards
> > compatibility. This makes the type somewhat complex for use in higher
> > level inode manipulations such as individual inode allocation, etc.
> > 
> > Rather than foist the complexity of dealing with this field to every bit
> > of logic that requires inode granular information, create the
> > xfs_inobt_ialloc_bitmap() helper to convert the holemask to an inode
> > allocation bitmap. The inode allocation bitmap is inode granularity
> > similar to the inobt record free mask and indicates which inodes of the
> > chunk are physically allocated on disk, irrespective of whether the
> > inode is considered allocated or free by the filesystem. The generic
> > bitmap type requires the use of generic kernel bitmap APIs.
> > 
> > The bitmap_to_u64() helper is provided to convert the bitmap back to a
> > native 64-bit type (for native bitwise operations). This is required
> > because the generic bitmap code represents a bitmap as an array of
> > unsigned long in a little endian style (though each array value is cpu
> > order). To ensure compatibility with various word sizes and endianness',
> > bitmap_to_u64() exports the bitmap to little endian and swaps back to
> > cpu byte order.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 69 insertions(+)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index 72ade0e..fc001d9 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -39,6 +39,8 @@
> >  #include "xfs_icache.h"
> >  #include "xfs_trace.h"
> >  
> > +STATIC void
> > +xfs_inobt_ialloc_bitmap(unsigned long *, struct xfs_inobt_rec_incore *);
> 
> xfs_inobt_irec_to_allocmap() seems more appropriate for what it does.
> I'd also suggest it should be in xfs_ialloc_btree.c, too.
> 

Ok.

> >  /*
> >   * Allocation group level functions.
> > @@ -739,6 +741,73 @@ xfs_ialloc_get_rec(
> >  	return 0;
> >  }
> >  
> > +static inline uint64_t
> > +bitmap_to_u64(
> > +	const unsigned long	*bitmap,
> > +	int			nbits)
> > +{
> > +	__le64			lebitmap;
> > +
> > +	ASSERT(nbits <= 64);
> > +
> > +	/*
> > +	 * The bitmap format depends on the native word size. E.g., bit 0 could
> > +	 * land in the middle of the 64 bits on a big endian 32-bit arch (see
> > +	 * arch/powerpc/include/asm/bitops.h). To handle this, export the bitmap
> > +	 * as 64-bit little endian and convert back to native byte order.
> > +	 */
> > +	bitmap_copy_le(&lebitmap, bitmap, nbits);
> > +	return le64_to_cpu(lebitmap);
> > +}
> 
> Ok, so this is for doing logic operations on the bitmap, such as
> inverting or masking out a bunch of bits?
> 

Yes, generally to convert to inode granularity for whatever operations
require it (e.g., find a "real" free inode from ir_free).

> The first use of this function is xfs_inobt_first_free_inode(), and
> the other use is in xfs_difree_inobt() to build the mask of inodes
> in the chunk that need to be freed, and in both those cases they do
> 
> 	xfs_inobt_ialloc_bitmap(alloc, rec)
> 	allocmask = bitmap_to_u64(alloc, 64);
> 
> and the local stack bitmap is otherwise unused. So, wouldn't a
> helper like:
> 
> /*
>  * Return a host format mask of all the allocated inodes in the
>  * chunk. The bitmap format depends on the native word size (e.g.
>  * see arch/powerpc/include/asm/bitops.h) and so we have to marshall
>  * the bitmap through a defined endian conversion so that we can
>  * perform host native 64 bit logic operations on the resultant
>  * allocation mask.
>  *
>  * A bit value of 1 means the inode is allocated, a value of 0 means it
>  * is free.
>  */
> u64
> xfs_inobt_irec_to_allocmask(
> 	struct xfs_inobt_rec_incore *irec)
> {
> 	DECLARE_BITMAP(allocmap, 64),
> 	__le64			lebitmap;
> 
> 	xfs_inobt_rec_to_allocmap(&allocmap, irec);
> 	bitmap_copy_le(&lebitmap, allocmap, 64);
> 	return le64_to_cpu(lebitmap);
> }
> 

Yeah, I went back and forth with doing the conversion within the
original helper. We ultimately end up with a couple more callers that do
use the generic bitmap, but this could be helpful to those that don't.

> > +
> > +/*
> > + * Convert the inode record holemask to an inode allocation bitmap. The inode
> > + * allocation bitmap is inode granularity and specifies whether an inode is
> > + * physically allocated on disk (not whether the inode is considered allocated
> > + * or free by the fs).
> > + *
> > + * We have to be careful with regard to byte order and word size since the
> > + * generic bitmap code uses primitive types.
> 
> " a bit value of 1 means the inode is allocated, a value of 0 means
> it is free"
> 

Ok.

> > + */
> > +STATIC void
> > +xfs_inobt_ialloc_bitmap(
> > +	unsigned long			*allocbmap,
> > +	struct xfs_inobt_rec_incore	*rec)
> > +{
> > +	int				nextbit;
> > +	DECLARE_BITMAP(holemask, 16);
> > +
> > +	bitmap_zero(allocbmap, 64);
> > +
> > +	/*
> > +	 * bitmaps are represented as an array of unsigned long (each in cpu
> > +	 * byte order). ir_holemask is only 16 bits, so direct assignment is
> > +	 * safe.
> > +	 */
> > +	ASSERT(sizeof(rec->ir_holemask) <= sizeof(holemask[0]));
> 
> BUILD_BUG_ON(sizeof(rec->ir_holemask) <= sizeof(holemask[0]));
> 
> i.e. if we come across a platform where this fails, break the build
> rather than waiting for the unlikely event of someone running a
> debug kernel on that platform...
> 

I assume the logic has to be inverted, but otherwise that's probably a
better idea. Thanks.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
