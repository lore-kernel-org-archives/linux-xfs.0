Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1PK5RSp126084 for <xfs@oss.sgi.com>; Thu, 25 Feb 2010 14:05:27 -0600
Subject: Re: [PATCH] xfs: Non-blocking inode locking in IO completion
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1266384989-28928-1-git-send-email-david@fromorbit.com>
References: <1266384989-28928-1-git-send-email-david@fromorbit.com>
Date: Thu, 25 Feb 2010 14:06:46 -0600
Message-ID: <1267128406.1905.18.camel@doink>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 2010-02-17 at 16:36 +1100, Dave Chinner wrote:
> The introduction of barriers to DM loop devices (e.g. dm-crypt) has
> created a new IO order completion dependency that XFS does not
> handle. That is, the completion of log IOs (which have barriers) in
> the loop filesystem are now dependent on completion of data IO in
> the backing filesystem.

One comment, below

. . .

> +	if (ioend->io_type != IOMAP_READ) {
> +		error = xfs_setfilesize(ioend);
> +		ASSERT(!error || error == EAGAIN);
>  	}
> +
> +	/*
> +	 * If we didn't complete processing of the ioend, requeue it to the
> +	 * tail of the workqueue for another attempt later. Otherwise destroy
> +	 * it.
> +	 */
> +	if (error == EAGAIN) {

It's not a problem now (and may never be), but it's
conceivable error could have been set to the return
value from xfs_iomap_write_unwritten() to have value
EAGAIN.  It might have been better to include this
block inside the if (ioend->io_type != IOMAP_READ) {
block, above.

(I'll take it as is, however...)

					-Alex




> +		atomic_inc(&ioend->io_remaining);
> +		xfs_finish_ioend(ioend, 0);
> +		/* ensure we don't spin on blocked ioends */
> +		delay(1);
> +	} else
> +		xfs_destroy_ioend(ioend);
>  }
>  
>  /*



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
