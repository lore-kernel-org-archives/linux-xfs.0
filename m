Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AJNoBO033614 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 13:23:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 085F5250085
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:26:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id D2iYLun8JqwYyS60 for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:26:02 -0800 (PST)
Date: Mon, 10 Jan 2011 14:26:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfs: factor common write setup code
Message-ID: <20110110192602.GI25029@infradead.org>
References: <1294399825-1157-1-git-send-email-david@fromorbit.com>
	<1294399825-1157-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294399825-1157-8-git-send-email-david@fromorbit.com>
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

On Fri, Jan 07, 2011 at 10:30:24PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffered IO and direct IO write paths share a common set of
> checks and limiting code prior to issuing the write. Factor that
> into a common helper function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Alex Elder <aelder@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_file.c |  128 +++++++++++++++++++-----------------------
>  1 files changed, 58 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index 9ce5e12..d6ff7ff 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -620,6 +620,60 @@ out_lock:
>  }

> +	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|*iolock);

it seems cleaner if we left this in the caller so that locking/unlocking
is not spread over N different layers.

Either way the patch looks correct, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
