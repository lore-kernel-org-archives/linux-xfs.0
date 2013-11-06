Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D51729E04
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 04:23:37 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 20543304062
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 02:23:35 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 7Bsoifo3ddLDIQLw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 02:23:34 -0800 (PST)
Date: Wed, 6 Nov 2013 02:23:34 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/37] libxfs: fix root inode handling inconsistencies
Message-ID: <20131106102334.GB614@infradead.org>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
	<1383700043-32305-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383700043-32305-16-git-send-email-david@fromorbit.com>
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

On Wed, Nov 06, 2013 at 12:07:01PM +1100, Dave Chinner wrote:
>  	mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
> -				LIBXFS_MOUNT_ROOTINOS | LIBXFS_MOUNT_DEBUGGER);
> +			  LIBXFS_MOUNT_DEBUGGER);
>  	if (!mp) {
> -		mp = libxfs_mount(&xmount, sbp, x.ddev, x.logdev, x.rtdev,
> -				LIBXFS_MOUNT_DEBUGGER);
> -		if (!mp) {
> -			fprintf(stderr, _("%s: device %s unusable (not an XFS "
> -				"filesystem?)\n"), progname, fsdevice);
> -			exit(1);
> -		}
> +		fprintf(stderr,
> +			_("%s: device %s unusable (not an XFS filesystem?)\n"),
> +			progname, fsdevice);
> +		exit(1);
>  	}
>  	blkbb = 1 << mp->m_blkbb_log;
>  
> +	/*
> +	 * xfs_check needs corrected incore superblock values
> +	 */
> +	if (sbp->sb_rootino != NULLFSINO &&
> +	    xfs_sb_version_haslazysbcount(&mp->m_sb)) {
> +		int error = xfs_initialize_perag_data(mp, sbp->sb_agcount);
> +		if (error) {
> +			fprintf(stderr, _("%s: cannot init perag data (%d)\n"),
> +				progname, error);
> +			exit(EXIT_FAILURE);

The old code above just goes ahead without the perage data due to the
retry without LIBXFS_MOUNT_ROOTINOS.  I think we should keep that
behaviour as we want to be able to run xfs_db under as many
circumstances as possible.

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
