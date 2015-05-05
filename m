Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBBDD7F47
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 17:12:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 478F4AC005
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:12:47 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SLcZ4UncJmFTZE5L for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 15:12:45 -0700 (PDT)
Date: Wed, 6 May 2015 08:12:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/12] xfs:Make the function,xfs_alloc_lookup_eq static
Message-ID: <20150505221209.GG21261@dastard>
References: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
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
To: Nicholas Krause <xerofoify@gmail.com>
Cc: jack@suse.cz, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de

On Tue, May 05, 2015 at 04:16:28PM -0400, Nicholas Krause wrote:
> This makes the function,xfs_alloc_lookup_eq static as there are no
> calls to this function outside the definition file for this function,
> xfs_alloc.c.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 516162b..48de3f0 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -52,7 +52,7 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
>  /*
>   * Lookup the record equal to [bno, len] in the btree given by cur.
>   */
> -STATIC int				/* error */
> +static int				/* error */
>  xfs_alloc_lookup_eq(
>  	struct xfs_btree_cur	*cur,	/* btree cursor */
>  	xfs_agblock_t		bno,	/* starting block of extent */

Please have a look at what STATIC actually means, and then use the
sparse checker to confirm that these functions are already static
for a CONFIG_XFS_DEBUG=n build.

i.e. STATIC is a stack usage minimisation and debugging aid, not
something that is broken and needs fixing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
