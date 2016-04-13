Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69C407CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 11:45:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 298C4304059
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:45:13 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id K0OVX1AAKqd0BQdA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:45:11 -0700 (PDT)
Date: Wed, 13 Apr 2016 09:45:11 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/11] xfs: optimise xfs_iext_destroy
Message-ID: <20160413164510.GC8475@infradead.org>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
	<1460525492-1170-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460525492-1170-6-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

>  /*
> + * Remove all records from the indirection array.
> + */
> +STATIC void
> +xfs_iext_irec_remove_all(
> +	struct xfs_ifork *ifp)
> +{
> +	int		nlists;
> +	int		i;
> +
> +	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
> +	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
> +	for (i = 0; i < nlists; i++) {
> +		xfs_ext_irec_t *erp = &ifp->if_u1.if_ext_irec[i];

Can we avoid the typedef for new code?

> +		if (erp->er_extbuf)
> +			kmem_free(erp->er_extbuf);

no need to check for NULL before a kmem_free, e.g. this whole loop could
just be:

	for (i = 0; i < nlists; i++)
		kmem_free(ifp->if_u1.if_ext_irec[i].er_extbuf);

>  {
>  	if (ifp->if_flags & XFS_IFEXTIREC) {
> -		int	erp_idx;
> -		int	nlists;
> -
> -		nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
> -		for (erp_idx = nlists - 1; erp_idx >= 0 ; erp_idx--) {
> -			xfs_iext_irec_remove(ifp, erp_idx);
> -		}
> +		xfs_iext_irec_remove_all(ifp);
>  		ifp->if_flags &= ~XFS_IFEXTIREC;

I'd be tempted to just move clearing of the flag into
xfs_iext_irec_remove_all if we change the patch anyway.

Otherwise this looks fine to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
