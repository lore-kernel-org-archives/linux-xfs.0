Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA906fDj125566 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 18:06:42 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 586491609FF
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 16:08:08 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	NppOkd4IUomyrXRy for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 16:08:08 -0800 (PST)
Date: Tue, 9 Nov 2010 11:08:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/16] xfs: dynamic speculative EOF preallocation
Message-ID: <20101109000805.GX2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-5-git-send-email-david@fromorbit.com>
	<20101108114325.GA19289@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101108114325.GA19289@infradead.org>
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

On Mon, Nov 08, 2010 at 06:43:25AM -0500, Christoph Hellwig wrote:
> > For default settings, ???e size and the initial extents is determined
> 
> weird character.
> 
> > The allocsize mount option still controls the minimum preallocation size, so
> > the smallest extent size can stil be bound in situations where this behaviour
> > is not sufficient.
> 
> Do we also need a way to keep an upper boundary?  Think lots of slowly
> growing log files on a filesystem not having tons of free space.

Perhaps - it's one of the things I've been debating backwards and
forwards and done nothing about yet.

It's hard to trim back preallocation before we hit ENOSPC via a
static threshold (e.g. 1% free space could be terabytes of space), but
once ENOSPC is hit we drop new preallocation completely. Perhaps a
gradual decrease in the maximum prealloc size based on freespace
remaining? e.g.

freespace	max prealloc size
  >5%		  full extent (8GB)
  4-5%		   2GB (8GB >> 2)
  3-4%		   1GB (8GB >> 3)
  2-3%		 512MB (8GB >> 4)
  1-2%		 256MB (8GB >> 5)
  <1%		 128MB (8GB >> 6)

I'm open to other ideas on what to do here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
