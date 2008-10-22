Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 03:10:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MAA1pu022318
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 03:10:02 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EBD714576CE
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 03:11:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 2JC0yQVaGxDFWMfA for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 03:11:47 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1Ksags-0007Et-Ef
	for xfs@oss.sgi.com; Wed, 22 Oct 2008 10:11:46 +0000
Date: Wed, 22 Oct 2008 06:11:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Handle ENOMEM during log initialisation
Message-ID: <20081022101146.GA11313@infradead.org>
References: <20081022061002.GG18495@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022061002.GG18495@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Oct 22, 2008 at 05:10:02PM +1100, Dave Chinner wrote:
> XFS: handle memory allocation failures during log initialisation
> 
> When there is no memory left in the system, xfs_buf_get_noaddr()
> can fail. If this happens at mount time during xlog_alloc_log()
> we fail to catch the error and oops.
> 
> Catch the error from xfs_buf_get_noaddr(), and allow other memory
> allocations to fail and catch those errors too. Report the error
> to the console and fail the mount with ENOMEM.
> 
> Tested by manually injecting errors into xfs_buf_get_noaddr() and
> xlog_alloc_log().
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_log.c |   38 ++++++++++++++++++++++++++++++++++++--
>  1 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 5184017..1dfa5fe 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c

> -	log = (xlog_t *)kmem_zalloc(sizeof(xlog_t), KM_SLEEP);
> +	log = (xlog_t *)kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);

You might want to remove the cast when you touch that line anyway.

>  	for (i=0; i < log->l_iclog_bufs; i++) {
>  		*iclogp = (xlog_in_core_t *)
> -			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
> +			  kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);

Same here.


Modulo those nitpicks this looks good.
