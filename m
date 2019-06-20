Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43154 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725905AbfFTTIq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jun 2019 15:08:46 -0400
Subject: Re: [PATCH 02/12] libfrog: cvt_u64 should use strtoull, not strtoll
References: <156104936953.1172531.2121427277342917243.stgit@magnolia>
 <156104938235.1172531.7192571581132527840.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2d5f3961-409f-c73c-4d25-c1aa131a556a@sandeen.net>
Date: Thu, 20 Jun 2019 14:08:44 -0500
MIME-Version: 1.0
In-Reply-To: <156104938235.1172531.7192571581132527840.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:49 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> cvt_u64 converts a string to an unsigned 64-bit number, so it should use
> strtoull, not strtoll because we don't want negative numbers here.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  libfrog/convert.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/libfrog/convert.c b/libfrog/convert.c
> index 62397507..8d4d4077 100644
> --- a/libfrog/convert.c
> +++ b/libfrog/convert.c
> @@ -105,14 +105,14 @@ cvt_s16(
>   */
>  uint64_t
>  cvt_u64(
> -	char		*s,
> -	int		base)
> +	char			*s,
> +	int			base)
>  {
> -	long long	i;
> -	char		*sp;
> +	unsigned long long	i;
> +	char			*sp;
>  
>  	errno = 0;
> -	i = strtoll(s, &sp, base);
> +	i = strtoull(s, &sp, base);
>  	/*
>  	 * If the input would over or underflow, return the clamped
>  	 * value and let the user check errno.  If we went all the
> 
