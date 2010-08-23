Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7NAaEZ4126008 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 05:36:14 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8AF8215D80FE
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 03:46:33 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HN0P8sM2EFGWRyka for
	<xfs@oss.sgi.com>; Mon, 23 Aug 2010 03:46:33 -0700 (PDT)
Date: Mon, 23 Aug 2010 06:36:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: improve buffer cache hash scalability
Message-ID: <20100823103647.GB7268@infradead.org>
References: <1282522546-7892-1-git-send-email-david@fromorbit.com>
	<1282522546-7892-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282522546-7892-3-git-send-email-david@fromorbit.com>
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

> @@ -1443,8 +1438,7 @@ xfs_alloc_bufhash(
>  {
>  	unsigned int		i;
>  
> -	btp->bt_hashshift = external ? 3 : 8;	/* 8 or 256 buckets */
> -	btp->bt_hashmask = (1 << btp->bt_hashshift) - 1;
> +	btp->bt_hashshift = external ? 3 : 12;	/* 8 or 4096 buckets */

Not directly related to the patch, but we never have hashes buffers
on the log device.  And on the RT device we only use hashed buffers
twice to verify the device size.  With a little work on the latter
we can stop allocating the buf hash entirely for the RT and log
devices.

Anyway, the patch looks good for now, although we should try to get
rid of the hash long term.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
