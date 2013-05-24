Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27D837CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 03:52:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 907A2AC001
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 01:52:11 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id aZGYAL13N7Ndajeh for
	<xfs@oss.sgi.com>; Fri, 24 May 2013 01:52:09 -0700 (PDT)
Date: Fri, 24 May 2013 04:52:06 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <986348673.5787542.1369385526612.JavaMail.root@redhat.com>
In-Reply-To: <20130523035115.GY24543@dastard>
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
	<20130523035115.GY24543@dastard>
Subject: Re: 3.9.3: Oops running xfstests
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com



----- Original Message -----
> From: "Dave Chinner" <david@fromorbit.com>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: xfs@oss.sgi.com, stable@vger.kernel.org
> Sent: Thursday, May 23, 2013 11:51:15 AM
> Subject: Re: 3.9.3: Oops running xfstests
> 
> On Wed, May 22, 2013 at 11:21:17PM -0400, CAI Qian wrote:
> > Fedora-19 based distro and LVM partitions.
> 
> Cai: As I've asked previously please include all the relevant
> information about your test system and the workload it is running
> when the problem occurs.  Stack traces aren't any good to us in
> isolation, and just dumping them on us causes unnecessary round
> trips.
> 
> http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
Sometimes, those information is going to drive me crazy due to the
amount of information need to gather from a system that been already
returned to the automation testing system pool and I never have access
to it anymore. Some of the information has like very little percentage
of the relevant as far as I can tell. I knew sometimes that 1% percentage
does count but the amount of efforts need to gather that 1% just crazy. :)
Since we have been in the same company, feel free to ping me and I can
give you the instruction to access the system and reproducer for it. Also,
I have been reproduced this on several x64 systems and nothing special
about the hardware and this panic at memmove is also very much similar to
those s390x/ppc64 stack overrun cases which has memove, xfs-leaf on the
trace, http://oss.sgi.com/archives/xfs/2013-05/msg00768.html

I will provide the information as far I knew for now.
- kernel version (uname -a): 3.9.3
- xfsprogs version (xfs_repair -V): Fedora-19 xfsprogs-3.1.10
- number of CPUs: 8
- contents of /proc/meminfo:
MemTotal:       16367152 kB
MemFree:        15723040 kB
Buffers:            1172 kB
Cached:           313016 kB
SwapCached:            0 kB
Active:           252388 kB
Inactive:         172832 kB
Active(anon):     111376 kB
Inactive(anon):      260 kB
Active(file):     141012 kB
Inactive(file):   172572 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       8257532 kB
SwapFree:        8257532 kB
Dirty:              5008 kB
Writeback:             0 kB
AnonPages:        110800 kB
Mapped:            22944 kB
Shmem:               564 kB
Slab:              69100 kB
SReclaimable:      26524 kB
SUnreclaim:        42576 kB
KernelStack:        1488 kB
PageTables:         5896 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    16441108 kB
Committed_AS:     265500 kB
VmallocTotal:   34359738367 kB
VmallocUsed:       45288 kB
VmallocChunk:   34347010568 kB
HardwareCorrupted:     0 kB
AnonHugePages:      2048 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       77440 kB
DirectMap2M:    16764928 kB
- contents of /proc/mounts: nothing special. Just Fedora-19 autopart
- contents of /proc/partitions: nothing special. Just Fedora-19 autopart
- RAID layout (hardware and/or software):
Nothing special,
06:21:51,812 INFO kernel:[   27.480775] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 0, phy 0, sas_addr 0x500000e0130ddbe2
06:21:51,812 NOTICE kernel:[   27.539634] scsi 0:0:0:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5
06:21:51,812 INFO kernel:[   27.592421] mptsas: ioc0: attaching ssp device: fw_channel 0, fw_id 1, phy 1, sas_addr 0x500000e0130fa8f2
06:21:51,812 NOTICE kernel:[   27.651334] scsi 0:0:1:0: Direct-Access     IBM-ESXS MAY2073RC        T107 PQ: 0 ANSI: 5
06:21:51,812 NOTICE kernel:[   27.753114] sd 0:0:0:0: [sda] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
06:21:51,812 NOTICE kernel:[   27.798987] sd 0:0:1:0: [sdb] 143374000 512-byte logical blocks: (73.4 GB/68.3 GiB)
06:21:51,812 NOTICE kernel:[   27.847388] sd 0:0:0:0: [sda] Write Protect is off
06:21:51,812 NOTICE kernel:[   27.847396] sd 0:0:1:0: [sdb] Write Protect is off
06:21:51,812 DEBUG kernel:[   27.847398] sd 0:0:1:0: [sdb] Mode Sense: d7 00 00 08
06:21:51,812 DEBUG kernel:[   27.904710] sd 0:0:0:0: [sda] Mode Sense: d7 00 00 08
06:21:51,812 NOTICE kernel:[   27.905323] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
06:21:51,812 NOTICE kernel:[   27.960059] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
06:21:51,812 INFO kernel:[   27.998854]  sdb: sdb1
06:21:51,812 NOTICE kernel:[   28.025249] sd 0:0:1:0: [sdb] Attached SCSI disk
06:21:51,812 INFO kernel:[   28.096714]  sda: sda1 sda2
06:21:51,812 NOTICE kernel:[   28.139844] sd 0:0:0:0: [sda] Attached SCSI disk
- LVM configuration: nothing special. Just Fedora-19 autopart. The below information
  from the installation time. Later, everything been formatted to XFS.
  name = vg_ibmls4102-lv_root  status = True  kids = 0 id = 7
  parents = ['existing 139508MB lvmvg vg_ibmls4102 (3)']
  uuid = wVn1JV-DQ4U-vXHD-liJi-kX0M-O6eA-geU4gs  size = 51200.0
  format = existing ext4 filesystem
  major = 0  minor = 0  exists = True  protected = False
  sysfs path = /devices/virtual/block/dm-1  partedDevice = parted.Device instance --
  model: Linux device-mapper (linear)  path: /dev/mapper/vg_ibmls4102-lv_root  type: 12
  sectorSize: 512  physicalSectorSize:  512
  length: 104857600  openCount: 0  readOnly: False
  externalMode: False  dirty: False  bootDirty: False
  host: 13107  did: 13107  busy: False
  hardwareGeometry: (6527, 255, 63)  biosGeometry: (6527, 255, 63)
  PedDevice: <_ped.Device object at 0x7f5ffd504b00>
  target size = 51200.0  path = /dev/mapper/vg_ibmls4102-lv_root
  format args = []  originalFormat = ext4  target = None  dmUuid = None  VG device = LVMVolumeGroupDevice instance (0x7f5fee7e3590) --
  name = vg_ibmls4102  status = True  kids = 3 id = 3
  parents = ['existing 69505MB partition sda2 (2) with existing lvmpv',
 'existing 70005MB partition sdb1 (5) with existing lvmpv']
  uuid = X0Bee2-lAuT-egUe-AXc1-a69j-dfmK-3ex1CB  size = 139508
  format = existing None
  major = 0  minor = 0  exists = True  protected = False
  sysfs path =   partedDevice = None
  target size = 0  path = /dev/mapper/vg_ibmls4102
  format args = []  originalFormat = None  target = None  dmUuid = None  free = 0.0  PE Size = 4.0  PE Count = 34877
  PE Free = 0  PV Count = 2
  LV Names = ['lv_home', 'lv_root', 'lv_swap']  modified = False
  extents = 34877.0  free space = 0
  free extents = 0.0  reserved percent = 0  reserved space = 0
  PVs = ['existing 69505MB partition sda2 (2) with existing lvmpv',
 'existing 70005MB partition sdb1 (5) with existing lvmpv']
  LVs = ['existing 71028MB lvmlv vg_ibmls4102-lv_home (6) with existing ext4 filesystem',
 'existing 51200MB lvmlv vg_ibmls4102-lv_root (7) with existing ext4 filesystem',
 'existing 17280MB lvmlv vg_ibmls4102-lv_swap (8) with existing swap']
  percent = 0
  mirrored = False stripes = 1  snapshot total =  0MB
  VG space used = 51200MB
- type of disks you are using: nothing special
- write cache status of drives: missed; need to reprovision the system.
- size of BBWC and mode it is running in: missed; need to reprovision the system.
- xfs_info output on the filesystem in question: missed; need to reprovision the system.
- dmesg output showing all error messages and stack traces:
  http://people.redhat.com/qcai/stable/console.txt
> 
> 
> > [  304.898489]
> > =============================================================================
> > [  304.898489] BUG kmalloc-4096 (Tainted: G      D     ): Padding
> > overwritten. 0xffff8801fbeb7c28-0xffff8801fbeb7fff
> > [  304.898490]
> > -----------------------------------------------------------------------------
> > [  304.898490]
> > [  304.898491] INFO: Slab 0xffffea0007efac00 objects=7 used=7 fp=0x
> > (null) flags=0x20000000004080
> > [  304.898492] Pid: 357, comm: systemd-udevd Tainted: G    B D      3.9.3
> > #1
> > [  304.898492] Call Trace:
> > [  304.898495]  [<ffffffff81181ed2>] slab_err+0xc2/0xf0
> > [  304.898497]  [<ffffffff8118176d>] ? init_object+0x3d/0x70
> > [  304.898498]  [<ffffffff81181ff5>] slab_pad_check.part.41+0xf5/0x170
> > [  304.898500]  [<ffffffff811bda63>] ? seq_read+0x2e3/0x3b0
> > [  304.898501]  [<ffffffff811820e3>] check_slab+0x73/0x100
> > [  304.898503]  [<ffffffff81606b50>] alloc_debug_processing+0x21/0x118
> > [  304.898504]  [<ffffffff8160772f>] __slab_alloc+0x3b8/0x4a2
> > [  304.898506]  [<ffffffff81161b57>] ? vma_link+0xb7/0xc0
> > [  304.898508]  [<ffffffff811bda63>] ? seq_read+0x2e3/0x3b0
> > [  304.898509]  [<ffffffff81184dd1>] kmem_cache_alloc_trace+0x1b1/0x200
> > [  304.898510]  [<ffffffff811bda63>] seq_read+0x2e3/0x3b0
> > [  304.898512]  [<ffffffff8119c56c>] vfs_read+0x9c/0x170
> > [  304.898513]  [<ffffffff8119c939>] sys_read+0x49/0xa0
> > [  304.898514]  [<ffffffff81619359>] system_call_fastpath+0x16/0x1b
> 
> That's something different, and indicates memory corruption is being
> seen as a result of something that is occuring through the /proc or
> /sys filesystems. Unrelated to XFS, I think...
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
