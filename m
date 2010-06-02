Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o525tLDI054842 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 00:55:22 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55FE738D3B6
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 22:57:48 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	7zv1mJi2eLtzXoHn for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 22:57:48 -0700 (PDT)
Date: Wed, 2 Jun 2010 15:57:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 11/17] xfs: simplify inode to transaction joining
Message-ID: <20100602055745.GK7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160901.401855518@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160901.401855518@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:38PM -0400, Christoph Hellwig wrote:
> Currently we need to either call IHOLD or xfs_trans_ihold on an inode when
> joining it to a transaction via xfs_trans_ijoin.
> 
> This patches instead makes xfs_trans_ijoin usable on it's own by doing
> an implicity xfs_trans_ihold, which also allows us to drop the third
> argument.  For the case where we want to hold a reference on the inode
> a xfs_trans_ijoin_ref wrapper is added which does the IHOLD and marks
> the inode for needing an xfs_iput.  In addition to the cleaner interface
> to the caller this also simplifies the implementation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Can't say I'm fond of the xfs_trans_iget() setting of the lock
flags, but that's a small price to pay forthe rest of the cleanup.
So it looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
