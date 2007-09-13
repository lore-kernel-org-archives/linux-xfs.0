Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 12:49:45 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.183])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8DJnc4p004667
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 12:49:42 -0700
Received: by wa-out-1112.google.com with SMTP id k22so776795waf
        for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 12:49:40 -0700 (PDT)
Message-ID: <cc7060690709131223o7bb4f75sd6a42e30a6a078c3@mail.gmail.com>
Date: Fri, 14 Sep 2007 00:53:20 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: TAKE 970240 - kill BMAPI_DEVICE
In-Reply-To: <20070913043416.CCFAC2F9EBDB@linuxbuild.melbourne.sgi.com>
MIME-Version: 1.0
References: <20070913043416.CCFAC2F9EBDB@linuxbuild.melbourne.sgi.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "donaldd@sgi.com" <donaldd@sgi.com>
Cc: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Can one of you let me know the process of submitting changes?

Problem: Real time flag set on a regular file can race with directio which
can lead to
              incorrect real time device for iomap in xfs_vm_direct_IO. This
can happen
              only on the first I/O to the file as we don't set real time
flag if any of
              the extents or delayed blocks present.

Fix:

  xfs_setattr() {
          ...
          if (!(mask & XFS_AT_SIZE)) {
                 if (need_io_lock && vap->va_xflags & XFS_XFLAG_REALTIME)
                        lock_flags |= XFS_IOLOCK_EXCL;
                 .....
          }
         ...
 }


-Thanks,
 Saradhi.


On 9/13/07, donaldd@sgi.com <donaldd@sgi.com> wrote:
>
> kill BMAPI_DEVICE
>
> There is no reason to go into the iomap machinery just to get the
> right block device for an inode.  Instead look at the realtime flag
> in the inode and grab the right device from the mount structure.
>
> I created a new helper, xfs_find_bdev_for_inode instead of opencoding
> it because I plan to use it in other places in the future.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de >
>
> Date:  Thu Sep 13 14:33:42 AEST 2007
> Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
> Inspected by:  hch@lst.de
>
> The following file(s) were checked into:
>   longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb
>
>
> Modid:  xfs-linux-melb:xfs-kern:29680a
> fs/xfs/xfs_iomap.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_iomap.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
>         - kill BMAPI_DEVICE
>
> fs/xfs/xfs_iomap.c - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> xfs_iomap.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
>         - kill BMAPI_DEVICE
>
> fs/xfs/linux-2.6/xfs_aops.c - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/> linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
>
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
>         - kill BMAPI_DEVICE
>
>
>
>


[[HTML alternate version deleted]]
