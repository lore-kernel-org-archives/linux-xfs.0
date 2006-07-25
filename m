Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 03:51:39 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6PAp7DW001440
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 03:51:09 -0700
Date: Tue, 25 Jul 2006 10:42:54 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: review: bump up xlog_state_do_callback loop checking
Message-ID: <20060725094254.GC29615@infradead.org>
References: <20060724155730.A2090627@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060724155730.A2090627@wobbly.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 24, 2006 at 03:57:30PM +1000, Nathan Scott wrote:
> Hi,
> 
> I started running the QA tests with an external log on a ramdisk &
> now constantly see situations where xlog_state_so_callback reports:
> 
>     Filesystem "sda2": xlog_state_do_callback: looping 10
>     Filesystem "sda2": xlog_state_do_callback: looping 20
>     Filesystem "sda2": xlog_state_do_callback: looping 10
>     Filesystem "sda2": xlog_state_do_callback: looping 10
>     Filesystem "sda2": xlog_state_do_callback: looping 10
>     Filesystem "sda2": xlog_state_do_callback: looping 20
> 
> on the system console.  Tim and I looked into this further, and remembered
> long ago list discussion on the topic, after others reported this too (also
> on ramdisks interestingly):
> http://oss.sgi.com/archives/xfs/2005-02/msg00108.html
> http://oss.sgi.com/archives/xfs/2005-02/msg00109.html
> 
> So, it seems Glen added this to try detect infinte loops on systems where
> we do log callback processing in interrupt context (i.e. IRIX).  It seems
> that with ramdisks its causing spurious warnings due to how quickly the
> completion handlers will be run (immediate, sync) though.  We can quite
> easily still keep the same infinite loop check but bump up the reporting
> threshold to something that wont happen for ramdisks/raid caches ... and
> report each several-thousand iterations instead of each tenth one.  It
> does still seems worthwhile to keep the infinte loop detection though, so
> at this stage I've left that in there.
> 
> Tim also insisted I optimise away the modulo operation that we do in the
> callback processing loop, while I was fixing this other issue, and he's
> pointed out an easy way to do that...

ok

> Index: xfs-linux/xfs_log.c
> ===================================================================
> --- xfs-linux.orig/xfs_log.c	2006-07-20 12:06:56.455633750 +1000
> +++ xfs-linux/xfs_log.c	2006-07-20 12:17:19.819492000 +1000
> @@ -2243,9 +2243,13 @@ xlog_state_do_callback(
>  
>  			iclog = iclog->ic_next;
>  		} while (first_iclog != iclog);
> -		if (repeats && (repeats % 10) == 0) {
> +
> +		if (repeats > 5000) {
> +			flushcnt += repeats;
> +			repeats = 0;
>  			xfs_fs_cmn_err(CE_WARN, log->l_mp,
> -				"xlog_state_do_callback: looping %d", repeats);
> +				"%s: possible infinite loop (%d iterations)",
> +				__FUNCTION__, flushcnt);
>  		}
>  	} while (!ioerrors && loopdidcallbacks);
>  
> @@ -2277,6 +2281,7 @@ xlog_state_do_callback(
>  	}
>  #endif
>  
> +	flushcnt = 0;
>  	if (log->l_iclog->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_IOERROR)) {
>  		flushcnt = log->l_flushcnt;
>  		log->l_flushcnt = 0;
> 
> 
---end quoted text---
