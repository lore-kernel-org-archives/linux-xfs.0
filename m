Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A6EC433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 16 Jan 2022 07:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiAPHBi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 Jan 2022 02:01:38 -0500
Received: from out20-99.mail.aliyun.com ([115.124.20.99]:44198 "EHLO
        out20-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiAPHBi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Jan 2022 02:01:38 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07474019|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.643832-0.00146574-0.354703;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047203;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.MdoMUfu_1642316495;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.MdoMUfu_1642316495)
          by smtp.aliyun-inc.com(10.147.41.187);
          Sun, 16 Jan 2022 15:01:35 +0800
Date:   Sun, 16 Jan 2022 15:01:35 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 7/8] iogen: upgrade to fallocate
Message-ID: <YePCz96eXSb66ppd@desktop>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
 <164193784690.3008286.8689130816813600863.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164193784690.3008286.8689130816813600863.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 11, 2022 at 01:50:46PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update this utility to use fallocate to preallocate/reserve space to a
> file so that we're not so dependent on legacy XFS ioctls.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  ltp/iogen.c |   32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/ltp/iogen.c b/ltp/iogen.c
> index 2b6644d5..6c2c1534 100644
> --- a/ltp/iogen.c
> +++ b/ltp/iogen.c
> @@ -928,7 +928,15 @@ bozo!
>  		   fd, f.l_whence, (long long)f.l_start, (long long)f.l_len);*/
>  
>  	    /* non-zeroing reservation */
> -#ifdef XFS_IOC_RESVSP
> +#if defined(HAVE_FALLOCATE)
> +	    if (fallocate(fd, 0, 0, nbytes) == -1) {

Seems this is not a identical replacement for XFS_IOC_RESVSP (is that
what we want here?), as fallocate(2) here zeros space and change i_size
as well.

And from xfsctl(3), after XFS_IOC_RESVSP "The blocks are allocated, but
not zeroed, and the file size does not change." And the comments above
indicates "non-zeroing reservation" as well.

If identical replacement is not required, we could drop "non-zeroing"
part, but add FALLOC_FL_KEEP_SIZE?

Thanks,
Eryu

> +		fprintf(stderr,
> +			"iogen%s:  Could not fallocate %d bytes in file %s: %s (%d)\n",
> +			TagName, nbytes, path, SYSERR, errno);
> +		close(fd);
> +		return -1;
> +	    }
> +#elif defined(XFS_IOC_RESVSP)
>  	    if( xfsctl( path, fd, XFS_IOC_RESVSP, &f ) == -1) {
>  		fprintf(stderr,
>  			"iogen%s:  Could not xfsctl(XFS_IOC_RESVSP) %d bytes in file %s: %s (%d)\n",
> @@ -936,8 +944,7 @@ bozo!
>  		close(fd);
>  		return -1;
>  	    }
> -#else
> -#ifdef F_RESVSP
> +#elif defined(F_RESVSP)
>  	    if( fcntl( fd, F_RESVSP, &f ) == -1) {
>  		fprintf(stderr,
>  			"iogen%s:  Could not fcntl(F_RESVSP) %d bytes in file %s: %s (%d)\n",
> @@ -946,8 +953,7 @@ bozo!
>  		return -1;
>  	    }
>  #else
> -bozo!
> -#endif
> +# error Dont know how to reserve space!
>  #endif
>  	}
>  
> @@ -962,7 +968,15 @@ bozo!
>  		    (long long)f.l_len);*/
>  
>  	    /* zeroing reservation */
> -#ifdef XFS_IOC_ALLOCSP
> +#if defined(HAVE_FALLOCATE)
> +	    if (fallocate(fd, 0, sbuf.st_size, nbytes - sbuf.st_size) == -1) {
> +		fprintf(stderr,
> +			"iogen%s:  Could not fallocate %d bytes in file %s: %s (%d)\n",
> +			TagName, nbytes, path, SYSERR, errno);
> +		close(fd);
> +		return -1;
> +	    }
> +#elif defined(XFS_IOC_ALLOCSP)
>  	    if( xfsctl( path, fd, XFS_IOC_ALLOCSP, &f ) == -1) {
>  		fprintf(stderr,
>  			"iogen%s:  Could not xfsctl(XFS_IOC_ALLOCSP) %d bytes in file %s: %s (%d)\n",
> @@ -970,8 +984,7 @@ bozo!
>  		close(fd);
>  		return -1;
>  	    }
> -#else
> -#ifdef F_ALLOCSP
> +#elif defined(F_ALLOCSP)
>  	    if ( fcntl(fd, F_ALLOCSP, &f) < 0) {
>  		fprintf(stderr,
>  			"iogen%s:  Could not fcntl(F_ALLOCSP) %d bytes in file %s: %s (%d)\n",
> @@ -980,8 +993,7 @@ bozo!
>  		return -1;
>  	    }
>  #else
> -bozo!
> -#endif
> +# error Dont know how to (pre)allocate space!
>  #endif
>  	}
>  #endif
