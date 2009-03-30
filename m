Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2UHtGDd207540 for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 12:55:31 -0500
Date: Mon, 30 Mar 2009 13:54:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix async io error handling in fsx
Message-ID: <20090330175451.GA1041@infradead.org>
References: <1238391050-14211-1-git-send-email-felixb@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1238391050-14211-1-git-send-email-felixb@sgi.com>
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

On Mon, Mar 30, 2009 at 12:30:50AM -0500, Felix Blyakher wrote:
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -976,19 +976,41 @@ __aio_rw(int rw, int fd, char *buf, unsigned len, unsigned offset)
>  		fprintf(stderr, "errcode=%d\n", ret);
>  		fprintf(stderr, "aio_rw: io_submit failed: %s\n",
>  				strerror(ret));
> -		return(-1);
> +		errno = -ret;
> +		return -1;

I think we'd be better off having all these places that set errno in one
place and use goto labels.  That way you can also add a small comment
about it.

> +		/*
> +		 * The b0rked libaio defines event.res as signed.
> +		 * However the kernel strucuture has it unsigned,
> +		 * and it's used to pass negated error value.
> +		 * Till the library is fixed use the temp var.
> +		 */

This comment seems backwards to the patch description and the actual
code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
