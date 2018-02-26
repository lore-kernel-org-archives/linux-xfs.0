Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m177199.ym.163.com ([123.58.177.199]:5411 "EHLO
        m177199.ym.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbeBZC7h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 21:59:37 -0500
Subject: Re: xfs_repair: add '-F' option to ignore writable mount checking
References: <5A914B45.8080200@xtaotech.com>
 <5c0df437-0f09-129c-945f-0f917bfdaa7e@sandeen.net>
 <20180224220428.GB30854@dastard>
From: Yang Joseph <joseph.yang@xtaotech.com>
Message-ID: <5A9377FB.7000201@xtaotech.com>
Date: Mon, 26 Feb 2018 10:59:07 +0800
MIME-Version: 1.0
In-Reply-To: <20180224220428.GB30854@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, nathans@debian.org, linux-xfs@vger.kernel.org

In our case, there is a mountpoint of ceph-fuse type and this mountpoint 
is abnormal.
I execute 'xfs_repair -n /dev/nbd4' cmd. Then xfs_repair is blocked in 
stat()
systemcall. '/dev/nbd4' has no relationship with the ceph-fuse mountpoint.

[root@compute5 ~]# ps aux | grep xfs_repair
root     16469  0.0  0.0 114744   564 ?        D    10:50   0:00 
xfs_repair -n /dev/nbd4

[root@compute5 ~]# cat /proc/16469/stack
[<ffffffffa04b953d>] __fuse_request_send+0x13d/0x2c0 [fuse]
[<ffffffffa04b96d2>] fuse_request_send+0x12/0x20 [fuse]
[<ffffffffa04be67a>] fuse_do_getattr+0x11a/0x2e0 [fuse]
[<ffffffffa04bfba5>] fuse_update_attributes+0x75/0x80 [fuse]
[<ffffffffa04bfbf3>] fuse_getattr+0x43/0x50 [fuse]
[<ffffffff81203976>] vfs_getattr+0x46/0x80
[<ffffffff81203aa5>] vfs_fstatat+0x75/0xc0
[<ffffffff81203ffe>] SYSC_newstat+0x2e/0x60
[<ffffffff812042de>] SyS_newstat+0xe/0x10
[<ffffffff81697809>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

The stat() is from the following code:

// libxfs/linux.c:platform_check_mount()
   while ((mnt = getmntent(f)) != NULL) {
     if (stat64(mnt->mnt_fsname, &mst) < 0) <---------<<<< 
unconditionally stat all mountpoints
       continue;

xfs_repair have to check all mountpoints of the system to make sure 
there is
no writable mount point of user specified device. If there is one abnormal
mountpoint, event it not related to user specified device, xfs_repair will
be blocked.

I can make sure there is no writable mountpoint of /dev/nbd4, so xfs_repair
don't need to check all mountpoints of the system. This is why I want to add
this '-F' option.

Because there are lots of other services on this node, I can't reboot 
the machine.

thx

Yang Honggang

On 02/25/2018 06:04 AM, Dave Chinner wrote:
> On Sat, Feb 24, 2018 at 11:56:44AM -0600, Eric Sandeen wrote:
>> On 2/24/18 5:23 AM, Yang Joseph wrote:
>>> hello,
>>>
>>> Before the repair process, xfs_repair will check if user specified device already
>>> has a writable mountpoint. And it will stat all the mountpoints of the system. If there
>>> is a dead mountpoint, this checking will be blocked and xfs_repair will enter 'D' state.
> So why is the mount point dead?
>
> That kinda means that the filesystem is still mounted, but something
> has hung somewhere and the filesystem may still have active
> references to the underlying device and be doing stuff that is
> modifying the filesystem....
>
> And if the device is still busy, then you aren't going to be able to
> mount the repaired device, anyway, because the block device is still
> busy...
>
>> That sounds like a bug worth fixing, but I am much
>> less excited about adding options which could do serious damage
>> to a filesystem.
> TO me it sounds like something that should be fixed by a reboot, not
> by adding dangerous options to xfs_repair...
>
> Cheers,
>
> Dave.

