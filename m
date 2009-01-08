Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n08MiGls015007 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 16:44:16 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40A50726CD
	for <xfs@oss.sgi.com>; Thu,  8 Jan 2009 14:44:15 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	aEgmyd00XE7QAQca for <xfs@oss.sgi.com>;
	Thu, 08 Jan 2009 14:44:15 -0800 (PST)
Date: Fri, 9 Jan 2009 09:44:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: make xfs_ino_t an unsigned long long
Message-ID: <20090108224413.GK9448@disturbed>
References: <20090108184222.244013000@bombadil.infradead.org>
	<20090108184430.967925000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090108184430.967925000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Jan 08, 2009 at 01:42:25PM -0500, Christoph Hellwig wrote:
> Currently xfs_ino_t is defined as a u64 which can either be an unsigned
> long long or on some 64 bit platforms and unsigned long.  Just making
> it and unsigned long long mean's it's still always 64 bits wide, but we
> don't need to resort to cases to print it.
> 
> Fixes a warning regression on 64 bit powerpc in current git.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_types.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_types.h	2009-01-01 11:53:17.321546620 +0100
> +++ xfs/fs/xfs/xfs_types.h	2009-01-05 20:30:04.794549213 +0100
> @@ -45,7 +45,7 @@ typedef __uint32_t		prid_t;		/* project 
>  typedef __uint32_t		inst_t;		/* an instruction */
>  
>  typedef __s64			xfs_off_t;	/* <file offset> type */
> -typedef __u64			xfs_ino_t;	/* <inode> type */
> +typedef unsigned long long	xfs_ino_t;	/* <inode> type */
>  typedef __s64			xfs_daddr_t;	/* <disk address> type */
>  typedef char *			xfs_caddr_t;	/* <core address> type */
>  typedef __u32			xfs_dev_t;

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
