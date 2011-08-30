Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U6PZFo117362 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 01:25:36 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26DA41E7F3CF
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 23:25:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ujVx6F0BiPLkcQKf for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2011 23:25:34 -0700 (PDT)
Date: Tue, 30 Aug 2011 16:25:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: fix ->write_inode return values
Message-ID: <20110830062532.GO3162@dastard>
References: <20110827055731.GA24159@infradead.org>
	<20110827055755.GB28351@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110827055755.GB28351@infradead.org>
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

On Sat, Aug 27, 2011 at 01:57:55AM -0400, Christoph Hellwig wrote:
> Currently we always redirty an inode that was attempted to be written out
> synchronously but has been cleaned by an AIL pushed internall, which is
> rather bogus.  Fix that by doing the i_update_core check early on and
> return 0 for it.  Also include async calls for it, as doing any work for
> those is just as pointless.  While we're at it also fix the sign for the
> EIO return in case of a filesystem shutdown, and fix the completely
> non-sensical locking around xfs_log_inode.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
