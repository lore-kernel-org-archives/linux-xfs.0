Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 95AC87F54
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 13:48:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F93A3040D2
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 11:48:05 -0700 (PDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
	[209.85.212.174]) by cuda.sgi.com with ESMTP id
	C8zyMxRm4UZtrzwD (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 11:48:01 -0700 (PDT)
Received: by wiwl6 with SMTP id l6so293314940wiw.0
	for <xfs@oss.sgi.com>; Mon, 06 Jul 2015 11:48:00 -0700 (PDT)
Message-ID: <F1A27B6A9FB048488A388EC4D9FD71F7@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <20150629222651.GG7943@dastard>
In-Reply-To: <20150629222651.GG7943@dastard>
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation
	deadlock"
Date: Mon, 6 Jul 2015 20:47:56 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, bfoster@redhat.com
Cc: Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com

Hi Dave, Brian,

[Compendium reply, trimmed and re-ordered]


> What was the problem with regard to preallocation and large VM images?
> The preallocation is not permanent and should be cleaned up if the file
> is inactive for a period of time (see the other prealloc FAQ entries).
The problem was that in 3.8 speculative preallocation was based on the inode 
size. So when creating large sparse files (for example with qemu-img), XFS 
was writing huge amounts of data through xfs_iozero, which choked the 
drives. As Dave pointed out, this was fixed in later kernels.

> For example, what happens
> if run something like the following locally?
> for i in $(seq 0 2 100); do
> xfs_io -fc "pwrite $((i * 4096)) 4k" /mnt/file
> done
When running this locally, speculative preallocation is trimmed through 
xfs_free_eofblocks (verified with systemtap), and indeed we get a highly 
fragmented file.
However, debugging our NFS workload, we see that this is not happening, 
i.e., NFS server does not issue ->release, until the end of the workload.

> I suppose that might never trigger due to the sync mount
> option. What's the reason for using that one?

> I'm afraid to ask why, but that is likely your problem - synchronous
> out of order writes from the NFS client will fragment the file
> badly because it defeats both delayed allocation and speculative
> preallocation because there is nothing to trigger the "don't remove
> speculatieve prealloc on file close" heuristic used to avoid
> fragmentation caused by out of order NFS writes....
The main reason for using "sync" mount option is to avoid data loss in the 
case of crash.
I did some experiments without this mount option, and indeed I see that same 
NFS workload results in lower fragmentation, especially for large files. 
However, since we do not consider at the moment removing the "sync" mount 
option, I did not debug further why it happens.

> NFS is likely resulting in out of order writes....
Yes, Dave, this appeared to be our issue. This in addition to badly 
configured NFS client, which had:
rsize=32768,wsize=32768
instead of what we usually see:
rsize=1048576,wsize=1048576

An out of order write was triggering a small speculative preallocation 
(allocsize=64k), and all subsequent writes into the "hole" were not able to 
benefit from it, and had to allocate separate extents (which most of the 
time were not physically contiguous). And NFS server receiving 32k writes 
contributed even more to the fragmentation. With 1MB writes this problem 
doesn't really happen even with allocsize=64k.

So currently, we are pulling the following XFS patches:
xfs: don't use speculative prealloc for small files
xfs: fix xfs_iomap_eof_prealloc_initial_size type
xfs: increase prealloc size to double that of the previous extent
xfs: fix potential infinite loop in xfs_iomap_prealloc_size()
xfs: limit speculative prealloc size on sparse files

(Final code will be as usual in 
https://github.com/zadarastorage/zadara-xfs-pushback)

However, Dave, I am still not comfortable with XFS insisting on continuous 
space for the data fork in kmem_alloc. Consider, for example,  Brian's 
script. Nothing stops the user from doing that. Another example could be 
strided 4k NFS writes coming out of order. For these cases, speculative 
preallocation will not help, as we will receive a highly fragmented file 
with holes.

Another example, Dave, can you please look at the stack trace in [1]. (It 
doesn't make much sense, but this is what we got). Could something like this 
happen:
- VFS tells XFS to unlink an inode
- XFS tries to reallocate the extents fork via xfs_inactive path
- there is no continuous memory, so kernel (somehow) wants to evict the same 
inode, but cannot lock it due to XFS already holding the lock???
I know that this is very far-fetched, and probably wrong, but insisting on 
continuous memory is also problematic here.

Thanks for your help Brian & Dave,
Alex.


[1]
454509.864025] nfsd            D 0000000000000001     0   797      2 
0x00000000
[454509.864025]  ffff88036e41d438 0000000000000046 ffff88037b351c00 
ffff88017fb22a20
[454509.864025]  ffff88036e41dfd8 0000000000000000 0000000000000008 
ffff8803aca2dd58
[454509.864025]  ffff88036e41d448 ffffffffa074905d 000000012e32b040 
ffff8803aca2dcc0
[454509.864025] Call Trace:
[454509.864025]  [<ffffffffa0748e94>] ? xfs_buf_lock+0x44/0x110 [xfs]
[454509.864025]  [<ffffffffa074905d>] ? _xfs_buf_find+0xfd/0x2a0 [xfs]
[454509.864025]  [<ffffffffa07492d4>] ? xfs_buf_get_map+0x34/0x1b0 [xfs]
[454509.864025]  [<ffffffffa074a261>] ? xfs_buf_read_map+0x31/0x130 [xfs]
[454509.864025]  [<ffffffffa07acc39>] ? xfs_trans_read_buf_map+0x2d9/0x490 
[xfs]
[454509.864025]  [<ffffffffa077e572>] ? 
xfs_btree_read_buf_block.isra.20.constprop.25+0x72/0xb0 [xfs]
[454509.864025]  [<ffffffffa0780a3c>] ? xfs_btree_rshift+0xcc/0x540 [xfs]
[454509.864025]  [<ffffffffa0749a84>] ? _xfs_buf_ioapply+0x294/0x300 [xfs]
[454509.864025]  [<ffffffffa0782bf8>] ? 
xfs_btree_make_block_unfull+0x58/0x190 [xfs]
[454509.864025]  [<ffffffffa074a210>] ? _xfs_buf_read+0x30/0x50 [xfs]
[454509.864025]  [<ffffffffa0749be9>] ? xfs_buf_iorequest+0x69/0xd0 [xfs]
[454509.864025]  [<ffffffffa07830b7>] ? xfs_btree_insrec+0x387/0x580 [xfs]
[454509.864025]  [<ffffffffa074a333>] ? xfs_buf_read_map+0x103/0x130 [xfs]
[454509.864025]  [<ffffffffa074a3bb>] ? xfs_buf_readahead_map+0x5b/0x80 
[xfs]
[454509.864025]  [<ffffffffa077e62b>] ? xfs_btree_lookup_get_block+0x7b/0xe0 
[xfs]
[454509.864025]  [<ffffffffa077d88f>] ? xfs_btree_ptr_offset+0x4f/0x70 [xfs]
[454509.864025]  [<ffffffffa077d8e2>] ? xfs_btree_key_addr+0x12/0x20 [xfs]
[454509.864025]  [<ffffffffa07822d7>] ? xfs_btree_lookup+0xb7/0x470 [xfs]
[454509.864025]  [<ffffffffa0764deb>] ? xfs_alloc_lookup_eq+0x1b/0x20 [xfs]
[454509.864025]  [<ffffffffa0765dd1>] ? xfs_free_ag_extent+0x421/0x940 [xfs]
[454509.864025]  [<ffffffffa07689fa>] ? xfs_free_extent+0x10a/0x170 [xfs]
[454509.864025]  [<ffffffffa07795c9>] ? xfs_bmap_finish+0x169/0x1b0 [xfs]
[454509.864025]  [<ffffffffa07956a3>] ? xfs_itruncate_extents+0xf3/0x2d0 
[xfs]
[454509.864025]  [<ffffffffa0764767>] ? kmem_zone_alloc+0x67/0xe0 [xfs]
[454509.864025]  [<ffffffffa0762180>] ? xfs_inactive+0x340/0x450 [xfs]
[454509.864025]  [<ffffffff816ed725>] ? _raw_spin_lock_irq+0x15/0x20
[454509.864025]  [<ffffffffa075e303>] ? xfs_fs_evict_inode+0x93/0x100 [xfs]
[454509.864025]  [<ffffffff811b5530>] ? evict+0xc0/0x1d0
[454509.864025]  [<ffffffff811b5e62>] ? iput_final+0xe2/0x170
[454509.864025]  [<ffffffff811b5f2e>] ? iput+0x3e/0x50
[454509.864025]  [<ffffffff811b0e88>] ? dentry_unlink_inode+0xd8/0x110
[454509.864025]  [<ffffffff811b0f7e>] ? d_delete+0xbe/0xd0
[454509.864025]  [<ffffffff811a663e>] ? vfs_unlink.part.27+0xde/0xf0
[454509.864025]  [<ffffffff811a847c>] ? vfs_unlink+0x3c/0x60
[454509.864025]  [<ffffffffa01e90c3>] ? nfsd_unlink+0x183/0x230 [nfsd]
[454509.864025]  [<ffffffffa01f871d>] ? nfsd4_remove+0x6d/0x130 [nfsd]
[454509.864025]  [<ffffffffa01f746c>] ? nfsd4_proc_compound+0x5ac/0x7a0 
[nfsd]
[454509.864025]  [<ffffffffa01e2d62>] ? nfsd_dispatch+0x102/0x270 [nfsd]
[454509.864025]  [<ffffffffa013cb48>] ? svc_process_common+0x328/0x5e0 
[sunrpc]
[454509.864025]  [<ffffffffa013d153>] ? svc_process+0x103/0x160 [sunrpc]
[454509.864025]  [<ffffffffa01e272f>] ? nfsd+0xbf/0x130 [nfsd]
[454509.864025]  [<ffffffffa01e2670>] ? nfsd_destroy+0x80/0x80 [nfsd]
[454509.864025]  [<ffffffff8107f050>] ? kthread+0xc0/0xd0
[454509.864025]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0
[454509.864025]  [<ffffffff816f61ec>] ? ret_from_fork+0x7c/0xb0
[454509.864025]  [<ffffffff8107ef90>] ? flush_kthread_worker+0xb0/0xb0






-----Original Message----- 
From: Dave Chinner
Sent: 30 June, 2015 12:26 AM
To: Alex Lyakas
Cc: xfs@oss.sgi.com ; hch@lst.de ; Yair Hershko ; Shyam Kaushik ; Danny 
Shavit
Subject: Re: xfs_iext_realloc_indirect and "XFS: possible memory allocation 
deadlock"

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
> > meta-data=/dev/dm-147            isize=256    agcount=67, 
> > agsize=268435440
> > blks
> >         =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=17825792000, 
> > imaxpct=5
> >         =                       sunit=16     swidth=160 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=521728, version=2
> >         =                       sectsz=512   sunit=16 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> >
> > Mount options:
> > /dev/dm-147 /export/nfsvol xfs 
> > rw,sync,noatime,wsync,attr2,discard,inode64,allocsize=64k,logbsize=64k,sunit=128,swidth=1280,noquota
> > 0 0
> >
> > So yes, we are using "allocsize=64k", which influences the speculative
> > allocation logic. I did various experiments, and indeed when I remove 
> > this
> > "allocsize=64k", fragmentation is much lesser. (Tried also other things,
> > like using a single nfsd thread, mounting without "sync" and patching 
> > nfsd
> > to provide "nicer" IOV to vfs_write, but none of these helped). On the 
> > other
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

> > Still, when doing local IO to a mounted XFS, even with "allocsize=64k", 
> > we
> > still get very few extents. Still don't know why is this difference 
> > between
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
> xfs_io -fc "pwrite $((i * 4096)) 4k" /mnt/file
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
