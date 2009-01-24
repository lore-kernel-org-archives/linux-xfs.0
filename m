Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0OEOEI5016084 for <xfs@oss.sgi.com>; Sat, 24 Jan 2009 08:24:14 -0600
Date: Sat, 24 Jan 2009 09:23:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, needs new owner] xfs_repair memory optimization
Message-ID: <20090124142331.GA32688@infradead.org>
References: <497926DC.1030509@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <497926DC.1030509@sgi.com>
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
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 23, 2009 at 01:09:32PM +1100, Mark Goodwin wrote:
>
> A known limitation of xfs_repair is the large amount of memory it
> requires, depending on filesystem size and number of inodes, etc.
>
> The attached patch series, originally by Barry Bnaujok, is close to
> being finished but requires a new owner to do some final testing and
> polishing. It applies cleanly against top-of-tree xfsprogs-3.0.0

I did a quick look over it on the plane today and it looks quite nice
to me.

I guess there are no patch descriptions left anywhere?

Otherwise some of the patch might need some minor polishing, e.g.
the patch moving over from the radix tree to the btree leaves the
radix-tree implementation in, which gets removed in the next patch
which has otherwise unrelated changes.

The btree implementation btw worries me a little, I wonder if we need
a test harness to make sure it's correct for all corner cases.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
