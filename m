Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLGmf9P024842 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 10:48:41 -0600
Message-ID: <494E7329.2090309@sandeen.net>
Date: Sun, 21 Dec 2008 10:47:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 9/13] fs/xfs: Remove redundant test
References: <Pine.LNX.4.64.0812211640360.9555@pc-004.diku.dk>
	<494E6846.8070800@sandeen.net>
	<Pine.LNX.4.64.0812211737180.9555@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812211737180.9555@pc-004.diku.dk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Julia Lawall <julia@diku.dk>
Cc: xfs-masters@oss.sgi.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In fs/xfs/xfs_trans_buf.c, bp is tested for being NULL just a few lines
> above.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> expression E;
> position p1,p2;
> @@
> 
> if (x@p1 == NULL || ...) { ... when forall
>    return ...; }
> ... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
> (
> x@p2 == NULL
> |
> x@p2 != NULL
> )
> 
> // another path to the test that is not through p1?
> @s exists@
> local idexpression r.x;
> position r.p1,r.p2;
> @@
> 
> ... when != x@p1
> (
> x@p2 == NULL
> |
> x@p2 != NULL
> )
> 
> @fix depends on !s@
> position r.p1,r.p2;
> expression x,E;
> statement S1,S2;
> @@
> 
> (
> - if ((x@p2 != NULL) || ...)
>   S1
> |
> - if ((x@p2 == NULL) && ...) S1
> |
> - BUG_ON(x@p2 == NULL);
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Looks good to me, thanks.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  var/julia/linuxcopy/fs/xfs/xfs_trans_buf.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/var/linuxes/linux-next/fs/xfs/xfs_trans_buf.c b/var/julia/linuxcopy/fs/xfs/xfs_trans_buf.c
> index 8ee2f8c..218829e 100644
> --- a/var/linuxes/linux-next/fs/xfs/xfs_trans_buf.c
> +++ b/var/julia/linuxcopy/fs/xfs/xfs_trans_buf.c
> @@ -307,7 +307,7 @@ xfs_trans_read_buf(
>  			return (flags & XFS_BUF_TRYLOCK) ?
>  					EAGAIN : XFS_ERROR(ENOMEM);
>  
> -		if ((bp != NULL) && (XFS_BUF_GETERROR(bp) != 0)) {
> +		if (XFS_BUF_GETERROR(bp) != 0) {
>  			xfs_ioerror_alert("xfs_trans_read_buf", mp,
>  					  bp, blkno);
>  			error = XFS_BUF_GETERROR(bp);
> @@ -315,7 +315,7 @@ xfs_trans_read_buf(
>  			return error;
>  		}
>  #ifdef DEBUG
> -		if (xfs_do_error && (bp != NULL)) {
> +		if (xfs_do_error) {
>  			if (xfs_error_target == target) {
>  				if (((xfs_req_num++) % xfs_error_mod) == 0) {
>  					xfs_buf_relse(bp);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
