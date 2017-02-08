Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42364 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751094AbdBHCbn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Feb 2017 21:31:43 -0500
Subject: Re: [PATCH] xfs: during log recovery, destroy the unlinked inodes
 even for read-only mount
References: <1481014847-22242-1-git-send-email-houtao1@huawei.com>
 <20161207063009.GH4326@dastard>
 <ad2d0226-3901-735e-e640-af03ce348baf@sandeen.net>
 <504078b4-68ea-eb3c-231f-9d840f1e8687@huawei.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f4577e5e-e775-673b-c2a9-d36cb245377e@sandeen.net>
Date: Tue, 7 Feb 2017 20:31:41 -0600
MIME-Version: 1.0
In-Reply-To: <504078b4-68ea-eb3c-231f-9d840f1e8687@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



On 12/15/16 5:36 AM, Hou Tao wrote:
>>> I was talking to Eric about this larger "recovery on read-only
>>> mount" problem last week on IRC - I can't find it my logs right now,
>>> but IIRC I'd suggested that we should always run xfs_mountfs()
>>> in read-write mount if the underlying device can be written to,
>>> and then once that is complete do a rw->ro transition exactly as we
>>> do for a remount,ro operation.
>>
>> Yeah, I have a larger patchset to try to handle this and other
>> related processing that wasn't happening on ro mounts.  I got
>> derailed because my regression test for it ran into all kinds
>> of unexpected new & unrelated bugs.  So I haven't sent it yet...
>>
>> There were lots of little bits here and there stemming, I think,
>> from old Irix code that didn't do /any/ device IO on a ro mount.
>>
>> -Eric
> It's glad to hear that you have nearly completed the ro mount patchset,
> so I will stop reworking on this problem.
> 
> During the rework, I found two puzzling XFS_MOUNT_RDONLY checkings
> at xfs_release(...) and xfs_inactive(...). In my opinion these check
> should be done at VFS instead of the specific filesystem, so why
> these XFS_MOUNT_RDONLY checkings there are ? Could we move the
> needed check to VFS just like the things sb_prepare_remount_readonly()
> have done ?

Getting back to this - the reason for your original patch, I think,
was that things like log recovery can get into this code without going
through the vfs at all, so I think vfs checks are not always sufficient.

That said, there probably are some XFS_MOUNT_RDONLY checks which are
redundant.

-Eric

> Tao
> 
