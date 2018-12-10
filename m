Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44934 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbeLJOds (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Dec 2018 09:33:48 -0500
Date: Mon, 10 Dec 2018 09:33:46 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Enlarging w/ xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed:
 Inappropriate ioctl for device
Message-ID: <20181210143345.GB8356@bfoster>
References: <20181210042842.GA16286@draconx.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181210042842.GA16286@draconx.ca>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nick Bowler <nbowler@draconx.ca>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 09, 2018 at 11:29:04PM -0500, Nick Bowler wrote:
> Hello,
> 
> I'm a bit new to using XFS and I ran into some errors trying to enlarge
> a filesystem.  This setup uses dmcrypt on top of md raid and I just
> reshaped the array to add additional storage.  The underlying block
> device reflects the new size, but the filesystem hasn't been enlarged
> yet:
> 
>   # blockdev --report /dev/mapper/data             
>   RO    RA   SSZ   BSZ   StartSec            Size   Device
>   rw  4096   512  4096          0  20001386921984   /dev/mapper/data
> 
>   # findmnt /dev/mapper/data
>   TARGET    SOURCE           FSTYPE OPTIONS
>   /mnt/data /dev/mapper/data xfs    rw,relatime,attr2,inode64,sunit=1024,swidth=2048,noquota
> 
>   # df -h /mnt/data
>   Filesystem        Size  Used Avail Use% Mounted on
>   /dev/mapper/data  9.1T  8.5T  649G  94% /mnt/data
> 
> So I read the manpage and it seems all I should need to do is run
> xfs_growfs on the mounted filesystem but...
> 
>   # xfs_growfs /mnt/data
>   meta-data=/dev/mapper/data       isize=512    agcount=32, agsize=76299136 blks
>            =                       sectsz=4096  attr=2, projid32bit=1
>            =                       crc=1        finobt=1, sparse=1, rmapbt=0
>            =                       reflink=0
>   data     =                       bsize=4096   blocks=2441572352, imaxpct=5
>            =                       sunit=128    swidth=256 blks
>   naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>   log      =internal log           bsize=4096   blocks=521728, version=2
>            =                       sectsz=4096  sunit=1 blks, lazy-count=1
>   realtime =none                   extsz=4096   blocks=0, rtextents=0
>   xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Inappropriate ioctl for device
>   xfs_growfs: XFS_IOC_FSGEOMETRY xfsctl failed: Inappropriate ioctl for device
> 
> ... and the filesystem is not enlarged.  Looking at strace output, the
> failing ioctls seem to be:
> 
>   openat(AT_FDCWD, "/mnt/data", O_RDONLY) = 3
>   [...]
>   ioctl(3, _IOC(_IOC_WRITE, 0x58, 0x6e, 0x10), 0xffcc9a80) = -1 ENOTTY (Inappropriate ioctl for device)
>   [...]
>   ioctl(3, _IOC(_IOC_READ, 0x58, 0x64, 0x70), 0xffcc9ba0) = -1 ENOTTY (Inappropriate ioctl for device)
> 
> Kernel version is 4.14.82 with xfsprogs 4.17.0, although I tried also
> with xfsprogs 4.19.0 and received the same errors.
> 
> Am I missing something obvious here?  What further steps should I take
> to help solve this?
> 

The only thing that comes to mind while poking through the code is
perhaps xfsprogs is sending the traditional XFS_IOC_GROWFSDATA command
into the compat_ioctl() path somehow or another (assuming
BROKEN_X86_ALIGNMENT is set).

What arch is your kernel/xfsprogs? What does 'cat
/sys/kernel/debug/trace/trace' show if you run  'trace-cmd start -e
xfs:xfs_file*ioctl*' and then attempt the growfs?

Brian

> Thanks,
>   Nick
