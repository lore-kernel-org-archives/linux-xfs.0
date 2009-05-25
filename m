Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4PAFHoZ090582 for <xfs@oss.sgi.com>; Mon, 25 May 2009 05:15:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BCAC1A18C47
	for <xfs@oss.sgi.com>; Mon, 25 May 2009 03:15:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Uy1EEE8UsKz1GsJe for
	<xfs@oss.sgi.com>; Mon, 25 May 2009 03:15:29 -0700 (PDT)
Date: Mon, 25 May 2009 06:15:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix overflow in xfs_growfs_data_private
Message-ID: <20090525101529.GA24124@infradead.org>
References: <4A184EC4.1050007@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A184EC4.1050007@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Richard Ems <Richard.Ems@cape-horn-eng.com>, xfs-oss <xfs@oss.sgi.com>

On Sat, May 23, 2009 at 02:30:12PM -0500, Eric Sandeen wrote:
> Index: linux-2.6/fs/xfs/xfs_fsops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_fsops.c
> +++ linux-2.6/fs/xfs/xfs_fsops.c
> @@ -160,7 +160,7 @@ xfs_growfs_data_private(
>  	nagcount = new + (nb_mod != 0);
>  	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
>  		nagcount--;
> -		nb = nagcount * mp->m_sb.sb_agblocks;
> +		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
>  		if (nb < mp->m_sb.sb_dblocks)
>  			return XFS_ERROR(EINVAL);

Nice one! Thanks dear C integer promotion rules..

Would be good to get this into 2.6.30


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
