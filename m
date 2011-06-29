Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5T4kLx5052775 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 23:46:22 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34A393D690
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 21:46:19 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	U8BywnaO3vtBzcen for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2011 21:46:19 -0700 (PDT)
Date: Wed, 29 Jun 2011 14:46:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: replace bp->flags usage with predefined macros
Message-ID: <20110629044616.GB1026@dastard>
References: <1309308784.5505.6214.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309308784.5505.6214.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Alex Elder <aelder@sgi.com>, XFS Mailing List <xfs@oss.sgi.com>

On Tue, Jun 28, 2011 at 05:53:04PM -0700, Chandra Seetharaman wrote:
> Cleanup: Replace bp->flags usage with predefined macros.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Christoph can correct me if I'm wrong, but I'm pretty sure his long term
direction is to remove the XFS_BUF_* macros completely.

Even so, in any new code we add or modify in xfs_buf.c we tend to
open code the flags. Hence the only code there that still uses the
XFS_BUF_* macros for manipulating flags are those we haven't needed
to touch for a long time....

> ---
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index 5e68099..8b24dc4 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -470,7 +470,7 @@ _xfs_buf_find(
>  			 * continue searching to the right for an exact match.
>  			 */
>  			if (bp->b_buffer_length != range_length) {
> -				ASSERT(bp->b_flags & XBF_STALE);
> +				ASSERT(XFS_BUF_ISSTALE(bp));
>  				rbp = &(*rbp)->rb_right;
>  				continue;
>  			}
> @@ -516,7 +516,7 @@ found:
>  	 * it. We need to keep flags such as how we allocated the buffer memory
>  	 * intact here.
>  	 */
> -	if (bp->b_flags & XBF_STALE) {
> +	if (XFS_BUF_ISSTALE(bp)) {
>  		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
>  		bp->b_flags &= XBF_MAPPED | _XBF_KMEM | _XBF_PAGES;
>  	}

And this code fragment is an example of why we are open coding the
flags checks: we do non-trivial open-coded flag manipulations
in many places, and hiding the fact that state is held in b_flags
makes it harder to read the code.

That is, the code as it stands in this case makes it obvious
that that if the buffer was stale, afterwards it is not stale
because the bit was cleared from b_flags. Using the macro hides the
fact that the stale state is held in b_flags and therefore cleared
by the conditional code and that the buffer is no longer stale...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
