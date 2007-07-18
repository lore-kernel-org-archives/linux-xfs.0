Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jul 2007 10:49:34 -0700 (PDT)
Received: from mail.rupa.com (hosted.rupa.com [207.210.101.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6IHnTbm013683
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 10:49:31 -0700
Received: from localhost (localhost [127.0.0.1])
	by localhost.rupa.com (Postfix) with ESMTP id B1D9A1CC4332
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 13:31:01 -0400 (EDT)
Received: from mail.rupa.com ([127.0.0.1])
	by localhost (hosted.rupa.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id kWUrARhtTRQy for <xfs@oss.sgi.com>;
	Wed, 18 Jul 2007 13:30:09 -0400 (EDT)
Received: from shakti.rupa.com (gw.rupa.com [64.81.112.212])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.rupa.com (Postfix) with ESMTP id 0DAE51CC432C
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 13:28:25 -0400 (EDT)
Received: from [127.0.0.1] (rupa.rupa.com [192.168.1.10])
	by shakti.rupa.com (Postfix) with ESMTP id A416487CA20
	for <xfs@oss.sgi.com>; Wed, 18 Jul 2007 12:28:22 -0500 (CDT)
Message-ID: <469E690B.5070600@rupa.com>
Date: Wed, 18 Jul 2007 12:24:59 -0700
From: Rupa Schomaker <rupa@rupa.com>
MIME-Version: 1.0
Subject: XFS repair on / in a hosted environment
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have a virtual server hosted in a XEN environment.  Kernel is
2.6.16.13-XenU and I can't change it. :( Host provider is not responsive
to getting us a newer kernel.

Anyway, during my nightly rsync backup, I started seeing the following:

Jul 18 12:51:01 hosted kernel: 0x0: 00 00 00 00 01 00 00 00 23 00 00 00
00 00 00 00
Jul 18 12:51:01 hosted kernel: Filesystem "sda1": XFS internal error
xfs_da_do_buf(2) at line 2221 of file fs/xfs/xfs_da_btree.c.  Caller
0xc02288fd
Jul 18 12:51:01 hosted kernel:  [<c0237b71>] xfs_corruption_error+0xbb/0xc6
Jul 18 12:51:01 hosted kernel:  [<c02288fd>] xfs_da_read_buf+0x25/0x2a
Jul 18 12:51:01 hosted kernel:  [<c025e4e5>] xfs_buf_read_flags+0x1f/0x82
Jul 18 12:51:01 hosted kernel:  [<c025b1aa>] kmem_zone_alloc+0x43/0x88
Jul 18 12:51:01 hosted kernel:  [<c02287bf>] xfs_da_do_buf+0x5df/0x6a9
Jul 18 12:51:01 hosted kernel:  [<c02288fd>] xfs_da_read_buf+0x25/0x2a
Jul 18 12:51:01 hosted kernel:  [<c0169d88>] dput+0x1b/0x11c
Jul 18 12:51:01 hosted kernel:  [<c02288fd>] xfs_da_read_buf+0x25/0x2a
Jul 18 12:51:01 hosted kernel:  [<c022cc12>]
xfs_dir2_block_getdents+0xe0/0x2e4
Jul 18 12:51:01 hosted kernel:  [<c022cc12>]
xfs_dir2_block_getdents+0xe0/0x2e4
Jul 18 12:51:01 hosted kernel:  [<c013e7ee>]
get_page_from_freelist+0xa8/0x34b
Jul 18 12:51:01 hosted kernel:  [<c0219919>] xfs_bmap_last_offset+0xd5/0xe8
Jul 18 12:51:01 hosted kernel:  [<c022c537>]
xfs_dir2_put_dirent64_direct+0x0/0x8b
Jul 18 12:51:01 hosted kernel:  [<c022c17e>] xfs_dir2_isblock+0x1c/0x65
Jul 18 12:51:01 hosted kernel:  [<c022c537>]
xfs_dir2_put_dirent64_direct+0x0/0x8b
Jul 18 12:51:01 hosted kernel:  [<c022c452>] xfs_dir2_getdents+0xb0/0xe4
Jul 18 12:51:01 hosted kernel:  [<c022c537>]
xfs_dir2_put_dirent64_direct+0x0/0x8b
Jul 18 12:51:01 hosted kernel:  [<c02559d4>] xfs_readdir+0x3f/0x51
Jul 18 12:51:01 hosted kernel:  [<c025ea5e>] linvfs_readdir+0xfd/0x1d2
Jul 18 12:51:01 hosted kernel:  [<c0165d46>] vfs_readdir+0x42/0x6f
Jul 18 12:51:01 hosted kernel:  [<c0165e59>] filldir64+0x0/0xc6
Jul 18 12:51:01 hosted kernel:  [<c0165f82>] sys_getdents64+0x63/0xa9
Jul 18 12:51:01 hosted kernel:  [<c0165e59>] filldir64+0x0/0xc6
Jul 18 12:51:01 hosted kernel:  [<c0104869>] syscall_call+0x7/0xb


I've narrowed this down to a single directory which cannot be removed:

/usr/src/linux-2.6.16-xen/sound/pci/au88x0

any attempt to get the contents of the directory results in an error and
the trace:

hosted:/usr/src/linux-2.6.16-xen/sound/pci# ls -l au88x0/
ls: reading directory au88x0/: Unknown error 990


Everything is on / so I can't easily get it unmounted to run xfs_repair.

I try booting into single user mode, mount -o remount ,ro /.  xfs_repair
-d /dev/sda1 still complains about a mounted writable partition.

===

On boot, mount shows:

/dev/sda1 on / type xfs (rw)

# mount -o remount,ro /

after the remount, mount still shows / as rw

# mount
/dev/sda1 on / type xfs (rw)

but attempts to modify it result in:

hosted:~# touch foo
touch: cannot touch `foo': Read-only file system


Ok, so try xfs_repair:

hosted:~# xfs_repair -d /dev/sda1
xfs_repair: /dev/sda1 contains a mounted and writable filesystem

fatal error -- couldn't initialize XFS library

xfs_repair thinks we are writable.

I tried doing this as early as I could in the boot process by putting a
script in

/etc/rcS.d/S00fixroot

but that is not early enough.

Any thoughts?

-Rupa
