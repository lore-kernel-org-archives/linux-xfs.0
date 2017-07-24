Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23882 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754445AbdGXQF4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jul 2017 12:05:56 -0400
Date: Mon, 24 Jul 2017 09:05:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: warnings complaining IOMAP_DELALLOC blocks in iomap_dio_actor
 from generic/446
Message-ID: <20170724160551.GB4352@magnolia>
References: <20170724145019.GG9167@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170724145019.GG9167@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 24, 2017 at 10:50:19PM +0800, Eryu Guan wrote:
> Hi all,
> 
> Currently generic/446 could trigger a warning in iomap_dio_actor()
> easily, it's complaining about unexpected iomap->type (see the end for
> full call trace).
> 
> fs/iomap.c: iomap_dio_actor()
>  859         default:                                                                                                                                                                          
>  860                 WARN_ON_ONCE(1);                                                                                                                                                          
>  861                 return -EIO;
> 
> It's due to the race between direct read and mmap write pagefault on the
> same *sparse* file. 
> 
> direct read process			mmap write process
> xfs_file_dio_aio_read (take IOLOCK_SHARED)
>  iomap_dio_rw
>   iomap_apply
>    filemap_write_and_wait_range
>    invalidate_inode_pages2_range
>    iomap_apply
> 					mmap
> 					 xfs_filemap_page_mkwrite (take MMAPLOCK_SHARED)
> 					  iomap_page_mkwrite
> 					   iomap_apply
> 					    xfs_file_iomap_begin
> 					     xfs_file_iomap_begin_delay (take ILOCK_EXCL)
> 					     (release ILOCK_EXCL)
> 					     ...
>     xfs_file_iomap_begin
>     (take ILOCK and read in bmap info)
>     iomap_dio_actor
>     ...
> 
> The dio path and page_mkwrite path are taking different locks so they're
> not serialized. So after dio read flushing the file range but before
> taking ILOCK, the page faults from mmap write could fault in and update
> the file map first with delalloc blocks. Then the dio reader sees this
> delalloc block map unexpectedly.
> 
> I'm not sure what's the best way to fix it, but a quick hack of
> disabling delalloc in the write page fault path could do the work for
> me, e.g.
> 
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -981,7 +981,7 @@ xfs_file_iomap_begin(
>         if (XFS_FORCED_SHUTDOWN(mp))
>                 return -EIO;
> 
> -       if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
> +       if (((flags & (IOMAP_WRITE|IOMAP_DIRECT|IOMAP_FAULT)) == IOMAP_WRITE) &&
>                         !IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
>                 /* Reserve delalloc blocks for regular writeback. */
>                 return xfs_file_iomap_begin_delay(inode, offset, length, flags,
> 
> So that mmap write page fault brings in already allocated blocks, and
> dio reader sees non-IOMAP_DELALLOC iomaps.

But now we can't take advantage of delayed allocation for mmap writes
even when the user isn't being evil by peppering us with dio reads.

> I know concurrent dio and mmap io are not recommended, so is this
> something that doens't need a fix at all, and the test should filter out
> the warning instead?

XFS no longer BUG_ON, so I guess it's fine if the test filters out the
warning.

It looks like the end result of a dioread/mmapwrite collision is that
the dio reader gets -EIO.  Would it be better to return a short read?

--D

> 
> Thanks,
> Eryu
> 
> [162097.402359] ------------[ cut here ]------------
> [162097.402745] WARNING: CPU: 1 PID: 20582 at fs/iomap.c:860 iomap_dio_actor+0xca/0x370
> [162097.403392] Modules linked in: rpcsec_gss_krb5 nfsv4(OE) dns_resolver nfs(OE) fscache btrfs xor raid6_pq ppdev i2c_piix4 parport_pc sg virtio_balloon parport i2c_core pcspkr nfsd(OE) auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod ata_generic pata_acpi virtio_scsi ata_piix 8139too libata virtio_pci 8139cp floppy virtio_ring mii serio_raw virtio
> [162097.406258] CPU: 1 PID: 20582 Comm: xfs_io Tainted: G        W  OE   4.13.0-rc1 #191
> [162097.406898] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> [162097.407388] task: ffff880212e40000 task.stack: ffffc900012ac000
> [162097.408403] RIP: 0010:iomap_dio_actor+0xca/0x370
> [162097.409072] RSP: 0018:ffffc900012afc20 EFLAGS: 00010202
> [162097.409533] RAX: 0000000000000002 RBX: ffffc900012afcb0 RCX: 000000000241b000
> [162097.410144] RDX: 00000000000001ff RSI: ffffc900012afe30 RDI: ffffc900012afe68
> [162097.410720] RBP: ffffc900012afc90 R08: ffffc900012afcb0 R09: ffff880211a65c60
> [162097.411324] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> [162097.411912] R13: ffffffffa016bb60 R14: ffff880211a65c60 R15: 0000000000000009
> [162097.412503] FS:  00007f94e825a740(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
> [162097.413181] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [162097.413648] CR2: 000000000241a000 CR3: 0000000212c22000 CR4: 00000000000006e0
> [162097.414261] Call Trace:
> [162097.414478]  ? iomap_dio_zero+0x100/0x100
> [162097.414808]  iomap_apply+0xa1/0x110
> [162097.415133]  iomap_dio_rw+0x20b/0x390
> [162097.415442]  ? iomap_dio_zero+0x100/0x100
> [162097.415804]  xfs_file_dio_aio_read+0x6e/0xf0 [xfs]
> [162097.416250]  xfs_file_read_iter+0xab/0xc0 [xfs]
> [162097.416629]  __vfs_read+0xe0/0x150
> [162097.416925]  vfs_read+0x8c/0x130
> [162097.417217]  SyS_pread64+0x87/0xb0
> [162097.417512]  do_syscall_64+0x67/0x150
> [162097.417818]  entry_SYSCALL64_slow_path+0x25/0x25
> [162097.418234] RIP: 0033:0x7f94e7e3cf73
> [162097.418533] RSP: 002b:00007fff7f52ae90 EFLAGS: 00000293 ORIG_RAX: 0000000000000011
> [162097.419167] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f94e7e3cf73
> [162097.419740] RDX: 0000000000001000 RSI: 000000000241a000 RDI: 0000000000000003
> [162097.420339] RBP: 00007fff7f52af50 R08: 0000000000000000 R09: 0000000000000000
> [162097.420924] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000000
> [162097.421516] R13: 0000000000020000 R14: 0000000000000000 R15: 0000000000000000
> [162097.422124] Code: e1 48 09 c1 48 85 ca 0f 85 82 02 00 00 0f b7 43 18 66 83 f8 03 0f 84 fb 01 00 00 66 83 f8 04 74 35 66 83 f8 01 0f 84 07 02 00 00 <0f> ff 48 c7 c0 fb ff ff ff 48 8b 4d d0 65 48 33 0c 25 28 00 00
> [162097.423661] ---[ end trace 927f98a352499782 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
