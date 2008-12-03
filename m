Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB339Svh009575 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 21:09:28 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F4065166E50D
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 19:09:27 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	5nO8q1vCgb6K4LCt for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2008 19:09:27 -0800 (PST)
Date: Wed, 3 Dec 2008 14:06:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 17/22] no explicit xfs_iflush for special inodes during
	unmount
Message-ID: <20081203030629.GN18236@disturbed>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160651.992698000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081202160651.992698000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Dec 02, 2008 at 11:04:47AM -0500, Christoph Hellwig wrote:
> Currently we explicitly call xfs_iflush on the quota, real-time and root
> inodes from xfs_unmount_flush.  But we just called xfs_sync_inodes with
> SYNC_ATTR and do an XFS_bflush aka xfs_flush_buftarg to make sure all inodes
> are on disk already, so there is no need for these special cases.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
