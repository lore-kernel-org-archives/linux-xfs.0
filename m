Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KH69Bg071951 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 12:06:09 -0500
Subject: Re: [PATCH v2] xfsdump: enable dump header checksums
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316523954-7688-1-git-send-email-wkendall@sgi.com>
References: <1316523954-7688-1-git-send-email-wkendall@sgi.com>
Date: Tue, 20 Sep 2011 12:06:05 -0500
Message-ID: <1316538365.2912.32.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-09-20 at 08:05 -0500, Bill Kendall wrote:
> Various structures in a dump file optionally contain a checksum, but
> the code to compute and validate the checksum has not been enabled.
> The checksum code has a negligible performance impact and so this
> patch enables the checksum code unconditionally. Also:
> 
> - make sure all header sizes are multiples of 4 bytes
>   (a requirement of the checksum routine)
> - zero structures to ensure internal padding has a known value
> - fix a bug in dump_extattr_buildrecord() which checksummed
>   the wrong header structure
> - add calc_checksum() and is_checksum_valid() routines to
>   cut down on duplicate code
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

This looks good.  I have a few comments for you
below but unless you decide to send me an update
I'll use this as-is.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  common/content_inode.h |   25 ++++++++++++++
>  dump/content.c         |   85 +++++++++++-------------------------------------
>  restore/Makefile       |    2 +-
>  restore/content.c      |   40 ++--------------------
>  4 files changed, 49 insertions(+), 103 deletions(-)
> 
> diff --git a/common/content_inode.h b/common/content_inode.h
> index 479fdfc..9c2c1cc 100644
> --- a/common/content_inode.h
> +++ b/common/content_inode.h
> @@ -347,4 +347,29 @@ typedef struct extattrhdr extattrhdr_t;
>  	/* a linux "secure" mode attribute
>  	 */
>  
> +/* Routines for calculating and validating checksums on xfsdump headers.
> + * The header length must be an integral number of u_int32_t's.
> + */
> +static inline u_int32_t
> +calc_checksum(void *bufp, size_t len)
> +{
> +	u_int32_t sum = 0;
> +	u_int32_t *sump = (u_int32_t *)bufp;
> +	u_int32_t *endp = (void *)sump + len

No need to cast a (void *) object to another
pointer type (and vice-versa).

And although gcc allows arithmetic on void pointers,
it is not standard, so (char *) would be a more
portable choice.

The multiple-of-4 assumption would be well stated with
an assertion.

> ;
> +	while (sump < endp)
> +		sum += *sump++;
> +	return ~sum + 1;
> +}
> +
> +static inline bool_t
> +is_checksum_valid(void *bufp, size_t len)
> +{

. . .



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
