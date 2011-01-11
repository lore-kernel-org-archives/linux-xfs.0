Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BLgYMm114666 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 15:42:34 -0600
Subject: Re: [PATCH 5/8] xfs: split direct IO write path from
	xfs_file_aio_write
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294702668-15216-6-git-send-email-david@fromorbit.com>
References: <1294702668-15216-1-git-send-email-david@fromorbit.com>
	<1294702668-15216-6-git-send-email-david@fromorbit.com>
Date: Tue, 11 Jan 2011 15:44:14 -0600
Message-ID: <1294782254.3115.11.camel@doink>
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

On Tue, 2011-01-11 at 10:37 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current xfs_file_aio_write code is a mess of locking shenanigans
> to handle the different locking requirements of buffered and direct
> IO. Start to clean this up by disentangling the direct IO path from
> the mess.
> 
> This also removes the failed direct IO fallback path to buffered IO.
> XFS handles all direct IO cases without needing to fall back to
> buffered IO, so we can safely remove this unused path. This greatly
> simplifies the logic and locking needed in the write path.

I reviewed this before, and your statement here
now explains the important change you made about
the dead code for falling back to buffered I/O.

So:

Reviewed-by: Alex Elder <aelder@sgi.com>

I think Christoph and I have signed off on all eight
of the patches in this series now.

					-Alex

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
