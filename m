Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBM2K6m2145538 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 20:20:06 -0600
Subject: Re: [PATCH 20/34] xfs: remove all the inodes on a buffer from the
	AIL in bulk
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1292916570-25015-21-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
	<1292916570-25015-21-git-send-email-david@fromorbit.com>
Date: Tue, 21 Dec 2010 20:20:46 -0600
Message-ID: <1292984446.2408.358.camel@doink>
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

On Tue, 2010-12-21 at 18:29 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When inode buffer IO completes, usually all of the inodes are removed from the
> AIL. This involves processing them one at a time and taking the AIL lock once
> for every inode. When all CPUs are processing inode IO completions, this causes
> excessive amount sof contention on the AIL lock.
> 
> Instead, change the way we process inode IO completion in the buffer
> IO done callback. Allow the inode IO done callback to walk the list
> of IO done callbacks and pull all the inodes off the buffer in one
> go and then process them as a batch.
> 
> Once all the inodes for removal are collected, take the AIL lock
> once and do a bulk removal operation to minimise traffic on the AIL
> lock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

One question, below.		-Alex

. . .

> @@ -861,28 +910,37 @@ xfs_iflush_done(
>  	 * the lock since it's cheaper, and then we recheck while
>  	 * holding the lock before removing the inode from the AIL.
>  	 */
> -	if (iip->ili_logged && lip->li_lsn == iip->ili_flush_lsn) {
> +	if (need_ail) {
> +		struct xfs_log_item *log_items[need_ail];

What's the worst-case value of need_ail we might see here?



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
