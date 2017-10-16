Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752165AbdJPKJG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 06:09:06 -0400
Date: Mon, 16 Oct 2017 06:09:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [Bug Report]: generic/085 trigger a XFS panic on kernel 4.14-rc2
Message-ID: <20171016100904.GA58994@bfoster.bfoster>
References: <20170930032857.GQ21475@dhcp12-143.nay.redhat.com>
 <20171002135618.GA32279@bfoster.bfoster>
 <20171013132935.GE21475@dhcp12-143.nay.redhat.com>
 <20171013181605.GA46787@bfoster.bfoster>
 <20171013195334.GB46787@bfoster.bfoster>
 <20171014223447.GC15067@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171014223447.GC15067@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Sun, Oct 15, 2017 at 09:34:47AM +1100, Dave Chinner wrote:
> On Fri, Oct 13, 2017 at 03:53:35PM -0400, Brian Foster wrote:
> > On Fri, Oct 13, 2017 at 02:16:05PM -0400, Brian Foster wrote:
> > > On Fri, Oct 13, 2017 at 09:29:35PM +0800, Zorro Lang wrote:
> > > > On Mon, Oct 02, 2017 at 09:56:18AM -0400, Brian Foster wrote:
> > > > > On Sat, Sep 30, 2017 at 11:28:57AM +0800, Zorro Lang wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > I hit a panic[1] when I ran xfstests on debug kernel v4.14-rc2
> > > > > > (with xfsprogs 4.13.1), and I can reproduce it on the same machine
> > > > > > twice. But I can't reproduce it on another machine.
> > > > > > 
> > > > > > Maybe there're some hardware specific requirement to trigger this panic. I
> > > > > > tested on normal disk partition, but the disk is multi stripes RAID device.
> > > > > > I didn't get the mkfs output of g/085, bug I found the default mkfs output
> > > > > > (mkfs.xfs -f /dev/sda3) is:
> > > > > > 
> > > > > > meta-data=/dev/sda3              isize=512    agcount=16, agsize=982528 blks
> > > > > >          =                       sectsz=512   attr=2, projid32bit=1
> > > > > >          =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
> > > > > > data     =                       bsize=1024   blocks=15720448, imaxpct=25
> > > > > >          =                       sunit=512    swidth=1024 blks
> > > > > > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > > > > > log      =internal log           bsize=1024   blocks=10240, version=2
> > > > > >          =                       sectsz=512   sunit=32 blks, lazy-count=1
> > > > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > > > > 
> > > > > > (The test machine is not on my hand now, I need time reserve it.)
> > > > > > 
> > > > > 
> > > > > If you are able to reproduce, could you provide a metadump of this fs
> > > > > immediately after the crash?
> > > > 
> > > > Finally I got the machine which can reproduce this bug for 1 day. Then I
> > > > got the XFS metadump which can trigger this bug.
> > > > 
> > > > Please download the metadump file by opening below link:
> > > > https://drive.google.com/file/d/0B5dFDeCXGOPXalNuMUJNdDM3STQ/view?usp=sharing
> > > > 
> > > > Just mount this xfs image, then kernel will crash. I didn't do any operations
> > > > on this XFS, just did "mkfs.xfs -b size=1024".
> > > > 
> > > 
> > > Thanks Zorro. I can reproduce with this image. It looks like the root
> > > problem is that a block address calculation goes wrong in
> > > xlog_find_head():
> > > 
> > > 	start_blk = log_bbnum - (num_scan_bblks - head_blk);
> > > 
> > > With log_bbnum = 3264, num_scan_bblks = 4096 and head_blk = 512,
> > > start_blk underflows and we go off the rails from there. Aside from
> > > addressing the crash, I think either this value and/or num_scan_bblks
> > > need to be clamped to within the range of the log.
> > > 
> > 
> > Actually Zorro, how are you creating a filesystem with such a small log?
> > I can't seem to create anything with a log smaller than 2MB. FWIW,
> > xfs_info shows the following once I work around the crash and mount the
> > fs:
> > 
> > meta-data=/dev/mapper/test-scratch isize=512    agcount=8, agsize=32256 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=1024   blocks=258048, imaxpct=25
> >          =                       sunit=512    swidth=1024 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal               bsize=1024   blocks=1632, version=2
> >          =                       sectsz=512   sunit=32 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> THis is one of the issues I came across with my mkfs refactoring.
> 
> The problem is the block size is 1k, not 4k, and there's a check
> somewhere against the number of log blocks rather than bytes, and
> so you can get a log smaller than the 2MB window that log recovery
> expects from 8x256k log buffers....
> 
> i.e. somewhere in mkfs we need to clamp the minimum log size to
> something greater than 2MB. I didn't get to the bottom of it - I
> fixed the option parsing bug that caused it and the log went to
> someting like 4.5MB instead of 1.6MB....
> 

Ok, so it sounds like that is the root cause and is fixed by the mkfs
rework. I have a couple patches laying around that fix up the
calculation and add some error checks to prevent the kernel crash, but
this has me wondering whether we should fail to mount the fs due to the
geometry. Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
