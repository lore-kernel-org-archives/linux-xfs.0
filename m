Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HMqVUJ005652 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 16:52:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 519E51CDB5EE
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 14:53:48 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	tr5oXY2Fj8XjCIRw for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2010 14:53:48 -0800 (PST)
Date: Thu, 18 Feb 2010 09:53:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix inode pincount check in fsync
Message-ID: <20100217225345.GT28392@discord.disaster>
References: <20100217193457.GA21840@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217193457.GA21840@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Feb 17, 2010 at 02:34:57PM -0500, Christoph Hellwig wrote:
> We need to hold the ilock to check the inode pincount safely.  While
> we're at it also remove the check for ip->i_itemp->ili_last_lsn, a
> pinned inode always has it set.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
