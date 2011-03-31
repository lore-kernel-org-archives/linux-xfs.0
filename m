Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2V6QAvj120685 for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 01:26:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B760E131CAD6
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 23:29:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 14oWu4r6fD5UJYxO for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2011 23:29:21 -0700 (PDT)
Date: Thu, 31 Mar 2011 02:29:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix extent format buffer allocation size
Message-ID: <20110331062920.GA32336@infradead.org>
References: <1301453521-5614-1-git-send-email-david@fromorbit.com>
	<20110330093333.GA32582@infradead.org>
	<20110331055114.GC30279@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110331055114.GC30279@dastard>
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

On Thu, Mar 31, 2011 at 04:51:14PM +1100, Dave Chinner wrote:
> On Wed, Mar 30, 2011 at 05:33:34AM -0400, Christoph Hellwig wrote:
> > > +	xfs_bmbt_rec_t		*ext_buffer;
> > > +
> > > +	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork),
> > 
> > If the fork size be the minimum of XFS_IFORK_SIZE and the if_bytes
> > value?
> 
> I thought about that, but I don't think it makes any difference. If
> there are no delalloc extents, then XFS_IFORK_SIZE and ifp->if_bytes
> are identical when the fork is in extent format. If there are
> delalloc extents, then XFS_IFORK_SIZE() is the one we want. Hence I
> don't think we need to even consider the value of ifp->if_bytes at
> all here....

You're right.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
