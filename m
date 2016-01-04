Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D7F529DF5
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 21:58:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7228D304032
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 19:58:44 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	MIKYD4waopokCJJQ for <xfs@oss.sgi.com>;
	Sun, 03 Jan 2016 19:58:41 -0800 (PST)
Date: Mon, 4 Jan 2016 14:58:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: create helper for bmap finish & trans join in
	attr code
Message-ID: <20160104035840.GA19802@dastard>
References: <56441B8E.6070603@redhat.com> <5644BEF8.6070201@sandeen.net>
	<20151112165801.GA14854@infradead.org>
	<20151112201231.GS19199@dastard>
	<20151113090840.GA16423@infradead.org>
	<56465643.5070504@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56465643.5070504@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Nov 13, 2015 at 03:29:39PM -0600, Eric Sandeen wrote:
> On 11/13/15 3:08 AM, Christoph Hellwig wrote:
> > On Fri, Nov 13, 2015 at 07:12:31AM +1100, Dave Chinner wrote:
> >> On Thu, Nov 12, 2015 at 08:58:01AM -0800, Christoph Hellwig wrote:
> >>> I think the problem here is simply that our interfaces suck.
> >>> xfs_trans_roll really needs to rejoin any inode to the new transaction
> >>> to that was joined to the previous one.  Once we've fixed that we can
> >>> get rid of the silly committed arguments and everyone will be happy.
> >>
> >> xfs_trans_roll is not specifically for rolling transactions with
> >> locked inodes in them. We could use it for any object that needs
> >> multiple transactions to modify. e.g. we could roll transactions
> >> across an AGF (using hold+join) so that it remains locked across
> >> multiple allocation/free transactions.
> > 
> > xfs_trans_roll already logs the inode core, which requires the
> > inode to be attached to the transaction.  While I could see the
> > point of moving this out of the core __xfs_trans_roll into an
> > xfs_trans_roll_inode helper we might as well follow the current
> > interface for now.
> 
> Trying to follow you guys ;)
> 
> Something like this?

yes, something like that ;)

(better late than never!)

-Dave.

> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index dbae649..d23bce8 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -91,32 +91,32 @@ xfs_zero_extent(
>   * last due to locking considerations.  We never free any extents in
>   * the first transaction.
>   *
> - * Return 1 if the given transaction was committed and a new one
> - * started, and 0 otherwise in the committed parameter.
> + * If an inode *ip is provided, rejoin it to the transaction if
> + * the transaction was committed.
>   */
>  int						/* error */
>  xfs_bmap_finish(
>  	struct xfs_trans		**tp,	/* transaction pointer addr */
>  	struct xfs_bmap_free		*flist,	/* i/o: list extents to free */
> -	int				*committed)/* xact committed or not */
> +	xfs_inode_t			*ip)
>  {
>  	struct xfs_efd_log_item		*efd;	/* extent free data */
>  	struct xfs_efi_log_item		*efi;	/* extent free intention */
>  	int				error;	/* error return value */
> +	int				committed;/* xact committed or not */
>  	struct xfs_bmap_free_item	*free;	/* free extent item */
>  	struct xfs_bmap_free_item	*next;	/* next item on free list */
>  
>  	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> -	if (flist->xbf_count == 0) {
> -		*committed = 0;
> +	if (flist->xbf_count == 0)
>  		return 0;
> -	}
> +
>  	efi = xfs_trans_get_efi(*tp, flist->xbf_count);
>  	for (free = flist->xbf_first; free; free = free->xbfi_next)
>  		xfs_trans_log_efi_extent(*tp, efi, free->xbfi_startblock,
>  			free->xbfi_blockcount);
>  
> -	error = __xfs_trans_roll(tp, NULL, committed);
> +	error = __xfs_trans_roll(tp, ip, &committed);
>  	if (error) {
>  		/*
>  		 * If the transaction was committed, drop the EFD reference
> @@ -128,16 +128,13 @@ xfs_bmap_finish(
>  		 * transaction so we should return committed=1 even though we're
>  		 * returning an error.
>  		 */
> -		if (*committed) {
> +		if (committed) {
>  			xfs_efi_release(efi);
>  			xfs_force_shutdown((*tp)->t_mountp,
>  				(error == -EFSCORRUPTED) ?
>  					SHUTDOWN_CORRUPT_INCORE :
>  					SHUTDOWN_META_IO_ERROR);
> -		} else {
> -			*committed = 1;
>  		}
> -
>  		return error;
>  	}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
