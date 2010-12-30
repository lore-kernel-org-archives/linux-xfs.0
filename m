Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUCQYuK242784 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 06:26:35 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D092515351D2
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 04:28:37 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id Hb9W33PcCOjvGrGs
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 04:28:37 -0800 (PST)
Received: by qwe5 with SMTP id 5so12243814qwe.26
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 04:28:36 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 30 Dec 2010 17:58:36 +0530
Message-ID: <AANLkTi=Tmh9m_Rwy-bUZQEzcZ3M+6X9tZxFMO-J2Rvec@mail.gmail.com>
Subject: XFS handling of synchronous buffers in case of EIO error
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8440527182922525813=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8440527182922525813==
Content-Type: multipart/alternative; boundary=0015175cded426e1c604989fd31a

--0015175cded426e1c604989fd31a
Content-Type: text/plain; charset=ISO-8859-1

Kernel: 2.6.30.9

I am trouble shooting a hang in XFS during umount.
Test scenerio: Copy large number of files files using below script, and
remove the USB after 3-5 second

index=0
while [ "$?" == 0 ]
do
        index=$((index+1))
        sync
        cp $1/1KB.txt $2/"$index".test
done

In rare scenerio during USB unplug the umount process hang at xfs_buf_lock.
Below log shows the hung process

We have put printk to buffer handling functions xfs_buf_iodone_callbacks(),
xfs_buf_error_relse(), xfs_buf_relse() and xfs_buf_rele()

We always observed the hang only comes when bp->b_relse =
xfs_buf_error_relse(). i.e when xfs_buf_iodone_callbacks() execute
XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);
XFS_BUF_DONE(bp);
XFS_BUF_FINISH_IOWAIT(bp);

 buf its never called by xfs_buf_relse() because b_hold = 3.

Also we have seen that this problem always comes when bp->relse != NULL &&
bp->hold > 1.

I do not know whether below prints will help you, but I have taken printk
for super block buffer tracing
S-functionname ( Start of function)
E-functionname (End of function)

I think the problem is related to xfs_buf_iodone_callbacks synchronous
buffer error handling path and release buffer.
------------------------------------------------
buf_lock   (Here buffer lock success, taken after down())
S-xfs_buf_rele - 3  (Start of xfs_buf_rele(), b_hold = 3)
Call Trace:
[<8032c1bc>] dump_stack+0x8/0x34 from[<801cab2c>] xfs_buf_rele+0xc8/0x28c
[<801cab2c>] xfs_buf_rele+0xc8/0x28c from[<801cad9c>]
xfs_buf_delwri_dequeue+0xac/0x13c
[<801cad9c>] xfs_buf_delwri_dequeue+0xac/0x13c from[<801cb798>]
xfs_bwrite+0x5c/0x128
[<801cb798>] xfs_bwrite+0x5c/0x128 from[<801d5b48>]
xfs_sync_fsdata+0xbc/0x17c
[<801d5b48>] xfs_sync_fsdata+0xbc/0x17c from[<801d690c>]
xfs_quiesce_data+0x34/0x68
[<801d690c>] xfs_quiesce_data+0x34/0x68 from[<801d2b34>]
xfs_fs_sync_fs+0x30/0xec
[<801d2b34>] xfs_fs_sync_fs+0x30/0xec<7>hub 2-0:1.0: state 7 ports 1 chg
0000 evt 0002
usb 2-1: USB disconnect, address 3
 from[<800b7ff0>] sync_filesystems+0x118/0x19c
[<800b7ff0>] sync_filesystems+0x118/0x19c from[<800db490>] do_sync+0x38/0x7c
[<800db490>] do_sync+0x38/0x7c from[<800db510>] sys_sync+0x10/0x20
[<800db510>] sys_sync+0x10/0x20 from[<8000ff44>] stack_done+0x20/0x3c

E-xfs_buf_rele  (End of function)

S-xfs_bdstrat_cb
S-xfs_buf_rele - 3
S-xfs_buf_iodone_callbacks
Device sda2, XFS metadata write error block 0x0 in sda2

E-xfs_buf_iodone_callbacks
Call Trace:
[<8032c1bc>] dump_stack+0x8/0x34 from[<801cab2c>] xfs_buf_rele+0xc8/0x28c
[<801cab2c>] xfs_buf_rele+0xc8/0x28c from[<801cb2fc>]
xfs_buf_iorequest+0xe8/0x104
[<801cb2fc>] xfs_buf_iorequest+0xe8/0x104 from[<801cbd2c>]
xfs_bdstrat_cb+0x140/0x178
[<801cbd2c>] xfs_bdstrat_cb+0x140/0x178 from[<801cb7ac>]
xfs_bwrite+0x70/0x128
[<801cb7ac>] xfs_bwrite+0x70/0x128 from[<801d5b48>]
xfs_sync_fsdata+0xbc/0x17c
[<801d5b48>] xfs_sync_fsdata+0xbc/0x17c from[<801d690c>]
xfs_quiesce_data+0x34/0x68
[<801d690c>] xfs_quiesce_data+0x34/0x68 from[<801d2b34>]
xfs_fs_sync_fs+0x30/0xec
[<801d2b34>] xfs_fs_sync_fs+0x30/0xec from[<800b7ff0>]
sync_filesystems+0x118/0x19c
[<800b7ff0>] sync_filesystems+0x118/0x19c from[<800db490>] do_sync+0x38/0x7c
[<800db490>] do_sync+0x38/0x7c from[<800db510>] sys_sync+0x10/0x20
[<800db510>] sys_sync+0x10/0x20 from[<8000ff44>] stack_done+0x20/0x3c

E-xfs_buf_rele
E-xfs_bdstrat_cb
xfs_force_shutdown(sda2,0x1) called from line 1020 of file
fs/xfs/linux-2.6/xfs_buf.c.  Return address = 0x801cb7f0
Filesystem "sda2": I/O Error Detected.  Shutting down filesystem: sda2
Please umount the filesystem, and rectify the problem(s)
S-xfs_buf_relse
S-xfs_buf_rele - 2
Call Trace:
[<8032c1bc>] dump_stack+0x8/0x34 from[<801cab2c>] xfs_buf_rele+0xc8/0x28c
[<801cab2c>] xfs_buf_rele+0xc8/0x28c from[<801cb828>] xfs_bwrite+0xec/0x128
[<801cb828>] xfs_bwrite+0xec/0x128 from[<801d5b48>]
xfs_sync_fsdata+0xbc/0x17c
[<801d5b48>] xfs_sync_fsdata+0xbc/0x17c from[<801d690c>]
xfs_quiesce_data+0x34/0x68
[<801d690c>] xfs_quiesce_data+0x34/0x68 from[<801d2b34>]
xfs_fs_sync_fs+0x30/0xec
[<801d2b34>] xfs_fs_sync_fs+0x30/0xec from[<800b7ff0>]
sync_filesystems+0x118/0x19c
[<800b7ff0>] sync_filesystems+0x118/0x19c from[<800db490>] do_sync+0x38/0x7c
[<800db490>] do_sync+0x38/0x7c from[<800db510>] sys_sync+0x10/0x20
[<800db510>] sys_sync+0x10/0x20 from[<8000ff44>] stack_done+0x20/0x3c

E-xfs_buf_rele
E-xfs_buf_relse
cp: cannot stat '/dtv/usb/sda2/6.test': Input/output error
Filesystem "sda2": xfs_log_force: error 5 returned.
INFO: task khubd:56 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd            D [86a516a8] 8032cb2c     0    56      2
237      26      (kernel thread)
Stack : 00000000 801a2a6c 8643ebe0 86b43a8c 86a51830 8032cb2c 7fffffff
86a516a8
        00000002 00000001 86b6dc00 80243a10 e0364448 8032c344 e0373f10
8032cb2c
        00000087 0000000b 86b43ab8 801d61bc 3b9aca00 8032d16c 00000008
8019f0dc
        86b43a88 00008000 8643ebe0 8616d900 0000000b 00000000 00000000
86bae000
        86b43b08 801d62e0 7fffffff 86a516a8 00000002 8032e374 00000000
8008fae4
        ...
Call Trace:
[<8032ca74>] __schedule+0x618/0x6b8 from[<8032cb2c>] schedule+0x18/0x3c
[<8032cb2c>] schedule+0x18/0x3c from[<8032d16c>] schedule_timeout+0x2c/0x1c0
[<8032d16c>] schedule_timeout+0x2c/0x1c0 from[<8032e374>] __down+0x8c/0xdc
[<8032e374>] __down+0x8c/0xdc from[<8004500c>] down+0x40/0x88
[<8004500c>] down+0x40/0x88 from[<801c9c10>] xfs_buf_lock+0xcc/0x178
[<801c9c10>] xfs_buf_lock+0xcc/0x178 from[<801b6550>] xfs_getsb+0x38/0x54
[<801b6550>] xfs_getsb+0x38/0x54 from[<801d5b00>] xfs_sync_fsdata+0x74/0x17c
[<801d5b00>] xfs_sync_fsdata+0x74/0x17c from[<801d690c>]
xfs_quiesce_data+0x34/0x68
[<801d690c>] xfs_quiesce_data+0x34/0x68 from[<801d2b34>]
xfs_fs_sync_fs+0x30/0xec
[<801d2b34>] xfs_fs_sync_fs+0x30/0xec from[<800b878c>]
__fsync_super+0xa4/0xc8
[<800b878c>] __fsync_super+0xa4/0xc8 from[<800b87c4>] fsync_super+0x14/0x28
[<800b87c4>] fsync_super+0x14/0x28 from[<800e5cc4>] fsync_bdev+0x28/0x64
[<800e5cc4>] fsync_bdev+0x28/0x64 from[<801faaa8>]
invalidate_partition+0x28/0x60
[<801faaa8>] invalidate_partition+0x28/0x60 from[<801001b0>]
del_gendisk+0x40/0xf0
[<801001b0>] del_gendisk+0x40/0xf0 from[<8025cb50>] sd_remove+0x40/0xc8
[<8025cb50>] sd_remove+0x40/0xc8 from[<80259b5c>] scsi_bus_remove+0x44/0x5c
[<80259b5c>] scsi_bus_remove+0x44/0x5c from[<802463d4>]
__device_release_driver+0x80/0xbc
[<802463d4>] __device_release_driver+0x80/0xbc from[<80246540>]
device_release_driver+0x28/0x40
[<80246540>] device_release_driver+0x28/0x40 from[<802457b8>]
bus_remove_device+0xb0/0xf0
[<802457b8>] bus_remove_device+0xb0/0xf0 from[<80243b30>]
device_del+0x120/0x1a8
[<80243b30>] device_del+0x120/0x1a8 from[<80259f50>]
__scsi_remove_device+0x40/0x98
[<80259f50>] __scsi_remove_device+0x40/0x98 from[<802569cc>]
scsi_forget_host+0x88/0xfc
[<802569cc>] scsi_forget_host+0x88/0xfc from[<8024f34c>]
scsi_remove_host+0xf8/0x1ac
[<8024f34c>] scsi_remove_host+0xf8/0x1ac from[<e039d6bc>]
quiesce_and_remove_host+0x9c/0x12c [usb_storage]
[<e039d6bc>] quiesce_and_remove_host+0x9c/0x12c [usb_storage]
from[<e039d83c>] usb_stor_disconnect+0x20/0x3c [usb_storage]
[<e039d83c>] usb_stor_disconnect+0x20/0x3c [usb_storage] from[<e0367c58>]
usb_unbind_interface+0x68/0x128 [usbcore]
[<e0367c58>] usb_unbind_interface+0x68/0x128 [usbcore] from[<802463d4>]
__device_release_driver+0x80/0xbc
[<802463d4>] __device_release_driver+0x80/0xbc from[<80246540>]
device_release_driver+0x28/0x40
[<80246540>] device_release_driver+0x28/0x40 from[<802457b8>]
bus_remove_device+0xb0/0xf0
[<802457b8>] bus_remove_device+0xb0/0xf0 from[<80243b30>]
device_del+0x120/0x1a8
[<80243b30>] device_del+0x120/0x1a8 from[<e0364854>]
usb_disable_device+0x14c/0x234 [usbcore]
[<e0364854>] usb_disable_device+0x14c/0x234 [usbcore] from[<e035d6b8>]
usb_disconnect+0x170/0x37c [usbcore]
[<e035d6b8>] usb_disconnect+0x170/0x37c [usbcore] from[<e035f264>]
hub_thread+0x85c/0x18f8 [usbcore]
[<e035f264>] hub_thread+0x85c/0x18f8 [usbcore] from[<8003ff3c>]
kthread+0x5c/0xa0
[<8003ff3c>] kthread+0x5c/0xa0 from[<80008908>]
kernel_thread_helper+0x10/0x18
-------------------------------------------------------------------------------------
INFO: task usb_mount:395 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
usb_mount        D [86163ae8] 8032cb2c     0   395
371                             (user thread)
Stack : ffffff9c 86b71ef0 00400ae0 800c0150 86163c70 8032cb2c 86163ae8
00000002
        86bbbf18 86bbbf00 00000000 00000000 86b71f00 86b71ef8 7f8b0670
8032cb2c
        86bbb780 800b2510 00000001 86bbbf00 86bbbf00 8032f024 86bbbf00
800b21c0
        86bbbf00 86bbbf00 86b6dc44 86b6dc44 86163ae8 00000002 86b6dc00
86b6dc00
        803fe190 800b9350 86bbbf00 86bbbf18 86bbbef8 86bbbf00 86bbbef8
86bbbef8
        ...
Call Trace:
[<8032ca74>] __schedule+0x618/0x6b8 from[<8032cb2c>] schedule+0x18/0x3c
[<8032cb2c>] schedule+0x18/0x3c from[<8032f024>]
__down_write_nested+0x104/0x128
[<8032f024>] __down_write_nested+0x104/0x128 from[<800b9350>]
deactivate_super+0x70/0x110
[<800b9350>] deactivate_super+0x70/0x110 from[<800d122c>]
sys_umount+0x310/0x358
[<800d122c>] sys_umount+0x310/0x358 from[<8000ff44>] stack_done+0x20/0x3c
-------------------------------------------------------------------------------------
Filesystem "sda2": xfs_log_force: error 5 returned.

--0015175cded426e1c604989fd31a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Kernel: 2.6.30.9</div>
<div>=A0</div>
<div>I am trouble shooting a hang in XFS during umount.</div>
<div>Test scenerio: Copy large number of files files using below script, an=
d remove the USB after 3-5 second</div>
<div>=A0</div>
<div>index=3D0<br>while [ &quot;$?&quot; =3D=3D 0 ]<br>do<br>=A0=A0=A0=A0=
=A0=A0=A0 index=3D$((index+1))<br>=A0=A0=A0=A0=A0=A0=A0 sync<br>=A0=A0=A0=
=A0=A0=A0=A0 cp $1/1KB.txt $2/&quot;$index&quot;.test<br>done</div>
<div>=A0</div>
<div>In rare scenerio during USB unplug the umount process hang at xfs_buf_=
lock. Below log shows the hung process</div>
<div>=A0</div>
<div>We have put printk to buffer handling functions xfs_buf_iodone_callbac=
ks(), xfs_buf_error_relse(), xfs_buf_relse() and xfs_buf_rele()</div>
<div>=A0</div>
<div>We always observed the hang only comes when bp-&gt;b_relse =3D xfs_buf=
_error_relse(). i.e when xfs_buf_iodone_callbacks() execute=A0</div>
<div>XFS_BUF_SET_BRELSE_FUNC(bp,xfs_buf_error_relse);<br>XFS_BUF_DONE(bp);<=
br>XFS_BUF_FINISH_IOWAIT(bp);=A0</div>
<div>=A0</div>
<div>
<div>buf its never called=A0by xfs_buf_relse() because=A0b_hold =3D 3.</div=
>
<div>=A0</div>
<div>Also we have seen that this problem always comes when bp-&gt;relse !=
=3D NULL &amp;&amp; bp-&gt;hold &gt; 1.</div>
<div>=A0</div>
<div>I do not know whether below prints will help you, but I have taken pri=
ntk for super block buffer tracing</div>
<div>S-functionname ( Start of function)</div>
<div>E-functionname (End of function)</div>
<div>=A0</div>
<div>I think the problem is related to=A0xfs_buf_iodone_callbacks synchrono=
us buffer error handling path and release buffer.</div>
<div>------------------------------------------------</div></div>
<div>buf_lock=A0=A0 (Here buffer lock success, taken after down())<br>S-xfs=
_buf_rele - 3=A0 (Start of xfs_buf_rele(), b_hold =3D 3)</div>
<div>Call Trace:<br>[&lt;8032c1bc&gt;] dump_stack+0x8/0x34 from[&lt;801cab2=
c&gt;] xfs_buf_rele+0xc8/0x28c<br>[&lt;801cab2c&gt;] xfs_buf_rele+0xc8/0x28=
c from[&lt;801cad9c&gt;] xfs_buf_delwri_dequeue+0xac/0x13c<br>[&lt;801cad9c=
&gt;] xfs_buf_delwri_dequeue+0xac/0x13c from[&lt;801cb798&gt;] xfs_bwrite+0=
x5c/0x128<br>
[&lt;801cb798&gt;] xfs_bwrite+0x5c/0x128 from[&lt;801d5b48&gt;] xfs_sync_fs=
data+0xbc/0x17c<br>[&lt;801d5b48&gt;] xfs_sync_fsdata+0xbc/0x17c from[&lt;8=
01d690c&gt;] xfs_quiesce_data+0x34/0x68<br>[&lt;801d690c&gt;] xfs_quiesce_d=
ata+0x34/0x68 from[&lt;801d2b34&gt;] xfs_fs_sync_fs+0x30/0xec<br>
[&lt;801d2b34&gt;] xfs_fs_sync_fs+0x30/0xec&lt;7&gt;hub 2-0:1.0: state 7 po=
rts 1 chg 0000 evt 0002<br></div>
<div>usb 2-1: USB disconnect, address 3<br></div>
<div>=A0from[&lt;800b7ff0&gt;] sync_filesystems+0x118/0x19c<br>[&lt;800b7ff=
0&gt;] sync_filesystems+0x118/0x19c from[&lt;800db490&gt;] do_sync+0x38/0x7=
c<br>[&lt;800db490&gt;] do_sync+0x38/0x7c from[&lt;800db510&gt;] sys_sync+0=
x10/0x20<br>
[&lt;800db510&gt;] sys_sync+0x10/0x20 from[&lt;8000ff44&gt;] stack_done+0x2=
0/0x3c</div>
<div><br>E-xfs_buf_rele=A0 (End of function)</div>
<div>=A0 </div>
<div>S-xfs_bdstrat_cb</div>
<div>S-xfs_buf_rele - 3<br>S-xfs_buf_iodone_callbacks<br>Device sda2, XFS m=
etadata write error block 0x0 in sda2</div>
<div><br>E-xfs_buf_iodone_callbacks<br>Call Trace:<br>[&lt;8032c1bc&gt;] du=
mp_stack+0x8/0x34 from[&lt;801cab2c&gt;] xfs_buf_rele+0xc8/0x28c<br>[&lt;80=
1cab2c&gt;] xfs_buf_rele+0xc8/0x28c from[&lt;801cb2fc&gt;] xfs_buf_ioreques=
t+0xe8/0x104<br>
[&lt;801cb2fc&gt;] xfs_buf_iorequest+0xe8/0x104 from[&lt;801cbd2c&gt;] xfs_=
bdstrat_cb+0x140/0x178<br>[&lt;801cbd2c&gt;] xfs_bdstrat_cb+0x140/0x178 fro=
m[&lt;801cb7ac&gt;] xfs_bwrite+0x70/0x128<br>[&lt;801cb7ac&gt;] xfs_bwrite+=
0x70/0x128 from[&lt;801d5b48&gt;] xfs_sync_fsdata+0xbc/0x17c<br>
[&lt;801d5b48&gt;] xfs_sync_fsdata+0xbc/0x17c from[&lt;801d690c&gt;] xfs_qu=
iesce_data+0x34/0x68<br>[&lt;801d690c&gt;] xfs_quiesce_data+0x34/0x68 from[=
&lt;801d2b34&gt;] xfs_fs_sync_fs+0x30/0xec<br>[&lt;801d2b34&gt;] xfs_fs_syn=
c_fs+0x30/0xec from[&lt;800b7ff0&gt;] sync_filesystems+0x118/0x19c<br>
[&lt;800b7ff0&gt;] sync_filesystems+0x118/0x19c from[&lt;800db490&gt;] do_s=
ync+0x38/0x7c<br>[&lt;800db490&gt;] do_sync+0x38/0x7c from[&lt;800db510&gt;=
] sys_sync+0x10/0x20<br>[&lt;800db510&gt;] sys_sync+0x10/0x20 from[&lt;8000=
ff44&gt;] stack_done+0x20/0x3c</div>

<div><br>E-xfs_buf_rele<br>E-xfs_bdstrat_cb<br>xfs_force_shutdown(sda2,0x1)=
 called from line 1020 of file fs/xfs/linux-2.6/xfs_buf.c.=A0 Return addres=
s =3D 0x801cb7f0<br>Filesystem &quot;sda2&quot;: I/O Error Detected.=A0 Shu=
tting down filesystem: sda2<br>
Please umount the filesystem, and rectify the problem(s)</div>
<div>S-xfs_buf_relse<br>S-xfs_buf_rele - 2</div>
<div>Call Trace:<br>[&lt;8032c1bc&gt;] dump_stack+0x8/0x34 from[&lt;801cab2=
c&gt;] xfs_buf_rele+0xc8/0x28c<br>[&lt;801cab2c&gt;] xfs_buf_rele+0xc8/0x28=
c from[&lt;801cb828&gt;] xfs_bwrite+0xec/0x128<br>[&lt;801cb828&gt;] xfs_bw=
rite+0xec/0x128 from[&lt;801d5b48&gt;] xfs_sync_fsdata+0xbc/0x17c<br>
[&lt;801d5b48&gt;] xfs_sync_fsdata+0xbc/0x17c from[&lt;801d690c&gt;] xfs_qu=
iesce_data+0x34/0x68<br>[&lt;801d690c&gt;] xfs_quiesce_data+0x34/0x68 from[=
&lt;801d2b34&gt;] xfs_fs_sync_fs+0x30/0xec<br>[&lt;801d2b34&gt;] xfs_fs_syn=
c_fs+0x30/0xec from[&lt;800b7ff0&gt;] sync_filesystems+0x118/0x19c<br>
[&lt;800b7ff0&gt;] sync_filesystems+0x118/0x19c from[&lt;800db490&gt;] do_s=
ync+0x38/0x7c<br>[&lt;800db490&gt;] do_sync+0x38/0x7c from[&lt;800db510&gt;=
] sys_sync+0x10/0x20<br>[&lt;800db510&gt;] sys_sync+0x10/0x20 from[&lt;8000=
ff44&gt;] stack_done+0x20/0x3c</div>

<div><br>E-xfs_buf_rele<br>E-xfs_buf_relse<br>cp: cannot stat &#39;/dtv/usb=
/sda2/6.test&#39;: Input/output error<br>Filesystem &quot;sda2&quot;: xfs_l=
og_force: error 5 returned.<br>INFO: task khubd:56 blocked for more than 12=
0 seconds.<br>
&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disables th=
is message.<br>khubd=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 D [86a516a8] 8032cb2c=
=A0=A0=A0=A0 0=A0=A0=A0 56=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 237=A0=A0=A0=A0=A0 26=A0=A0=A0=A0=A0 (kernel thread)<br>Stack : 0000000=
0 801a2a6c 8643ebe0 86b43a8c 86a51830 8032cb2c 7fffffff 86a516a8<br>
=A0=A0=A0=A0=A0=A0=A0 00000002 00000001 86b6dc00 80243a10 e0364448 8032c344=
 e0373f10 8032cb2c<br>=A0=A0=A0=A0=A0=A0=A0 00000087 0000000b 86b43ab8 801d=
61bc 3b9aca00 8032d16c 00000008 8019f0dc<br>=A0=A0=A0=A0=A0=A0=A0 86b43a88 =
00008000 8643ebe0 8616d900 0000000b 00000000 00000000 86bae000<br>
=A0=A0=A0=A0=A0=A0=A0 86b43b08 801d62e0 7fffffff 86a516a8 00000002 8032e374=
 00000000 8008fae4<br>=A0=A0=A0=A0=A0=A0=A0 ...<br>Call Trace:<br>[&lt;8032=
ca74&gt;] __schedule+0x618/0x6b8 from[&lt;8032cb2c&gt;] schedule+0x18/0x3c<=
br>[&lt;8032cb2c&gt;] schedule+0x18/0x3c from[&lt;8032d16c&gt;] schedule_ti=
meout+0x2c/0x1c0<br>
[&lt;8032d16c&gt;] schedule_timeout+0x2c/0x1c0 from[&lt;8032e374&gt;] __dow=
n+0x8c/0xdc<br>[&lt;8032e374&gt;] __down+0x8c/0xdc from[&lt;8004500c&gt;] d=
own+0x40/0x88<br>[&lt;8004500c&gt;] down+0x40/0x88 from[&lt;801c9c10&gt;] x=
fs_buf_lock+0xcc/0x178<br>
[&lt;801c9c10&gt;] xfs_buf_lock+0xcc/0x178 from[&lt;801b6550&gt;] xfs_getsb=
+0x38/0x54<br>[&lt;801b6550&gt;] xfs_getsb+0x38/0x54 from[&lt;801d5b00&gt;]=
 xfs_sync_fsdata+0x74/0x17c<br>[&lt;801d5b00&gt;] xfs_sync_fsdata+0x74/0x17=
c from[&lt;801d690c&gt;] xfs_quiesce_data+0x34/0x68<br>
[&lt;801d690c&gt;] xfs_quiesce_data+0x34/0x68 from[&lt;801d2b34&gt;] xfs_fs=
_sync_fs+0x30/0xec<br>[&lt;801d2b34&gt;] xfs_fs_sync_fs+0x30/0xec from[&lt;=
800b878c&gt;] __fsync_super+0xa4/0xc8<br>[&lt;800b878c&gt;] __fsync_super+0=
xa4/0xc8 from[&lt;800b87c4&gt;] fsync_super+0x14/0x28<br>
[&lt;800b87c4&gt;] fsync_super+0x14/0x28 from[&lt;800e5cc4&gt;] fsync_bdev+=
0x28/0x64<br>[&lt;800e5cc4&gt;] fsync_bdev+0x28/0x64 from[&lt;801faaa8&gt;]=
 invalidate_partition+0x28/0x60<br>[&lt;801faaa8&gt;] invalidate_partition+=
0x28/0x60 from[&lt;801001b0&gt;] del_gendisk+0x40/0xf0<br>
[&lt;801001b0&gt;] del_gendisk+0x40/0xf0 from[&lt;8025cb50&gt;] sd_remove+0=
x40/0xc8<br>[&lt;8025cb50&gt;] sd_remove+0x40/0xc8 from[&lt;80259b5c&gt;] s=
csi_bus_remove+0x44/0x5c<br>[&lt;80259b5c&gt;] scsi_bus_remove+0x44/0x5c fr=
om[&lt;802463d4&gt;] __device_release_driver+0x80/0xbc<br>
[&lt;802463d4&gt;] __device_release_driver+0x80/0xbc from[&lt;80246540&gt;]=
 device_release_driver+0x28/0x40<br>[&lt;80246540&gt;] device_release_drive=
r+0x28/0x40 from[&lt;802457b8&gt;] bus_remove_device+0xb0/0xf0<br>[&lt;8024=
57b8&gt;] bus_remove_device+0xb0/0xf0 from[&lt;80243b30&gt;] device_del+0x1=
20/0x1a8<br>
[&lt;80243b30&gt;] device_del+0x120/0x1a8 from[&lt;80259f50&gt;] __scsi_rem=
ove_device+0x40/0x98<br>[&lt;80259f50&gt;] __scsi_remove_device+0x40/0x98 f=
rom[&lt;802569cc&gt;] scsi_forget_host+0x88/0xfc<br>[&lt;802569cc&gt;] scsi=
_forget_host+0x88/0xfc from[&lt;8024f34c&gt;] scsi_remove_host+0xf8/0x1ac<b=
r>
[&lt;8024f34c&gt;] scsi_remove_host+0xf8/0x1ac from[&lt;e039d6bc&gt;] quies=
ce_and_remove_host+0x9c/0x12c [usb_storage]<br>[&lt;e039d6bc&gt;] quiesce_a=
nd_remove_host+0x9c/0x12c [usb_storage] from[&lt;e039d83c&gt;] usb_stor_dis=
connect+0x20/0x3c [usb_storage]<br>
[&lt;e039d83c&gt;] usb_stor_disconnect+0x20/0x3c [usb_storage] from[&lt;e03=
67c58&gt;] usb_unbind_interface+0x68/0x128 [usbcore]<br>[&lt;e0367c58&gt;] =
usb_unbind_interface+0x68/0x128 [usbcore] from[&lt;802463d4&gt;] __device_r=
elease_driver+0x80/0xbc<br>
[&lt;802463d4&gt;] __device_release_driver+0x80/0xbc from[&lt;80246540&gt;]=
 device_release_driver+0x28/0x40<br>[&lt;80246540&gt;] device_release_drive=
r+0x28/0x40 from[&lt;802457b8&gt;] bus_remove_device+0xb0/0xf0<br>[&lt;8024=
57b8&gt;] bus_remove_device+0xb0/0xf0 from[&lt;80243b30&gt;] device_del+0x1=
20/0x1a8<br>
[&lt;80243b30&gt;] device_del+0x120/0x1a8 from[&lt;e0364854&gt;] usb_disabl=
e_device+0x14c/0x234 [usbcore]<br>[&lt;e0364854&gt;] usb_disable_device+0x1=
4c/0x234 [usbcore] from[&lt;e035d6b8&gt;] usb_disconnect+0x170/0x37c [usbco=
re]<br>
[&lt;e035d6b8&gt;] usb_disconnect+0x170/0x37c [usbcore] from[&lt;e035f264&g=
t;] hub_thread+0x85c/0x18f8 [usbcore]<br>[&lt;e035f264&gt;] hub_thread+0x85=
c/0x18f8 [usbcore] from[&lt;8003ff3c&gt;] kthread+0x5c/0xa0<br>[&lt;8003ff3=
c&gt;] kthread+0x5c/0xa0 from[&lt;80008908&gt;] kernel_thread_helper+0x10/0=
x18</div>

<div>----------------------------------------------------------------------=
---------------<br>INFO: task usb_mount:395 blocked for more than 120 secon=
ds.<br>&quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_secs&quot; disa=
bles this message.<br>
usb_mount=A0=A0=A0=A0=A0=A0=A0 D [86163ae8] 8032cb2c=A0=A0=A0=A0 0=A0=A0 39=
5=A0=A0=A0 371=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 (user thread)<br>Stack : ffffff9c 86b71ef0 00400ae=
0 800c0150 86163c70 8032cb2c 86163ae8 00000002<br>=A0=A0=A0=A0=A0=A0=A0 86b=
bbf18 86bbbf00 00000000 00000000 86b71f00 86b71ef8 7f8b0670 8032cb2c<br>
=A0=A0=A0=A0=A0=A0=A0 86bbb780 800b2510 00000001 86bbbf00 86bbbf00 8032f024=
 86bbbf00 800b21c0<br>=A0=A0=A0=A0=A0=A0=A0 86bbbf00 86bbbf00 86b6dc44 86b6=
dc44 86163ae8 00000002 86b6dc00 86b6dc00<br>=A0=A0=A0=A0=A0=A0=A0 803fe190 =
800b9350 86bbbf00 86bbbf18 86bbbef8 86bbbf00 86bbbef8 86bbbef8<br>
=A0=A0=A0=A0=A0=A0=A0 ...<br>Call Trace:<br>[&lt;8032ca74&gt;] __schedule+0=
x618/0x6b8 from[&lt;8032cb2c&gt;] schedule+0x18/0x3c<br>[&lt;8032cb2c&gt;] =
schedule+0x18/0x3c from[&lt;8032f024&gt;] __down_write_nested+0x104/0x128<b=
r>[&lt;8032f024&gt;] __down_write_nested+0x104/0x128 from[&lt;800b9350&gt;]=
 deactivate_super+0x70/0x110<br>
[&lt;800b9350&gt;] deactivate_super+0x70/0x110 from[&lt;800d122c&gt;] sys_u=
mount+0x310/0x358<br>[&lt;800d122c&gt;] sys_umount+0x310/0x358 from[&lt;800=
0ff44&gt;] stack_done+0x20/0x3c</div>
<div>----------------------------------------------------------------------=
---------------<br>Filesystem &quot;sda2&quot;: xfs_log_force: error 5 retu=
rned.<br></div>

--0015175cded426e1c604989fd31a--


--===============8440527182922525813==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8440527182922525813==--
