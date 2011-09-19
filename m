Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JFqVrm259049 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 10:52:31 -0500
Subject: Re: [PATCH 23/27] rearrange bmapi and bmalloca structures for best
	packing
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110918204147.015140236@bombadil.infradead.org>
References: <20110918204040.266805129@bombadil.infradead.org>
	<20110918204147.015140236@bombadil.infradead.org>
Date: Mon, 19 Sep 2011 10:52:27 -0500
Message-ID: <1316447547.2941.7.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Sun, 2011-09-18 at 16:41 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-bmalloca-shrink)
> Minimise the stack overhead of the remaining stack variables and
> structures placed on the stack by packing them without holes. pahole
> is used to optimise allocation args structures, stack variables are
> done manually.
> 
> [hch: various updates while forward porting the changes]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I don't object to it, but I do comment on something
below that I think is not an improvement.  I'll
take this as-is anyway, unless you care to re-submit
it.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .

> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c	2011-09-11 08:47:11.743121736 -0400
> +++ xfs/fs/xfs/xfs_bmap.c	2011-09-11 09:05:37.706448434 -0400

. . .

> @@ -4899,19 +4886,21 @@ xfs_bmapi_write(
>  	bma.userdata = 0;
>  	bma.flist = flist;
>  	bma.firstblock = firstblock;
> +	bma.eof = n;
> +	bma.conv = !!(flags & XFS_BMAPI_CONVERT);
>  
> +	n = 0;
> +	end = bno + len;
> +	obno = bno;
>  	while (bno < end && n < *nmap) {
> -		inhole = eof || bma.got.br_startoff > bno;
> -		wasdelay = !inhole && isnullstartblock(bma.got.br_startblock);
> -
>  		/*
> -		 * First, deal with the hole before the allocated space
> -		 * that we found, if any.
> +		 * If we are past EOF, in a hole in a delayed allocation call
> +		 * the allocator to get us a real allocation first.
>  		 */
> -		if (inhole || wasdelay) {
> -			bma.eof = eof;
> -			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
> -			bma.wasdel = wasdelay;
> +		if (bma.eof || bma.got.br_startoff > bno ||
> +		    isnullstartblock(bma.got.br_startblock)) {
> +			bma.wasdel = isnullstartblock(bma.got.br_startblock) &&
> +					!bma.eof && bma.got.br_startoff <= bno;

I think this detracts from readability and simplicity
rather than adding to it.  I understand the desire to
get rid of the local variables, and I do follow what
each piece of this conditional means, but "inhole"
and "wasdelay" were actually quite nice shorthands
for what that logic represents.

>  			bma.length = len;
>  			bma.offset = bno;
>  

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
