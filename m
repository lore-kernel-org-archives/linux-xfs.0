Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729559AbfABQMW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jan 2019 11:12:22 -0500
Date: Wed, 2 Jan 2019 11:12:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Sometimes the disk is unplugged and the umount operation enters
 the D state.
Message-ID: <20190102161220.GB6452@bfoster>
References: <CALe3CaDDVR-2N1UtSaSXivvgtmg3ihD95WA8j8Ef9=5YS7PVsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALe3CaDDVR-2N1UtSaSXivvgtmg3ihD95WA8j8Ef9=5YS7PVsw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Su Hua <suhua.tanke@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Dec 27, 2018 at 12:20:42PM +0800, Su Hua wrote:
> Hi Brian：
> 
> We use kernel version: 4.4.163
> 
> Our test department found that this version of the kernel still has the
> problem that the umount operation will enter the D state after the disk is
> unplugged. The information is as follows:
> 
> [Mon Dec 17 13:41:17 2018] INFO: task umount:19009 blocked for more than
> 120 seconds.
> [Mon Dec 17 13:41:17 2018]       Tainted: G        W  O    4.4.163 #4
> [Mon Dec 17 13:41:17 2018] "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Mon Dec 17 13:41:17 2018] umount          D ffffffc000084974     0 19009
>  8925 0x00000008
> [Mon Dec 17 13:41:17 2018] Call trace:
> [Mon Dec 17 13:41:17 2018] [<ffffffc000084974>] __switch_to+0x60/0x6c
> [Mon Dec 17 13:41:17 2018] [<ffffffc0007ed9d8>] __schedule+0x1a4/0x564
> [Mon Dec 17 13:41:17 2018] [<ffffffc0007eddd0>] schedule+0x38/0x90
> [Mon Dec 17 13:41:17 2018] [<ffffffc00035a10c>]
> xfs_ail_push_all_sync+0xac/0xf8
> [Mon Dec 17 13:41:17 2018] [<ffffffc000343bd4>] xfs_unmountfs+0x48/0x110
> [Mon Dec 17 13:41:17 2018] [<ffffffc000346db4>] xfs_fs_put_super+0x30/0x84
> [Mon Dec 17 13:41:17 2018] [<ffffffc0001896e0>]
> generic_shutdown_super+0x68/0xdc
> [Mon Dec 17 13:41:17 2018] [<ffffffc000189a34>] kill_block_super+0x1c/0x5c
> [Mon Dec 17 13:41:17 2018] [<ffffffc000189bb0>]
> deactivate_locked_super+0x5c/0x88
> [Mon Dec 17 13:41:17 2018] [<ffffffc00018a948>] deactivate_super+0xa8/0xb4
> [Mon Dec 17 13:41:17 2018] [<ffffffc0001a4614>] cleanup_mnt+0x3c/0x74
> [Mon Dec 17 13:41:17 2018] [<ffffffc0001a46b0>] __cleanup_mnt+0x10/0x18
> [Mon Dec 17 13:41:17 2018] [<ffffffc0000b3f90>] task_work_run+0xa8/0xc4
> [Mon Dec 17 13:41:17 2018] [<ffffffc000086458>] do_notify_resume+0x6c/0x74
> [Mon Dec 17 13:41:17 2018] [<ffffffc0000839e0>] work_pending+0x1c/0x20
> 
> And the trace info like this:
> xfs_umount_D.txt
> <https://github.com/zlsh007/Ohters/blob/master/Bug/xfs_umount_D.txt>
> 
> Can you give me some advice, how can I solve this problem?
> 

I'd probably start with commit e6b3bb78962e6 ("xfs: add "fail at
unmount" error handling configuration") which went into v4.7. That may
or may not depend on earlier error configuration work as well.

Brian

> Best regards
