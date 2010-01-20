Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K8THGw254123 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 02:29:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B2C5E1C64CAC
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:30:18 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id aNjq9CrAfstpAX27 for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2010 00:30:18 -0800 (PST)
Date: Wed, 20 Jan 2010 03:30:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] xfstests: fix printf format warnings in aio-stress.c
Message-ID: <20100120083018.GD6721@infradead.org>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
	<1263958688-435-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263958688-435-5-git-send-email-david@fromorbit.com>
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

> diff --git a/ltp/aio-stress.c b/ltp/aio-stress.c
> index ab9e006..57a2158 100644
> --- a/ltp/aio-stress.c
> +++ b/ltp/aio-stress.c
> @@ -1167,9 +1167,9 @@ restart:
>  
>      if (t->stage_mb_trans && t->num_files > 0) {
>          double seconds = time_since_now(&stage_time);
> -	fprintf(stderr, "thread %d %s totals (%.2f MB/s) %.2f MB in %.2fs\n", 
> -	        t - global_thread_info, this_stage, t->stage_mb_trans/seconds, 
> -		t->stage_mb_trans, seconds);
> +	fprintf(stderr, "thread %llu %s totals (%.2f MB/s) %.2f MB in %.2fs\n",
> +	        (unsigned long long)(t - global_thread_info), this_stage,
> +		t->stage_mb_trans/seconds, t->stage_mb_trans, seconds);

Differences between two pointers in C99 is a ptrdiff_t.  Probably not
worth searching the printf sepcifier for it and just casting it up, so
ok.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
