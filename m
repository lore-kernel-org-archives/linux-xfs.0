Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2ED9C7F3F
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 09:51:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A2C59AC004
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 07:51:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZyBtBGZbXqtNNTwJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 06 Sep 2014 07:51:16 -0700 (PDT)
Date: Sat, 6 Sep 2014 10:51:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Is XFS suitable for 350 million files on 20TB storage?
Message-ID: <20140906145105.GA23506@bfoster.bfoster>
References: <540986B1.4080306@profihost.ag>
	<20140905123058.GA29710@bfoster.bfoster>
	<5409AF40.10801@profihost.ag> <20140905230528.GO20473@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140905230528.GO20473@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Sat, Sep 06, 2014 at 09:05:28AM +1000, Dave Chinner wrote:
> On Fri, Sep 05, 2014 at 02:40:32PM +0200, Stefan Priebe - Profihost AG wrote:
> > 
> > Am 05.09.2014 um 14:30 schrieb Brian Foster:
> > > On Fri, Sep 05, 2014 at 11:47:29AM +0200, Stefan Priebe - Profihost AG wrote:
> > >> Hi,
> > >>
> > >> i have a backup system running 20TB of storage having 350 million files.
> > >> This was working fine for month.
> > >>
> > >> But now the free space is so heavily fragmented that i only see the
> > >> kworker with 4x 100% CPU and write speed beeing very slow. 15TB of the
> > >> 20TB are in use.
> 
> What does perf tell you about the CPU being burnt? (i.e run perf top
> for 10-20s while that CPU burn is happening and paste the top 10 CPU
> consuming functions).
> 
> > >>
> > >> Overall files are 350 Million - all in different directories. Max 5000
> > >> per dir.
> > >>
> > >> Kernel is 3.10.53 and mount options are:
> > >> noatime,nodiratime,attr2,inode64,logbufs=8,logbsize=256k,noquota
> > >>
> > >> # xfs_db -r -c freesp /dev/sda1
> > >>    from      to extents  blocks    pct
> > >>       1       1 29484138 29484138   2,16
> > >>       2       3 16930134 39834672   2,92
> > >>       4       7 16169985 87877159   6,45
> > >>       8      15 78202543 999838327  73,41
> 
> With an inode size of 256 bytes, this is going to be your real
> problem soon - most of the free space is smaller than an inode
> chunk so soon you won't be able to allocate new inodes, even though
> there is free space on disk.
> 

The extent list here is in fsb units, right? 256b inodes means 16k inode
chunks, in which case it seems like there's still plenty of room for
inode chunks (e.g., 8-15 blocks -> 32k-64k).

If you're at 350m inodes for 15T with 5T to go, that's 23.3m inodes per
TB and extrapolates to ~117m more to enospc. That's 1.8m inode chunks
out of the ~80m 8-15 block records currently free, and doesn't count the
20+ million inodes that seem to be scattered about the existing records
as well.

I certainly could be missing something here, but it seems like premature
enospc due to inode chunk allocation failure might not be an impending
problem here (likely due to using the smallest inode size, the risk
seems to increase much more using the larger inode sizes)...

> Unfortunately, there's not much we can do about this right now - we
> need development in both user and kernel space to mitigate this
> issue: spare inode chunk allocation in kernel space, and free space
> defragmentation in userspace. Both are on the near term development
> list....
> 
> Also, the fact that there are almost 80 million 8-15 block extents
> indicates that the CPU burn is likely coming from the by-size free
> space search. We look up the first extent of the correct size, and
> then do a linear search for a nearest extent of that size to the
> target. Hence we could be searching millions of extents to find the
> "nearest"....
> 
> > >>      16      31 3562456 83746085   6,15
> > >>      32      63 2370812 102124143   7,50
> > >>      64     127  280885 18929867   1,39
> > >>     256     511       2     827   0,00
> > >>     512    1023      65   35092   0,00
> > >>    2048    4095       2    6561   0,00
> > >>   16384   32767       1   23951   0,00
> > >>
> > >> Is there anything i can optimize? Or is it just a bad idea to do this
> > >> with XFS?
> 
> No, it's not a bad idea. In fact, if you have this sort of use case,
> XFS is really your only choice. In terms of optimisation, the only
> thing that will really help performance is the new finobt structure.
> That's a mkfs option andnot an in-place change, though, so it's
> unlikely to help.
> 
> FWIW, it may also help aging characteristics of this sort of
> workload by improving inode allocation layout. That would be 
> a side effect of being able to search the entire free inode tree
> extremely quickly rather than allocating new chunks to keep CPU time
> searching the allocate inode tree for free inodes down. Hence it
> would tend to more tightly pack inode chunks when they are allocated
> on disk as it will fill full chunks before allocating new ones
> elsewhere.
> 
> > >> Any other options? Maybe rsync options like --inplace /
> > >> --no-whole-file?
> 
> For 350M files? I doubt there's much you can really do. Any sort of
> large scale re-organisation is going to take a long, long time and
> require lots of IO. If you are goign to take that route, you'd do
> better to upgrade kernel and xfsprogs, then dump/mkfs.xfs -m
> crc=1,finobt=1/restore. And you'd probably want to use a
> multi-stream dump/restore so it can run operations concurrently and
> hence at storage speed rather than being CPU bound....
> 
> Also, if the problem really is the number of indentically sized free
> space fragments in the freespace btrees, then the initial solution
> is, again, a mkfs one. i.e. remake the filesystem with more, smaller
> AGs to keep the number of extents the btrees need to index down to a
> reasonable level. Say a couple of hundred AGs rather than 21?
> 
> > > If so, I wonder if something like the
> > > following commit introduced in 3.12 would help:
> > > 
> > > 133eeb17 xfs: don't use speculative prealloc for small files
> > 
> > Looks interesting.
> 
> Probably won't make any difference because backups via rsync do
> open/write/close and don't touch the file data again, so the close
> will be removing speculative preallocation before the data is
> written and extents are allocated by background writeback....
> 

Yeah, good point. I was curious if there was an fsync involved somewhere
in the sequence here, but I didn't see rsync doing that anywhere. I
think we've seen that contribute to the aforementioned inode chunk
allocation problem when mixed with aggressive prealloc, but that was a
different application (openstack related, iirc).

That said, Stefan did mention that rsync can do file updates here. So
perhaps there exists the possibility to see multiple file extensions and
writeback causing a similar kind of prealloc->convert->trim eofblocks
pattern across multiple backups..? Either way I agree that seems much
less likely to be a prominent contributer to the problem here.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
