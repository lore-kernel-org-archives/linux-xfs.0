Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D0BC87F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 06:29:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80F4E8F8035
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 04:29:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YypcDINslDgpvIN2 for
	<xfs@oss.sgi.com>; Tue, 13 May 2014 04:29:40 -0700 (PDT)
Date: Tue, 13 May 2014 07:29:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: remove XFS_TRANS_RESERVE in collapse range
Message-ID: <20140513112930.GA53546@bfoster.bfoster>
References: <000f01cf6e3e$d4a0a800$7de1f800$@samsung.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <000f01cf6e3e$d4a0a800$7de1f800$@samsung.com>
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
To: Namjae Jeon <namjae.jeon@samsung.com>
Cc: xfs@oss.sgi.com

On Tue, May 13, 2014 at 09:03:55AM +0900, Namjae Jeon wrote:
> There is no need to dip into reserve pool. Reserve pool is used for much
> more important things. And xfs_trans_reserve will never return ENOSPC
> because punch hole is already done. If we get ENOSPC, collapse range
> will be simply failed.
> 
> Cc: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---

Looks good, thanks Namjae!

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 296160b..057f671 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1519,7 +1519,6 @@ xfs_collapse_file_space(
>  
>  	while (!error && !done) {
>  		tp = xfs_trans_alloc(mp, XFS_TRANS_DIOSTRAT);
> -		tp->t_flags |= XFS_TRANS_RESERVE;
>  		/*
>  		 * We would need to reserve permanent block for transaction.
>  		 * This will come into picture when after shifting extent into
> @@ -1529,7 +1528,6 @@ xfs_collapse_file_space(
>  		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
>  				XFS_DIOSTRAT_SPACE_RES(mp, 0), 0);
>  		if (error) {
> -			ASSERT(error == ENOSPC || XFS_FORCED_SHUTDOWN(mp));
>  			xfs_trans_cancel(tp, 0);
>  			break;
>  		}
> -- 
> 1.7.11-rc0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
