Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CEDC87F5D
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 01:24:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B55C0304043
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 23:24:42 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	qvRuwHB4i0VwOrN2 for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 23:24:33 -0800 (PST)
Date: Mon, 9 Dec 2013 18:24:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: rename xfs_ilock_map_shared
Message-ID: <20131209072428.GT31386@dastard>
References: <20131206203006.914776999@bombadil.infradead.org>
	<20131206203128.511935311@bombadil.infradead.org>
	<20131208223359.GD31386@dastard>
	<20131209070316.GA27054@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131209070316.GA27054@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Dec 08, 2013 at 11:03:16PM -0800, Christoph Hellwig wrote:
> On Mon, Dec 09, 2013 at 09:33:59AM +1100, Dave Chinner wrote:
> > While we are changing this, I think it makes sense to move it to
> > being a static inline function given how simple it is....
> 
> I actually tried that first, but with XFS_DINODE_FMT_BTREE in
> fs/xfs/xfs_dinode.h, struct xfsicdinode in xfs_log_format.h
> and the resulting dependencies it didn't seem workable.  My inode
> reshuffle might provide relief eventually.

Ok, makes sense to leave it like that for the moment.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
