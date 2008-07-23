Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 20:48:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N3mcuQ016549
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 20:48:39 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 366A9E88994
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 20:49:48 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id zgRHBsD2Je0MUjV2 for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 20:49:48 -0700 (PDT)
Message-ID: <4886AA4B.3030302@sandeen.net>
Date: Tue, 22 Jul 2008 22:49:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch] Use BIO_META tags for metadata rather than BIO_SYNC
References: <20080121041826.GB155259@sgi.com>
In-Reply-To: <20080121041826.GB155259@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> Improve metadata I/O merging in the elevator
> 
> Change all async metadata buffers to use [READ|WRITE]_META I/O types
> so that the I/O doesn't get issued immediately. This allows merging
> of adjacent metadata requests but still prioritises them over bulk
> data. This shows a 10-15% improvement in sequential create speed of
> small files.

That sounds awesome.  I'll test it on a similar workload I've been
playing with.  Lachlan reviewed this, I think - any plans to add it?

I'll run my test & post results.

Thanks,
-Eric

> Don't include the log buffers in this classification - leave them
> as sync types so they are issued immediately.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_buf.c |    6 +++++-
>  include/linux/fs.h         |    1 +
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-12-19 11:56:47.977477993 +1100
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-12-19 11:56:52.200932303 +1100
> @@ -1136,10 +1136,14 @@ _xfs_buf_ioapply(
>  	if (bp->b_flags & XBF_ORDERED) {
>  		ASSERT(!(bp->b_flags & XBF_READ));
>  		rw = WRITE_BARRIER;
> -	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
> +	} else if (bp->b_flags & XBF_LOG_BUFFER) {
>  		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
>  		bp->b_flags &= ~_XBF_RUN_QUEUES;
>  		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
> +	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
> +		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
> +		bp->b_flags &= ~_XBF_RUN_QUEUES;
> +		rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;
>  	} else {
>  		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
>  		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
> Index: 2.6.x-xfs-new/include/linux/fs.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/include/linux/fs.h	2007-12-19 01:11:16.495229881 +1100
> +++ 2.6.x-xfs-new/include/linux/fs.h	2007-12-19 11:56:52.352912667 +1100
> @@ -83,6 +83,7 @@ extern int dir_notify_enable;
>  #define READ_SYNC	(READ | (1 << BIO_RW_SYNC))
>  #define READ_META	(READ | (1 << BIO_RW_META))
>  #define WRITE_SYNC	(WRITE | (1 << BIO_RW_SYNC))
> +#define WRITE_META	(WRITE | (1 << BIO_RW_META))
>  #define WRITE_BARRIER	((1 << BIO_RW) | (1 << BIO_RW_BARRIER))
>  
>  #define SEL_IN		1
> 
> 
