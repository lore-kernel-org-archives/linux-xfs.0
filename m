Return-Path: <xfs-bounces@oss.sgi.com>
Message-Id: <8470E784-966F-4FFE-BA3A-D9B1A0963FB9@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0907271815060.2682@ask.diku.dk>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 10/12] fs/xfs: Correct redundant test
Date: Mon, 27 Jul 2009 11:37:13 -0500
References: <Pine.LNX.4.64.0907271815060.2682@ask.diku.dk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Julia Lawall <julia@diku.dk>
Cc: xfs-masters@oss.sgi.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


On Jul 27, 2009, at 11:15 AM, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
>
> bp was tested for NULL a few lines before, followed by a return, and  
> there
> is no intervening modification of its value.
>
> A simplified version of the semantic match that finds this problem  
> is as
> follows: (http://www.emn.fr/x-info/coccinelle/)
>
> // <smpl>
> @r exists@
> local idexpression x;
> expression E;
> position p1,p2;
> @@
>
> if (x == NULL || ...) { ... when forall
>   return ...; }
> ... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
> (
> *x == NULL
> |
> *x != NULL
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Looks good. Thanks. I'll check it in.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> ---
> fs/xfs/xfs_trans_buf.c              |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 8ee2f8c..218829e 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -307,7 +307,7 @@ xfs_trans_read_buf(
> 			return (flags & XFS_BUF_TRYLOCK) ?
> 					EAGAIN : XFS_ERROR(ENOMEM);
>
> -		if ((bp != NULL) && (XFS_BUF_GETERROR(bp) != 0)) {
> +		if (XFS_BUF_GETERROR(bp) != 0) {
> 			xfs_ioerror_alert("xfs_trans_read_buf", mp,
> 					  bp, blkno);
> 			error = XFS_BUF_GETERROR(bp);
> @@ -315,7 +315,7 @@ xfs_trans_read_buf(
> 			return error;
> 		}
> #ifdef DEBUG
> -		if (xfs_do_error && (bp != NULL)) {
> +		if (xfs_do_error) {
> 			if (xfs_error_target == target) {
> 				if (((xfs_req_num++) % xfs_error_mod) == 0) {
> 					xfs_buf_relse(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
