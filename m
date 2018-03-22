Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34292 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751617AbeCVX0m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 19:26:42 -0400
Date: Thu, 22 Mar 2018 16:26:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: file corruptions, 2nd half of 512b block
Message-ID: <20180322232629.GF4818@magnolia>
References: <20180322150226.GA31029@onthe.net.au>
 <20180322180327.GI16617@bfoster.bfoster>
 <20180322230450.GT1150@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180322230450.GT1150@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Chris Dunlop <chris@onthe.net.au>, linux-xfs@vger.kernel.org

On Fri, Mar 23, 2018 at 10:04:50AM +1100, Dave Chinner wrote:
> On Thu, Mar 22, 2018 at 02:03:28PM -0400, Brian Foster wrote:
> > On Fri, Mar 23, 2018 at 02:02:26AM +1100, Chris Dunlop wrote:
> > > Eyeballing the corrupted blocks and matching good blocks doesn't show
> > > any obvious pattern. The files themselves contain compressed data so
> > > it's all highly random at the block level, and the corruptions
> > > themselves similarly look like random bytes.
> > > 
> > > The corrupt blocks are not a copy of other data in the file within the
> > > surrounding 256k of the corrupt block.
> > > 
> > 
> > So you obviously have a fairly large/complex storage configuration. I
> > think you have to assume that this corruption could be introduced pretty
> > much anywhere in the stack (network, mm, fs, block layer, md) until it
> > can be narrowed down.
> > 
> > > ----------------------------------------------------------------------
> > > System configuration
> > > ----------------------------------------------------------------------
> > > 
> > > linux-4.9.76
> > > xfsprogs 4.10
> > > CPU: 2 x E5620 (16 cores total)
> > > 192G RAM
> > > 
> > > # grep bigfs /etc/mtab
> > > /dev/mapper/vg00-bigfs /bigfs xfs rw,noatime,attr2,inode64,logbsize=256k,sunit=1024,swidth=9216,noquota 0 0
> > > # xfs_info /bigfs
> > > meta-data=/dev/mapper/vg00-bigfs isize=512    agcount=246, agsize=268435328 blks
> > >         =                       sectsz=4096  attr=2, projid32bit=1
> > >         =                       crc=1        finobt=1 spinodes=0 rmapbt=0
> > >         =                       reflink=0
> > > data     =                       bsize=4096   blocks=65929101312, imaxpct=5
> > >         =                       sunit=128    swidth=1152 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > > log      =internal               bsize=4096   blocks=521728, version=2
> > >         =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > 
> > > XFS on LVM on 6 x PVs, each PV is md raid-6, each with 11 x hdd.
> 
> Are these all on the one raid controller? i.e. what's the physical
> layout of all these disks?
> 
> > > The raids all check clean.
> > > 
> > > The XFS has been expanded a number of times.
> > > 
> > > ----------------------------------------------------------------------
> > > Explicit example...
> > > ----------------------------------------------------------------------
> > > 
> > > 2018-03-04 21:40:44 data + md5 files written
> > > 2018-03-04 22:43:33 checksum mismatch detected
> > 
> > Seems like the corruption is detected fairly soon after creation. How
> > often are these files explicitly checked/read? I also assume the files
> > aren't ever modified..?
> > 
> > FWIW, the patterns that you have shown so far do seem to suggest
> > something higher level than a physical storage problem. Otherwise, I'd
> > expect these instances wouldn't always necessarily land in file data.
> > Have you run 'xfs_repair -n' on the fs to confirm there aren't any other
> > problems?
> > 
> > OTOH, a 256b corruption seems quite unusual for a filesystem with 4k
> > blocks. I suppose that could suggest some kind of memory/cache
> > corruption as opposed to a bad page/extent state or something of that
> > nature.
> 
> Especially with the data write mechanisms being used - e.g. NFS
> won't be doing partial sector reads and writes for data transfer -
> it'll all be done in blocks much larger that the filesystem block
> size (e.g. 1MB IOs).
> 
> > Hmm, I guess the only productive thing I can think of right now is to
> > see if you can try and detect the problem as soon as possible. For e.g.,
> > it sounds like this is a closed system. If so, could you follow up every
> > file creation with an immediate md5 verification (perhaps followed by an
> > fadvise(DONTNEED) and another md5 check to try and catch an inconsistent
> > pagecache)? Perhaps others might have further ideas..
> 
> Basically, the only steps now are a methodical, layer by layer
> checking of the IO path to isolate where the corruption is being
> introduced. First you need a somewhat reliable reproducer that can
> be used for debugging.
> 
> Write patterned files (e.g. encode a file id, file offset and 16 bit
> cksum in every 8 byte chunk) and then verify them. When you get a
> corruption, the corrupted data will tell you where the corruption
> came from. It'll either be silent bit flips, some other files' data,
> or it will be stale data.i See if the corruption pattern is
> consistent. See if the locations correlate to a single disk, a
> single raid controller, a single backplane, etc. i.e. try to find
> some pattern to the corruption.
> 
> Unfortunately, I can't find the repository for the data checking
> tools that were developed years ago for doing exactly this sort of
> testing (genstream+checkstream) online anymore - they seem to
> have disappeared from the internet. (*) Shouldn't be too hard to
> write a quick tool to do this, though.

https://sourceforge.net/projects/checkstream/ ?

--D

> Also worth testing is whether the same corruption occurs when you
> use direct IO to write and read the files. That would rule out a
> large chunk of the filesystem and OS code as the cause of the
> corruption.
> 
> (*) Google is completely useless for searching for historic things,
> mailing lists and/or code these days. Searching google now reminds
> of the bad old days of AltaVista - "never finds what I'm looking
> for"....
> 
> > > file size: 31232491008 bytes
> > > 
> > > The file is moved to "badfile", and the file regenerated from source
> > > data as "goodfile".
> 
> What does "regenerated from source" mean?
> 
> DOes that mean a new file is created, compressed and then copied
> across? Or is it just the original file being copied again?
> 
> > > From extent 16, the actual corrupt sector offset within the lv device
> > > underneath xfs is:
> > > 
> > > 289315926016 + (53906431 - 45826040) == 289324006407
> > > 
> > > Then we can look at the devices underneath the lv:
> > > 
> > > # lvs --units s -o lv_name,seg_start,seg_size,devices
> > >  LV    Start         SSize         Devices
> > >  bigfs            0S 105486999552S /dev/md0(0)
> > >  bigfs 105486999552S 105487007744S /dev/md4(0)
> > >  bigfs 210974007296S 105487007744S /dev/md9(0)
> > >  bigfs 316461015040S  35160866816S /dev/md1(0)
> > >  bigfs 351621881856S 105487007744S /dev/md5(0)
> > >  bigfs 457108889600S  70323920896S /dev/md3(0)
> > > 
> > > Comparing our corrupt sector lv offset with the start sector of each md
> > > device, we can see the corrupt sector is within /dev/md9 and not at a
> > > boundary. The corrupt sector offset within the lv data on md9 is given
> > > by:
> 
> Does, the problem always occur on /dev/md9?
> 
> If so, does the location correlate to a single disk in /dev/md9?
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
