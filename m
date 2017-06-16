Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:36614 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbdFPRKe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Jun 2017 13:10:34 -0400
Received: by mail-ua0-f181.google.com with SMTP id g40so29207901uaa.3
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 10:10:33 -0700 (PDT)
MIME-Version: 1.0
From: Brian Matheson <bmath@paperspace.com>
Date: Fri, 16 Jun 2017 13:10:32 -0400
Message-ID: <CAHeTc0YizqSC55utPpe+Rsupv+G1qd2Es2a-6V3PFtf8NxnfOQ@mail.gmail.com>
Subject: memory allocation deadlock
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

I'm writing to get some information about a problem we're seeing on
our nfs servers.  We're using XFS on an LVM volume backed by an LSI
RAID card (raid 6, with 24 SSDs).  We're nfs exporting the volume to a
number of hypervisors.  We're seeing messages like the following:

Jun 16 09:22:30 ny2r3s1 kernel: [15259176.032579] XFS: nfsd(2301)
possible memory allocation deadlock size 68256 in kmem_alloc
(mode:0x2400240)

These messages are followed by nfsd failures as indicated by log messages like:

Jun 16 09:22:39 ny2r3s1 kernel: [15259184.933311] nfsd: peername
failed (err 107)!

Dropping the caches on the box fixes the problem immediately.  Based
on a little research, we thought that the problem could be occurring
due to file fragmentation, so we're running xfs_fsr periodically to
defragment.  At the moment we're also periodically dropping the cache
in an attempt to prevent the problem from occurring.

Any help appreciated, and if this query belongs on a different mailing
list, please let me know.


The systems are running ubuntu 14.04 with a 4.4.0 kernel (Linux
ny2r3s1 4.4.0-53-generic #74~14.04.1-Ubuntu SMP Fri Dec 2 03:43:31 UTC
2016 x86_64 x86_64 x86_64 GNU/Linux).  xfs_repair is version 3.1.9.
They have 64G of RAM, most of which is used by cache, and 12 cpu
cores.  As mentioned we're using ssds connected to an lsi raid card.
xfs_info reports:

meta-data=/dev/mapper/VMSTORAGE_SSD-XFS_VHD isize=256    agcount=62,
agsize=167772096 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=10311515136, imaxpct=5
         =                       sunit=64     swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

At the moment, slabtop reports this:
 Active / Total Objects (% used)    : 5543699 / 5668921 (97.8%)
 Active / Total Slabs (% used)      : 157822 / 157822 (100.0%)
 Active / Total Caches (% used)     : 77 / 144 (53.5%)
 Active / Total Size (% used)       : 1110436.20K / 1259304.73K (88.2%)
 Minimum / Average / Maximum Object : 0.01K / 0.22K / 18.50K

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
4382508 4382508 100%    0.10K 112372       39    449488K buffer_head
348152 348152 100%    0.57K  12434       28    198944K radix_tree_node
116880  83796  71%    4.00K  14610        8    467520K kmalloc-4096
114492  88855  77%    0.09K   2726       42     10904K kmalloc-96
108640  86238  79%    0.12K   3395       32     13580K kmalloc-128
 51680  51680 100%    0.12K   1520       34      6080K kernfs_node_cache
 49536  29011  58%    0.06K    774       64      3096K kmalloc-64
 46464  46214  99%    0.03K    363      128      1452K kmalloc-32
 44394  34860  78%    0.19K   1057       42      8456K dentry
 40188  38679  96%    0.04K    394      102      1576K ext4_extent_status
 33150  31649  95%    0.05K    390       85      1560K ftrace_event_field
 26207  25842  98%    0.05K    359       73      1436K Acpi-Parse
 23142  20528  88%    0.38K    551       42      8816K mnt_cache
 21756  21515  98%    0.19K    518       42      4144K kmalloc-192
 20160  20160 100%    0.07K    360       56      1440K Acpi-Operand
 19800  19800 100%    0.18K    450       44      3600K xfs_log_ticket

Thanks much,
Brian Matheson
