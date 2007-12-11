Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 18:53:34 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBB2rPCs011039
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 18:53:29 -0800
Message-ID: <475DFC42.1080300@sgi.com>
Date: Tue, 11 Dec 2007 13:56:02 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: kill last 2.4 ifdef leftover
References: <20071130093836.GA2949@lst.de>
In-Reply-To: <20071130093836.GA2949@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs.h	2007-09-29 11:48:48.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/xfs.h	2007-09-29 11:49:03.000000000 +0200
> @@ -41,11 +41,6 @@
>  #define XFS_FILESTREAMS_TRACE 1
>  #endif
>  
> -#include <linux/version.h>
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
>  #include <linux-2.6/xfs_linux.h>
> -#else
> -#include <linux-2.4/xfs_linux.h>
> -#endif
>  
>  #endif	/* __XFS_H__ */
> 

I'll check it in. Ta.

--Tim
