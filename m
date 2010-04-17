Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3H1MNxT026568 for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 20:22:24 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF7FF2CBDC4
	for <xfs@oss.sgi.com>; Fri, 16 Apr 2010 18:24:18 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	rFQa401dGcTuV7gP for <xfs@oss.sgi.com>;
	Fri, 16 Apr 2010 18:24:18 -0700 (PDT)
Date: Sat, 17 Apr 2010 11:24:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_fsr question for improvement
Message-ID: <20100417012415.GE2493@dastard>
References: <201004161043.11243@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004161043.11243@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Fri, Apr 16, 2010 at 10:43:10AM +0200, Michael Monnerie wrote:
> From the man page I read that a file is defragmented by copying it to a 
> free space big enough to place it in one extent.
> 
> Now I have a 4TB filesystem, where all files written are at least 1GB, 
> average 5GB, up to 30GB each. I just xfs_growfs'd that filesystem to 
> 6TB, as it was 97% full (150GB free). Every night a xfs_fsr runs and 
> finished to defragment everything, except during the last days where it 
> didn't find enough free space in a row to defragment.
> 
> Could it be that the defragmentation did it's job but in the end the 
> file layout was like this:
> file 1GB
> freespace 900M
> file 1GB
> freespace 900M
> file 1GB
> freespace 900M
> That, while being an "almost worst case" scenario, would mean that once 
> the filesystem is about 50% full, new 1GB files will be fragmented all 
> the time.

Yup, xfs_fsr does not care about free space fragmentation - it just
cares about reducing the number of extents in the target file. fsr
is not very smart, because being smart is hard. Also fsr is generally
not needed because the allocator usuallly does a pretty good job up
front of laying out files contiguously.

However, The mistake that _everyone_ is making is that "not quite
perfect" does not equal "fragmented and needs fixing."

2 extents in a 1GB file is not a fragmented file - if the number was
in the hundreds then I'd be saying that it was fragmented, but not
single digits. XFS resists fragmentation better than most other
filesystems, so defragmentation, while possible, is generally not
needed.

You've got to think about what the numbers you are seeing really
mean before you can determine if you have a fragmentation problem or
not. If you don't understand what they mean in terms of your
applications or you aren't seeing any adverse performance problems,
then you don't have a fragmentation problem, not matter what the
numbers say....

e.g. I only consider a file fragmented enough to run fsr on it when
the number of extents or location of them is such that I can't get
large IOs from it (i.e. extents of less than a couple of megabytes
for most users) and it therefore affects performance. An example of
this is my VM block device images:

$ for f in `ls *.img`; do sudo xfs_bmap -v $f |tail -1 | awk '// {print $1}' ; done
856:
2676:
103:
823:
5452:
4734:
9222:
4101:
4258:

They have thousands of extents in them and they are all between
8-10GB in size, and IO from my VMs are stiall capable of saturating
the disks backing these files. While I'd normally consider these
files fragmented and candidates for running fsr on tme, the number
of extents is not actually a performance limiting factor and so
there's no point in defragmenting them. Especially as that requires
shutting down the VMs...

> To prevent this, xfs_fsr should do a "compress" phase after 
> defragmentation finished, in order to move all the files behind each 
> other:
> file 1GB
> file 1GB
> file 1GB
> file 1GB
> freespace 3600M
> That would also help fill the filesystem from front to end, reducing 
> disk head moves.

Packing requires a whole lot more knowledge of the filesytem layout
in fsr, like where the free space is. We don't export that
information to userspace. It also requires the ability to allocate
at specific locations, instead of letting the allocator choose as it
does now. This is also a capability we don't have from userspace.

If you want to extend fsr to do this, you need to discover all the
files that have data in the same AG as the one you want to pack
(requires a full filesystem scan to build a block-to-owner inode
mapping), then move the data out of the identified areas of
freespace fragmentation into other AGs, then move them back in using
preallocation. This will pack the data as best as possible. I don't
have time to do this myself, but I'll happily review the patches ;)

Alternatively, if you want to pack your filesystem right now, copy
everything off it and then copy it back on. i.e. dump and restore.

> Another thing, but related to xfs_fsr, is that I did an xfs_repair on 
> that filesystem once, and I could see there were a lot of small I/Os 
> done, with almost no throughput. The disks are 7.200rpm 2TB disks, so 
> random disk access is horribly slow, and it looked like the disks were 
> doing nothing else but seeking.

This is not at all related to xfs_fsr. Newer versions of repair are
much smarter about reading metadata off disk - they can do readahead
and reorder IOs into ascending block offset....

> Would it be possible xfs_fsr defrags the meta data in a way that they 
> are all together so seeks are faster?

It's not related to fsr because fsr does not defragment metadata.
Some metadata cannot be defragmented (e.g. inodes cannot be moved),
some metadata cannot be manipulated directly (e.g. free space
btrees), and some is just difficult to do (e.g. directory
defragmentation) so hasn't ever been done.

> Currently, when I do "find /this_big_fs -inum 1234", it takes *ages* for 
> a run, while there are not so many files on it:
> # iostat -kx 5 555
> Device:         r/s     rkB/s    avgrq-sz avgqu-sz   await  svctm  %util
> xvdb              23,20    92,80     8,00     0,42   15,28  18,17  42,16
> xvdc              20,20    84,00     8,32     0,57   28,40  28,36  57,28

Well, it's not XFS's fault that each read IO is taking 20-30ms. You
can only do 30-50 IOs a second per drive at that rate, so:

[...]
> So I get 43 reads/second at 100% utilization. Well I can see up to 

This is right on the money - it's going as fast a your (slow) RAID-5
volume will allow it to....

> 150r/s, but still that's no "wow". A single run to find an inode takes a 
> very long time.

Raid 5/6 generally provides the same IOPS performance as a single
spindle, regardless of the width of the RAID stripe. A 2TB sata
drive might be able to do 150-200 IOPS, so a RAID5 array made up of
these drives will tend to max out at roughly the same....

> # df -i
> Filesystem            Inodes         IUsed          IFree      IUse%
> mybigstore            1258291200  765684 1257525516    1%
> 
> So only 765.684 files, and it takes about 8 minutes for a "find" pass.
> Maybe an xfs_fsr over metadata could help here?

Eric increased the directory read buffer size fed to XFS recently,
which should allow more readahead to occur internally to large
directories. This will help reading large directories, but nothing can
be done in XFS if the directories are small because inodes can't be
moved and find does not do readahead of directory inodes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
