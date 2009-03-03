Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23GlH0J023570 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 10:47:17 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C07E1C137B3
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 08:46:49 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id pu3X3H7NIS0CTaaF for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2009 08:46:49 -0800 (PST)
Message-ID: <49AD5AB5.9050604@sandeen.net>
Date: Tue, 03 Mar 2009 10:28:37 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs: prevent kernel crash due to corrupted inode log format
References: <20090215191344.GA16706@infradead.org>
In-Reply-To: <20090215191344.GA16706@infradead.org>
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
Cc: Andras Korn <korn-sgi.com@chardonnay.math.bme.hu>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Andras Korn reported an oops on log replay causes by a corrupted
> xfs_inode_log_format_t passing a 0 size to kmem_zalloc.  This patch handles
> to small or too large numbers of log regions gracefully by rejecting the
> log replay with a useful error message.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Andras Korn <korn-sgi.com@chardonnay.math.bme.hu>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfs/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-12 19:00:29.056944584 +0100
> +++ xfs/fs/xfs/xfs_log_recover.c	2009-02-15 20:07:56.568971792 +0100
> @@ -1455,10 +1455,19 @@ xlog_recover_add_to_trans(
>  	item = item->ri_prev;
>  
>  	if (item->ri_total == 0) {		/* first region to be added */
> -		item->ri_total	= in_f->ilf_size;
> -		ASSERT(item->ri_total <= XLOG_MAX_REGIONS_IN_ITEM);
> -		item->ri_buf = kmem_zalloc((item->ri_total *
> -					    sizeof(xfs_log_iovec_t)), KM_SLEEP);
> +		if (in_f->ilf_size == 0 ||
> +		    in_f->ilf_size > XLOG_MAX_REGIONS_IN_ITEM) {
> +			xlog_warn(
> +	"XFS: bad number of regions (%d) in inode log format",
> +				  in_f->ilf_size);
> +			ASSERT(0);
> +			return XFS_ERROR(EIO);
> +		}
> +
> +		item->ri_total = in_f->ilf_size;
> +		item->ri_buf =
> +			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
> +				    KM_SLEEP);
>  	}
>  	ASSERT(item->ri_total > item->ri_cnt);
>  	/* Description region is ri_buf[0] */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
