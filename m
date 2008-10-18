Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 18 Oct 2008 05:34:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9ICYg0v015204
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:34:43 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36E7C130E53F
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:36:26 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id k3nMZkMxoUk72Jfi for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 05:36:26 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m9ICaNIF025440
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 18 Oct 2008 14:36:24 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m9ICaNR4025431
	for xfs@oss.sgi.com; Sat, 18 Oct 2008 14:36:23 +0200
Date: Sat, 18 Oct 2008 14:36:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] trivial xfs_remove comment fixup
Message-ID: <20081018123623.GB25304@lst.de>
References: <20080807215849.GA11345@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807215849.GA11345@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Ping?  This is just a trivial comment fixup, shouldn't be that hard to
review..

On Thu, Aug 07, 2008 at 11:58:49PM +0200, Christoph Hellwig wrote:
> The dp to ip comment should be for the unconditional xfs_droplink
> call, and the "." link obviously only exists for directories,
> so it should be in the is_dir conditional.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-08-06 17:26:37.000000000 -0300
> +++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-08-06 17:36:44.000000000 -0300
> @@ -2014,7 +2014,7 @@ xfs_remove(
>  			goto out_bmap_cancel;
>  
>  		/*
> -		 * Drop the link from dp to ip.
> +		 * Drop the "." link from ip to self.
>  		 */
>  		error = xfs_droplink(tp, ip);
>  		if (error)
> @@ -2029,7 +2029,7 @@ xfs_remove(
>  	}
>  
>  	/*
> -	 * Drop the "." link from ip to self.
> +	 * Drop the link from dp to ip.
>  	 */
>  	error = xfs_droplink(tp, ip);
>  	if (error)
---end quoted text---
