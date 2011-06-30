Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5UBRiYC207987 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 06:27:44 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72EC117837F0
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 04:27:42 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id x4mJrqq0b5PGvbOs
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 04:27:42 -0700 (PDT)
Received: by ewy8 with SMTP id 8so748993ewy.26
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 04:27:42 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Jun 2011 16:57:42 +0530
Message-ID: <BANLkTikhE+N3GByMKnKJU=Tn1CTYHoNRUg@mail.gmail.com>
Subject: XFS and USB Hang on 2.6.35.13
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1649982199159931350=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

--===============1649982199159931350==
Content-Type: multipart/alternative; boundary=00163641668771a4ac04a6ec30f7

--00163641668771a4ac04a6ec30f7
Content-Type: text/plain; charset=ISO-8859-1

Hi All,
I encountered a hang on XFS during unplug.
*Test Case:*
#!/bin/sh
index=0
while [ "$?" == 0 ]
do
        index=$(($index+1))
        sync
        cp /mnt/1KB.txt /tmp/"$index".test
done
Where /mnt - mount point for vfat and /tmp mount point for XFS, both can be
XFS also.

During this operation, unplug the USB. I am getting HANG almost everytime I
unplug.

*Kernel Version:* 2.6.35.13 (extremely sorry, I know next question will be
why am I not using TOT kernel - I tried but my PC does not boot up with the
latest one)

*Target=ARM*
*Logs Using Kernel Hung Task Feature*
# sh test.sh
usb 2-1: USB disconnect, address 2
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
sd 0:0:0:0: [sda] CDB: cdb[0]=0x2a: 2a 00 00 40 08 01 00 00 02 00
end_request: I/O error, dev sda, sector 4196353
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
sd 0:0:0:0: [sda] CDB: cdb[0]=0x2a: 2a 00 00 40 08 08 00 00 18 00
end_request: I/O error, dev sda, sector 4196360
end_request: I/O error, dev sda, sector 6293645
Device sda3, XFS metadata write error block 0x1 in sda3
xfs_force_shutdown(sda3,0x1) called from line 1031 of file
fs/xfs/xfs_buf_item.c.  Return address = 0xc0507b1c

*INFO: task khubd:*33 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D c06c261c     0    33      2 0x00000000
Backtrace:
[<c06c2210>] (schedule+0x0/0x500) from [<c0523f4c>]
(_xfs_log_force+0x230/0x284)
[<c0523d1c>] (_xfs_log_force+0x0/0x284) from [<c0524194>]
(xfs_log_force+0x18/0x38)
[<c052417c>] (xfs_log_force+0x0/0x38) from [<c0544edc>]
(xfs_sync_data+0x48/0x58)
 r4:00000001 r3:00000005
[<c0544e94>] (xfs_sync_data+0x0/0x58) from [<c0544f44>]
(xfs_quiesce_data+0x24/0x80)
 r6:dbd0dd08 r5:00000001 r4:db46e000
[<c0544f20>] (xfs_quiesce_data+0x0/0x80) from [<c0542208>]
(xfs_fs_sync_fs+0x24/0xe0)
 r6:dbd0dd08 r5:00000001 r4:db46e000 r3:c05421e4
[<c05421e4>] (xfs_fs_sync_fs+0x0/0xe0) from [<c048faf8>]
(__sync_filesystem+0x84/0xa0)
 r8:0000001f r7:db46eae0 r6:dbd0dd08 r5:00000001 r4:db470200
[<c048fa74>] (__sync_filesystem+0x0/0xa0) from [<c048fbe0>]
(sync_filesystem+0x58/0x60)
 r5:db470200 r4:db470200
[<c048fb88>] (sync_filesystem+0x0/0x60) from [<c0499124>]
(fsync_bdev+0x20/0x44)
 r4:db89e0a0 r3:00000006
[<c0499104>] (fsync_bdev+0x0/0x44) from [<c056c6a0>]
(invalidate_partition+0x20/0x3c)
 r5:dbdc1a00 r4:db89e0a0
[<c056c680>] (invalidate_partition+0x0/0x3c) from [<c04b8914>]
(del_gendisk+0x34/0x140)
 r5:dbdc1a00 r4:db470e00
[<c04b88e0>] (del_gendisk+0x0/0x140) from [<c05c78e8>] (sd_remove+0x48/0x84)
 r6:db44a5e8 r5:c07e8fc4 r4:db46e4c0
[<c05c78a0>] (sd_remove+0x0/0x84) from [<c05b2860>]
(__device_release_driver+0x6c/0xac)
 r6:60000013 r5:c07e901c r4:db46e4c0 r3:c05c78a0
[<c05b27f4>] (__device_release_driver+0x0/0xac) from [<c05b2978>]
(device_release_driver+0x24/0x30)
 r5:db46e4c0 r4:db46e4f4
[<c05b2954>] (device_release_driver+0x0/0x30) from [<c05b1e58>]
(bus_remove_device+0x7c/0x8c)
 r5:dad9d018 r4:db46e4c0
[<c05b1ddc>] (bus_remove_device+0x0/0x8c) from [<c05b03f0>]
(device_del+0x118/0x170)
 r4:db46e4c0 r3:00000000
[<c05b02d8>] (device_del+0x0/0x170) from [<c05c4da4>]
(__scsi_remove_device+0x48/0x90)
 r6:60000013 r5:db46e4c0 r4:db46e400 r3:c07e8760
[<c05c4d5c>] (__scsi_remove_device+0x0/0x90) from [<c05c2404>]
(scsi_forget_host+0x48/0x6c)
 r5:db46e400 r4:db46e800
[<c05c23bc>] (scsi_forget_host+0x0/0x6c) from [<c05bc408>]
(scsi_remove_host+0x7c/0x104)
 r5:db46e838 r4:db46e800
[<c05bc38c>] (scsi_remove_host+0x0/0x104) from [<c0612ffc>]
(quiesce_and_remove_host+0x68/0x9c)
 r6:db46ebb4 r5:db46e800 r4:db46eab8 r3:00000000
[<c0612f94>] (quiesce_and_remove_host+0x0/0x9c) from [<c06130d0>]
(usb_stor_disconnect+0x1c/0x28)
 r7:c07eb2f4 r6:db46ec00 r5:db49a200 r4:db46eab8
[<c06130b4>] (usb_stor_disconnect+0x0/0x28) from [<c0601668>]
(usb_unbind_interface+0x54/0xdc)
 r4:db49a220 r3:c06130b4
[<c0601614>] (usb_unbind_interface+0x0/0xdc) from [<c05b2860>]
(__device_release_driver+0x6c/0xac)
 r7:00000000 r6:db49a200 r5:c07eb2f4 r4:db49a220
[<c05b27f4>] (__device_release_driver+0x0/0xac) from [<c05b2978>]
(device_release_driver+0x24/0x30)
 r5:db49a220 r4:db49a254
[<c05b2954>] (device_release_driver+0x0/0x30) from [<c05b1e58>]
(bus_remove_device+0x7c/0x8c)
 r5:db46ec68 r4:db49a220
[<c05b1ddc>] (bus_remove_device+0x0/0x8c) from [<c05b03f0>]
(device_del+0x118/0x170)
 r4:db49a220 r3:00000000
[<c05b02d8>] (device_del+0x0/0x170) from [<c05ff0c4>]
(usb_disable_device+0x58/0xf8)
 r6:db49a200 r5:00000000 r4:db46ec00 r3:00000005
[<c05ff06c>] (usb_disable_device+0x0/0xf8) from [<c05fa978>]
(usb_disconnect+0x98/0xf4)
 r7:dbd70200 r6:db46ec68 r5:db46ec9c r4:db46ec00
[<c05fa8e0>] (usb_disconnect+0x0/0xf4) from [<c05fafbc>]
(hub_thread+0x3e4/0xd78)
[<c05fabd8>] (hub_thread+0x0/0xd78) from [<c041e6a0>] (kthread+0x84/0x8c)
[<c041e61c>] (kthread+0x0/0x8c) from [<c040c04c>] (do_exit+0x0/0x61c)
 r7:00000013 r6:c040c04c r5:c041e61c r4:dbc2df24
*INFO: task xfslogd/1*:40 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfslogd/1     D c06c261c     0    40      2 0x00000000
Backtrace:
[<c06c2210>] (schedule+0x0/0x500) from [<c0523f4c>]
(_xfs_log_force+0x230/0x284)
[<c0523d1c>] (_xfs_log_force+0x0/0x284) from [<c0524148>]
(xfs_log_force_umount+0x1a8/0x1dc)
[<c0523fa0>] (xfs_log_force_umount+0x0/0x1dc) from [<c053753c>]
(xfs_do_force_shutdown+0x70/0x164)
[<c05374cc>] (xfs_do_force_shutdown+0x0/0x164) from [<c0507b1c>]
(xfs_buf_iodone_callbacks+0x14c/0x184)
 r7:db469f20 r6:db46e000 r5:daf58968 r4:db445ec0
[<c05079d0>] (xfs_buf_iodone_callbacks+0x0/0x184) from [<c053b8e0>]
(xfs_buf_iodone_work+0x58/0x7c)
 r7:c0bed1d0 r6:c053b888 r5:db468000 r4:db445ec0
[<c053b888>] (xfs_buf_iodone_work+0x0/0x7c) from [<c041a8bc>]
(worker_thread+0x154/0x1e4)
 r4:c0bed1c0 r3:00000001
[<c041a768>] (worker_thread+0x0/0x1e4) from [<c041e6a0>] (kthread+0x84/0x8c)
[<c041e61c>] (kthread+0x0/0x8c) from [<c040c04c>] (do_exit+0x0/0x61c)
 r7:00000013 r6:c040c04c r5:c041e61c r4:dbc2decc
*INFO: task sync:*164 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D c06c261c     0   164    136 0x00000000
Backtrace:
[<c06c2210>] (schedule+0x0/0x500) from [<c06c297c>]
(schedule_timeout+0x20/0x200)
[<c06c295c>] (schedule_timeout+0x0/0x200) from [<c06c20d0>]
(wait_for_common+0xd0/0x164)
 r7:db44534c r6:daed4000 r5:7fffffff r4:db445348
[<c06c2000>] (wait_for_common+0x0/0x164) from [<c06c220c>]
(wait_for_completion+0x18/0x1c)
[<c06c21f4>] (wait_for_completion+0x0/0x1c) from [<c053a74c>]
(xfs_buf_iowait+0x54/0x5c)
[<c053a6f8>] (xfs_buf_iowait+0x0/0x5c) from [<c053bb9c>]
(xfs_flush_buftarg+0x14c/0x180)
 r4:db4452c0 r3:db4452ec
[<c053ba50>] (xfs_flush_buftarg+0x0/0x180) from [<c0544f5c>]
(xfs_quiesce_data+0x3c/0x80)
 r7:c048fb14 r6:00000000 r5:00000001 r4:db46e000
[<c0544f20>] (xfs_quiesce_data+0x0/0x80) from [<c0542208>]
(xfs_fs_sync_fs+0x24/0xe0)
 r6:daed5f84 r5:00000001 r4:db46e000 r3:c05421e4
[<c05421e4>] (xfs_fs_sync_fs+0x0/0xe0) from [<c048faf8>]
(__sync_filesystem+0x84/0xa0)
 r8:c0394264 r7:c048fb14 r6:daed5f84 r5:00000001 r4:db470200
[<c048fa74>] (__sync_filesystem+0x0/0xa0) from [<c048fb40>]
(sync_one_sb+0x2c/0x30)
 r5:db470240 r4:db470200
[<c048fb14>] (sync_one_sb+0x0/0x30) from [<c0470ca0>]
(iterate_supers+0x74/0xb8)
[<c0470c2c>] (iterate_supers+0x0/0xb8) from [<c048fa30>]
(sync_filesystems+0x20/0x2c)
 r7:00000024 r6:bef48db4 r5:00000001 r4:000f78be
[<c048fa10>] (sync_filesystems+0x0/0x2c) from [<c048fb68>]
(sys_sync+0x24/0x44)
[<c048fb44>] (sys_sync+0x0/0x44) from [<c03940e0>]
(ret_fast_syscall+0x0/0x30)
*On Analysis:*
I found that both the *"khubd"* and *"xfslogd"* are waiting for signal
(sv_wait() (xfs_log.c - _xfs_log_force()))
*In normal case:*
I found that xfslogd does the callback and signal that through
xlog_state_do_callback() ( sv_broadcast(&iclog->ic_force_wait) - xfs_log.c);
But during hang, xfslogd itself is waiting. So who does the callback in this
case?
Is xfslogd supposed to wait(sv_wait(&iclog->ic_force_wait, PINOD,
&log->l_icloglock, s);) ?

Please let me know in case of any issues also update if my analysis is right
or wrong. I do not expect a solution but please guide me in my findings.

Thanks & Regards,
Amit Sahrawat

--00163641668771a4ac04a6ec30f7
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<p>Hi All,</p><div>I encountered a hang on XFS during unplug.<br><strong>Te=
st Case:</strong><br>#!/bin/sh<br>index=3D0<br>while [ &quot;$?&quot; =3D=
=3D 0 ]<br>do<br>=A0=A0=A0=A0=A0=A0=A0 index=3D$(($index+1))<br>=A0=A0=A0=
=A0=A0=A0=A0 sync<br>=A0=A0=A0=A0=A0=A0=A0 cp /mnt/1KB.txt /tmp/&quot;$inde=
x&quot;.test<br>
done</div><div>Where /mnt - mount point for vfat and /tmp mount point for X=
FS, both can be XFS also.</div><p>During this operation, unplug the USB. I =
am getting HANG almost everytime I unplug.</p><p><strong>Kernel Version:</s=
trong> 2.6.35.13 (extremely sorry, I know next question will be why am I no=
t using TOT kernel - I tried but my PC does not boot up with the latest one=
)</p>
<p><strong>Target=3DARM</strong></p><div><strong>Logs Using Kernel Hung Tas=
k Feature</strong></div><div># sh test.sh <br>usb 2-1: USB disconnect, addr=
ess 2<br>sd 0:0:0:0: [sda] Unhandled error code<br>sd 0:0:0:0: [sda] Result=
: hostbyte=3D0x01 driverbyte=3D0x00<br>
sd 0:0:0:0: [sda] CDB: cdb[0]=3D0x2a: 2a 00 00 40 08 01 00 00 02 00<br>end_=
request: I/O error, dev sda, sector 4196353<br>sd 0:0:0:0: [sda] Unhandled =
error code<br>sd 0:0:0:0: [sda] Result: hostbyte=3D0x01 driverbyte=3D0x00<b=
r>
sd 0:0:0:0: [sda] CDB: cdb[0]=3D0x2a: 2a 00 00 40 08 08 00 00 18 00<br>end_=
request: I/O error, dev sda, sector 4196360<br>end_request: I/O error, dev =
sda, sector 6293645<br>Device sda3, XFS metadata write error block 0x1 in s=
da3<br>
xfs_force_shutdown(sda3,0x1) called from line 1031 of file fs/xfs/xfs_buf_i=
tem.c.=A0 Return address =3D 0xc0507b1c</div><p><strong>INFO: task khubd:</=
strong>33 blocked for more than 120 seconds.<br>&quot;echo 0 &gt; /proc/sys=
/kernel/hung_task_timeout_secs&quot; disables this message.<br>
khubd=A0=A0=A0=A0=A0=A0=A0=A0 D c06c261c=A0=A0=A0=A0 0=A0=A0=A0 33=A0=A0=A0=
=A0=A0 2 0x00000000<br>Backtrace: <br>[&lt;c06c2210&gt;] (schedule+0x0/0x50=
0) from [&lt;c0523f4c&gt;] (_xfs_log_force+0x230/0x284)<br>[&lt;c0523d1c&gt=
;] (_xfs_log_force+0x0/0x284) from [&lt;c0524194&gt;] (xfs_log_force+0x18/0=
x38)<br>
[&lt;c052417c&gt;] (xfs_log_force+0x0/0x38) from [&lt;c0544edc&gt;] (xfs_sy=
nc_data+0x48/0x58)<br>=A0r4:00000001 r3:00000005<br>[&lt;c0544e94&gt;] (xfs=
_sync_data+0x0/0x58) from [&lt;c0544f44&gt;] (xfs_quiesce_data+0x24/0x80)<b=
r>
=A0r6:dbd0dd08 r5:00000001 r4:db46e000<br>[&lt;c0544f20&gt;] (xfs_quiesce_d=
ata+0x0/0x80) from [&lt;c0542208&gt;] (xfs_fs_sync_fs+0x24/0xe0)<br>=A0r6:d=
bd0dd08 r5:00000001 r4:db46e000 r3:c05421e4<br>[&lt;c05421e4&gt;] (xfs_fs_s=
ync_fs+0x0/0xe0) from [&lt;c048faf8&gt;] (__sync_filesystem+0x84/0xa0)<br>
=A0r8:0000001f r7:db46eae0 r6:dbd0dd08 r5:00000001 r4:db470200<br>[&lt;c048=
fa74&gt;] (__sync_filesystem+0x0/0xa0) from [&lt;c048fbe0&gt;] (sync_filesy=
stem+0x58/0x60)<br>=A0r5:db470200 r4:db470200<br>[&lt;c048fb88&gt;] (sync_f=
ilesystem+0x0/0x60) from [&lt;c0499124&gt;] (fsync_bdev+0x20/0x44)<br>
=A0r4:db89e0a0 r3:00000006<br>[&lt;c0499104&gt;] (fsync_bdev+0x0/0x44) from=
 [&lt;c056c6a0&gt;] (invalidate_partition+0x20/0x3c)<br>=A0r5:dbdc1a00 r4:d=
b89e0a0<br>[&lt;c056c680&gt;] (invalidate_partition+0x0/0x3c) from [&lt;c04=
b8914&gt;] (del_gendisk+0x34/0x140)<br>
=A0r5:dbdc1a00 r4:db470e00<br>[&lt;c04b88e0&gt;] (del_gendisk+0x0/0x140) fr=
om [&lt;c05c78e8&gt;] (sd_remove+0x48/0x84)<br>=A0r6:db44a5e8 r5:c07e8fc4 r=
4:db46e4c0<br>[&lt;c05c78a0&gt;] (sd_remove+0x0/0x84) from [&lt;c05b2860&gt=
;] (__device_release_driver+0x6c/0xac)<br>
=A0r6:60000013 r5:c07e901c r4:db46e4c0 r3:c05c78a0<br>[&lt;c05b27f4&gt;] (_=
_device_release_driver+0x0/0xac) from [&lt;c05b2978&gt;] (device_release_dr=
iver+0x24/0x30)<br>=A0r5:db46e4c0 r4:db46e4f4<br>[&lt;c05b2954&gt;] (device=
_release_driver+0x0/0x30) from [&lt;c05b1e58&gt;] (bus_remove_device+0x7c/0=
x8c)<br>
=A0r5:dad9d018 r4:db46e4c0<br>[&lt;c05b1ddc&gt;] (bus_remove_device+0x0/0x8=
c) from [&lt;c05b03f0&gt;] (device_del+0x118/0x170)<br>=A0r4:db46e4c0 r3:00=
000000<br>[&lt;c05b02d8&gt;] (device_del+0x0/0x170) from [&lt;c05c4da4&gt;]=
 (__scsi_remove_device+0x48/0x90)<br>
=A0r6:60000013 r5:db46e4c0 r4:db46e400 r3:c07e8760<br>[&lt;c05c4d5c&gt;] (_=
_scsi_remove_device+0x0/0x90) from [&lt;c05c2404&gt;] (scsi_forget_host+0x4=
8/0x6c)<br>=A0r5:db46e400 r4:db46e800<br>[&lt;c05c23bc&gt;] (scsi_forget_ho=
st+0x0/0x6c) from [&lt;c05bc408&gt;] (scsi_remove_host+0x7c/0x104)<br>
=A0r5:db46e838 r4:db46e800<br>[&lt;c05bc38c&gt;] (scsi_remove_host+0x0/0x10=
4) from [&lt;c0612ffc&gt;] (quiesce_and_remove_host+0x68/0x9c)<br>=A0r6:db4=
6ebb4 r5:db46e800 r4:db46eab8 r3:00000000<br>[&lt;c0612f94&gt;] (quiesce_an=
d_remove_host+0x0/0x9c) from [&lt;c06130d0&gt;] (usb_stor_disconnect+0x1c/0=
x28)<br>
=A0r7:c07eb2f4 r6:db46ec00 r5:db49a200 r4:db46eab8<br>[&lt;c06130b4&gt;] (u=
sb_stor_disconnect+0x0/0x28) from [&lt;c0601668&gt;] (usb_unbind_interface+=
0x54/0xdc)<br>=A0r4:db49a220 r3:c06130b4<br>[&lt;c0601614&gt;] (usb_unbind_=
interface+0x0/0xdc) from [&lt;c05b2860&gt;] (__device_release_driver+0x6c/0=
xac)<br>
=A0r7:00000000 r6:db49a200 r5:c07eb2f4 r4:db49a220<br>[&lt;c05b27f4&gt;] (_=
_device_release_driver+0x0/0xac) from [&lt;c05b2978&gt;] (device_release_dr=
iver+0x24/0x30)<br>=A0r5:db49a220 r4:db49a254<br>[&lt;c05b2954&gt;] (device=
_release_driver+0x0/0x30) from [&lt;c05b1e58&gt;] (bus_remove_device+0x7c/0=
x8c)<br>
=A0r5:db46ec68 r4:db49a220<br>[&lt;c05b1ddc&gt;] (bus_remove_device+0x0/0x8=
c) from [&lt;c05b03f0&gt;] (device_del+0x118/0x170)<br>=A0r4:db49a220 r3:00=
000000<br>[&lt;c05b02d8&gt;] (device_del+0x0/0x170) from [&lt;c05ff0c4&gt;]=
 (usb_disable_device+0x58/0xf8)<br>
=A0r6:db49a200 r5:00000000 r4:db46ec00 r3:00000005<br>[&lt;c05ff06c&gt;] (u=
sb_disable_device+0x0/0xf8) from [&lt;c05fa978&gt;] (usb_disconnect+0x98/0x=
f4)<br>=A0r7:dbd70200 r6:db46ec68 r5:db46ec9c r4:db46ec00<br>[&lt;c05fa8e0&=
gt;] (usb_disconnect+0x0/0xf4) from [&lt;c05fafbc&gt;] (hub_thread+0x3e4/0x=
d78)<br>
[&lt;c05fabd8&gt;] (hub_thread+0x0/0xd78) from [&lt;c041e6a0&gt;] (kthread+=
0x84/0x8c)<br>[&lt;c041e61c&gt;] (kthread+0x0/0x8c) from [&lt;c040c04c&gt;]=
 (do_exit+0x0/0x61c)<br>=A0r7:00000013 r6:c040c04c r5:c041e61c r4:dbc2df24<=
br>
<strong>INFO: task xfslogd/1</strong>:40 blocked for more than 120 seconds.=
<br>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disable=
s this message.<br>xfslogd/1=A0=A0=A0=A0 D c06c261c=A0=A0=A0=A0 0=A0=A0=A0 =
40=A0=A0=A0=A0=A0 2 0x00000000<br>
Backtrace: <br>[&lt;c06c2210&gt;] (schedule+0x0/0x500) from [&lt;c0523f4c&g=
t;] (_xfs_log_force+0x230/0x284)<br>[&lt;c0523d1c&gt;] (_xfs_log_force+0x0/=
0x284) from [&lt;c0524148&gt;] (xfs_log_force_umount+0x1a8/0x1dc)<br>[&lt;c=
0523fa0&gt;] (xfs_log_force_umount+0x0/0x1dc) from [&lt;c053753c&gt;] (xfs_=
do_force_shutdown+0x70/0x164)<br>
[&lt;c05374cc&gt;] (xfs_do_force_shutdown+0x0/0x164) from [&lt;c0507b1c&gt;=
] (xfs_buf_iodone_callbacks+0x14c/0x184)<br>=A0r7:db469f20 r6:db46e000 r5:d=
af58968 r4:db445ec0<br>[&lt;c05079d0&gt;] (xfs_buf_iodone_callbacks+0x0/0x1=
84) from [&lt;c053b8e0&gt;] (xfs_buf_iodone_work+0x58/0x7c)<br>
=A0r7:c0bed1d0 r6:c053b888 r5:db468000 r4:db445ec0<br>[&lt;c053b888&gt;] (x=
fs_buf_iodone_work+0x0/0x7c) from [&lt;c041a8bc&gt;] (worker_thread+0x154/0=
x1e4)<br>=A0r4:c0bed1c0 r3:00000001<br>[&lt;c041a768&gt;] (worker_thread+0x=
0/0x1e4) from [&lt;c041e6a0&gt;] (kthread+0x84/0x8c)<br>
[&lt;c041e61c&gt;] (kthread+0x0/0x8c) from [&lt;c040c04c&gt;] (do_exit+0x0/=
0x61c)<br>=A0r7:00000013 r6:c040c04c r5:c041e61c r4:dbc2decc<br><strong>INF=
O: task sync:</strong>164 blocked for more than 120 seconds.<br>&quot;echo =
0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables this message.=
<br>
sync=A0=A0=A0=A0=A0=A0=A0=A0=A0 D c06c261c=A0=A0=A0=A0 0=A0=A0 164=A0=A0=A0=
 136 0x00000000<br>Backtrace: <br>[&lt;c06c2210&gt;] (schedule+0x0/0x500) f=
rom [&lt;c06c297c&gt;] (schedule_timeout+0x20/0x200)<br>[&lt;c06c295c&gt;] =
(schedule_timeout+0x0/0x200) from [&lt;c06c20d0&gt;] (wait_for_common+0xd0/=
0x164)<br>
=A0r7:db44534c r6:daed4000 r5:7fffffff r4:db445348<br>[&lt;c06c2000&gt;] (w=
ait_for_common+0x0/0x164) from [&lt;c06c220c&gt;] (wait_for_completion+0x18=
/0x1c)<br>[&lt;c06c21f4&gt;] (wait_for_completion+0x0/0x1c) from [&lt;c053a=
74c&gt;] (xfs_buf_iowait+0x54/0x5c)<br>
[&lt;c053a6f8&gt;] (xfs_buf_iowait+0x0/0x5c) from [&lt;c053bb9c&gt;] (xfs_f=
lush_buftarg+0x14c/0x180)<br>=A0r4:db4452c0 r3:db4452ec<br>[&lt;c053ba50&gt=
;] (xfs_flush_buftarg+0x0/0x180) from [&lt;c0544f5c&gt;] (xfs_quiesce_data+=
0x3c/0x80)<br>
=A0r7:c048fb14 r6:00000000 r5:00000001 r4:db46e000<br>[&lt;c0544f20&gt;] (x=
fs_quiesce_data+0x0/0x80) from [&lt;c0542208&gt;] (xfs_fs_sync_fs+0x24/0xe0=
)<br>=A0r6:daed5f84 r5:00000001 r4:db46e000 r3:c05421e4<br>[&lt;c05421e4&gt=
;] (xfs_fs_sync_fs+0x0/0xe0) from [&lt;c048faf8&gt;] (__sync_filesystem+0x8=
4/0xa0)<br>
=A0r8:c0394264 r7:c048fb14 r6:daed5f84 r5:00000001 r4:db470200<br>[&lt;c048=
fa74&gt;] (__sync_filesystem+0x0/0xa0) from [&lt;c048fb40&gt;] (sync_one_sb=
+0x2c/0x30)<br>=A0r5:db470240 r4:db470200<br>[&lt;c048fb14&gt;] (sync_one_s=
b+0x0/0x30) from [&lt;c0470ca0&gt;] (iterate_supers+0x74/0xb8)<br>
[&lt;c0470c2c&gt;] (iterate_supers+0x0/0xb8) from [&lt;c048fa30&gt;] (sync_=
filesystems+0x20/0x2c)<br>=A0r7:00000024 r6:bef48db4 r5:00000001 r4:000f78b=
e<br>[&lt;c048fa10&gt;] (sync_filesystems+0x0/0x2c) from [&lt;c048fb68&gt;]=
 (sys_sync+0x24/0x44)<br>
[&lt;c048fb44&gt;] (sys_sync+0x0/0x44) from [&lt;c03940e0&gt;] (ret_fast_sy=
scall+0x0/0x30)</p><div><strong>On Analysis:</strong></div><div>I found tha=
t both the <strong>&quot;khubd&quot;</strong> and <strong>&quot;xfslogd&quo=
t;</strong> are waiting for signal (sv_wait() (xfs_log.c - _xfs_log_force()=
))<br>
<strong>In normal case:</strong><br>I found that xfslogd does the callback =
and signal that through xlog_state_do_callback() ( sv_broadcast(&amp;iclog-=
&gt;ic_force_wait) - xfs_log.c);<br>But during hang, xfslogd itself is wait=
ing. So who does the callback in this case?<br>
Is xfslogd supposed to wait(sv_wait(&amp;iclog-&gt;ic_force_wait, PINOD, &a=
mp;log-&gt;l_icloglock, s);) ?</div><p>Please let me know in case of any is=
sues also update if my analysis is right or wrong. I do not expect a soluti=
on but please guide me in my findings.</p>
<p>Thanks &amp; Regards,<br>Amit Sahrawat<br></p>

--00163641668771a4ac04a6ec30f7--


--===============1649982199159931350==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1649982199159931350==--
