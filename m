Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5415dCj189984 for <xfs@oss.sgi.com>; Thu, 3 Jun 2010 20:05:39 -0500
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1F6C63934C6
	for <xfs@oss.sgi.com>; Thu,  3 Jun 2010 18:08:05 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id s0m2Xpb3foFjnJMY for
	<xfs@oss.sgi.com>; Thu, 03 Jun 2010 18:08:05 -0700 (PDT)
Message-ID: <4C085289.9040000@cn.fujitsu.com>
Date: Fri, 04 Jun 2010 09:10:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/6] writeback: initial tracing support
References: <1275609328-12514-1-git-send-email-david@fromorbit.com>
	<1275609328-12514-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1275609328-12514-2-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

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

Should use strlcpy() ?

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
> +TRACE_EVENT(writeback_sched,
> +
> +	TP_PROTO(struct backing_dev_info *bdi, struct bdi_work *work,
> +		 const char *msg),
> +
> +	TP_ARGS(bdi, work, msg),
> +
> +	TP_STRUCT__entry(
> +		__array(char,			name,		16)
> +		__field(unsigned int,		work)
> +		__array(char,			task,		8)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name, dev_name(bdi->dev), 16);

ditto

> +		__entry->work = (unsigned long) work & 0xffff;
> +		snprintf(__entry->task, 8, "%s", msg);
> +	),
> +
> +	TP_printk("work=%x, task=%s", __entry->work, __entry->task)
> +);

...

> +TRACE_EVENT(writeback_bdi_register,
> +
> +	TP_PROTO(const char *name, int start),
> +
> +	TP_ARGS(name, start),
> +
> +	TP_STRUCT__entry(
> +		__array(char,	name,		16)
> +		__field(int,	start)
> +	),
> +
> +	TP_fast_assign(
> +		strncpy(__entry->name, name, 16);

ditto

> +		__entry->start = start;
> +	),
> +
> +	TP_printk("%s: %s", __entry->name,
> +			__entry->start ? "registered" : "unregistered")
> +);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
