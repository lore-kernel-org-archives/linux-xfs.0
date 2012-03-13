Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DLoOFN074430 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 16:50:24 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3rDTmACsa6FRjXEr for <xfs@oss.sgi.com>;
	Tue, 13 Mar 2012 14:50:22 -0700 (PDT)
Date: Wed, 14 Mar 2012 08:50:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: per-filesystem dquot LRU lists
Message-ID: <20120313215021.GH5091@dastard>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085308.631894051@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313085308.631894051@bombadil.infradead.org>
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

On Tue, Mar 13, 2012 at 04:52:34AM -0400, Christoph Hellwig wrote:
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

Looks sane.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
