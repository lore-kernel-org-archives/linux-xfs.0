Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Jul 2006 03:28:33 -0700 (PDT)
Received: from e450.epcc.ed.ac.uk (e450.epcc.ed.ac.uk [129.215.56.230])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6IASFDW029044
	for <linux-xfs@oss.sgi.com>; Tue, 18 Jul 2006 03:28:16 -0700
Subject: oops with CentOS 4.3 / xfs / nfsd
From: Andrew Elwell <andrewe@epcc.ed.ac.uk>
Content-Type: multipart/mixed; boundary="=-3KPuxqhFz7DVasZxaYzI"
Date: Tue, 18 Jul 2006 10:29:21 +0100
Message-Id: <1153214961.6793.15.camel@x41ade>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: maciej@epcc.ed.ac.uk

--=-3KPuxqhFz7DVasZxaYzI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Folks,

We've migrated some of our storage servers to CentOS 4.3 and are seeing
lockups. It *could* be hardware I know, and I'm scheduling downtime to
run memtest86+ ASAP.

Overview:
2* LPFC HBA's connecting to our SAN, 
dm setup for multipath to see 4*1.6TB trays
each tray as a PV in lvm2 sanvg
xfs on a 3T lv
NFS exported out as /export/work 

using the 2.6.9-34 centosplus SMP kernel (3GHz P4 with hyperthreading
enabled)

what we normally (~once a day) is simply

do_IRQ: stack overflow: 416
 [<c0107a27>]

on the console and nothing else. (needs a cold reboot)

Having installed netdump (nice tool btw) we got a different error
yesterday that looks xfs / nfsd related...

(attached)

any help in progressing this would be much appreciated - 

Andrew





--=-3KPuxqhFz7DVasZxaYzI
Content-Disposition: attachment; filename=log
Content-Type: text/plain; name=log; charset=UTF-8
Content-Transfer-Encoding: 7bit

 IP 172.20.0.224
SysRq : HELP : loglevel0-8 reBoot Crash tErm kIll saK showMem powerOff showPc unRaw Sync showTasks Unmount shoWcpus 
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 [<c014687d>] cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 [<dfb75f10>] kmem_alloc+0x50/0x96 [xfs]
 [<dfb75fd8>] kmem_realloc+0x17/0x52 [xfs]
 [<dfb5b237>] xfs_iext_realloc+0xc9/0xdc [xfs]
 [<dfb38935>] xfs_bmap_insert_exlist+0x22/0x77 [xfs]
 [<dfb35d4a>] xfs_bmap_add_extent_hole_delay+0x43c/0x492 [xfs]
 [<dfb3377c>] xfs_bmap_add_extent+0x146/0x399 [xfs]
 [<dfb3a9d8>] xfs_bmapi+0xb03/0x12cc [xfs]
 [<c0107b01>] do_IRQ+0x123/0x1b8
 [<dfb3a1fe>] xfs_bmapi+0x329/0x12cc [xfs]
 [<c011fe60>] autoremove_wake_function+0x0/0x2d
 [<dfb5dc9f>] xfs_iomap_write_delay+0x630/0x70a [xfs]
 [<dfb38fb5>] xfs_bmap_do_search_extents+0x378/0x384 [xfs]
 [<dfb5d084>] xfs_iomap+0x23a/0x3ec [xfs]
 [<dfb5d12e>] xfs_iomap+0x2e4/0x3ec [xfs]
 [<dfb7d5b8>] xfs_bmap+0x1a/0x1e [xfs]
 [<dfb7713d>] linvfs_get_block_core+0x6b/0x257 [xfs]
 [<c015af2c>] set_bh_page+0x2c/0x34
 [<dfb7733c>] linvfs_get_block+0x13/0x17 [xfs]
 [<c015b562>] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs]
 [<dfb77654>] linvfs_prepare_write+0x12/0x16 [xfs]
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs]
 [<c0141115>] generic_file_buffered_write+0x186/0x47c
 [<dfb7cadb>] xfs_zero_eof+0x167/0x275 [xfs]
 [<dfb7d206>] xfs_write+0x61d/0x97d [xfs]
 [<dfb796d9>] linvfs_writev+0xc4/0xe3 [xfs]
 [<c011c7e1>] activate_task+0x88/0x95
 [<dfd174eb>] svc_expkey_lookup+0x1f0/0x322 [nfsd]
 [<c011fe60>] autoremove_wake_function+0x0/0x2d
 [<dfb79615>] linvfs_writev+0x0/0xe3 [xfs]
 [<c015902d>] do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd]
 [<c02d9060>] common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]
 [<dfd11482>] nfsd+0x1cc/0x339 [nfsd]
 [<dfd112b6>] nfsd+0x0/0x339 [nfsd]
 [<c0104209>] kernel_thread_helper+0x5/0xb
Mem-info:
DMA per-cpu:
cpu 0 hot: low 2, high 6, batch 1
cpu 0 cold: low 0, high 2, batch 1
cpu 1 hot: low 2, high 6, batch 1
cpu 1 cold: low 0, high 2, batch 1
Normal per-cpu:
cpu 0 hot: low 32, high 96, batch 16
cpu 0 cold: low 0, high 32, batch 16
cpu 1 hot: low 32, high 96, batch 16
cpu 1 cold: low 0, high 32, batch 16
HighMem per-cpu: empty

Free pages:        2244kB (0kB HighMem)
Active:2887 inactive:114284 dirty:14642 writeback:0 unstable:0 free:561 slab:5084 mapped:2796 pagetables:195
DMA free:172kB min:20kB low:40kB high:60kB active:476kB inactive:11204kB present:16384kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
Normal free:2072kB min:688kB low:1376kB high:2064kB active:11072kB inactive:445932kB present:490684kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
HighMem free:0kB min:128kB low:256kB high:384kB active:0kB inactive:0kB present:0kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
DMA: 33*4kB 5*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 172kB
Normal: 226*4kB 122*8kB 2*16kB 5*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2072kB
HighMem: empty
Swap cache: add 55, delete 55, find 3/4, race 0+0
0 bounce buffer pages
Free swap:       2048100kB
126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33708 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 [<c014687d>] cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 [<dfb75f10>] kmem_alloc+0x50/0x96 [xfs]
 [<dfb75fd8>] kmem_realloc+0x17/0x52 [xfs]
 [<dfb5b237>] xfs_iext_realloc+0xc9/0xdc [xfs]
 [<dfb38935>] xfs_bmap_insert_exlist+0x22/0x77 [xfs]
 [<dfb35d4a>] xfs_bmap_add_extent_hole_delay+0x43c/0x492 [xfs]
 [<dfb3377c>] xfs_bmap_add_extent+0x146/0x399 [xfs]
 [<dfb3a9d8>] xfs_bmapi+0xb03/0x12cc [xfs]
 [<c0107b01>] do_IRQ+0x123/0x1b8
 [<dfb3a1fe>] xfs_bmapi+0x329/0x12cc [xfs]
 [<c011fe60>] autoremove_wake_function+0x0/0x2d
 [<dfb5dc9f>] xfs_iomap_write_delay+0x630/0x70a [xfs]
 [<dfb38fb5>] xfs_bmap_do_search_extents+0x378/0x384 [xfs]
 [<dfb5d084>] xfs_iomap+0x23a/0x3ec [xfs]
 [<dfb5d12e>] xfs_iomap+0x2e4/0x3ec [xfs]
 [<dfb7d5b8>] xfs_bmap+0x1a/0x1e [xfs]
 [<dfb7713d>] linvfs_get_block_core+0x6b/0x257 [xfs]
 [<c015af2c>] set_bh_page+0x2c/0x34
 [<dfb7733c>] linvfs_get_block+0x13/0x17 [xfs]
 [<c015b562>] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs]
 [<dfb77654>] linvfs_prepare_write+0x12/0x16 [xfs]
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs]
 [<c0141115>] generic_file_buffered_write+0x186/0x47c
 [<dfb7cadb>] xfs_zero_eof+0x167/0x275 [xfs]
 [<dfb7d206>] xfs_write+0x61d/0x97d [xfs]
 [<dfb796d9>] linvfs_writev+0xc4/0xe3 [xfs]
 [<c011c7e1>] activate_task+0x88/0x95
 [<dfd174eb>] svc_expkey_lookup+0x1f0/0x322 [nfsd]
 [<c011fe60>] autoremove_wake_function+0x0/0x2d
 [<dfb79615>] linvfs_writev+0x0/0xe3 [xfs]
 [<c015902d>] do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd]
 [<c02d9060>] common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]
 [<dfd11482>] nfsd+0x1cc/0x339 [nfsd]
 [<dfd112b6>] nfsd+0x0/0x339 [nfsd]
 [<c0104209>] kernel_thread_helper+0x5/0xb
Mem-info:
DMA per-cpu:
cpu 0 hot: low 2, high 6, batch 1
cpu 0 cold: low 0, high 2, batch 1
cpu 1 hot: low 2, high 6, batch 1
cpu 1 cold: low 0, high 2, batch 1
Normal per-cpu:
cpu 0 hot: low 32, high 96, batch 16
cpu 0 cold: low 0, high 32, batch 16
cpu 1 hot: low 32, high 96, batch 16
cpu 1 cold: low 0, high 32, batch 16
HighMem per-cpu: empty

Free pages:        2372kB (0kB HighMem)
Active:2887 inactive:114252 dirty:14642 writeback:0 unstable:0 free:593 slab:5084 mapped:2796 pagetables:195
DMA free:172kB min:20kB low:40kB high:60kB active:476kB inactive:11204kB present:16384kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
Normal free:2200kB min:688kB low:1376kB high:2064kB active:11072kB inactive:445804kB present:490684kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
HighMem free:0kB min:128kB low:256kB high:384kB active:0kB inactive:0kB present:0kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
DMA: 33*4kB 5*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 172kB
Normal: 234*4kB 134*8kB 2*16kB 5*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2200kB
HighMem: empty
Swap cache: add 55, delete 55, find 3/4, race 0+0
0 bounce buffer pages
Free swap:       2048100kB
126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33678 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 [<c014687d>] cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 [<dfb75f10>] kmem_alloc+0x50/0x96 [xfs]
 [<dfb75fd8>] kmem_realloc+0x17/0x52 [xfs]
 [<dfb5b237>] xfs_iext_realloc+0xc9/0xdc [xfs]
 [<dfb38935>] xfs_bmap_insert_exlist+0x22/0x77 [xfs]
 [<dfb35d4a>] xfs_bmap_add_extent_hole_delay+0x43c/0x492 [xfs]
 [<dfb3377c>] xfs_bmap_add_extent+0x146/0x399 [xfs]
 [<dfb3a9d8>] xfs_bmapi+0xb03/0x12cc [xfs]
 [<c0107b01>] do_IRQ+0x123/0x1b8
 [<dfb3a1fe>] xfs_bmapi+0x329/0x12cc [xfs]
 [<c011fe60>] autoremove_wake_function+0x0/0x2d
 [<dfb5dc9f>] xfs_iomap_write_delay+0x630/0x70a [xfs]
 [<dfb38fb5>] xfs_bmap_do_search_extents+0x378/0x384 [xfs]
 [<dfb5d084>] xfs_iomap+0x23a/0x3ec [xfs]
 [<dfb5d12e>] xfs_iomap+0x2e4/0x3ec [xfs] set_bh_page+0x2c/0x34
 [<dfb7733c>] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs] generic_file_buffered_write+0x186/0x47c
 activate_task+0x88/0x95 autoremove_wake_function+0x0/0x2d
 do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd]
 common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]cpu 0 hot: low 2, high 6, batch 1
126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33644 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 [<c014687d>] cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 [<dfb75f10>] do_IRQ+0x123/0x1b8 autoremove_wake_function+0x0/0x2d set_bh_page+0x2c/0x34
 [<dfb7733c>] linvfs_get_block+0x13/0x17 [xfs] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] generic_file_buffered_write+0x186/0x47c
 activate_task+0x88/0x95 autoremove_wake_function+0x0/0x2d
 do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>]Active:2893 inactive:114163 dirty:14644 writeback:0 unstable:0 free:673 slab:5085 mapped:2796 pagetables:195
DMA free:300kB min:20kB low:40kB high:60kB active:476kB inactive:11076kB present:16384kB pages_scanned:0 all_unreclaimable? no
protections[]:126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33625 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 do_IRQ+0x123/0x1b8 autoremove_wake_function+0x0/0x2d set_bh_page+0x2c/0x34
 [<dfb7733c>] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs] generic_file_buffered_write+0x186/0x47c
 linvfs_writev+0xc4/0xe3 [xfs] activate_task+0x88/0x95 autoremove_wake_function+0x0/0x2d do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd]
 common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]
126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33598 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 [<c014687d>] cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 [<dfb75f10>] do_IRQ+0x123/0x1b8 autoremove_wake_function+0x0/0x2d
 set_bh_page+0x2c/0x34
 [<dfb7733c>] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs] generic_file_buffered_write+0x186/0x47c
 [<dfb7cadb>] activate_task+0x88/0x95 autoremove_wake_function+0x0/0x2d
 do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd]
 [<c02d9060>] common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]Free pages:        2820kB (0kB HighMem)
Active:2894 inactive:114130 dirty:14646 writeback:1 unstable:0 free:705 slab:5085 mapped:2796 pagetables:195
DMA free:300kB min:20kB low:40kB high:60kB active:476kB inactive:11076kB present:16384kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
protections[]: 0 0 0
126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33586 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 [<c014687d>] cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 [<dfb75f10>] autoremove_wake_function+0x0/0x2d
 set_bh_page+0x2c/0x34
 [<dfb7733c>] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs]
 generic_file_buffered_write+0x186/0x47c
 activate_task+0x88/0x95
 autoremove_wake_function+0x0/0x2d do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd]
 common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33574 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 [<c014687d>] cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 [<dfb75f10>] xfs_bmap_add_extent_hole_delay+0x43c/0x492 [xfs] autoremove_wake_function+0x0/0x2d set_bh_page+0x2c/0x34
 [<dfb7733c>] linvfs_get_block+0x13/0x17 [xfs] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs] generic_file_buffered_write+0x186/0x47c
 [<dfb7cadb>] activate_task+0x88/0x95 autoremove_wake_function+0x0/0x2d do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd]
 [<c02d9060>] common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]cpu 0 hot: low 2, high 6, batch 1
 empty

Free pages:        2948kB (0kB HighMem)
HighMem: empty
126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33560 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 [<c014687d>] cache_alloc_refill+0x14f/0x187
 __kmalloc+0x71/0x83
 [<dfb75f10>] xfs_bmapi+0xb03/0x12cc [xfs] autoremove_wake_function+0x0/0x2d set_bh_page+0x2c/0x34
 [<dfb7733c>] linvfs_get_block+0x13/0x17 [xfs] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs] generic_file_buffered_write+0x186/0x47c
 [<dfb7cadb>] activate_task+0x88/0x95 autoremove_wake_function+0x0/0x2d do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd]
 common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]
DMA: 65*4kB 5*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 300kB
126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33546 pages shared
0 pages swap cached
nfsd: page allocation failure. order:4, mode:0x50
 [<c0143286>] __alloc_pages+0x2d6/0x2ee
 [<c01432b6>] __get_free_pages+0x18/0x24
 [<c0145c37>] kmem_getpages+0x16/0xaf
 [<c01466aa>] cache_grow+0x99/0x11d
 cache_alloc_refill+0x14f/0x187
 [<c0146bf4>] __kmalloc+0x71/0x83
 [<dfb75f10>] do_IRQ+0x123/0x1b8 autoremove_wake_function+0x0/0x2d set_bh_page+0x2c/0x34
 [<dfb7733c>] linvfs_get_block+0x13/0x17 [xfs] __block_prepare_write+0x165/0x3e7
 [<c015be6a>] block_prepare_write+0x16/0x23
 [<dfb77329>] linvfs_get_block+0x0/0x17 [xfs] generic_file_buffered_write+0x186/0x47c
 [<dfb7cadb>] activate_task+0x88/0x95 autoremove_wake_function+0x0/0x2d do_readv_writev+0x1c0/0x240
 [<c0158b1f>] do_sync_write+0x0/0xc9
 [<c0158108>] __dentry_open+0x105/0x1cf
 [<c0157ffe>] dentry_open+0x49/0x4e
 [<c015912b>] vfs_writev+0x3e/0x43
 [<dfd14ee0>] nfsd_write+0xeb/0x284 [nfsd] common_interrupt+0x18/0x20
 [<dfaf03c9>] svcauth_unix_set_client+0x7d/0xb5 [sunrpc]
 [<dfd1c52a>] nfsd3_proc_write+0xbf/0xd5 [nfsd]
 [<dfd1e5d8>] nfs3svc_decode_writeargs+0x0/0x243 [nfsd]
 [<dfd116a9>] nfsd_dispatch+0xba/0x16d [nfsd]
 [<dfaed58b>] svc_process+0x432/0x6d7 [sunrpc]
cpu 1 hot: low 32, high 96, batch 16
cpu 1 cold: low 0, high 32, batch 16
HighMem per-cpu:126767 pages of RAM
0 pages of HIGHMEM
2103 reserved pages
33534 pages shared
0 pages swap cached
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
possible deadlock in kmem_alloc (mode:0x50)
do_IRQ: stack overflow: 416
 [<c0107a27>]
--=-3KPuxqhFz7DVasZxaYzI--
