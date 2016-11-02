Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from corp-mailer.zoner.com ([217.198.120.77]:56772 "EHLO
        corp-mailer.zoner.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754938AbcKBQbE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2016 12:31:04 -0400
Subject: Re: Quota-enabled XFS hangs during mount
References: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
 <20161101215803.GA14023@dastard>
From: Martin Svec <martin.svec@zoner.cz>
Message-ID: <cad65166-6d77-3c6f-151b-5970b1b6fc85@zoner.cz>
Date: Wed, 2 Nov 2016 17:31:00 +0100
MIME-Version: 1.0
In-Reply-To: <20161101215803.GA14023@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Hello,

Dne 1.11.2016 v 22:58 Dave Chinner napsal(a):
> On Tue, Nov 01, 2016 at 05:45:04PM +0100, Martin Svec wrote:
>> Hello,
>>
>> with user and group quotas enabled, XFS freezes during mount and the following error is reported to
>> dmesg (Debian 8 kernel 3.16.0-4):
<SNIP>
>> Ugh. Please turn on CONFIG_FRAME_POINTER=y. However, it still looks
>> like it's waiting on IO completion.

Below is a vanilla 4.6.7 calltrace compiled with frame pointers:

[  360.235106] INFO: task mount:785 blocked for more than 120 seconds.
[  360.235143]       Tainted: G            E   4.6.7-xfs1 #20
[  360.235167] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  360.235200] mount           D ffff88007a1df978     0   785    737 0x00000000
[  360.235238]  ffff88007a1df978 00000001c01d7770 ffffffff81c0d540 ffff880036d44240
[  360.235276]  ffff88007a1e0000 7fffffffffffffff ffff880079e5fe80 ffff880036d44240
[  360.235313]  ffff88007a1dfb08 ffff88007a1df990 ffffffff815fd4e5 ffff880079e5fe88
[  360.236367] Call Trace:
[  360.237057]  [<ffffffff815fd4e5>] schedule+0x35/0x80
[  360.237753]  [<ffffffff8160065f>] schedule_timeout+0x22f/0x2c0
[  360.238448]  [<ffffffff8133607d>] ? radix_tree_lookup+0xd/0x10
[  360.239238]  [<ffffffffc019c8da>] ? xfs_perag_get+0x2a/0xb0 [xfs]
[  360.239979]  [<ffffffff815fdfaa>] wait_for_completion+0xfa/0x130
[  360.240672]  [<ffffffff810aa250>] ? wake_up_q+0x70/0x70
[  360.241395]  [<ffffffffc01dce42>] xfs_qm_flush_one+0x82/0xc0 [xfs]
[  360.242094]  [<ffffffffc01dcdc0>] ? xfs_qm_dqattach_one+0x120/0x120 [xfs]
[  360.242795]  [<ffffffffc01dd23c>] xfs_qm_dquot_walk.isra.10+0xec/0x170 [xfs]
[  360.243513]  [<ffffffffc01df295>] xfs_qm_quotacheck+0x255/0x310 [xfs]
[  360.244202]  [<ffffffffc01df434>] xfs_qm_mount_quotas+0xe4/0x170 [xfs]
[  360.244879]  [<ffffffffc01c0b64>] xfs_mountfs+0x804/0x870 [xfs]
[  360.245547]  [<ffffffffc01c33df>] xfs_fs_fill_super+0x3af/0x4c0 [xfs]
[  360.246210]  [<ffffffff8120860d>] mount_bdev+0x17d/0x1b0
[  360.246888]  [<ffffffffc01c3030>] ? xfs_test_remount_options.isra.11+0x60/0x60 [xfs]
[  360.247590]  [<ffffffffc01c1e65>] xfs_fs_mount+0x15/0x20 [xfs]
[  360.248242]  [<ffffffff81208f08>] mount_fs+0x38/0x170
[  360.248880]  [<ffffffff812255e4>] vfs_kern_mount+0x64/0x110
[  360.249516]  [<ffffffff81227c88>] do_mount+0x248/0xde0
[  360.250168]  [<ffffffff811a2841>] ? strndup_user+0x41/0x80
[  360.250807]  [<ffffffff8122781c>] ? copy_mount_options+0x2c/0x230
[  360.251451]  [<ffffffff81228b14>] SyS_mount+0x94/0xd0
[  360.252050]  [<ffffffff816013b6>] entry_SYSCALL_64_fastpath+0x1e/0xa8

>
>> Filesystem parameters are as follows:
>>
>> orthosie:~# xfs_info /www
>> meta-data=/dev/sdd1              isize=256    agcount=103, agsize=655232 blks
> urk. 103 AGs of 2.5GB each? That's going to cause all sorts of seek
> issues with IO. How many times has this filesystem
> been grown since it was first created as a 10GB filesystem? What's
> the underlying storage?

Good to know, thanks for pointing on this. It's a VMware virtual machine that was resized multiple
times depending on increasing space needs. The storage is a VMDK virtual drive backed by all-flash
iSCSI SAN storage.

>>          =                       sectsz=512   attr=2, projid32bit=0
>>          =                       crc=0        finobt=0
>> data     =                       bsize=4096   blocks=66846464, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
>> log      =internal               bsize=4096   blocks=2560, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> Disk usage:
>>
>> orthosie:~# df
>> Filesystem     1K-blocks      Used Available Use% Mounted on
>> /dev/sdd1      267375616 225270324  42105292  85% /www
> How many inodes? How much RAM?

orthosie:~# df -i
Filesystem        Inodes   IUsed     IFree IUse% Mounted on
/dev/sdd1      173746096 5214637 168531459    4% /www

The virtual machine has 2 virtual cores and 2 GB RAM. None of it is a bottleneck, I think.

>> The only workaround is to mount the filesystem without quotas, xfs_repair reports no errors. 
> xfs_repair ignores quotas - it simply removes the flags that tell
> the kernel to rebuild the quotas on the next mount.
>
>> Any ideas what's wrong? How can I help to fix the problem? Note
>> that the server is a non-production clone of a virtual machine
>> where the problem originally occurred. So I'm free to any tests
>> and experiments.
> What else is stuck when the hung task trigger fires (sysrq-w
> output)? Is there still IO going on when the hung task warning comes
> up, or it the system completely idle at this point?

The system is fully responsive, no other hung tasks or system stalls. Only load average is increased
to 1.0 due to the hung kernel task. There's no I/O on the affected block device and the system is idle.

I tried xfs_quota -xc 'quot -n' on the filesystem mounted without quotas. This command succeeds and
returns reasonable results: 298 user quotas.

Also, my colleague informed me that we have another virtual machine with the same problem. The setup
is the same: Debian 8 webserver with usrquota-enabled XFS, running kernel SMP Debian 3.16.7-ckt25-2
(2016-04-08) x86_64 GNU/Linux.

Thank you,
Martin


