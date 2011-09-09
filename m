Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89KNMMi058301 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 15:23:22 -0500
Subject: Re: [PATCH 09/25] xfs: do not use xfs_bmap_add_extent for adding
	delalloc extents
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060642.190850825@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060642.190850825@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 15:23:18 -0500
Message-ID: <1315599798.1999.53.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote: 
> We can just call xfs_bmap_add_extent_hole_delay directly to add a delayed
> allocated regions to the extent tree, instead of going through all the
> complexities of xfs_bmap_add_extent that aren't needed for this simple
> case.

Looks good.

By the way, while looking at this I noticed the code in xfs_bunmapi()
seemed to be doing arithmetic with a possibly null br_startblock,
which can't be right...  (In assigning sum just after wasdel gets
assigned.)

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
