Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hermes.casalogic.dk ([91.216.14.29]:43344 "EHLO
        hermes.casalogic.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbeILQoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 12:44:11 -0400
Date: Wed, 12 Sep 2018 13:39:59 +0200 (CEST)
From: Troels Hansen <th@casalogic.dk>
Message-ID: <1190577571.4632210.1536752399899.JavaMail.zimbra@casalogic.dk>
In-Reply-To: <20180912105938.jbziznvnrheldudj@odin.usersys.redhat.com>
References: <1063031109.4602643.1536739675362.JavaMail.zimbra@casalogic.dk> <20180912105938.jbziznvnrheldudj@odin.usersys.redhat.com>
Subject: Re: Strange XFS problem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

Hi Carlos


----- On Sep 12, 2018, at 12:59 PM, Carlos Maiolino cmaiolino@redhat.com wrote:

> In the mean time, can you provide more information about the systems where you
> are hitting this issue?
> 
> Mainle the storage configuration and the xfs_info output of the affected
> filesystems.
> 
> FWIW:
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F


$ uname -a
Linux ged 4.15.0-32-generic #35~16.04.1-Ubuntu SMP Fri Aug 10 21:54:34 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux


$ sudo xfs_info /z/home
meta-data=/dev/sda               isize=256    agcount=102, agsize=268435328 blks
         =                       sectsz=512   attr=2, projid32bit=0
         =                       crc=0        finobt=0 spinodes=0
data     =                       bsize=4096   blocks=27345289216, imaxpct=1
         =                       sunit=128    swidth=256 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
log      =internal               bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=8 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


$ xfs_repair -V
xfs_repair version 4.3.0

CPU:
2 x Xeon(R) Gold 6142, total 32cores, 64 threads.

$ cat /proc/meminfo 
MemTotal:       1583995652 kB
MemFree:        143862972 kB
MemAvailable:   1509722704 kB
Buffers:          388972 kB
Cached:         1237429160 kB
SwapCached:            0 kB
Active:         1026769972 kB
Inactive:       218745456 kB
Active(anon):    7542528 kB
Inactive(anon):   274984 kB
Active(file):   1019227444 kB
Inactive(file): 218470472 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       9765372 kB
SwapFree:        9765372 kB
Dirty:              4976 kB
Writeback:             0 kB
AnonPages:       7696592 kB
Mapped:            90216 kB
Shmem:            120212 kB
Slab:           144289884 kB
SReclaimable:   136424256 kB
SUnreclaim:      7865628 kB
KernelStack:       16176 kB
PageTables:        25844 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    801763196 kB
Committed_AS:   12122188 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:     1826624 kB
DirectMap2M:    224344064 kB
DirectMap1G:    1385168896 kB

$ cat /proc/mounts
.....
/dev/sda /z/home xfs rw,relatime,attr2,inode64,sunit=1024,swidth=2048,noquota 0 0

$ cat /proc/partitions 
major minor  #blocks  name
   8        0 109381156864 sda
   8       16 39048970240 sdb
   8       32  585498624 sdc
   8       33    9765376 sdc1
   8       34          1 sdc2
   8       37  575732480 sdc5
  11        0    1048575 sr0

Hardware raid on Dell PERC H840

Raid50, 8 disk per span, 4 spans.
RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3
Size                : 101.869 TB
Sector Size         : 512
Parity Size         : 14.552 TB
State               : Optimal
Strip Size          : 512 KB
Number Of Drives per span:8
Span Depth          : 4

6Gb cache on controller, battery backed up.

Disks are 4Tb Toshiba 12G SAS disks.

Not running LVM.
