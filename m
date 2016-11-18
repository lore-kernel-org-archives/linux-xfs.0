Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:53273 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751713AbcKRFqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Nov 2016 00:46:25 -0500
Date: Fri, 18 Nov 2016 16:46:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [BUG] dd doesn't return on ENOSPC and hang when fulfilling
 rmapbt XFS
Message-ID: <20161118054620.GG28177@dastard>
References: <20161117163515.GB27776@eguan.usersys.redhat.com>
 <20161117173639.GJ16813@birch.djwong.org>
 <20161117201102.GK16813@birch.djwong.org>
 <20161118052633.GE27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161118052633.GE27776@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Nov 18, 2016 at 01:26:33PM +0800, Eryu Guan wrote:
> On Thu, Nov 17, 2016 at 12:11:02PM -0800, Darrick J. Wong wrote:
> > On Thu, Nov 17, 2016 at 09:36:39AM -0800, Darrick J. Wong wrote:
> > > On Fri, Nov 18, 2016 at 12:35:15AM +0800, Eryu Guan wrote:
> > > > Hi all,
> > > > 
> > > > I hit a test hang in generic/224 when testing rmapbt enabled XFS on a
> > > > host that has non-zero sunit/swidth reported from underlying device. And
> > > > I simplified the reproducer to the following script, and the hang can be
> > > > reproduced on any host now.
> > > > 
> > > > -----
> > > > #!/bin/bash
> > > > 
> > > > dev=/dev/sda5
> > > > mnt=/mnt/xfs
> > > > 
> > > > mkfs -t xfs -m rmapbt=1 -d agcount=8,size=1g -f $dev
> > > 
> > > Hm.  I formatted with:
> > > mkfs.xfs -m rmapbt=1 -d sunit=4096,swidth=40960 -f /dev/sdf
> > > 
> > > (made up sunit numbers just to see how whacky it could get)
> > > 
> > > and got a different hang instead.  It looks like we are unable to
> > > allocate any blocks to the bmbt and various things blow up from
> > > there.  Will go retry with tracepoints on to see if we're running
> > > out of AG reservation or if we're really out of disk blocks or what.
> > > 
> > > Crash message attached at the end.
> > 
> > Hm.  Looking at the indlen calculations, I see that we don't include the
> > space that the rmapbt might need to store all the reverse mappings.  I
> > think this is a problem, since we decline delalloc reservations if (len
> > + indlen) > fdblocks, but we potentially end up using more than indlen
> > blocks to map len blocks into the file, so the allocator goes nuts.
> > 
> > Eryu, does the following patch fix the problem you see?  I ran your
> > reproducer and mine and it fixed the problem in both cases.  I didn't
> > observe any issues running generic/224 either.
> 
> I applied your patch (and only your patch, patches posted by Dave were
> not included) on top of 4.9-rc5 kernel, and it passed my simplified
> reproducer, but still failed generic/224 with
> 
> MKFS_OPTIONS="-b size=4k -m crc=1,rmapbt=1 -d agcount=8"
> 
> Not all the time, but easily to hit. And sysrq-w showed the same traces
> as before.
> 
> SECTION       -- xfs_test
> RECREATING    -- xfs on /dev/mapper/testvg-testlv1
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 ibm-x3550m3-05 4.9.0-rc5+
> MKFS_OPTIONS  -- -f -f -b size=4k -m crc=1,rmapbt=1 -d agcount=8 /dev/mapper/testvg-testlv2
> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/mapper/testvg-testlv2 /mnt/testarea/scratch
> 
> generic/224 16s ...  <===== never return

My patchset does pass generic/224 here, but it fails lots of other tests
because of an accounting problem I've not yet found.

SECTION       -- xfs
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test2 4.9.0-rc4-dgc+
MKFS_OPTIONS  -- -f -m rmapbt=1 -i sparse=1 /dev/sdg
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/sdg /mnt/scratch

generic/224 25s ... 24s
Ran: generic/224
Passed all 1 tests

SECTION       -- xfs
=========================
Ran: generic/224
Passed all 1 tests

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
