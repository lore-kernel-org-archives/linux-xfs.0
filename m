Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9J1EWhO016077 for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 20:14:32 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18C3515260
	for <xfs@oss.sgi.com>; Sun, 18 Oct 2009 18:16:04 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	O0DgtrUm3zLehr9U for <xfs@oss.sgi.com>;
	Sun, 18 Oct 2009 18:16:04 -0700 (PDT)
Date: Mon, 19 Oct 2009 12:16:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091019011600.GO9464@discord.disaster>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
	<20091007011926.GB32032@infradead.org>
	<4AD18C8D.90808@news-service.com>
	<20091012233854.GA29446@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091012233854.GA29446@infradead.org>
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
Cc: Patrick Schreurs <patrick@news-service.com>, Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Mon, Oct 12, 2009 at 07:38:54PM -0400, Christoph Hellwig wrote:
> On Sun, Oct 11, 2009 at 09:43:09AM +0200, Patrick Schreurs wrote:
> > Hello Christoph,
> >
> > Attached you'll find a screenshot from a 2.6.31.3 server, which includes  
> > your patches and has XFS_DEBUG turned on. I truly hope this is useful to  
> > you.
> 
> Thanks.  The patch below should fix the inode reclaim race that could
> lead to the double free you're seeing.  To be applied ontop of all
> the other patches I sent you.
> 
> Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-10-11 19:09:43.828254119 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-10-12 13:48:14.886006087 +0200
> @@ -670,22 +670,22 @@ xfs_reclaim_inode(
>  {
>  	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
>  
> -	/* The hash lock here protects a thread in xfs_iget_core from
> -	 * racing with us on linking the inode back with a vnode.
> -	 * Once we have the XFS_IRECLAIM flag set it will not touch
> -	 * us.
> +	/*
> +	 * The hash lock here protects a thread in xfs_iget from racing with
> +	 * us on recycling the inode.  Once we have the XFS_IRECLAIM flag set
> +	 * it will not touch it.
>  	 */
> -	write_lock(&pag->pag_ici_lock);

Did you mean to remove this write_lock? The patch does not remove
the unlocks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
