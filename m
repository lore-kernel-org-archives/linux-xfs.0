Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9F5uc7W244887
	for <linux-xfs@oss.sgi.com>; Thu, 15 Oct 2009 00:56:38 -0500
Received: from tneu02.synserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CD52122853C
	for <linux-xfs@oss.sgi.com>; Wed, 14 Oct 2009 22:58:08 -0700 (PDT)
Received: from tneu02.synserver.de (tneu02.synserver.de [217.119.58.222]) by
	cuda.sgi.com with ESMTP id Ci6g4Qb5RhCbCH36 for
	<linux-xfs@oss.sgi.com>; Wed, 14 Oct 2009 22:58:08 -0700 (PDT)
From: Thomas Neumann <tneumann@users.sourceforge.net>
Subject: Re: deadlocks with fallocate
Date: Thu, 15 Oct 2009 07:58:05 +0200
References: <hak2l2$ko2$1@ger.gmane.org> <20091014150951.GA13123@infradead.org>
In-Reply-To: <20091014150951.GA13123@infradead.org>
MIME-Version: 1.0
Message-Id: <200910150758.06003.tneumann@users.sourceforge.net>
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
Cc: linux-xfs@oss.sgi.com

> Can you try if the hack below makes the problem go away?
> 
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-10-14
>  17:06:50.489254023 +0200 +++
>  linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-10-14 17:07:54.055006445 +0200
>  @@ -278,6 +278,8 @@ xfs_end_bio_unwritten(
>  	xfs_off_t		offset = ioend->io_offset;
>  	size_t			size = ioend->io_size;
> 
> +	current->flags |= PF_FSTRANS;
> +
>  	if (likely(!ioend->io_error)) {
>  		if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
>  			int error;
> 

I did some more tests, and indeed the patch makes the deadlock go away. Your 
description of it as a hack makes me somewhat concerned about using it 
permanently, but hopefully you will find a proper solution ;)

Thanks for looking at this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
