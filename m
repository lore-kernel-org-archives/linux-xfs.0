Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42180 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfFTS6q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 14:58:46 -0400
Subject: Re: [PATCH 01/12] libfrog: don't set negative errno in conversion
 functions
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104937602.1172531.10936665245404210667.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2bf07013-3f5b-a9cb-b593-b4355ef46586@sandeen.net>
Date: Thu, 20 Jun 2019 13:58:44 -0500
MIME-Version: 1.0
In-Reply-To: <156104937602.1172531.10936665245404210667.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:49 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Don't set errno to a negative value when we're converting integers.
> That's a kernel thing; this is userspace.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

<Doge stare>

and it's also "errno" fercryingoutloud ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libfrog/convert.c |   12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/libfrog/convert.c b/libfrog/convert.c
> index ed4cae7f..62397507 100644
> --- a/libfrog/convert.c
> +++ b/libfrog/convert.c
> @@ -47,7 +47,7 @@ cvt_s64(
>  		return i;
>  
>  	/* Not all the input was consumed, return error. */
> -	errno = -ERANGE;
> +	errno = ERANGE;
>  	return INT64_MIN;
>  }
>  
> @@ -68,7 +68,7 @@ cvt_s32(
>  	if (errno)
>  		return i;
>  	if (i > INT32_MAX || i < INT32_MIN) {
> -		errno = -ERANGE;
> +		errno = ERANGE;
>  		return INT32_MIN;
>  	}
>  	return i;
> @@ -91,7 +91,7 @@ cvt_s16(
>  	if (errno)
>  		return i;
>  	if (i > INT16_MAX || i < INT16_MIN) {
> -		errno = -ERANGE;
> +		errno = ERANGE;
>  		return INT16_MIN;
>  	}
>  	return i;
> @@ -123,7 +123,7 @@ cvt_u64(
>  		return i;
>  
>  	/* Not all the input was consumed, return error. */
> -	errno = -ERANGE;
> +	errno = ERANGE;
>  	return UINT64_MAX;
>  }
>  
> @@ -144,7 +144,7 @@ cvt_u32(
>  	if (errno)
>  		return i;
>  	if (i > UINT32_MAX) {
> -		errno = -ERANGE;
> +		errno = ERANGE;
>  		return UINT32_MAX;
>  	}
>  	return i;
> @@ -167,7 +167,7 @@ cvt_u16(
>  	if (errno)
>  		return i;
>  	if (i > UINT16_MAX) {
> -		errno = -ERANGE;
> +		errno = ERANGE;
>  		return UINT16_MAX;
>  	}
>  	return i;
> 
