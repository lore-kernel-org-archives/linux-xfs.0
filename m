Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B9D737F3F
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 07:35:34 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6414304067
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 05:35:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id YRAlLmqmY7BlUyQv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 05:35:27 -0800 (PST)
Date: Mon, 25 Nov 2013 05:35:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] decouple the in-memory from the on-disk log format
Message-ID: <20131125133525.GA21992@infradead.org>
References: <20131123151151.716201348@bombadil.infradead.org>
	<20131125085415.GC8803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131125085415.GC8803@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Nov 25, 2013 at 07:54:15PM +1100, Dave Chinner wrote:
> Can you give us an outline of where you are taking this code and
> what problems you are trying to solve? I'm missing the big picture
> view that is driving this work - I think I know where you are going
> to take it (i.e. closer integration with the vfs struct inode to
> remove a bunch of duplicate information), but I'd like to know for
> sure where this is going before looking at the code in real depth...

There's no problem per se, it's just the requiring the in-memory copy
of the logged data is hugely inefficient.  We already see that with the
three patches dropping the trivial log format, and it will be even
bigger for the inode.  Basically the next step is to get rid of
struct icdinode - the structure will still exist sa struct xfs_log_inode
or similar, but only inside the log item.  The other fields will get
merged into struct xfs_inode.  Most of them will then go away in favour
of using exist VFS inode fields or moving into struct xfs_ifork so
that a lot of data vs attribute fork special casing can go away.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
