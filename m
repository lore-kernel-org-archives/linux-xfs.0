Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35906 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbcL2OmK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Dec 2016 09:42:10 -0500
Received: by mail-io0-f173.google.com with SMTP id h133so117017250ioe.3
        for <linux-xfs@vger.kernel.org>; Thu, 29 Dec 2016 06:42:10 -0800 (PST)
Subject: Re: [PATCH] xfs: don't print warnings when xfs_log_force fails
References: <1482999799-11776-1-git-send-email-hch@lst.de>
 <1482999799-11776-2-git-send-email-hch@lst.de>
From: Alex Elder <elder@ieee.org>
Message-ID: <d7b252bb-c5f8-eb18-b87e-73e8cbb81883@ieee.org>
Date: Thu, 29 Dec 2016 08:42:08 -0600
MIME-Version: 1.0
In-Reply-To: <1482999799-11776-2-git-send-email-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 12/29/2016 02:23 AM, Christoph Hellwig wrote:
> There are only two reasons for xfs_log_force / xfs_log_force_lsn to fail:
> one is an I/O error, for which xlog_bdstrat already logs a warning, and
> the second is an already shutdown log due to a previous I/O errors.  In
> the latter case we'll already have a previous indication for the actual
> error, but the large stream of misleading warnings from xfs_log_force
> will probably scroll it out of the message buffer.
> 
> Simply removing the warnings thus makes the XFS log reporting significantly
> better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This sounds like a good idea, though I haven't really reviewed
the code itself.  But I'd say a one line comment indicating why
errors from _xfs_log_force() are being ignored might be good.

					-Alex

> ---
>  fs/xfs/xfs_log.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index c39ac14..b1469f0 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3317,12 +3317,8 @@ xfs_log_force(
>  	xfs_mount_t	*mp,
>  	uint		flags)
>  {
> -	int	error;
> -
>  	trace_xfs_log_force(mp, 0, _RET_IP_);
> -	error = _xfs_log_force(mp, flags, NULL);
> -	if (error)
> -		xfs_warn(mp, "%s: error %d returned.", __func__, error);
> +	_xfs_log_force(mp, flags, NULL);
>  }
>  
>  /*
> @@ -3466,12 +3462,8 @@ xfs_log_force_lsn(
>  	xfs_lsn_t	lsn,
>  	uint		flags)
>  {
> -	int	error;
> -
>  	trace_xfs_log_force(mp, lsn, _RET_IP_);
> -	error = _xfs_log_force_lsn(mp, lsn, flags, NULL);
> -	if (error)
> -		xfs_warn(mp, "%s: error %d returned.", __func__, error);
> +	_xfs_log_force_lsn(mp, lsn, flags, NULL);
>  }
>  
>  /*
> 

