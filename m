Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Jul 2006 06:45:21 -0700 (PDT)
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.190])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6LDj8DW004356
	for <xfs@oss.sgi.com>; Fri, 21 Jul 2006 06:45:10 -0700
Received: by nf-out-0910.google.com with SMTP id a27so784155nfc
        for <xfs@oss.sgi.com>; Fri, 21 Jul 2006 06:44:45 -0700 (PDT)
Message-ID: <68559cef0607210519q9f382c6n7104bef9cf9716f3@mail.gmail.com>
Date: Fri, 21 Jul 2006 14:19:34 +0200
From: "Luca Maranzano" <liuk001@gmail.com>
Subject: Page allocation failure writing to an XFS volume via NFS on CentOS 4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello all,

we have a CentOS 4.3 Server on an HP DL 380G3, 1 Xeon 2,8 Ghz (no
hyperthreading), 1GB RAM.
Kernel: 2.6.9-34.0.2.EL
Xfs:
- xfsprogs-2.7.3-1
- kernel-module-xfs-2.6.9-34.EL-0.1-3

modinfo xfs:
filename:       /lib/modules/2.6.9-34.0.2.EL/extra/xfs.ko
author:         Silicon Graphics, Inc.
description:    SGI-XFS CVS-2004-10-17_05:00_UTC with ACLs, security
attributes, realtime, large block numbers, no debug enabled
license:        GPL
vermagic:       2.6.9-34.EL 686 REGPARM 4KSTACKS gcc-3.4
depends:


The server has 1 Emulex Lp9002 with 3 LUNs of our SAN.
2 LUNs are forming a Striped LVM2 volume of 2,7 TB (/sansata/big)
1 LUN is an LVM2 volume of 1,5 TB (/sansata/medium)

Both LVs are exported via NFS and are formatted with XFS.

Today, while transfering data via NFS from another server to
/sansata/medium, we got the following error:

kswapd0: page allocation failure. order:0, mode:0xd0
 [<c014c48d>] __alloc_pages+0x2e1/0x2f7
 [<c014c4bb>] __get_free_pages+0x18/0x24
 [<c014f9a2>] kmem_getpages+0x15/0x94
 [<c015065f>] cache_grow+0x107/0x233
 [<c0150982>] cache_alloc_refill+0x1f7/0x227
 [<c0150bf4>] kmem_cache_alloc+0x46/0x4c
 [<c014ac4d>] mempool_alloc+0xb6/0x1f9
 [<c011e867>] autoremove_wake_function+0x0/0x2d
 [<c011e867>] autoremove_wake_function+0x0/0x2d
 [<f8aa86ea>] EmsPlatformCreateIo+0x2a/0x60 [emcp]
 [<f8aa8978>] allocPio+0x18/0x40 [emcp]
 [<f8aa89e7>] emcp_pseudo_mrf+0x27/0x60 [emcp]
 [<c02518a6>] generic_make_request+0x190/0x1a0
 [<c016dff5>] bio_clone+0x8b/0xa3
 [<f8873370>] __map_bio+0x34/0xb4 [dm_mod]
 [<f8873579>] __clone_and_map+0xc3/0x2c9 [dm_mod]
 [<c014c35d>] __alloc_pages+0x1b1/0x2f7
 [<f8873829>] __split_bio+0xaa/0x108 [dm_mod]
 [<f8873965>] dm_request+0xde/0xf1 [dm_mod]
 [<c02518a6>] generic_make_request+0x190/0x1a0
 [<c011e867>] autoremove_wake_function+0x0/0x2d
 [<c025195a>] submit_bio+0xa4/0xac
 [<c016de25>] bio_alloc+0x100/0x168
 [<c016d7da>] submit_bh+0x13e/0x163
 [<f93a4d6d>] xfs_submit_page+0x84/0xa8 [xfs]
 [<f93a4f71>] xfs_convert_page+0x1e0/0x1f4 [xfs]
 [<f93a4fbe>] xfs_cluster_write+0x39/0x43 [xfs]
 [<f93a5488>] xfs_page_state_convert+0x4c0/0x50c [xfs]
 [<f93a598a>] linvfs_writepage+0x91/0xc6 [xfs]
 [<c0152fac>] pageout+0x88/0xc5
 [<c01531f2>] shrink_list+0x209/0x4ea
 [<c01536d2>] shrink_cache+0x1ff/0x454
 [<c0152d91>] shrink_slab+0x7d/0x14c
 [<c015408c>] shrink_zone+0x8f/0x9e
 [<c015442f>] balance_pgdat+0x197/0x2cb
 [<c015461c>] kswapd+0xb9/0xbb
 [<c011e867>] autoremove_wake_function+0x0/0x2d
 [<c031139a>] ret_from_fork+0x6/0x14
 [<c011e867>] autoremove_wake_function+0x0/0x2d
 [<c0154563>] kswapd+0x0/0xbb
 [<c01041dd>] kernel_thread_helper+0x5/0xb
Mem-info:
DMA per-cpu:
cpu 0 hot: low 2, high 6, batch 1
cpu 0 cold: low 0, high 2, batch 1
Normal per-cpu:
cpu 0 hot: low 32, high 96, batch 16
cpu 0 cold: low 0, high 32, batch 16
HighMem per-cpu:
cpu 0 hot: low 14, high 42, batch 7
cpu 0 cold: low 0, high 14, batch 7

Free pages:         280kB (280kB HighMem)
Active:3798 inactive:247509 dirty:671 writeback:14620 unstable:0
free:70 slab:4738 mapped:3512 pagetables:249
DMA free:0kB min:16kB low:32kB high:48kB active:40kB inactive:12344kB
present:16384kB pages_scanned:0 all_unreclaimable? no
protections[]: 0 0 0
Normal free:0kB min:936kB low:1872kB high:2808kB active:2236kB
inactive:865676kB present:901120kB pages_scanned:0 all_unreclaimable?
no
protections[]: 0 0 0
HighMem free:280kB min:128kB low:256kB high:384kB active:12916kB
inactive:112016kB present:131048kB pages_scanned:0 all_unreclaimable?
no
protections[]: 0 0 0
DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB
0*2048kB 0*4096kB = 0kB
Normal: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 0kB
HighMem: 0*4kB 15*8kB 4*16kB 1*32kB 1*64kB 0*128kB 0*256kB 0*512kB
0*1024kB 0*2048kB 0*4096kB = 280kB
Swap cache: add 35191, delete 34409, find 16993/22779, race 0+0
0 bounce buffer pages
Free swap:       1040416kB
262138 pages of RAM
32762 pages of HIGHMEM
3180 reserved pages
48473 pages shared
782 pages swap cached

Despite this, the data transfer has completed at a reasonable speed
and the file seems to be correct (it is a gz file and "gzip -vt"
reports OK).

I can't say if this is a real XFS issue, but I'd like to share with
you my doubts about the stability of this setup, since this server is
used as a "disk library" to backup a lot of data which are then backed
up to a LTO Library via Netbackup.

I'm very happy about the performance of the XFS partitions (on the
Striped LVM DBench reported about 209 MB/s for 16 clients, bonnie++
reported 60MB/s for sequential block writing) and I'm always been an
XFS fan :-).
I've some suspect about the 4KSTACKS issues and the 2.4.9-x kernel
used by RedHat 4 or CentOS 4.3: are there any known problems with this
version of kernel?
Please see also my other post about "xfs: possible memory allocation
deadlock in _pagebuf_lookup_pages" of some days ago.

>From what I've read searching the Net it seems that XFS and RedHat are
not big friends, correct me if I'm wrong :-/.

I'd like to try latest SuSE as an alternative, since I need certified
support for our EMC SAN Storage, but I cannot go back and reinstall
all at this point.

Let me know if you need more info.

Your considerations are welcome.
Thanks in advance.
Cheers,
Luca
