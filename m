Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 02 Jul 2007 12:43:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l62JhBtL010973
	for <xfs@oss.sgi.com>; Mon, 2 Jul 2007 12:43:12 -0700
Message-ID: <468954BD.50205@sandeen.net>
Date: Mon, 02 Jul 2007 14:40:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH][XFS][resend] memory leak; allocated transaction not freed
 in xfs_inactive_free_eofblocks() in failure case.
References: <200707010116.54884.jesper.juhl@gmail.com>
In-Reply-To: <200707010116.54884.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>

Jesper Juhl wrote:
> (this is back from May 16 2007, resending since it doesn't look like 
> the patch ever made it in anywhere)
> 
> 

Weird, looks like it's in cvs...

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.699&r2=text&tr2=1.698&f=h

but not in git.

-Eric

> Fix XFS memory leak; allocated transaction not freed in xfs_inactive_free_eofblocks() in failure case.
> 
> the code allocates a transaction, but in the case where 'truncate' is
> !=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return
> an error, we'll just return from the function without dealing with the
> memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be
> orphaned/leaked - not good.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> --- 
>  fs/xfs/xfs_vnodeops.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index de17aed..32519cf 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1260,6 +1260,7 @@ xfs_inactive_free_eofblocks(
>  		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
>  				    ip->i_size);
>  		if (error) {
> +			xfs_trans_cancel(tp, 0);
>  			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  			return error;
>  		}
> 
> 
> 
