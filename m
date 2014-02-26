Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD6F77F37
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 23:44:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 78089AC002
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 21:44:13 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bkhH576ZPRxXuM1P for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 21:44:11 -0800 (PST)
Date: Wed, 26 Feb 2014 16:44:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: byte range buffer dirty region tracking
Message-ID: <20140226054406.GP13647@dastard>
References: <1393194354-12780-1-git-send-email-david@fromorbit.com>
	<20140226021525.GB26022@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140226021525.GB26022@infradead.org>
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

On Tue, Feb 25, 2014 at 06:15:25PM -0800, Christoph Hellwig wrote:
> Interesting.  I had a prototype of this supporting just a single
> region a while ago, but never managed to get it to pass all recovery
> tests.  That was before I separated the in-core from the on-disk
> log items, though.

Yeah, that makes it much easier to deal with. It's still a bit
messy though, and it still panics every so often under heavy load.
IOWs I still don't quite have the range-to-bitmap accounting
correct.

> > Hence if we just track a signle region, it will almost always cover
> > the entire directory buffer - if we only modify a single entry in
> > the buffer, then that's a fairly large cost in terms of log space
> > and CPU overhead for random individual operations. If we decide that
> > we are going to use a single range, then we may as well just use the
> > dirty flag and log the entire buffer every time.
> 
> Which might not be an all that bad idea given how much log bandwith
> we have available.  Defintively would be interesting to instrument
> and benchmark it vs the 4 regions version.

Well, for v4 filesystems under create workloads the increase is
definitely noticable - I haven't got measurements to hand, though it
was somethign in the order 30% or so for 256 byte inodes due to the
increase in size of the inode cluster buffers being logged. For
larger inodes that's going to be even worse. We don't have to worry
on v5 filesystems, though, so only btree blocks are the main
concern....

> Note that we probably should also introduce a log incompat feature to
> just log the range instead of converting it to the old bitmap for v5
> filesystems.

Yup, that's easy enough to do, and should make the v5 code even
simpler and faster....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
