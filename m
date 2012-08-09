Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q79B176J152975 for <xfs@oss.sgi.com>; Thu, 9 Aug 2012 06:01:08 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id GgZCIKFbn13FFVFh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Aug 2012 04:01:04 -0700 (PDT)
Received: from mailsrv.i.zmi.at (mailgate.i.zmi.at [10.72.17.3])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPS id 4BAAF1822432
	for <xfs@oss.sgi.com>; Thu,  9 Aug 2012 13:01:02 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id 590AFC8C449
	for <xfs@oss.sgi.com>; Thu,  9 Aug 2012 13:01:05 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs warnings on kernel 3.2.15
Date: Thu, 09 Aug 2012 13:01:01 +0200
Message-ID: <1918987.4hlisJiio3@saturn>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4760383894900573341=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4760383894900573341==
Content-Type: multipart/signed; boundary="nextPart1664996.hmyhZlmAf9"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1664996.hmyhZlmAf9
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

I've noticed one of our postgresql servers having a high load, so I loo=
ked into it.
Kernel =3D 3.2.15, disk space is free:

# df
/dev/sda2              6281216    457888   5823328   8% /disks/work
/dev/sdc1             52402180  10135176  42267004  20% /disks/pg-db

And I got these warnings since Jul 12 until today:

Jul 12 00:31:41 db24 kernel: XFS (sda2): xlog_space_left: head behind t=
ail
Jul 12 00:31:41 db24 kernel:  tail_cycle =3D 4, tail_bytes =3D 248320
Jul 12 00:31:41 db24 kernel:  GH   cycle =3D 4, GH   bytes =3D 248312
[snip]
Aug  8 03:45:48 db24 kernel: XFS (sdc1): xlog_space_left: head behind t=
ail
Aug  8 03:45:48 db24 kernel:  tail_cycle =3D 607, tail_bytes =3D 217021=
44
Aug  8 03:45:48 db24 kernel:  GH   cycle =3D 607, GH   bytes =3D 217018=
56

And this morning it changed into warnings:

Aug  9 10:34:57 db24 kernel: INFO: task vmtoolsd:1426 blocked for more =
than 120 seconds.
Aug  9 10:34:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:34:57 db24 kernel: ffff880059e0fc78 0000000000000082 ffff8800=
59af3ba0 0000000000000001
Aug  9 10:34:57 db24 kernel: ffff880059e0e010 ffff880058ea5cc0 00000000=
00010940 ffff880059e0ffd8
Aug  9 10:34:57 db24 kernel: ffff880059e0ffd8 0000000000010940 ffff8800=
56264f80 ffff880058ea5cc0
Aug  9 10:34:57 db24 kernel: Call Trace:
Aug  9 10:34:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:34:57 db24 kernel: [<ffffffff8136fb1e>] rwsem_down_failed_com=
mon+0xe4/0x116
Aug  9 10:34:57 db24 kernel: [<ffffffff8136fb63>] rwsem_down_write_fail=
ed+0x13/0x15
Aug  9 10:34:57 db24 kernel: [<ffffffff811c4503>] call_rwsem_down_write=
_failed+0x13/0x20
Aug  9 10:34:57 db24 kernel: [<ffffffff8136f35c>] ? down_write+0x20/0x2=
2
Aug  9 10:34:57 db24 kernel: [<ffffffff810d1e44>] thaw_super+0x1c/0xae
Aug  9 10:34:57 db24 kernel: [<ffffffff810f6b5e>] thaw_bdev+0x45/0x74
Aug  9 10:34:57 db24 kernel: [<ffffffffa002019c>] VmSyncThawDevices+0x5=
6/0x9e [vmsync]
Aug  9 10:34:57 db24 kernel: [<ffffffffa0020542>] VmSyncUnlockedIoctl+0=
x1b4/0x208 [vmsync]
Aug  9 10:34:57 db24 kernel: [<ffffffff81115dd1>] proc_reg_unlocked_ioc=
tl+0x82/0xa1
Aug  9 10:34:57 db24 kernel: [<ffffffff8102c05d>] ? pick_next_task_fair=
+0xfc/0x10c
Aug  9 10:34:57 db24 kernel: [<ffffffffa002038e>] ? VmSyncAddPath+0xff/=
0xff [vmsync]
Aug  9 10:34:57 db24 kernel: [<ffffffff810dcf9f>] do_vfs_ioctl+0x3f6/0x=
47b
Aug  9 10:34:57 db24 kernel: [<ffffffff810dd066>] sys_ioctl+0x42/0x65
Aug  9 10:34:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+=
0x16/0x1b
Aug  9 10:34:57 db24 kernel: INFO: task postmaster:3112 blocked for mor=
e than 120 seconds.
Aug  9 10:34:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:34:57 db24 kernel: ffff8800563f5d18 0000000000000082 00000000=
00000000 0000000000000000
Aug  9 10:34:57 db24 kernel: ffff8800563f4010 ffff8800590d93e0 00000000=
00010940 ffff8800563f5fd8
Aug  9 10:34:57 db24 kernel: ffff8800563f5fd8 0000000000010940 ffff8800=
5ab9c240 ffff8800590d93e0
Aug  9 10:34:57 db24 kernel: Call Trace:
Aug  9 10:34:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:34:57 db24 kernel: [<ffffffff8114ed8b>] xfs_file_aio_write+0x=
118/0x224
Aug  9 10:34:57 db24 kernel: [<ffffffff8104c59a>] ? wake_up_bit+0x25/0x=
25
Aug  9 10:34:57 db24 kernel: [<ffffffff810cf526>] do_sync_write+0xc9/0x=
106
Aug  9 10:34:57 db24 kernel: [<ffffffff8100875a>] ? read_tsc+0x9/0x1b
Aug  9 10:34:57 db24 kernel: [<ffffffff810528b0>] ? timekeeping_get_ns+=
0x15/0x34
Aug  9 10:34:57 db24 kernel: [<ffffffff81053370>] ? ktime_get_ts+0x80/0=
x89
Aug  9 10:34:57 db24 kernel: [<ffffffff810dda04>] ? poll_select_copy_re=
maining+0xc6/0xea
Aug  9 10:34:57 db24 kernel: [<ffffffff810cfe57>] vfs_write+0xa9/0x105
Aug  9 10:34:57 db24 kernel: [<ffffffff810cff69>] sys_write+0x45/0x69
Aug  9 10:34:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+=
0x16/0x1b
Aug  9 10:34:57 db24 kernel: INFO: task postmaster:3115 blocked for mor=
e than 120 seconds.
Aug  9 10:34:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:34:57 db24 kernel: ffff8800563edb38 0000000000000082 00000000=
00000000 ffff880000000000
Aug  9 10:34:57 db24 kernel: ffff8800563ec010 ffff8800590dcf80 00000000=
00010940 ffff8800563edfd8
Aug  9 10:34:57 db24 kernel: ffff8800563edfd8 0000000000010940 ffff8800=
5ab9c240 ffff8800590dcf80
Aug  9 10:34:57 db24 kernel: Call Trace:
Aug  9 10:34:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:34:57 db24 kernel: [<ffffffff8118a64a>] xfs_trans_alloc+0x79/=
0xa7
Aug  9 10:34:57 db24 kernel: [<ffffffff8104c59a>] ? wake_up_bit+0x25/0x=
25
Aug  9 10:34:57 db24 kernel: [<ffffffff8115b99a>] xfs_create+0x18c/0x4c=
7
Aug  9 10:34:57 db24 kernel: [<ffffffff81150b56>] ? xfs_ilock+0x59/0x5e=

Aug  9 10:34:57 db24 kernel: [<ffffffff810df065>] ? spin_lock+0x9/0xb
Aug  9 10:34:57 db24 kernel: [<ffffffff810df877>] ? _d_rehash+0x1f/0x22=

Aug  9 10:34:57 db24 kernel: [<ffffffff811541d1>] xfs_vn_mknod+0xca/0x1=
5e
Aug  9 10:34:57 db24 kernel: [<ffffffff81154280>] xfs_vn_create+0xb/0xd=

Aug  9 10:34:57 db24 kernel: [<ffffffff810da7ad>] vfs_create+0x4e/0x6e
Aug  9 10:34:57 db24 kernel: [<ffffffff810db68c>] do_last+0x201/0x502
Aug  9 10:34:57 db24 kernel: [<ffffffff810dba61>] path_openat+0xd4/0x31=
a
Aug  9 10:34:57 db24 kernel: [<ffffffff810c13f4>] ? kmem_cache_free+0x1=
5/0x6e
Aug  9 10:34:57 db24 kernel: [<ffffffff810dbd96>] do_filp_open+0x38/0x8=
6
Aug  9 10:34:57 db24 kernel: [<ffffffff810e507a>] ? alloc_fd+0x116/0x12=
9
Aug  9 10:34:57 db24 kernel: [<ffffffff810ce147>] do_sys_open+0x6e/0x10=
7
Aug  9 10:34:57 db24 kernel: [<ffffffff810ce209>] sys_open+0x1b/0x1d
Aug  9 10:34:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+=
0x16/0x1b
Aug  9 10:34:57 db24 kernel: INFO: task flush-259:26214:19297 blocked f=
or more than 120 seconds.
Aug  9 10:34:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:34:57 db24 kernel: ffff880052039b10 0000000000000046 ffff8800=
52039aa0 ffff880047536078
Aug  9 10:34:57 db24 kernel: ffff880052038010 ffff880056263500 00000000=
00010940 ffff880052039fd8
Aug  9 10:34:57 db24 kernel: ffff880052039fd8 0000000000010940 ffff8800=
59620000 ffff880056263500
Aug  9 10:34:57 db24 kernel: Call Trace:
Aug  9 10:34:57 db24 kernel: [<ffffffff8104c605>] ? spin_unlock_irqrest=
ore+0x9/0xb
Aug  9 10:34:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:34:57 db24 kernel: [<ffffffff8118a64a>] xfs_trans_alloc+0x79/=
0xa7
Aug  9 10:34:57 db24 kernel: [<ffffffff8104c59a>] ? wake_up_bit+0x25/0x=
25
Aug  9 10:34:57 db24 kernel: [<ffffffff8109180a>] ? generic_writepages+=
0x4b/0x57
Aug  9 10:34:57 db24 kernel: [<ffffffff8115906b>] xfs_log_dirty_inode+0=
x2b/0x9f
Aug  9 10:34:57 db24 kernel: [<ffffffff8115716d>] xfs_fs_write_inode+0x=
47/0x107
Aug  9 10:34:57 db24 kernel: [<ffffffff810ec01b>] writeback_single_inod=
e+0x1b8/0x2ef
Aug  9 10:34:57 db24 kernel: [<ffffffff810ec705>] writeback_sb_inodes+0=
x168/0x201
Aug  9 10:34:57 db24 kernel: [<ffffffff810eccfe>] __writeback_inodes_wb=
+0x6d/0xab
Aug  9 10:34:57 db24 kernel: [<ffffffff810ecea6>] wb_writeback+0xf1/0x1=
8b
Aug  9 10:34:57 db24 kernel: [<ffffffff8101f406>] ? default_spin_lock_f=
lags+0x9/0xf
Aug  9 10:34:57 db24 kernel: [<ffffffff8136fbc4>] ? _raw_spin_lock_irqs=
ave+0x22/0x2b
Aug  9 10:34:57 db24 kernel: [<ffffffff810ed07f>] wb_do_writeback+0x13f=
/0x1a0
Aug  9 10:34:57 db24 kernel: [<ffffffff8103fdbe>] ? del_timer+0x81/0x81=

Aug  9 10:34:57 db24 kernel: [<ffffffff810ed170>] bdi_writeback_thread+=
0x90/0x164
Aug  9 10:34:57 db24 kernel: [<ffffffff810ed0e0>] ? wb_do_writeback+0x1=
a0/0x1a0
Aug  9 10:34:57 db24 kernel: [<ffffffff8104c17c>] kthread+0x7d/0x85
Aug  9 10:34:57 db24 kernel: [<ffffffff81371eb4>] kernel_thread_helper+=
0x4/0x10
Aug  9 10:34:57 db24 kernel: [<ffffffff8104c0ff>] ? kthread_worker_fn+0=
x153/0x153
Aug  9 10:34:57 db24 kernel: [<ffffffff81371eb0>] ? gs_change+0x13/0x13=

Aug  9 10:34:57 db24 kernel: INFO: task postmaster:26077 blocked for mo=
re than 120 seconds.
Aug  9 10:34:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:34:57 db24 kernel: ffff8800257e7d18 0000000000000086 ffffea00=
014d6680 0000000000000000
Aug  9 10:34:57 db24 kernel: ffff8800257e6010 ffff880056261a80 00000000=
00010940 ffff8800257e7fd8
Aug  9 10:34:57 db24 kernel: ffff8800257e7fd8 0000000000010940 ffffffff=
8160d020 ffff880056261a80
Aug  9 10:34:57 db24 kernel: Call Trace:
Aug  9 10:34:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:34:57 db24 kernel: [<ffffffff8114ed8b>] xfs_file_aio_write+0x=
118/0x224
Aug  9 10:34:57 db24 kernel: [<ffffffff8104c59a>] ? wake_up_bit+0x25/0x=
25
Aug  9 10:34:57 db24 kernel: [<ffffffff810cf526>] do_sync_write+0xc9/0x=
106
Aug  9 10:34:57 db24 kernel: [<ffffffff810cfe57>] vfs_write+0xa9/0x105
Aug  9 10:34:57 db24 kernel: [<ffffffff810cff69>] sys_write+0x45/0x69
Aug  9 10:34:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+=
0x16/0x1b

Aug  9 10:36:57 db24 kernel: INFO: task vmtoolsd:1426 blocked for more =
than 120 seconds.
Aug  9 10:36:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:36:57 db24 kernel: ffff880059e0fc78 0000000000000082 ffff8800=
59af3ba0 0000000000000001
Aug  9 10:36:57 db24 kernel: ffff880059e0e010 ffff880058ea5cc0 00000000=
00010940 ffff880059e0ffd8
Aug  9 10:36:57 db24 kernel: ffff880059e0ffd8 0000000000010940 ffff8800=
56264f80 ffff880058ea5cc0
Aug  9 10:36:57 db24 kernel: Call Trace:
Aug  9 10:36:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:36:57 db24 kernel: [<ffffffff8136fb1e>] rwsem_down_failed_com=
mon+0xe4/0x116
Aug  9 10:36:57 db24 kernel: [<ffffffff8136fb63>] rwsem_down_write_fail=
ed+0x13/0x15
Aug  9 10:36:57 db24 kernel: [<ffffffff811c4503>] call_rwsem_down_write=
_failed+0x13/0x20
Aug  9 10:36:57 db24 kernel: [<ffffffff8136f35c>] ? down_write+0x20/0x2=
2
Aug  9 10:36:57 db24 kernel: [<ffffffff810d1e44>] thaw_super+0x1c/0xae
Aug  9 10:36:57 db24 kernel: [<ffffffff810f6b5e>] thaw_bdev+0x45/0x74
Aug  9 10:36:57 db24 kernel: [<ffffffffa002019c>] VmSyncThawDevices+0x5=
6/0x9e [vmsync]
Aug  9 10:36:57 db24 kernel: [<ffffffffa0020542>] VmSyncUnlockedIoctl+0=
x1b4/0x208 [vmsync]
Aug  9 10:36:57 db24 kernel: [<ffffffff81115dd1>] proc_reg_unlocked_ioc=
tl+0x82/0xa1
Aug  9 10:36:57 db24 kernel: [<ffffffff8102c05d>] ? pick_next_task_fair=
+0xfc/0x10c
Aug  9 10:36:57 db24 kernel: [<ffffffffa002038e>] ? VmSyncAddPath+0xff/=
0xff [vmsync]
Aug  9 10:36:57 db24 kernel: [<ffffffff810dcf9f>] do_vfs_ioctl+0x3f6/0x=
47b
Aug  9 10:36:57 db24 kernel: [<ffffffff810dd066>] sys_ioctl+0x42/0x65
Aug  9 10:36:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+=
0x16/0x1b
Aug  9 10:36:57 db24 kernel: INFO: task postmaster:3112 blocked for mor=
e than 120 seconds.
Aug  9 10:36:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:36:57 db24 kernel: ffff8800563f5d18 0000000000000082 00000000=
00000000 0000000000000000
Aug  9 10:36:57 db24 kernel: ffff8800563f4010 ffff8800590d93e0 00000000=
00010940 ffff8800563f5fd8
Aug  9 10:36:57 db24 kernel: ffff8800563f5fd8 0000000000010940 ffff8800=
5ab9c240 ffff8800590d93e0
Aug  9 10:36:57 db24 kernel: Call Trace:
Aug  9 10:36:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:36:57 db24 kernel: [<ffffffff8114ed8b>] xfs_file_aio_write+0x=
118/0x224
Aug  9 10:36:57 db24 kernel: [<ffffffff8104c59a>] ? wake_up_bit+0x25/0x=
25
Aug  9 10:36:57 db24 kernel: [<ffffffff810cf526>] do_sync_write+0xc9/0x=
106
Aug  9 10:36:57 db24 kernel: [<ffffffff8100875a>] ? read_tsc+0x9/0x1b
Aug  9 10:36:57 db24 kernel: [<ffffffff810528b0>] ? timekeeping_get_ns+=
0x15/0x34
Aug  9 10:36:57 db24 kernel: [<ffffffff81053370>] ? ktime_get_ts+0x80/0=
x89
Aug  9 10:36:57 db24 kernel: [<ffffffff810dda04>] ? poll_select_copy_re=
maining+0xc6/0xea
Aug  9 10:36:57 db24 kernel: [<ffffffff810cfe57>] vfs_write+0xa9/0x105
Aug  9 10:36:57 db24 kernel: [<ffffffff810cff69>] sys_write+0x45/0x69
Aug  9 10:36:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+=
0x16/0x1b
Aug  9 10:36:57 db24 kernel: INFO: task postmaster:3115 blocked for mor=
e than 120 seconds.
Aug  9 10:36:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:36:57 db24 kernel: ffff8800563edb38 0000000000000082 00000000=
00000000 ffff880000000000
Aug  9 10:36:57 db24 kernel: ffff8800563ec010 ffff8800590dcf80 00000000=
00010940 ffff8800563edfd8
Aug  9 10:36:57 db24 kernel: ffff8800563edfd8 0000000000010940 ffff8800=
5ab9c240 ffff8800590dcf80
Aug  9 10:36:57 db24 kernel: Call Trace:
Aug  9 10:36:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:36:57 db24 kernel: [<ffffffff8118a64a>] xfs_trans_alloc+0x79/=
0xa7
Aug  9 10:36:57 db24 kernel: [<ffffffff8104c59a>] ? wake_up_bit+0x25/0x=
25
Aug  9 10:36:57 db24 kernel: [<ffffffff8115b99a>] xfs_create+0x18c/0x4c=
7
Aug  9 10:36:57 db24 kernel: [<ffffffff81150b56>] ? xfs_ilock+0x59/0x5e=

Aug  9 10:36:57 db24 kernel: [<ffffffff810df065>] ? spin_lock+0x9/0xb
Aug  9 10:36:57 db24 kernel: [<ffffffff810df877>] ? _d_rehash+0x1f/0x22=

Aug  9 10:36:57 db24 kernel: [<ffffffff811541d1>] xfs_vn_mknod+0xca/0x1=
5e
Aug  9 10:36:57 db24 kernel: [<ffffffff81154280>] xfs_vn_create+0xb/0xd=

Aug  9 10:36:57 db24 kernel: [<ffffffff810da7ad>] vfs_create+0x4e/0x6e
Aug  9 10:36:57 db24 kernel: [<ffffffff810db68c>] do_last+0x201/0x502
Aug  9 10:36:57 db24 kernel: [<ffffffff810dba61>] path_openat+0xd4/0x31=
a
Aug  9 10:36:57 db24 kernel: [<ffffffff810c13f4>] ? kmem_cache_free+0x1=
5/0x6e
Aug  9 10:36:57 db24 kernel: [<ffffffff810dbd96>] do_filp_open+0x38/0x8=
6
Aug  9 10:36:57 db24 kernel: [<ffffffff810e507a>] ? alloc_fd+0x116/0x12=
9
Aug  9 10:36:57 db24 kernel: [<ffffffff810ce147>] do_sys_open+0x6e/0x10=
7
Aug  9 10:36:57 db24 kernel: [<ffffffff810ce209>] sys_open+0x1b/0x1d
Aug  9 10:36:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+=
0x16/0x1b
Aug  9 10:36:57 db24 kernel: INFO: task postmaster:13762 blocked for mo=
re than 120 seconds.
Aug  9 10:36:57 db24 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeo=
ut_secs" disables this message.
Aug  9 10:36:57 db24 kernel: ffff880029025d18 0000000000000082 ffff8800=
00000000 0000000000000000
Aug  9 10:36:57 db24 kernel: ffff880029024010 ffff880056260d40 00000000=
00010940 ffff880029025fd8
Aug  9 10:36:57 db24 kernel: ffff880029025fd8 0000000000010940 ffffffff=
8160d020 ffff880056260d40
Aug  9 10:36:57 db24 kernel: Call Trace:
Aug  9 10:36:57 db24 kernel: [<ffffffff8136e926>] schedule+0x55/0x57
Aug  9 10:36:57 db24 kernel: [<ffffffff8114ed8b>] xfs_file_aio_write+0x=
118/0x224
Aug  9 10:36:57 db24 kernel: [<ffffffff8104c59a>] ? wake_up_bit+0x25/0x=
25
Aug  9 10:36:57 db24 kernel: [<ffffffff810cf526>] do_sync_write+0xc9/0x=
106
Aug  9 10:36:57 db24 kernel: [<ffffffff810cfe57>] vfs_write+0xa9/0x105
Aug  9 10:36:57 db24 kernel: [<ffffffff810cff69>] sys_write+0x45/0x69
Aug  9 10:36:57 db24 kernel: [<ffffffff813705d2>] system_call_fastpath+=
0x16/0x1b

I then tried
# echo 3 >/proc/sys/vm/drop_caches
but the system hung completely.

This is a VMware VM, and I have no idea how to send SYS-T or similar ke=
ys to it.
I had to reset it (reboot hung), and everything worked again. This VM i=
s now on kernel 3.5

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1664996.hmyhZlmAf9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAjmG0ACgkQzhSR9xwSCbR74ACgi5XCIlNHjGV96bOnkPHoIGcG
NiwAoIWcnMga1wfH6R3YuyEAsIdWxBqS
=Qn4G
-----END PGP SIGNATURE-----

--nextPart1664996.hmyhZlmAf9--


--===============4760383894900573341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4760383894900573341==--
