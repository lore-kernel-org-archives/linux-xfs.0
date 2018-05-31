Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38274 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755634AbeEaROd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 May 2018 13:14:33 -0400
Date: Thu, 31 May 2018 12:14:31 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 1/4] xfs: xfs_rtword_t should be unsigned, not signed
Message-ID: <20180531171431.GA25547@redhat.com>
References: <152778442467.6891.15278589749191666547.stgit@magnolia>
 <152778443080.6891.5154502694195176365.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152778443080.6891.5154502694195176365.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 09:33:50AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> xfs_rtword_t is used for bit manipulations in the realtime bitmap file.
> Since we're performing bit shifts with this type, we don't want sign
> extension and we don't want to be left shifting negative quantities
> because that's undefined behavior.
> 
> This also shuts up these UBSAN warnings:
> UBSAN: Undefined behaviour in fs/xfs/libxfs/xfs_rtbitmap.c:833:48
> signed integer overflow:
> -2147483648 - 1 cannot be represented in type 'int'
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

looks fine.
Reviewed-by: Bill O'Donnell <billodo@redhat.com>


> ---
>  fs/xfs/libxfs/xfs_types.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 3c560695c546..ea18449bd732 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -30,7 +30,7 @@ typedef int64_t		xfs_fsize_t;	/* bytes in a file */
>  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
>  
>  typedef int32_t		xfs_suminfo_t;	/* type of bitmap summary info */
> -typedef int32_t		xfs_rtword_t;	/* word type for bitmap manipulations */
> +typedef uint32_t	xfs_rtword_t;	/* word type for bitmap manipulations */
>  
>  typedef int64_t		xfs_lsn_t;	/* log sequence number */
>  typedef int32_t		xfs_tid_t;	/* transaction identifier */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
