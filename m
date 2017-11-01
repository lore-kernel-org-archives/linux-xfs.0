Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:53144 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751958AbdKABv3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 21:51:29 -0400
MIME-Version: 1.0
In-Reply-To: <20171031003358.GD5858@dastard>
References: <CAM_iQpU9A+KpSdXceUuz-cUX+f91bttKwJCOE91LnTZmKofk_Q@mail.gmail.com>
 <20171031003358.GD5858@dastard>
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 31 Oct 2017 18:51:08 -0700
Message-ID: <CAM_iQpUD5ffaKS7TQ5n9A67TWqrVm8AVKf6ERz3pSFu7rL2rbg@mail.gmail.com>
Subject: Re: xfs: list corruption in xfs_setup_inode()
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Oct 30, 2017 at 5:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Oct 30, 2017 at 02:55:43PM -0700, Cong Wang wrote:
>> Hello,
>>
>> We triggered a list corruption (double add) warning below on our 4.9
>> kernel (the 4.9 kernel we use is based on -stable release, with only a
>> few unrelated networking backports):
>>
>>
>> WARNING: CPU: 5 PID: 628 at lib/list_debug.c:36 __list_add+0xac/0xb0
>> list_add double add: new=ffff8d9d691e0aa0, prev=ffff8d9d7a716608,
>> next=ffff8d9d691e0aa0.
>> Modules linked in: raid0 tcp_diag inet_diag intel_rapl
>> x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support
>> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mpt3sas raid_class
>> scsi_transport_sas i2c_i801 i2c_smbus i2c_core ie31200_edac lpc_ich
>> shpchp edac_core video ipmi_si ipmi_devintf ipmi_msghandler
>> acpi_cpufreq sch_fq_codel xfs libcrc32c crc32c_intel e1000e ptp
>> pps_core
>> CPU: 5 PID: 628 Comm: systemd-tmpfile Tainted: G        W
>
> Kernel was already tainted before this warning was triggered. What
> was the previous warning(s) that the kernel threw?

Ah, there was a same warning right before the above one:


:[   19.953754] EXT4-fs (md0): mounted filesystem with writeback data
mode. Opts: errors=remount-ro,data=writeback
:[   19.979051] ------------[ cut here ]------------
:[   19.979216] WARNING: CPU: 3 PID: 628 at lib/list_debug.c:36
__list_add+0xac/0xb0
:[   19.979470] list_add double add: new=ffff8d9d691d72a0,
prev=ffff8d9d7a716608, next=ffff8d9d691d72a0.
:[   19.979780] Modules linked in: raid0 tcp_diag inet_diag intel_rapl
x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel mpt3sas raid_class
scsi_transport_sas i2c_i801 i2c_smbus i2c_core ie31200_edac lpc_ich
shpchp edac_core video ipmi_si ipmi_devintf ipmi_msghandler
acpi_cpufreq sch_fq_codel xfs libcrc32c crc32c_intel e1000e ptp
pps_core
:[   19.981201] CPU: 3 PID: 628 Comm: systemd-tmpfile Not tainted
4.9.34.el7.x86_64 #1
:[   19.981491] Hardware name: TYAN S5512/S5512, BIOS V8.B13 03/20/2014
:[   19.981706]  ffffb0d48a0abb30 ffffffff8e389f47 ffffb0d48a0abb80
0000000000000000
:[   19.982000]  ffffb0d48a0abb70 ffffffff8e08989b 0000002400000000
ffff8d9d691d72a0
:[   19.982278]  ffff8d9d7a716608 ffff8d9d691d72a0 0000000000004000
ffff8d9d7de6d800
:[   19.982555] Call Trace:
:[   19.982645]  [<ffffffff8e389f47>] dump_stack+0x4d/0x66
:[   19.982823]  [<ffffffff8e08989b>] __warn+0xcb/0xf0
:[   19.983007]  [<ffffffff8e08991f>] warn_slowpath_fmt+0x5f/0x80
:[   19.983205]  [<ffffffff8e3a979c>] __list_add+0xac/0xb0
:[   19.983383]  [<ffffffff8e2355bb>] inode_sb_list_add+0x3b/0x50
:[   19.983610]  [<ffffffffc040157c>] xfs_setup_inode+0x2c/0x170 [xfs]
:[   19.983837]  [<ffffffffc0402097>] xfs_ialloc+0x317/0x5c0 [xfs]
:[   19.984072]  [<ffffffffc0404347>] xfs_dir_ialloc+0x77/0x220 [xfs]
:[   19.984283]  [<ffffffff8e74cf32>] ? down_write+0x12/0x40
:[   19.984481]  [<ffffffffc0404972>] xfs_create+0x482/0x760 [xfs]
:[   19.984697]  [<ffffffffc04019ae>] xfs_generic_create+0x21e/0x2c0 [xfs]
:[   19.984955]  [<ffffffffc0401a84>] xfs_vn_mknod+0x14/0x20 [xfs]
:[   19.985171]  [<ffffffffc0401aa6>] xfs_vn_mkdir+0x16/0x20 [xfs]
:[   19.985373]  [<ffffffff8e226698>] vfs_mkdir+0xe8/0x140
:[   19.985551]  [<ffffffff8e22aa4a>] SyS_mkdir+0x7a/0xf0
:[   19.985726]  [<ffffffff8e74f8e0>] entry_SYSCALL_64_fastpath+0x13/0x94
:[   19.985987] ---[ end trace b461c28386dac363 ]---
:[   19.987613] ------------[ cut here ]------------



>
>> 4.9.34.el7.x86_64 #1
>> Hardware name: TYAN S5512/S5512, BIOS V8.B13 03/20/2014
>>  ffffb0d48a0abb30 ffffffff8e389f47 ffffb0d48a0abb80 0000000000000000
>>  ffffb0d48a0abb70 ffffffff8e08989b 0000002400000000 ffff8d9d691e0aa0
>>  ffff8d9d7a716608 ffff8d9d691e0aa0 0000000000004000 ffff8d9d7de6d800
>> Call Trace:
>>  [<ffffffff8e389f47>] dump_stack+0x4d/0x66
>>  [<ffffffff8e08989b>] __warn+0xcb/0xf0
>>  [<ffffffff8e08991f>] warn_slowpath_fmt+0x5f/0x80
>>  [<ffffffff8e3a979c>] __list_add+0xac/0xb0
>>  [<ffffffff8e2355bb>] inode_sb_list_add+0x3b/0x50
>>  [<ffffffffc040157c>] xfs_setup_inode+0x2c/0x170 [xfs]
>>  [<ffffffffc0402097>] xfs_ialloc+0x317/0x5c0 [xfs]
>>  [<ffffffffc0404347>] xfs_dir_ialloc+0x77/0x220 [xfs]
>
> Inode allocation, so should be a new inode straight from the slab
> cache. THat implies memory corruption of some kind. Please turn on
> slab poisoning and try to reproduce.

Are you sure? xfs_iget() seems searching in a cache before allocating
a new one:

        ip = radix_tree_lookup(&pag->pag_ici_root, agino);

        if (ip) {
                error = xfs_iget_cache_hit(pag, ip, ino, flags, lock_flags);
                if (error)
                        goto out_error_or_again;
        } else {
                rcu_read_unlock();
                if (flags & XFS_IGET_INCORE) {
                        error = -ENOENT;
                        goto out_error_or_again;
                }
                XFS_STATS_INC(mp, xs_ig_missed);

                error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip,
                                                        flags, lock_flags);
                if (error)
                        goto out_error_or_again;
        }


>
>>  [<ffffffff8e74cf32>] ? down_write+0x12/0x40
>>  [<ffffffffc0404972>] xfs_create+0x482/0x760 [xfs]
>>  [<ffffffffc04019ae>] xfs_generic_create+0x21e/0x2c0 [xfs]
>>  [<ffffffffc0401a84>] xfs_vn_mknod+0x14/0x20 [xfs]
>>  [<ffffffffc0401aa6>] xfs_vn_mkdir+0x16/0x20 [xfs]
>>  [<ffffffff8e226698>] vfs_mkdir+0xe8/0x140
>>  [<ffffffff8e22aa4a>] SyS_mkdir+0x7a/0xf0
>>  [<ffffffff8e74f8e0>] entry_SYSCALL_64_fastpath+0x13/0x94
>>
>> _Without_ looking deeper, it seems this warning could be shut up by:
>>
>> --- a/fs/xfs/xfs_icache.c
>> +++ b/fs/xfs/xfs_icache.c
>> @@ -1138,6 +1138,8 @@ xfs_reclaim_inode(
>>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
>>
>>         XFS_STATS_INC(ip->i_mount, xs_ig_reclaims);
>> +
>> +       inode_sb_list_del(VFS_I(ip));
>>
>> with properly exporting inode_sb_list_del(). Does this make any sense?
>
> No, because by this stage the inode has already been removed from
> the superblock indoe list. Doing this sort of thing here would just
> paper over whatever the underlying problem might be.


For me, it looks like the inode in the cache pag->pag_ici_root
is not removed from sb list before removing from cache. Existing
RCU readers could still read and add it to sb list again before the
RCU callback executes. This could also explain why it is not
easy to trigger (only two people including me reported it so far).


>
>> Please let me know if I can provide any other information.
>
> How do you reproduce the problem?


The warning is reported via ABRT email, we don't know what was
happening at the time of crash.


Thanks!
