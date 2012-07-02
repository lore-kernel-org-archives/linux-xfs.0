Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q626WUwV174486 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 01:32:31 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	628Xmx2ARpvro3oy (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Jul 2012 23:32:30 -0700 (PDT)
Date: Mon, 2 Jul 2012 02:32:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [MMTests] IO metadata on XFS
Message-ID: <20120702063226.GA32151@infradead.org>
References: <20120620113252.GE4011@suse.de> <20120629111932.GA14154@suse.de>
	<20120629112505.GF14154@suse.de> <20120701235458.GM19223@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120701235458.GM19223@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com, Mel Gorman <mgorman@suse.de>, linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 09:54:58AM +1000, Dave Chinner wrote:
> That will be caused by the fact we changed all the metadata updates
> to be logged, which means a transaction every time .dirty_inode is
> called.
> 
> This should mostly go away when XFS is converted to use .update_time
> rather than .dirty_inode to only issue transactions when the VFS
> updates the atime rather than every .dirty_inode call...

I think the patch to do that conversion still needs review..

> It increases the CPU overhead (dirty_inode can be called up to 4
> times per write(2) call, IIRC), so with limited numbers of
> threads/limited CPU power it will result in lower performance. Where
> you have lots of CPU power, there will be little difference in
> performance...

When I checked it it could only be called twice, and we'd already
optimize away the second call.  I'd defintively like to track down where
the performance changes happend, at least to a major version but even
better to a -rc or git commit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
