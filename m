Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABEB87F3F
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 20:27:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F11F8F8037
	for <xfs@oss.sgi.com>; Wed,  4 Jun 2014 18:27:27 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	iWUkiIbke73gELku for <xfs@oss.sgi.com>;
	Wed, 04 Jun 2014 18:27:25 -0700 (PDT)
Date: Thu, 5 Jun 2014 11:26:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/16] xfs: remove redundant geometry information from
	xfs_da_state
Message-ID: <20140605012652.GC4523@dastard>
References: <1401257083-13433-1-git-send-email-david@fromorbit.com>
	<20140530233906.GL6677@dastard>
	<20140602140324.GA24196@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140602140324.GA24196@bfoster.bfoster>
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

On Mon, Jun 02, 2014 at 10:03:24AM -0400, Brian Foster wrote:
> On Sat, May 31, 2014 at 09:39:06AM +1000, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > It's carried in state->args->geo, so there's no need to duplicate it
> > and use more stack space than necessary.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
....
> > @@ -1089,14 +1089,15 @@ xfs_da3_root_join(
> >  	 * that could occur. For dir3 blocks we also need to update the block
> >  	 * number in the buffer header.
> >  	 */
> > -	memcpy(root_blk->bp->b_addr, bp->b_addr, state->blocksize);
> > +	memcpy(root_blk->bp->b_addr, bp->b_addr, state->args->geo->blksize);
> >  	root_blk->bp->b_ops = bp->b_ops;
> >  	xfs_trans_buf_copy_type(root_blk->bp, bp);
> >  	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
> >  		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
> >  		da3->blkno = cpu_to_be64(root_blk->bp->b_bn);
> >  	}
> > -	xfs_trans_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
> > +	xfs_trans_log_buf(args->trans, root_blk->bp, 0,
> > +			  state->args->geo->blksize - 1);
> 
> FYI, you've got a local args pointer in xfs_da3_root_join().

Ah, the joys of macro based replacement. I'll fix it up. ;)

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
