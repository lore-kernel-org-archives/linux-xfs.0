Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:2559 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755701AbcLOLhE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Dec 2016 06:37:04 -0500
Subject: Re: [PATCH] xfs: during log recovery, destroy the unlinked inodes
 even for read-only mount
References: <1481014847-22242-1-git-send-email-houtao1@huawei.com>
 <20161207063009.GH4326@dastard>
 <ad2d0226-3901-735e-e640-af03ce348baf@sandeen.net>
From: Hou Tao <houtao1@huawei.com>
Message-ID: <504078b4-68ea-eb3c-231f-9d840f1e8687@huawei.com>
Date: Thu, 15 Dec 2016 19:36:52 +0800
MIME-Version: 1.0
In-Reply-To: <ad2d0226-3901-735e-e640-af03ce348baf@sandeen.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

>> I was talking to Eric about this larger "recovery on read-only
>> mount" problem last week on IRC - I can't find it my logs right now,
>> but IIRC I'd suggested that we should always run xfs_mountfs()
>> in read-write mount if the underlying device can be written to,
>> and then once that is complete do a rw->ro transition exactly as we
>> do for a remount,ro operation.
> 
> Yeah, I have a larger patchset to try to handle this and other
> related processing that wasn't happening on ro mounts.  I got
> derailed because my regression test for it ran into all kinds
> of unexpected new & unrelated bugs.  So I haven't sent it yet...
> 
> There were lots of little bits here and there stemming, I think,
> from old Irix code that didn't do /any/ device IO on a ro mount.
> 
> -Eric
It's glad to hear that you have nearly completed the ro mount patchset,
so I will stop reworking on this problem.

During the rework, I found two puzzling XFS_MOUNT_RDONLY checkings
at xfs_release(...) and xfs_inactive(...). In my opinion these check
should be done at VFS instead of the specific filesystem, so why
these XFS_MOUNT_RDONLY checkings there are ? Could we move the
needed check to VFS just like the things sb_prepare_remount_readonly()
have done ?

Tao


