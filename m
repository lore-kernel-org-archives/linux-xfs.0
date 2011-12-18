Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIMWf3x255605 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 16:32:42 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AcHNVWc8klF3DGjZ for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 14:32:40 -0800 (PST)
Date: Sun, 18 Dec 2011 17:32:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: log all dirty inodes in xfs_fs_sync_fs
Message-ID: <20111218223239.GA10435@infradead.org>
References: <20111218154936.GA17626@infradead.org>
	<20111218155015.GC17626@infradead.org>
	<20111218221707.GH23662@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218221707.GH23662@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>, xfs@oss.sgi.com

On Mon, Dec 19, 2011 at 09:17:07AM +1100, Dave Chinner wrote:
> This will do a transaction on the inode, clean or dirty. That's an
> awful lot of overhead for the few inodes (out of perhaps millions in
> memory) that actually need it. with the ->dirty_inode callback from
> the VFS, we know the only inodes that need logging are those with
> i_update_core set....

Ooops, I messed that up when forwarding the RFC patch I sent to
Paul & Sean, and that I had been testing with most of the time.  The
original one moved the i_update_core check into xfs_log_inode and that
is how it should be done.  I'll resend it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
