Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4RLUoot165693 for <xfs@oss.sgi.com>; Thu, 27 May 2010 16:30:51 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3541C10A3909
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 14:35:05 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	Nry2Lxay0Oe7HyiH for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 14:35:05 -0700 (PDT)
Date: Thu, 27 May 2010 14:32:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] writeback: initial tracing support
Message-Id: <20100527143233.836b2c47.akpm@linux-foundation.org>
In-Reply-To: <1274784852-30502-2-git-send-email-david@fromorbit.com>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-2-git-send-email-david@fromorbit.com>
Mime-Version: 1.0
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
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue, 25 May 2010 20:54:07 +1000
Dave Chinner <david@fromorbit.com> wrote:

> From: From: Jens Axboe <jens.axboe@oracle.com>
> 
> Trace queue/sched/exec parts of the writeback loop.

It would be most useful if this patchset's description provided sample
tracing output, so we can see what the patch is actually providing us.

> -#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
> -
> -/*
> - * We don't actually have pdflush, but this one is exported though /proc...
> - */
> -int nr_pdflush_threads;
> -
>  /*
>   * Passed into wb_writeback(), essentially a subset of writeback_control
>   */
> @@ -63,6 +57,16 @@ struct bdi_work {
>  	unsigned long state;		/* flag bits, see WS_* */
>  };
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/writeback.h>
> +
> +#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)

Could/should be implemented in C.

> +/*
> + * We don't actually have pdflush, but this one is exported though /proc...
> + */
> +int nr_pdflush_threads;

So this is always zero now?

We don't want to keep it forever.  Add a
printk_once("nr_pdflush_threads is deprecated") when someone reads it,
remove it in 2014.

>
> ...
>
> --- /dev/null
> +++ b/include/trace/events/writeback.h
> @@ -0,0 +1,171 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM writeback
> +
> +#if !defined(_TRACE_WRITEBACK_H) || defined(TRACE_HEADER_MULTI_READ)

Seems wrong.  If you define TRACE_HEADER_MULTI_READ then include this
header twice, things explode.  Which negates the purpose of
_TRACE_WRITEBACK_H.

> +#define _TRACE_WRITEBACK_H
> +
> +#include <linux/backing-dev.h>
> +#include <linux/writeback.h>
> +
> +TRACE_EVENT(writeback_queue,
> +
> +	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_args *args),
> +
> +	TP_ARGS(bdi, args),
> +
> +	TP_STRUCT__entry(
> +		__array(char,		name,		16)
> +		__field(long,		nr_pages)
> +		__field(int,		sb)
> +		__field(int,		sync_mode)
> +		__field(int,		for_kupdate)
> +		__field(int,		range_cyclic)
> +		__field(int,		for_background)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name, dev_name(bdi->dev), 16);
> +		__entry->nr_pages	= args->nr_pages;
> +		__entry->sb		= !!args->sb;
> +		__entry->for_kupdate	= args->for_kupdate;
> +		__entry->range_cyclic	= args->range_cyclic;
> +		__entry->for_background	= args->for_background;
> +	),
> +
> +	TP_printk("%s: pages=%ld, sb=%d, kupdate=%d, range_cyclic=%d "
> +		  "for_background=%d", __entry->name, __entry->nr_pages,
> +			__entry->sb, __entry->for_kupdate,
> +			__entry->range_cyclic, __entry->for_background)
> +);
> +

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
