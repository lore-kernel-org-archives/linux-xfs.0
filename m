Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E98E77FFC
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 18:23:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C364E304059
	for <xfs@oss.sgi.com>; Mon,  7 Apr 2014 16:23:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	gcPoGQ2WzQQGgi9C for <xfs@oss.sgi.com>;
	Mon, 07 Apr 2014 16:23:12 -0700 (PDT)
Date: Tue, 8 Apr 2014 09:23:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/19] xfs: remove unused tp arg from
	xfs_symlink_local_to_remote()
Message-ID: <20140407232310.GD27017@dastard>
References: <1396900746-22201-1-git-send-email-sandeen@redhat.com>
	<1396900746-22201-17-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1396900746-22201-17-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 07, 2014 at 02:59:03PM -0500, Eric Sandeen wrote:
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_bmap.c           |    5 ++---
>  fs/xfs/xfs_shared.h         |    2 +-
>  fs/xfs/xfs_symlink_remote.c |    1 -
>  3 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
> index 03b6ff2..6a1e702 100644
> --- a/fs/xfs/xfs_bmap.c
> +++ b/fs/xfs/xfs_bmap.c
> @@ -919,8 +919,7 @@ xfs_bmap_local_to_extents(
>  	xfs_extlen_t	total,		/* total blocks needed by transaction */
>  	int		*logflagsp,	/* inode logging flags */
>  	int		whichfork,
> -	void		(*init_fn)(struct xfs_trans *tp,
> -				   struct xfs_buf *bp,
> +	void		(*init_fn)(struct xfs_buf *bp,
>  				   struct xfs_inode *ip,
>  				   struct xfs_ifork *ifp))
>  {

This one I disagree with - this local-to-remote change is only done
within a transaction context. The existing conversions don't require
any special operations that require logging different objects, but
the possibility exists and so we really do need to pass the
transaction structure through this API.

e.g. we really should convert the directory code over to use the
generic xfs_bmap_local_to_extents() function rather than rolling
it's own version of essentially the same thing, and that requires
passing the transaction structure through the init_fn interface.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
