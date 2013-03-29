Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 22B357F83
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 22:13:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 119CE304066
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 20:13:35 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	WfgiZVQkQWuqTsjh for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 20:13:33 -0700 (PDT)
Date: Fri, 29 Mar 2013 14:13:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/21] xfs: add CRC checking to dir2 free blocks
Message-ID: <20130329031331.GI6369@dastard>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-13-git-send-email-david@fromorbit.com>
	<20130328234023.GW22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130328234023.GW22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 28, 2013 at 06:40:23PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Tue, Mar 12, 2013 at 11:30:45PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This addition follows the same pattern as the dir2 block CRCs, but
> > with a few differences. The main difference is that the free block
> > header is different between the v2 and v3 formats, so an "in-core"
> > free block header has been added and _todisk/_from_disk functions
> > used to abstract the differences in structure format from the code.
> > This is similar to the on-disk superblock versus the in-core
> > superblock setup. The in-core strucutre is populated when the buffer
> > is read from disk, all the in memory checks and modifications are
> > done on the in-core version of the structure which is written back
> > to the buffer before the buffer is logged.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Just a few nits below.
> 
> > -static void
> > -xfs_dir2_free_verify(
> > +static bool
> > +xfs_dir3_free_verify(
> >  	struct xfs_buf		*bp)
> >  {
> >  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> >  	struct xfs_dir2_free_hdr *hdr = bp->b_addr;
> > -	int			block_ok = 0;
> >  
> > -	block_ok = hdr->magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC);
> > -	if (!block_ok) {
> > -		XFS_CORRUPTION_ERROR("xfs_dir2_free_verify magic",
> > -				     XFS_ERRLEVEL_LOW, mp, hdr);
> > -		xfs_buf_ioerror(bp, EFSCORRUPTED);
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
> > +
> > +		if (hdr3->magic != be32_to_cpu(XFS_DIR3_FREE_MAGIC))
> > +			return false;
> > +		if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_uuid))
> > +			return false;
> > +		if (be64_to_cpu(hdr3->blkno) != bp->b_bn)
> > +			return false;
> > +	} else {
> > +		if (hdr->magic != be32_to_cpu(XFS_DIR2_FREE_MAGIC))
> > +			return false;
> >  	}
> > +
> > +	/* XXX: should bounds check the xfs_dir3_icfree_hdr here */
> 
> What did you have in mind?

Checking that the header fields:
	a) are within valid bounds; and
	b) match what is in the bests array.

> > -	if (!hdr) {
> > -		/* One less used entry in the free table.  */
> > -		be32_add_cpu(&free->hdr.nused, -1);
> > -		xfs_dir2_free_log_header(tp, fbp);
> >  
> > -		/*
> > -		 * If this was the last entry in the table, we can trim the
> > -		 * table size back.  There might be other entries at the end
> > -		 * referring to non-existent data blocks, get those too.
> > -		 */
> 
> You dropped this comment.  Was there something wrong with it?

No, just an oversight when rearranging the code.

> >  	/* Log the free entry that changed, unless we got rid of it.  */
> >  	if (logfree)
> >  		xfs_dir2_free_log_bests(tp, fbp, findex, findex);
> > @@ -1062,10 +1221,15 @@ xfs_dir2_leafn_remove(
> >  		if (error)
> >  			return error;
> >  		free = fbp->b_addr;
> > -		ASSERT(free->hdr.magic == cpu_to_be32(XFS_DIR2_FREE_MAGIC));
> > -		ASSERT(be32_to_cpu(free->hdr.firstdb) ==
> > -		       xfs_dir2_free_max_bests(mp) *
> > -		       (fdb - XFS_DIR2_FREE_FIRSTDB(mp)));
> > +#ifdef DEBUG
> > +	{
> > +		struct xfs_dir3_icfree_hdr freehdr;
> > +		xfs_dir3_free_hdr_from_disk(&freehdr, free);
> > +		ASSERT(be32_to_cpu(freehdr.firstdb) ==
> 
> I think freehdr.firstdb is already in cpu endianness.

Right. Well spotted. I've already posted a fix for it - sparse
endian checking picked this up. My current series folds those fixes
back into the original patches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
