Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 13:31:03 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8DKUt4p011302
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 13:30:56 -0700
Date: Thu, 13 Sep 2007 21:30:55 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: TAKE 970240 - kill BMAPI_DEVICE
Message-ID: <20070913203055.GA14895@infradead.org>
References: <20070913043416.CCFAC2F9EBDB@linuxbuild.melbourne.sgi.com> <cc7060690709131223o7bb4f75sd6a42e30a6a078c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc7060690709131223o7bb4f75sd6a42e30a6a078c3@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: "donaldd@sgi.com" <donaldd@sgi.com>, xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

On Fri, Sep 14, 2007 at 12:53:20AM +0530, Bhagi rathi wrote:
> Can one of you let me know the process of submitting changes?

Just send a unified diff (using diff -u) to the list.

> 
> Problem: Real time flag set on a regular file can race with directio which
> can lead to
>               incorrect real time device for iomap in xfs_vm_direct_IO. This
> can happen
>               only on the first I/O to the file as we don't set real time
> flag if any of
>               the extents or delayed blocks present.
> 
> Fix:
> 
>   xfs_setattr() {
>           ...
>           if (!(mask & XFS_AT_SIZE)) {
>                  if (need_io_lock && vap->va_xflags & XFS_XFLAG_REALTIME)
>                         lock_flags |= XFS_IOLOCK_EXCL;
>                  .....
>           }

I have a patch queued up aswell, although it's after a reorganization of
the code to not clutter xfs_setattr even more.  If you want to send out
the fix now please go ahead.
