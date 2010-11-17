Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAHAfjOx234539 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 04:41:45 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F06B189325
	for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 02:43:15 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id VNe1O8i7xEYfBbaR for
	<xfs@oss.sgi.com>; Wed, 17 Nov 2010 02:43:15 -0800 (PST)
Message-ID: <4CE3B1C0.3060308@open-e.com>
Date: Wed, 17 Nov 2010 11:43:12 +0100
From: Piotr Kandziora <piotr.kandziora@open-e.com>
MIME-Version: 1.0
Subject: Re: XFS: I/O Error Detected / 2.6.27.39
References: <4CE282DB.8060200@open-e.com>
	<20101116214415.61ecb7cd@galadriel.home>
In-Reply-To: <20101116214415.61ecb7cd@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Artur Piechocki <artur.piechocki@open-e.com>, lukasz.wittig@open-e.com, Janusz Bak <jb@open-e.com>, xfs@oss.sgi.com

Emmanuel,

Below answers for your questions.

> Le Tue, 16 Nov 2010 14:10:51 +0100 vous =E9criviez:
>
>    =

>> Hi,
>>
>> Our environment is following:
>> - we have 24GB RAM,
>> - we are using 3ware controller (and it does not report any errors),
>>      =

> What model? 9550SX? 9650SE? 9690SA? 9750 ?
>
>    =


3ware 9650SE SATA-2 RAID PCIe supported by 3w_9xxx kernel module =

(version 2.26.08.006-2.6.28)

- we have one big logical volume (20TB) exported via NFS with large
>> amount of small files (about 150k),
>> - we are doing periodically backup of this logical volume using rsync
>> to another server.
>> - we have kernel 2.6.27.39,
>>      =

> What distribution, architecture? What is the version of xfs tools
> (try xfs_info -V for instance)? What are the xfs mount options?
>
>    =

- debian based distribution with a lot of modification,
- architecture x86_64,
- xfs tools version 2.10.1
- mount options for this LV: =

rw,noatime,nodiratime,attr2,nobarrier,usrquota,prjquota,grpquota
- NFS share is exported with following options: =

rw,no_root_squash,insecure,insecure_locks,async,anonuid=3D65534,anongid=3D6=
5534,subtree_check

>> Unfortunately our system is freezing unexpectedly without reason.
>>      =

> What are the symptoms ? does the whole system freeze up? Or does it
> crash with kernel panic, or otherwise "Oops" messages?
>    =


Symptoms are different. One time we've got a few oom-killers:


[kern.warning] kernel: load_average invoked oom-killer: gfp_mask=3D0xd0, =

order=3D0, oomkilladj=3D0
[kern.emerg] kernel: Pid: 19927, comm: load_average Not tainted =

2.6.27.39-oe64-00000-g17059a5 #30
[kern.emerg] kernel:
[kern.emerg] kernel: Call Trace:
[kern.emerg] kernel: [<ffffffff80273418>] oom_kill_process+0x118/0x210
[kern.emerg] kernel: [<ffffffff802730b3>] badness+0x163/0x1e0
[kern.emerg] kernel: [<ffffffff80273926>] out_of_memory+0x1b6/0x230
[kern.emerg] kernel: [<ffffffff8027560d>] __alloc_pages_internal+0x3cd/0x430
[kern.emerg] kernel: [<ffffffff802934cd>] cache_alloc_refill+0x2bd/0x580
[kern.emerg] kernel: [<ffffffff802b59e0>] single_release+0x0/0x40
[kern.emerg] kernel: [<ffffffff80293960>] __kmalloc+0xf0/0x110
[kern.emerg] kernel: [<ffffffff802e7b4a>] stat_open+0x5a/0xc0
[kern.emerg] kernel: [<ffffffff802e066d>] proc_reg_open+0x8d/0x140
[kern.emerg] kernel: [<ffffffff802e05e0>] proc_reg_open+0x0/0x140
[kern.emerg] kernel: [<ffffffff80296038>] __dentry_open+0xb8/0x2e0
[kern.emerg] kernel: [<ffffffff80296306>] nameidata_to_filp+0x26/0x40
[kern.emerg] kernel: [<ffffffff802a1666>] do_filp_open+0x246/0x7b0
[kern.emerg] kernel: [<ffffffff802dff80>] proc_delete_inode+0x0/0x70
[kern.emerg] kernel: [<ffffffff8024a928>] wake_up_bit+0x18/0x40
[kern.emerg] kernel: [<ffffffff802afce1>] mntput_no_expire+0x21/0x120
[kern.emerg] kernel: [<ffffffff802aeccc>] alloc_fd+0x7c/0x130
[kern.emerg] kernel: [<ffffffff8029650c>] do_sys_open+0x5c/0xf0
[kern.emerg] kernel: [<ffffffff802cd4a4>] compat_sys_open+0x64/0xf0
[kern.emerg] kernel: [<ffffffff802cdff3>] compat_sys_select+0x133/0x180
[kern.emerg] kernel: [<ffffffff80228452>] ia32_sysret+0x0/0x5

[kern.warning] kernel: 3dm2 invoked oom-killer: gfp_mask=3D0xd0, order=3D0, =

oomkilladj=3D0
[kern.emerg] kernel: Pid: 18662, comm: 3dm2 Not tainted =

2.6.27.39-oe64-00000-g17059a5 #30
[kern.emerg] kernel:
[kern.emerg] kernel: Call Trace:
[kern.emerg] kernel: [<ffffffff80273418>] oom_kill_process+0x118/0x210
[kern.emerg] kernel: [<ffffffff802730b3>] badness+0x163/0x1e0
[kern.emerg] kernel: [<ffffffff80273926>] out_of_memory+0x1b6/0x230
[kern.emerg] kernel: [<ffffffff8027560d>] __alloc_pages_internal+0x3cd/0x430
[auth.info] CRON[25434]: (pam_unix) session opened for user root by (uid=3D=
0)
[kern.emerg] kernel: [<ffffffff802110dd>] dma_alloc_pages+0x1d/0x30
[kern.emerg] kernel: [<ffffffff802111f4>] dma_alloc_coherent+0x104/0x360
[kern.emerg] kernel: [<ffffffffa0091a7d>] twa_chrdev_ioctl+0x11d/0x7a0 =

[3w_9xxx]
[kern.emerg] kernel: [<ffffffff802afce1>] mntput_no_expire+0x21/0x120
[kern.emerg] kernel: [<ffffffff8022b23c>] __dequeue_entity+0x6c/0xa0
[kern.emerg] kernel: [<ffffffff8022b4b7>] set_next_entity+0x47/0x50
[kern.emerg] kernel: [<ffffffff802a4a2d>] vfs_ioctl+0x7d/0xc0
[kern.emerg] kernel: [<ffffffff8024dd70>] hrtimer_wakeup+0x0/0x30
[kern.emerg] kernel: [<ffffffff802a4afb>] do_vfs_ioctl+0x8b/0x2e0
[kern.emerg] kernel: [<ffffffff802a4de1>] sys_ioctl+0x91/0xb0
[auth.info] CRON[25132]: (pam_unix) session closed for user root
[kern.emerg] kernel: [<ffffffff8020c27b>] system_call_fastpath+0x16/0x1b

another time call-trace:

2010/11/11 10:56:21|Pid: 4324, comm: nfsd Not tainted =

2.6.27.39-oe64-00000-gc758227 #39
2010/11/11 10:56:21|
2010/11/11 10:56:21|Call Trace:
2010/11/11 10:56:21|[<ffffffff803d849b>] xfs_rename+0x28b/0x610
2010/11/11 10:56:21|[<ffffffff803da086>] xfs_trans_cancel+0x126/0x150
2010/11/11 10:56:21|[<ffffffff803d849b>] xfs_rename+0x28b/0x610
2010/11/11 10:56:21|[<ffffffff803eab2d>] xfs_vn_rename+0x7d/0xb0
2010/11/11 10:56:21|[<ffffffff8029f50b>] vfs_rename+0x41b/0x4c0
2010/11/11 10:56:21|[<ffffffff80350f94>] nfsd_rename+0x354/0x3a0
2010/11/11 10:56:21|[<ffffffff803584f3>] nfsd3_proc_rename+0xd3/0x1a0
2010/11/11 10:56:21|[<ffffffff8034a3d1>] nfsd_dispatch+0xb1/0x230
2010/11/11 10:56:21|[<ffffffff8066470a>] svc_process+0x47a/0x780
2010/11/11 10:56:21|[<ffffffff806968d2>] __down_read+0x12/0xa7
2010/11/11 10:56:21|[<ffffffff8034ab1a>] nfsd+0x17a/0x2a0
2010/11/11 10:56:21|[<ffffffff8034a9a0>] nfsd+0x0/0x2a0
2010/11/11 10:56:21|[<ffffffff802499ab>] kthread+0x4b/0x80
2010/11/11 10:56:21|[<ffffffff8020d149>] child_rip+0xa/0x11
2010/11/11 10:56:21|[<ffffffff80249960>] kthread+0x0/0x80
2010/11/11 10:56:21|[<ffffffff8020d13f>] child_rip+0x0/0x11

and after this call-trace series of messages:

Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-37,0x1) called from line 420 of file =

fs/xfs/xfs_rw.c.  Return address =3D 0xffffffff803e2c39
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-37,0x1) called from line 420 of file =

fs/xfs/xfs_rw.c.  Return address =3D 0xffffffff803e2c39
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
Filesystem "dm-37": xfs_log_force: error 5 returned.
xfs_force_shutdown(dm-37,0x1) called from line 420 of file =

fs/xfs/xfs_rw.c.  Return address =3D 0xffffffff803e2c39


> Older 3Ware cards (9550, early 9650) are prone to overheating and may
> fail.
>    =


We've checked temperature on each disk using LSI/3ware CLI (tw_cli) and =

average is 35C.

>> We
>> started investigating this problem and noticed that cache memory is
>> slowly increasing.
>>      =

> This is completely normal and expected. Linux uses up all available
> memory as a disk cache.
>
>    =

>> We tried to dump this cache memory using:
>> /bin/echo "3">  /proc/sys/vm/drop_caches
>>
>> In a result, cache was dumped, but in logs we noticed a lot of errors
>> with XFS:
>>
>> [kern.warning] kernel: xfs_iunlink_remove: xfs_inotobp()  returned an
>> error 22 on dm-16.  Returning error.
>> [kern.notice] kernel: xfs_inactive:\011xfs_ifree() returned an error
>> =3D 22 on dm-16
>> [kern.notice] kernel: xfs_force_shutdown(dm-16,0x1) called from line
>> 1406 of file fs/xfs/xfs_vnodeops.c.  Return address =3D 0x
>> [kern.alert] kernel: Filesystem \"dm-16\": I/O Error Detected.
>> Shutting down filesystem: dm-16
>> [kern.alert] kernel: Please umount the filesystem, and rectify the
>> problem(s)
>> [kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned
>> an error 5 on dm-16.  Returning error.
>> [kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned
>> an error 5 on dm-16.  Returning error.
>> [kern.warning] kernel: xfs_imap_to_bp: xfs_trans_read_buf()returned
>> an error 5 on dm-16.  Returning error.
>>
>> We are wondering if this is problem connected to hardware or rather
>> this is XFS problem (if yes, was it fixed?).
>>      =

> This may be an xfs bug but more details would be necessary.
>
>    =


This problem occurred two times in the past, we repaired fs using =

xfs_repair (and it showed errors). We simulated it using dumping cache =

yesterday ...

Best regards
Piotr K

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
