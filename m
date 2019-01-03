Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi1-f172.google.com ([209.85.167.172]:36307 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfACBrL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jan 2019 20:47:11 -0500
Received: by mail-oi1-f172.google.com with SMTP id x23so26612303oix.3
        for <linux-xfs@vger.kernel.org>; Wed, 02 Jan 2019 17:47:10 -0800 (PST)
MIME-Version: 1.0
References: <CALe3CaDDVR-2N1UtSaSXivvgtmg3ihD95WA8j8Ef9=5YS7PVsw@mail.gmail.com>
 <20190102161220.GB6452@bfoster>
In-Reply-To: <20190102161220.GB6452@bfoster>
From: Su Hua <suhua.tanke@gmail.com>
Date: Thu, 3 Jan 2019 09:46:58 +0800
Message-ID: <CALe3CaBLf83yvnx3tUTPEdDZiZc7Y1WSaSt2K2UQTJdnCtpAZQ@mail.gmail.com>
Subject: Re: Sometimes the disk is unplugged and the umount operation enters
 the D state.
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Yeah, thank you, I found this patch yesterday, =EF=BC=9A=EF=BC=89 I will ba=
ckport it,
Happy New Year's Day.

suhua

> Best regards


Brian Foster <bfoster@redhat.com> =E4=BA=8E2019=E5=B9=B41=E6=9C=883=E6=97=
=A5=E5=91=A8=E5=9B=9B =E4=B8=8A=E5=8D=8812:12=E5=86=99=E9=81=93=EF=BC=9A
>
> On Thu, Dec 27, 2018 at 12:20:42PM +0800, Su Hua wrote:
> > Hi Brian=EF=BC=9A
> >
> > We use kernel version: 4.4.163
> >
> > Our test department found that this version of the kernel still has the
> > problem that the umount operation will enter the D state after the disk=
 is
> > unplugged. The information is as follows:
> >
> > [Mon Dec 17 13:41:17 2018] INFO: task umount:19009 blocked for more tha=
n
> > 120 seconds.
> > [Mon Dec 17 13:41:17 2018]       Tainted: G        W  O    4.4.163 #4
> > [Mon Dec 17 13:41:17 2018] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [Mon Dec 17 13:41:17 2018] umount          D ffffffc000084974     0 190=
09
> >  8925 0x00000008
> > [Mon Dec 17 13:41:17 2018] Call trace:
> > [Mon Dec 17 13:41:17 2018] [<ffffffc000084974>] __switch_to+0x60/0x6c
> > [Mon Dec 17 13:41:17 2018] [<ffffffc0007ed9d8>] __schedule+0x1a4/0x564
> > [Mon Dec 17 13:41:17 2018] [<ffffffc0007eddd0>] schedule+0x38/0x90
> > [Mon Dec 17 13:41:17 2018] [<ffffffc00035a10c>]
> > xfs_ail_push_all_sync+0xac/0xf8
> > [Mon Dec 17 13:41:17 2018] [<ffffffc000343bd4>] xfs_unmountfs+0x48/0x11=
0
> > [Mon Dec 17 13:41:17 2018] [<ffffffc000346db4>] xfs_fs_put_super+0x30/0=
x84
> > [Mon Dec 17 13:41:17 2018] [<ffffffc0001896e0>]
> > generic_shutdown_super+0x68/0xdc
> > [Mon Dec 17 13:41:17 2018] [<ffffffc000189a34>] kill_block_super+0x1c/0=
x5c
> > [Mon Dec 17 13:41:17 2018] [<ffffffc000189bb0>]
> > deactivate_locked_super+0x5c/0x88
> > [Mon Dec 17 13:41:17 2018] [<ffffffc00018a948>] deactivate_super+0xa8/0=
xb4
> > [Mon Dec 17 13:41:17 2018] [<ffffffc0001a4614>] cleanup_mnt+0x3c/0x74
> > [Mon Dec 17 13:41:17 2018] [<ffffffc0001a46b0>] __cleanup_mnt+0x10/0x18
> > [Mon Dec 17 13:41:17 2018] [<ffffffc0000b3f90>] task_work_run+0xa8/0xc4
> > [Mon Dec 17 13:41:17 2018] [<ffffffc000086458>] do_notify_resume+0x6c/0=
x74
> > [Mon Dec 17 13:41:17 2018] [<ffffffc0000839e0>] work_pending+0x1c/0x20
> >
> > And the trace info like this:
> > xfs_umount_D.txt
> > <https://github.com/zlsh007/Ohters/blob/master/Bug/xfs_umount_D.txt>
> >
> > Can you give me some advice, how can I solve this problem?
> >
>
> I'd probably start with commit e6b3bb78962e6 ("xfs: add "fail at
> unmount" error handling configuration") which went into v4.7. That may
> or may not depend on earlier error configuration work as well.
>
> Brian
>
> > Best regards
