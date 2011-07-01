Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6193exr054576 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:03:40 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1459BB29A9A
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:03:38 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XN7mHnGrNNqw01kZ for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:03:38 -0700 (PDT)
Date: Fri, 1 Jul 2011 19:03:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS and USB Hang on 2.6.35.13
Message-ID: <20110701090332.GO561@dastard>
References: <BANLkTikhE+N3GByMKnKJU=Tn1CTYHoNRUg@mail.gmail.com>
	<20110630121918.GK561@dastard>
	<BANLkTimyhDJeuNo_L-xc=yEc_EtyH5NTVg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTimyhDJeuNo_L-xc=yEc_EtyH5NTVg@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 01, 2011 at 10:00:54AM +0530, Amit Sahrawat wrote:
> On Thu, Jun 30, 2011 at 5:49 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Jun 30, 2011 at 04:57:42PM +0530, Amit Sahrawat wrote:
> > > Hi All,
> > > I encountered a hang on XFS during unplug.
> > > *Test Case:*
> > > #!/bin/sh
> > > index=3D0
> > > while [ "$?" =3D=3D 0 ]
> > > do
> > > =A0 =A0 =A0 =A0 index=3D$(($index+1))
> > > =A0 =A0 =A0 =A0 sync
> > > =A0 =A0 =A0 =A0 cp /mnt/1KB.txt /tmp/"$index".test
> > > done
> > > Where /mnt - mount point for vfat and /tmp mount point for XFS, both =
can be
> > > XFS also.
> > >
> > > During this operation, unplug the USB. I am getting HANG almost every=
time I
> > > unplug.
> >
> > Well, that's no surprise. The unplug appears to be losing IOs in
> > progress.
> >
> > > *Kernel Version:* 2.6.35.13 (extremely sorry, I know next question wi=
ll be
> > > why am I not using TOT kernel - I tried but my PC does not boot up wi=
th the
> > > latest one)
.....
> > > *INFO: task khubd:*33 blocked for more than 120 seconds.
> > > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this mess=
age.
> > > khubd =A0 =A0 =A0 =A0 D c06c261c =A0 =A0 0 =A0 =A033 =A0 =A0 =A02 0x0=
0000000
> > > Backtrace:
> > > [<c06c2210>] (schedule+0x0/0x500) from [<c0523f4c>]
> > > (_xfs_log_force+0x230/0x284)
> >
> > You need to turn off line wrapping for stuff you paste into email.
> > The cleaned up (i.e. relevant part) trace is:
> >
> > [<c06c2210>] (schedule+0x0/0x500)
> > [<c0523d1c>] (_xfs_log_force+0x0/0x284)
> > [<c052417c>] (xfs_log_force+0x0/0x38)
> > [<c0544e94>] (xfs_sync_data+0x0/0x58)
> > [<c0544f20>] (xfs_quiesce_data+0x0/0x80)
> > [<c05421e4>] (xfs_fs_sync_fs+0x0/0xe0)
> > [<c048fa74>] (__sync_filesystem+0x0/0xa0)
> > [<c048fb88>] (sync_filesystem+0x0/0x60)
> > [<c0499104>] (fsync_bdev+0x0/0x44)
> > [<c056c680>] (invalidate_partition+0x0/0x3c)
> > [<c04b88e0>] (del_gendisk+0x0/0x140)
> > [<c05c78a0>] (sd_remove+0x0/0x84)
> > [<c05b27f4>] (__device_release_driver+0x0/0xac)
> > [<c05b2954>] (device_release_driver+0x0/0x30)
> > [<c05b1ddc>] (bus_remove_device+0x0/0x8c)
> > [<c05b02d8>] (device_del+0x0/0x170)
> > [<c05c4d5c>] (__scsi_remove_device+0x0/0x90)
> > [<c05c23bc>] (scsi_forget_host+0x0/0x6c)
> > [<c05bc38c>] (scsi_remove_host+0x0/0x104)
> > [<c0612f94>] (quiesce_and_remove_host+0x0/0x9c)
> > [<c06130b4>] (usb_stor_disconnect+0x0/0x28)
> > [<c0601614>] (usb_unbind_interface+0x0/0xdc)
> > [<c05b27f4>] (__device_release_driver+0x0/0xac)
> > [<c05b2954>] (device_release_driver+0x0/0x30)
> > [<c05b1ddc>] (bus_remove_device+0x0/0x8c)
> > [<c05b02d8>] (device_del+0x0/0x170)
> > [<c05ff06c>] (usb_disable_device+0x0/0xf8)
> > [<c05fa8e0>] (usb_disconnect+0x0/0xf4)
> > [<c05fabd8>] (hub_thread+0x0/0xd78)
> > [<c041e61c>] (kthread+0x0/0x8c)
> >
> > Well, that just looks utterly braindamaged to me.
> >
> > We just had the device containing the filesystem removed from the
> > system, so the error handling routine ends up trying to sync the
> > filesystem to the device that doesn't exist anymore. WTF?
> >
> =

> >>> This is what I think, why is syncing taking place when the

Amit, you don't need to quote your own reply. That just confuses
mail readers that understand the ">" quoting convention and
highlight appropriately, and made me wonder if you'd even
replied....

> This is what I think, why is syncing taking place when the
> device doesn't exist anymore. What is the gain in doing so?

I doubt the person who wrote the error handling even realised that
it ended up in such a mess.

> I
> will try and propose this feature.

Not sure what you mean by this....

....
> > AFAICT, this problem doesn't exist in TOT - the conversion of the
>
> Again I have a problem which seems fixed in TOT :)
> =

> > xfslogd workqueue to CMWQ allows processing of other xfslogd
> > workqueue events to continue even though this one has gone to sleep.
> >
> > You probably need to change the shutdown type to
> > SHUTDOWN_LOG_IO_ERROR to prevent a log flush from occurring in this
> > shutdown context.
> =

> This will fix the error for this kernel version, I will give this a try.
> Is this the patchwork for CMWQ:
> http://patchwork.xfs.org/patch/2037/ (xfs: improve sync behaviour
> in face of aggressive dirtying) ? Please let me know.

No. 2.6.35 doesn't have the CMWQ infrastructure, it was introduced
in 2.6.38 IIRC.

IOWs, there isn't a fix you can just backport - you're going to need
to write and test your own fix, and my suggestion for doing that is
above.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
