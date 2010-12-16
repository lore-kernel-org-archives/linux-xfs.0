Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGBtku3047203 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 05:55:46 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE8111F7AB1
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 03:57:40 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2d6H710Cg0MxWuPn for
	<xfs@oss.sgi.com>; Thu, 16 Dec 2010 03:57:40 -0800 (PST)
Date: Thu, 16 Dec 2010 06:57:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: ensure sync write errors are returned
Message-ID: <20101216115738.GB20445@infradead.org>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
	<1292376208-16282-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292376208-16282-2-git-send-email-david@fromorbit.com>
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

>  		error2 = filemap_write_and_wait_range(mapping, pos, end);
> -		if (!error)
> +		if (error2)
>  			error = error2;
>  		if (need_i_mutex)
>  			mutex_lock(&inode->i_mutex);
> @@ -777,7 +777,7 @@ write_retry:
>  
>  		error2 = -xfs_file_fsync(file,
>  					 (file->f_flags & __O_SYNC) ? 0 : 1);
> -		if (!error)
> +		if (error2 && error >= 0)
>  			error = error2;

Shouldn't the filemap_write_and_wait_range clause use a similar check as
this one?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
