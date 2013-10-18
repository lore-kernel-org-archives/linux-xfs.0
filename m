Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0F8257F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 12:03:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E3A028F804C
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:03:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OVTgbnmqJDhUxMdP for
	<xfs@oss.sgi.com>; Fri, 18 Oct 2013 10:03:11 -0700 (PDT)
Message-ID: <526169CA.2020404@redhat.com>
Date: Fri, 18 Oct 2013 13:03:06 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/10] xfs: introduce the free inode btree
References: <1381342018-35829-1-git-send-email-bfoster@redhat.com>
	<5261633E.8050504@gmail.com> <526168BA.2000002@redhat.com>
In-Reply-To: <526168BA.2000002@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michael Semon <mlsemon35@gmail.com>
Cc: xfs@oss.sgi.com

[ cc list ]

On 10/18/2013 12:58 PM, Brian Foster wrote:
> On 10/18/2013 12:35 PM, Michael Semon wrote:
>> On 10/9/2013 2:06 PM, Brian Foster wrote:
>>> Hi all,
>>>
>>> Here is the first release of free inode btree support for the kernel. It
>>> is based on the RFC previously made available here:
>>>
>>> http://oss.sgi.com/archives/xfs/2013-09/msg00076.html
>>>
>>> The free inode btree adds a new inode btree to XFS with the intent to
>>> track only inode chunks with at least one free inode. Patches 1-3 add
>>> the necessary support for the new XFS_BTNUM_FINOBT type and introduce a
>>> read-only v5 superblock flag. Patch 4 updates the transaction
>>> reservations for inode allocation operations to account for the finobt.
>>> Patches 5-9 add support to manage the finobt on inode chunk allocation,
>>> inode allocation, inode free (and chunk deletion) and growfs. The 10th
>>> and final patch adds the feature bit to the associated mask. Thoughts,
>>> reviews and flames appreciated.
>>>
>>> Brian
>>
>> OK, I'm giving this a go on x86, and xfstests generic/* seems to be OK.
>>  lockdep is happy so far.  The merge was straightforward but not
>> automatic by any means.  However, there was a crash on xfs/030, and
>> I'm sending a simple crash log because I'm on vacation, and my test
>> setup is not up to snuff (no serial, one drive dying, bad Internet
>> connection, etc.).
>>
> 
> Hi Michael,
> 
> Interesting notion of vacation you have there. ;)
> 
> Yes, I'm aware of this issue. This is due to the current lack of
> xfs_repair support for finobt. xfs_repair scans the existing inode btree
> into memory and actually regenerates and writes out a new inode btree
> afterwards. This doesn't yet happen for the finobt, so xfs_repair
> effectively zeroes out (corrupts) the finobt root/level fields in the
> agi and leads to this explosion. In short, you'll want to run xfstests
> with "-x repair" until that support is added.
> 
> Now that I think of it, this should probably manifest as an fs shutdown
> or something more graceful than a panic. I'll look into that. Thanks for
> testing!
> 
> Brian
> 
>> The merge against xfsprogs went fairly smoothly.
>>
>> Both merges were over the top of some of Dave's recent work, and maybe
>> that's why they weren't automatic.
>>
>> Thanks!
>>
>> Michael
>>
>> [`crash` session follows]
>>
>> Script started on Thu 17 Oct 2013 07:21:41 PM EDT
>> root:/usr/src/dumps# crash vmlinux current-crash
>>
>> crash 7.0.2
>> Copyright (C) 2002-2013  Red Hat, Inc.
>> Copyright (C) 2004, 2005, 2006, 2010  IBM Corporation
>> Copyright (C) 1999-2006  Hewlett-Packard Co
>> Copyright (C) 2005, 2006, 2011, 2012  Fujitsu Limited
>> Copyright (C) 2006, 2007  VA Linux Systems Japan K.K.
>> Copyright (C) 2005, 2011  NEC Corporation
>> Copyright (C) 1999, 2002, 2007  Silicon Graphics, Inc.
>> Copyright (C) 1999, 2000, 2001, 2002  Mission Critical Linux, Inc.
>> This program is free software, covered by the GNU General Public License,
>> and you are welcome to change it and/or distribute copies of it under
>> certain conditions.  Enter "help copying" to see the conditions.
>> This program has absolutely no warranty.  Enter "help warranty" for
>> details.
>>
>> GNU gdb (GDB) 7.6
>> Copyright (C) 2013 Free Software Foundation, Inc.
>> License GPLv3+: GNU GPL version 3 or later
>> <http://gnu.org/licenses/gpl.html>
>> This is free software: you are free to change and redistribute it.
>> There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
>> and "show warranty" for details.
>> This GDB was configured as "i686-pc-linux-gnu"...
>>
>> please wait... (gathering kmem slab cache data)
>> WARNING: cannot determine how modules are linked
>> WARNING: no kernel module access
>>
>> please wait... (gathering task table data)
>> please wait... (determining panic task)
>>       KERNEL: vmlinux
>>     DUMPFILE: current-crash
>>         CPUS: 1
>>         DATE: Thu Oct 17 18:53:48 2013
>>       UPTIME: 02:40:00
>> LOAD AVERAGE: 1.50, 18.11, 24.54
>>        TASKS: 77
>>     NODENAME: plbearer
>>      RELEASE: 3.12.0-rc4+
>>      VERSION: #7 Thu Oct 17 15:30:41 EDT 2013
>>      MACHINE: i686  (1794 Mhz)
>>       MEMORY: 510.6 MB
>>        PANIC: "Oops: 0000 [#1] DEBUG_PAGEALLOC" (check log for details)
>>          PID: 9475
>>      COMMAND: "dd"
>>         TASK: de0b9430  [THREAD_INFO: d350c000]
>>          CPU: 0
>>        STATE: TASK_RUNNING (PANIC)
>>
>> crash> ps
>>    PID    PPID  CPU   TASK    ST  %MEM     VSZ    RSS  COMM
>>       0      0   0  c174f620  RU   0.0       0      0  [swapper]
>>       1      0   0  c0058000  IN   0.0    2116     76  init
>>       2      0   0  c0059430  IN   0.0       0      0  [kthreadd]
>>       3      2   0  c005a860  IN   0.0       0      0  [ksoftirqd/0]
>>       5      2   0  c005d0c0  IN   0.0       0      0  [kworker/0:0H]
>>       7      2   0  c0118000  IN   0.0       0      0  [watchdog/0]
>>       8      2   0  c0119430  IN   0.0       0      0  [khelper]
>>       9      2   0  c011a860  IN   0.0       0      0  [kdevtmpfs]
>>      10      2   0  c011bc90  IN   0.0       0      0  [writeback]
>>      11      2   0  c011d0c0  IN   0.0       0      0  [bioset]
>>      12      2   0  c011e4f0  IN   0.0       0      0  [kblockd]
>>      13      2   0  c01b8000  IN   0.0       0      0  [ata_sff]
>>      14      2   0  c01b9430  IN   0.0       0      0  [khubd]
>>      17      2   0  c01bd0c0  IN   0.0       0      0  [rt-test-0]
>>      18      2   0  c01be4f0  IN   0.0       0      0  [rt-test-1]
>>      19      2   0  c01bbc90  IN   0.0       0      0  [rt-test-2]
>>      20      2   0  c0298000  IN   0.0       0      0  [rt-test-3]
>>      21      2   0  c0299430  IN   0.0       0      0  [rt-test-4]
>>      22      2   0  c029a860  IN   0.0       0      0  [rt-test-5]
>>      23      2   0  c029bc90  IN   0.0       0      0  [rt-test-6]
>>      24      2   0  c029d0c0  IN   0.0       0      0  [rt-test-7]
>>      25      2   0  c029e4f0  IN   0.0       0      0  [khungtaskd]
>>      26      2   0  c02b8000  IN   0.0       0      0  [kswapd0]
>>      27      2   0  c02b9430  IN   0.0       0      0  [fsnotify_mark]
>>      28      2   0  c02ba860  IN   0.0       0      0  [cifsiod]
>>      29      2   0  c02bbc90  IN   0.0       0      0  [jfsIO]
>>      30      2   0  c02bd0c0  IN   0.0       0      0  [jfsCommit]
>>      31      2   0  c02be4f0  IN   0.0       0      0  [jfsSync]
>>      32      2   0  de998000  IN   0.0       0      0  [xfsalloc]
>>      33      2   0  de999430  IN   0.0       0      0  [xfs_mru_cache]
>>      34      2   0  de99a860  IN   0.0       0      0  [xfslogd]
>>      35      2   0  de99bc90  IN   0.0       0      0  [bioset]
>>      36      2   0  de99d0c0  IN   0.0       0      0  [crypto]
>>      52      2   0  de9d1430  IN   0.0       0      0  [scsi_eh_0]
>>      53      2   0  de9d0000  IN   0.0       0      0  [scsi_eh_1]
>>      56      2   0  de9d50c0  IN   0.0       0      0  [kpsmoused]
>>      60      2   0  dead9430  IN   0.0       0      0  [kworker/0:1H]
>>      61      2   0  deada860  IN   0.0       0      0  [kmemleak]
>>      62      2   0  deadbc90  IN   0.0       0      0  [deferwq]
>>     121      1   0  debd2860  IN   0.0    2168    260  syslogd
>>     126      1   0  debd64f0  IN   0.0    2112    232  klogd
>>     233      1   0  debd3c90  IN   0.1    5024    480  ntpd
>>     238      1   0  debd50c0  IN   0.0    2128     52  acpid
>>     240      1   0  deadd0c0  IN   0.0    2456      4  gpm
>>     242      1   0  debd0000  IN   0.0    2348    172  crond
>>     244      1   0  de550000  IN   0.0    2340      4  atd
>>     250      1   0  de552860  IN   0.0    3828      4  bash
>>     251      1   0  de553c90  IN   0.0    3828      4  bash
>>     252      1   0  de5550c0  IN   0.0    3832      4  bash
>>     253      1   0  de5564f0  IN   0.0    3828      4  bash
>>     254      1   0  deade4f0  IN   0.0    2352      4  agetty
>>    3574      2   0  c235bc90  IN   0.0       0      0  [kworker/u2:1]
>>    8980      2   0  d7e62860  IN   0.0       0      0  [xfs-data/sda4]
>>    8981      2   0  d7e60000  IN   0.0       0      0  [xfs-conv/sda4]
>>    8982      2   0  d7e664f0  IN   0.0       0      0  [xfs-cil/sda4]
>>    8983      2   0  d7e61430  IN   0.0       0      0  [xfsaild/sda4]
>>    9003  26905   0  d7cae4f0  IN   0.3    3512   1744  030
>>    9223   9003   0  d7e63c90  IN   0.2    3532   1256  030
>>    9224   9003   0  d7e650c0  IN   0.1    2224    596  sed
>>    9465      2   0  d08250c0  IN   0.0       0      0  [xfs-data/sda5]
>>    9466      2   0  d0822860  IN   0.0       0      0  [xfs-conv/sda5]
>>    9467      2   0  d08264f0  IN   0.0       0      0  [xfs-cil/sda5]
>>    9468      2   0  d0823c90  IN   0.0       0      0  [xfsaild/sda5]
>>    9469   9223   0  d7cad0c0  IN   0.2    3540   1176  030
>>    9470   9223   0  d7cabc90  IN   0.2    3532   1060  030
>>    9471   9470   0  d7caa860  IN   0.1    2184    456  fgrep
>>>  9475   9469   0  de0b9430  RU   0.1    2008    384  dd
>>   11362      2   0  de2b0000  IN   0.0       0      0  [kworker/0:2]
>>   11364      2   0  de0bd0c0  IN   0.0       0      0  [kworker/0:3]
>>   16034      2   0  d0821430  IN   0.0       0      0  [kworker/0:8]
>>   16748      2   0  d7ca9430  IN   0.0       0      0  [kworker/0:14]
>>   17966      2   0  c235d0c0  IN   0.0       0      0  [kworker/u2:2]
>>   20267    251   0  de2b64f0  IN   0.1    2684    444  watch
>>   26881      1   0  de0be4f0  IN   0.0    3824      4  bash
>>   26905  26881   0  de0bbc90  IN   0.2    4072   1196  check
>>   29183    250   0  de0b8000  IN   0.0    2384     40  cat
>>   29240      2   0  de2b3c90  IN   0.0       0      0  [kworker/u2:0]
>> crash> log -t # trimmed
>> XFS (sda5): Using inode cluster size of 16384 bytes
>> XFS (sda5): Mounting Filesystem
>> XFS (sda5): Ending clean mount
>> BUG: unable to handle kernel NULL pointer dereference at 00000006
>> IP: [<c11e098f>] xfs_btree_lookup+0x1b4/0x42a
>> *pde = 00000000
>> Oops: 0000 [#1] DEBUG_PAGEALLOC
>> CPU: 0 PID: 9475 Comm: dd Not tainted 3.12.0-rc4+ #7
>> Hardware name: Dell Computer Corporation Dimension 2350/07W080, BIOS A01
>> 12/17/2 002
>> task: de0b9430 ti: d350c000 task.ti: d350c000
>> EIP: 0060:[<c11e098f>] EFLAGS: 00010286 CPU: 0
>> EIP is at xfs_btree_lookup+0x1b4/0x42a
>> EAX: 00000000 EBX: deb11390 ECX: 00000000 EDX: c0187a80
>> ESI: 00000060 EDI: ffffffff EBP: d350dc10 ESP: d350dbd0
>>  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
>> CR0: 8005003b CR2: 00000006 CR3: 0ec44000 CR4: 000007d0
>> Stack:
>>  00000060 c41c5a00 c0028200 00000001 d350dc54 ffffffff 00000001 00000000
>>  00000000 00000000 d350dc10 c11fb45e de67ee00 deb11390 00000060 00000000
>>  d350dc88 c11f921d 00000000 00000004 00000001 00000246 c120c778 de26d800
>> Call Trace:
>>  [<c11fb45e>] ? xfs_inobt_init_cursor+0x2c/0x91
>>  [<c11f921d>] xfs_dialloc_ag+0x223/0x7fb
>>  [<c120c778>] ? xfs_perag_get+0xb8/0x21c
>>  [<c11fa087>] ? xfs_ialloc_read_agi+0x3a/0x95
>>  [<c11fa0bf>] ? xfs_ialloc_read_agi+0x72/0x95
>>  [<c11facd7>] ? xfs_dialloc+0x229/0x272
>>  [<c11faafd>] xfs_dialloc+0x4f/0x272
>>  [<c11fc8a9>] xfs_ialloc+0x4d/0x6f1
>>  [<c11fb83b>] ? xfs_ilock+0x100/0x1f1
>>  [<c11fcfc0>] xfs_dir_ialloc+0x73/0x245
>>  [<c11fb83b>] ? xfs_ilock+0x100/0x1f1
>>  [<c11fd3bf>] ? xfs_create+0x1b1/0x73e
>>  [<c11fd591>] xfs_create+0x383/0x73e
>>  [<c11b3091>] xfs_vn_mknod+0xb0/0x175
>>  [<c11b3156>] ? xfs_vn_mknod+0x175/0x175
>>  [<c11b3170>] xfs_vn_create+0x1a/0x1c
>>  [<c10e92f6>] vfs_create+0x69/0xc8
>>  [<c10e9a7d>] do_last.isra.48+0x728/0xd54
>>  [<c10e7c0f>] ? link_path_walk+0x54/0x6da
>>  [<c10ea151>] path_openat+0xa8/0x53c
>>  [<c1059fc5>] ? local_clock+0x3d/0x58
>>  [<c10ea616>] do_filp_open+0x31/0x72
>>  [<c10dd812>] do_sys_open+0x116/0x1de
>>  [<c156d9f2>] ? sysenter_exit+0xf/0x1d
>>  [<c10dd8fc>] SyS_open+0x22/0x24
>>  [<c156d9bf>] sysenter_do_call+0x12/0x36
>> Code: fa 1f 89 d0 2b 45 d8 1b 55 dc 89 d0 c1 e8 1f 74 0c 83 7d cc 01 0f
>> 94 c0 3c  01 83 d7 ff 89 7b 4c 85 ff 0f 84 84 01 00 00 8b 45 e0 <0f> b7
>> 40 06 86 e0 0f b7  c0 39 f8 0f 8c 70 01 00 00 8b 45 d8 8b
>> EIP: [<c11e098f>] xfs_btree_lookup+0x1b4/0x42a SS:ESP 0068:d350dbd0
>> CR2: 0000000000000006
>> crash> bt
>> PID: 9475   TASK: de0b9430  CPU: 0   COMMAND: "dd"
>>  #0 [d350da64] crash_kexec at c1080ca0
>>  #1 [d350daa8] __bad_area_nosemaphore at c15614f3
>>  #2 [d350dae8] bad_area at c15616df
>>  #3 [d350db00] __do_page_fault at c10248bf
>>  #4 [d350db88] do_page_fault at c1024b74
>>  #5 [d350db90] error_code (via page_fault) at c156d6b8
>>     EAX: 00000000  EBX: deb11390  ECX: 00000000  EDX: c0187a80  EBP:
>> d350dc10
>>     DS:  007b      ESI: 00000060  ES:  007b      EDI: ffffffff  GS:  00e0
>>     CS:  0060      EIP: c11e098f  ERR: ffffffff  EFLAGS: 00010286
>>  #6 [d350dbc4] xfs_btree_lookup at c11e098f
>>  #7 [d350dbfc] xfs_inobt_init_cursor at c11fb459
>>  #8 [d350dc14] xfs_dialloc_ag at c11f9218
>>  #9 [d350dc8c] xfs_dialloc at c11faaf8
>> #10 [d350dccc] xfs_ialloc at c11fc8a4
>> #11 [d350dd0c] xfs_dir_ialloc at c11fcfbb
>> #12 [d350dd5c] xfs_create at c11fd58c
>> #13 [d350ddd8] xfs_vn_mknod at c11b308c
>> #14 [d350de10] xfs_vn_create at c11b316b
>> #15 [d350de1c] vfs_create at c10e92f4
>> #16 [d350de48] do_last at c10e9a78
>> #17 [d350dea4] path_openat at c10ea14c
>> #18 [d350def0] do_filp_open at c10ea611
>> #19 [d350df64] do_sys_open at c10dd80d
>> #20 [d350dfa4] sys_open at c10dd8f7
>> #21 [d350dfb0] ia32_sysenter_target at c156d9b8
>>     EAX: 00000005  EBX: bfd0befd  ECX: 00008241  EDX: 000001b6
>>     DS:  007b      ESI: 00000000  ES:  007b      EDI: b778a000
>>     SS:  007b      ESP: bfd0a670  EBP: bfd0a7d8  GS:  0033
>>     CS:  0073      EIP: b77b9424  ERR: 00000005  EFLAGS: 00000286
>> crash> quit
>> root:/usr/src/dumps#
>> Script done on Thu 17 Oct 2013 07:23:23 PM EDT
>>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
