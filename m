Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Dec 2006 10:35:57 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBEIZlqw021217
	for <xfs@oss.sgi.com>; Thu, 14 Dec 2006 10:35:50 -0800
Date: Thu, 14 Dec 2006 18:15:00 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] use vfs-defined file attribute flags
Message-ID: <20061214181500.GA13856@infradead.org>
References: <45819221.70502@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45819221.70502@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

> -#define LINUX_XFLAG_SYNC	0x00000008 /* Synchronous updates */
> -#define LINUX_XFLAG_IMMUTABLE	0x00000010 /* Immutable file */
> -#define LINUX_XFLAG_APPEND	0x00000020 /* writes to file may only append */
> -#define LINUX_XFLAG_NODUMP	0x00000040 /* do not dump file */
> -#define LINUX_XFLAG_NOATIME	0x00000080 /* do not update atime */
> +#define LINUX_XFLAG_SYNC	FS_SYNC_FL	/* Synchronous updates */
> +#define LINUX_XFLAG_IMMUTABLE	FS_IMMUTABLE_FL	/* Immutable file */
> +#define LINUX_XFLAG_APPEND	FS_APPEND_FL	/* writes may only append */
> +#define LINUX_XFLAG_NODUMP	FS_NODUMP_FL	/* do not dump file */
> +#define LINUX_XFLAG_NOATIME	FS_NOATIME_FL	/* do not update atime */

Just kill the defines completly and use the FS_ flags.

>  
>  STATIC unsigned int
>  xfs_merge_ioc_xflags(
> 
> 
> 
> 
---end quoted text---
