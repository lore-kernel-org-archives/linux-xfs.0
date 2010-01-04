Return-Path: <xfs-bounces@oss.sgi.com>
Received: from oss.sgi.com (localhost [127.0.0.1])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id o04FJxFs124561;
	Mon, 4 Jan 2010 09:19:59 -0600
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04FJvh7124548 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 09:19:58 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C743C13D5B9
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 07:20:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pNOMjaN0Wbo8wmnR for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2010 07:20:48 -0800 (PST)
Date: Mon, 4 Jan 2010 10:20:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] XFS: Don't wake xfsbufd when idle
Message-ID: <20100104152048.GC24810@infradead.org>
References: <1262400215-19443-1-git-send-email-david@fromorbit.com>
	<1262400215-19443-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1262400215-19443-3-git-send-email-david@fromorbit.com>
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

On Sat, Jan 02, 2010 at 01:43:35PM +1100, Dave Chinner wrote:
> The xfsbufd wakes every xfsbufd_centisecs (once per second by
> default) for each filesystem even when the filesystem is idle.
> If the xfsbufd has nothing to do, put it into a long term sleep
> and only wake it up when there is work pending (i.e. dirty
> buffers to flush soon). This will make laptop power misers happy.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |   28 +++++++++++++++++++---------
>  1 files changed, 19 insertions(+), 9 deletions(-)
> 

>  STATIC int xfsbufd(void *);
> -STATIC int xfsbufd_wakeup(int, gfp_t);
> +STATIC int xfsbufd_wakeup_all(int, gfp_t);

this rename seems unrelated to the rest of the patch.

> @@ -1595,6 +1595,11 @@ xfs_buf_delwri_queue(
>  		list_del(&bp->b_list);
>  	}
>  
> +	if (list_empty(dwq)) {
> +		/* start xfsbufd as it has something to do now */
> +		wake_up_process(bp->b_target->bt_task);
> +	}

Does it make sense to wake xfsbufd before actually adding the item and
unlocking the queue lock?  Shouldn't this be defered until after the
addition?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
