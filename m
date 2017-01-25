Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751990AbdAYPgL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jan 2017 10:36:11 -0500
Date: Wed, 25 Jan 2017 10:36:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Quota-enabled XFS hangs during mount
Message-ID: <20170125153610.GD28388@bfoster.bfoster>
References: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
 <20161101215803.GA14023@dastard>
 <cad65166-6d77-3c6f-151b-5970b1b6fc85@zoner.cz>
 <20161103013153.GH9920@dastard>
 <7993e9b8-6eb8-6a0d-aa72-01346cca1b63@zoner.cz>
 <20161103204049.GA28177@dastard>
 <43ca55d0-6762-d54f-5ba9-a83f9c1988f6@zoner.cz>
 <20170123134452.GA33287@bfoster.bfoster>
 <5b41d19b-1a0d-2b74-a633-30a5f6d2f14a@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b41d19b-1a0d-2b74-a633-30a5f6d2f14a@zoner.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Svec <martin.svec@zoner.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Tue, Jan 24, 2017 at 02:17:36PM +0100, Martin Svec wrote:
> Hello,
> 
> Dne 23.1.2017 v 14:44 Brian Foster napsal(a):
> > On Mon, Jan 23, 2017 at 10:44:20AM +0100, Martin Svec wrote:
> >> Hello Dave,
> >>
> >> Any updates on this? It's a bit annoying to workaround the bug by increasing RAM just because of the
> >> initial quotacheck.
> >>
> > Note that Dave is away on a bit of an extended vacation[1]. It looks
> > like he was in the process of fishing through the code to spot any
> > potential problems related to quotacheck+reclaim. I see you've cc'd him
> > directly so we'll see if we get a response wrt to if he got anywhere
> > with that...
> >
> > Skimming back through this thread, it looks like we have an issue where
> > quota check is not quite reliable in the event of reclaim, and you
> > appear to be reproducing this due to a probably unique combination of
> > large inode count and low memory.
> >
> > Is my understanding correct that you've reproduced this on more recent
> > kernels than the original report? 
> 
> Yes, I repeated the tests using 4.9.3 kernel on another VM where we hit this issue.
> 
> Configuration:
> * vSphere 5.5 virtual machine, 2 vCPUs, virtual disks residing on iSCSI VMFS datastore
> * Debian Jessie 64 bit webserver, vanilla kernel 4.9.3
> * 180 GB XFS data disk mounted as /www
> 
> Quotacheck behavior depends on assigned RAM:
> * 2 or less GiB: mount /www leads to a storm of OOM kills including shell, ttys etc., so the system
> becomes unusable.
> * 3 GiB: mount /www task hangs in the same way as I reported in earlier in this thread.
> * 4 or more GiB: mount /www succeeds.
> 
> The affected disk is checked using xfs_repair. I keep a VM snapshot to be able to reproduce the bug.
> Below is updated filesystem information and dmesg output:
> 
> ---------
> xfs-test:~# df -i
> Filesystem        Inodes   IUsed     IFree IUse% Mounted on
> /dev/sdd1      165312432 2475753 162836679    2% /www
> 
> ---------
> xfs-test:~# xfs_info /www
> meta-data=/dev/sdd1              isize=256    agcount=73, agsize=655232 blks
>          =                       sectsz=512   attr=2, projid32bit=0
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=47185664, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 

Ok, thanks.

> ---------
> slabtop, 3 GiB RAM:
> 
>  Active / Total Objects (% used)    : 3447273 / 3452076 (99.9%)
>  Active / Total Slabs (% used)      : 648365 / 648371 (100.0%)
>  Active / Total Caches (% used)     : 70 / 124 (56.5%)
>  Active / Total Size (% used)       : 2592192.04K / 2593485.27K (100.0%)
>  Minimum / Average / Maximum Object : 0.02K / 0.75K / 4096.00K
> 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 2477104 2477101  99%    1.00K 619276        4   2477104K xfs_inode
> 631904 631840  99%    0.03K   5096      124     20384K kmalloc-32
>  74496  74492  99%    0.06K   1164       64      4656K kmalloc-64
>  72373  72367  99%    0.56K  10339        7     41356K radix_tree_node
>  38410  38314  99%    0.38K   3841       10     15364K mnt_cache
>  31360  31334  99%    0.12K    980       32      3920K kmalloc-96
>  27574  27570  99%    0.12K    811       34      3244K kernfs_node_cache
>  19152  18291  95%    0.19K    912       21      3648K dentry
>  17312  17300  99%    0.12K    541       32      2164K kmalloc-node
>  14546  13829  95%    0.57K   2078        7      8312K inode_cache
>  11088  11088 100%    0.19K    528       21      2112K kmalloc-192
>   5432   5269  96%    0.07K     97       56       388K Acpi-Operand
>   3960   3917  98%    0.04K     40       99       160K Acpi-Namespace
>   3624   3571  98%    0.50K    453        8      1812K kmalloc-512
>   3320   3249  97%    0.05K     40       83       160K ftrace_event_field
>   3146   3048  96%    0.18K    143       22       572K vm_area_struct
>   2752   2628  95%    0.06K     43       64       172K anon_vma_chain
>   2640   1991  75%    0.25K    165       16       660K kmalloc-256
>   1748   1703  97%    0.09K     38       46       152K trace_event_file
>   1568   1400  89%    0.07K     28       56       112K anon_vma
>   1086   1035  95%    0.62K    181        6       724K proc_inode_cache
>    935    910  97%    0.67K     85       11       680K shmem_inode_cache
>    786    776  98%    2.00K    393        2      1572K kmalloc-2048
>    780    764  97%    1.00K    195        4       780K kmalloc-1024
>    525    341  64%    0.19K     25       21       100K cred_jar
>    408    396  97%    0.47K     51        8       204K xfs_da_state
>    336    312  92%    0.62K     56        6       224K sock_inode_cache
>    309    300  97%    2.05K    103        3       824K idr_layer_cache
>    256    176  68%    0.12K      8       32        32K pid
>    240      2   0%    0.02K      1      240         4K jbd2_revoke_table_s
>    231    231 100%    4.00K    231        1       924K kmalloc-4096
>    230    222  96%    3.31K    115        2       920K task_struct
>    224    205  91%    1.06K     32        7       256K signal_cache
>    213     26  12%    0.05K      3       71        12K Acpi-Parse
>    213    213 100%    2.06K     71        3       568K sighand_cache
>    189     97  51%    0.06K      3       63        12K fs_cache
>    187     86  45%    0.36K     17       11        68K blkdev_requests
>    163     63  38%    0.02K      1      163         4K numa_policy
> 
> ---------
> dmesg, 3 GiB RAM:
> 
> [  967.642413] INFO: task mount:669 blocked for more than 120 seconds.
> [  967.642456]       Tainted: G            E   4.9.3-znr1+ #24
> [  967.642510] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  967.642570] mount           D    0   669    652 0x00000000
> [  967.642573]  ffff8800b9b8ac00 0000000000000000 ffffffffa800e540 ffff880036b85200
> [  967.642575]  ffff8800bb618740 ffffc90000f87998 ffffffffa7a2802d ffff8800ba38e000
> [  967.642577]  ffffc90000f87998 00000000c021fd94 0002000000000000 ffff880036b85200
> [  967.642579] Call Trace:
> [  967.642586]  [<ffffffffa7a2802d>] ? __schedule+0x23d/0x6e0
> [  967.642588]  [<ffffffffa7a28506>] schedule+0x36/0x80
> [  967.642590]  [<ffffffffa7a2bbac>] schedule_timeout+0x21c/0x3c0
> [  967.642592]  [<ffffffffa774c3ab>] ? __radix_tree_lookup+0x7b/0xe0
> [  967.642594]  [<ffffffffa7a28fbb>] wait_for_completion+0xfb/0x140
> [  967.642596]  [<ffffffffa74ae1f0>] ? wake_up_q+0x70/0x70
> [  967.642654]  [<ffffffffc0225b32>] xfs_qm_flush_one+0x82/0xc0 [xfs]
> [  967.642684]  [<ffffffffc0225ab0>] ? xfs_qm_dqattach_one+0x120/0x120 [xfs]
> [  967.642712]  [<ffffffffc0225f1c>] xfs_qm_dquot_walk.isra.10+0xec/0x170 [xfs]
> [  967.642744]  [<ffffffffc0227f75>] xfs_qm_quotacheck+0x255/0x310 [xfs]
> [  967.642774]  [<ffffffffc0228114>] xfs_qm_mount_quotas+0xe4/0x170 [xfs]
> [  967.642800]  [<ffffffffc02042bd>] xfs_mountfs+0x62d/0x940 [xfs]
> [  967.642827]  [<ffffffffc0208eca>] xfs_fs_fill_super+0x40a/0x590 [xfs]
> [  967.642829]  [<ffffffffa761aa4a>] mount_bdev+0x17a/0x1b0
> [  967.642864]  [<ffffffffc0208ac0>] ? xfs_test_remount_options.isra.14+0x60/0x60 [xfs]
> [  967.642895]  [<ffffffffc0207b35>] xfs_fs_mount+0x15/0x20 [xfs]
> [  967.642897]  [<ffffffffa761b428>] mount_fs+0x38/0x170
> [  967.642900]  [<ffffffffa76390a4>] vfs_kern_mount+0x64/0x110
> [  967.642901]  [<ffffffffa763b7f5>] do_mount+0x1e5/0xcd0
> [  967.642903]  [<ffffffffa763b3ec>] ? copy_mount_options+0x2c/0x230
> [  967.642904]  [<ffffffffa763c5d4>] SyS_mount+0x94/0xd0
> [  967.642907]  [<ffffffffa7a2d0fb>] entry_SYSCALL_64_fastpath+0x1e/0xad
> 
> > If so and we don't hear back from Dave
> > in a reasonable time, it might be useful to provide a metadump of the fs
> > if possible. That would allow us to restore in a similar low RAM vm
> > configuration, trigger quota check and try to reproduce directly...
> 
> Unfortunately, the output of xfs_metadump apparently contains readable fragments of files! We cannot
> provide you such a dump from production server. Shouldn't metadump obfuscate metadata and ignore all
> filesystem data? Maybe it's a sign of filesystem corruption unrecognized by xfs_repair?
> 

It should, not sure what's going on there. Perhaps a metadump bug. We
can probably just create a filesystem with similar geometry and inode
population and see what happens with that...

Brian

> 
> Thank you,
> Martin
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
