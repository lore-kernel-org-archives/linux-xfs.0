Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U7ROjc120711 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 02:27:24 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80EA6124EA3
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 00:27:23 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	r2xF7oDBD3QWQsJd for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 00:27:23 -0700 (PDT)
Date: Tue, 30 Aug 2011 03:27:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: fix xfs_mark_inode_dirty during umount
Message-ID: <20110830072721.GA24364@infradead.org>
References: <20110827055731.GA24159@infradead.org>
	<20110827055744.GA28351@infradead.org>
	<20110830062416.GN3162@dastard>
	<20110830063949.GA19262@infradead.org>
	<20110830072013.GS3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110830072013.GS3162@dastard>
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

On Tue, Aug 30, 2011 at 05:20:13PM +1000, Dave Chinner wrote:
> Now that may have been true on Irix/MIPS which had strong memory
> ordering so only compiler barriers were necessary.
> 
> However, normally when we talk about ordered memory semantics in
> Linux, we cannot assume strong ordering - if we have ordering
> requirements, we have to guarantee ordering by explicit use of
> memory barriers, right?

Probably.  But I'm not worried about that so much, it's just timestamps
we're talking about as the size already has the ilock unlock as full
barrier, and we're going to kill this code soon anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
