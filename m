Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VMpJM4233583 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 17:51:19 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E72813B5F63
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:54:44 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	2nHHholUDRls1LD4 for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 15:54:44 -0700 (PDT)
Date: Thu, 1 Sep 2011 08:51:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: fix xfs_mark_inode_dirty during umount
Message-ID: <20110831225113.GL32358@dastard>
References: <20110827055731.GA24159@infradead.org>
	<20110827055744.GA28351@infradead.org>
	<20110830062416.GN3162@dastard>
	<20110830063949.GA19262@infradead.org>
	<20110830072013.GS3162@dastard>
	<20110830072721.GA24364@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110830072721.GA24364@infradead.org>
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

On Tue, Aug 30, 2011 at 03:27:21AM -0400, Christoph Hellwig wrote:
> On Tue, Aug 30, 2011 at 05:20:13PM +1000, Dave Chinner wrote:
> > Now that may have been true on Irix/MIPS which had strong memory
> > ordering so only compiler barriers were necessary.
> > 
> > However, normally when we talk about ordered memory semantics in
> > Linux, we cannot assume strong ordering - if we have ordering
> > requirements, we have to guarantee ordering by explicit use of
> > memory barriers, right?
> 
> Probably.  But I'm not worried about that so much, it's just timestamps
> we're talking about as the size already has the ilock unlock as full
> barrier, and we're going to kill this code soon anyway.

Fair enough.

Consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
