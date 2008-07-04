Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 00:10:04 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6479vK1030505
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 00:09:58 -0700
Message-ID: <486DCCFD.1070007@sgi.com>
Date: Fri, 04 Jul 2008 17:10:53 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] fix compilation without CONFIG_PROC_FS
References: <20080702193630.GA19715@lst.de>
In-Reply-To: <20080702193630.GA19715@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

I'll check it in.
--Tim

Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_stats.h	2008-06-27 15:16:21.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_stats.h	2008-06-27 15:19:18.000000000 +0200
> @@ -146,11 +146,12 @@ extern void xfs_cleanup_procfs(void);
>  
>  static inline int xfs_init_procfs(void)
>  {
> -	return 0
> -};
> +	return 0;
> +}
> +
>  static inline void xfs_cleanup_procfs(void)
>  {
> -};
> +}
>  
>  #endif	/* !CONFIG_PROC_FS */
>  
> 
