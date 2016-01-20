Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4994F7F37
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 14:35:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AB968F8040
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 12:35:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kuQCSDXHmQGfO2DN for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2016 12:35:04 -0800 (PST)
Date: Thu, 21 Jan 2016 07:35:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Pass mp to kmem_alloc and friends?
Message-ID: <20160120203503.GD20456@dastard>
References: <569FCAED.4050306@sandeen.net>
	<20160120195354.GA5500@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160120195354.GA5500@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Wed, Jan 20, 2016 at 11:53:54AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 20, 2016 at 11:59:09AM -0600, Eric Sandeen wrote:
> > I had a request for the kmem_alloc deadlock warning to print the
> > filesystem involved.
> > 
> > Any objections to passing mp into kmem_alloc() and friends whenever
> > it's reasonably available from the caller?
> > 
> > It'd be a big mechanical change, don't want to embark on that unless
> > it seems acceptable & useful.
> > 
> > I think we generally know the root causes of the most common deadlock
> > warnings, but it's a warm fuzzy to give as much info as possible.
> > 
> > Heck, I almost wonder if passing a descriptive string in, for at
> > least the problematic cases we know about, i.e. "extent map realloc"
> > so we'd get something like:
> > 
> > XFS (sdb1): myprocess(123) possible memory allocation deadlock size 12345 during extent map realloc in kmem_alloc (mode:0x250)
> > 
> > I dunno ... too much? :)
> 
> Not enough?  What about putting in just enough macro madness to report
> the name & line number of the calling function in the message?
> 
> XFS (sdb1): myprocess(123) possible kmem_alloc deadlock in
> xfs_eat_my_data.c:5135 (size:12345 mode:0x250)

Problem with that is the the return address will often just point to
a higher level wrapper function, and we are still without any
caller context. e.g. if we find the caller is xfs_buf_alloc_maps(),
what operation was being performed that needed a new buffer
allocated?

IMO, the only thing that will actually be useful for debugging at
this point is a full stack dump....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
