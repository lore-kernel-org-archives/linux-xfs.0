Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Jun 2007 14:56:37 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l52LuYWt003639
	for <linux-xfs@oss.sgi.com>; Sat, 2 Jun 2007 14:56:35 -0700
Date: Sat, 2 Jun 2007 17:39:13 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: corruption bug in 2.6.17
In-Reply-To: <5d96567b0706021407q4455b60asd9d23ef82cb90b55@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706021738430.22751@p34.internal.lan>
References: <5d96567b0706021407q4455b60asd9d23ef82cb90b55@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-xfs@oss.sgi.com, alkirkco@sgi.com

Raz, 2.6.17-2.6.17.6 had the nasty corruption bug you're seeing, best to 
restore from backup and/or check the FAQ and get off that kernel range 
asap.

On Sun, 3 Jun 2007, Raz Ben-Jehuda(caro) wrote:

> Mandy Hello
>
> I have got into a serious trouble with xfs . I had some directories
> returning "no such file or directory". This xfs file system is over a
> raid5 of 4 disks, with 1MB stripe unit size. files are hierarchly
> being "XFS_IOC_FSSETXATTR" extended to 1MB.
>
> when I tried to create a new file I got the bellow oops.
> could it be that your fix for 2.6.17.7 solves this problem ?
> thank you.
> raz
>
> 4499008.609000] Filesystem "md1": XFS internal error
> xfs_dir2_block_addname at line 105 of file fs/xfs/xfs_dir2_block.c.
> Caller 0xc10e7e1c
> [4499008.634000]  <c10e94c3> xfs_dir2_block_addname+0x88b/0x8a9
> <c10e7e1c> xfs_dir2_createname+0x11a/0x179
> [4499008.654000]  <c10e7e1c> xfs_dir2_createname+0x11a/0x179
> <c10d737e> xfs_bmap_last_offset+0xce/0x128
> [4499008.673000]  <c10e889e> xfs_dir2_isblock+0x32/0x82  <c10e7e1c>
> xfs_dir2_createname+0x11a/0x179
> [4499008.690000]  <c112662c> kmem_zone_alloc+0x57/0xc5  <c111a348>
> xfs_trans_ijoin+0x35/0x7f
> [4499008.707000]  <c112117d> xfs_create+0x45b/0x7aa  <c112dd89>
> xfs_vn_mknod+0x2f9/0x37e
> [4499008.725000]  <c112dec4> xfs_vn_lookup+0x79/0x96  <c1077acc>
> lookup_mnt+0x32/0x5c
> [4499008.741000]  <c1068ee2> do_lookup+0x50/0xa8  <c107300c> dput+0x23/0x183
> [4499008.755000]  <c1068f8a> __link_path_walk+0x50/0xe17  <c1077acc>
> lookup_mnt+0x32/0x5c
> [4499008.772000]  <c1077eff> mntput_no_expire+0x22/0xb1  <c1077eff>
> mntput_no_expire+0x22/0xb1
> [4499008.789000]  <c1069dc2> link_path_walk+0x71/0xc9  <c1068898>
> permission+0x7e/0x9b
> [4499008.805000]  <c106a8b2> vfs_create+0x7d/0x122  <c106b1ec>
> open_namei+0x69e/0x6ff
> [4499008.820000]  <c104ddaf> page_add_file_rmap+0x29/0x2b  <c10595a9>
> do_filp_open+0x43/0x61
> [4499008.837000]  <c105991c> do_sys_open+0x57/0xe1  <c10599cd>
> sys_open+0x27/0x2b
> [4499008.852000]  <c100300f> syscall_call+0x7/0xb
> [4499008.863000] Filesystem "md1": XFS internal error xfs_trans_cancel
> at line 1150 of file fs/xfs/xfs_trans.c.  Caller 0xc112100e
> [4499008.886000]  <c1118b57> xfs_trans_cancel+0x103/0x136  <c112100e>
> xfs_create+0x2ec/0x7aa
> [4499008.903000]  <c112100e> xfs_create+0x2ec/0x7aa  <c112dd89>
> xfs_vn_mknod+0x2f9/0x37e
> [4499008.918000]  <c112dec4> xfs_vn_lookup+0x79/0x96  <c1077acc>
> lookup_mnt+0x32/0x5c
> [4499008.935000]  <c1068ee2> do_lookup+0x50/0xa8  <c107300c> dput+0x23/0x183
> [4499008.948000]  <c1068f8a> __link_path_walk+0x50/0xe17  <c1077acc>
> lookup_mnt+0x32/0x5c
> [4499008.966000]  <c1077eff> mntput_no_expire+0x22/0xb1  <c1077eff>
> mntput_no_expire+0x22/0xb1
> [4499008.983000]  <c1069dc2> link_path_walk+0x71/0xc9  <c1068898>
> permission+0x7e/0x9b
> [4499008.999000]  <c106a8b2> vfs_create+0x7d/0x122  <c106b1ec>
> open_namei+0x69e/0x6ff
> [4499009.015000]  <c104ddaf> page_add_file_rmap+0x29/0x2b  <c10595a9>
> do_filp_open+0x43/0x61
> [4499009.031000]  <c105991c> do_sys_open+0x57/0xe1  <c10599cd>
> sys_open+0x27/0x2b
> [4499009.046000]  <c100300f> syscall_call+0x7/0xb
> [4499009.057000] xfs_force_shutdown(md1,0x8) called from line 1151 of
> file fs/xfs/xfs_trans.c.  Return address = 0xc1131b54
> [4499009.078000] Filesystem "md1": Corruption of in-memory data
> detected.  Shutting down filesystem: md1
> [4499009.097000] Please umount the filesystem, and rectify the problem(s)
>
>
> -- 
> Raz
>
>
