Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 662DF7F7D
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 10:18:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45CAC8F8073
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 08:18:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lMynd7d9NTwNVvif (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Aug 2014 08:18:52 -0700 (PDT)
Date: Thu, 7 Aug 2014 11:18:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 04/18] xfs: introduce inode record hole mask for sparse
	inode chunks
Message-ID: <20140807151847.GC53888@bfoster.bfoster>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
	<1406211788-63206-5-git-send-email-bfoster@redhat.com>
	<20140724221453.GP20518@dastard>
	<20140728161632.GC59542@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140728161632.GC59542@bfoster.bfoster>
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

On Mon, Jul 28, 2014 at 12:16:33PM -0400, Brian Foster wrote:
> On Fri, Jul 25, 2014 at 08:14:53AM +1000, Dave Chinner wrote:
> > On Thu, Jul 24, 2014 at 10:22:54AM -0400, Brian Foster wrote:
> > > The inode btrees track 64 inodes per record, regardless of inode size.
> > > Thus, inode chunks on disk vary in size depending on the size of the
> > > inodes. This creates a contiguous allocation requirement for new inode
> > > chunks that can be difficult to satisfy on an aged and fragmented (free
> > > space) filesystem.
> > > 
> > > The inode record freecount currently uses 4 bytes on disk to track the
> > > free inode count. With a maximum freecount value of 64, only one byte is
> > > required. Convert the freecount field to a single byte and reserve two
> > > of the remaining 3 higher order bytes left to the hole mask field.
> > > 
> > > The hole mask field tracks potential holes in the chunks of physical
> > > space that the inode record refers to. This facilitates the sparse
> > > allocation of inode chunks when contiguous chunks are not available and
> > > allows the inode btrees to identify what portions of the chunk contain
> > > valid inodes.
> > > 
> > > Tracking holes means the field is initialized to zero and thus maintains
> > > backwards compatibility with existing filesystems. E.g., the higher
> > > order bytes of a counter with a max value of 64 are already initialized
> > > to 0. Update the inode record management functions to handle the new
> > > field and initialize it to zero for now.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_format.h       | 7 +++++--
> > >  fs/xfs/libxfs/xfs_ialloc.c       | 9 +++++++--
> > >  fs/xfs/libxfs/xfs_ialloc_btree.c | 4 +++-
> > >  3 files changed, 15 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > index 34d85ac..39022d9 100644
> > > --- a/fs/xfs/libxfs/xfs_format.h
> > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > @@ -221,13 +221,16 @@ static inline xfs_inofree_t xfs_inobt_maskn(int i, int n)
> > >   */
> > >  typedef struct xfs_inobt_rec {
> > >  	__be32		ir_startino;	/* starting inode number */
> > > -	__be32		ir_freecount;	/* count of free inodes (set bits) */
> > > +	__be16		ir_holemask;	/* hole mask for sparse chunks */
> > > +	__u8		ir_pad;
> > > +	__u8		ir_freecount;	/* count of free inodes (set bits) */
> > >  	__be64		ir_free;	/* free inode mask */
> > >  } xfs_inobt_rec_t;
> > 
> > might we want the number of inodes allocated in the chunk there as
> > well (i.e. in the pad field) so we can validate the holemask against
> > the number of inodes allocated in the chunk?
> > 
> 
> So you're suggesting something like this?
> 
> -	__be32		ir_freecount;	/* count of free inodes (set bits) */
> +	__be16		ir_holemask;	/* hole mask for sparse chunks */
> +	__u8		ir_count;	/* total inode count */
> +	__u8		ir_freecount;	/* count of free inodes (set bits) */
> 
> That's an interesting thought. It might make some of the code more clear
> and eliminate the need for the derivation of that value from the
> holemask (beyond for validation purposes). I do like the extra
> validation and potential debug use given the holemask is not quite as
> human friendly as the free mask in terms of having a bit per inode.
> 
> As long as there isn't any concern over reserving this space for
> something else down the road (I suspect not, since the pad is introduced
> by this feature), I'll look to use it as an inode count.
> 

The ir_count field along with changing the way we handle the feature bit
to be fixed rather than dynamic introduces an interesting design point
with regard to backwards compatibility.

The feature bit is now fixed at mkfs time and we have an assumption that
it could be removed via some userspace mechanism (e.g., repair,
xfs_admin, etc.). To do that safely, the mechanism requires some kind of
verification that sparse inode chunks do not exist, either as part of
the repair tracking or some kind of new counter somewhere that xfs_admin
could refer to.

The ir_count field helps with verification of the holemask and
simplifies calculation of a "real" inode count for such records (e.g.,
for bulkstat). We could set ir_count only for inode records that are
sparse, but that seems slightly unfortunate if we expect this record
format to eventually be default. Alternatively (and what I have in my
tree at the moment), we can use ir_count unconditionally so long as the
feature bit is set. That obviously breaks the backwards compatibility of
the record format since this is a higher order byte of ir_freecount on
older kernels.

So if the feature bit is mkfs time and there is no intent to enable it
thereafter, it seems there isn't much benefit to record backwards
compatibility. If we go that route, perhaps it's better to have an
ir_alloc field or some such instead of ir_holemask, invert the bits and
eliminate that bit of complexity. On the flipside, limiting usage of
ir_count and retaining ir_holemask in its current form leaves open the
possibility for enabling sparse inode chunks without a reformat (given
certain requirements, e.g., a v5 superblock). Thoughts?

Brian

> Brian
> 
> > -Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
