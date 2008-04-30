Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 00:16:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3U7Fset011083
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 00:15:56 -0700
Message-ID: <48181D04.4030902@sgi.com>
Date: Wed, 30 Apr 2008 17:17:24 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix non-debug build for xfsidbg.c
References: <20080430065937.GC108924158@sgi.com>
In-Reply-To: <20080430065937.GC108924158@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave, would the code look cleaner if iclog_bak was printed on a line by itself?
That way we wouldn't need the #else and we wouldn't be duplicating code.

David Chinner wrote:
> Make the use of l_iclog_bak conditional on debug configs.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/xfsidbg.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2008-04-30 16:47:06.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2008-04-30 16:49:33.615164895 +1000
> @@ -5845,9 +5845,14 @@ xfsidbg_xlog(xlog_t *log)
>  	kdb_printf("curr_cycle: %d  prev_cycle: %d  curr_block: %d  prev_block: %d\n",
>  	     log->l_curr_cycle, log->l_prev_cycle, log->l_curr_block,
>  	     log->l_prev_block);
> +#ifdef DEBUG
>  	kdb_printf("iclog_bak: 0x%p  iclog_size: 0x%x (%d)  num iclogs: %d\n",
>  		log->l_iclog_bak, log->l_iclog_size, log->l_iclog_size,
>  		log->l_iclog_bufs);
> +#else
> +	kdb_printf("iclog_size: 0x%x (%d)  num iclogs: %d\n",
> +		log->l_iclog_size, log->l_iclog_size, log->l_iclog_bufs);
> +#endif
>  	kdb_printf("l_iclog_hsize %d l_iclog_heads %d\n",
>  		log->l_iclog_hsize, log->l_iclog_heads);
>  	kdb_printf("l_sectbb_log %u l_sectbb_mask %u\n",
> 
