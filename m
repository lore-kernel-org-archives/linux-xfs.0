Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42936 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdF3QqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Jun 2017 12:46:01 -0400
Date: Fri, 30 Jun 2017 09:45:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Check for m_errortag initialization in
 xfs_errortag_test
Message-ID: <20170630164556.GM5874@birch.djwong.org>
References: <20170630130301.32264-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630130301.32264-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 30, 2017 at 03:03:01PM +0200, Carlos Maiolino wrote:
> While adding error injection into IO completion, I notice the lack of
> initialization check in xfs_errortag_test(), make the error injection
> mechanism unable to be used there.
> 
> IO completion is executed a few times before the error injection
> mechanism is initialized, so to be safer, make xfs_errortag_test() check
> if the errortag is properly initialized.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Ahah, hadn't realized that.  Looks good,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_error.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 26c32bc..2f4feb9 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -233,6 +233,17 @@ xfs_errortag_test(
>  {
>  	unsigned int		randfactor;
>  
> +	/*
> +	 * To be able to use error injection anywhere, we need to ensure error
> +	 * injection mechanism is already initialized.
> +	 *
> +	 * Code paths like I/O completion can be called before the
> +	 * initialization is complete, but be able to inject errors in such
> +	 * places is still useful.
> +	 */
> +	if (!mp->m_errortag)
> +		return false;
> +
>  	ASSERT(error_tag < XFS_ERRTAG_MAX);
>  	randfactor = mp->m_errortag[error_tag];
>  	if (!randfactor || prandom_u32() % randfactor)
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
