Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 06:42:07 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBIEg01g007829
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:42:03 -0800
Received: from smtp-tls.univ-nantes.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B91C1180318
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:42:11 -0800 (PST)
Received: from smtp-tls.univ-nantes.fr (Smtp-Tls1.univ-nantes.fr [193.52.101.145]) by cuda.sgi.com with ESMTP id lTSqu7l7HqVfPAjm for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 06:42:11 -0800 (PST)
Message-ID: <4767DC20.1080406@univ-nantes.fr>
Date: Tue, 18 Dec 2007 15:41:36 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: kernel oops on debian , 2.6.18-5
References: <476790D5.6040205@univ-nantes.fr> <20071218123259.GL4396912@sgi.com>
In-Reply-To: <20071218123259.GL4396912@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, Jacky Carimalo <jacky.carimalo@univ-nantes.fr>

David Chinner wrote:
> On Tue, Dec 18, 2007 at 10:20:21AM +0100, Yann Dupont wrote:
>   
>> Hello, we got a kernel oops, probably in xfs on a debian kernel.
>>
>> This volume is on SAN + device mapper.
>> this is a 1 TB  volume. It was in service for more than 2 ou 3 years.
>> There is a high humber of files on it, as this volume serves for a
>> rsyncd, where 200+ servers sync their root filesystem on it every day.
>>
>> here is the oops :
>>
>> Dec 16 23:27:32 inchgower kernel: XFS internal error
>> XFS_WANT_CORRUPTED_GOTO at line 1561 of file fs/xfs/xfs_alloc.c.  Caller
>> 0xffffffff881857b7
>> Dec 16 23:27:32 inchgower kernel:
>> Dec 16 23:27:32 inchgower kernel: Call Trace:
>> Dec 16 23:27:32 inchgower kernel:  [<ffffffff88183ec0>]
>> :xfs:xfs_free_ag_extent+0x19f/0x67f
>>     
>
> corrupted freespace btree. what does xfs_check tell you about the
> filesystem on dm-3?
>
>   
xfs_check tells me to run xfs_repair -L, the attempts to mount the FS
to clear the logs ending in kernel oops.

XFS internal error XFS_WANT_CORRUPTED_RETURN at line 281 of file 
fs/xfs/xfs_alloc.c.  Caller 0xffffffff88182f74

Call Trace:
  [<ffffffff881816ed>] :xfs:xfs_alloc_fixup_trees+0x2fa/0x30b
  [<ffffffff88198822>] :xfs:xfs_btree_setbuf+0x1f/0x89
  [<ffffffff88182f74>] :xfs:xfs_alloc_ag_vextent+0xbd4/0xf5e
  [<ffffffff88183aa5>] :xfs:xfs_alloc_vextent+0x2ce/0x401
  [<ffffffff88191a70>] :xfs:xfs_bmapi+0x1068/0x1c85
  [<ffffffff881c85f2>] :xfs:kmem_zone_alloc+0x56/0xa3
  [<ffffffff8819ca78>] :xfs:xfs_dir2_grow_inode+0xca/0x2d4
  [<ffffffff8819d8df>] :xfs:xfs_dir2_sf_to_block+0xad/0x5ba
  [<ffffffff881b001b>] :xfs:xfs_inode_item_init+0x1e/0x7a
  [<ffffffff881a4348>] :xfs:xfs_dir2_sf_addname+0x19d/0x4cf
  [<ffffffff8819d43e>] :xfs:xfs_dir_createname+0xc4/0x134
  [<ffffffff881c865d>] :xfs:kmem_zone_zalloc+0x1e/0x2f
  [<ffffffff881b001b>] :xfs:xfs_inode_item_init+0x1e/0x7a
  [<ffffffff881c6065>] :xfs:xfs_create+0x39d/0x5dd
  [<ffffffff881ce702>] :xfs:xfs_vn_mknod+0x1bd/0x3c8inchgower:~# strace 
-fp 7885
Process 17194 attached with 6 threads - interrupt to quit

  [<ffffffff80220a18>] __up_read+0x13/0x8a
  [<ffffffff881aa75e>] :xfs:xfs_iunlock+0x57/0x79
  [<ffffffff881c3392>] :xfs:xfs_access+0x3d/0x46
  [<ffffffff8819d112>] :xfs:xfs_dir_lookup+0xa2/0x122
  [<ffffffff8020e0c5>] link_path_walk+0xd3/0xe5
  [<ffffffff80239138>] vfs_create+0xe7/0x12c
  [<ffffffff80219430>] open_namei+0x18c/0x6a0
  [<ffffffff881cc5bb>] :xfs:xfs_file_open+0x27/0x2c
  [<ffffffff80225d1d>] do_filp_open+0x1c/0x3d
  [<ffffffff802180e0>] do_sys_open+0x44/0xc5
  [<ffffffff8025d2a2>] ia32_sysret+0x0/0xa

Filesystem "dm-1": XFS internal error xfs_trans_cancel at line 1138 of 
file fs/xfs/xfs_trans.c.  Caller 0xffffffff881c6253

Call Trace:
  [<ffffffff881bdeac>] :xfs:xfs_trans_cancel+0x5b/0xfe
  [<ffffffff881c6253>] :xfs:xfs_create+0x58b/0x5dd
  [<ffffffff881ce702>] :xfs:xfs_vn_mknod+0x1bd/0x3c8
  [<ffffffff80220a18>] __up_read+0x13/0x8a
  [<ffffffff881aa75e>] :xfs:xfs_iunlock+0x57/0x79
  [<ffffffff881c3392>] :xfs:xfs_access+0x3d/0x46
  [<ffffffff8819d112>] :xfs:xfs_dir_lookup+0xa2/0x122
  [<ffffffff8020e0c5>] link_path_walk+0xd3/0xe5
  [<ffffffff80239138>] vfs_create+0xe7/0x12c
  [<ffffffff80219430>] open_namei+0x18c/0x6a0
  [<ffffffff881cc5bb>] :xfs:xfs_file_open+0x27/0x2c
  [<ffffffff80225d1d>] do_filp_open+0x1c/0x3d
  [<ffffffff802180e0>] do_sys_open+0x44/0xc5
  [<ffffffff8025d2a2>] ia32_sysret+0x0/0xa


I've been upgrading the xfs_repair to last version available on debian 
(xfs_repair version 2.9.4)

There are lots of  errors reported
(don't have the beginning on the console)

...
data fork in ino 3628932549 claims free block 226749351
data fork in ino 3628932549 claims free block 226749352
data fork in ino 3628932549 claims free block 226749353
data fork in ino 3628932549 claims free block 226749354
data fork in ino 3628932549 claims free block 226749355
data fork in ino 3628932549 claims free block 226749356
data fork in ino 3628932549 claims free block 226749357
data fork in ino 3628932549 claims free block 226749358
data fork in ino 3628932549 claims free block 226749359
data fork in ino 3628932549 claims free block 226749360
data fork in ino 3628932549 claims free block 226749361
data fork in ino 3628932549 claims free block 226749362
data fork in ino 3628932549 claims free block 226749363
imap claims a free inode 3629547632 is in use, correcting imap and 
clearing inode
         - agno = 28
         - agno = 29
data fork in ino 3894217924 claims free block 243388605
data fork in ino 3894217924 claims free block 243388606
data fork in ino 3899211601 claims free block 243702250
data fork in ino 3899211601 claims free block 243702251
data fork in ino 3899211601 claims free block 243702252
data fork in ino 3907562994 claims free block 244222632
data fork in ino 3907562994 claims free block 244222633
data fork in ino 3907562994 claims free block 244222634
data fork in ino 3907562994 claims free block 244222635
data fork in ino 3907562994 claims free block 244222636
data fork in ino 3910289697 claims free block 244393117
data fork in ino 3910289697 claims free block 244393118
data fork in ino 3910289699 claims free block 244393113
....
and in the end :


         - agno = 31
correcting imap
correcting imap
correcting imap
correcting imap
correcting imap
         - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno = 0



)

And now the process seems stuck.
There is no activity on the san disk ;

a ps show this :

root      7885  6466  7885  0    6 1447133 5660020 6 09:55 pts/0  
00:00:19 xfs_repair -L /dev/evms/DATAXFS2
root      7885  6466 17190  0    6 1447133 5660020 6 10:16 pts/0  
00:00:00 xfs_repair -L /dev/evms/DATAXFS2
root      7885  6466 17191  0    6 1447133 5660020 6 10:16 pts/0  
00:00:00 xfs_repair -L /dev/evms/DATAXFS2
root      7885  6466 17192  0    6 1447133 5660020 6 10:16 pts/0  
00:00:00 xfs_repair -L /dev/evms/DATAXFS2
root      7885  6466 17193  0    6 1447133 5660020 6 10:16 pts/0  
00:00:00 xfs_repair -L /dev/evms/DATAXFS2
root      7885  6466 17194  0    6 1447133 5660020 6 10:16 pts/0  
00:00:00 xfs_repair -L /dev/evms/DATAXFS2


and a strace this :
inchgower:~# strace -fp 7885
Process 17194 attached with 6 threads - interrupt to quit
[pid 17191] futex(0x2aab3c8fa884, FUTEX_WAIT, 44, NULL <unfinished ...>
[pid 17192] futex(0x2aab3c8fa884, FUTEX_WAIT, 44, NULL <unfinished ...>
[pid 17193] futex(0x2aab3c8fa884, FUTEX_WAIT, 44, NULL <unfinished ...>
[pid 17194] futex(0x2aab3c8fa884, FUTEX_WAIT, 44, NULL <unfinished ...>
[pid 17190] futex(0x67e4f8, FUTEX_WAIT, 2, NULL

Can I stop the process and start another version without risking problems ?
> Could be a hardware problem. Could be an XFs problem. Coul dbe a dm problem.
> I really can't say from a shutdown message like this - all it tells us is
> that a btree block was corrupted by something since the last time it was
> checked....
>
> Cheers,
>
> Dave.
>   

OK,
cheers,

--
Yann Dupont, Cri de l'université de Nantes
Tel: 02.51.12.53.91 - Fax: 02.51.12.58.60 - Yann.Dupont@univ-nantes.fr
