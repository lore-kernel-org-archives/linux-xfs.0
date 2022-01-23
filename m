Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58309C433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Jan 2022 13:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbiAWNTL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Jan 2022 08:19:11 -0500
Received: from out20-51.mail.aliyun.com ([115.124.20.51]:48605 "EHLO
        out20-51.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbiAWNTL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jan 2022 08:19:11 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07494468|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.565865-0.00182176-0.432313;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047203;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.Mh9qlv6_1642943948;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Mh9qlv6_1642943948)
          by smtp.aliyun-inc.com(10.147.41.178);
          Sun, 23 Jan 2022 21:19:08 +0800
Date:   Sun, 23 Jan 2022 21:19:08 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v2] iogen: upgrade to fallocate
Message-ID: <Ye1VzD76z0K/oWOt@desktop>
References: <20220118182910.GC13514@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118182910.GC13514@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 18, 2022 at 10:29:10AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Update this utility to use fallocate to preallocate/reserve space to a
> file so that we're not so dependent on legacy XFS ioctls.  Fix a minor
> whitespace error while we're at it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: fix the fallocate flags for the resvsp replacement code
> ---
>  ltp/iogen.c |   34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/ltp/iogen.c b/ltp/iogen.c
> index 2b6644d5..c43cc1d0 100644
> --- a/ltp/iogen.c
> +++ b/ltp/iogen.c
> @@ -922,13 +922,21 @@ bozo!
>  	    f.l_whence = SEEK_SET;
>  	    f.l_start = 0;
>  	    f.l_len = nbytes;
> -	    
> +
>  	    /*fprintf(stderr,
>  		    "create_file: xfsctl(%d, RESVSP, { %d, %lld, %lld })\n",
>  		   fd, f.l_whence, (long long)f.l_start, (long long)f.l_len);*/
>  
>  	    /* non-zeroing reservation */
> -#ifdef XFS_IOC_RESVSP
> +#if defined(FALLOCATE)
> +	    if (fallocate(fd, FALLOC_FL_KEEP_SIZE, 0, nbytes) == -1) {

gcc warns about

iogen.c: In function 'create_file':                   
iogen.c:820:20: warning: variable 'f' set but not used [-Wunused-but-set-variable]
  820 |     struct flock64 f;                           
      |                    ^

So I replaced 'nbytes' with 'f.l_len' in above fallocate(2) call.

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
> +#if defined(FALLOCATE)
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
