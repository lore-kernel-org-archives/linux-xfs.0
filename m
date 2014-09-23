Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EC5F17F3F
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 07:54:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8FA3D304053
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 05:54:10 -0700 (PDT)
Received: from mail.optimare.de (survey.optimare.de [82.198.200.60]) by
	cuda.sgi.com with ESMTP id 6KCsfaOtKxSP45Ql (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 05:54:02 -0700 (PDT)
Message-ID: <54216D67.6090800@optimare.de>
Date: Tue, 23 Sep 2014 14:53:59 +0200
From: Thomas Stagge <thomas.stagge@optimare.de>
MIME-Version: 1.0
Subject: XFS  kernal crash
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3407422423254752114=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============3407422423254752114==
Content-Type: multipart/alternative;
 boundary="------------020208010800020302070003"

This is a multi-part message in MIME format.
--------------020208010800020302070003
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

we have in the last few weeks always problems with the XFS file system.

XFS: possible memory allocation deadlock in kmem_alloc (mode: 0x250)


After a certain time there is a kernel crash which looks as follows:
September 23 10:17:57 hostname kernel: [1282081.010814] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:17:59 hostname kernel: [1282082.913437] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:01 hostname kernel: [1282084.908582] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:03 hostname kernel: [1282086.691791] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:05 hostname kernel: [1282088.691319] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:07 hostname kernel: [1282090.690182] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:09 hostname kernel: [1282092.673355] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:11 hostname kernel: [1282094.596504] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:13 hostname kernel: [1282096.595971] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:15 hostname kernel: [1282098.595301] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:17 hostname kernel: [1282100.594232] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:19 hostname kernel: [1282102.433262] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:21 hostname kernel: [1282104.412432] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:23 hostname kernel: [1282106.411598] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:25 hostname kernel: [1282108.310740] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:27 hostname kernel: [1282110.289892] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:29 hostname kernel: [1282112.289106] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:31 hostname kernel: [1282114.288247] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:33 hostname kernel: [1282116.215953] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:35 hostname kernel: [1282118.198488] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:37 hostname kernel: [1282120.193686] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:39 hostname kernel: [1282122.288716] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:41 hostname kernel: [1282124.215970] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:43 hostname kernel: [1282126.307031] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:45 hostname kernel: [1282128.306190] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:47 hostname kernel: [1282130.405310] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:49 hostname kernel: [1282132.076611] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:51 hostname kernel: [1282134.027790] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:53 hostname kernel: [1282136.122911] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:55 hostname kernel: [1282138.218032] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:57 hostname kernel: [1282140.145365] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:18:59 hostname kernel: [1282142.140528] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:19:01 hostname kernel: [1282144.091708] XFS: possible 
memory allocation deadlock in kmem_alloc (mode: 0x250)
September 23 10:19:01 hostname kernel: [1282144.223485] INFO: task 
kswapd0: 87 blocked for more than 120 seconds.
September 23 10:19:01 hostname kernel: [1282144.224156] Not tainted 
3.13.0-34-generic # 60-Ubuntu ~ precise1
September 23 10:19:01 hostname kernel: [1282144.224837] "echo 0> / proc 
/ sys / kernel / hung_task_timeout_secs" disables this message.
September 23 10:19:01 hostname kernel: [1282144.225597] kswapd0 D 
ffff88031662a020 0 87 2 0x00000000
September 23 10:19:01 hostname kernel: [1282144.225609] ffff88019500d8f8 
0000000000000002 ffff880199d94440 ffff88019500dfd8
September 23 10:19:01 hostname kernel: [1282144.225621] 0000000000014440 
0000000000014440 ffff880316cd2fe0 ffff880316f3afe0
September 23 10:19:01 hostname kernel: [1282144.225629] ffff88019500d970 
ffff880314119128 ffff88031411912c 00000000ffffffff
September 23 10:19:01 hostname kernel: [1282144.225638] Call Trace:
September 23 10:19:01 hostname kernel: [1282144.225658] 
[<ffffffff8175b8b9>] schedule + 0x29 / 0x70
September 23 10:19:01 hostname kernel: [1282144.225669] 
[<ffffffff8175bbde>] schedule_preempt_disabled + 0xe / 0x10
September 23 10:19:01 hostname kernel: [1282144.225680] 
[<ffffffff8175da14>] __mutex_lock_slowpath + 0x114 / 0x1b0
September 23 10:19:01 hostname kernel: [1282144.225771] 
[<ffffffffa0218291>]? xfs_perag_get_tag + 0x41 / 0xf0 [xfs]
September 23 10:19:01 hostname kernel: [1282144.225781] 
[<ffffffff8175dad3>] mutex_lock + 0x23 / 0x37
September 23 10:19:01 hostname kernel: [1282144.225832] 
[<ffffffffa01c7540>] xfs_reclaim_inodes_ag + 0x2e0 / 0x3a0 [xfs]
September 23 10:19:01 hostname kernel: [1282144.225843] 
[<ffffffff8101d0b9>]? sched_clock + 0x9 / 0x10
September 23 10:19:01 hostname kernel: [1282144.225852] 
[<ffffffff81042c9b>]? native_smp_send_reschedule + 0x4b / 0x60
September 23 10:19:01 hostname kernel: [1282144.225862] 
[<ffffffff8109cf7d>]? ttwu_queue + 0x8D / 0xD0
September 23 10:19:01 hostname kernel: [1282144.225871] 
[<ffffffff8109f860>]? try_to_wake_up + 0x190 / 0x210
September 23 10:19:01 hostname kernel: [1282144.225879] 
[<ffffffff8109f947>]? wake_up_process + 0x27 / 0x50

uname -a
hostname 3.13.0-34-generic # 60-Ubuntu SMP Wed precise1 ~ August 13 
15:55:33 UTC 2014 x86_64 x86_64 x86_64 GNU / Linux


xfs_repair -V
xfs_repair Version 3.1.7


7 CPUs  -> cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : Quad-Core AMD Opteron(tm) Processor 2376
stepping        : 2
microcode       : 0x1000086
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 0
cpu cores       : 4
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext 
fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl 
nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm 
extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit 
wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips        : 4600.18
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate


cat /proc/meminfo
MemTotal:       12304884 kB
MemFree:          151816 kB
Buffers:            1076 kB
Cached:         10328496 kB
SwapCached:            0 kB
Active:          2658232 kB
Inactive:        7766540 kB
Active(anon):      42644 kB
Inactive(anon):    53636 kB
Active(file):    2615588 kB
Inactive(file):  7712904 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       4878268 kB
SwapFree:        4878268 kB
Dirty:              1220 kB
Writeback:             0 kB
AnonPages:         95728 kB
Mapped:            32208 kB
Shmem:               352 kB
Slab:            1412904 kB
SReclaimable:    1188188 kB
SUnreclaim:       224716 kB
KernelStack:        3512 kB
PageTables:        28816 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    11030708 kB
Committed_AS:     949792 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      310312 kB
VmallocChunk:   34353030140 kB
HardwareCorrupted:     0 kB
AnonHugePages:     12288 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       75520 kB
DirectMap2M:     3069952 kB
DirectMap1G:     9437184 kB


  cat /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=6108796k,nr_inodes=1527199,mode=755 0 0
devpts /dev/pts devpts 
rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=1230492k,mode=755 0 0
/dev/disk/by-uuid/d6821e50-e82b-448d-bc03-9c286ef59c8f / xfs 
rw,relatime,attr2,inode64,noquota 0 0
none /sys/fs/fuse/connections fusectl rw,relatime 0 0
none /sys/kernel/debug debugfs rw,relatime 0 0
none /sys/kernel/security securityfs rw,relatime 0 0
none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
/dev/sdc1 /extern/data0 xfs rw,relatime,attr2,inode64,noquota 0 0
rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0


cat /proc/partitions
major minor  #blocks  name

   11        0    1048575 sr0
    8        0  245175336 sda
    8        1   97654784 sda1
    8        2    4882432 sda2
    8       16  245175336 sdb
    8       17   97654784 sdb1
    8       18    4882432 sdb2
    9        2   97589120 md2
    9        1    4878272 md1
    8       32 27345461248 sdc
    8       33 27345461214 sdc1


xfs_info /dev/md2
Metadaten =/dev/disk/by-uuid/d6821e50-e82b-448d-bc03-9c286ef59c8f 
isize=256    agcount=4, agsize=6099320 blks
           =                       sectsz=512   attr=2
Daten     =                       bsize=4096   Blöcke=24397280, imaxpct=25
           =                       sunit=0      swidth=0 blks
Benennung =Version 2              bsize=4096   ascii-ci=0
Protokoll =Intern                 bsize=4096   Blöcke=11912, Version=2
           =                       sectsz=512   sunit=0 blks, lazy-count=1
Echtzeit  =keine                  extsz=4096   Blöcke=0, rtextents=0


  xfs_info /dev/md2
Metadaten =/dev/disk/by-uuid/d6821e50-e82b-448d-bc03-9c286ef59c8f 
isize=256    agcount=4, agsize=6099320 blks
           =                       sectsz=512   attr=2
Daten     =                       bsize=4096   Blöcke=24397280, imaxpct=25
           =                       sunit=0      swidth=0 blks
Benennung =Version 2              bsize=4096   ascii-ci=0
Protokoll =Intern                 bsize=4096   Blöcke=11912, Version=2
           =                       sectsz=512   sunit=0 blks, lazy-count=1
Echtzeit  =keine                  extsz=4096   Blöcke=0, rtextents=0


xfs_info /dev/sdc1
Metadaten =/dev/sdc1              isize=256    agcount=26, 
agsize=268435455 blks
           =                       sectsz=512   attr=2
Daten     =                       bsize=4096 Blöcke=6836365303, imaxpct=5
           =                       sunit=0      swidth=0 blks
Benennung =Version 2              bsize=4096   ascii-ci=0
Protokoll =Intern                 bsize=4096   Blöcke=32768, Version=2
           =                       sectsz=512   sunit=0 blks, lazy-count=0
Echtzeit  =keine                  extsz=4096   Blöcke=0, rtextents=0


Can you help us?


Best regards,

-- 
Mit freundlichen Grüssen,

Thomas Stagge
--------------------------------------

Thomas Stagge, Dipl.Ing.(FH)
System Administrator

OPTIMARE Systems GmbH
Am Luneort 15a
27572 Bremerhaven, Germany

T: +49 471 48361-27
F: +49 471 48361-11
M: +49 172 8698575

  

thomas.stagge@optimare.de
Internet: http://www.optimare.de

CEO: Dipl.-Ing. Hans J. Stahl; Sitz der Gesellschaft: Bremerhaven; Registergericht: Amtsgericht Bremen HRB 28618 HB


--------------020208010800020302070003
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-15">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <meta http-equiv="Content-Type" content="text/html;
      charset=ISO-8859-15">
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN">Hello, <br>
        <br>
        we have in the last few weeks always problems with the XFS file
        system. <br>
        <br>
        XFS: possible memory allocation deadlock in kmem_alloc (mode:
        0x250) <o:p></o:p></span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
        After a certain time there is a kernel crash which looks as
        follows: <br>
        September 23 10:17:57 hostname kernel: [1282081.010814] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:17:59 hostname kernel: [1282082.913437] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:01 hostname kernel: [1282084.908582] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:03 hostname kernel: [1282086.691791] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:05 hostname kernel: [1282088.691319] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:07 hostname kernel: [1282090.690182] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:09 hostname kernel: [1282092.673355] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:11 hostname kernel: [1282094.596504] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:13 hostname kernel: [1282096.595971] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:15 hostname kernel: [1282098.595301] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:17 hostname kernel: [1282100.594232] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:19 hostname kernel: [1282102.433262] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:21 hostname kernel: [1282104.412432] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:23 hostname kernel: [1282106.411598] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:25 hostname kernel: [1282108.310740] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:27 hostname kernel: [1282110.289892] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:29 hostname kernel: [1282112.289106] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:31 hostname kernel: [1282114.288247] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:33 hostname kernel: [1282116.215953] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:35 hostname kernel: [1282118.198488] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:37 hostname kernel: [1282120.193686] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:39 hostname kernel: [1282122.288716] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:41 hostname kernel: [1282124.215970] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:43 hostname kernel: [1282126.307031] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:45 hostname kernel: [1282128.306190] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:47 hostname kernel: [1282130.405310] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:49 hostname kernel: [1282132.076611] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:51 hostname kernel: [1282134.027790] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:53 hostname kernel: [1282136.122911] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:55 hostname kernel: [1282138.218032] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:57 hostname kernel: [1282140.145365] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:18:59 hostname kernel: [1282142.140528] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:19:01 hostname kernel: [1282144.091708] XFS:
        possible memory
        allocation deadlock in kmem_alloc (mode: 0x250) <br>
        September 23 10:19:01 hostname kernel: [1282144.223485] INFO:
        task kswapd0: 87
        blocked for more than 120 seconds. <br>
        September 23 10:19:01 hostname kernel: [1282144.224156] Not
        tainted 3.13.0-34-generic
        # 60-Ubuntu ~ precise1 <br>
        September 23 10:19:01 hostname kernel: [1282144.224837] "echo
        0&gt; / proc
        / sys / kernel / hung_task_timeout_secs" disables this message.
        <br>
        September 23 10:19:01 hostname kernel: [1282144.225597] kswapd0
        D
        ffff88031662a020 0 87 2 0x00000000 <br>
        September 23 10:19:01 hostname kernel: [1282144.225609]
        ffff88019500d8f8
        0000000000000002 ffff880199d94440 ffff88019500dfd8 <br>
        September 23 10:19:01 hostname kernel: [1282144.225621]
        0000000000014440
        0000000000014440 ffff880316cd2fe0 ffff880316f3afe0 <br>
        September 23 10:19:01 hostname kernel: [1282144.225629]
        ffff88019500d970
        ffff880314119128 ffff88031411912c 00000000ffffffff <br>
        September 23 10:19:01 hostname kernel: [1282144.225638] Call
        Trace: <br>
        September 23 10:19:01 hostname kernel: [1282144.225658]
        [&lt;ffffffff8175b8b9&gt;] schedule + 0x29 / 0x70 <br>
        September 23 10:19:01 hostname kernel: [1282144.225669]
        [&lt;ffffffff8175bbde&gt;] schedule_preempt_disabled + 0xe /
        0x10 <br>
        September 23 10:19:01 hostname kernel: [1282144.225680]
        [&lt;ffffffff8175da14&gt;] __mutex_lock_slowpath + 0x114 / 0x1b0
        <br>
        September 23 10:19:01 hostname kernel: [1282144.225771]
        [&lt;ffffffffa0218291&gt;]? xfs_perag_get_tag + 0x41 / 0xf0
        [xfs] <br>
        September 23 10:19:01 hostname kernel: [1282144.225781]
        [&lt;ffffffff8175dad3&gt;] mutex_lock + 0x23 / 0x37 <br>
        September 23 10:19:01 hostname kernel: [1282144.225832]
        [&lt;ffffffffa01c7540&gt;] xfs_reclaim_inodes_ag + 0x2e0 / 0x3a0
        [xfs] <br>
        September 23 10:19:01 hostname kernel: [1282144.225843]
        [&lt;ffffffff8101d0b9&gt;]? sched_clock + 0x9 / 0x10 <br>
        September 23 10:19:01 hostname kernel: [1282144.225852]
        [&lt;ffffffff81042c9b&gt;]? native_smp_send_reschedule + 0x4b /
        0x60 <br>
        September 23 10:19:01 hostname kernel: [1282144.225862]
        [&lt;ffffffff8109cf7d&gt;]? ttwu_queue + 0x8D / 0xD0 <br>
        September 23 10:19:01 hostname kernel: [1282144.225871]
        [&lt;ffffffff8109f860&gt;]?
        try_to_wake_up + 0x190 / 0x210 <br>
        September 23 10:19:01 hostname kernel: [1282144.225879]
        [&lt;ffffffff8109f947&gt;]? wake_up_process + 0x27 / 0x50 <br>
        <br>
        uname -a<br>
        hostname 3.13.0-34-generic # 60-Ubuntu SMP Wed precise1 ~ August
        13 15:55:33
        UTC 2014 x86_64 x86_64 x86_64 GNU / Linux <br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
        xfs_repair -V<br>
        xfs_repair Version 3.1.7<br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
        7 CPUs  -&gt; cat /proc/cpuinfo<br>
        processor       : 0<br>
        vendor_id       : AuthenticAMD<br>
        cpu family      : 16<br>
        model           : 4<br>
        model name      : Quad-Core AMD Opteron(tm) Processor 2376<br>
        stepping        : 2<br>
        microcode       : 0x1000086<br>
        cpu MHz         : 800.000<br>
        cache size      : 512 KB<br>
        physical id     : 0<br>
        siblings        : 4<br>
        core id         : 0<br>
        cpu cores       : 4<br>
        apicid          : 0<br>
        initial apicid  : 0<br>
        fpu             : yes<br>
        fpu_exception   : yes<br>
        cpuid level     : 5<br>
        wp              : yes<br>
        flags           : fpu vme de pse tsc msr pae mce cx8 apic sep
        mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall
        nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc
        rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt
        lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse
        3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock
        nrip_save<br>
        bogomips        : 4600.18<br>
        TLB size        : 1024 4K pages<br>
        clflush size    : 64<br>
        cache_alignment : 64<br>
        address sizes   : 48 bits physical, 48 bits virtual<br>
        power management: ts ttp tm stc 100mhzsteps hwpstate</span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
        cat /proc/meminfo<br>
        MemTotal:       12304884 kB<br>
        MemFree:          151816 kB<br>
        Buffers:            1076 kB<br>
        Cached:         10328496 kB<br>
        SwapCached:            0 kB<br>
        Active:          2658232 kB<br>
        Inactive:        7766540 kB<br>
        Active(anon):      42644 kB<br>
        Inactive(anon):    53636 kB<br>
        Active(file):    2615588 kB<br>
        Inactive(file):  7712904 kB<br>
        Unevictable:           0 kB<br>
        Mlocked:               0 kB<br>
        SwapTotal:       4878268 kB<br>
        SwapFree:        4878268 kB<br>
        Dirty:              1220 kB<br>
        Writeback:             0 kB<br>
        AnonPages:         95728 kB<br>
        Mapped:            32208 kB<br>
        Shmem:               352 kB<br>
        Slab:            1412904 kB<br>
        SReclaimable:    1188188 kB<br>
        SUnreclaim:       224716 kB<br>
        KernelStack:        3512 kB<br>
        PageTables:        28816 kB<br>
        NFS_Unstable:          0 kB<br>
        Bounce:                0 kB<br>
        WritebackTmp:          0 kB<br>
        CommitLimit:    11030708 kB<br>
        Committed_AS:     949792 kB<br>
        VmallocTotal:   34359738367 kB<br>
        VmallocUsed:      310312 kB<br>
        VmallocChunk:   34353030140 kB<br>
        HardwareCorrupted:     0 kB<br>
        AnonHugePages:     12288 kB<br>
        HugePages_Total:       0<br>
        HugePages_Free:        0<br>
        HugePages_Rsvd:        0<br>
        HugePages_Surp:        0<br>
        Hugepagesize:       2048 kB<br>
        DirectMap4k:       75520 kB<br>
        DirectMap2M:     3069952 kB<br>
        DirectMap1G:     9437184 kB<br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
         cat /proc/mounts<br>
        rootfs / rootfs rw 0 0<br>
        sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0<br>
        proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0<br>
        udev /dev devtmpfs
        rw,relatime,size=6108796k,nr_inodes=1527199,mode=755 0 0<br>
        devpts /dev/pts devpts
        rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0<br>
        tmpfs /run tmpfs
        rw,nosuid,noexec,relatime,size=1230492k,mode=755 0 0<br>
        /dev/disk/by-uuid/d6821e50-e82b-448d-bc03-9c286ef59c8f / xfs
        rw,relatime,attr2,inode64,noquota 0 0<br>
        none /sys/fs/fuse/connections fusectl rw,relatime 0 0<br>
        none /sys/kernel/debug debugfs rw,relatime 0 0<br>
        none /sys/kernel/security securityfs rw,relatime 0 0<br>
        none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k
        0 0<br>
        none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0<br>
        /dev/sdc1 /extern/data0 xfs rw,relatime,attr2,inode64,noquota 0
        0<br>
        rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0<br>
        nfsd /proc/fs/nfsd nfsd rw,relatime 0 0<br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
        cat /proc/partitions<br>
        major minor  #blocks  name<br>
        <br>
          11        0    1048575 sr0<br>
           8        0  245175336 sda<br>
           8        1   97654784 sda1<br>
           8        2    4882432 sda2<br>
           8       16  245175336 sdb<br>
           8       17   97654784 sdb1<br>
           8       18    4882432 sdb2<br>
           9        2   97589120 md2<br>
           9        1    4878272 md1<br>
           8       32 27345461248 sdc<br>
           8       33 27345461214 sdc1<br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><br>
      <span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"></span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN">xfs_info /dev/md2<br>
        Metadaten
        =/dev/disk/by-uuid/d6821e50-e82b-448d-bc03-9c286ef59c8f
        isize=256    agcount=4, agsize=6099320 blks<br>
                  =                       sectsz=512   attr=2<br>
        Daten     =                       bsize=4096   Blöcke=24397280,
        imaxpct=25<br>
                  =                       sunit=0      swidth=0 blks<br>
        Benennung =Version 2              bsize=4096   ascii-ci=0<br>
        Protokoll =Intern                 bsize=4096   Blöcke=11912,
        Version=2<br>
                  =                       sectsz=512   sunit=0 blks,
        lazy-count=1<br>
        Echtzeit  =keine                  extsz=4096   Blöcke=0,
        rtextents=0</span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"> xfs_info /dev/md2<br>
        Metadaten
        =/dev/disk/by-uuid/d6821e50-e82b-448d-bc03-9c286ef59c8f
        isize=256    agcount=4, agsize=6099320 blks<br>
                  =                       sectsz=512   attr=2<br>
        Daten     =                       bsize=4096   Blöcke=24397280,
        imaxpct=25<br>
                  =                       sunit=0      swidth=0 blks<br>
        Benennung =Version 2              bsize=4096   ascii-ci=0<br>
        Protokoll =Intern                 bsize=4096   Blöcke=11912,
        Version=2<br>
                  =                       sectsz=512   sunit=0 blks,
        lazy-count=1<br>
        Echtzeit  =keine                  extsz=4096   Blöcke=0,
        rtextents=0<br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
        xfs_info /dev/sdc1<br>
        Metadaten =/dev/sdc1              isize=256    agcount=26,
        agsize=268435455 blks<br>
                  =                       sectsz=512   attr=2<br>
        Daten     =                       bsize=4096  
        Blöcke=6836365303, imaxpct=5<br>
                  =                       sunit=0      swidth=0 blks<br>
        Benennung =Version 2              bsize=4096   ascii-ci=0<br>
        Protokoll =Intern                 bsize=4096   Blöcke=32768,
        Version=2<br>
                  =                       sectsz=512   sunit=0 blks,
        lazy-count=0<br>
        Echtzeit  =keine                  extsz=4096   Blöcke=0,
        rtextents=0<br>
        <br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"><br>
        Can you help us?<br>
      </span></p>
    <p class="MsoNormal"
      style="margin-bottom:0cm;margin-bottom:.0001pt;line-height:
      normal"><br>
      Best regards,<br>
      <span style="font-size:12.0pt;font-family:&quot;Times New
        Roman&quot;,&quot;serif&quot;;
        mso-fareast-font-family:&quot;Times New
        Roman&quot;;mso-ansi-language:EN" lang="EN"></span><span
        style="font-size:12.0pt;font-family:
        &quot;Times New
        Roman&quot;,&quot;serif&quot;;mso-fareast-font-family:&quot;Times
        New Roman&quot;;mso-ansi-language:
        EN-US" lang="EN-US"><o:p></o:p></span></p>
    <meta name="ProgId" content="Word.Document">
    <meta name="Generator" content="Microsoft Word 15">
    <meta name="Originator" content="Microsoft Word 15">
    <link rel="File-List"
href="file:///C:%5CUsers%5CTHOMAS%7E1.STA%5CAppData%5CLocal%5CTemp%5Cmsohtmlclip1%5C01%5Cclip_filelist.xml">
    <!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->
    <link rel="themeData"
href="file:///C:%5CUsers%5CTHOMAS%7E1.STA%5CAppData%5CLocal%5CTemp%5Cmsohtmlclip1%5C01%5Cclip_themedata.thmx">
    <link rel="colorSchemeMapping"
href="file:///C:%5CUsers%5CTHOMAS%7E1.STA%5CAppData%5CLocal%5CTemp%5Cmsohtmlclip1%5C01%5Cclip_colorschememapping.xml">
    <!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:TrackMoves/>
  <w:TrackFormatting/>
  <w:HyphenationZone>21</w:HyphenationZone>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:DoNotPromoteQF/>
  <w:LidThemeOther>DE</w:LidThemeOther>
  <w:LidThemeAsian>ZH-CN</w:LidThemeAsian>
  <w:LidThemeComplexScript>X-NONE</w:LidThemeComplexScript>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
   <w:SplitPgBreakAndParaMark/>
   <w:EnableOpenTypeKerning/>
   <w:DontFlipMirrorIndents/>
   <w:OverrideTableStyleHps/>
   <w:UseFELayout/>
  </w:Compatibility>
  <m:mathPr>
   <m:mathFont m:val="Cambria Math"/>
   <m:brkBin m:val="before"/>
   <m:brkBinSub m:val="&#45;-"/>
   <m:smallFrac m:val="off"/>
   <m:dispDef/>
   <m:lMargin m:val="0"/>
   <m:rMargin m:val="0"/>
   <m:defJc m:val="centerGroup"/>
   <m:wrapIndent m:val="1440"/>
   <m:intLim m:val="subSup"/>
   <m:naryLim m:val="undOvr"/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState="false" DefUnhideWhenUsed="false"
  DefSemiHidden="false" DefQFormat="false" DefPriority="99"
  LatentStyleCount="371">
  <w:LsdException Locked="false" Priority="0" QFormat="true" Name="Normal"/>
  <w:LsdException Locked="false" Priority="9" QFormat="true" Name="heading 1"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="heading 2"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="heading 3"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="heading 4"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="heading 5"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="heading 6"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="heading 7"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="heading 8"/>
  <w:LsdException Locked="false" Priority="9" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="heading 9"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 5"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 6"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 7"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 8"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index 9"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 1"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 2"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 3"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 4"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 5"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 6"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 7"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 8"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" Name="toc 9"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Normal Indent"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="footnote text"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="annotation text"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="header"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="footer"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="index heading"/>
  <w:LsdException Locked="false" Priority="35" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="caption"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="table of figures"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="envelope address"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="envelope return"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="footnote reference"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="annotation reference"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="line number"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="page number"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="endnote reference"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="endnote text"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="table of authorities"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="macro"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="toa heading"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Bullet"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Number"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List 5"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Bullet 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Bullet 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Bullet 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Bullet 5"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Number 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Number 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Number 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Number 5"/>
  <w:LsdException Locked="false" Priority="10" QFormat="true" Name="Title"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Closing"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Signature"/>
  <w:LsdException Locked="false" Priority="1" SemiHidden="true"
   UnhideWhenUsed="true" Name="Default Paragraph Font"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Body Text"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Body Text Indent"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Continue"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Continue 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Continue 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Continue 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="List Continue 5"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Message Header"/>
  <w:LsdException Locked="false" Priority="11" QFormat="true" Name="Subtitle"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Salutation"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Date"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Body Text First Indent"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Body Text First Indent 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Note Heading"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Body Text 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Body Text 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Body Text Indent 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Body Text Indent 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Block Text"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Hyperlink"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="FollowedHyperlink"/>
  <w:LsdException Locked="false" Priority="22" QFormat="true" Name="Strong"/>
  <w:LsdException Locked="false" Priority="20" QFormat="true" Name="Emphasis"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Document Map"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Plain Text"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="E-mail Signature"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Top of Form"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Bottom of Form"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Normal (Web)"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Acronym"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Address"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Cite"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Code"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Definition"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Keyboard"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Preformatted"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Sample"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Typewriter"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="HTML Variable"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Normal Table"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="annotation subject"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="No List"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Outline List 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Outline List 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Outline List 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Simple 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Simple 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Simple 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Classic 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Classic 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Classic 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Classic 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Colorful 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Colorful 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Colorful 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Columns 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Columns 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Columns 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Columns 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Columns 5"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Grid 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Grid 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Grid 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Grid 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Grid 5"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Grid 6"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Grid 7"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Grid 8"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table List 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table List 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table List 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table List 4"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table List 5"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table List 6"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table List 7"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table List 8"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table 3D effects 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table 3D effects 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table 3D effects 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Contemporary"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Elegant"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Professional"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Subtle 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Subtle 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Web 1"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Web 2"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Web 3"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Balloon Text"/>
  <w:LsdException Locked="false" Priority="39" Name="Table Grid"/>
  <w:LsdException Locked="false" SemiHidden="true" UnhideWhenUsed="true"
   Name="Table Theme"/>
  <w:LsdException Locked="false" SemiHidden="true" Name="Placeholder Text"/>
  <w:LsdException Locked="false" Priority="1" QFormat="true" Name="No Spacing"/>
  <w:LsdException Locked="false" Priority="60" Name="Light Shading"/>
  <w:LsdException Locked="false" Priority="61" Name="Light List"/>
  <w:LsdException Locked="false" Priority="62" Name="Light Grid"/>
  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1"/>
  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2"/>
  <w:LsdException Locked="false" Priority="65" Name="Medium List 1"/>
  <w:LsdException Locked="false" Priority="66" Name="Medium List 2"/>
  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1"/>
  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2"/>
  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3"/>
  <w:LsdException Locked="false" Priority="70" Name="Dark List"/>
  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading"/>
  <w:LsdException Locked="false" Priority="72" Name="Colorful List"/>
  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid"/>
  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 1"/>
  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 1"/>
  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 1"/>
  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 1"/>
  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 1"/>
  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 1"/>
  <w:LsdException Locked="false" SemiHidden="true" Name="Revision"/>
  <w:LsdException Locked="false" Priority="34" QFormat="true"
   Name="List Paragraph"/>
  <w:LsdException Locked="false" Priority="29" QFormat="true" Name="Quote"/>
  <w:LsdException Locked="false" Priority="30" QFormat="true"
   Name="Intense Quote"/>
  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 1"/>
  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 1"/>
  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 1"/>
  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 1"/>
  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 1"/>
  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 1"/>
  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 1"/>
  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 1"/>
  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 2"/>
  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 2"/>
  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 2"/>
  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 2"/>
  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 2"/>
  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 2"/>
  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 2"/>
  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 2"/>
  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 2"/>
  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 2"/>
  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 2"/>
  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 2"/>
  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 2"/>
  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 2"/>
  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 3"/>
  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 3"/>
  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 3"/>
  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 3"/>
  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 3"/>
  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 3"/>
  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 3"/>
  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 3"/>
  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 3"/>
  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 3"/>
  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 3"/>
  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 3"/>
  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 3"/>
  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 3"/>
  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 4"/>
  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 4"/>
  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 4"/>
  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 4"/>
  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 4"/>
  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 4"/>
  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 4"/>
  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 4"/>
  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 4"/>
  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 4"/>
  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 4"/>
  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 4"/>
  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 4"/>
  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 4"/>
  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 5"/>
  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 5"/>
  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 5"/>
  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 5"/>
  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 5"/>
  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 5"/>
  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 5"/>
  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 5"/>
  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 5"/>
  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 5"/>
  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 5"/>
  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 5"/>
  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 5"/>
  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 5"/>
  <w:LsdException Locked="false" Priority="60" Name="Light Shading Accent 6"/>
  <w:LsdException Locked="false" Priority="61" Name="Light List Accent 6"/>
  <w:LsdException Locked="false" Priority="62" Name="Light Grid Accent 6"/>
  <w:LsdException Locked="false" Priority="63" Name="Medium Shading 1 Accent 6"/>
  <w:LsdException Locked="false" Priority="64" Name="Medium Shading 2 Accent 6"/>
  <w:LsdException Locked="false" Priority="65" Name="Medium List 1 Accent 6"/>
  <w:LsdException Locked="false" Priority="66" Name="Medium List 2 Accent 6"/>
  <w:LsdException Locked="false" Priority="67" Name="Medium Grid 1 Accent 6"/>
  <w:LsdException Locked="false" Priority="68" Name="Medium Grid 2 Accent 6"/>
  <w:LsdException Locked="false" Priority="69" Name="Medium Grid 3 Accent 6"/>
  <w:LsdException Locked="false" Priority="70" Name="Dark List Accent 6"/>
  <w:LsdException Locked="false" Priority="71" Name="Colorful Shading Accent 6"/>
  <w:LsdException Locked="false" Priority="72" Name="Colorful List Accent 6"/>
  <w:LsdException Locked="false" Priority="73" Name="Colorful Grid Accent 6"/>
  <w:LsdException Locked="false" Priority="19" QFormat="true"
   Name="Subtle Emphasis"/>
  <w:LsdException Locked="false" Priority="21" QFormat="true"
   Name="Intense Emphasis"/>
  <w:LsdException Locked="false" Priority="31" QFormat="true"
   Name="Subtle Reference"/>
  <w:LsdException Locked="false" Priority="32" QFormat="true"
   Name="Intense Reference"/>
  <w:LsdException Locked="false" Priority="33" QFormat="true" Name="Book Title"/>
  <w:LsdException Locked="false" Priority="37" SemiHidden="true"
   UnhideWhenUsed="true" Name="Bibliography"/>
  <w:LsdException Locked="false" Priority="39" SemiHidden="true"
   UnhideWhenUsed="true" QFormat="true" Name="TOC Heading"/>
  <w:LsdException Locked="false" Priority="41" Name="Plain Table 1"/>
  <w:LsdException Locked="false" Priority="42" Name="Plain Table 2"/>
  <w:LsdException Locked="false" Priority="43" Name="Plain Table 3"/>
  <w:LsdException Locked="false" Priority="44" Name="Plain Table 4"/>
  <w:LsdException Locked="false" Priority="45" Name="Plain Table 5"/>
  <w:LsdException Locked="false" Priority="40" Name="Grid Table Light"/>
  <w:LsdException Locked="false" Priority="46" Name="Grid Table 1 Light"/>
  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2"/>
  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3"/>
  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4"/>
  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark"/>
  <w:LsdException Locked="false" Priority="51" Name="Grid Table 6 Colorful"/>
  <w:LsdException Locked="false" Priority="52" Name="Grid Table 7 Colorful"/>
  <w:LsdException Locked="false" Priority="46"
   Name="Grid Table 1 Light Accent 1"/>
  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 1"/>
  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 1"/>
  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 1"/>
  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 1"/>
  <w:LsdException Locked="false" Priority="51"
   Name="Grid Table 6 Colorful Accent 1"/>
  <w:LsdException Locked="false" Priority="52"
   Name="Grid Table 7 Colorful Accent 1"/>
  <w:LsdException Locked="false" Priority="46"
   Name="Grid Table 1 Light Accent 2"/>
  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 2"/>
  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 2"/>
  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 2"/>
  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 2"/>
  <w:LsdException Locked="false" Priority="51"
   Name="Grid Table 6 Colorful Accent 2"/>
  <w:LsdException Locked="false" Priority="52"
   Name="Grid Table 7 Colorful Accent 2"/>
  <w:LsdException Locked="false" Priority="46"
   Name="Grid Table 1 Light Accent 3"/>
  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 3"/>
  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 3"/>
  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 3"/>
  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 3"/>
  <w:LsdException Locked="false" Priority="51"
   Name="Grid Table 6 Colorful Accent 3"/>
  <w:LsdException Locked="false" Priority="52"
   Name="Grid Table 7 Colorful Accent 3"/>
  <w:LsdException Locked="false" Priority="46"
   Name="Grid Table 1 Light Accent 4"/>
  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 4"/>
  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 4"/>
  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 4"/>
  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 4"/>
  <w:LsdException Locked="false" Priority="51"
   Name="Grid Table 6 Colorful Accent 4"/>
  <w:LsdException Locked="false" Priority="52"
   Name="Grid Table 7 Colorful Accent 4"/>
  <w:LsdException Locked="false" Priority="46"
   Name="Grid Table 1 Light Accent 5"/>
  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 5"/>
  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 5"/>
  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 5"/>
  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 5"/>
  <w:LsdException Locked="false" Priority="51"
   Name="Grid Table 6 Colorful Accent 5"/>
  <w:LsdException Locked="false" Priority="52"
   Name="Grid Table 7 Colorful Accent 5"/>
  <w:LsdException Locked="false" Priority="46"
   Name="Grid Table 1 Light Accent 6"/>
  <w:LsdException Locked="false" Priority="47" Name="Grid Table 2 Accent 6"/>
  <w:LsdException Locked="false" Priority="48" Name="Grid Table 3 Accent 6"/>
  <w:LsdException Locked="false" Priority="49" Name="Grid Table 4 Accent 6"/>
  <w:LsdException Locked="false" Priority="50" Name="Grid Table 5 Dark Accent 6"/>
  <w:LsdException Locked="false" Priority="51"
   Name="Grid Table 6 Colorful Accent 6"/>
  <w:LsdException Locked="false" Priority="52"
   Name="Grid Table 7 Colorful Accent 6"/>
  <w:LsdException Locked="false" Priority="46" Name="List Table 1 Light"/>
  <w:LsdException Locked="false" Priority="47" Name="List Table 2"/>
  <w:LsdException Locked="false" Priority="48" Name="List Table 3"/>
  <w:LsdException Locked="false" Priority="49" Name="List Table 4"/>
  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark"/>
  <w:LsdException Locked="false" Priority="51" Name="List Table 6 Colorful"/>
  <w:LsdException Locked="false" Priority="52" Name="List Table 7 Colorful"/>
  <w:LsdException Locked="false" Priority="46"
   Name="List Table 1 Light Accent 1"/>
  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 1"/>
  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 1"/>
  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 1"/>
  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 1"/>
  <w:LsdException Locked="false" Priority="51"
   Name="List Table 6 Colorful Accent 1"/>
  <w:LsdException Locked="false" Priority="52"
   Name="List Table 7 Colorful Accent 1"/>
  <w:LsdException Locked="false" Priority="46"
   Name="List Table 1 Light Accent 2"/>
  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 2"/>
  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 2"/>
  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 2"/>
  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 2"/>
  <w:LsdException Locked="false" Priority="51"
   Name="List Table 6 Colorful Accent 2"/>
  <w:LsdException Locked="false" Priority="52"
   Name="List Table 7 Colorful Accent 2"/>
  <w:LsdException Locked="false" Priority="46"
   Name="List Table 1 Light Accent 3"/>
  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 3"/>
  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 3"/>
  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 3"/>
  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 3"/>
  <w:LsdException Locked="false" Priority="51"
   Name="List Table 6 Colorful Accent 3"/>
  <w:LsdException Locked="false" Priority="52"
   Name="List Table 7 Colorful Accent 3"/>
  <w:LsdException Locked="false" Priority="46"
   Name="List Table 1 Light Accent 4"/>
  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 4"/>
  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 4"/>
  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 4"/>
  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 4"/>
  <w:LsdException Locked="false" Priority="51"
   Name="List Table 6 Colorful Accent 4"/>
  <w:LsdException Locked="false" Priority="52"
   Name="List Table 7 Colorful Accent 4"/>
  <w:LsdException Locked="false" Priority="46"
   Name="List Table 1 Light Accent 5"/>
  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 5"/>
  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 5"/>
  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 5"/>
  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 5"/>
  <w:LsdException Locked="false" Priority="51"
   Name="List Table 6 Colorful Accent 5"/>
  <w:LsdException Locked="false" Priority="52"
   Name="List Table 7 Colorful Accent 5"/>
  <w:LsdException Locked="false" Priority="46"
   Name="List Table 1 Light Accent 6"/>
  <w:LsdException Locked="false" Priority="47" Name="List Table 2 Accent 6"/>
  <w:LsdException Locked="false" Priority="48" Name="List Table 3 Accent 6"/>
  <w:LsdException Locked="false" Priority="49" Name="List Table 4 Accent 6"/>
  <w:LsdException Locked="false" Priority="50" Name="List Table 5 Dark Accent 6"/>
  <w:LsdException Locked="false" Priority="51"
   Name="List Table 6 Colorful Accent 6"/>
  <w:LsdException Locked="false" Priority="52"
   Name="List Table 7 Colorful Accent 6"/>
 </w:LatentStyles>
</xml><![endif]-->
    <style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:SimSun;
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-alt:&#23435;&#20307;;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 680460288 22 0 262145 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;
	mso-font-charset:0;
	mso-generic-font-family:roman;
	mso-font-pitch:variable;
	mso-font-signature:-536870145 1107305727 0 0 415 0;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;
	mso-font-charset:0;
	mso-generic-font-family:swiss;
	mso-font-pitch:variable;
	mso-font-signature:-536870145 1073786111 1 0 415 0;}
@font-face
	{font-family:"\@SimSun";
	panose-1:2 1 6 0 3 1 1 1 1 1;
	mso-font-charset:134;
	mso-generic-font-family:auto;
	mso-font-pitch:variable;
	mso-font-signature:3 680460288 22 0 262145 0;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{mso-style-unhide:no;
	mso-style-qformat:yes;
	mso-style-parent:"";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:8.0pt;
	margin-left:0cm;
	line-height:107%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:SimSun;
	mso-fareast-theme-font:minor-fareast;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
.MsoChpDefault
	{mso-style-type:export-only;
	mso-default-props:yes;
	font-family:"Calibri","sans-serif";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-fareast-font-family:SimSun;
	mso-fareast-theme-font:minor-fareast;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;
	mso-bidi-font-family:"Times New Roman";
	mso-bidi-theme-font:minor-bidi;}
.MsoPapDefault
	{mso-style-type:export-only;
	margin-bottom:8.0pt;
	line-height:107%;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:70.85pt 70.85pt 2.0cm 70.85pt;
	mso-header-margin:36.0pt;
	mso-footer-margin:36.0pt;
	mso-paper-source:0;}
div.WordSection1
	{page:WordSection1;}
-->
</style><!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
	{mso-style-name:"Normale Tabelle";
	mso-tstyle-rowband-size:0;
	mso-tstyle-colband-size:0;
	mso-style-noshow:yes;
	mso-style-priority:99;
	mso-style-parent:"";
	mso-padding-alt:0cm 5.4pt 0cm 5.4pt;
	mso-para-margin-top:0cm;
	mso-para-margin-right:0cm;
	mso-para-margin-bottom:8.0pt;
	mso-para-margin-left:0cm;
	line-height:107%;
	mso-pagination:widow-orphan;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	mso-ascii-font-family:Calibri;
	mso-ascii-theme-font:minor-latin;
	mso-hansi-font-family:Calibri;
	mso-hansi-theme-font:minor-latin;}
</style>
<![endif]-->
    <pre class="moz-signature" cols="72">-- 
Mit freundlichen Grüssen,

Thomas Stagge
--------------------------------------

Thomas Stagge, Dipl.Ing.(FH)
System Administrator

OPTIMARE Systems GmbH
Am Luneort 15a
27572 Bremerhaven, Germany

T: +49 471 48361-27
F: +49 471 48361-11
M: +49 172 8698575

 

<a class="moz-txt-link-abbreviated" href="mailto:thomas.stagge@optimare.de">thomas.stagge@optimare.de</a>
Internet: <a class="moz-txt-link-freetext" href="http://www.optimare.de">http://www.optimare.de</a>

CEO: Dipl.-Ing. Hans J. Stahl; Sitz der Gesellschaft: Bremerhaven; Registergericht: Amtsgericht Bremen HRB 28618 HB

</pre>
  </body>
</html>

--------------020208010800020302070003--


--===============3407422423254752114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3407422423254752114==--
