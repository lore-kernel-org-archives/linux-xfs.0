Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q632Z06r043407 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 21:35:00 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ByiTBoR3shNyqAW5 for
	<xfs@oss.sgi.com>; Mon, 02 Jul 2012 19:34:59 -0700 (PDT)
Date: Mon, 2 Jul 2012 22:34:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 1/3] block: add sysfs entry for
	discard_alignment
Message-ID: <20120703023442.GB3586@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
	<1341235225-27551-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1341235225-27551-2-git-send-email-pbonzini@redhat.com>
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
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: axboe@kernel.dk, martin.petersen@oracle.com, snitzer@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, hch@lst.de

On Mon, Jul 02, 2012 at 03:20:23PM +0200, Paolo Bonzini wrote:
> The next patches will actually use the alignment, expose it in sysfs
> for ease of debugging.
> 

Don't we already have discard_alignment exported as device attribute.

/sys/block/<dev>/discard_alignment

Thanks
Vivek

> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  block/blk-sysfs.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index aa41b47..95e919c 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -146,6 +146,11 @@ static ssize_t queue_io_opt_show(struct request_queue *q, char *page)
>  	return queue_var_show(queue_io_opt(q), page);
>  }
>  
> +static ssize_t queue_discard_alignment_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(q->limits.discard_alignment, page);
> +}
> +
>  static ssize_t queue_discard_granularity_show(struct request_queue *q, char *page)
>  {
>  	return queue_var_show(q->limits.discard_granularity, page);
> @@ -343,6 +348,11 @@ static struct queue_sysfs_entry queue_io_opt_entry = {
>  	.show = queue_io_opt_show,
>  };
>  
> +static struct queue_sysfs_entry queue_discard_alignment_entry = {
> +	.attr = {.name = "discard_alignment", .mode = S_IRUGO },
> +	.show = queue_discard_alignment_show,
> +};
> +
>  static struct queue_sysfs_entry queue_discard_granularity_entry = {
>  	.attr = {.name = "discard_granularity", .mode = S_IRUGO },
>  	.show = queue_discard_granularity_show,
> @@ -403,6 +413,7 @@ static struct attribute *default_attrs[] = {
>  	&queue_io_min_entry.attr,
>  	&queue_io_opt_entry.attr,
>  	&queue_discard_granularity_entry.attr,
> +	&queue_discard_alignment_entry.attr,
>  	&queue_discard_max_entry.attr,
>  	&queue_discard_zeroes_data_entry.attr,
>  	&queue_nonrot_entry.attr,
> -- 
> 1.7.1
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
