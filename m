Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PGcWdK011875 for <xfs@oss.sgi.com>; Tue, 25 May 2010 11:38:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D31EE1577222
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 09:42:35 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id DeCEsDBhpib6OV0I for <xfs@oss.sgi.com>;
	Tue, 25 May 2010 09:42:35 -0700 (PDT)
Date: Tue, 25 May 2010 12:40:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix race in inode cluster freeing failing to
	stale inodes
Message-ID: <20100525164052.GA18666@infradead.org>
References: <1274581478-19260-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1274581478-19260-1-git-send-email-david@fromorbit.com>
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

Looks good, but some minor nits on the comments below:


Reviewed-by: Christoph Hellwig <hch@lst.de>

>  		/*
> +		 * Now we've locked out tail pushing and flushing by locking
> +		 * the buffer, look for each inode in memory and attempt to
> +		 * lock it. Any inode we get the locks on add it to the inode
> +		 * buffer and set it up for being staled on buffer IO
> +		 * completion.

This comment reads a bit odd.  The first thing we do in the loop is
locking the buffer, so the "Now" at the beginning of the comment feels
rather out of place.  What about:

		/*
		 * For each inode in memory attempt to add it to the inode
		 * buffer and set it up for being staled on buffer IO
		 * completion.  This is safe as we've locked out tail
		 * pushing and flushing by locking the buffer.
		 *
		 * We have already marked every inode that was part of
		 * a transaction stale above, which means there is no
		 * point in even trying to lock them.
		 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
