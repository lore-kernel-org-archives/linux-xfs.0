Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMG6RMQ250232 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 10:06:28 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 801231CEC039
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 08:08:22 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id bc5SaTYBHZSBmbHh for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 08:08:22 -0800 (PST)
Message-ID: <4D122275.2000808@sandeen.net>
Date: Wed, 22 Dec 2010 10:08:21 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS hangs
References: <AANLkTikOcJA5a6u2YDXVGAEY0CqKiATTF02VeBsSKtU0@mail.gmail.com>	<20101222060254.GH4907@dastard>
	<201012220904.56914@zmi.at>
	<AANLkTikZkcftqFoZRL=of6TNSiLToYdv=D_mxMMNUj1G@mail.gmail.com>
In-Reply-To: <AANLkTikZkcftqFoZRL=of6TNSiLToYdv=D_mxMMNUj1G@mail.gmail.com>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On 12/22/10 3:12 AM, Amit Sahrawat wrote:
> Hi,
> =

> There seems to be a problem in posting - I already apologized and
> provided complete details. I guess this was the first time, i missed
> on providing the test case.

the xfs mailing list sometimes eats or delays email :(

> Please refer my earlier post on the same issue:
> =

> =

> Extremely sorry for inconvenience, will take care about posting
> complete details in future.
> =

> Test Case : cp Complex directory structure(large no of files and
> directories) to my XFS formatted partition: cp -ar /LibExe /usb/sda2 =

> Unplug the USB while the COPY is in progress.

Success here will depend to some degree on how well your storage behaves.

For starters, do you see any messages about barriers at mount time?

> Storage: USB Flash, USB HDD (Both)
> =

> Kernel: 2.6.34 Target: MIPS LOGS:

So you unplug the USB storage:

> usb 2-1: USB disconnect, address 7 =

> Device sda2, XFS metadata write error block 0x0 in sda2 =

> xfs_force_shutdown(sda2,0x1) called from line 1004 of file
> fs/xfs/linux-2.6/xfs_buf.c.  Return address =3D 0x801cc294 Filesystem
> "sda2": I/O Error Detected.  Shutting down filesystem: sda2 Please
> umount the filesystem, and rectify the problem(s)

this much looks normal for a storage device that disappears.

And now you plug it back in:

> Plug in USB Port1 sd 7:0:0:0: [sdb] Attached SCSI disk Filesystem
> "sda2": xfs_log_force: error 5 returned. Filesystem "sda2":
> xfs_log_force: error 5 returned. Filesystem "sda2": xfs_log_force:
> error 5 returned. Filesystem "sda2": xfs_log_force: error 5

EIO.

> returned. - Show quoted text - INFO: task usb_mount:1858 blocked for
> more than 120 seconds. "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message. =


Might be interesting to know exactly what "usb_mount" does?

Fixing the stack trace so I can read it ...

> usb_mount        D [84a42440] 8032d62c     0  1858   1816
> (user thread) Stack : 00000107 00000000 85e7be80 00030002 84a425c8
> 8032d62c 7fffffff 84a42440 00000002 8496e200 00000001 00000000
> 85e7bf00 85e7bef8 7fa2f2e0 8032d62c 00000001 801d69a8 85e7bd40
> 801d6b34 85e7bd4c 8032dc6c 00000000 801dbc80 85e7be80 864315a8
> 8662c980 00000001 00000742 00000000 00000000 84b85800 85e7bd90
> 801d6cc0 7fffffff 84a42440 00000002 8032ee74 00000081 804158a0 ... =

> Call Trace:
> [<8032d574>] __schedule+0x618/0x6b8 from[<8032d62c>] schedule+0x18/0x3c
> [<8032d62c>] schedule+0x18/0x3c from[<8032dc6c>] schedule_timeout+0x2c/0x=
1c0
> [<8032dc6c>] schedule_timeout+0x2c/0x1c0 from[<8032ee74>] __down+0x8c/0xdc
> [<8032ee74>] __down+0x8c/0xdc from[<8004500c>] down+0x40/0x88
> [<8004500c>] down+0x40/0x88 from[<801ca838>] xfs_buf_lock+0xcc/0x15c
> [<801ca838>] xfs_buf_lock+0xcc/0x15c from[<801b71a0>] xfs_getsb+0x38/0x54 =

> [<801b71a0>] xfs_getsb+0x38/0x54 from[<801d64a8>] xfs_sync_fsdata+0x7c/0x=
154
> [<801d64a8>] xfs_sync_fsdata+0x7c/0x154 from[<801d7284>] xfs_quiesce_data=
+0x34/0x60
> [<801d7284>] xfs_quiesce_data+0x34/0x60 from[<801d3514>] xfs_fs_sync_fs+0=
x30/0xec =

> [<801d3514>] xfs_fs_sync_fs+0x30/0xec from [<800ba09c>] __fsync_super+0xa=
4/0xc8
> [<800ba09c>] __fsync_super+0xa4/0xc8 from[<800ba0d4>] fsync_super+0x14/0x=
28
> [<800ba0d4>] fsync_super+0x14/0x28 from[<800ba4a0>] generic_shutdown_supe=
r+0x34/0x190
> [<800ba4a0>] generic_shutdown_super+0x34/0x190 from[<800ba654>] kill_bloc=
k_super+0x58/0x80
> [<800ba654>] kill_block_super+0x58/0x80 from[<800bac6c>] deactivate_super=
+0x7c/0x110
> [<800bac6c>] deactivate_super+0x7c/0x110 from[<800d2bbc>] sys_umount+0x31=
0/0x358 =

> [<800d2bbc>] sys_umount+0x310/0x358 from[<8000ff44>] stack_done+0x20/0x3c =


so "usb_mount" is calling umount.  Why?  What does this script do?

Let's start with what the script is doing, and please also answer Dave's
question about what "echo w > /proc/sysrq-trigger" says.  This may tell
us if other threads are blocked as well.

You guys are on a custom kernel with custom hardware so you absolutely must
provide as much information as possible if you need help.  As Dave said,
we can't go back and forth 5 times in email repeatedly begging for
info, it doesn't scale, and this sort of support is done in spare time.

Given my experience with embedded development processes, I'm also extremely
wary of what other unspecified changes may be in the kernel tree.  If upstr=
eam
kernels boot on this hardware, testing a recent pristine upstream kernel
would be a very good test as well.

Sometimes sending test hardware to developers makes this sort of thing go m=
ore
smoothly as well.  46" or larger, I suppose ;)

Thanks,
-Eric

> -------------------------------------------------------------------------=
------------
>
> =

Filesystem "sda2": xfs_log_force: error 5 returned.
> Please let me know in case more information is needed.
> =

> Thanks & Regards, Amit Sahrawat
> =

> On Wed, Dec 22, 2010 at 1:34 PM, Michael Monnerie
> <michael.monnerie@is.it-management.at
> <mailto:michael.monnerie@is.it-management.at>> wrote:
> =

> On Mittwoch, 22. Dezember 2010 Dave Chinner wrote:
>> For future reference, when you are reporting a problem you need to =

>> be specific about what you were doing to cause the problem you are =

>> reporting.  Describe your kernel, your storage, your test case,
>> any errors that occurred before the problem you are reporting,
>> etc.
>> =

>> We need this information to make any sense of your bug report, but =

>> I'm getting tired of having to ask for it every time you report a =

>> problem. The more information you put in your bug report, the more =

>> likely we are to be able to help you. We don't have unlimited =

>> amounts of time (or patience) to drag all the basic details of
>> your problem out of you over 3 or 4 emails, so including it up
>> front will help a lot....
> =

> Should I update this section?
> =

> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_whe=
n_reporting_a_problem.3F
>
>  We should probably just send that link to people so you don't have
> to write long texts all the time.
> =

> Maybe above section should be updated to:
> =

> Things to include are what version of XFS you are using and version
> of the kernel. If you have problems with userland packages please
> report the version of the package you are using.
> =

> If the problem relates to a particular filesystem, the output from
> the xfs_info(8) command and any mount(8) options in use will also be
> useful to the developers.
> =

> If you experience an oops, please run it through ksymoops so that it
> can be interpreted. Also describe what you were doing, if you can
> repeat it, and describe you kernel, storage, test case, if there was
> a hardware problem before, etc.
> =

> If you have a filesystem that cannot be repaired, make sure you have =

> xfsprogs 3.1.x or later and run xfs_metadump(8) to capture the
> metadata (which obfuscates filenames and attributes to protect your
> privacy) and make the dump available for someone to analyse.
> =

> -- mit freundlichen Gr=FCssen, Michael Monnerie, Ing. BSc
> =

> it-management Internet Services: Prot=E9ger http://proteger.at
> <http://proteger.at/> [gesprochen: Prot-e-schee] Tel: +43 660 / 415
> 6531
> =

> // ****** Radiointerview zum Thema Spam ****** //
> http://www.it-podcast.at/archiv.html#podcast-100716 // // Haus zu
> verkaufen: http://zmi.at/langegg/
> =

> =

> =

> =

> _______________________________________________ xfs mailing list =

> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
