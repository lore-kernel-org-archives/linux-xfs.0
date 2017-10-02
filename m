Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39802 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJBWPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Oct 2017 18:15:05 -0400
Date: Mon, 2 Oct 2017 15:15:00 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [Bug Report]: generic/085 trigger a XFS panic on kernel 4.14-rc2
Message-ID: <20171002221500.GA6503@magnolia>
References: <20170930032857.GQ21475@dhcp12-143.nay.redhat.com>
 <20171001225849.GH3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171001225849.GH3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org

On Mon, Oct 02, 2017 at 09:58:49AM +1100, Dave Chinner wrote:
> On Sat, Sep 30, 2017 at 11:28:57AM +0800, Zorro Lang wrote:
> > Hi,
> > 
> > I hit a panic[1] when I ran xfstests on debug kernel v4.14-rc2
> > (with xfsprogs 4.13.1), and I can reproduce it on the same machine
> > twice. But I can't reproduce it on another machine.
> > 
> > Maybe there're some hardware specific requirement to trigger this panic. I
> > tested on normal disk partition, but the disk is multi stripes RAID device.
> > I didn't get the mkfs output of g/085, bug I found the default mkfs output
> > (mkfs.xfs -f /dev/sda3) is:
> > 
> > meta-data=/dev/sda3              isize=512    agcount=16, agsize=982528 blks
> >          =                       sectsz=512   attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
> > data     =                       bsize=1024   blocks=15720448, imaxpct=25
> >          =                       sunit=512    swidth=1024 blks
> > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > log      =internal log           bsize=1024   blocks=10240, version=2
> >          =                       sectsz=512   sunit=32 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> FWIW, I've come across a few of these log recovery crashes recently
> when reworking mkfs.xfs. The cause of them has always been either a
> log being too small or a mismatch between log size and log stripe
> unit configuration. The typical sign of that was either a
> negative buffer length like this one (XFS (dm-0): Invalid block
> length (0xfffffed8) for buffer) or the head/tail block initially
> being calculated before/after the actual log and so the log offset
> was negative.
> 
> I'm guessing the recent log validity checking we've added isn't as
> robust as it should be, but I haven't had time to dig into it yet.
> I've debugged the issues far enough to point to mkfs being wrong
> with xfs_logprint - it runs the same head/tail recovery code as the
> kernel so typically crashes on the same problems as the kernel. It's
> much easier to debug in userspace with gdb, though.....

Just to pile on with everyone else: I've noticed that fuzzing logsunit
to -1 causes the mount process to spit out a bunch of recovery-related
io errors.  Shortly thereafter the kernel crashes too.

--D

> 
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
