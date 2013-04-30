Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 53BF37F3F
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 02:29:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DBA29AC001
	for <xfs@oss.sgi.com>; Tue, 30 Apr 2013 00:28:58 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	2nvmdOG27dsgImFc for <xfs@oss.sgi.com>;
	Tue, 30 Apr 2013 00:28:56 -0700 (PDT)
Date: Tue, 30 Apr 2013 17:28:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/22] xfs: add buffer types to directory and attribute
	buffers
Message-ID: <20130430072855.GG23072@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<1364965892-19623-20-git-send-email-david@fromorbit.com>
	<20130426190953.GH29359@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130426190953.GH29359@sgi.com>
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

On Fri, Apr 26, 2013 at 02:09:53PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Wed, Apr 03, 2013 at 04:11:29PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add buffer types to the buffer log items so that log recovery can
> > validate the buffers and calculate CRCs correctly after the buffers
> > are recovered.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Comments below.
.....
> > +		struct xfs_da_blkinfo	*info = (*bpp)->b_addr;
> > +		int			type;
> > +
> > +		switch (be16_to_cpu(info->magic)) {
> > +		case XFS_DA3_NODE_MAGIC:
> > +		case XFS_DA_NODE_MAGIC:
> 
> Nit:  
> 		case XFS_DA_NODE_MAGIC:
> 		case XFS_DA3_NODE_MAGIC:

Fixed.

> > +		case XFS_ATTR3_LEAF_MAGIC:
> > +			type = XFS_BLF_ATTR_LEAF_BUF;
> > +			break;
> > +		case XFS_DIR2_LEAFN_MAGIC:
> > +		case XFS_DIR3_LEAFN_MAGIC:
> > +			type = XFS_BLF_DIR_LEAFN_BUF;
> > +			break;
> > +		default:
> > +			type = 0;
> > +			ASSERT(0);
> > +			break;
> 
> Would some kind of shutdown be desireable here?  Maybe not.

We've already run the buffer verification callbacks at this point,
so if the magic number is not one of the types in the above case
statement then we should have an EFSCORRUPTED error and no buffer.
It's a "can't happen" case, and hence the assert. If it happens on a
production system, then we don't know what the type is so just let
it go so the caller can fail the buffer appropriately....

> > @@ -2004,19 +1960,169 @@ xlog_recover_do_reg_buffer(
> >  		bp->b_ops = &xfs_inode_buf_ops;
> >  		break;
> >  	case XFS_BLF_SYMLINK_BUF:
> > -		if (*(__be32 *)bp->b_addr != cpu_to_be32(XFS_SYMLINK_MAGIC)) {
> > +		if (magic32 != XFS_SYMLINK_MAGIC) {
> >  			xfs_warn(mp, "Bad symlink block magic!");
> >  			ASSERT(0);
> >  			break;
> >  		}
> >  		bp->b_ops = &xfs_symlink_buf_ops;
> >  		break;
> 
> ...
> 
> > +	case XFS_BLF_ATTR_RMT_BUF:
> > +		if (!xfs_sb_version_hascrc(&mp->m_sb))
> > +			break;
> > +		if (magicda != XFS_ATTR3_RMT_MAGIC) {
> 		    magic32
> 
> The new remote attribute header has magic at offset 0.

Good catch. Fixed.

> > +STATIC void
> > +xlog_recover_do_reg_buffer(
> > +	struct xfs_mount	*mp,
> > +	xlog_recover_item_t	*item,
> > +	struct xfs_buf		*bp,
> > +	xfs_buf_log_format_t	*buf_f)
> > +{
> 
> ...
> 
> > +	/* Shouldn't be any more regions */
> > +	ASSERT(i == item->ri_total);
> > +
> > +	xlog_recovery_validate_buf_type(mp, bp, buf_f);
> > +
> 
> Extra line.

Fixed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
