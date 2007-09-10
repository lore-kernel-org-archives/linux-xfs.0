Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 05:01:15 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8AC144p006927
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 05:01:07 -0700
Date: Mon, 10 Sep 2007 14:01:03 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] kill BMAPI_DEVICE
Message-ID: <20070910120103.GA3666@lst.de>
References: <20070909153947.GA19986@lst.de> <cc7060690709091232w4185e788yf8a085e0e67e71e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7060690709091232w4185e788yf8a085e0e67e71e8@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Sep 10, 2007 at 01:02:07AM +0530, Bhagi rathi wrote:
> XFS_IOCORE_RT |  XFS_DIFLAG_REALTIME can be set from an ioctl (xfs_setattr).
> A directIO without holding ILOCK
> in shared in mode can read a wrong value of di_flag for real time decision.
> As a result, we may pass in-correct device
> during directIO as the proposed xfs_find_bdev_for_inode doesn't hold any
> lock in reading the flags. It is not based
> on iocore flags as well.
> 
> On a secondary note, XFS_IOCORE_RT was set without holding iolock which
> seems to an issue. I tend to leave
> xfs_bmapi to decide BMAPI_DEVICE to xfs_iomap.

The previous locking doesn't help anything - if the value changes during
the direct I/O process we are in trouble anyway.  Fortunately we always
hold the iolock in shared mode over any direct I/O, so taking this lock
in ->setattr will fix this pre-existing issue.

> What is the reason why this has to be seperated?

Because it does not belong into xfs_iomap.  While there is at least some
common code between BMAPI_READ, BMAPI_WRITE and BMAPI_ALLOCATE calls so
sharing that makes some sense it does not at all for the other two which
this patch separates out in preparation of bigger changes in this area.
