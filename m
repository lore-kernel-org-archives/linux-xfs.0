Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OD5Tis143368
	for <linux-xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:05:31 -0600
Received: from amanpulo.fs3.ph (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CE331486C1
	for <linux-xfs@oss.sgi.com>; Tue, 24 Feb 2009 05:04:56 -0800 (PST)
Received: from amanpulo.fs3.ph (amanpulo.fs3.ph [202.81.162.101]) by
	cuda.sgi.com with ESMTP id a2W9dKLYGZt8BRl5 for
	<linux-xfs@oss.sgi.com>; Tue, 24 Feb 2009 05:04:56 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by amanpulo.fs3.ph (Postfix) with ESMTP id 309C130317B1D
	for <linux-xfs@oss.sgi.com>; Tue, 24 Feb 2009 21:04:23 +0800 (PHT)
Received: from amanpulo.fs3.ph ([127.0.0.1])
	by localhost (amanpulo.fs3.ph [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id ZfxR-RPaEgiH for <linux-xfs@oss.sgi.com>;
	Tue, 24 Feb 2009 21:04:22 +0800 (PHT)
Received: from [172.16.0.236] (unknown [61.28.174.115])
	(using SSLv3 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by amanpulo.fs3.ph (Postfix) with ESMTP id A59DF30317B13
	for <linux-xfs@oss.sgi.com>; Tue, 24 Feb 2009 21:04:22 +0800 (PHT)
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
From: Federico Sevilla III <jijo@fs3.ph>
References: 06CCEA2EB1B80A4A937ED59005FA855101C81060@svits26.main.ad.rit.edu
In-Reply-To: 06CCEA2EB1B80A4A937ED59005FA855101C81060@svits26.main.ad.rit.edu
Date: Tue, 24 Feb 2009 21:04:21 +0800
Message-Id: <1235480661.17293.28.camel@disciplina.fs3.ph>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4736358655230825787=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <linux-xfs@oss.sgi.com>


--===============4736358655230825787==
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gy4JYCJ2AjqTOPU7zWsF"


--=-gy4JYCJ2AjqTOPU7zWsF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Recently, we had two file servers crash during periods of increased load
(increased access from workstations in the LAN). After the crash, the
XFS file systems would no longer mount. The mount process would just
stay in state D, with no progress, and no significant disk activity.

The first pass of xfs_repair (without -L) successfully found a secondary
super block. The primary was corrupted for some reason. The file system
could still not be mounted after this first xfs_repair, and xfs_repair
would no longer continue because the log had to be replayed. Running
xfs_repair a second time with the -L option worked.

Unfortunately we don't have the output of these runs of xfs_repair to
share with the list. The above narrative is the same for the crash on
both servers, though.

On one of the servers now, on the same file system that had trouble, we
are having the following messages (the system otherwise remains usable,
though, which is weird):

        attempt to access beyond end of device
        sda7: rw=3D0, want=3D154858897362229008, limit=3D3885978852
        I/O error in filesystem ("sda7") meta-data dev sda7 block 0x2262b58=
bf959708       ("xfs_trans_read_buf") error 5 buf count 4096

On this server which has been up for ~6 hours, we have 348 of the above
messages, and they are all identical.

Both servers use CentOS5 with the Linux 2.6.18-92.1.22.el5 kernel. For
the server currently spewing the above messages, the underlying storage
(quoted directly from dmesg) is:

        megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
        SCSI subsystem initialized
        megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
        megaraid: probe new device 0x1000:0x1960:0x1000:0x0523: bus 4:slot =
3:func 0
        ACPI: PCI Interrupt 0000:04:03.0[A] -> GSI 25 (level, low) -> IRQ 2=
01
        megaraid: fw version:[713S] bios version:[G121]
        scsi0 : LSI Logic MegaRAID driver
        scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
        scsi[0]: scanning scsi channel 1 [virtual] for logical drives
          Vendor: MegaRAID  Model: LD 0 RAID5 1907G  Rev: 713S
          Type:   Direct-Access                      ANSI SCSI revision: 02
        SCSI device sda: 3906242560 512-byte hdwr sectors (1999996 MB)

The information of the file system on /dev/sda7 is as follows:

        meta-data=3D/dev/sda7              isize=3D256    agcount=3D32, ags=
ize=3D15179616 blks
                 =3D                       sectsz=3D512   attr=3D2
        data     =3D                       bsize=3D4096   blocks=3D48574732=
8, imaxpct=3D25
                 =3D                       sunit=3D32     swidth=3D160 blks=
, unwritten=3D1
        naming   =3Dversion 2              bsize=3D4096 =20
        log      =3Dinternal               bsize=3D4096   blocks=3D32768, v=
ersion=3D2
                 =3D                       sectsz=3D512   sunit=3D32 blks, =
lazy-count=3D0
        realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtext=
ents=3D0

Mount options are:

        rw,logbufs=3D8,logbsize=3D256k,sunit=3D256,swidth=3D1280,nobarrier

Write cache is disabled by the hardware RAID controller for all the
drives, and caching on the controller is set to write-through. These
servers are not new, and before setting them up we ran multiple passes
of memtest86+ with no issue.

Please help me understand what the cause of this problem could be. I
have been searching and it remains unclear. Also, suggestions on what
can be done to fix this.

Thanks!

On 2008-01-03 15:55, Jay Sullivan wrote:
> I'm still seeing a lot of the following in my dmesg.  Any ideas?  See
> below for what I have already tried (including moving data to a fresh
> XFS volume).
>=20
> =20
>=20
> Tons of these; sometimes the want=3D changes, but it is always huge.
>=20
> ###
>=20
> attempt to access beyond end of device
>=20
> dm-0: rw=3D0, want=3D68609558288793608, limit=3D8178892800
>=20
> I/O error in filesystem ("dm-0") meta-data dev dm-0 block
> 0xf3c0079e000000       ("xfs_trans_read_buf") error 5 buf count 4096
>=20
> ###
>=20
> =20
>=20
> Occasionally some of these:
>=20
> ###
>=20
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4533 of file
> fs/xfs/xfs_bmap.c.  Caller 0xc028c5a2
> [<c026bc58>] xfs_bmap_read_extents+0x3bd/0x498
> [<c028c5a2>] xfs_iread_extents+0x74/0xe1
> [<c028fb02>] xfs_iext_realloc_direct+0xa4/0xe7
> [<c028f3ef>] xfs_iex t;c028c5a2>] xfs_iread_extents+0x74/0xe1
> [<c026befd>] xfs_bmapi+0x1ca/0x173f
> [<c02e2d7e>] elv_rb_add+0x6f/0x88
> [<c02eb843>] as_update_rq+0x32/0x72
> [<c02ec08b>] as_add_request+0x76/0xa4
> [<c02e330c>] elv_insert+0xd5/0x142
> [<c02e70ad>] __make_request+0xc8/0x305
> [<c02e7480>] generic_make_request+0x122/0x1d9
> [<c03ee0e3>] __map_bio+0x33/0xa9
> [<c03ee36c>] __clone_and_map+0xda/0x34c
> [<c0148fce>] mempool_alloc+0x2a/0xdb
> [<c028aa3c>] xfs_ilock+0x58/0xa0
> [<c029168b>] xfs_iomap+0x216/0x4b7
> [<c02b2000>] __xfs_get_blocks+0x6b/0x226
> [<c02f2792>] radix_tree_node_alloc+0x16/0x57
> [<c02f2997>] radix_tree_insert+0xb0/0x126
> [<c02b21e3>] xfs_get_blocks+0x28/0x2d
> [<c0183a32>] block_read_full_page+0x192/0x346
> [<c02b21bb>] xfs_get_blocks+0x0/0x2d
> [<c028a667>] xfs_iget+0x145/0x150
> [<c018982d>] do_mpage_readpag 28aba1>] xfs_iunlock+0x43/0x84
> [<c02a8096>] xfs_vget+0xe1/0xf2
> [<c020a578>] find_exported_dentry+0x71/0x4b6
> [<c014c4a4>] __do_page_cache_readahead+0x88/0x153
> [<c0189aa4>] mpage_readpage+0x4b/0x5e
> [<c02b21bb>] xfs_get_blocks+0x0/0x2d
> [<c014c69d>] blockable_page_cache_readahead+0x4d/0xb9
> [<c014c942>] page_cache_readahead+0x174/0x1a3
> [<c014630f>] find_get_page+0x18/0x3a
> [<c014684e>] do_generic_mapping_read+0x1b5/0x535
> [<c012621a>] __capable+0x8/0x1b
> [<c0146f6c>] generic_file_sendfile+0x68/0x83
> [<c020eff2>] nfsd_read_actor+0x0/0x10f
> [<c02b822f>] xfs_sendfile+0x94/0x164
> [<c020eff2>] nfsd_read_actor+0x0/0x10f
> [<c0211325>] nfsd_permission+0x6e/0x103
> [<c02b4868>] xfs_file_sendfile+0x4c/0x5c
> [<c020eff2>] nfsd_read_actor+0x0/0x10f
> [<c020f445>] nfsd_vfs_read+0x344/0x361
> [<c020eff2>] nfsd_read_actor+0x0/0x ] nfsd_read+0xd8/0xf9
> [<c021548e>] nfsd3_proc_read+0xb0/0x174
> [<c02170b4>] nfs3svc_decode_readargs+0x0/0xf7
> [<c020b535>] nfsd_dispatch+0x8a/0x1f5
> [<c048c43e>] svcauth_unix_set_client+0x11d/0x175
> [<c0488d73>] svc_process+0x4fd/0x681
> [<c020b39b>] nfsd+0x163/0x273
> [<c020b238>] nfsd+0x0/0x273
> [<c01037fb>] kernel_thread_helper+0x7/0x10
> ###
>=20
> =20
>=20
> Thanks!
>=20
> =20
>=20
> ~Jay
>=20
> =20
>=20
> From: Jay Sullivan [mailto:jpspgd@???]=20
> Sent: Thursday, December 20, 2007 9:01 PM
> To: xfs@???
> Cc: Jay Sullivan
> Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
>=20
> =20
>=20
> I'm still seeing problems.  =3D(
>=20
> =20
>=20
> Most recently I have copied all of the data off of the suspect XFS
> volume onto another fresh XFS volume.  A few days later I saw the same
> messages show up in dmesg.  I haven't had a catastrophic failure that
> makes the kernel remount the FS RO, but I don't want to wait for that to
> happen.
>=20
> =20
>=20
> Today I upgraded to the latest stable kernel in Gentoo (2.6.23-r3) and
> I'm still on xfsprogs 2.9.4, also the latest stable release.  A few
> hours after rebooting to load the new kernel, I saw the following in
> dmesg:
>=20
> =20
>=20
> ####################
>=20
> attempt to access beyond end of device
>=20
> dm-0: rw=3D0, want=3D68609558288793608, limit=3D8178892800
>=20
> I/O error in files dev dm-0 block 0xf3c0079e000000
> ("xfs_trans_read_buf") error 5 buf count 4096
>=20
> attempt to access beyond end of device
>=20
> dm-0: rw=3D0, want=3D68609558288793608, limit=3D8178892800
>=20
> I/O error in filesystem ("dm-0") meta-data dev dm-0 block
> 0xf3c0079e000000       ("xfs_trans_read_buf") error 5 buf count 4096
>=20
> attempt to access beyond end of device
>=20
> dm-0: rw=3D0, want=3D68609558288793608, limit=3D8178892800
>=20
> I/O error in filesystem ("dm-0") meta-data dev dm-0 block
> 0xf3c0079e000000       ("xfs_trans_read_buf") error 5 buf count 4096
>=20
> attempt to access beyond end of device
>=20
> dm-0: rw=3D0, want=3D68609558288793608, limit=3D8178892800
>=20
> I/O error in filesystem ("dm-0") meta-data dev dm-0 block
> 0xf3c0079e000000       ("xfs_trans_read_buf") error 5 buf count 4096
>=20
> ###################
>=20
> =20
>=20
> These are the same to access a block that is WAAAY outside of the range
> of my drives) that I was seeing before the last time my FS got remounted
> read-only by the colonel.
>=20
> =20
>=20
> Any ideas?  What other information can I gather that would help with
> troubleshooting?  Here are some more specifics:
>=20
> =20
>=20
> This is a Dell PowerEdge 1850 with a FusionMPT/LSI fibre channel card.
> The XFS volume is a 3.9TB logical volume in LVM.  The volume group is
> spread across LUNs of a Apple XServe RAIDs which are connected o'er FC
> to our fabric.  I just swapped FC switches (to a different brand even)
> and the problem was showing before and after the switch switch, so
> that's not it.  I have also swapped FC cards, upgraded FC card firmware,
> updated BIOSs, etc..  This server sees heavy NFS (v3) and samba
> (currently 3.0.24 until the current regression bug is squashed and
> stable) traffic.   usually sees 200-300Mbps throughput 24/7, although
> sometimes more.
>=20
> =20
>=20
> Far-fetched:  Is there any way that a particular file on my FS, when
> accessed, is causing the problem? =20
>=20
> =20
>=20
> I have a very similar system (Dell PE 2650, same FC card, same type of
> RAID, same SFP cables, same GPT scheme, same kernel) but instead with an
> ext3 (full journal) FS in a 5.[something]TB logical volume (LVM) with no
> problems.  Oh, and it sees system load values in the mid-20s just about
> all day. =20
>=20
> =20
>=20
> Grasping at straws.  I need XFS to work because we'll soon be requiring
> seriously large filesystems with non-sucky extended attribute and ACL
> support.  Plus it's fast and I like it.
>=20
> =20
>=20
> Can the XFS community help?  I don't want to have to turn to that guy
> that a  =3DP
>=20
> =20
>=20
> ~Jay
>=20
> =20
>=20
> =20
>=20
> On Nov 14, 2007, at 10:05 AM, Jay Sullivan wrote:
>=20
>=20
>=20
>=20
>=20
> Of course this had to happen one more time before my scheduled
> maintenance window...  Anyways, here's all of the good stuff I
> collected.  Can anyone make sense of it?  Oh, and I upgraded to xfsprogs
> 2.9.4 last week, so all output you see is with that version. =20
>=20
> Thanks!
>=20
> ###################
>=20
> dmesg output
>=20
> ###################
>=20
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4533 of file
> fs/xfs/xfs_bmap.c.  Caller 0xc028c5a2
> [<c026bc58>] xfs_bmap_read_extents+0x3bd/0x498
> [<c028c5a2>] xfs_iread_extents+0x74/0xe1
> [<c028fb02>] xfs_iext_realloc_direct+0xa4/0xe7
> [<c028f3ef>] xfs_iex t;c028c5a2>] xfs_iread_extents+0x74/0xe1
> [<c026befd>] xfs_bmapi+0x1ca/0x173f
> [<c02e2d7e>] elv_rb_add+0x6f/0x88
> [<c02eb843>] as_update_rq+0x32/0x72
> [<c02ec08b>] as_add_request+0x76/0xa4
> [<c02e330c>] elv_insert+0xd5/0x142
> [<c02e70ad>] __make_request+0xc8/0x305
> [<c02e7480>] generic_make_request+0x122/0x1d9
> [<c03ee0e3>] __map_bio+0x33/0xa9
> [<c03ee36c>] __clone_and_map+0xda/0x34c
> [<c0148fce>] mempool_alloc+0x2a/0xdb
> [<c028aa3c>] xfs_ilock+0x58/0xa0
> [<c029168b>] xfs_iomap+0x216/0x4b7
> [<c02b2000>] __xfs_get_blocks+0x6b/0x226
> [<c02f2792>] radix_tree_node_alloc+0x16/0x57
> [<c02f2997>] radix_tree_insert+0xb0/0x126
> [<c02b21e3>] xfs_get_blocks+0x28/0x2d
> [<c0183a32>] block_read_full_page+0x192/0x346
> [<c02b21bb>] xfs_get_blocks+0x0/0x2d
> [<c028a667>] xfs_iget+0x145/0x150
> [<c018982d>] do_mpage_readpag 28aba1>] xfs_iunlock+0x43/0x84
> [<c02a8096>] xfs_vget+0xe1/0xf2
> [<c020a578>] find_exported_dentry+0x71/0x4b6
> [<c014c4a4>] __do_page_cache_readahead+0x88/0x153
> [<c0189aa4>] mpage_readpage+0x4b/0x5e
> [<c02b21bb>] xfs_get_blocks+0x0/0x2d
> [<c014c69d>] blockable_page_cache_readahead+0x4d/0xb9
> [<c014c942>] page_cache_readahead+0x174/0x1a3
> [<c014630f>] find_get_page+0x18/0x3a
> [<c014684e>] do_generic_mapping_read+0x1b5/0x535
> [<c012621a>] __capable+0x8/0x1b
> [<c0146f6c>] generic_file_sendfile+0x68/0x83
> [<c020eff2>] nfsd_read_actor+0x0/0x10f
> [<c02b822f>] xfs_sendfile+0x94/0x164
> [<c020eff2>] nfsd_read_actor+0x0/0x10f
> [<c0211325>] nfsd_permission+0x6e/0x103
> [<c02b4868>] xfs_file_sendfile+0x4c/0x5c
> [<c020eff2>] nfsd_read_actor+0x0/0x10f
> [<c020f445>] nfsd_vfs_read+0x344/0x361
> [<c020eff2>] nfsd_read_actor+0x0/0x ] nfsd_read+0xd8/0xf9
> [<c021548e>] nfsd3_proc_read+0xb0/0x174
> [<c02170b4>] nfs3svc_decode_readargs+0x0/0xf7
> [<c020b535>] nfsd_dispatch+0x8a/0x1f5
> [<c048c43e>] svcauth_unix_set_client+0x11d/0x175
> [<c0488d73>] svc_process+0x4fd/0x681
> [<c020b39b>] nfsd+0x163/0x273
> [<c020b238>] nfsd+0x0/0x273
> [<c01037fb>] kernel_thread_helper+0x7/0x10
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> attempt to access beyond end of device
> dm-1: rw=3D0, want=3D6763361770196172808, limit=3D7759462400
> I/O error in filesystem ("dm-1") meta-data dev dm-1 block
> 0x5ddc49b238000000       ("xfs_trans_read_buf") error 5 buf count 4096
> xfs_force_shutdown(dm-1,0x1) called from line 415 of file
> fs/xfs/xfs_trans_buf.c.  Return address =3D 0xc02baa25
> Filesystem "dm-1": I/O Error Detected.  Shutting down filesystem: dm-1
> Please umount the filesystem, and rectify the problem(s)
>=20
>=20
> #################### I umount'ed and mount'ed the FS several times, but
> xfs_repair still told me to use -L...  Any ideas?
>=20
> #######################
>=20
> server-files ~ # umount /mnt/san/
> server-files ~ # mount /mnt/san/
> server-files ~ # umount /mnt/san/
> server-files ~ # xfs_repair
> /dev/server-files-sanvg01/server-files-sanlv01=20
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs
> to
> be replayed.  Mount the filesystem to replay the log, and unmount it
> before
> re-running xfs_repair.  If you are unable to mount the filesystem, then
> use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a
> mount
> of the filesystem before doing this.
> server-files ~ # xfs_repair -L
> /dev/server-files-sanvg01/server-files-sanlv01=20
> Pha perblock...
> Phase 2 - using internal log
>        - zero log...
> ALERT: The filesystem has valuable metadata changes in a log which is
> being
> destroyed because the -L option was used.
>        - scan filesystem freespace and inode maps...
>        - found root inode chunk
> Phase 3 - for each AG...
>        - scan and clear agi unlinked lists...
>        - process known inodes and perform inode discovery...
>        - agno =3D 0
> 4002: Badness in key lookup (length)
> bp=3D(bno 2561904, len 16384 bytes) key=3D(bno 2561904, len 8192 bytes)
> 8003: Badness in key lookup (length)
> bp=3D(bno 0, len 512 bytes) key=3D(bno 0, len 4096 bytes)
> bad bmap btree ptr 0x5f808b0400000000 in ino 5123809
> bad data fork in inode 5123809
> cleared inode 5123809
> bad magi 480148 (data fork) bmbt block 0
> bad data fork in inode 7480148
> cleared inode 7480148
>        - agno =3D 1
>        - agno =3D 2
>        - agno =3D 3
>        - agno =3D 4
>        - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>        - setting up duplicate extent list...
>        - check for inodes claiming duplicate blocks...
>        - agno =3D 0
>        - agno =3D 1
>        - agno =3D 2
>        - agno =3D 3
>        - agno =3D 4
> entry "Fuller_RotoscopeCorrected.mov" at block 0 offset 184 in directory
> inode 89923 7480148
>        clearing inode number in entry at offset 184...
> Phase 5 - rebuild AG headers and trees...
>        - reset superblock...
> 4000: Badness in key lookup (length)
> bp=3D(bno 0, len 4096 bytes) key=3D(bno 0, len 512 bytes)
> Phase 6 - check inode connectivity...
>        - resetting contents of realtime bitmap and summary inodes
>        - traversing filesystem ...
> bad hash table for directory inode 8992373 (no data entry): rebuilding
> rebuilding directory inode 8992373
> 4000: Badness in key lookup (length)
> bp=3D(bno 0, len 4096 bytes) key=3D(bno 0, len 512 bytes)
> 4000: Badness in key lookup (length)
> bp=3D(bno 0, len 4096 bytes) key=3D(bno 0, len 512 bytes)
>        - traversal finished ...
>        - moving disconnected inodes to lost+found nd correct link
> counts...
> 4000: Badness in key lookup (length)
> bp=3D(bno 0, len 4096 bytes) key=3D(bno 0, len 512 bytes)
> done
> server-files ~ # mount /mnt/san
> server-files ~ # umount /mnt/san
> server-files ~ # xfs_repair -L
> /dev/server-files-sanvg01/server-files-sanlv01=20
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - zero log...
>=20
> server-files ~ # xfs_repair
> /dev/server-files-sanvg01/server-files-sanlv01=20
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - zero log...
> XFS: totally zeroed log
>        - scan filesystem freespace and inode maps...
>        - found root inode chunk
> Phase 3 - for each AG...
>        - scan and clear agi unlinked lists...
>        - proc orm inode discovery...
>        - agno =3D 0
>        - agno =3D 1
>        - agno =3D 2
>        - agno =3D 3
>        - agno =3D 4
>        - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>        - setting up duplicate extent list...
>        - check for inodes claiming duplicate blocks...
>        - agno =3D 0
>        - agno =3D 1
>        - agno =3D 2
>        - agno =3D 3
>        - agno =3D 4
> Phase 5 - rebuild AG headers and trees...
>        - reset su check inode connectivity...
>        - resetting contents of realtime bitmap and summary inodes
>        - traversing filesystem ...
>        - traversal finished ...
>        - moving disconnected inodes to lost+found ...
> Phase 7 - verify and correct link counts...
> done
>=20
> ################
>=20
> So that's it for now.  Next week I'll be rsyncing all of the data off of
> this volume to another array.  I still want to know what's happening,
> though...  *pout*
>=20
> Anyways, thanks a lot for everyone's help.
>=20
> ~Jay
>=20
>=20
> -----Original Message-----
> From: xfs-bounce@??? [mailto:xfs-bounce@???] On Behalf
> Of Jay Sullivan
> Sent: Friday, November 02, 2007 10:49 AM
> To: xfs@???
> Subject: RE: xf rom file fs/xfs/xfs_trans_buf.c
>=20
> What can I say about Murphy and his silly laws?  I just had a drive fail
> on my array.  I wonder if this is the root of my problems...  Yay
> parity. =20
>=20
> ~Jay
>=20
> -----Original Message-----
> From: xfs-bounce@??? [mailto:xfs-bounce@???] On Behalf
> Of Jay Sullivan
> Sent: Friday, November 02, 2007 10:00 AM
> To: xfs@???
> Subject: RE: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
>=20
> I lost the xfs_repair output on an xterm with only four lines of
> scrollback...  I'll definitely be more careful to preserve more
> 'evidence' next time.  =3D(  "Pics or it didn't happen", right?
>=20
> I just upgraded xfsprogs and will scan the disk during my next scheduled
> downtime (probably in about 2 weeks).  I'm tempted to just wipe the
> volume and start over:  I have enough ' to copy
> everything out to a fresh XFS volume.
>=20
> Regarding "areca":  I'm using hardware RAID built into Apple XServe
> RAIDs o'er LSI FC929X cards.
>=20
> Someone else offered the likely explanation that the btree is corrupted.
> Isn't this something xfs_repair should be able to fix?  Would it be
> easier, safer, and faster to move the data to a new volume (and restore
> corrupted files if/as I find them from backup)?  We're talking about
> just less than 4TB of data which used to take about 6 hours to fsck (one
> pass) with ext3.  Restoring the whole shebang from backups would
> probably take the better part of 12 years (waiting for compression,
> resetting ACLs, etc.)...
>=20
> FWIW, another (way less important,) much busier and significantly larger
> logical volume on the same array has been totally fine.  Murphy--go
> figure.
>=20
> Thanks!
>=20
> -----Original Message-----
> From: Eric Sandeen [mail >]=20
> Sent: Thursday, November 01, 2007 10:30 PM
> To: Jay Sullivan
> Cc: <mailto:sandeen@???> xfs@???
> Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
>=20
> Jay Sullivan wrote:
>=20
>=20
>=20
> Good eye:  it wasn't mountable, thus the -L flag.  No recent =20
>=20
>     (unplanned) power outages.  The machine and the array that holds
> the =20
>=20
>     disks are both on serious batteries/UPS and the array's cache =20
>=20
>     batteries are in good health.
>=20
>=20
> Did you have the xfs_repair output to see what it found?  You might also
> grab the very latest xfsprogs (2.9.4) in case it's catching more cases.
>=20
> I hate it when people suggest running memtest86, but I might do that
> anyway.  :)
>=20
> What controller are you using?  If you say "areca" I might be on to
> something e seen...
>=20
> -Eric
>=20
>=20
>=20
> [[HTML alternate version deleted]]
>=20
>=20
>=20
>=20

--=-gy4JYCJ2AjqTOPU7zWsF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJo/BV5rCBSJO3Rr4RAiBEAJ9ctGG+palf795zNgbli9bXtN1g6wCffdmt
ZSz7aInaxihNfX2iXyNLI/Q=
=dpG3
-----END PGP SIGNATURE-----

--=-gy4JYCJ2AjqTOPU7zWsF--


--===============4736358655230825787==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4736358655230825787==--
