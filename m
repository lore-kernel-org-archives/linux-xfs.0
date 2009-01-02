Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n02C02EN026005 for <xfs@oss.sgi.com>; Fri, 2 Jan 2009 06:00:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D09E11BF94EA
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2009 04:00:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Vju4kkI2DFbc8SQH for
	<xfs@oss.sgi.com>; Fri, 02 Jan 2009 04:00:01 -0800 (PST)
Date: Fri, 2 Jan 2009 07:00:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fix xfs_fsr insufficient space check
Message-ID: <20090102120000.GA9789@infradead.org>
References: <20090102100306.GA36830@puku.stupidest.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090102100306.GA36830@puku.stupidest.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Chris Wedgwood <cw@f00f.org>
Cc: xfs@oss.sgi.com

On Fri, Jan 02, 2009 at 02:03:06AM -0800, Chris Wedgwood wrote:
> The xfs_fsr insufficient check should consider the blocks used not the
> file length.  Without this change it is not possible to reorganize
> sparse files when file size exceeds the free space.
> 
> Signed-off-by: Chris Wedgwood <cw@f00f.org>
> 
> 
> --- fsr/xfs_fsr.c.orig	2009-01-02 01:51:03.049181411 -0800
> +++ fsr/xfs_fsr.c	2009-01-02 01:53:56.297180891 -0800
> @@ -912,9 +912,9 @@
>  	}
>  	bsize = vfss.f_frsize ? vfss.f_frsize : vfss.f_bsize;
>  
> -	if (statp->bs_size > ((vfss.f_bfree * bsize) - minimumfree)) {
> +	if ((statp->bs_blksize * statp->bs_blocks) > ((vfss.f_bfree * bsize) - minimumfree)) {

I'll put this after fixing the line length and removing all the
superflous braces.  Also we probably want a comment that bs_blksize
in xfs_bstat_t actually is the blocksize, unlike st_blksize in struct
stat.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
