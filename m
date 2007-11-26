Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Nov 2007 18:13:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAQ2CsjD001439
	for <xfs@oss.sgi.com>; Sun, 25 Nov 2007 18:12:56 -0800
Message-ID: <474A2B62.20204@sgi.com>
Date: Mon, 26 Nov 2007 13:11:46 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
References: <20071122003339.GH114266761@sgi.com>
In-Reply-To: <20071122003339.GH114266761@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

> Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-11-22 10:47:21.945395328 +1100
> +++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-11-22 10:53:11.556186722 +1100
> @@ -1443,6 +1443,8 @@ xlog_sync(xlog_t		*log,
>  	XFS_BUF_ZEROFLAGS(bp);
>  	XFS_BUF_BUSY(bp);
>  	XFS_BUF_ASYNC(bp);
> +	XFS_BUF_SET_LOGBUF(bp);
> +
>  	/*
>  	 * Do an ordered write for the log block.
>  	 * Its unnecessary to flush the first split block in the log wrap case.

Whichever way you go with this one Dave you should probably add another
XFS_BUF_SET_LOGBUF() call for the buffer split case further down in the
same function.
