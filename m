Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 48C807F66
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 14:12:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D06CBAC002
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 12:12:39 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7M3nQHvgp74BGaAz for <xfs@oss.sgi.com>;
	Thu, 12 Nov 2015 12:12:33 -0800 (PST)
Date: Fri, 13 Nov 2015 07:12:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] xfs: create helper for bmap finish & trans join in
	attr code
Message-ID: <20151112201231.GS19199@dastard>
References: <56441B8E.6070603@redhat.com> <5644BEF8.6070201@sandeen.net>
	<20151112165801.GA14854@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151112165801.GA14854@infradead.org>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Nov 12, 2015 at 08:58:01AM -0800, Christoph Hellwig wrote:
> I think the problem here is simply that our interfaces suck.
> xfs_trans_roll really needs to rejoin any inode to the new transaction
> to that was joined to the previous one.  Once we've fixed that we can
> get rid of the silly committed arguments and everyone will be happy.

xfs_trans_roll is not specifically for rolling transactions with
locked inodes in them. We could use it for any object that needs
multiple transactions to modify. e.g. we could roll transactions
across an AGF (using hold+join) so that it remains locked across
multiple allocation/free transactions.

So I think pushing the inode joining inside xfs_trans_roll() is not
the right thing to do, but an "inode specific wrapper" such as
"xfs_trans_roll_inode()" would handle this just fine...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
