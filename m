Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3S2H5d0242176 for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 21:17:05 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6930A11AD1AE
	for <xfs@oss.sgi.com>; Wed, 27 Apr 2011 19:20:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ZiSqJvO36BZRtkdO for <xfs@oss.sgi.com>;
	Wed, 27 Apr 2011 19:20:37 -0700 (PDT)
Date: Thu, 28 Apr 2011 12:20:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix compiler warning in xfs_trace.h
Message-ID: <20110428022036.GQ12436@dastard>
References: <20110424190258.GA32137@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110424190258.GA32137@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

On Sun, Apr 24, 2011 at 03:02:58PM -0400, Christoph Hellwig wrote:
> xfs_fsblock_t may be a 32-bit type on if XFS_BIG_BLKNOS is not set,
> make sure to cast a value of this type to an unsigned long long
> before using the ll printk qualifier.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-04-22 06:22:11.409709360 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-04-22 06:22:30.756271218 +0200
> @@ -1418,7 +1418,7 @@ DECLARE_EVENT_CLASS(xfs_alloc_class,
>  		  __entry->wasfromfl,
>  		  __entry->isfl,
>  		  __entry->userdata,
> -		  __entry->firstblock)
> +		  (unsigned long long)__entry->firstblock)
>  )
>  
>  #define DEFINE_ALLOC_EVENT(name) \

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
