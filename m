Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:47051 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752661AbdLHIak (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Dec 2017 03:30:40 -0500
MIME-Version: 1.0
In-Reply-To: <20171208013819.GN4094@dastard>
References: <CAHsD-6DNpb2+dE-yVUis35=AGOS0GoFnpT42A2vktW5HCOthMQ@mail.gmail.com>
 <20171208013819.GN4094@dastard>
From: Dinesh Pathak <dinesh.pathak@gmail.com>
Date: Fri, 8 Dec 2017 14:00:19 +0530
Message-ID: <CAHsD-6BuJe0LbnkJGT=gtqLmQQYLbpk0z9hZvAYme2OSH6LXgA@mail.gmail.com>
Subject: Re: Traversing XFS mounted VM puts process in D state
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, rupesh bajaj <rupesh.bajaj@gmail.com>

On Fri, Dec 8, 2017 at 7:08 AM, Dave Chinner <david@fromorbit.com> wrote:
> [cc linux-xfs@vger.kernel.org]
>
> On Fri, Dec 08, 2017 at 06:42:32AM +0530, Dinesh Pathak wrote:
>> Hi, We are mounting and traversing one backup of a VM with XFS filesystem.
>> Sometimes during traversing, the process goes into D state and can not be
>> killed. Eventually system needs to IPMI rebooted. This happens once in 100
>> times.
>>
>> This VM backup is kept on NFS storage. So we first do NFS mounting. Then do
>> loopback mount of the partition which contain XFS. After that we traverse
>> the file system, but this traversing is not necessarily multi threaded (We
>> have seen the issue in both single-threaded and multi-threaded traversal)
>>
>> I see a similar problem reported here: https://access.redhat.com/
>> solutions/2456711
>> The resolution given here is to upgrade the linux kernel to
>> kernel-3.10.0-514.el7 RHSA-2016-2574
>> <https://rhn.redhat.com/errata/RHSA-2016-2574.html> RHEL7.3. Upgrading the
>> kernel may not be possible for us. Is there any patch/patches that we can
>> apply to fix this issue.
>
> Oh, it's RHEL kernel. This is not a mainline kernel so you need to
> report this to your local Red Hat support engineer rather than to
> upstream kernel lists.
>
> -Dave.

Hi Dave, Thanks for your time. The above link only reports a similar
bug, which has same kernel trace, which we found on internet. Our
client machine, where traversal is done, is using CentOS.

$ hostnamectl
   Static hostname: coh-tw-cl01-node-4
         Icon name: computer-server
           Chassis: server
        Machine ID: b38a4225b6544e20b25a2e55f63ed5fa
           Boot ID: 90dc6e0a0cdd4b6581ae62941d74587c
  Operating System: CentOS Linux 7 (Core)
       CPE OS Name: cpe:/o:centos:centos:7
            Kernel: Linux 3.10.0-327.22.2.el7.x86_64
      Architecture: x86-64

Thanks,
Dinesh

>
>> One more thread here says that this issue is fixed only in the above kernel
>> version. It is seen in previous as well as later versions.
>> https://bugs.centos.org/view.php?id=13843&history=1
>>
>> Is there anyway to reproduce this problem. All our efforts to reproduce
>> this issue have not succeeded.
>>
>> Please help me know if any more debugging can be done.
>>
>> Thanks,
>> Dinesh
>>
>> Kernel version of source VM, whose backup is taken.
>>
>> root@web-2318 ~]# uname -a
>>
>> Linux web-2318.website.oxilion.nl 3.10.0-514.26.2.el7.x86_64 #1 SMP Tue Jul
>> 4 15:04:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
>>
>>
>> Kernel version of the machine where backup is mounted and traversed.
>> 3.10.0-327.22.2.el7.x86_64 #1 SMP Tue Jul 5 12:41:09 PDT 2016 x86_64 x86_64
>> x86_64 GNU/Linux
>>
>>
>> Mon Dec  4 21:08:21 2017] yoda_exec       D 0000000000000000     0 48948  48938
>> 0x00000000
>>
>> [Mon Dec  4 21:08:21 2017]  ffff8801052437b0 0000000000000086
>> ffff88000aa02e00 ffff880105243fd8
>>
>> [Mon Dec  4 21:08:21 2017]  ffff880105243fd8 ffff880105243fd8
>> ffff88000aa02e00 ffff88010521e730
>>
>> [Mon Dec  4 21:08:21 2017]  7fffffffffffffff ffff88000aa02e00
>> 0000000000000002 0000000000000000
>>
>> [Mon Dec  4 21:08:21 2017] Call Trace:
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff8163b7f9>] schedule+0x29/0x70
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff816394e9>]
>> schedule_timeout+0x209/0x2d0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07a2e67>] ?
>> xfs_iext_bno_to_ext+0xa7/0x1a0 [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff8163ab22>] __down_common+0xd2/0x14a
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07b00cd>] ?
>> _xfs_buf_find+0x16d/0x2c0 [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff8163abb7>] __down+0x1d/0x1f
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff810ab921>] down+0x41/0x50
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07afecc>] xfs_buf_lock+0x3c/0xd0
>> [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07b00cd>] _xfs_buf_find+0x16d/0x2c0
>> [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07b024a>] xfs_buf_get_map+0x2a/0x180
>> [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07b0d2c>]
>> xfs_buf_read_map+0x2c/0x140 [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07dd829>]
>> xfs_trans_read_buf_map+0x199/0x400 [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa0790204>] xfs_da_read_buf+0xd4/0x100
>> [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa0790253>]
>> xfs_da3_node_read+0x23/0xd0 [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811c153a>] ?
>> kmem_cache_alloc+0x1ba/0x1d0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07914ce>]
>> xfs_da3_node_lookup_int+0x6e/0x2f0 [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa079bded>]
>> xfs_dir2_node_lookup+0x4d/0x170
>> [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07937b5>] xfs_dir_lookup+0x195/0x1b0
>> [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07c1bb6>] xfs_lookup+0x66/0x110 [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffffa07bea0b>] xfs_vn_lookup+0x7b/0xd0
>> [xfs]
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811e8cad>] lookup_real+0x1d/0x50
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811e9622>] __lookup_hash+0x42/0x60
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff8163342b>] lookup_slow+0x42/0xa7
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811ee4f3>] path_lookupat+0x773/0x7a0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff81186f6a>] ? kvfree+0x2a/0x40
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811c13b5>] ?
>> kmem_cache_alloc+0x35/0x1d0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811ef1ef>] ? getname_flags+0x4f/0x1a0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811ee54b>] filename_lookup+0x2b/0xc0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811f0317>]
>> user_path_at_empty+0x67/0xc0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811f0381>] user_path_at+0x11/0x20
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811e3bc3>] vfs_fstatat+0x63/0xc0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811e4191>] SYSC_newlstat+0x31/0x60
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811f27fc>] ? vfs_readdir+0x8c/0xe0
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811f2cad>] ? SyS_getdents+0xfd/0x120
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff811e441e>] SyS_newlstat+0xe/0x10
>>
>> [Mon Dec  4 21:08:21 2017]  [<ffffffff81646889>]
>> system_call_fastpath+0x16/0x1b
>
> --
> Dave Chinner
> david@fromorbit.com
