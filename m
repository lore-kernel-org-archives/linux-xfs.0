Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D5C897FA9
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 17:14:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5A69304032
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 15:14:18 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3zOvdVAvnsAYfoG9 for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 15:14:17 -0800 (PST)
Message-ID: <54E51CC7.8040709@sandeen.net>
Date: Wed, 18 Feb 2015 17:14:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: Introduce permanent async buffer write IO failures
References: <1424298740-25821-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1424298740-25821-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 2/18/15 4:32 PM, Dave Chinner wrote:
>  	/*
> -	 * If the write of the buffer was synchronous, we want to make
> -	 * sure to return the error to the caller of xfs_bwrite().
> +	 * Repeated failure on an async write.
> +	 *
> +	 * Now we need to classify the error and determine the correct action to
> +	 * take. Different types of errors will require different processing,
> +	 * but make the default classification "transient" so that we keep
> +	 * retrying in these cases.  If this is the wrog thing to do, then we'll
> +	 * get reports that the filesystem hung in the presence of that type of
> +	 * error and we can take appropriate action to remedy the issue for that
> +	 * type of error.
>  	 */

So, I think this is the tricky part.

No errno has a universal meaning, and we don't know what kind of block device
we're talking to.  One device's ENOSPC may be another's EIO, and either may or
may not be permanent, maybe ENODEV *isn't* permanent.  (...is it always permanent?)

My first feeble hack at this was counting consecutive errors, and hard failing
after a set number.  Thinking about that later, it seems like something time-based
might be better than io-count-based.

Can we really simply switch on an error?  If nothing else, this might have
to be configurable somehow, so that an admin can choose which errors for
which device are desired to be "permanent."

(I think that's accurately summing up irc-and-side-channel discussions) ;)

Thanks,
-Eric

> +	switch (bp->b_error) {
> +	case ENODEV:
> +		/* permanent error, no recovery possible */
> +		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +		goto out_stale;
> +	default:
> +		/* do nothing, higher layers will retry */
> +		break;
> +	}
> +
> +	xfs_buf_relse(bp);
> +	return true;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
