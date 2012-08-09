Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q79K8r6g220834 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 15:08:53 -0500
Message-ID: <502418D1.6040008@sgi.com>
Date: Thu, 09 Aug 2012 15:08:49 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfs_io: implement preadv for vectored reads
References: <1343255450-28559-1-git-send-email-david@fromorbit.com>
	<1343255450-28559-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1343255450-28559-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/25/12 17:30, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> When looking at KVM based direct IO patterns, I noticed that it was
> using preadv and pwritev, and I could not use xfs_io to simulate
> these IO patterns. Extend the pread command to be able to issue
> vectored read IO to enable use to simulate KVM style direct IO.
>
> Also document the new parameters as well as all the missing pread
> command parameters in the xfs_io(8) man page.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
  +int	vectors;
> +struct iovec *iov;
> +
> +static int
> +alloc_iovec(
> +	size_t		bsize,
> +	int		uflag,
> +	unsigned int	seed)
> +{
> +	int		i;
> +
> +	iov = calloc(vectors, sizeof(struct iovec));
> +	if (!iov)
> +		return -1;
> +
> +	buffersize = 0;
> +	for (i = 0; i<  vectors; i++) {
> +		iov[i].iov_base = memalign(pagesize, bsize);
                 ^^^^^
Okay, make sense.

> +		buffer = memalign(pagesize, bsize);
> +		if (!buffer) {
	        ^^^^^^

Here I am bit confused. Did you want to allocate to the buffer for the 
iovec case?

Thank-you,

Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
