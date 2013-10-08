Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E0CB77F9F
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 17:56:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AB95AC002
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 15:56:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id zwBEEqws3ebYeQR6 for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 15:56:02 -0700 (PDT)
Message-ID: <52548D80.8070807@sandeen.net>
Date: Tue, 08 Oct 2013 17:56:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 03/32] xfs: fix some minor sparse warnings
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-4-git-send-email-david@fromorbit.com>
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

On 9/29/13 10:15 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A couple of simple locking annotations and 0 vs NULL warnings.
> Nothing that changes any code behaviour, just removes build noise.

The patch is fine as it is, but it doesn't reflect the commit log.

Is part of it missing?

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/xfs_bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
> index 2d480cc..7336abf 100644
> --- a/libxfs/xfs_bmap.c
> +++ b/libxfs/xfs_bmap.c
> @@ -4415,7 +4415,7 @@ xfs_bmapi_write(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_ifork	*ifp;
> -	struct xfs_bmalloca	bma = { 0 };	/* args for xfs_bmap_alloc */
> +	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
>  	xfs_fileoff_t		end;		/* end of mapped file region */
>  	int			eof;		/* after the end of extents */
>  	int			error;		/* error return */
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
