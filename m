Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:36369 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752813AbdFPS5o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2017 14:57:44 -0400
Received: by mail-ua0-f181.google.com with SMTP id g40so30692714uaa.3
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 11:57:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d2778fc2-8363-187e-1ba2-ecdc8ced35b7@sandeen.net>
References: <CAHeTc0YizqSC55utPpe+Rsupv+G1qd2Es2a-6V3PFtf8NxnfOQ@mail.gmail.com>
 <d2778fc2-8363-187e-1ba2-ecdc8ced35b7@sandeen.net>
From: Brian Matheson <bmath@paperspace.com>
Date: Fri, 16 Jun 2017 14:57:32 -0400
Message-ID: <CAHeTc0a3kFpZEyBV4RoDe+N4dPtEFtRN7aay8+JCz9F+iu1rpw@mail.gmail.com>
Subject: Re: memory allocation deadlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Thanks for the reply, Eric.

I don't have data for each of the files handy, but this particular
filesystem was at 46% fragmentation before our first run and went down
to 35% after.  It's currently at 24%.  The fsr run reports that many
of the files are fully defragmented but some have as many as 40,000
extents.

Preventing the fragmentation by setting the extent size would be
great, but I understand that operation only works if there are no
extents in the file at the time of the operation.  Since we're
creating the files on a hypervisor that's nfs mounting the xfs fs, it
would be tricky to insert a step to set the extent size hits at file
creation time.

We'd prefer to avoid dropping the caches, and maybe instead tune
vm.vfs_cache_pressure or use some other mechanism to prevent these
problems.  We're not in a position to experiment right now though, and
are looking for recommendations.

Do you think fragmentation is the root of the problem, even at 24%
fragmentation for the fs?

On Fri, Jun 16, 2017 at 2:14 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 6/16/17 12:10 PM, Brian Matheson wrote:
>> Hi all,
>>
>> I'm writing to get some information about a problem we're seeing on
>> our nfs servers.  We're using XFS on an LVM volume backed by an LSI
>> RAID card (raid 6, with 24 SSDs).  We're nfs exporting the volume to a
>> number of hypervisors.  We're seeing messages like the following:
>>
>> Jun 16 09:22:30 ny2r3s1 kernel: [15259176.032579] XFS: nfsd(2301)
>> possible memory allocation deadlock size 68256 in kmem_alloc
>> (mode:0x2400240)
>>
>> These messages are followed by nfsd failures as indicated by log messages like:
>>
>> Jun 16 09:22:39 ny2r3s1 kernel: [15259184.933311] nfsd: peername
>> failed (err 107)!
>>
>> Dropping the caches on the box fixes the problem immediately.  Based
>> on a little research, we thought that the problem could be occurring
>> due to file fragmentation, so we're running xfs_fsr periodically to
>> defragment.  At the moment we're also periodically dropping the cache
>> in an attempt to prevent the problem from occurring.
>
> A better approach might be to set extent size hints on the fragmented
> files in question, to avoid the fragmentation in the first place.
>
> drop caches is a pretty big hammer, and xfs_fsr can have other side
> effects w.r.t. filesystem aging and freespace fragmentation.
>
> How badly fragmented were the files in question?
>
> -Eric
>
>> Any help appreciated, and if this query belongs on a different mailing
>> list, please let me know.
>>
>>
>> The systems are running ubuntu 14.04 with a 4.4.0 kernel (Linux
>> ny2r3s1 4.4.0-53-generic #74~14.04.1-Ubuntu SMP Fri Dec 2 03:43:31 UTC
>> 2016 x86_64 x86_64 x86_64 GNU/Linux).  xfs_repair is version 3.1.9.
>> They have 64G of RAM, most of which is used by cache, and 12 cpu
>> cores.  As mentioned we're using ssds connected to an lsi raid card.
>> xfs_info reports:
>>
>> meta-data=/dev/mapper/VMSTORAGE_SSD-XFS_VHD isize=256    agcount=62,
>> agsize=167772096 blks
>>          =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=10311515136, imaxpct=5
>>          =                       sunit=64     swidth=256 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal               bsize=4096   blocks=521728, version=2
>>          =                       sectsz=512   sunit=64 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>
>> At the moment, slabtop reports this:
>>  Active / Total Objects (% used)    : 5543699 / 5668921 (97.8%)
>>  Active / Total Slabs (% used)      : 157822 / 157822 (100.0%)
>>  Active / Total Caches (% used)     : 77 / 144 (53.5%)
>>  Active / Total Size (% used)       : 1110436.20K / 1259304.73K (88.2%)
>>  Minimum / Average / Maximum Object : 0.01K / 0.22K / 18.50K
>>
>>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>> 4382508 4382508 100%    0.10K 112372       39    449488K buffer_head
>> 348152 348152 100%    0.57K  12434       28    198944K radix_tree_node
>> 116880  83796  71%    4.00K  14610        8    467520K kmalloc-4096
>> 114492  88855  77%    0.09K   2726       42     10904K kmalloc-96
>> 108640  86238  79%    0.12K   3395       32     13580K kmalloc-128
>>  51680  51680 100%    0.12K   1520       34      6080K kernfs_node_cache
>>  49536  29011  58%    0.06K    774       64      3096K kmalloc-64
>>  46464  46214  99%    0.03K    363      128      1452K kmalloc-32
>>  44394  34860  78%    0.19K   1057       42      8456K dentry
>>  40188  38679  96%    0.04K    394      102      1576K ext4_extent_status
>>  33150  31649  95%    0.05K    390       85      1560K ftrace_event_field
>>  26207  25842  98%    0.05K    359       73      1436K Acpi-Parse
>>  23142  20528  88%    0.38K    551       42      8816K mnt_cache
>>  21756  21515  98%    0.19K    518       42      4144K kmalloc-192
>>  20160  20160 100%    0.07K    360       56      1440K Acpi-Operand
>>  19800  19800 100%    0.18K    450       44      3600K xfs_log_ticket
>>
>> Thanks much,
>> Brian Matheson
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
