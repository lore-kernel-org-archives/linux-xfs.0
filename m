Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 70B0D29DF9
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 11:22:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAEF4AC007
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 09:22:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id MVlFWojN3D1v4tht (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 09:22:34 -0800 (PST)
Date: Mon, 2 Dec 2013 09:22:33 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/15] mkfs: merge getnum
Message-ID: <20131202172233.GD28630@infradead.org>
References: <1385689430-10103-1-git-send-email-david@fromorbit.com>
	<1385689430-10103-13-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385689430-10103-13-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 12:43:47PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> getnum() is now only called by getnum_checked(). Move the two
> together into a single getnum() function and change all the callers
> back to getnum().

So we now have two different getnums in mkfs now.  Maybe the one in
proto.c should have a different name? 

> +static long long
> +getnum(
> +	const char	*str,
> +	unsigned int	blksize,
> +	unsigned int	sectsize,
> +	bool		convert)
> +{
> +	long long	i;
> +	char		*sp;
> +
> +	if (convert)
> +		return cvtnum(blksize, sectsize, str);

Also the whole if convert is true sillyness lives on here.  The caller
that wants cvtnum should just call it directly.

> +	else {
> +		char		*sp;
> +
> +		c = strtoll(str, &sp, 0);
> +		if (c == 0 && sp == str)
> +			illegal_option(str, opts, index);
> +		if (*sp != '\0')
> +			illegal_option(str, opts, index);
> +	}

And given that the strtoll wrapping code is the same for both getnums
I suspect we shoud just have a mkfs_strtoll that gets called here,
and directly by the proto.c callers.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
