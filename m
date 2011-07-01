Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p614UuXr030308 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 23:30:57 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF0CE1D7EC86
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 21:30:55 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	tGbuFTsX3E6h7SOw for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2011 21:30:55 -0700 (PDT)
Received: by eyh5 with SMTP id 5so1020879eyh.26
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 21:30:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110630121918.GK561@dastard>
References: <BANLkTikhE+N3GByMKnKJU=Tn1CTYHoNRUg@mail.gmail.com>
	<20110630121918.GK561@dastard>
Date: Fri, 1 Jul 2011 10:00:54 +0530
Message-ID: <BANLkTimyhDJeuNo_L-xc=yEc_EtyH5NTVg@mail.gmail.com>
Subject: Re: XFS and USB Hang on 2.6.35.13
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 30, 2011 at 5:49 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> On Thu, Jun 30, 2011 at 04:57:42PM +0530, Amit Sahrawat wrote:
> > Hi All,
> > I encountered a hang on XFS during unplug.
> > *Test Case:*
> > #!/bin/sh
> > index=3D0
> > while [ "$?" =3D=3D 0 ]
> > do
> > =A0 =A0 =A0 =A0 index=3D$(($index+1))
> > =A0 =A0 =A0 =A0 sync
> > =A0 =A0 =A0 =A0 cp /mnt/1KB.txt /tmp/"$index".test
> > done
> > Where /mnt - mount point for vfat and /tmp mount point for XFS, both ca=
n be
> > XFS also.
> >
> > During this operation, unplug the USB. I am getting HANG almost everyti=
me I
> > unplug.
>
> Well, that's no surprise. The unplug appears to be losing IOs in
> progress.
>
> > *Kernel Version:* 2.6.35.13 (extremely sorry, I know next question will=
 be
> > why am I not using TOT kernel - I tried but my PC does not boot up with=
 the
> > latest one)
> >
> > *Target=3DARM*
> > *Logs Using Kernel Hung Task Feature*
> > # sh test.sh
> > usb 2-1: USB disconnect, address 2
> > sd 0:0:0:0: [sda] Unhandled error code
> > sd 0:0:0:0: [sda] Result: hostbyte=3D0x01 driverbyte=3D0x00
> > sd 0:0:0:0: [sda] CDB: cdb[0]=3D0x2a: 2a 00 00 40 08 01 00 00 02 00
> > end_request: I/O error, dev sda, sector 4196353
> > sd 0:0:0:0: [sda] Unhandled error code
> > sd 0:0:0:0: [sda] Result: hostbyte=3D0x01 driverbyte=3D0x00
> > sd 0:0:0:0: [sda] CDB: cdb[0]=3D0x2a: 2a 00 00 40 08 08 00 00 18 00
> > end_request: I/O error, dev sda, sector 4196360
> > end_request: I/O error, dev sda, sector 6293645
> > Device sda3, XFS metadata write error block 0x1 in sda3
> > xfs_force_shutdown(sda3,0x1) called from line 1031 of file
> > fs/xfs/xfs_buf_item.c. =A0Return address =3D 0xc0507b1c
>
> So the device was unplugged, there was a disconnect error, a few IO
> errors and then a shutdown.
>
> >
> > *INFO: task khubd:*33 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > khubd =A0 =A0 =A0 =A0 D c06c261c =A0 =A0 0 =A0 =A033 =A0 =A0 =A02 0x000=
00000
> > Backtrace:
> > [<c06c2210>] (schedule+0x0/0x500) from [<c0523f4c>]
> > (_xfs_log_force+0x230/0x284)
>
> You need to turn off line wrapping for stuff you paste into email.
> The cleaned up (i.e. relevant part) trace is:
>
> [<c06c2210>] (schedule+0x0/0x500)
> [<c0523d1c>] (_xfs_log_force+0x0/0x284)
> [<c052417c>] (xfs_log_force+0x0/0x38)
> [<c0544e94>] (xfs_sync_data+0x0/0x58)
> [<c0544f20>] (xfs_quiesce_data+0x0/0x80)
> [<c05421e4>] (xfs_fs_sync_fs+0x0/0xe0)
> [<c048fa74>] (__sync_filesystem+0x0/0xa0)
> [<c048fb88>] (sync_filesystem+0x0/0x60)
> [<c0499104>] (fsync_bdev+0x0/0x44)
> [<c056c680>] (invalidate_partition+0x0/0x3c)
> [<c04b88e0>] (del_gendisk+0x0/0x140)
> [<c05c78a0>] (sd_remove+0x0/0x84)
> [<c05b27f4>] (__device_release_driver+0x0/0xac)
> [<c05b2954>] (device_release_driver+0x0/0x30)
> [<c05b1ddc>] (bus_remove_device+0x0/0x8c)
> [<c05b02d8>] (device_del+0x0/0x170)
> [<c05c4d5c>] (__scsi_remove_device+0x0/0x90)
> [<c05c23bc>] (scsi_forget_host+0x0/0x6c)
> [<c05bc38c>] (scsi_remove_host+0x0/0x104)
> [<c0612f94>] (quiesce_and_remove_host+0x0/0x9c)
> [<c06130b4>] (usb_stor_disconnect+0x0/0x28)
> [<c0601614>] (usb_unbind_interface+0x0/0xdc)
> [<c05b27f4>] (__device_release_driver+0x0/0xac)
> [<c05b2954>] (device_release_driver+0x0/0x30)
> [<c05b1ddc>] (bus_remove_device+0x0/0x8c)
> [<c05b02d8>] (device_del+0x0/0x170)
> [<c05ff06c>] (usb_disable_device+0x0/0xf8)
> [<c05fa8e0>] (usb_disconnect+0x0/0xf4)
> [<c05fabd8>] (hub_thread+0x0/0xd78)
> [<c041e61c>] (kthread+0x0/0x8c)
>
> Well, that just looks utterly braindamaged to me.
>
> We just had the device containing the filesystem removed from the
> system, so the error handling routine ends up trying to sync the
> filesystem to the device that doesn't exist anymore. WTF?
>

>>> This is what I think, why is syncing taking place when the device doesn=
't exist anymore. What is the gain in doing so? I will try and propose this=
 feature.

> Anyway, that's not the cause of the hang, but just an example of
> someone not thinking through what their error handling actually
> does...
>
> > *INFO: task xfslogd/1*:40 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > xfslogd/1 =A0 =A0 D c06c261c =A0 =A0 0 =A0 =A040 =A0 =A0 =A02 0x00000000
> > Backtrace:
>
> [<c06c2210>] (schedule+0x0/0x500)
> [<c0523d1c>] (_xfs_log_force+0x0/0x284)
> [<c0523fa0>] (xfs_log_force_umount+0x0/0x1dc)
> [<c05374cc>] (xfs_do_force_shutdown+0x0/0x164)
> [<c05079d0>] (xfs_buf_iodone_callbacks+0x0/0x184)
> [<c053b888>] (xfs_buf_iodone_work+0x0/0x7c)
> [<c041a768>] (worker_thread+0x0/0x1e4)
> [<c041e61c>] (kthread+0x0/0x8c)
>
> That's where the shutdown has hung - only the xfslogd can complete
> the IO that will allow the log force to complete, and that is not
> occurring because it is waiting for the log force to complete before
> it can complete the IO that will complete the log force...
>
> AFAICT, this problem doesn't exist in TOT - the conversion of the
>>> Again I have a problem which seems fixed in TOT :)

> xfslogd workqueue to CMWQ allows processing of other xfslogd
> workqueue events to continue even though this one has gone to sleep.
>
> You probably need to change the shutdown type to
> SHUTDOWN_LOG_IO_ERROR to prevent a log flush from occurring in this
> shutdown context.

>>> This will fix the error for this kernel version, I will give this a try.
>>> Is this the patchwork for CMWQ: http://patchwork.xfs.org/patch/2037/ (x=
fs: improve sync behaviour in face of aggressive dirtying) ? Please let me =
know.

>
> > =A0r7:00000013 r6:c040c04c r5:c041e61c r4:dbc2decc
> > *INFO: task sync:*164 blocked for more than 120 seconds.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > sync =A0 =A0 =A0 =A0 =A0D c06c261c =A0 =A0 0 =A0 164 =A0 =A0136 0x00000=
000
> > Backtrace:
> [<c06c2210>] (schedule+0x0/0x500)
> [<c06c295c>] (schedule_timeout+0x0/0x200)
> [<c06c2000>] (wait_for_common+0x0/0x164)
> [<c06c21f4>] (wait_for_completion+0x0/0x1c)
> [<c053a6f8>] (xfs_buf_iowait+0x0/0x5c)
> [<c053ba50>] (xfs_flush_buftarg+0x0/0x180)
> [<c0544f20>] (xfs_quiesce_data+0x0/0x80)
> [<c05421e4>] (xfs_fs_sync_fs+0x0/0xe0)
> [<c048fa74>] (__sync_filesystem+0x0/0xa0)
> [<c048fb14>] (sync_one_sb+0x0/0x30)
> [<c0470c2c>] (iterate_supers+0x0/0xb8)
> [<c048fa10>] (sync_filesystems+0x0/0x2c)
> [<c048fb44>] (sys_sync+0x0/0x44)
>
> And that one is probably stuck waiting for the xfslogd to complete
> the IO.

>>>Yes, Both are waiting for signal to come.
Waiting [_xfs_log_force()][3125][Name:khubd]
end_request: I/O error, dev sda, sector 4226672
end_request: I/O error, dev sda, sector 5283400
Device sda3, XFS metadata write error block 0x1 in sda3
xfs_force_shutdown(sda3,0x1) called from line 1031 of file
fs/xfs/xfs_buf_item.c.  Return address =3D 0xc0507b1c

Waiting [_xfs_log_force()][3125][Name:xfslogd/0]


> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

Thanks & Regards,
Amit Sahrawat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
