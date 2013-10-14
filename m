Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70B117F54
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 23:55:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5F288304032
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 21:55:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	B7xAPFwsFxMxpqtW for <xfs@oss.sgi.com>;
	Sun, 13 Oct 2013 21:55:09 -0700 (PDT)
Date: Mon, 14 Oct 2013 15:55:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: always hold the iolock when calling
	xfs_change_file_space
Message-ID: <20131014045505.GH4446@dastard>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.290849068@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131012075640.290849068@bombadil.infradead.org>
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

On Sat, Oct 12, 2013 at 12:55:06AM -0700, Christoph Hellwig wrote:
> Currently fallocate always holds the iolock when calling into
> xfs_change_file_space, while the ioctl path lets some of the lower level
> functions take it, but leave it out in others.
> 
> This patch makes sure the ioctl path also always holds the iolock and
> thus introduces consistent locking for the preallocation operations while
> simplifying the code and allowing to kill the now unused XFS_ATTR_NOLOCK
> flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
