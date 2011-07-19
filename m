Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6JHAVwu182672 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 12:10:32 -0500
Date: Tue, 19 Jul 2011 13:10:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: encapsulate a block of debug code
Message-ID: <20110719171028.GA31088@infradead.org>
References: <201107181814.p6IIEAZm028909@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107181814.p6IIEAZm028909@stout.americas.sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 18, 2011 at 01:14:09PM -0500, Alex Elder wrote:
> Pull into a helper function some debug-only code that validates a
> xfs_da_blkinfo structure that's been read from disk.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
>  fs/xfs/xfs_da_btree.c |   31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> Index: b/fs/xfs/xfs_da_btree.c
> ===================================================================
> --- a/fs/xfs/xfs_da_btree.c
> +++ b/fs/xfs/xfs_da_btree.c
> @@ -692,6 +692,24 @@ xfs_da_join(xfs_da_state_t *state)
>  	return(error);
>  }
>  
> +#ifdef	DEBUG
> +static void
> +xfs_da_blkinfo_validate(struct xfs_da_blkinfo *blkinfo, __u16 level)

I'm not sure the name is a good one.  E.g. the forw/backw pointers
really rely on this node not having any siblings.  Which they shoudn't
have here, but that's not generally true of any blkinfo.

Otherwise looks fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
