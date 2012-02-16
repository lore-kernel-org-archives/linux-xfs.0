Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GL8kad019108 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 15:08:46 -0600
Date: Thu, 16 Feb 2012 15:08:49 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 10/12] xfs: shared code for grant head wakeups
Message-ID: <20120216210849.GY7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141435.299712663@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141435.299712663@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Replace xlog_reserveq_wake() and xlog_writeq_wake() with
xlog_grant_head_wake(), which takes a struct xlog_grant_head.

On Mon, Dec 12, 2011 at 09:13:57AM -0500, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_log.c   |   50 ++++++++++++++++++++------------------------------
>  fs/xfs/xfs_trace.h |    1 -
>  2 files changed, 20 insertions(+), 31 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2011-12-11 21:31:10.580621915 +0100
> +++ xfs/fs/xfs/xfs_log.c	2011-12-11 21:32:08.763640044 +0100
> @@ -171,49 +171,39 @@ xlog_grant_head_wake_all(
>  	spin_unlock(&head->lock);
>  }
>  
> -STATIC bool
> -xlog_reserveq_wake(
> +static inline int
> +xlog_ticket_reservation(
>  	struct log		*log,
> -	int			*free_bytes)
> +	struct xlog_grant_head	*head,
> +	struct xlog_ticket	*tic)
>  {
> -	struct xlog_ticket	*tic;
> -	int			need_bytes;
> -
> -	list_for_each_entry(tic, &log->l_reserve_head.waiters, t_queue) {
> +	if (head == &log->l_write_head) {

Maybe it would be better to test a bit in the xlog_grant_head.  You
certainly have space since they are cacheline aligned... or take a bool
or flag to test.

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
