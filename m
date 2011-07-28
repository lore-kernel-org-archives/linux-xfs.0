Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6SAp3dA252735 for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 05:51:04 -0500
Received: from mail-vw0-f47.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0247A168886B
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:51:17 -0700 (PDT)
Received: from mail-vw0-f47.google.com (mail-vw0-f47.google.com
	[209.85.212.47]) by cuda.sgi.com with ESMTP id 5fh91ngyCcHTBxkb
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:51:17 -0700 (PDT)
Received: by vws2 with SMTP id 2so2063095vws.6
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2011 03:51:01 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 28 Jul 2011 16:21:01 +0530
Message-ID: <CAB4K4y6-2odbRhqn6q7ZDOxqF9oUcj2zKvyCEV6374QGyM-ddA@mail.gmail.com>
Subject: "xfs: fix error handling for synchronous writes" revisited
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

Just to recall, last year we have reported one hang issue in 2.6.30.9
wherein we get hang if we remove the device while synchronous write was underway
It was because synchronous buffer remain locked in case of EIO error.

In response to that a fix commit: bfc60177f8ab509bc225becbb58f7e53a0e33e81
 "xfs: fix error handling for synchronous writes" for 2.6.38 was given
by community
Unfortunately I did not use this patch and therefore did not test it.

Coming to present, I run the same test case again, and I got different
hang pasted below.
While debugging I compared with my own solution, wherein I did not
have any issue
Kindly review the solution patch

------------------------------------------------------------------------------------------------------------------------------

diff -Nurp -X linux/Documentation/dontdiff linux/fs/xfs/xfs_buf_item.c
linux-Dirty/fs/xfs/xfs_buf_item.c
--- linux/fs/xfs/xfs_buf_item.c 2011-06-09 10:05:18.000000000 +0530
+++ linux-Dirty/fs/xfs/xfs_buf_item.c   2011-07-28 15:53:51.000000000 +0530
@@ -1028,7 +1028,6 @@ xfs_buf_iodone_callbacks(
        XFS_BUF_UNDELAYWRITE(bp);

        trace_xfs_buf_error_relse(bp, _RET_IP_);
-       xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);

 do_callbacks:
        xfs_buf_do_callbacks(bp, lip);
--------------------------------------------------------------------------------------------------------------------------------


VDLinux#> ./create.sh /dtv/usb/sda3
usb 2-1: USB disconnect, address 6
sd 4:0:0:0: [sda] Unhandled error code
sd 4:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
sd 4:0:0:0: [sda] CDB: cdb[0]=0x2a: 2a 00 00 59 6e 22 00 00 18 00
end_request: I/O error, dev sda, sector 5860898
sd 4:0:0:0: [sda] Unhandled error code
sd 4:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
sd 4:0:0:0: [sda] CDB: cdb[0]=0x2a: 2a 00 00 59 72 aa 00 00 08 00
end_request: I/O error, dev sda, sector 5862058
end_request: I/O error, dev sda, sector 10764521
Device sda3, XFS metadata write error block 0x8 in sda3
xfs_force_shutdown(sda3,0x1) called from line 1031 of file
fs/xfs/xfs_buf_item.c.  Return address = 0x80134f10





INFO: task xfslogd/0:15 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfslogd/0     D 801535ec     0    15      2 0x00100000
Stack : 878f0164 878f6bf0 8034aa10 8034aa40 80382360 80021418 802a5030 8034af8c
        878f0000 80350000 00000000 87bf7700 86c86c00 00000001 87bf7700 87000780
        8030d500 8030d538 fffffffe 801535ec 803b4a80 00000000 878f0000 efffffff
        00000001 878f0000 80024254 87000780 87bb3a34 efffffff 8030d500 00000000
        87bf7700 86c86c00 00000000 fffffffc efffffff 80153840 00000000 80179600
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<801535ec>] _xfs_log_force+0x264/0x2ec
[<80153840>] xfs_log_force_umount+0x1cc/0x238
[<80169730>] xfs_do_force_shutdown+0x74/0x19c
[<80134f10>] xfs_buf_iodone_callbacks+0x158/0x190
[<8003cc8c>] worker_thread+0x170/0x24c
[<80040b98>] kthread+0x7c/0x84
[<8000a9e8>] kernel_thread_helper+0x10/0x18

INFO: task khubd:62 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D 801535ec     0    62      2 0x00100000
Stack : 874bb0a0 00000000 00000000 00000000 86c6e880 8017896c 802a5030 80350000
        878f48c0 8006a824 00000000 86c86c00 872a7a00 00000001 87bf7700 87000780
        e0382e4c 801d56fc 86c86000 801535ec 86c86c00 80178b38 80350000 80024eb4
        00000001 878f48c0 80024254 878a7da4 87000780 00000001 00000005 86c86c00
        86c86c00 872a7a00 86c86c00 80005280 00000001 801538c4 80005280 00000001
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<801535ec>] _xfs_log_force+0x264/0x2ec
[<801538c4>] xfs_log_force+0x18/0x4c
[<80178e80>] xfs_sync_data+0x4c/0x64
[<80178f08>] xfs_quiesce_data+0x2c/0x98
[<801756c0>] xfs_fs_sync_fs+0x28/0xdc
[<800c43cc>] __sync_filesystem+0x88/0xbc
[<800cf2d0>] fsync_bdev+0x28/0x64
[<8019be98>] invalidate_partition+0x28/0x50
[<800eddac>] del_gendisk+0x40/0xf8
[<801ee7ac>] sd_remove+0x38/0xc4
[<801d8058>] __device_release_driver+0x6c/0xc4
[<801d81e4>] device_release_driver+0x28/0x40
[<801d7498>] bus_remove_device+0xac/0xe0
[<801d580c>] device_del+0x110/0x170
[<801eb550>] __scsi_remove_device+0x4c/0xb4
[<801e8114>] scsi_forget_host+0x90/0xf4
[<801e0dc8>] scsi_remove_host+0xec/0x19c
[<e03c66d8>] quiesce_and_remove_host+0x94/0x138 [usb_storage]
[<e03c6874>] usb_stor_disconnect+0x2c/0x48 [usb_storage]
[<e038683c>] usb_unbind_interface+0x68/0x148 [usbcore]
[<801d8058>] __device_release_driver+0x6c/0xc4
[<801d81e4>] device_release_driver+0x28/0x40
[<801d7498>] bus_remove_device+0xac/0xe0
[<801d580c>] device_del+0x110/0x170
[<e0383204>] usb_disable_device+0xfc/0x244 [usbcore]
[<e037bc10>] usb_disconnect+0x188/0x3c4 [usbcore]
[<e037d7d0>] hub_thread+0x7ec/0x1a34 [usbcore]
[<80040b98>] kthread+0x7c/0x84
[<8000a9e8>] kernel_thread_helper+0x10/0x18

INFO: task sync:3805 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D 80005f44     0  3805   2934 0x00100000
Stack : 00000000 00000d30 87013900 87113680 00000001 00000000 802a5030 80193414
        8729da40 00000000 7fffffff 00000000 87013978 00000002 86c77e30 00000000
        0056e324 00000000 00000002 80005f44 87013900 800cc490 87013900 800cd0ac
        00000000 870133dc 00000002 00000000 00000000 8016d5f8 00000000 00000000
        00000000 00000000 00000000 80005d7c 00001000 8729da40 87013900 86c77e28
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<80005f44>] schedule_timeout+0x24/0x1f8
[<80005d7c>] wait_for_common+0xf4/0x1b0
[<8016d268>] xfs_buf_iowait+0x50/0x64
[<8016ea30>] xfs_flush_buftarg+0x178/0x1cc
[<80178f20>] xfs_quiesce_data+0x44/0x98
[<801756c0>] xfs_fs_sync_fs+0x28/0xdc
[<800c43cc>] __sync_filesystem+0x88/0xbc
[<8009faac>] iterate_supers+0x9c/0x120
[<800c42f8>] sync_filesystems+0x1c/0x28
[<800c444c>] sys_sync+0x20/0x48
[<80002164>] stack_done+0x20/0x40

INFO: task usb_mount:3850 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
usb_mount     D 80007adc     0  3850   3808 0x00100000
Stack : 00000000 800b3e08 00000000 87915ef0 87915ef0 800ab4e4 00100100 800b039c
        878f5180 800b0eac 878f5180 00000002 87915ef8 87bff800 87bff800 87915f00
        87bff818 00000000 7ff0f698 80007adc 87bff818 800236cc 00000001 800981cc
        8719c644 8719c644 878f5180 00000002 87bff800 8719c600 00000000 8009f774
        87915f00 00000000 87915f00 00000000 87915f00 800b97c4 00000000 00000000
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<80007adc>] __down_write_nested+0x110/0x134
[<8009f774>] deactivate_super+0x58/0x80
[<800b97c4>] sys_umount+0x310/0x360
[<80002164>] stack_done+0x20/0x40

INFO: task xfslogd/0:15 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfslogd/0     D 801535ec     0    15      2 0x00100000
Stack : 878f0164 878f6bf0 8034aa10 8034aa40 80382360 80021418 802a5030 8034af8c
        878f0000 80350000 00000000 87bf7700 86c86c00 00000001 87bf7700 87000780
        8030d500 8030d538 fffffffe 801535ec 803b4a80 00000000 878f0000 efffffff
        00000001 878f0000 80024254 87000780 87bb3a34 efffffff 8030d500 00000000
        87bf7700 86c86c00 00000000 fffffffc efffffff 80153840 00000000 80179600
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<801535ec>] _xfs_log_force+0x264/0x2ec
[<80153840>] xfs_log_force_umount+0x1cc/0x238
[<80169730>] xfs_do_force_shutdown+0x74/0x19c
[<80134f10>] xfs_buf_iodone_callbacks+0x158/0x190
[<8003cc8c>] worker_thread+0x170/0x24c
[<80040b98>] kthread+0x7c/0x84
[<8000a9e8>] kernel_thread_helper+0x10/0x18

INFO: task khubd:62 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
khubd         D 801535ec     0    62      2 0x00100000
Stack : 874bb0a0 00000000 00000000 00000000 86c6e880 8017896c 802a5030 80350000
        878f48c0 8006a824 00000000 86c86c00 872a7a00 00000001 87bf7700 87000780
        e0382e4c 801d56fc 86c86000 801535ec 86c86c00 80178b38 80350000 80024eb4
        00000001 878f48c0 80024254 878a7da4 87000780 00000001 00000005 86c86c00
        86c86c00 872a7a00 86c86c00 80005280 00000001 801538c4 80005280 00000001
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<801535ec>] _xfs_log_force+0x264/0x2ec
[<801538c4>] xfs_log_force+0x18/0x4c
[<80178e80>] xfs_sync_data+0x4c/0x64
[<80178f08>] xfs_quiesce_data+0x2c/0x98
[<801756c0>] xfs_fs_sync_fs+0x28/0xdc
[<800c43cc>] __sync_filesystem+0x88/0xbc
[<800cf2d0>] fsync_bdev+0x28/0x64
[<8019be98>] invalidate_partition+0x28/0x50
[<800eddac>] del_gendisk+0x40/0xf8
[<801ee7ac>] sd_remove+0x38/0xc4
[<801d8058>] __device_release_driver+0x6c/0xc4
[<801d81e4>] device_release_driver+0x28/0x40
[<801d7498>] bus_remove_device+0xac/0xe0
[<801d580c>] device_del+0x110/0x170
[<801eb550>] __scsi_remove_device+0x4c/0xb4
[<801e8114>] scsi_forget_host+0x90/0xf4
[<801e0dc8>] scsi_remove_host+0xec/0x19c
[<e03c66d8>] quiesce_and_remove_host+0x94/0x138 [usb_storage]
[<e03c6874>] usb_stor_disconnect+0x2c/0x48 [usb_storage]
[<e038683c>] usb_unbind_interface+0x68/0x148 [usbcore]
[<801d8058>] __device_release_driver+0x6c/0xc4
[<801d81e4>] device_release_driver+0x28/0x40
[<801d7498>] bus_remove_device+0xac/0xe0
[<801d580c>] device_del+0x110/0x170
[<e0383204>] usb_disable_device+0xfc/0x244 [usbcore]
[<e037bc10>] usb_disconnect+0x188/0x3c4 [usbcore]
[<e037d7d0>] hub_thread+0x7ec/0x1a34 [usbcore]
[<80040b98>] kthread+0x7c/0x84
[<8000a9e8>] kernel_thread_helper+0x10/0x18

INFO: task sync:3805 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sync          D 80005f44     0  3805   2934 0x00100000
Stack : 00000000 00000d30 87013900 87113680 00000001 00000000 802a5030 80193414
        8729da40 00000000 7fffffff 00000000 87013978 00000002 86c77e30 00000000
        0056e324 00000000 00000002 80005f44 87013900 800cc490 87013900 800cd0ac
        00000000 870133dc 00000002 00000000 00000000 8016d5f8 00000000 00000000
        00000000 00000000 00000000 80005d7c 00001000 8729da40 87013900 86c77e28
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<80005f44>] schedule_timeout+0x24/0x1f8
[<80005d7c>] wait_for_common+0xf4/0x1b0
[<8016d268>] xfs_buf_iowait+0x50/0x64
[<8016ea30>] xfs_flush_buftarg+0x178/0x1cc
[<80178f20>] xfs_quiesce_data+0x44/0x98
[<801756c0>] xfs_fs_sync_fs+0x28/0xdc
[<800c43cc>] __sync_filesystem+0x88/0xbc
[<8009faac>] iterate_supers+0x9c/0x120
[<800c42f8>] sync_filesystems+0x1c/0x28
[<800c444c>] sys_sync+0x20/0x48
[<80002164>] stack_done+0x20/0x40

INFO: task usb_mount:3850 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
usb_mount     D 80007adc     0  3850   3808 0x00100000
Stack : 00000000 800b3e08 00000000 87915ef0 87915ef0 800ab4e4 00100100 800b039c
        878f5180 800b0eac 878f5180 00000002 87915ef8 87bff800 87bff800 87915f00
        87bff818 00000000 7ff0f698 80007adc 87bff818 800236cc 00000001 800981cc
        8719c644 8719c644 878f5180 00000002 87bff800 8719c600 00000000 8009f774
        87915f00 00000000 87915f00 00000000 87915f00 800b97c4 00000000 00000000
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<80007adc>] __down_write_nested+0x110/0x134
[<8009f774>] deactivate_super+0x58/0x80
[<800b97c4>] sys_umount+0x310/0x360
[<80002164>] stack_done+0x20/0x40

INFO: task xfslogd/0:15 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
xfslogd/0     D 801535ec     0    15      2 0x00100000
Stack : 878f0164 878f6bf0 8034aa10 8034aa40 80382360 80021418 802a5030 8034af8c
        878f0000 80350000 00000000 87bf7700 86c86c00 00000001 87bf7700 87000780
        8030d500 8030d538 fffffffe 801535ec 803b4a80 00000000 878f0000 efffffff
        00000001 878f0000 80024254 87000780 87bb3a34 efffffff 8030d500 00000000
        87bf7700 86c86c00 00000000 fffffffc efffffff 80153840 00000000 80179600
        ...
Call Trace:
[<80005884>] schedule+0x4a8/0x56c
[<801535ec>] _xfs_log_force+0x264/0x2ec
[<80153840>] xfs_log_force_umount+0x1cc/0x238
[<80169730>] xfs_do_force_shutdown+0x74/0x19c
[<80134f10>] xfs_buf_iodone_callbacks+0x158/0x190
[<8003cc8c>] worker_thread+0x170/0x24c
[<80040b98>] kthread+0x7c/0x84
[<8000a9e8>] kernel_thread_helper+0x10/0x18

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
