Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0803daJ015503 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 18:03:40 -0600
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F0E617B8CD4
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 16:03:38 -0800 (PST)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.173]) by cuda.sgi.com with ESMTP id
	AfAA9dzZOak7w2Wl for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2009 16:03:38 -0800 (PST)
Received: by wf-out-1314.google.com with SMTP id 26so10899907wfd.32
	for <xfs@oss.sgi.com>; Wed, 07 Jan 2009 16:03:37 -0800 (PST)
Message-ID: <d96784ac0901071603o1993d988m3c74b3cf73263881@mail.gmail.com>
Date: Wed, 7 Jan 2009 17:03:37 -0700
From: "Gomel Kiev" <gomelkiev@gmail.com>
Subject: xfs error
In-Reply-To: <d96784ac0901071601q610a6be1n96ebb4ebcb289e2@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <d96784ac0901062202t42927621r196894b6b2cc9449@mail.gmail.com>
	<alpine.DEB.1.10.0901070715330.26046@p34.internal.lan>
	<d96784ac0901071055k1daa4102v29afba929a91bec7@mail.gmail.com>
	<alpine.DEB.1.10.0901071520490.19624@p34.internal.lan>
	<d96784ac0901071601q610a6be1n96ebb4ebcb289e2@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

more info:

xfs_db -V -> 2.10.2
here is output form xfs_metadump:
xfs_metadump: unexpected XFS SB magic number 0x33c08ed0
xfs_metadump: size check failed
xfs_metadump: read failed: Invalid argument
xfs_metadump: data size check failed
xfs_metadump: failed to alloc -225176656 bytes: Cannot allocate memory

dmesg:
xfs_db[5893]: segfault at 28 ip b7ec31c0 sp bfd04bcc error 4 in
libpthread-2.7.so[b7ebc000+13000]
xfs_db[5895]: segfault at 28 ip b80701c0 sp bfab217c error 4 in
libpthread-2.7.so[b8069000+13000]
xfs_db[5923]: segfault at 28 ip b80671c0 sp bffaae6c error 4 in
libpthread-2.7.so[b8060000+13000]
xfs_db[5925]: segfault at 28 ip b7ebe1c0 sp bf9ff8bc error 4 in
libpthread-2.7.so[b7eb7000+13000]
xfs_db[5928]: segfault at 28 ip b7f511c0 sp bfc92b8c error 4 in
libpthread-2.7.so[b7f4a000+13000]
xfs_db[5931]: segfault at 28 ip b80591c0 sp bfd9b48c error 4 in
libpthread-2.7.so[b8052000+13000]
xfs_db[5932]: segfault at 28 ip b7f361c0 sp bfc79b6c error 4 in
libpthread-2.7.so[b7f2f000+13000]

any ideas?
thanks for help



On Wed, Jan 7, 2009 at 1:20 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> $ dpkg -S xfs_metadump xfsprogs: /usr/sbin/xfs_metadump
> xfsprogs: /usr/share/man/man8/xfs_metadump.8.gz
>
>
> On Wed, 7 Jan 2009, Gomel Kiev wrote:
>
>> 1. xfs_repair running for 20 hours , and can not find superblock
>> 2. on my knoppix I don't have xfs_metadump.
>> where I can get it?
>> thx
>>
>>
>> On Wed, Jan 7, 2009 at 5:16 AM, Justin Piszcz <jpiszcz@lucidpixels.com>
>> wrote:
>>>
>>>
>>> On Tue, 6 Jan 2009, Gomel Kiev wrote:
>>>
>>>> Hello, here is whole story, maybe somebody can help.
>>>> hardware: buffalo linkstation + "MS2UT+B"  in mirror mode, raid1.
>>>> 2x1tb seagate drives
>>>> buffalo :
>>>> root@BUFFALO:~# uname -a
>>>> Linux BUFFALO 2.6.16.16-arm1 #9 Wed Mar 7 14:17:36 JST 2007 armv5tejl
>>>> unknown
>>>>
>>>> xfs version:
>>>> root@BUFFALO:~# xfs_info -V /mnt/usbdisk2
>>>> xfs_info version 2.5.6
>>>>
>>>> on dec 12, log show errors:
>>>> Dec 12 04:26:28 BUFFALO kernel: 0x0: 60 f2 de 8d 58 cf 08 48 46 76 56
>>>> 8f 1e 3e 78 29
>>>> Dec 12 04:26:28 BUFFALO kernel: Filesystem "sdc1": XFS internal error
>>>> xfs_da_do_buf(2) at line 2221 of file fs/xfs/xfs_da_btree.c.  Caller
>>>> 0xc011ff60
>>>> Dec 12 04:26:28 BUFFALO kernel: 0x0: 60 f2 de 8d 58 cf 08 48 46 76 56
>>>> 8f 1e 3e 78 29
>>>> Dec 12 04:26:28 BUFFALO kernel: Filesystem "sdc1": XFS internal error
>>>> xfs_da_do_buf(2) at line 2221 of file fs/xfs/xfs_da_btree.c.  Caller
>>>> 0xc011ff60
>>>> Dec 12 04:26:28 BUFFALO kernel: 0x0: 60 f2 de 8d 58 cf 08 48 46 76 56
>>>> 8f 1e 3e 78 29
>>>> Dec 12 04:26:28 BUFFALO kernel: Filesystem "sdc1": XFS internal error
>>>> xfs_da_do_buf(2) at line 2221 of file fs/xfs/xfs_da_btree.c.  Caller
>>>> 0xc011ff60
>>>> Dec 12 04:26:29 BUFFALO kernel: 0x0: 60 f2 de 8d 58 cf 08 48 46 76 56
>>>> 8f 1e 3e 78 29
>>>> Dec 12 04:26:29 BUFFALO kernel: Filesystem "sdc1": XFS internal error
>>>> xfs_da_do_buf(2) at line 2221 of file fs/xfs/xfs_da_btree.c.  Caller
>>>> 0xc011ff60
>>>>
>>>> after that , could not mount drive(any). I removed drives from
>>>> external storage and connected to Knoppix
>>>> here is info:
>>>> Linux Knoppix 2.6.19 #7 SMP PREEMPT Sun Dec 17 22:01:07 CET 2006 i686
>>>> GNU/Linux
>>>>
>>>> xfs version:
>>>> xfs_info version 2.8.11
>>>>
>>>> dmesg shows:
>>>> Starting XFS recovery on filesystem: hda (logdev: internal)
>>>> Filesystem "hda": XFS internal error xlog_valid_rec_header(1) at line
>>>> 3503 of file fs/xfs/xfs_log_recover.c.  Caller 0xd14f14d2
>>>> [<d14eeceb>] xlog_valid_rec_header+0x10f/0x14c [xfs]
>>>> [<d14f14d2>] xlog_do_recovery_pass+0x1e2/0x940 [xfs]
>>>> [<d14f14d2>] xlog_do_recovery_pass+0x1e2/0x940 [xfs]
>>>> [<d14f34a7>] xlog_recover+0xdf/0x250 [xfs]
>>>> [<d14edeca>] xfs_log_mount+0x3ce/0x5cc [xfs]
>>>> [<d14f5f81>] xfs_mountfs+0xb8d/0x106c [xfs]
>>>> [<c011cca0>] default_wake_function+0x0/0xc
>>>> [<c024c88f>] _atomic_dec_and_lock+0x3f/0x74
>>>> [<d150ecdf>] xfs_mountfs_check_barriers+0xd3/0xf4 [xfs]
>>>> [<d14fd33c>] xfs_mount+0x628/0x978 [xfs]
>>>> [<c024c7de>] __next_cpu+0x12/0x20
>>>> [<c0170e0b>] __percpu_populate_mask+0x4b/0x74
>>>> [<d14a46d4>] xfs_qm_parseargs+0x0/0x2a4 [xfs]
>>>> [<d14a48e1>] xfs_qm_parseargs+0x20d/0x2a4 [xfs]
>>>> [<d14fcd14>] xfs_mount+0x0/0x978 [xfs]
>>>> [<d150f549>] vfs_mount+0x21/0x24 [xfs]
>>>> [<d150f3a0>] xfs_fs_fill_super+0x6c/0x1c4 [xfs]
>>>> [<c0250aa7>] snprintf+0x1f/0x24
>>>> [<c01ac963>] disk_name+0xa7/0xb4
>>>> [<c017502d>] get_sb_bdev+0xed/0x124
>>>> [<d150e788>] xfs_fs_get_sb+0x20/0x28 [xfs]
>>>> [<d150f334>] xfs_fs_fill_super+0x0/0x1c4 [xfs]
>>>> [<c0174b74>] vfs_kern_mount+0xcc/0x138
>>>> [<c0174c1f>] do_kern_mount+0x27/0x44
>>>> [<c0188f55>] do_mount+0x2b9/0x6c8
>>>> [<c0188313>] mntput_no_expire+0x13/0x70
>>>> [<c017c435>] link_path_walk+0x65/0xcc
>>>> [<c02d3d74>] idedisk_release+0x3c/0x90
>>>> [<c0185541>] iput+0x35/0x68
>>>> [<c02d3d74>] idedisk_release+0x3c/0x90
>>>> [<c0187eb7>] copy_mount_options+0x2b/0x138
>>>> [<c01893dd>] sys_mount+0x79/0xb4
>>>> [<c01035cf>] syscall_call+0x7/0xb
>>>> =======================
>>>> XFS: log mount/recovery failed: error 117
>>>> XFS: log mount failed
>>>> XFS mounting filesystem hda
>>>>
>>>>
>>>> xfs_repair on knoppix running 20 hours, showing:
>>>> Phase 1 - find and verify superblock...
>>>> couldn't verify primary superblock - not enough secondary superblocks
>>>> with match                   ing geometry !!!
>>>>
>>>> attempting to find secondary superblock...
>>>>
>>>>
>>>>
>>>> Help, anybody?
>>>> I have 975gb (25 gb was empty) of multimedia files.
>>>> I tried UFS explorer, able to recover some files, but most files size
>>>> was
>>>> wrong.
>>>>
>>>> Thanks
>>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs
>>>>
>>>
>>> Looks like you have some serious corruption; however your best bet would
>>> be
>>> to boot knoppix and run xfs_repair (from the latest xfsprogs) package and
>>> report back (preferrably with a strace of xfs_repair if its hanging).  In
>>> addition, a metadump of the filesystem may be useful as well, Eric/other
>>> XFS
>>> members can analyze why the mount is failing if they have that.
>>>
>>> Justin.
>>>
>>>
>>>
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
