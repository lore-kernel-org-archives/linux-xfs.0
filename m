Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAM0adUV160830 for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 18:36:39 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80EA513DDA77
	for <xfs@oss.sgi.com>; Sun, 21 Nov 2010 16:38:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	FwlYn2Xx8KDS9dJs for <xfs@oss.sgi.com>;
	Sun, 21 Nov 2010 16:38:13 -0800 (PST)
Date: Mon, 22 Nov 2010 11:37:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix exporting with left over 64-bit inodes
Message-ID: <20101122003754.GE13830@dastard>
References: <20101119133848.GA5471@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101119133848.GA5471@infradead.org>
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
Cc: Samuel Kvasnica <samuel.kvasnica@ims.co.at>, xfs@oss.sgi.com

On Fri, Nov 19, 2010 at 08:38:49AM -0500, Christoph Hellwig wrote:
> From: Samuel Kvasnica <samuel.kvasnica@ims.co.at>
> 
> We now support mounting and using filesystems with 64-bit inodes even
> when not mounted with the inode64 option (which now only controls if
> we allocate new inodes in that space or not).  Make sure we always
> use large NFS file handles when exporting a filesystem that may contain
> 64-bit inodes.  Note that this only affects newly generated file handles,
> any outstanding 32-bit file handle is still accepted.
> 
> [hch: the comment and commit log are mine, the rest is from a patch
>  snipplet from Samuel]
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Won't this mean that people exporting non-root directories suddenly
have those exports stop working on a kernel upgrade due to changing
the handle format?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
