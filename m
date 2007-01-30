Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Jan 2007 16:12:10 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0U0C3qw031856
	for <xfs@oss.sgi.com>; Mon, 29 Jan 2007 16:12:05 -0800
Message-Id: <200701300010.LAA00558@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_repair leaves things un-repaired.
Date: Tue, 30 Jan 2007 11:14:58 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <1170114096.12767.9.camel@tmolus.apparatus.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: ajones@apparatus.net, xfs@oss.sgi.com

Hi Andrew,

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Andrew Jones
> Sent: Tuesday, 30 January 2007 10:42 AM
> To: xfs@oss.sgi.com
> Subject: xfs_repair leaves things un-repaired.
> 
> I have a filesystem which I cannot repair with xfs_repair.  Running
> xfs_repair results in its finding and fixing the same errors, over and
> over and over.  Whenever I attempt to manipulate certain directories,
> the filesystem shuts itself down:
> 
> Jan 29 17:59:02 amnesiac kernel:  [<f94ab38a>] xfs_btree_check_sblock
> +0x9c/0xab [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f949484e>] xfs_alloc_lookup
> +0x134/0x35c [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f949484e>] xfs_alloc_lookup
> +0x134/0x35c [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f94921cd>] xfs_free_ag_extent
> +0x48/0x5fd [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f94939fd>] 
> xfs_free_extent+0xb7/0xd4
> [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f94a1824>] xfs_bmap_finish
> +0xe6/0x167 [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f94c00d3>] xfs_itruncate_finish
> +0x1af/0x2ff [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f94dae5b>] 
> xfs_inactive+0x254/0x92c
> [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<c016eb53>] iput+0x3d/0x66
> Jan 29 17:59:02 amnesiac kernel:  [<f94d9eb8>] xfs_remove+0x322/0x3a9
> [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f94e15f9>] xfs_validate_fields
> +0x1e/0x7d [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<f94e1b9e>] xfs_vn_unlink+0x2f/0x3b
> [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<c017bc3f>] inotify_inode_is_dead
> +0x18/0x6c
> Jan 29 17:59:02 amnesiac kernel:  [<f94e4047>] xfs_fs_clear_inode
> +0x6d/0xa3 [xfs]
> Jan 29 17:59:02 amnesiac kernel:  [<c016efe2>] clear_inode+0xab/0xd8
> Jan 29 17:59:02 amnesiac kernel:  [<c016f0cc>] generic_delete_inode
> +0xbd/0x10f
> Jan 29 17:59:02 amnesiac kernel:  [<c016eb7a>] iput+0x64/0x66
> Jan 29 17:59:02 amnesiac kernel:  [<c0167c6b>] do_unlinkat+0xa7/0x113
> Jan 29 17:59:02 amnesiac kernel:  [<c0169822>] vfs_readdir+0x7d/0x8d
> Jan 29 17:59:02 amnesiac kernel:  [<c016964c>] filldir64+0x0/0xc3
> Jan 29 17:59:02 amnesiac kernel:  [<c01698cd>] 
> sys_getdents64+0x9b/0xa5
> Jan 29 17:59:02 amnesiac kernel:  [<c0102c11>] sysenter_past_esp
> +0x56/0x79
> Jan 29 17:59:02 amnesiac kernel: xfs_force_shutdown(dm-0,0x8) called
> from line 4267 of file fs/xfs/xfs_bmap.c.  Return address = 0xf94e46f0
> Jan 29 17:59:15 amnesiac kernel: xfs_force_shutdown(dm-0,0x1) called
> from line 424 of file fs/xfs/xfs_rw.c.  Return address = 0xf94e46f0
> Jan 29 17:59:15 amnesiac kernel: xfs_force_shutdown(dm-0,0x1) called
> from line 424 of file fs/xfs/xfs_rw.c.  Return address = 0xf94e46f0
> 
> I think the second and third "xfs_force_shutdown" calls came after I
> unmounted, remounted, and attempted to repeat the "rm" that had failed
> with the first one, without an xfs_repair attempt in the interregnum.
> 
> I tried copying it from one filesystem to a new one, using tar.  It
> worked fine for a while, but then I had an "unplanned" 
> shutdown due to a
> failure in the RAID devices.  Since then, the same problems 
> have arisen.
> 
> Is this a normal problem? Should I just give up and copy to a new
> filesystem?

The xfs_repair output is valid. All the inodes that are reporting errors
are orphaned inodes that were moved into lost+found. At the start of
phase 4, the lost+found directory is deleted which causes all the inodes
in lost+found to be re-orphaned. The current solution to this problem is
to rename lost+found after an xfs_repair run and then unmount and try
xfs_repair again.

Regarding the shutdown, that is not normal and I personally don't know
what the problem is from the trace. If it's a corrupt lost+found that
xfs_repair is generating (I gather you are rm'ing lost+found), the
second xfs_repair run after a rename should identify the problem with
the directory. You can also try running xfs_check on the device as it
may pick up something xfs_repair is missing.

Regards,
Barry.

> root@amnesiac#xfs_info /dev/vg0/home
> meta-data=/dev/vg0/home          isize=256    agcount=65, 
> agsize=7325792
> blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=468855808,
> imaxpct=25
>          =                       sunit=0      swidth=0 blks, 
> unwritten=1
> naming   =version 2              bsize=4096
> log      =internal               bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> root@amnesiac#uname -a
> Linux amnesiac 2.6.18-3-686 #1 SMP Sun Dec 10 19:37:06 UTC 2006 i686
> GNU/Linux
> root@amnesiac#xfs_repair -V
> xfs_repair version 2.8.18
> 
> The xfs_repair -v output is attached to this message.
> 
