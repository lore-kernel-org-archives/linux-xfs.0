Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1KM8kIt113197 for <xfs@oss.sgi.com>; Mon, 20 Feb 2012 16:08:46 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iHPa8YUlcwc1gRVS for <xfs@oss.sgi.com>;
	Mon, 20 Feb 2012 14:08:45 -0800 (PST)
Date: Tue, 21 Feb 2012 09:08:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: per-filesystem dquot LRU lists
Message-ID: <20120220220842.GD3592@dastard>
References: <20120220022815.018921977@bombadil.infradead.org>
	<20120220022904.240235841@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120220022904.240235841@bombadil.infradead.org>
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

On Sun, Feb 19, 2012 at 09:28:20PM -0500, Christoph Hellwig wrote:
> Replace the global dquot lru lists with a per-filesystem one.
> 
> Note that the shrinker isn't wire up to the per-superblock VFS shrinker
> infrastructure as would have problems summing up and splitting the counts
> for inodes and dquots.  I don't think this is a major problem as the quota
> cache isn't as interwinded with the inode cache as the dentry cache is,
> because an inode that is dropped from the cache will generally release
> a dquot reference, but most of the time it won't be the last one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
