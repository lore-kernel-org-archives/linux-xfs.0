Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 06:20:14 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8ADK64p019600
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 06:20:07 -0700
Received: by wa-out-1112.google.com with SMTP id k22so1702051waf
        for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 06:20:08 -0700 (PDT)
Message-ID: <cc7060690709100620q66a533f8gda58cd0cbb19208a@mail.gmail.com>
Date: Mon, 10 Sep 2007 18:50:07 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: [PATCH] kill BMAPI_DEVICE
In-Reply-To: <20070910120103.GA3666@lst.de>
MIME-Version: 1.0
References: <20070909153947.GA19986@lst.de>
	 <cc7060690709091232w4185e788yf8a085e0e67e71e8@mail.gmail.com>
	 <20070910120103.GA3666@lst.de>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On 9/10/07, Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Sep 10, 2007 at 01:02:07AM +0530, Bhagi rathi wrote:
> > XFS_IOCORE_RT |  XFS_DIFLAG_REALTIME can be set from an ioctl
> (xfs_setattr).
> > A directIO without holding ILOCK
> > in shared in mode can read a wrong value of di_flag for real time
> decision.
> > As a result, we may pass in-correct device
> > during directIO as the proposed xfs_find_bdev_for_inode doesn't hold any
> > lock in reading the flags. It is not based
> > on iocore flags as well.
> >
> > On a secondary note, XFS_IOCORE_RT was set without holding iolock which
> > seems to an issue. I tend to leave
> > xfs_bmapi to decide BMAPI_DEVICE to xfs_iomap.
>
> The previous locking doesn't help anything - if the value changes during
> the direct I/O process we are in trouble anyway.  Fortunately we always
> hold the iolock in shared mode over any direct I/O, so taking this lock
> in ->setattr will fix this pre-existing issue.


Yes.  I believe the proposed change can succeed after the fix you mentioned.

> What is the reason why this has to be seperated?
>
> Because it does not belong into xfs_iomap.  While there is at least some
> common code between BMAPI_READ, BMAPI_WRITE and BMAPI_ALLOCATE calls so
> sharing that makes some sense it does not at all for the other two which
> this patch separates out in preparation of bigger changes in this area.


What is the goal of the bigger changes planned?

-Saradhi.


[[HTML alternate version deleted]]
