Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P6NIgk168040 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 01:23:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 700071C02C91
	for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 23:23:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	rXD5dGBJzC9Tk7jN for <xfs@oss.sgi.com>;
	Wed, 24 Aug 2011 23:23:17 -0700 (PDT)
Date: Thu, 25 Aug 2011 02:23:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: preparing a new xfsprogs release?
Message-ID: <20110825062316.GA17126@infradead.org>
References: <20110825050828.GA30775@infradead.org>
	<20110825061959.GN3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110825061959.GN3162@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Aug 25, 2011 at 04:19:59PM +1000, Dave Chinner wrote:
> On Thu, Aug 25, 2011 at 01:08:28AM -0400, Christoph Hellwig wrote:
> > We have the libxfs resync and a healthy amount of fixes in xfsprogs,
> > what about cutting a release in about 1-2 weeks from now?
> 
> Probably a good idea.
> 
> Once it is release, I'll look at doing another kernel code sync -
> this one will be a lot smaller than the last - and then we can start
> adding all the new stuff we've got on top of it...

I have a few things that I want to do to make syncs easier in the
future:

 - stop using the plain xfs.h include in userland, and use the same
   includes as in kernel space.  This might require some new stub
   headers and magic #include_next games in userland, but should really
   ease our life there.
 - split files only partially shared between kernel and userspace and
   logical boundaries so that they can be shared 1:1.  My poster child
   for that would be to split a xfs_busy_extent.c out of xfs_alloc.c.

But let's get this release out before starting major surgery.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
