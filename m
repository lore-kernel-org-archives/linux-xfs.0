Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5JKWkdo027920 for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 15:32:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44F8C1E114AE
	for <xfs@oss.sgi.com>; Sat, 19 Jun 2010 13:35:25 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id AHBKnP5ov9WHaR9T for
	<xfs@oss.sgi.com>; Sat, 19 Jun 2010 13:35:25 -0700 (PDT)
Date: Sat, 19 Jun 2010 16:35:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove xfs_iput_new
Message-ID: <20100619203523.GA30665@infradead.org>
References: <20100611161824.GA7556@infradead.org>
	<20100615015300.GP6590@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100615015300.GP6590@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jun 15, 2010 at 11:53:00AM +1000, Dave Chinner wrote:
> On Fri, Jun 11, 2010 at 12:18:24PM -0400, Christoph Hellwig wrote:
> > We never get an i_mode of 0 or a locked VFS inode until we pass in the
> > XFS_IGET_CREATE flag to xfs_iget, which makes xfs_iput_new equivalent to
> > xfs_iput for the only caller.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

There's in fact no need to lock the inode at all here, so this can
be replaced with IRELE.   I'll send an updated version with my next
batch of patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
