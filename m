Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AMOAVd048982 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 16:24:11 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A349E1D20771
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 14:26:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	SLzxHDmokPXWbbVC for <xfs@oss.sgi.com>;
	Mon, 10 Jan 2011 14:26:21 -0800 (PST)
Date: Tue, 11 Jan 2011 09:26:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/8] xfs: introduce xfs_rw_lock() helpers for locking
	the inode
Message-ID: <20110110222618.GG28803@dastard>
References: <1294399825-1157-1-git-send-email-david@fromorbit.com>
	<1294399825-1157-5-git-send-email-david@fromorbit.com>
	<20110110192305.GF25029@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110110192305.GF25029@infradead.org>
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

On Mon, Jan 10, 2011 at 02:23:05PM -0500, Christoph Hellwig wrote:
> > -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > +	xfs_rw_ilock(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL);
> 
> this now takes i_mutex, which will be taken again by
> generic_file_splice_write.

Ah, oops. I'll revert that bit - I thought we had test coverage of
that interface. I guess we need a basic sanity test for this
functionality. I'll write one.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
