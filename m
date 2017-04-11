Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.stepping-stone.ch ([194.176.109.206]:44768 "EHLO
        mail.stepping-stone.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754251AbdDKK2d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2017 06:28:33 -0400
Subject: Re: XFS mount hangs during quotacheck
References: <94fae78c-056b-3055-0714-c4df9239fffb@stepping-stone.ch>
 <20170406125120.GA50328@bfoster.bfoster>
 <c29ade94-ea74-07ac-db58-e203219f9426@stepping-stone.ch>
 <20170406132058.GB50328@bfoster.bfoster>
 <019caacc-f5b5-fb29-c10c-f1de72b25caf@stepping-stone.ch>
From: Christian Affolter <c.affolter@stepping-stone.ch>
Message-ID: <4bec2296-0ac0-68a0-4b97-fb2df2616202@stepping-stone.ch>
Date: Tue, 11 Apr 2017 12:28:12 +0200
MIME-Version: 1.0
In-Reply-To: <019caacc-f5b5-fb29-c10c-f1de72b25caf@stepping-stone.ch>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Hello Brian,

On 06.04.2017 15:35, Christian Affolter wrote:
> On 06.04.2017 15:21, Brian Foster wrote:
>> On Thu, Apr 06, 2017 at 03:10:41PM +0200, Christian Affolter wrote:
>>> Hi Brian,
>>>
>>> thanks a lot for taking the time to help.
>>>
>>> On 06.04.2017 14:51, Brian Foster wrote:
>>>> On Wed, Apr 05, 2017 at 03:08:03PM +0200, Christian Affolter wrote:
>>>>> Hi everyone,
>>>>>
>>>>> I'm having a system with a 15 TiB XFS volume with user and project
>>>>> quotas,
>>>>> which recently crashed.
>>>>>
>>>>> After a successful xfs_repair run, I'm trying to mount the file system
>>>>> again. According to dmesg a quotacheck is needed (XFS (vdc):
>>>>> Quotacheck
>>>>> needed: Please wait.), for about 20 minutes I see expected
>>>>> read-activity on
>>>>> the device within iotop, then it suddenly stops but the mount
>>>>> command still
>>>>> hangs in uninterruptable sleep state (D+) while the system remains
>>>>> completely idle (I/O and CPU wise).
>>>>>
>>>>> [...]
>>>>
>>>>> Apr  5 10:33:48 sysresccd kernel: XFS (vdc): Mounting V5 Filesystem
>>>>> Apr  5 10:33:48 sysresccd kernel: XFS (vdc): Ending clean mount
>>>>> Apr  5 10:33:53 sysresccd kernel: XFS (vdc): Unmounting Filesystem
>>>>> Apr  5 10:34:00 sysresccd kernel: Adding 4193276k swap on
>>>>> /dev/vda2.  Priority:-1 extents:1 across:4193276k FS
>>>>> Apr  5 10:34:35 sysresccd kernel: XFS (vdc): Mounting V5 Filesystem
>>>>> Apr  5 10:34:35 sysresccd kernel: XFS (vdc): Ending clean mount
>>>>> Apr  5 10:34:35 sysresccd kernel: XFS (vdc): Quotacheck needed:
>>>>> Please wait.
>>>>> Apr  5 10:34:43 sysresccd su[2622]: Successful su for root by root
>>>>> Apr  5 10:34:43 sysresccd su[2622]: + /dev/tty2 root:root
>>>>> Apr  5 12:03:49 sysresccd kernel: sysrq: SysRq : Show Blocked State
>>>>> Apr  5 12:03:49 sysresccd kernel:   task                        PC
>>>>> stack   pid father
>>>>> Apr  5 12:03:49 sysresccd kernel: mount           D
>>>>> ffff880310653958     0  2611   2571 0x20020000
>>>>> Apr  5 12:03:49 sysresccd kernel:  ffff880310653958
>>>>> ffff880310653958 0000000500370b74 ffff880002789d40
>>>>> Apr  5 12:03:49 sysresccd kernel:  ffff880310654000
>>>>> ffff8803111da198 0000000000000002 ffffffff817fbb2a
>>>>> Apr  5 12:03:49 sysresccd kernel:  ffff880002789d40
>>>>> ffff880310653970 ffffffff817f9f58 7fffffffffffffff
>>>>> Apr  5 12:03:49 sysresccd kernel: Call Trace:
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fbb2a>] ?
>>>>> usleep_range+0x3a/0x3a
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817f9f58>]
>>>>> schedule+0x70/0x7e
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fbb59>]
>>>>> schedule_timeout+0x2f/0x107
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81170dcd>] ?
>>>>> __kmalloc+0xeb/0x114
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81389780>] ?
>>>>> kmem_alloc+0x33/0x96
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff810b58f0>] ?
>>>>> arch_local_irq_save+0x15/0x1b
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fc3f7>] ?
>>>>> _raw_spin_unlock_irqrestore+0xf/0x11
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fa72d>]
>>>>> do_wait_for_common+0xe4/0x11a
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fa72d>] ?
>>>>> do_wait_for_common+0xe4/0x11a
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff810a315c>] ?
>>>>> wake_up_q+0x42/0x42
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fa7d9>]
>>>>> wait_for_common+0x36/0x4f
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817fa80a>]
>>>>> wait_for_completion+0x18/0x1a
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139a223>]
>>>>> xfs_qm_flush_one+0x42/0x7f
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139a586>]
>>>>> xfs_qm_dquot_walk.isra.8+0xc1/0x106
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139a1e1>] ?
>>>>> xfs_qm_dqattach_one+0xe3/0xe3
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139bd27>]
>>>>> xfs_qm_quotacheck+0x131/0x252
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8139bedf>]
>>>>> xfs_qm_mount_quotas+0x97/0x143
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff813840a1>]
>>>>> xfs_mountfs+0x587/0x6b1
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff813868ea>]
>>>>> xfs_fs_fill_super+0x411/0x4b5
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff811846d1>]
>>>>> mount_bdev+0x141/0x195
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff813864d9>] ?
>>>>> xfs_parseargs+0x8e8/0x8e8
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81168bff>] ?
>>>>> alloc_pages_current+0x96/0x9f
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8138502b>]
>>>>> xfs_fs_mount+0x10/0x12
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff811851f3>]
>>>>> mount_fs+0x62/0x12b
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff81199646>]
>>>>> vfs_kern_mount+0x64/0xd0
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff8119bccd>]
>>>>> do_mount+0x8d5/0x9e6
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff811c07b1>]
>>>>> compat_SyS_mount+0x179/0x1a5
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff810039bb>]
>>>>> do_syscall_32_irqs_off+0x52/0x61
>>>>> Apr  5 12:03:49 sysresccd kernel:  [<ffffffff817feee6>]
>>>>> entry_INT80_compat+0x36/0x50
>>>>
>>>> This looks like a known quotacheck vs. reclaim deadlock. Quotacheck is
>>>> in the phase where it has completed all of the updates of in-core
>>>> accounting and now needs to flush the in-core xfs_dquot structures to
>>>> their associated backing buffers and submit them for I/O. The flush
>>>> sequence is stuck waiting on an xfs_dquot flush lock, however.
>>>>
>>>> The problem is that quotacheck holds the underlying buffers and then
>>>> does a blocking xfs_dqflock(), which is effectively an inverse locking
>>>> order from xfs_dquot memory reclaim. If reclaim runs during the
>>>> previous
>>>> quotacheck phase, it acquires the flush lock and fails to submit the
>>>> underlying buffer for I/O (because quotacheck effectively holds/pins
>>>> the
>>>> buffer). When the quotacheck flush gets to the dquot, it thus waits
>>>> indefinitely on a flush lock that will never unlock.
>>>>
>>>> If you're comfortable building a kernel from source, you could try the
>>>> following patch and see if it helps quotacheck to complete:
>>>>
>>>>   http://www.spinics.net/lists/linux-xfs/msg04485.html
>>>>
>>>> (Note that I've not been able to get this patch merged.)
>>>
>>> Shall I only apply "[PATCH 2/3] xfs: push buffer of flush locked
>>> dquot to
>>> avoid quotacheck deadlock" or are all patches of this series required?
>>>
>>> Which kernel version would you recommend for applying the patch?
>>>
>>
>> You could apply patches 1-2 of that series. Patch 3 was a
>> hack/experiment. Definitely do not apply that one.
>>
>> I think they should apply fine to any v4.10 or newer kernel. I'm not
>> sure that quotacheck changes all that often so you could probably pull
>> them into an older kernel as well, but you'd have to try to apply them
>> to know for sure.
>>
>> Brian
>
> OK, I will build a 4.10.X kernel with your patches applied and try to
> re-mount the volume within the next few days.
>
> I will keep you posted.

I'm glad to report that your patches helped to mount the volume with 
enabled quota support again.

I've built two 4.10.8 kernels, the first one without your patches and 
the second one with your patches applied.
First I've tried to mount the volume with the unpatched kernel, which 
resulted in the same mount hang as before. Afterwards, I've booted with 
the patched kernel on which the quota check succeeded:

[  101.304031] XFS (vdc): Mounting V5 Filesystem
[  101.706020] XFS (vdc): Starting recovery (logdev: internal)
[  102.276708] XFS (vdc): Ending recovery (logdev: internal)
[  102.278253] XFS (vdc): Quotacheck needed: Please wait.
[ 1388.403236] XFS (vdc): Quotacheck: Done.

I've run some basic checks with "xfs_quota" and the user as well as the 
project quotas look good.

For the record, I've applied the following two patches:
https://patchwork.kernel.org/patch/9591113
https://patchwork.kernel.org/patch/9591117

Thank you very much for your help!

Best,
Chris
