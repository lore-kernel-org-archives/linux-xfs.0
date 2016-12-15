Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52888 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752886AbcLOEHe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Dec 2016 23:07:34 -0500
Subject: Re: [PATCH] xfs: during log recovery, destroy the unlinked inodes
 even for read-only mount
References: <1481014847-22242-1-git-send-email-houtao1@huawei.com>
 <20161207063009.GH4326@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ad2d0226-3901-735e-e640-af03ce348baf@sandeen.net>
Date: Wed, 14 Dec 2016 22:07:32 -0600
MIME-Version: 1.0
In-Reply-To: <20161207063009.GH4326@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Hou Tao <houtao1@huawei.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org

On 12/7/16 12:30 AM, Dave Chinner wrote:
> On Tue, Dec 06, 2016 at 05:00:47PM +0800, Hou Tao wrote:
>> During the 2nd stage of log recovery, if the filesystem is firstly mounted
>> as read-only, the unlink inodes will not be destroyed and the unlinked list
>> in AGI will not be cleared. Even after a read-write remount or umount,
>> the unlinked inodes will still be valid and be kept on disk, and the
>> available freespace will be incorrect.
>>
>> To fix the problem, we need to force xfs_inactive() to destroy the
>> unlinked inode when the filesystem is mounted as read-only.
>> So clear the XFS_MOUNT_RDONLY flag temporarily before the recovery
>> of unlinked inodes and restore the flag after the recovery has done.
>>
>> The problem can be reproduced by the following steps:
>> 1. mount a xfs fs on a KVM VM
>> 2. on the VM launch an application which does the following things:
>>    open(xfs_file); unlink(xfs_file);
>>    while(1) { write(xfs_file, 2MB); sleep(1); }
>> 3. wait 5 seconds, sync the xfs fs, and wait 5 seconds
>> 4. terminate the VM
>> 5. start the VM and mount the xfs as read-only
>> 6. remount the xfs as read-write or umount
>> 7. check the unlinked list and the available freespace
> 
> This is only papering over the larger problem.
> 
> I was talking to Eric about this larger "recovery on read-only
> mount" problem last week on IRC - I can't find it my logs right now,
> but IIRC I'd suggested that we should always run xfs_mountfs()
> in read-write mount if the underlying device can be written to,
> and then once that is complete do a rw->ro transition exactly as we
> do for a remount,ro operation.

Yeah, I have a larger patchset to try to handle this and other
related processing that wasn't happening on ro mounts.  I got
derailed because my regression test for it ran into all kinds
of unexpected new & unrelated bugs.  So I haven't sent it yet...

There were lots of little bits here and there stemming, I think,
from old Irix code that didn't do /any/ device IO on a ro mount.

-Eric

> That way we remove all the special "write on read only mount" hacks
> we currently have throughout the code to enable log recovery to run
> on read-only mounts.
> 
> Essentially is requires moving the device read only check from the
> log code to xfs_fs_fill_super() and handling the no-recovery flag
> there before we call xfs_mountfs() and adding the rw->ro state
> transition after we return. This will be much simpler and much more
> reliable than trying to turn off "read only" state around certain
> operations...
> 
> Cheers,
> 
> Dave.
> 
