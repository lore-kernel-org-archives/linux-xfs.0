Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1H4FlxZ203940 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 22:15:47 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 856351CD8226
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 20:17:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	Wx4kEhsvXIwk9W9c for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 20:17:04 -0800 (PST)
Date: Wed, 17 Feb 2010 15:17:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] [PATCH 4/4] xfs: implement optimized fdatasync
Message-ID: <20100217041700.GL28392@discord.disaster>
References: <20100215094445.528696829@bombadil.infradead.org>
	<20100215094605.009247071@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100215094605.009247071@bombadil.infradead.org>
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
Cc: xfs@oss.sgi.com

On Mon, Feb 15, 2010 at 04:44:49AM -0500, Christoph Hellwig wrote:
> Allow us to track the difference between timestamp and size updates by using
> mark_inode_dirty from the I/O completion code, and checking the VFS inode
> flags in xfs_file_fsync.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane.

Reviewed-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
