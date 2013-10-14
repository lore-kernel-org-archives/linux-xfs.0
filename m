Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 71AC67F5E
	for <xfs@oss.sgi.com>; Mon, 14 Oct 2013 00:08:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5BA3B304032
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 22:08:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vBNAFTshM308uC6r for <xfs@oss.sgi.com>;
	Sun, 13 Oct 2013 22:08:11 -0700 (PDT)
Date: Mon, 14 Oct 2013 16:08:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: fold xfs_change_file_space into xfs_ioc_space
Message-ID: <20131014050807.GJ4446@dastard>
References: <20131012075503.370510641@bombadil.infradead.org>
	<20131012075640.637625757@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131012075640.637625757@bombadil.infradead.org>
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

On Sat, Oct 12, 2013 at 12:55:08AM -0700, Christoph Hellwig wrote:
> Now that only one caller of xfs_change_file_space is left it can be merged
> into said caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

One question, though:

> +	case XFS_IOC_ALLOCSP:
> +	case XFS_IOC_ALLOCSP64:
> +	case XFS_IOC_FREESP:
> +	case XFS_IOC_FREESP64:

Should we, at this point, mark these ioctls as deprecated and
schedule then for removal given that we've recommended against using
them for the past 10 years and we have fallocate() now?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
