Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39750 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfA1X0i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 18:26:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 69C0F2B082
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 23:26:35 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] Possibly vfs cache related replicable xfs regression
 since 4.19.0  on sata hdd:s
Date: Mon, 28 Jan 2019 23:26:32 +0000
Message-ID: <bug-202441-201763-InGMajsRVS@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202441-201763@https.bugzilla.kernel.org/>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

--- Comment #2 from Roger (rogan6710@gmail.com) ---

Hello Dave !
Thanks for the really fast reply :)
Here is most of the (rather lengthy) system information:

Single "eight" core processor:

rogan@trooper:~$ uname -a
Linux trooper.morgoth.org 4.19.18 #2 SMP Sat Jan 26 13:43:16 CST 2019 x86_64
AMD FX(tm)-9590 Eight-Core Processor AuthenticAMD GNU/Linux

root@trooper:~# xfs_repair -V
xfs_repair version 4.19.0

root@trooper:~# cat /proc/meminfo 
MemTotal:       24645396 kB
MemFree:          358452 kB
MemAvailable:   22044292 kB
Buffers:            3152 kB
Cached:         22005216 kB
SwapCached:            0 kB
Active:          1713092 kB
Inactive:       21824100 kB
Active(anon):    1157816 kB
Inactive(anon):   555736 kB
Active(file):     555276 kB
Inactive(file): 21268364 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       8388604 kB
SwapFree:        8388604 kB
Dirty:              5980 kB
Writeback:             0 kB
AnonPages:       1528944 kB
Mapped:           531340 kB
Shmem:            254920 kB
Slab:             565012 kB
SReclaimable:     502684 kB
SUnreclaim:        62328 kB
KernelStack:       10448 kB
PageTables:        18100 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    20711300 kB
Committed_AS:    5195092 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
Percpu:             3232 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
CmaTotal:              0 kB
CmaFree:               0 kB
DirectMap4k:     2698836 kB
DirectMap2M:    22364160 kB
DirectMap1G:           0 kB

root@trooper:~# cat /proc/mounts 
proc /proc proc rw,relatime 0 0
sysfs /sys sysfs rw,relatime 0 0
tmpfs /run tmpfs rw,nosuid,nodev,noexec,relatime,size=32768k,mode=755 0 0
devtmpfs /dev devtmpfs rw,relatime,size=8192k,nr_inodes=3070316,mode=755 0 0
/dev/sda1 / xfs rw,relatime,attr2,inode64,noquota 0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /dev/shm tmpfs rw,relatime 0 0
cgroup_root /sys/fs/cgroup tmpfs rw,relatime,size=8192k,mode=755 0 0
cpuset /sys/fs/cgroup/cpuset cgroup rw,relatime,cpuset,clone_children 0 0
cpu /sys/fs/cgroup/cpu cgroup rw,relatime,cpu 0 0
cpuacct /sys/fs/cgroup/cpuacct cgroup rw,relatime,cpuacct 0 0
blkio /sys/fs/cgroup/blkio cgroup rw,relatime,blkio 0 0
memory /sys/fs/cgroup/memory cgroup rw,relatime,memory 0 0
devices /sys/fs/cgroup/devices cgroup rw,relatime,devices 0 0
freezer /sys/fs/cgroup/freezer cgroup rw,relatime,freezer 0 0
net_cls /sys/fs/cgroup/net_cls cgroup rw,relatime,net_cls 0 0
perf_event /sys/fs/cgroup/perf_event cgroup
rw,relatime,perf_event,release_agent=/run/cgmanager/agents/cgm-release-agent.perf_event
0 0
net_prio /sys/fs/cgroup/net_prio cgroup rw,relatime,net_prio 0 0
pids /sys/fs/cgroup/pids cgroup
rw,relatime,pids,release_agent=/run/cgmanager/agents/cgm-release-agent.pids 0 0
/dev/sdb1 /home xfs rw,nosuid,nodev,relatime,attr2,inode64,noquota 0 0
192.168.1.2:/export/vol0 /export/vol0 nfs
rw,relatime,vers=3,rsize=8192,wsize=8192,namlen=255,hard,proto=tcp,timeo=10,retrans=2,sec=sys,mountaddr=192.168.1.2,mountvers=3,mountport=887,mountproto=tcp,local_lock=none,addr=192.168.1.2
0 0
192.168.1.2:/export/vol1 /export/vol1 nfs
rw,relatime,vers=3,rsize=8192,wsize=8192,namlen=255,hard,proto=tcp,timeo=10,retrans=2,sec=sys,mountaddr=192.168.1.2,mountvers=3,mountport=887,mountproto=tcp,local_lock=none,addr=192.168.1.2
0 0
192.168.1.2:/export/vol2 /export/vol2 nfs
rw,relatime,vers=3,rsize=8192,wsize=8192,namlen=255,hard,proto=tcp,timeo=10,retrans=2,sec=sys,mountaddr=192.168.1.2,mountvers=3,mountport=887,mountproto=tcp,local_lock=none,addr=192.168.1.2
0 0
192.168.1.2:/export/vol3 /export/vol3 nfs
rw,relatime,vers=3,rsize=8192,wsize=8192,namlen=255,hard,proto=tcp,timeo=10,retrans=2,sec=sys,mountaddr=192.168.1.2,mountvers=3,mountport=887,mountproto=tcp,local_lock=none,addr=192.168.1.2
0 0
192.168.1.2:/export/vol4 /export/vol4 nfs
rw,relatime,vers=3,rsize=8192,wsize=8192,namlen=255,hard,proto=tcp,timeo=10,retrans=2,sec=sys,mountaddr=192.168.1.2,mountvers=3,mountport=887,mountproto=tcp,local_lock=none,addr=192.168.1.2
0 0
devpts /dev/pts devpts rw,relatime,gid=5,mode=620,ptmxmode=000 0 0
fusectl /sys/fs/fuse/connections fusectl rw,relatime 0 0
gvfsd-fuse /home/rogan/.gvfs fuse.gvfsd-fuse
rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0
/dev/sdc1 /mnt/d0 xfs rw,relatime,attr2,inode64,noquota 0 0
/dev/sdd1 /mnt/d1 xfs rw,relatime,attr2,inode64,noquota 0 0
/dev/sde1 /mnt/d2 xfs rw,relatime,attr2,inode64,noquota 0 0

root@trooper:~# cat /proc/partitions 
major minor  #blocks  name

   1        0      16384 ram0
   1        1      16384 ram1
   1        2      16384 ram2
   1        3      16384 ram3
   1        4      16384 ram4
   1        5      16384 ram5
   1        6      16384 ram6
   1        7      16384 ram7
   1        8      16384 ram8
   1        9      16384 ram9
   1       10      16384 ram10
   1       11      16384 ram11
   1       12      16384 ram12
   1       13      16384 ram13
   1       14      16384 ram14
   1       15      16384 ram15
   8        0  244198584 sda
   8        1  244198535 sda1
   8       16  468851544 sdb
   8       17  468851495 sdb1
   8       32  976762584 sdc
   8       33  976761560 sdc1
   8       48  976762584 sdd
   8       49  976761560 sdd1
   8       64  976762584 sde
   8       65  976761560 sde1
  11        0    1048575 sr0

root@trooper:~# hdparm -I /dev/sd[abcde]

/dev/sda:

ATA device, with non-removable media
        Model Number:       WDC WDS250G2B0A-00SM50                  
        Serial Number:      173859420723        
        Firmware Revision:  X61130WD
        Media Serial Num:   
        Media Manufacturer: 
        Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions,
SATA Rev 2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
        Used: unknown (minor revision code 0x005e) 
        Supported: 11 10 9 8 7 6 5 
        Likely used: 11
Configuration:
        Logical         max     current
        cylinders       16383   0
        heads           16      0
        sectors/track   63      0
        --
        LBA    user addressable sectors:   268435455
        LBA48  user addressable sectors:   488397168
        Logical  Sector size:                   512 bytes
        Physical Sector size:                   512 bytes
        Logical Sector-0 offset:                  0 bytes
        device size with M = 1024*1024:      238475 MBytes
        device size with M = 1000*1000:      250059 MBytes (250 GB)
        cache/buffer size  = unknown
        Form Factor: 2.5 inch
        Nominal Media Rotation Rate: Solid State Device
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max = 1   Current = 1
        Advanced power management level: 128
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4 
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
           *    48-bit Address feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    64-bit World wide name
           *    WRITE_UNCORRECTABLE_EXT command
           *    {READ,WRITE}_DMA_EXT_GPL commands
           *    Segmented DOWNLOAD_MICROCODE
                unknown 119[8]
           *    Gen1 signaling speed (1.5Gb/s)
           *    Gen2 signaling speed (3.0Gb/s)
           *    Gen3 signaling speed (6.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Phy event counters
           *    READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
           *    DMA Setup Auto-Activate optimization
                Device-initiated interface power management
                Asynchronous notification (eg. media change)
           *    Software settings preservation
                Device Sleep (DEVSLP)
           *    SANITIZE feature set
           *    BLOCK_ERASE_EXT command
           *    DOWNLOAD MICROCODE DMA command
           *    WRITE BUFFER DMA command
           *    READ BUFFER DMA command
           *    Data Set Management TRIM supported (limit 8 blocks)
           *    Deterministic read ZEROs after TRIM
Security: 
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
                supported: enhanced erase
        2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5001b444a973c828
        NAA             : 5
        IEEE OUI        : 001b44
        Unique ID       : 4a973c828
Device Sleep:
        DEVSLP Exit Timeout (DETO): 30 ms (drive)
        Minimum DEVSLP Assertion Time (MDAT): 30 ms (drive)
Checksum: correct

/dev/sdb:

ATA device, with non-removable media
        Model Number:       INTEL SSDSC2KW480H6                     
        Serial Number:      CVLT62460810480EGN  
        Firmware Revision:  LSF031C
        Transport:          Serial, ATA8-AST, SATA 1.0a, SATA II Extensions,
SATA Rev 2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
        Used: unknown (minor revision code 0xffff) 
        Supported: 10 9 8 7 6 5 
        Likely used: 10
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:    16514064
        LBA    user addressable sectors:   268435455
        LBA48  user addressable sectors:   937703088
        Logical  Sector size:                   512 bytes
        Physical Sector size:                   512 bytes
        Logical Sector-0 offset:                  0 bytes
        device size with M = 1024*1024:      457862 MBytes
        device size with M = 1000*1000:      480103 MBytes (480 GB)
        cache/buffer size  = unknown
        Form Factor: 2.5 inch
        Nominal Media Rotation Rate: Solid State Device
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 16
        Advanced power management level: 254
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4 
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    NOP cmd
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
           *    48-bit Address feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    64-bit World wide name
           *    IDLE_IMMEDIATE with UNLOAD
           *    WRITE_UNCORRECTABLE_EXT command
           *    {READ,WRITE}_DMA_EXT_GPL commands
           *    Segmented DOWNLOAD_MICROCODE
           *    Gen1 signaling speed (1.5Gb/s)
           *    Gen2 signaling speed (3.0Gb/s)
           *    Gen3 signaling speed (6.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Host-initiated interface power management
           *    Phy event counters
           *    DMA Setup Auto-Activate optimization
                Device-initiated interface power management
           *    Software settings preservation
                Device Sleep (DEVSLP)
           *    SMART Command Transport (SCT) feature set
           *    SCT Error Recovery Control (AC3)
           *    SCT Features Control (AC4)
           *    SCT Data Tables (AC5)
           *    SANITIZE feature set
           *    CRYPTO_SCRAMBLE_EXT command
           *    BLOCK_ERASE_EXT command
           *    reserved 69[4]
           *    DOWNLOAD MICROCODE DMA command
           *    WRITE BUFFER DMA command
           *    READ BUFFER DMA command
           *    Data Set Management TRIM supported (limit 8 blocks)
           *    Deterministic read data after TRIM
Security: 
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
                supported: enhanced erase
        4min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 55cd2e414d07e84e
        NAA             : 5
        IEEE OUI        : 5cd2e4
        Unique ID       : 14d07e84e
Device Sleep:
        DEVSLP Exit Timeout (DETO): 20 ms (drive)
        Minimum DEVSLP Assertion Time (MDAT): 31 ms (drive)
Checksum: correct

/dev/sdc:

ATA device, with non-removable media
        Model Number:       ST1000DM003-1ER162                      
        Serial Number:      Z4Y5FJF6
        Firmware Revision:  CC45    
        Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev
2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
        Used: unknown (minor revision code 0x001f) 
        Supported: 9 8 7 6 5 
        Likely used: 9
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:    16514064
        LBA    user addressable sectors:   268435455
        LBA48  user addressable sectors:  1953525168
        Logical  Sector size:                   512 bytes
        Physical Sector size:                  4096 bytes
        Logical Sector-0 offset:                  0 bytes
        device size with M = 1024*1024:      953869 MBytes
        device size with M = 1000*1000:     1000204 MBytes (1000 GB)
        cache/buffer size  = unknown
        Form Factor: 3.5 inch
        Nominal Media Rotation Rate: 7200
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 16
        Advanced power management level: 254
        Recommended acoustic management value: 208, current value: 208
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4 
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                SET_MAX security extension
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    64-bit World wide name
                Write-Read-Verify feature set
           *    WRITE_UNCORRECTABLE_EXT command
           *    {READ,WRITE}_DMA_EXT_GPL commands
           *    Segmented DOWNLOAD_MICROCODE
           *    unknown 119[6]
           *    Gen1 signaling speed (1.5Gb/s)
           *    Gen2 signaling speed (3.0Gb/s)
           *    Gen3 signaling speed (6.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Phy event counters
           *    READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
           *    DMA Setup Auto-Activate optimization
                Device-initiated interface power management
           *    Software settings preservation
                unknown 78[7]
           *    SMART Command Transport (SCT) feature set
           *    SCT Write Same (AC2)
                unknown 206[7]
                unknown 206[12] (vendor specific)
           *    SANITIZE feature set
           *    OVERWRITE_EXT command
Security: 
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
                supported: enhanced erase
        100min for SECURITY ERASE UNIT. 100min for ENHANCED SECURITY ERASE
UNIT.
Logical Unit WWN Device Identifier: 5000c5007aab9de1
        NAA             : 5
        IEEE OUI        : 000c50
        Unique ID       : 07aab9de1
Checksum: correct

/dev/sdd:

ATA device, with non-removable media
        Model Number:       ST1000DM003-1ER162                      
        Serial Number:      Z4Y1SAVG
        Firmware Revision:  CC43    
        Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev
2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
        Used: unknown (minor revision code 0x001f) 
        Supported: 9 8 7 6 5 
        Likely used: 9
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:    16514064
        LBA    user addressable sectors:   268435455
        LBA48  user addressable sectors:  1953525168
        Logical  Sector size:                   512 bytes
        Physical Sector size:                  4096 bytes
        Logical Sector-0 offset:                  0 bytes
        device size with M = 1024*1024:      953869 MBytes
        device size with M = 1000*1000:     1000204 MBytes (1000 GB)
        cache/buffer size  = unknown
        Form Factor: 3.5 inch
        Nominal Media Rotation Rate: 7200
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 16
        Advanced power management level: 254
        Recommended acoustic management value: 208, current value: 208
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4 
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                SET_MAX security extension
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    64-bit World wide name
                Write-Read-Verify feature set
           *    WRITE_UNCORRECTABLE_EXT command
           *    {READ,WRITE}_DMA_EXT_GPL commands
           *    Segmented DOWNLOAD_MICROCODE
           *    unknown 119[6]
           *    Gen1 signaling speed (1.5Gb/s)
           *    Gen2 signaling speed (3.0Gb/s)
           *    Gen3 signaling speed (6.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Phy event counters
           *    READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
           *    DMA Setup Auto-Activate optimization
                Device-initiated interface power management
           *    Software settings preservation
                unknown 78[7]
           *    SMART Command Transport (SCT) feature set
           *    SCT Write Same (AC2)
                unknown 206[7]
                unknown 206[12] (vendor specific)
           *    SANITIZE feature set
           *    OVERWRITE_EXT command
           *    reserved 69[7]
Security: 
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
                supported: enhanced erase
        98min for SECURITY ERASE UNIT. 98min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 5000c500793959c3
        NAA             : 5
        IEEE OUI        : 000c50
        Unique ID       : 0793959c3
Checksum: correct

/dev/sde:

ATA device, with non-removable media
        Model Number:       ST1000DM003-1ER162                      
        Serial Number:      Z4Y9C367
        Firmware Revision:  CC45    
        Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev
2.5, SATA Rev 2.6, SATA Rev 3.0
Standards:
        Used: unknown (minor revision code 0x001f) 
        Supported: 9 8 7 6 5 
        Likely used: 9
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:    16514064
        LBA    user addressable sectors:   268435455
        LBA48  user addressable sectors:  1953525168
        Logical  Sector size:                   512 bytes
        Physical Sector size:                  4096 bytes
        Logical Sector-0 offset:                  0 bytes
        device size with M = 1024*1024:      953869 MBytes
        device size with M = 1000*1000:     1000204 MBytes (1000 GB)
        cache/buffer size  = unknown
        Form Factor: 3.5 inch
        Nominal Media Rotation Rate: 7200
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 16
        Advanced power management level: 254
        Recommended acoustic management value: 208, current value: 208
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4 
             Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
                Power-Up In Standby feature set
           *    SET_FEATURES required to spinup after power up
                SET_MAX security extension
           *    48-bit Address feature set
           *    Device Configuration Overlay feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    General Purpose Logging feature set
           *    WRITE_{DMA|MULTIPLE}_FUA_EXT
           *    64-bit World wide name
                Write-Read-Verify feature set
           *    WRITE_UNCORRECTABLE_EXT command
           *    {READ,WRITE}_DMA_EXT_GPL commands
           *    Segmented DOWNLOAD_MICROCODE
           *    unknown 119[6]
           *    Gen1 signaling speed (1.5Gb/s)
           *    Gen2 signaling speed (3.0Gb/s)
           *    Gen3 signaling speed (6.0Gb/s)
           *    Native Command Queueing (NCQ)
           *    Phy event counters
           *    READ_LOG_DMA_EXT equivalent to READ_LOG_EXT
           *    DMA Setup Auto-Activate optimization
                Device-initiated interface power management
           *    Software settings preservation
                unknown 78[7]
           *    SMART Command Transport (SCT) feature set
           *    SCT Write Same (AC2)
                unknown 206[7]
                unknown 206[12] (vendor specific)
           *    SANITIZE feature set
           *    OVERWRITE_EXT command
Security: 
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
                supported: enhanced erase
        104min for SECURITY ERASE UNIT. 104min for ENHANCED SECURITY ERASE
UNIT.
Logical Unit WWN Device Identifier: 5000c50086e4bcd4
        NAA             : 5
        IEEE OUI        : 000c50
        Unique ID       : 086e4bcd4
Checksum: correct

 xfs_info /dev/sdc1
xfs_info: /dev/sdc1 contains a mounted filesystem

fatal error -- couldn't initialize XFS library

hmm ?

root@trooper:~# umount /mnt/d0/
root@trooper:~# umount /mnt/d1/
root@trooper:~# umount /mnt/d2/
root@trooper:~# xfs_info /dev/sdc1
meta-data=/dev/sdc1              isize=512    agcount=4, agsize=61047598 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=244190390, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=119233, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

xfs_info /dev/sdd1
meta-data=/dev/sdd1              isize=512    agcount=4, agsize=61047598 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=244190390, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=119233, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

root@trooper:~# xfs_info /dev/sde1 
meta-data=/dev/sde1              isize=512    agcount=4, agsize=61047598 blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=244190390, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=119233, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

/home and / (on ssd's) are made with the older version of mkfs.xfs so they 
don't have the sparse inode feature enabled. And I have tested both versions of
mkfs.xfs with the exact same result unfortunately. Otherwise all systems are
made with default options (i.e. no options).

I knew about that vfs_cache_pressure=0 "drawback", it's not a fix :(

While testing I have never seen any tendency to swap. I have tested with
swappiness=100 and different swap sizes and areas and even a swap file now
(thanks for the recent fallocate addition, much appreciated :) ).

I'll do a quick run and give you some dmesg

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
