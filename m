Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Apr 2007 01:04:29 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3D84PfB010564
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 01:04:26 -0700
Date: Fri, 13 Apr 2007 08:26:15 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] remove the unnecessary word in the log message.
Message-ID: <20070413072615.GB20326@infradead.org>
References: <200704130037.AA05196@TNESG9305.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704130037.AA05196@TNESG9305.tnes.nec.co.jp>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Utako Kusaka <utako@tnes.nec.co.jp>
Cc: xfs@oss.sgi.com

On Fri, Apr 13, 2007 at 09:37:35AM +0900, Utako Kusaka wrote:
> --- linux-2.6.20-orig/fs/xfs/xfs_log_recover.c  2007-02-05 03:44:54.000000000 +0900
> +++ linux-2.6.20/fs/xfs/xfs_log_recover.c       2007-04-11 13:23:04.000000000 +0900
> @@ -3937,8 +3937,7 @@ xlog_recover(
>  		 * under the vfs layer, so we can get away with it unless
>  		 * the device itself is read-only, in which case we fail.
>  		 */
> -		if ((error = xfs_dev_is_read_only(log->l_mp,
> -						"recovery required"))) {
> +		if ((error = xfs_dev_is_read_only(log->l_mp, "recovery"))) {
>  			return error;
>  		}

Looks good.  (And gets rid of an ugly line-break, nice)
