Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jan 2008 07:55:46 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m03FtdNU032573
	for <xfs@oss.sgi.com>; Thu, 3 Jan 2008 07:55:41 -0800
Received: from SVITS26.main.ad.rit.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E849BBE7DA1
	for <xfs@oss.sgi.com>; Thu,  3 Jan 2008 07:55:52 -0800 (PST)
Received: from SVITS26.main.ad.rit.edu (svits26.main.ad.rit.edu [129.21.18.136]) by cuda.sgi.com with ESMTP id dppxY1M4kXM8rR1Z for <xfs@oss.sgi.com>; Thu, 03 Jan 2008 07:55:52 -0800 (PST)
MIME-Version: 1.0
Subject: RE: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
Date: Thu, 3 Jan 2008 10:55:48 -0500
Message-ID: <06CCEA2EB1B80A4A937ED59005FA855101C81060@svits26.main.ad.rit.edu>
In-reply-to: <C8CBE79A-8D1D-4151-ADFD-2C9400FAF356@rit.edu>
References: <B3EDBE0F860AF74BAA82EF17A7CDEDC660BE05A3@svits26.main.ad.rit.edu> <C8CBE79A-8D1D-4151-ADFD-2C9400FAF356@rit.edu>
From: "Jay Sullivan" <jpspgd@rit.edu>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Jay Sullivan <jpspgd@rit.edu>

I'm still seeing a lot of the following in my dmesg.  Any ideas?  See
below for what I have already tried (including moving data to a fresh
XFS volume).

 

Tons of these; sometimes the want= changes, but it is always huge.

###

attempt to access beyond end of device

dm-0: rw=0, want=68609558288793608, limit=8178892800

I/O error in filesystem ("dm-0") meta-data dev dm-0 block
0xf3c0079e000000       ("xfs_trans_read_buf") error 5 buf count 4096

###

 

Occasionally some of these:

###

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4533 of file
fs/xfs/xfs_bmap.c.  Caller 0xc028c5a2
[<c026bc58>] xfs_bmap_read_extents+0x3bd/0x498
[<c028c5a2>] xfs_iread_extents+0x74/0xe1
[<c028fb02>] xfs_iext_realloc_direct+0xa4/0xe7
[<c028f3ef>] xfs_iex t;c028c5a2>] xfs_iread_extents+0x74/0xe1
[<c026befd>] xfs_bmapi+0x1ca/0x173f
[<c02e2d7e>] elv_rb_add+0x6f/0x88
[<c02eb843>] as_update_rq+0x32/0x72
[<c02ec08b>] as_add_request+0x76/0xa4
[<c02e330c>] elv_insert+0xd5/0x142
[<c02e70ad>] __make_request+0xc8/0x305
[<c02e7480>] generic_make_request+0x122/0x1d9
[<c03ee0e3>] __map_bio+0x33/0xa9
[<c03ee36c>] __clone_and_map+0xda/0x34c
[<c0148fce>] mempool_alloc+0x2a/0xdb
[<c028aa3c>] xfs_ilock+0x58/0xa0
[<c029168b>] xfs_iomap+0x216/0x4b7
[<c02b2000>] __xfs_get_blocks+0x6b/0x226
[<c02f2792>] radix_tree_node_alloc+0x16/0x57
[<c02f2997>] radix_tree_insert+0xb0/0x126
[<c02b21e3>] xfs_get_blocks+0x28/0x2d
[<c0183a32>] block_read_full_page+0x192/0x346
[<c02b21bb>] xfs_get_blocks+0x0/0x2d
[<c028a667>] xfs_iget+0x145/0x150
[<c018982d>] do_mpage_readpag 28aba1>] xfs_iunlock+0x43/0x84
[<c02a8096>] xfs_vget+0xe1/0xf2
[<c020a578>] find_exported_dentry+0x71/0x4b6
[<c014c4a4>] __do_page_cache_readahead+0x88/0x153
[<c0189aa4>] mpage_readpage+0x4b/0x5e
[<c02b21bb>] xfs_get_blocks+0x0/0x2d
[<c014c69d>] blockable_page_cache_readahead+0x4d/0xb9
[<c014c942>] page_cache_readahead+0x174/0x1a3
[<c014630f>] find_get_page+0x18/0x3a
[<c014684e>] do_generic_mapping_read+0x1b5/0x535
[<c012621a>] __capable+0x8/0x1b
[<c0146f6c>] generic_file_sendfile+0x68/0x83
[<c020eff2>] nfsd_read_actor+0x0/0x10f
[<c02b822f>] xfs_sendfile+0x94/0x164
[<c020eff2>] nfsd_read_actor+0x0/0x10f
[<c0211325>] nfsd_permission+0x6e/0x103
[<c02b4868>] xfs_file_sendfile+0x4c/0x5c
[<c020eff2>] nfsd_read_actor+0x0/0x10f
[<c020f445>] nfsd_vfs_read+0x344/0x361
[<c020eff2>] nfsd_read_actor+0x0/0x ] nfsd_read+0xd8/0xf9
[<c021548e>] nfsd3_proc_read+0xb0/0x174
[<c02170b4>] nfs3svc_decode_readargs+0x0/0xf7
[<c020b535>] nfsd_dispatch+0x8a/0x1f5
[<c048c43e>] svcauth_unix_set_client+0x11d/0x175
[<c0488d73>] svc_process+0x4fd/0x681
[<c020b39b>] nfsd+0x163/0x273
[<c020b238>] nfsd+0x0/0x273
[<c01037fb>] kernel_thread_helper+0x7/0x10
###

 

Thanks!

 

~Jay

 

From: Jay Sullivan [mailto:jpspgd@rit.edu] 
Sent: Thursday, December 20, 2007 9:01 PM
To: xfs@oss.sgi.com
Cc: Jay Sullivan
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c

 

I'm still seeing problems.  =(

 

Most recently I have copied all of the data off of the suspect XFS
volume onto another fresh XFS volume.  A few days later I saw the same
messages show up in dmesg.  I haven't had a catastrophic failure that
makes the kernel remount the FS RO, but I don't want to wait for that to
happen.

 

Today I upgraded to the latest stable kernel in Gentoo (2.6.23-r3) and
I'm still on xfsprogs 2.9.4, also the latest stable release.  A few
hours after rebooting to load the new kernel, I saw the following in
dmesg:

 

####################

attempt to access beyond end of device

dm-0: rw=0, want=68609558288793608, limit=8178892800

I/O error in files dev dm-0 block 0xf3c0079e000000
("xfs_trans_read_buf") error 5 buf count 4096

attempt to access beyond end of device

dm-0: rw=0, want=68609558288793608, limit=8178892800

I/O error in filesystem ("dm-0") meta-data dev dm-0 block
0xf3c0079e000000       ("xfs_trans_read_buf") error 5 buf count 4096

attempt to access beyond end of device

dm-0: rw=0, want=68609558288793608, limit=8178892800

I/O error in filesystem ("dm-0") meta-data dev dm-0 block
0xf3c0079e000000       ("xfs_trans_read_buf") error 5 buf count 4096

attempt to access beyond end of device

dm-0: rw=0, want=68609558288793608, limit=8178892800

I/O error in filesystem ("dm-0") meta-data dev dm-0 block
0xf3c0079e000000       ("xfs_trans_read_buf") error 5 buf count 4096

###################

 

These are the same to access a block that is WAAAY outside of the range
of my drives) that I was seeing before the last time my FS got remounted
read-only by the colonel.

 

Any ideas?  What other information can I gather that would help with
troubleshooting?  Here are some more specifics:

 

This is a Dell PowerEdge 1850 with a FusionMPT/LSI fibre channel card.
The XFS volume is a 3.9TB logical volume in LVM.  The volume group is
spread across LUNs of a Apple XServe RAIDs which are connected o'er FC
to our fabric.  I just swapped FC switches (to a different brand even)
and the problem was showing before and after the switch switch, so
that's not it.  I have also swapped FC cards, upgraded FC card firmware,
updated BIOSs, etc..  This server sees heavy NFS (v3) and samba
(currently 3.0.24 until the current regression bug is squashed and
stable) traffic.   usually sees 200-300Mbps throughput 24/7, although
sometimes more.

 

Far-fetched:  Is there any way that a particular file on my FS, when
accessed, is causing the problem?  

 

I have a very similar system (Dell PE 2650, same FC card, same type of
RAID, same SFP cables, same GPT scheme, same kernel) but instead with an
ext3 (full journal) FS in a 5.[something]TB logical volume (LVM) with no
problems.  Oh, and it sees system load values in the mid-20s just about
all day.  

 

Grasping at straws.  I need XFS to work because we'll soon be requiring
seriously large filesystems with non-sucky extended attribute and ACL
support.  Plus it's fast and I like it.

 

Can the XFS community help?  I don't want to have to turn to that guy
that a  =P

 

~Jay

 

 

On Nov 14, 2007, at 10:05 AM, Jay Sullivan wrote:





Of course this had to happen one more time before my scheduled
maintenance window...  Anyways, here's all of the good stuff I
collected.  Can anyone make sense of it?  Oh, and I upgraded to xfsprogs
2.9.4 last week, so all output you see is with that version.  

Thanks!

###################

dmesg output

###################

XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4533 of file
fs/xfs/xfs_bmap.c.  Caller 0xc028c5a2
[<c026bc58>] xfs_bmap_read_extents+0x3bd/0x498
[<c028c5a2>] xfs_iread_extents+0x74/0xe1
[<c028fb02>] xfs_iext_realloc_direct+0xa4/0xe7
[<c028f3ef>] xfs_iex t;c028c5a2>] xfs_iread_extents+0x74/0xe1
[<c026befd>] xfs_bmapi+0x1ca/0x173f
[<c02e2d7e>] elv_rb_add+0x6f/0x88
[<c02eb843>] as_update_rq+0x32/0x72
[<c02ec08b>] as_add_request+0x76/0xa4
[<c02e330c>] elv_insert+0xd5/0x142
[<c02e70ad>] __make_request+0xc8/0x305
[<c02e7480>] generic_make_request+0x122/0x1d9
[<c03ee0e3>] __map_bio+0x33/0xa9
[<c03ee36c>] __clone_and_map+0xda/0x34c
[<c0148fce>] mempool_alloc+0x2a/0xdb
[<c028aa3c>] xfs_ilock+0x58/0xa0
[<c029168b>] xfs_iomap+0x216/0x4b7
[<c02b2000>] __xfs_get_blocks+0x6b/0x226
[<c02f2792>] radix_tree_node_alloc+0x16/0x57
[<c02f2997>] radix_tree_insert+0xb0/0x126
[<c02b21e3>] xfs_get_blocks+0x28/0x2d
[<c0183a32>] block_read_full_page+0x192/0x346
[<c02b21bb>] xfs_get_blocks+0x0/0x2d
[<c028a667>] xfs_iget+0x145/0x150
[<c018982d>] do_mpage_readpag 28aba1>] xfs_iunlock+0x43/0x84
[<c02a8096>] xfs_vget+0xe1/0xf2
[<c020a578>] find_exported_dentry+0x71/0x4b6
[<c014c4a4>] __do_page_cache_readahead+0x88/0x153
[<c0189aa4>] mpage_readpage+0x4b/0x5e
[<c02b21bb>] xfs_get_blocks+0x0/0x2d
[<c014c69d>] blockable_page_cache_readahead+0x4d/0xb9
[<c014c942>] page_cache_readahead+0x174/0x1a3
[<c014630f>] find_get_page+0x18/0x3a
[<c014684e>] do_generic_mapping_read+0x1b5/0x535
[<c012621a>] __capable+0x8/0x1b
[<c0146f6c>] generic_file_sendfile+0x68/0x83
[<c020eff2>] nfsd_read_actor+0x0/0x10f
[<c02b822f>] xfs_sendfile+0x94/0x164
[<c020eff2>] nfsd_read_actor+0x0/0x10f
[<c0211325>] nfsd_permission+0x6e/0x103
[<c02b4868>] xfs_file_sendfile+0x4c/0x5c
[<c020eff2>] nfsd_read_actor+0x0/0x10f
[<c020f445>] nfsd_vfs_read+0x344/0x361
[<c020eff2>] nfsd_read_actor+0x0/0x ] nfsd_read+0xd8/0xf9
[<c021548e>] nfsd3_proc_read+0xb0/0x174
[<c02170b4>] nfs3svc_decode_readargs+0x0/0xf7
[<c020b535>] nfsd_dispatch+0x8a/0x1f5
[<c048c43e>] svcauth_unix_set_client+0x11d/0x175
[<c0488d73>] svc_process+0x4fd/0x681
[<c020b39b>] nfsd+0x163/0x273
[<c020b238>] nfsd+0x0/0x273
[<c01037fb>] kernel_thread_helper+0x7/0x10
=======================
attempt to access beyond end of device
dm-1: rw=0, want=6763361770196172808, limit=7759462400
I/O error in filesystem ("dm-1") meta-data dev dm-1 block
0x5ddc49b238000000       ("xfs_trans_read_buf") error 5 buf count 4096
xfs_force_shutdown(dm-1,0x1) called from line 415 of file
fs/xfs/xfs_trans_buf.c.  Return address = 0xc02baa25
Filesystem "dm-1": I/O Error Detected.  Shutting down filesystem: dm-1
Please umount the filesystem, and rectify the problem(s)


#################### I umount'ed and mount'ed the FS several times, but
xfs_repair still told me to use -L...  Any ideas?

#######################

server-files ~ # umount /mnt/san/
server-files ~ # mount /mnt/san/
server-files ~ # umount /mnt/san/
server-files ~ # xfs_repair
/dev/server-files-sanvg01/server-files-sanlv01 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
       - zero log...
ERROR: The filesystem has valuable metadata changes in a log which needs
to
be replayed.  Mount the filesystem to replay the log, and unmount it
before
re-running xfs_repair.  If you are unable to mount the filesystem, then
use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a
mount
of the filesystem before doing this.
server-files ~ # xfs_repair -L
/dev/server-files-sanvg01/server-files-sanlv01 
Pha perblock...
Phase 2 - using internal log
       - zero log...
ALERT: The filesystem has valuable metadata changes in a log which is
being
destroyed because the -L option was used.
       - scan filesystem freespace and inode maps...
       - found root inode chunk
Phase 3 - for each AG...
       - scan and clear agi unlinked lists...
       - process known inodes and perform inode discovery...
       - agno = 0
4002: Badness in key lookup (length)
bp=(bno 2561904, len 16384 bytes) key=(bno 2561904, len 8192 bytes)
8003: Badness in key lookup (length)
bp=(bno 0, len 512 bytes) key=(bno 0, len 4096 bytes)
bad bmap btree ptr 0x5f808b0400000000 in ino 5123809
bad data fork in inode 5123809
cleared inode 5123809
bad magi 480148 (data fork) bmbt block 0
bad data fork in inode 7480148
cleared inode 7480148
       - agno = 1
       - agno = 2
       - agno = 3
       - agno = 4
       - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
       - setting up duplicate extent list...
       - check for inodes claiming duplicate blocks...
       - agno = 0
       - agno = 1
       - agno = 2
       - agno = 3
       - agno = 4
entry "Fuller_RotoscopeCorrected.mov" at block 0 offset 184 in directory
inode 89923 7480148
       clearing inode number in entry at offset 184...
Phase 5 - rebuild AG headers and trees...
       - reset superblock...
4000: Badness in key lookup (length)
bp=(bno 0, len 4096 bytes) key=(bno 0, len 512 bytes)
Phase 6 - check inode connectivity...
       - resetting contents of realtime bitmap and summary inodes
       - traversing filesystem ...
bad hash table for directory inode 8992373 (no data entry): rebuilding
rebuilding directory inode 8992373
4000: Badness in key lookup (length)
bp=(bno 0, len 4096 bytes) key=(bno 0, len 512 bytes)
4000: Badness in key lookup (length)
bp=(bno 0, len 4096 bytes) key=(bno 0, len 512 bytes)
       - traversal finished ...
       - moving disconnected inodes to lost+found nd correct link
counts...
4000: Badness in key lookup (length)
bp=(bno 0, len 4096 bytes) key=(bno 0, len 512 bytes)
done
server-files ~ # mount /mnt/san
server-files ~ # umount /mnt/san
server-files ~ # xfs_repair -L
/dev/server-files-sanvg01/server-files-sanlv01 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
       - zero log...

server-files ~ # xfs_repair
/dev/server-files-sanvg01/server-files-sanlv01 
Phase 1 - find and verify superblock...
Phase 2 - using internal log
       - zero log...
XFS: totally zeroed log
       - scan filesystem freespace and inode maps...
       - found root inode chunk
Phase 3 - for each AG...
       - scan and clear agi unlinked lists...
       - proc orm inode discovery...
       - agno = 0
       - agno = 1
       - agno = 2
       - agno = 3
       - agno = 4
       - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
       - setting up duplicate extent list...
       - check for inodes claiming duplicate blocks...
       - agno = 0
       - agno = 1
       - agno = 2
       - agno = 3
       - agno = 4
Phase 5 - rebuild AG headers and trees...
       - reset su check inode connectivity...
       - resetting contents of realtime bitmap and summary inodes
       - traversing filesystem ...
       - traversal finished ...
       - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done

################

So that's it for now.  Next week I'll be rsyncing all of the data off of
this volume to another array.  I still want to know what's happening,
though...  *pout*

Anyways, thanks a lot for everyone's help.

~Jay


-----Original Message-----
From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of Jay Sullivan
Sent: Friday, November 02, 2007 10:49 AM
To: xfs@oss.sgi.com
Subject: RE: xf rom file fs/xfs/xfs_trans_buf.c

What can I say about Murphy and his silly laws?  I just had a drive fail
on my array.  I wonder if this is the root of my problems...  Yay
parity.  

~Jay

-----Original Message-----
From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] On Behalf
Of Jay Sullivan
Sent: Friday, November 02, 2007 10:00 AM
To: xfs@oss.sgi.com
Subject: RE: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c

I lost the xfs_repair output on an xterm with only four lines of
scrollback...  I'll definitely be more careful to preserve more
'evidence' next time.  =(  "Pics or it didn't happen", right?

I just upgraded xfsprogs and will scan the disk during my next scheduled
downtime (probably in about 2 weeks).  I'm tempted to just wipe the
volume and start over:  I have enough ' to copy
everything out to a fresh XFS volume.

Regarding "areca":  I'm using hardware RAID built into Apple XServe
RAIDs o'er LSI FC929X cards.

Someone else offered the likely explanation that the btree is corrupted.
Isn't this something xfs_repair should be able to fix?  Would it be
easier, safer, and faster to move the data to a new volume (and restore
corrupted files if/as I find them from backup)?  We're talking about
just less than 4TB of data which used to take about 6 hours to fsck (one
pass) with ext3.  Restoring the whole shebang from backups would
probably take the better part of 12 years (waiting for compression,
resetting ACLs, etc.)...

FWIW, another (way less important,) much busier and significantly larger
logical volume on the same array has been totally fine.  Murphy--go
figure.

Thanks!

-----Original Message-----
From: Eric Sandeen [mail >] 
Sent: Thursday, November 01, 2007 10:30 PM
To: Jay Sullivan
Cc: <mailto:sandeen@sandeen.net> xfs@oss.sgi.com
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c

Jay Sullivan wrote:



Good eye:  it wasn't mountable, thus the -L flag.  No recent  

	(unplanned) power outages.  The machine and the array that holds
the  

	disks are both on serious batteries/UPS and the array's cache  

	batteries are in good health.


Did you have the xfs_repair output to see what it found?  You might also
grab the very latest xfsprogs (2.9.4) in case it's catching more cases.

I hate it when people suggest running memtest86, but I might do that
anyway.  :)

What controller are you using?  If you say "areca" I might be on to
something e seen...

-Eric



[[HTML alternate version deleted]]
