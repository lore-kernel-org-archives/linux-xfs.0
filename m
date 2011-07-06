Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6635lb5062771 for <xfs@oss.sgi.com>; Tue, 5 Jul 2011 22:05:47 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E6254B8CA
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2011 20:05:45 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	YCidzOOwqisk4JG3 for <xfs@oss.sgi.com>;
	Tue, 05 Jul 2011 20:05:45 -0700 (PDT)
Date: Wed, 6 Jul 2011 13:05:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 19/27] xfs: kill struct xfs_dir2_data
Message-ID: <20110706030543.GN1026@dastard>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094606.199361663@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701094606.199361663@bombadil.infradead.org>
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

On Fri, Jul 01, 2011 at 05:43:40AM -0400, Christoph Hellwig wrote:
> Remove the confusing xfs_dir2_data structure.  It is supposed to describe
> an XFS dir2 data btree block, but due to the variable sized nature of
> almost all elements in it it can't actuall do anything close to that
> job.  In addition to accessing the fixed offset header structure it was
> only used to get a pointer to the first dir or unused entry after it,
> which can be trivially replaced by pointer arithmetics on the header
> pointer.  For most users that is actually more natural anyway, as they
> don't use a typed pointer but rather a character pointer for further
> arithmetics.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> @@ -70,10 +69,9 @@ xfs_dir2_data_check(
>  	struct xfs_name		name;
>  
>  	mp = dp->i_mount;
> -	d = bp->data;
> -	hdr = &d->hdr;
> +	hdr = bp->data;
>  	bf = hdr->bestfree;
> -	p = (char *)d->u;
> +	p = (char *)(hdr + 1);

Same comment as the previous patch about using a wrapper for this.

Otherwise looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
