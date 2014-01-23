Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC6A67F98
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 15:42:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 675F1AC003
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 13:42:00 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ZNTvgsm6fCXck0ag for <xfs@oss.sgi.com>;
	Thu, 23 Jan 2014 13:41:58 -0800 (PST)
Date: Fri, 24 Jan 2014 08:41:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] repair: fix discontiguous directory block support
Message-ID: <20140123214155.GX13997@dastard>
References: <1390375033-10483-1-git-send-email-david@fromorbit.com>
	<1390375033-10483-4-git-send-email-david@fromorbit.com>
	<52E14E2A.7000902@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52E14E2A.7000902@redhat.com>
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

On Thu, Jan 23, 2014 at 12:15:22PM -0500, Brian Foster wrote:
> On 01/22/2014 02:17 AM, Dave Chinner wrote:
> > @@ -167,6 +167,14 @@ pf_read_bmbt_reclist(
> >  	xfs_bmbt_irec_t		irec;
> >  	xfs_dfilblks_t		cp = 0;		/* prev count */
> >  	xfs_dfiloff_t		op = 0;		/* prev offset */
> > +#define MAP_ARRAY_SZ 4
> > +	struct xfs_buf_map	map_array[MAP_ARRAY_SZ];
> > +	struct xfs_buf_map	*map = map_array;
> > +	int			max_extents = MAP_ARRAY_SZ;
> > +	int			nmaps = 0;;
> > +	unsigned int		len = 0;
> > +	int			ret = 0;
> > +
> 
> So if I understand correctly, the idea here is to now batch extent reads
> into buffers of the directory block size, quieting the messages
> described in the commit log.

Yes.

> > @@ -188,18 +196,60 @@ pf_read_bmbt_reclist(
> >  		cp = irec.br_blockcount;
> >  
> >  		while (irec.br_blockcount) {
> > -			unsigned int	len;
> > +			unsigned int	bm_len;
> >  
> >  			pftrace("queuing dir extent in AG %d", args->agno);
> >  
> > -			len = (irec.br_blockcount > mp->m_dirblkfsbs) ?
> > -					mp->m_dirblkfsbs : irec.br_blockcount;
> > -			pf_queue_io(args, irec.br_startblock, len, B_DIR_META);
> > -			irec.br_blockcount -= len;
> > -			irec.br_startblock += len;
> > +			if (len + irec.br_blockcount >= mp->m_dirblkfsbs) {
> > +				bm_len = mp->m_dirblkfsbs - len;
> > +				len = 0;
> > +			} else {
> > +				len += irec.br_blockcount;
> > +				bm_len = irec.br_blockcount;
> > +			}
> 
> So len represents the total length of the maps attached to the current
> array...
> 
> > +
> > +			map[nmaps].bm_bn = XFS_FSB_TO_DADDR(mp,
> > +							irec.br_startblock);
> > +			map[nmaps].bm_len = XFS_FSB_TO_BB(mp, bm_len);
> > +			nmaps++;
> > +
> > +			if (len == 0) {
> > +				pf_queue_io(args, map, nmaps, B_DIR_META);
> > +				nmaps = 0;
> > +			}
> 
> Kind of a nit, but this looks a little weird to me. The logic would be a
> bit more clear with something like:
> 
> 	if (len + irec.br_blockcount > mp->dirblkfsbs)
> 		bm_len = mp->m_dirblkfsbs - len;
> 	else
> 		bm_len = irec.br_blockcount;
> 	len += bm_len;
> 
> 	...
> 
> 	if (len == mp->dirblkfsbs) {
> 		len = 0;
> 		pf_queue_io(...)
> 	}

Yeah, that's more obvious and consistent with other code. Will fix.

> ... which then raises the question of what happens if the directory
> we're reading doesn't end with len == mp->dirblkfsbs? If so, perhaps not
> a performance regression, but it looks like we wouldn't queue the last
> I/O. Some of the directory code suggests that we fail if we don't alloc
> the dirblkfsbs block count, so maybe this doesn't happen.

That's not an issue the prefetch code needs to handle. Prefetching
is just about walking the extent tree and pulling the necessary
buffers into the cache prior to scanning them. Other code is
responsible for checking that the block count/extent map is actually
valid.

Also, if we don't prefetch a block, then when it is required later
it will be read directly. Hence not doing IO here is does not affect
the behaviour of xfs_repair at all.

> > +/*
> > + * pf_batch_read must be called with the lock locked.
> > + */
> >  static void
> >  pf_batch_read(
> >  	prefetch_args_t		*args,
> > @@ -426,8 +495,15 @@ pf_batch_read(
> >  			max_fsbno = fsbno + pf_max_fsbs;
> >  		}
> >  		while (bplist[num] && num < MAX_BUFS && fsbno < max_fsbno) {
> > -			if (which != PF_META_ONLY ||
> > -			    !B_IS_INODE(XFS_BUF_PRIORITY(bplist[num])))
> > +			/*
> > +			 * Handle discontiguous buffers outside the seek
> > +			 * optimised IO loop below.
> > +			 */
> > +			if ((bplist[num]->b_flags & LIBXFS_B_DISCONTIG)) {
> > +				pf_read_discontig(args, bplist[num]);
> > +				bplist[num] = NULL;
> 
> So we pull these out from the processing below (which appears to want to
> issue largish reads comprised of multiple buffers, via bplist). Thanks
> for the comment above pf_read_discontig().

Yes, that's right.

FYI, the concept behind the prefetch algorithm is to optimise the IO
if possible by doing a single large IO and cherry-picking the
metadata out of it rather than lots of small semi-random IOs. i.e.
use excess storage bandwidth instead of seeks to read dense
regionsof metadata. With dense enough metadata and multi-threading
this optimisation allows xfs_repair to pull in hundreds of megabytes
of metadata every second for processing and as such can keep
multiple CPUs busy even on seek-limited storage. The code is pretty
gnarly, though....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
