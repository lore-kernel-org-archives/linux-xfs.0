Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43382 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfBVX3A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Feb 2019 18:29:00 -0500
Date: Fri, 22 Feb 2019 15:28:51 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] pmem: advertise page alignment for pmem devices
 supporting fsdax
Message-ID: <20190222232851.GC21626@magnolia>
References: <20190222182008.GT6503@magnolia>
 <20190222231136.GC23020@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190222231136.GC23020@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: dan.j.williams@intel.com, linux-nvdimm@lists.01.org, zwisler@kernel.org, vishal.l.verma@intel.com, xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Feb 23, 2019 at 10:11:36AM +1100, Dave Chinner wrote:
> On Fri, Feb 22, 2019 at 10:20:08AM -0800, Darrick J. Wong wrote:
> > Hi all!
> > 
> > Uh, we have an internal customer <cough> who's been trying out MAP_SYNC
> > on pmem, and they've observed that one has to do a fair amount of
> > legwork (in the form of mkfs.xfs parameters) to get the kernel to set up
> > 2M PMD mappings.  They (of course) want to mmap hundreds of GB of pmem,
> > so the PMD mappings are much more efficient.
> > 
> > I started poking around w.r.t. what mkfs.xfs was doing and realized that
> > if the fsdax pmem device advertised iomin/ioopt of 2MB, then mkfs will
> > set up all the parameters automatically.  Below is my ham-handed attempt
> > to teach the kernel to do this.
> 
> What's the before and after mkfs output?
> 
> (need to see the context that this "fixes" before I comment)

Here's what we do today assuming no options and 800GB pmem devices:

# blockdev --getiomin --getioopt /dev/pmem0 /dev/pmem1
4096
0
4096
0
# mkfs.xfs -N /dev/pmem0 -r rtdev=/dev/pmem1
meta-data=/dev/pmem0             isize=512    agcount=4, agsize=52428800 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=209715200, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=102400, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/pmem1             extsz=4096   blocks=209715200, rtextents=209715200

And here's what we do to get 2M aligned mappings:

# mkfs.xfs -N /dev/pmem0 -r rtdev=/dev/pmem1,extsize=2m -d su=2m,sw=1
meta-data=/dev/pmem0             isize=512    agcount=32, agsize=6553600 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=209715200, imaxpct=25
         =                       sunit=512    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=102400, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/pmem1             extsz=2097152 blocks=209715200, rtextents=409600

With this patch, things change as such:

# blockdev --getiomin --getioopt /dev/pmem0 /dev/pmem1
2097152
2097152
2097152
2097152
# mkfs.xfs -N /dev/pmem0 -r rtdev=/dev/pmem1
meta-data=/dev/pmem0             isize=512    agcount=32, agsize=6553600 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=209715200, imaxpct=25
         =                       sunit=512    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=102400, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =/dev/pmem1             extsz=2097152 blocks=209715200, rtextents=409600

I think the only change is the agcount, which for 2M mappings probably
isn't a huge deal.  It's obviously a bigger deal for 1G pages, assuming
we decide that's even advisable.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
