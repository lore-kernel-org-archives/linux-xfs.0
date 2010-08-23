Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7NCAreC128756 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 07:10:53 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 813101E4EFCE
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 05:11:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	0jOtWVZ41ycLdXtf for <xfs@oss.sgi.com>;
	Mon, 23 Aug 2010 05:11:25 -0700 (PDT)
Date: Mon, 23 Aug 2010 22:11:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: do not discard page cache data on EAGAIN
Message-ID: <20100823121122.GH31488@dastard>
References: <20100823091015.GA2829@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100823091015.GA2829@infradead.org>
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

On Mon, Aug 23, 2010 at 05:10:15AM -0400, Christoph Hellwig wrote:
> If xfs_map_blocks returns EAGAIN because of lock contention we must redirty
> the page and not disard the pagecache content and return an error from
> writepage.  We used to do this correctly, but the logic got lost during
> the recent reshuffle of the writepage code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Mike Gao <ygao.linux@gmail.com> 
> Tested-by: Mike Gao <ygao.linux@gmail.com> 

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
