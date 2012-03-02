Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q227nMS5011606 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 01:49:22 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZGNWCVHHIp4sltCh (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 23:49:21 -0800 (PST)
Date: Fri, 2 Mar 2012 02:49:20 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] xfs: handle kmalloc failure when reading attrs
Message-ID: <20120302074920.GE4117@infradead.org>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
	<1330661507-1121-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330661507-1121-4-git-send-email-david@fromorbit.com>
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

I think the subject should be more like:

xfs: fallback to vmalloc for large buffers in xfs_attrmulti_attr_get

> +	kbuf = kmem_zalloc(*len, KM_SLEEP | KM_MAYFAIL);
> +	if (!kbuf) {
> +		kbuf = kmem_zalloc_large(*len);
> +		if (!kbuf)
> +			return ENOMEM;
> +	}
>  
>  	error = xfs_attr_get(XFS_I(inode), name, kbuf, (int *)len, flags);
>  	if (error)
> @@ -457,7 +460,7 @@ xfs_attrmulti_attr_get(
>  		error = EFAULT;
>  
>   out_kfree:
> -	kfree(kbuf);
> +	kmem_free(kbuf);

kmem_free doesn't handle vmalloced buffers from kmem_zalloc_large, you
need to use kmem_free_large for them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
