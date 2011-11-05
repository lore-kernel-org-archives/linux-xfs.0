Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA58BFxZ142726 for <xfs@oss.sgi.com>; Sat, 5 Nov 2011 03:11:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2B921CE842F
	for <xfs@oss.sgi.com>; Sat,  5 Nov 2011 01:11:11 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qEYD0l9lZvGE45g8 for <xfs@oss.sgi.com>;
	Sat, 05 Nov 2011 01:11:11 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RMbLL-0003kq-3F
	for xfs@oss.sgi.com; Sat, 05 Nov 2011 08:11:11 +0000
Date: Sat, 5 Nov 2011 04:11:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/45] fix: force shutdown handling in xfs_end_io
Message-ID: <20111105081111.GA14382@infradead.org>
References: <20111028095423.796574703@bombadil.infradead.org>
	<20111028100337.411618173@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111028100337.411618173@bombadil.infradead.org>
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
To: xfs@oss.sgi.com

Btw, this probably is another candidates for 3.2.

On Fri, Oct 28, 2011 at 05:54:33AM -0400, Christoph Hellwig wrote:
> Only ioend->io_error gets propagated back to e.g. AIO completions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_aops.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: xfs/fs/xfs/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_aops.c	2011-10-27 22:39:56.068672482 +0200
> +++ xfs/fs/xfs/xfs_aops.c	2011-10-27 22:39:56.902173367 +0200
> @@ -184,7 +184,7 @@ xfs_end_io(
>  	int		error = 0;
>  
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> -		error = -EIO;
> +		ioend->io_error = -EIO;
>  		goto done;
>  	}
>  	if (ioend->io_error)
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
