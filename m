Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 955557F4E
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 11:27:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F25CBAC00C
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 09:27:03 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id hHwrHeHYzMHh2kbf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 09:27:02 -0700 (PDT)
Date: Fri, 6 Sep 2013 09:27:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: move buf_ops externs to a xfs_format.h
Message-ID: <20130906162701.GA9994@infradead.org>
References: <1378382015-16026-1-git-send-email-david@fromorbit.com>
	<1378382015-16026-2-git-send-email-david@fromorbit.com>
	<20130905190407.GA603@infradead.org>
	<20130905235412.GN12779@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130905235412.GN12779@dastard>
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

On Fri, Sep 06, 2013 at 09:54:12AM +1000, Dave Chinner wrote:
> Fair enough - I thought about that, but then realised we don't
> really have any "global" shared header files that fit this purpose.
> The only two really are xfs_fs.h - which is used for ioctl interface
> definitions - and xfs_types.h which is used for type definitions,
> not structure instances...
> 
> So I'm not really sure where we'd put something like this without
> creating a new header file, and I don't really want to do that,
> either.

We might need a new one, the headers still need major work anyway.

If we start with

	xfs*_format.h - purely disk format
	xfs_fs.h - ioctl and userspace ABI constants

an

	xfs_shared.h

and
	xfs_kernel.h

seem like logical additions to move most of the misc headers to instead
of all the silly ones for just a handful or two worth of prototypes.

Note that a few non-format bits already sneaked into xfs_format.h
unfortunately, guess I need to watch more closely :)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
