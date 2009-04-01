Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n317LfUR057550 for <xfs@oss.sgi.com>; Wed, 1 Apr 2009 02:21:56 -0500
Date: Wed, 1 Apr 2009 03:21:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix async io error handling in fsx
Message-ID: <20090401072117.GA25131@infradead.org>
References: <1238442101-24311-1-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1238442101-24311-1-git-send-email-felixb@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Mar 30, 2009 at 02:41:41PM -0500, Felix Blyakher wrote:
> The result of async io returned in the event.res in addition
> to the number of bytes read/written provides negated error
> number. The broken libaio defines event.res as unsigned
> while the same structure in the kernel defines it as signed.
> The kernel indeed treat it as signed, and returns the
> negated error number. Till libaio is fixed we provide
> the signed long temp var.
> Also set errno for each error condition in aio_rw, as the
> caller is not aio aware and expects ret(-1)+errno by the
> traditional libc convention.
> 
> Signed-off-by: Felix Blyakher <felixb@sgi.com>
> ---
>  ltp/fsx.c |   42 +++++++++++++++++++++++++++++++++++-------
>  1 files changed, 35 insertions(+), 7 deletions(-)

>  	if (len != event.res) {
> -		fprintf(stderr, "bad read length: %lu instead of %u\n",
> -				event.res, len);
> +		/*
> +		 * The b0rked libaio defines event.res as unsigned.
> +		 * However the kernel strucuture has it signed,
> +		 * and it's used to pass negated error value.
> +		 * Till the library is fixed use the temp var.
> +		 */
> +		res = (long)event.res;
> +		if (res >= 0)
> +			fprintf(stderr, "bad io length: %lu instead of %u\n",
> +					res, len);
> +		else {
> +			fprintf(stderr, "errcode=%d\n", -res);
> +			fprintf(stderr, "aio_rw: async io failed: %s\n",
> +					strerror(-res));
> +			goto out_error;
> +		}
> +
>  	}
>  	return event.res;
> +
> +out_error:
> +	/*
> +	 * The caller expects error return in traditional libc
> +	 * convention, i.e. -1 and the errno set to error.
> +	 */
> +	errno = ret <= 0 ? -ret : -res;
> +	return -1;

I wonder why this doesn't give a compiler warning.  res is only
initialized in that last branch above.  Wouldn't it be better to set
ret to res inside that branch and only use ret down here?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
