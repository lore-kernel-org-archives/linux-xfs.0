Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF6A77F73
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 17:26:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFD248F8033
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 15:26:56 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cq5Czcp3voNh4XbV for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 15:26:53 -0700 (PDT)
Date: Tue, 30 Jun 2015 08:26:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Message-ID: <20150629222651.GG7943@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150629190222.GC57700@bfoster.bfoster>
	<E57C3C845AE048FC8F503F91620E1EF5@alyakaslap>
	<20150629114308.GA57700@bfoster.bfoster>
	<67A4FE15562A466F9787DFF197F05463@alyakaslap>
	<F2066917D2CB4CB3B0C29C099FA3852C@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>, hch@lst.de, xfs@oss.sgi.com

[Compendium reply, top-posting removed, trimmed and re-ordered]

On Sat, Jun 27, 2015 at 11:01:30PM +0200, Alex Lyakas wrote:
> Results are following:
> - memory allocation failures happened only on the
> kmem_realloc_xfs_iext_realloc_indirect path for now
> - XFS hits memory re-allocation failures when it needs to allocate
> about 35KB. Sometimes allocation succeeds after few retries, but
> sometimes it takes several thousands of retries.

Allocations of 35kB are failing? Sounds like you have a serious
memory fragmentation problem if allocations that small are having
trouble.

> - All allocation failures happened on NFSv3 paths
> - Three inode numbers were reported as failing memory allocations.
> After several hours, "find -inum" is still searching for these
> inodes...this is a huge filesystem... Is there any other quicker
> (XFS-specific?) way to find the file based on inode number?

Not yet. You can use the bulkstat ioctl to find the inode by inode
number, then open-by-handle to get a fd for the inode to allow you
to read/write/stat/bmap/etc, but the only way to find the path right
now is to brute force it. That reverse mapping and parent pointer
stuff I'm working on at the moment will make lookups like this easy.

> Any recommendation how to move forward with this issue?
> 
> Additional observation that I saw in my local system: writing files
> to XFS locally vs writing the same files via NFS (both 3 and 4), the
> amount of extents reported by "xfs_bmap" is much higher for the NFS
> case. For example, creating a new file and writing into it as
> follows:
> - write 4KB
> - skip 4KB (i.e., lseek to 4KB + 4KB)
> - write 4KB
> - skip 4KB
> ...
> Create a file of say 50MB this way.
> 
> Locally it ends up with very few (1-5) extents. But same exact
> workload through NFS results in several thousands of extents.

NFS is likely resulting in out of order writes....

> The
> filesystem is mounted as "sync" in both cases.

I'm afraid to ask why, but that is likely your problem - synchronous
out of order writes from the NFS client will fragment the file
badly because it defeats both delayed allocation and speculative
preallocation because there is nothing to trigger the "don't remove
speculatieve prealloc on file close" heuristic used to avoid
fragmentation caused by out of order NFS writes....

On Sun, Jun 28, 2015 at 08:19:35PM +0200, Alex Lyakas wrote:
> through NFS. Trying the same 4KB-data/4KB-hole workload on small
> files of 2MB. When writing the file locally, I see that
> xfs_file_buffered_aio_write is always called with a single 4KB
> buffer:
> xfs_file_buffered_aio_write: inum=100663559 nr_segs=1
> seg #0: {.iov_base=0x18db8f0, .iov_len=4096}
> 
> But when doing the same workload through NFS:
> xfs_file_buffered_aio_write: inum=167772423 nr_segs=2
> seg #0: {.iov_base=0xffff88006c1100a8, .iov_len=3928}
> seg #1: {.iov_base=0xffff88005556e000, .iov_len=168}
> There are always two such buffers in the IOV.

IOV format is irrelevant to the buffered write behaviour of XFS.

> I am still trying to debug why this results in XFS requiring much
> more extents to fit such workload. I tapped into some functions and
> seeing:
> 
> Local workload:
> 6    xfs_iext_add: ifp=0xffff8800096de6b8 idx=0x0 ext_diff=0x1,
> nextents=0 new_size=16 if_bytes=0 if_real_bytes=0
> 25    xfs_iext_add: ifp=0xffff8800096de6b8 idx=0x1 ext_diff=0x1,
.....

Sequential allocation, all nice and contiguous.
Preallocation is clearly not being removed between writes.

> NFS workload:
....
> nextents=1 new_size=32 if_bytes=16 if_real_bytes=0
> 124    xfs_iext_add: ifp=0xffff8800096df4b8 idx=0x1 ext_diff=0x1,
> nextents=2 new_size=48 if_bytes=32 if_real_bytes=0
> 130    xfs_iext_add: ifp=0xffff8800096df4b8 idx=0x1 ext_diff=0x1,

You're not getting sequential allocation, which further points to
problems with preallocation being removed on close.

> Number of extents is growing. But still I could not see why this is
> happening. Can you please give a hint why?

The sync mount option.

> 3) I tried to see what is the largest file XFS can maintain with
> this 4KB-data/4KB-hole workload on a VM with 5GB RAM. I was able to
> reach 146GB and almost 9M extents. There were a lof of "memory
> allocation deadlock" messages popping, but eventually allocation
> would succeed. Until finally, allocation could not succeed for 3
> minutes and hung-task panic occurred.

Well, yes. Each extent requires 32 bytes, plus an index page every
256 leaf pages (i.e. every 256*128=32k extents). So that extent list
requires roughly 300MB of memory, and a contiguous 270 page
allocation. vmalloc is not the answer here - it just papers over the
underlying problem: excessive fragmentation.

On Mon, Jun 29, 2015 at 03:02:23PM -0400, Brian Foster wrote:
> On Mon, Jun 29, 2015 at 07:59:00PM +0200, Alex Lyakas wrote:
> > Hi Brian,
> > Thanks for your comments.
> > 
> > Here is the information you asked for:
> > 
> > meta-data=/dev/dm-147            isize=256    agcount=67, agsize=268435440
> > blks
> >         =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=17825792000, imaxpct=5
> >         =                       sunit=16     swidth=160 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=521728, version=2
> >         =                       sectsz=512   sunit=16 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > Mount options:
> > /dev/dm-147 /export/nfsvol xfs rw,sync,noatime,wsync,attr2,discard,inode64,allocsize=64k,logbsize=64k,sunit=128,swidth=1280,noquota
> > 0 0
> > 
> > So yes, we are using "allocsize=64k", which influences the speculative
> > allocation logic. I did various experiments, and indeed when I remove this
> > "allocsize=64k", fragmentation is much lesser. (Tried also other things,
> > like using a single nfsd thread, mounting without "sync" and patching nfsd
> > to provide "nicer" IOV to vfs_write, but none of these helped). On the other
> > hand, we started using this option "allocsize=64k" to prevent aggressive
> > preallocation that we saw XFS doing on large QCOW files (VM images).
> > 
> 
> What was the problem with regard to preallocation and large VM images?
> The preallocation is not permanent and should be cleaned up if the file
> is inactive for a period of time (see the other prealloc FAQ entries).

A lot of change went into the speculative preallocation in the
kernels after 3.8, so I suspect we've already fixed whatever problem
was seen. Alex, it would be a good idea to try to reproduce those
problems on a current kernel to see if they still are present....

> > Still, when doing local IO to a mounted XFS, even with "allocsize=64k", we
> > still get very few extents. Still don't know why is this difference between
> > local IO and NFS. Would be great to receive a clue for that phenomena.
> > 
> 
> What exactly is your test in this case? I assume you're also testing
> with the same mount options and whatnot. One difference could be that
> NFS might involve more open-write-close cycles than a local write test,
> which could impact reclaim of preallocation. For example, what happens
> if you run something like the following locally?
> 
> for i in $(seq 0 2 100); do
> 	xfs_io -fc "pwrite $((i * 4096)) 4k" /mnt/file
> done

That should produce similar results to run the NFS client. Years ago
back at SGI we used a tool written by Greg Banks called "Ddnfs" for
testing this sort of thing. it did open_by_handle()/close() around
each read/write syscall to emulate the NFS server IO pattern.

http://oss.sgi.com/projects/nfs/testtools/ddnfs-oss-20090302.tar.bz2

> 
> This will do the strided writes while opening and closing the file each
> time and thus probably more closely matches what might be happening over
> NFS. Prealloc is typically trimmed on close, but there is an NFS
> specific heuristic that should detect this and let it hang around for
> longer in this case. Taking a quick look at that code shows that it is
> tied to the existence of delayed allocation blocks at close time,
> however. I suppose that might never trigger due to the sync mount
> option. What's the reason for using that one?

Right - it won't trigger because writeback occurs in the write()
context, so we have a clean inode when the fd is closed and
->release is called...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
