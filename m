Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755179AbdEAPnN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 May 2017 11:43:13 -0400
Date: Mon, 1 May 2017 11:26:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes minutes to complete
Message-ID: <20170501152640.GC2109@bfoster.bfoster>
References: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A20782FA8B4C82B0393E5BEF8A8754@alyakaslap>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 01, 2017 at 03:37:23PM +0300, Alex Lyakas wrote:
> [resending to proper list]
> 
> Greetings XFS community,
> 
> We have an XFS instance mounted as "sync"
> (rw,sync,noatime,wsync,attr2,discard,inode64,prjquota 0 0). This instance is
> exposed via nfsd. Size is about 50TB.
> 
> root@0000000f:/home/alex # xfs_info /export/share1
> meta-data=/dev/dm-64             isize=256    agcount=49, agsize=268435455
> blks
>         =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=13107200000, imaxpct=5
>         =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>         =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 

Looks mostly like you are using defaults with the exception of the sync
and discard related mount options.

> We observe the following issue:
> 
> nfsd thread comes into xfs_file_write_iter()=>xfs_file_buffered_aio_write(),
> which copies the data into page cache. Then xfs_file_write_iter() calls
> generic_write_sync(), which ends up working for minutes in stack like [1].
> It seems to be scanning the free space btrees, calling xfs_btree_increment()
> and sometimes xfs_btree_decrement().
> 
> This whole operation is performed while i_lock is exclusively locked by
> xfs_iomap_write_allocate(), before calling xfs_bmapi_write(). So i_lock is
> being held for minutes.
> 
> Meanwhile, another nfsd thread calls into the same inode, and  reaches
> xfs_file_buffered_aio_write(), and calls xfs_rw_ilock(XFS_IOLOCK_EXCL),
> which locks both i_mutex and i_iolock. Now this thread calls
> xfs_file_aio_write_checks() which wants to grab the i_lock in stack like
> [2]. So now all three locks (i_mutex, i_lock and i_iolock) are taken.
> 
> Now another nfsd thread calling into xfs_file_buffered_aio_write() will get
> stuck waiting for i_mutex. Or any other thread that needs one of these locks
> will get stuck. This in some cases triggers hung-task panic.
> 
> After allocation completes, I look at the inode in question via xfs_db, and
> I see that this file is not heavily fragmented. It has few 10s of extents
> only. So file fragmentation is not an issue.
> 
> Questions:
> 1) The thread in [1] does not seem to be waiting for IO. It wants to lock a
> metadata buffer, which is done before spawning a IO on it (to my
> understanding). What is it waiting for?
> 

The search overhead could be high due to either fragmented free space or
perhaps waiting on busy extents (since you have enabled online discard).
Do you have any threads freeing space and waiting on discard operations
when this occurs? Also, what does 'xfs_db -c "freesp -s" <dev>' show for
this filesystem?

> 2) Any recommendations what to do in such situation? Will running xfs_fsr
> help? (although the files in question are not heavily fragmented)
> 

I don't think so.

> Kernel version is 3.18.19.
> 
> BTW, in the code I see the following comment:
> /*
> * Locking primitives for read and write IO paths to ensure we consistently
> use
> * and order the inode->i_mutex, ip->i_lock and ip->i_iolock.
> */
> 
> But the above analysis clearly shows that this locking order is violated.
> xfs_file_buffered_aio_write()  grabs the i_mutex and the i_iolock. And only
> then it wants to grab the i_lock (indirectly). Is the comment wrong or is
> the code wrong? I looked at kernel 4.10, and it seems to have the same
> discrepancy between the comment and the code.
> 

I don't think the comment above is intended to define locking order,
just to indicate that order is important. iolock generally comes before
ilock.

Brian

> Thanks,
> Alex.
> 
> 
> 
> 
> [1]
> [<ffffffff810b90f1>] down+0x41/0x50
> [<ffffffffc0d79090>] xfs_buf_lock+0x40/0x120 [xfs]
> [<ffffffffc0d792cd>] _xfs_buf_find+0x15d/0x2e0 [xfs]
> [<ffffffffc0d7947a>] xfs_buf_get_map+0x2a/0x210 [xfs]
> [<ffffffffc0d7a1dc>] xfs_buf_read_map+0x2c/0x190 [xfs]
> [<ffffffffc0dac621>] xfs_trans_read_buf_map+0x261/0x490 [xfs]
> [<ffffffffc0d50a89>] xfs_btree_read_buf_block.constprop.28+0x69/0xa0 [xfs]
> [<ffffffffc0d5340e>] xfs_btree_increment+0x1ee/0x2e0 [xfs]
> [<ffffffffc0d384ea>] xfs_alloc_ag_vextent_near+0x58a/0x1e20 [xfs]
> [<ffffffffc0d39ea5>] xfs_alloc_ag_vextent+0xd5/0x120 [xfs]
> [<ffffffffc0d3b65f>] xfs_alloc_vextent+0x48f/0x690 [xfs]
> [<ffffffffc0d4c4ff>] xfs_bmap_btalloc+0x39f/0x700 [xfs]
> [<ffffffffc0d4c884>] xfs_bmap_alloc+0x24/0x40 [xfs]
> [<ffffffffc0d4d601>] xfs_bmapi_write+0x811/0xe00 [xfs]
> [<ffffffffc0d8b0c5>] xfs_iomap_write_allocate+0x155/0x4f0 [xfs]
> [<ffffffffc0d7159e>] xfs_map_blocks+0x1de/0x250 [xfs]
> [<ffffffffc0d72e15>] xfs_vm_writepage+0x1a5/0x630 [xfs]
> [<ffffffff8117c377>] __writepage+0x17/0x50
> [<ffffffff8117ccb8>] write_cache_pages+0x238/0x4c0
> [<ffffffff8117cf80>] generic_writepages+0x40/0x60
> [<ffffffffc0d71c93>] xfs_vm_writepages+0x43/0x50 [xfs]
> [<ffffffff8117e7ae>] do_writepages+0x1e/0x40
> [<ffffffff81173429>] __filemap_fdatawrite_range+0x59/0x60
> [<ffffffff8117352a>] filemap_write_and_wait_range+0x2a/0x70
> [<ffffffffc0d80af7>] xfs_file_fsync+0x57/0x220 [xfs]
> [<ffffffff8121823b>] vfs_fsync_range+0x1b/0x30
> [<ffffffffc0d8238b>] xfs_file_write_iter+0xeb/0x130 [xfs]
> [<ffffffff811e7545>] do_iter_readv_writev+0x65/0xa0
> [<ffffffff811e8bf9>] do_readv_writev+0xc9/0x280
> [<ffffffff811e8e39>] vfs_writev+0x39/0x50
> [<ffffffffc0306fb7>] nfsd_vfs_write.isra.14+0x97/0x350 [nfsd]
> [<ffffffffc030a8ce>] nfsd_write+0x8e/0x100 [nfsd]
> [<ffffffffc0315411>] nfsd4_write+0x1c1/0x220 [nfsd]
> [<ffffffffc0316edc>] nfsd4_proc_compound+0x50c/0x850 [nfsd]
> [<ffffffffc0302ed3>] nfsd_dispatch+0xd3/0x240 [nfsd]
> [<ffffffffc0263dc0>] svc_process_common+0x440/0x6d0 [sunrpc]
> [<ffffffffc0264157>] svc_process+0x107/0x170 [sunrpc]
> [<ffffffffc0302837>] nfsd+0x127/0x1a0 [nfsd]
> [<ffffffff810911b9>] kthread+0xc9/0xe0
> [<ffffffff81717918>] ret_from_fork+0x58/0x90
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> [2]
> [<ffffffffc0c80db1>] xfs_ilock+0x321/0x330 [xfs]
> [<ffffffffc0c7e5dd>] xfs_vn_update_time+0x6d/0x1b0 [xfs]
> [<ffffffff81202c15>] update_time+0x25/0xc0
> [<ffffffff810d7c76>] ? current_fs_time+0x16/0x60
> [<ffffffff81202e70>] file_update_time+0x80/0xd0
> [<ffffffffc0c74e60>] xfs_file_aio_write_checks+0x140/0x1a0 [xfs]
> [<ffffffffc0c74fac>] xfs_file_buffered_aio_write.isra.11+0xec/0x390 [xfs]
> [<ffffffff811e7430>] ? new_sync_read+0xb0/0xb0
> [<ffffffffc0c752d3>] xfs_file_write_iter+0x83/0x130 [xfs]
> [<ffffffff811e7545>] do_iter_readv_writev+0x65/0xa0
> [<ffffffff811e8bf9>] do_readv_writev+0xc9/0x280
> [<ffffffffc0c75250>] ? xfs_file_buffered_aio_write.isra.11+0x390/0x390 [xfs]
> [<ffffffffc0c75250>] ? xfs_file_buffered_aio_write.isra.11+0x390/0x390 [xfs]
> [<ffffffff81341e43>] ? apparmor_cred_prepare+0x33/0x50
> [<ffffffff811e8e39>] vfs_writev+0x39/0x50
> [<ffffffffc0306fb7>] nfsd_vfs_write.isra.14+0x97/0x350 [nfsd]
> [<ffffffffc030a8ce>] nfsd_write+0x8e/0x100 [nfsd]
> [<ffffffffc0315411>] nfsd4_write+0x1c1/0x220 [nfsd]
> [<ffffffffc0316edc>] nfsd4_proc_compound+0x50c/0x850 [nfsd]
> [<ffffffffc0302ed3>] nfsd_dispatch+0xd3/0x240 [nfsd]
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
