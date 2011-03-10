Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2AHVEdv113945 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 11:31:25 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4615233823D
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:34:06 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EQt2RtrZQaJclZqK for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2011 09:34:06 -0800 (PST)
Date: Thu, 10 Mar 2011 12:34:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfs: introduce a xfssyncd workqueue
Message-ID: <20110310173405.GB19609@infradead.org>
References: <1299715529-11026-1-git-send-email-david@fromorbit.com>
	<1299715529-11026-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299715529-11026-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

> - out_sysctl_unregister:
> +out_destroy_xfs_syncd:
> +	destroy_workqueue(xfs_syncd_wq);
> +out_sysctl_unregister:
>  	xfs_sysctl_unregister();
> - out_cleanup_procfs:
> +out_cleanup_procfs:
>  	xfs_cleanup_procfs();
> - out_buf_terminate:
> +out_buf_terminate:
>  	xfs_buf_terminate();
> - out_filestream_uninit:
> +out_filestream_uninit:
>  	xfs_filestream_uninit();
> - out_mru_cache_uninit:
> +out_mru_cache_uninit:
>  	xfs_mru_cache_uninit();
> - out_destroy_zones:
> +out_destroy_zones:

What's the point of these random formatting changes?


Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
