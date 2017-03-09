Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47438 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752737AbdCIM7W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 07:59:22 -0500
Date: Thu, 9 Mar 2017 07:59:20 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: 4.11.0-rc1 boot resulted in WARNING: CPU: 14 PID: 1722 at
 fs/sysfs/dir.c:31 .sysfs_warn_dup+0x78/0xb0
Message-ID: <20170309125919.GA16713@bfoster.bfoster>
References: <1488904264.3961.17.camel@abdul-ThinkPad-T450>
 <20170308131705.GB23404@bfoster.bfoster>
 <1489056606.3961.41.camel@abdul-ThinkPad-T450>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1489056606.3961.41.camel@abdul-ThinkPad-T450>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: linux-xfs@vger.kernel.org, mpe@ellerman.id, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org

cc linux-block

On Thu, Mar 09, 2017 at 04:20:06PM +0530, Abdul Haleem wrote:
> On Wed, 2017-03-08 at 08:17 -0500, Brian Foster wrote:
> > On Tue, Mar 07, 2017 at 10:01:04PM +0530, Abdul Haleem wrote:
> > > 
> > > Hi,
> > > 
> > > Today's mainline (4.11.0-rc1) booted with warnings on Power7 LPAR.
> > > 
> > > Issue is not reproducible all the time.
> > > 
> > > traces:
> > > --------
> > > Found device VDASD 5.
> > > Mounting /home...
> > > Reached target Swap.
> > > Found device VDASD 2.
> > > 
> > > Mounting /boot...
> > > 
> > > sysfs: cannot create duplicate filename '/fs/xfs/sda'
> > 
> > That is strange. The sysfs name is ultimately based on the superblock id
> > (sb->s_id), which afaik should reflect the underlying device and thus be
> > unique. Just to be sure, do you otherwise have a mounted and functional
> > sysfs dir?
> > 
> > I assume after this boot you have a mounted 'sda' device somewhere.. If
> > so, what content already exists under the sysfs fs/xfs/sda subdir when
> > the duplicate warning occurs? Has the associated device been
> > mounted/unmounted before this occurs, or is there anything abnormal
> > going on during boot up, such as device repartitioning, devices coming
> > and going, etc..?
> 
> Brian, Thanks for looking into this issue.
> 
> No, the system is not in same state, it was overwritten by other runs of
> Automation framework.
> 
> However the boot logs are preserved and attached here.
> 
> > 
> > What does 'mount' show for this system when the problem occurs vs. when
> > it doesn't? It might be useful to post the full boot log for when this
> > occurs as well.
> 
> I do not have any sysfs info when warning occursm but on a normal system
> (with out warning):
> 
> # mount
> sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
> proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
> devtmpfs on /dev type devtmpfs
> (rw,nosuid,size=41833088k,nr_inodes=653642,mode=755)
> securityfs on /sys/kernel/security type securityfs
> (rw,nosuid,nodev,noexec,relatime)
> tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
> devpts on /dev/pts type devpts
> (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
> tmpfs on /run type tmpfs (rw,nosuid,nodev,mode=755)
> tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
> cgroup on /sys/fs/cgroup/systemd type cgroup
> (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
> pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
> cgroup on /sys/fs/cgroup/cpuset type cgroup
> (rw,nosuid,nodev,noexec,relatime,cpuset)
> cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup
> (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
> cgroup on /sys/fs/cgroup/freezer type cgroup
> (rw,nosuid,nodev,noexec,relatime,freezer)
> cgroup on /sys/fs/cgroup/hugetlb type cgroup
> (rw,nosuid,nodev,noexec,relatime,hugetlb)
> cgroup on /sys/fs/cgroup/devices type cgroup
> (rw,nosuid,nodev,noexec,relatime,devices)
> cgroup on /sys/fs/cgroup/net_cls type cgroup
> (rw,nosuid,nodev,noexec,relatime,net_cls)
> cgroup on /sys/fs/cgroup/blkio type cgroup
> (rw,nosuid,nodev,noexec,relatime,blkio)
> cgroup on /sys/fs/cgroup/memory type cgroup
> (rw,nosuid,nodev,noexec,relatime,memory)
> cgroup on /sys/fs/cgroup/perf_event type cgroup
> (rw,nosuid,nodev,noexec,relatime,perf_event)
> configfs on /sys/kernel/config type configfs (rw,relatime)
> /dev/sda3 on / type ext4 (rw,relatime,data=ordered)
> systemd-1 on /proc/sys/fs/binfmt_misc type autofs
> (rw,relatime,fd=24,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
> debugfs on /sys/kernel/debug type debugfs (rw,relatime)
> mqueue on /dev/mqueue type mqueue (rw,relatime)
> hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
> binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
> sunrpc on /var/lib/nfs/rpc_pipefs type rpc_pipefs (rw,relatime)
> nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
> /dev/sda2 on /boot type xfs (rw,relatime,attr2,inode64,noquota)
> /dev/sda5 on /home type xfs (rw,relatime,attr2,inode64,noquota)

So you have two XFS filesystems mounted on partitions of this device,
sda2 and sda5.

> tmpfs on /run/user/0 type tmpfs
> (rw,nosuid,nodev,relatime,size=8375680k,mode=700)
> 
> # ls /sys/fs/xfs
> sda  sda5  stats
> 

Yet under /sys/fs/xfs we have sda and sda5. Presumably sda here refers
to sda2.

> # df -h
> Filesystem      Size  Used Avail Use% Mounted on
> devtmpfs         40G     0   40G   0% /dev
> tmpfs            40G     0   40G   0% /dev/shm
> tmpfs            40G   14M   40G   1% /run
> tmpfs            40G     0   40G   0% /sys/fs/cgroup
> /dev/sda3       394G   17G  358G   5% /
> /dev/sda2        40G  673M   40G   2% /boot
> /dev/sda5       100G   21G   80G  21% /home
> tmpfs           8.0G     0  8.0G   0% /run/user/0
> 
> # lsblk
> NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
> loop0    7:0    0   256M  0 loop 
> sda      8:0    0 558.9G  0 disk 
> ├─sda4   8:4    0     1K  0 part 
> ├─sda2   8:2    0    40G  0 part /boot
> ├─sda5   8:5    0   100G  0 part /home
> ├─sda3   8:3    0   400G  0 part /
> ├─sda1   8:1    0    10M  0 part 
> └─sda6   8:6    0    10G  0 part [SWAP]
> 

Six total partitions on the device...

> # cat /proc/partitions 
> major minor  #blocks  name
> 
>    8        0  586061784 sda
>    8        1      10240 sda
>    8        2   41943040 sda
>    8        3  419430400 sda3
>    8        4          1 sda
>    8        5  104857600 sda5
>    8        6   10485760 sda6
>    7        0     262144 loop0
> 

... and according to the kernel, three of them are named sda. :/ This
appears to be the crux of the problem. My understanding is that these
should all have unique names based on the partition. XFS is just going
to reuse that name to create the /sys/fs/xfs/<dev> subdir, so as soon as
you mount another XFS filesystem on top of one of those other similarly
named partitions, the error is going to trigger.

There's nothing obvious enough to me in the boot log to point at a
problem. I've CC'd the linux-block list to see if anybody more familiar
with the block layer might be able to comment on what could be going on
here.

Brian

> # xfs_info /home
> meta-data=/dev/sda5              isize=256    agcount=4, agsize=6553600
> blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=26214400,
> imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> # xfs_info /boot/
> meta-data=/dev/sda2              isize=256    agcount=4, agsize=2621440
> blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=10485760,
> imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=5120, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>  
> 
> # fdisk -l
> 
> Disk /dev/sda: 600.1 GB, 600127266816 bytes, 1172123568 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk label type: dos
> Disk identifier: 0xe2ab0400
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1   *        2048       22527       10240   41  PPC PReP Boot
> /dev/sda2           22528    83908607    41943040   83  Linux
> /dev/sda3        83908608   922769407   419430400   83  Linux
> /dev/sda4       922769408  1172121599   124676096    5  Extended
> /dev/sda5       922771456  1132486655   104857600   83  Linux
> /dev/sda6      1132488704  1153460223    10485760   82  Linux swap /
> Solaris
> 
> 
> Please let me know if you need more info.
> 
> > 
> > Brian
> > 
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 14 PID: 1722 at fs/sysfs/dir.c:31 .sysfs_warn_dup
> > > +0x78/0xb0
> > > Modules linked in: sg(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E)
> > > grace(E) sunrpc(E) binfmt_misc(E) ip_tables(E) ext4(E) mbcache(E)
> > > jbd2(E) sd_mod(E) ibmvscsi(E) ibmveth(E) scsi_transport_srp(E)
> > > CPU: 14 PID: 1722 Comm: mount Tainted: G        W   E   4.11.0-rc1-autotest #1
> > > task: c0000009ed3f9c80 task.stack: c0000009ed430000
> > > NIP: c0000000003a6c68 LR: c0000000003a6c64 CTR: 0000000001764c5c
> > > REGS: c0000009ed4333c0 TRAP: 0700   Tainted: G        W   E    (4.11.0-rc1-autotest)
> > > MSR: 800000000282b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>
> > >   CR: 22022822  XER: 00000006
> > > CFAR: c000000000994958 SOFTE: 1
> > > GPR00: c0000000003a6c64 c0000009ed433640 c00000000138a500 0000000000000035
> > > GPR04: c0000009ff88ada0 c0000009ff8a1658 00000000014cfc2c 0000000000000000
> > > GPR08: 0000000000000000 c000000000dd146c 00000009feac0000 0000000000003fef
> > > GPR12: 0000000022022844 c00000000e9f7e00 0000000037409c40 0000000037409c30
> > > GPR16: 0000000037409c28 ffffffffffffffff 0000000000000000 000000003741f1c8
> > > GPR20: 00000100147d1270 0000000000000000 00000000c0ed0000 00003fffa0f53384
> > > GPR24: c00000000394d178 c000000000c054c0 c000000001742e68 c0000000ff3ea640
> > > GPR28: c00000000394d640 c0000013eec28c28 c0000009f2ab0148 c000000003833000
> > > NIP [c0000000003a6c68] .sysfs_warn_dup+0x78/0xb0
> > > LR [c0000000003a6c64] .sysfs_warn_dup+0x74/0xb0
> > > Call Trace:
> > > [c0000009ed433640] [c0000000003a6c64] .sysfs_warn_dup+0x74/0xb0 (unreliable)
> > > [c0000009ed4336d0] [c0000000003a6de4] .sysfs_create_dir_ns+0xc4/0xd0
> > > [c0000009ed433760] [c000000000551048] .kobject_add_internal+0xd8/0x450
> > > [c0000009ed433800] [c00000000055141c] .kobject_init_and_add+0x5c/0x90
> > > [c0000009ed433890] [c00000000044ac54] .xfs_mountfs+0x224/0xa30
> > > [c0000009ed433960] [c000000000452a90] .xfs_fs_fill_super+0x490/0x620
> > > [c0000009ed433a10] [c0000000002fefc0] .mount_bdev+0x220/0x260
> > > [c0000009ed433ac0] [c0000000004509b8] .xfs_fs_mount+0x18/0x30
> > > [c0000009ed433b30] [c000000000300520] .mount_fs+0x70/0x210
> > > [c0000009ed433bf0] [c000000000325930] .vfs_kern_mount+0x60/0x1c0
> > > [c0000009ed433cb0] [c00000000032a458] .do_mount+0x268/0xee0
> > > [c0000009ed433d90] [c00000000032b4ec] .SyS_mount+0x8c/0x100
> > > [c0000009ed433e30] [c00000000000b184] system_call+0x38/0xe0
> > > Instruction dump:
> > > 7fa3eb78 38800000 7fe5fb78 38c01000 4bffa929 60000000 3c62ff8b 7fe4fb78
> > > 38636ec8 7fc5f378 485edcb9 60000000 <0fe00000> 7fe3fb78 4bf1fb01 60000000
> > > ---[ end trace 78f08bafbc2388f3 ]---
> > > kobject_add_internal failed for sda with -EEXIST, don't try to register
> > > things with the same name in the same directory.
> > > 
> > > 
> > > -- 
> > > Regard's
> > > 
> > > Abdul Haleem
> > > IBM Linux Technology Centre
> > > 
> > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> 
> -- 
> Regard's
> 
> Abdul Haleem
> IBM Linux Technology Centre
> 
> 

> 02:41:31 [ 1183.879237] kvm: exiting hardware virtualization
> 02:41:31 [ 1183.880617] kexec: Starting new kernel
> 02:41:31 [ 1183.880718] kexec: waiting for cpu 0 (physical 0) to enter 2 state
> 02:41:31 [ 1183.881673] kexec: waiting for cpu 4 (physical 4) to enter 2 state
> 02:41:31 [ 1183.881731] kexec: waiting for cpu 5 (physical 5) to enter 2 state
> 02:41:31 [ 1183.881761] kexec: waiting for cpu 7 (physical 7) to enter 2 state
> 02:41:31 [ 1183.881792] kexec: waiting for cpu 12 (physical 12) to enter 2 state
> 02:41:31 [ 1183.881887] kexec: waiting for cpu 13 (physical 13) to enter 2 state
> 02:41:31 [ 1183.881924] kexec: waiting for cpu 29 (physical 29) to enter 2 state
> 02:41:31 [ 1183.881955] kexec: waiting for cpu 31 (physical 31) to enter 2 state
> 02:41:31 [ 1183.881987] kexec: waiting for cpu 36 (physical 36) to enter 2 state
> 02:41:31 [ 1183.882019] kexec: waiting for cpu 38 (physical 38) to enter 2 state
> 02:41:38 I'm in purgatory
> 02:41:40 [    0.000000] Page sizes from device-tree:
> 02:41:40 [    0.000000] base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
> 02:41:40 [    0.000000] base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
> 02:41:40 [    0.000000] base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
> 02:41:40 [    0.000000] base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
> 02:41:40 [    0.000000] base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
> 02:41:40 [    0.000000] base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
> 02:41:40 [    0.000000] base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
> 02:41:40 [    0.000000] Using 1TB segments
> 02:41:40 [    0.000000] Initializing hash mmu with SLB
> 02:41:40 [    0.000000] Linux version 4.11.0-rc1-autotest (root@p7-korg-ci1.pok.stglabs.ibm.com) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-4) (GCC) ) #1 SMP Mon Mar 6 16:03:25 EST 2017
> 02:41:40 [    0.000000] Found initrd at 0xc000000002f40000:0xc0000000041505b6
> 02:41:40 [    0.000000] Using pSeries machine description
> 02:41:40 [    0.000000] bootconsole [udbg0] enabled
> 02:41:40 [    0.000000] Partition configured for 40 cpus.
> 02:41:40 [    0.000000] CPU maps initialized for 4 threads per core
> 02:41:40  -> smp_release_cpus()
> 02:41:40 spinning_secondaries = 0
> 02:41:40  <- smp_release_cpus()
> 02:41:40 [    0.000000] -----------------------------------------------------
> 02:41:40 [    0.000000] ppc64_pft_size    = 0x1f
> 02:41:40 [    0.000000] phys_mem_size     = 0x1400000000
> 02:41:40 [    0.000000] dcache_bsize      = 0x80
> 02:41:40 [    0.000000] icache_bsize      = 0x80
> 02:41:40 [    0.000000] cpu_features      = 0x0b7e7ae418500049
> 02:41:40 [    0.000000]   possible        = 0x7fffffff18500649
> 02:41:40 [    0.000000]   always          = 0x0000000018100040
> 02:41:40 [    0.000000] cpu_user_features = 0xdc0065c2 0x20000000
> 02:41:40 [    0.000000] mmu_features      = 0x7c004001
> 02:41:40 [    0.000000] firmware_features = 0x00000001845ffc5f
> 02:41:40 [    0.000000] htab_hash_mask    = 0xffffff
> 02:41:40 [    0.000000] -----------------------------------------------------
> 02:41:40 [    0.000000] numa: Initmem setup node 0 [mem 0x00000000-0x9ffffffff]
> 02:41:40 [    0.000000] numa:   NODE_DATA [mem 0x9ffff6300-0x9ffffffff]
> 02:41:40 [    0.000000] numa: Initmem setup node 1 [mem 0xa00000000-0x13ffffffff]
> 02:41:40 [    0.000000] numa:   NODE_DATA [mem 0x13ffe8e300-0x13ffe97fff]
> 02:41:40 [    0.000000] Section 5117 and 5119 (node 1) have a circular dependency on usemap and pgdat allocations
> 02:41:40 [    0.000000] PPC64 nvram contains 15360 bytes
> 02:41:40 [    0.000000] Zone ranges:
> 02:41:40 [    0.000000]   DMA      [mem 0x0000000000000000-0x00000013ffffffff]
> 02:41:40 [    0.000000]   DMA32    empty
> 02:41:40 [    0.000000]   Normal   empty
> 02:41:40 [    0.000000] Movable zone start for each node
> 02:41:40 [    0.000000] Early memory node ranges
> 02:41:40 [    0.000000]   node   0: [mem 0x0000000000000000-0x00000009ffffffff]
> 02:41:40 [    0.000000]   node   1: [mem 0x0000000a00000000-0x00000013ffffffff]
> 02:41:40 [    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x00000009ffffffff]
> 02:41:40 [    0.000000] Initmem setup node 1 [mem 0x0000000a00000000-0x00000013ffffffff]
> 02:41:40 [    0.000000] percpu: Embedded 3 pages/cpu @c0000009ff500000 s155672 r0 d40936 u262144
> 02:41:40 [    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 1309440
> 02:41:40 [    0.000000] Policy zone: DMA
> 02:41:40 [    0.000000] Kernel command line: rw root=UUID=c4012ac5-50cc-4bd6-bf56-cb7210c530d5 
> 02:41:40 [    0.000000] PID hash table entries: 4096 (order: -1, 32768 bytes)
> 02:41:40 [    0.000000] Memory: 83666304K/83886080K available (9920K kernel code, 2240K rwdata, 3492K rodata, 4736K init, 3554K bss, 219776K reserved, 0K cma-reserved)
> 02:41:40 [    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=40, Nodes=2
> 02:41:40 [    0.000000] Hierarchical RCU implementation.
> 02:41:40 [    0.000000] 	Build-time adjustment of leaf fanout to 64.
> 02:41:40 [    0.000000] 	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=40.
> 02:41:40 [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=40
> 02:41:40 [    0.000000] NR_IRQS:512 nr_irqs:512 16
> 02:41:40 [    0.000000] 	Offload RCU callbacks from all CPUs
> 02:41:40 [    0.000000] 	Offload RCU callbacks from CPUs: 0-39.
> 02:41:40 [    0.000003] clocksource: timebase: mask: 0xffffffffffffffff max_cycles: 0x761537d007, max_idle_ns: 440795202126 ns
> 02:41:40 [    0.000060] clocksource: timebase mult[1f40000] shift[24] registered
> 02:41:40 [    0.000227] Console: colour dummy device 80x25
> 02:41:40 [    0.000259] console [hvc0] enabled
> 02:41:40 [    0.000259] console [hvc0] enabled
> 02:41:40 [    0.000282] bootconsole [udbg0] disabled
> 02:41:40 [    0.000282] bootconsole [udbg0] disabled
> 02:41:40 [    0.000511] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
> 02:41:40 [    0.000523] pid_max: default: 40960 minimum: 320
> 02:41:40 [    0.002408] Security Framework initialized
> 02:41:40 [    0.002417] SELinux:  Initializing.
> 02:41:40 [    0.004367] Dentry cache hash table entries: 16777216 (order: 11, 134217728 bytes)
> 02:41:40 [    0.081404] Inode-cache hash table entries: 8388608 (order: 10, 67108864 bytes)
> 02:41:40 [    0.121643] Mount-cache hash table entries: 262144 (order: 5, 2097152 bytes)
> 02:41:40 [    0.121693] Mountpoint-cache hash table entries: 262144 (order: 5, 2097152 bytes)
> 02:41:40 [    0.124985] EEH: pSeries platform initialized
> 02:41:40 [    0.124999] POWER7 performance monitor hardware support registered
> 02:41:40 [    0.126265] smp: Bringing up secondary CPUs ...
> 02:41:40 [    0.138886] random: fast init done
> 02:41:40 [    0.146587] smp: Brought up 2 nodes, 40 CPUs
> 02:41:40 [    0.146597] numa: Node 0 CPUs: 0-23
> 02:41:40 [    0.146600] numa: Node 1 CPUs: 24-39
> 02:41:40 [    0.147833] Enabling Asymmetric SMT scheduling
> 02:41:40 [    0.149674] devtmpfs: initialized
> 02:41:40 [    0.162065] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
> 02:41:40 [    0.162086] futex hash table entries: 16384 (order: 5, 2097152 bytes)
> 02:41:40 [    0.163129] NET: Registered protocol family 16
> 02:41:40 [    0.163198] EEH: No capable adapters found
> 02:41:40 [    0.163231] IBM eBus Device Driver
> 02:41:40 [    0.163461] cpuidle: using governor menu
> 02:41:40 [    0.163587] pstore: using zlib compression
> 02:41:40 [    0.163594] pstore: Registered nvram as persistent store backend
> 02:41:40 [    0.172682] PCI: Probing PCI hardware
> 02:41:40 [    0.174064] HugeTLB registered 16 MB page size, pre-allocated 0 pages
> 02:41:40 [    0.174068] HugeTLB registered 16 GB page size, pre-allocated 0 pages
> 02:41:40 [    0.175619] vgaarb: loaded
> 02:41:40 [    0.175805] SCSI subsystem initialized
> 02:41:40 [    0.175851] usbcore: registered new interface driver usbfs
> 02:41:40 [    0.175863] usbcore: registered new interface driver hub
> 02:41:40 [    0.176103] usbcore: registered new device driver usb
> 02:41:40 [    0.176599] NetLabel: Initializing
> 02:41:40 [    0.176602] NetLabel:  domain hash size = 128
> 02:41:40 [    0.176605] NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
> 02:41:40 [    0.176630] NetLabel:  unlabeled traffic allowed by default
> 02:41:40 [    0.176979] clocksource: Switched to clocksource timebase
> 02:41:40 [    0.197279] VFS: Disk quotas dquot_6.6.0
> 02:41:40 [    0.197453] VFS: Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
> 02:41:40 [    0.200194] NET: Registered protocol family 2
> 02:41:40 [    0.200518] TCP established hash table entries: 524288 (order: 6, 4194304 bytes)
> 02:41:40 [    0.201432] TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
> 02:41:40 [    0.201664] TCP: Hash tables configured (established 524288 bind 65536)
> 02:41:40 [    0.201773] UDP hash table entries: 65536 (order: 5, 2097152 bytes)
> 02:41:40 [    0.202178] UDP-Lite hash table entries: 65536 (order: 5, 2097152 bytes)
> 02:41:40 [    0.202901] NET: Registered protocol family 1
> 02:41:40 [    0.203007] Unpacking initramfs...
> 02:41:40 [    0.468764] Freeing initrd memory: 18496K
> 02:41:40 [    0.471312] IOMMU table initialized, virtual merging enabled
> 02:41:40 [    0.482059] audit: initializing netlink subsys (disabled)
> 02:41:40 [    0.482130] audit: type=2000 audit(1488834706.470:1): state=initialized audit_enabled=0 res=1
> 02:41:40 [    0.482134] Failed to find blacklist at 396005003d290008
> 02:41:40 [    0.482134] Failed to find blacklist at 396004003d290008
> 02:41:40 [    0.482135] Failed to find blacklist at 282a002041e00008
> 02:41:40 [    0.482135] Failed to find blacklist at 396005004800001c
> 02:41:40 [    0.485171] Initialise system trusted keyrings
> 02:41:40 [    0.485553] workingset: timestamp_bits=38 max_order=21 bucket_order=0
> 02:41:40 [    0.486841] zbud: loaded
> 02:41:40 [    0.487432] SGI XFS with ACLs, security attributes, no debug enabled
> 02:41:40 [    0.553535] NET: Registered protocol family 38
> 02:41:40 [    0.553556] Key type asymmetric registered
> 02:41:40 [    0.553560] Asymmetric key parser 'x509' registered
> 02:41:40 [    0.553602] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 251)
> 02:41:40 [    0.553774] io scheduler noop registered
> 02:41:40 [    0.553778] io scheduler deadline registered (default)
> 02:41:40 [    0.553791] io scheduler cfq registered
> 02:41:40 [    0.553794] io scheduler mq-deadline registered
> 02:41:40 [    0.554484] atomic64_test: passed
> 02:41:40 [    0.554959] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> 02:41:40 [    0.555291] Linux agpgart interface v0.103
> 02:41:40 [    0.555545] rdac: device handler registered
> 02:41:40 [    0.555591] hp_sw: device handler registered
> 02:41:40 [    0.555595] emc: device handler registered
> 02:41:40 [    0.555883] alua: device handler registered
> 02:41:40 [    0.555926] libphy: Fixed MDIO Bus: probed
> 02:41:40 [    0.555980] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> 02:41:40 [    0.555992] ehci-pci: EHCI PCI platform driver
> 02:41:40 [    0.556002] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> 02:41:40 [    0.556013] ohci-pci: OHCI PCI platform driver
> 02:41:40 [    0.556023] uhci_hcd: USB Universal Host Controller Interface driver
> 02:41:40 [    0.556069] usbcore: registered new interface driver usbserial
> 02:41:40 [    0.556078] usbcore: registered new interface driver usbserial_generic
> 02:41:40 [    0.556088] usbserial: USB Serial support registered for generic
> 02:41:40 [    0.556165] mousedev: PS/2 mouse device common for all mice
> 02:41:40 [    0.556352] rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
> 02:41:40 [    0.556893] hidraw: raw HID events driver (C) Jiri Kosina
> 02:41:40 [    0.557003] usbcore: registered new interface driver usbhid
> 02:41:40 [    0.557006] usbhid: USB HID core driver
> 02:41:40 [    0.557130] drop_monitor: Initializing network drop monitor service
> 02:41:40 [    0.557249] Initializing XFRM netlink socket
> 02:41:40 [    0.557770] NET: Registered protocol family 10
> 02:41:40 [    0.558338] Segment Routing with IPv6
> 02:41:40 [    0.558358] NET: Registered protocol family 17
> 02:41:40 [    0.558614] registered taskstats version 1
> 02:41:40 [    0.558622] Loading compiled-in X.509 certificates
> 02:41:40 [    0.561121] alg: No test for pkcs1pad(rsa,sha1) (pkcs1pad(rsa-generic,sha1))
> 02:41:40 [    0.561835] Loaded X.509 cert 'Build time autogenerated kernel key: e215906ce829b0ce6a5245eeb1c38578ea3ccc5a'
> 02:41:40 [    0.561886] zswap: loaded using pool lzo/zbud
> 02:41:40 [    0.564512] Key type big_key registered
> 02:41:40 [    0.564658] rtc-generic rtc-generic: setting system clock to 2017-03-06 21:11:46 UTC (1488834706)
> 02:41:40 [    0.565508] Freeing unused kernel memory: 4736K
> 02:41:40 [    0.565514] This architecture does not have kernel memory protection.
> 02:41:40 [    0.572770] systemd[1]: systemd 219 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ -LZ4 -SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
> 02:41:40 [    0.572949] systemd[1]: Detected architecture ppc64.
> 02:41:40 [    0.572954] systemd[1]: Running in initial RAM disk.
> 02:41:40 
> 02:41:40 Welcome to [0;34mRed Hat Enterprise Linux Server 7.2 (Maipo) dracut-033-359.el7 (Initramfs)[0m!
> 02:41:40 
> 02:41:40 [    0.573124] systemd[1]: Set hostname to <p7-korg-ci1.pok.stglabs.ibm.com>.
> 02:41:40 [[32m  OK  [0m] Reached target Swap.
> 02:41:40 [    0.608006] systemd[1]: Reached target Swap.
> 02:41:40 [    0.608020] systemd[1]: Starting Swap.
> 02:41:40 [[32m  OK  [0m] Reached target Local File Systems.
> 02:41:40 [    0.608138] systemd[1]: Reached target Local File Systems.
> 02:41:40 [    0.608148] systemd[1]: Starting Local File Systems.
> 02:41:40 [[32m  OK  [0m] Reached target Timers.
> 02:41:40 [    0.608260] systemd[1]: Reached target Timers.
> 02:41:40 [    0.608269] systemd[1]: Starting Timers.
> 02:41:40 [[32m  OK  [0m] Created slice -.slice.
> 02:41:40 [[32m  OK  [0m] Listening on udev Control Socket.
> 02:41:40 [[32m  OK  [0m] Listening on Journal Socket.
> 02:41:40 [[32m  OK  [0m] Listening on udev Kernel Socket.
> 02:41:40 [[32m  OK  [0m] Reached target Sockets.
> 02:41:40 [[32m  OK  [0m] Created slice System Slice.
> 02:41:40          Starting Create list of required st... nodes for the current kernel...
> 02:41:40          Starting Journal Service...
> 02:41:40          Starting dracut cmdline hook...
> 02:41:40          Starting Setup Virtual Console...
> 02:41:40 [[32m  OK  [0m] Reached target Slices.
> 02:41:40          Starting Apply Kernel Variables...
> 02:41:40 [[32m  OK  [0m] Started Create list of required sta...ce nodes for the current kernel.
> 02:41:40 [[32m  OK  [0m] Started Apply Kernel Variables.
> 02:41:40          Starting Create Static Device Nodes in /dev...
> 02:41:40 [[32m  OK  [0m] Started Journal Service.
> 02:41:40 [[32m  OK  [0m] Started Create Static Device Nodes in /dev.
> 02:41:40 [[32m  OK  [0m] Started Setup Virtual Console.
> 02:41:40 [[32m  OK  [0m] Started dracut cmdline hook.
> 02:41:40          Starting dracut pre-udev hook...
> 02:41:40 [[32m  OK  [0m] Started dracut pre-udev hook.
> 02:41:40          Starting udev Kernel Device Manager...
> 02:41:40 [[32m  OK  [0m] Started udev Kernel Device Manager.
> 02:41:40          Starting udev Coldplug all Devices...
> 02:41:41          Mounting Configuration File System...
> 02:41:41 [[32m  OK  [0m] Mounted Configuration File System.
> 02:41:41 [[32m  OK  [0m] Started udev Coldplug all Devices.
> 02:41:41 [[32m  OK  [0m] Reached target System Initialization.
> 02:41:41          Starting Show Plymouth Boot Screen...
> 02:41:41          Starting dracut initqueue hook...
> 02:41:41 [    0.782031] scsi_transport_srp: module verification failed: signature and/or required key missing - tainting kernel
> 02:41:41 [    0.782748] ibmvscsi 3000000b: SRP_VERSION: 16.a
> 02:41:41 [[32m  OK  [0m] Started Show Plymouth Boot Screen.
> 
> 02:41:41 [[32m  OK  [0m] Reached target Paths.
> 
> 02:41:41 [[32m  OK  [0m] Reached target Basic System.
> 
> 02:41:47 %G[    7.017019] ibmvscsi 3000000b: SRP_VERSION: 16.a
> 02:41:47 [    7.017146] ibmvscsi 3000000b: Maximum ID: 64 Maximum LUN: 32 Maximum Channel: 3
> 02:41:47 [    7.017152] scsi host0: IBM POWER Virtual SCSI Adapter 1.5.9
> 02:41:47 [    7.017331] ibmvscsi 3000000b: partner initialization complete
> 02:41:47 [    7.017382] ibmvscsi 3000000b: host srp version: 16.a, host partition vios1 (2), OS 3, max io 1048576
> 02:41:47 [    7.017442] ibmvscsi 3000000b: Client reserve enabled
> 02:41:47 [    7.017450] ibmvscsi 3000000b: sent SRP login
> 02:41:47 [    7.017491] ibmvscsi 3000000b: SRP_LOGIN succeeded
> 02:41:47 [    7.058998] scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
> 02:41:47 [    7.084681] random: crng init done
> 02:41:47 [    7.123944] sd 0:0:1:0: [sda] 1172123568 512-byte logical blocks: (600 GB/559 GiB)
> 02:41:47 [    7.123999] sd 0:0:1:0: [sda] Write Protect is off
> 02:41:47 [    7.124047] sd 0:0:1:0: [sda] Cache data unavailable
> 02:41:47 [    7.124051] sd 0:0:1:0: [sda] Assuming drive cache: write through
> 02:41:47 [    7.141010]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
> 02:41:47 [    7.141528] sd 0:0:1:0: [sda] Attached SCSI disk
> 02:41:47 [[32m  OK  [0m] Found device VDASD 3.
> 
> 02:41:47          Starting File System Check on /dev/...5-50cc-4bd6-bf56-cb7210c530d5...
> 
> 02:41:47 [[32m  OK  [0m] Started dracut initqueue hook.
> 
> 02:41:47 [[32m  OK  [0m] Reached target Remote File Systems (Pre).
> 
> 02:41:47 [[32m  OK  [0m] Reached target Remote File Systems.
> 
> 02:41:51 [[32m  OK  [0m] Started File System Check on /dev/d...ac5-50cc-4bd6-bf56-cb7210c530d5.
> 
> 02:41:51          Mounting /sysroot...
> 
> 02:41:51 [   11.488591] EXT4-fs (sda): mounted filesystem with ordered data mode. Opts: (null)
> 02:41:51 [[32m  OK  [0m] Mounted /sysroot.
> 
> 02:41:51 [[32m  OK  [0m] Reached target Initrd Root File System.
> 
> 02:41:51          Starting Reload Configuration from the Real Root...
> 
> 02:41:51 [[32m  OK  [0m] Started Reload Configuration from the Real Root.
> 
> 02:41:51 [[32m  OK  [0m] Reached target Initrd File Systems.
> 
> 02:41:51 [[32m  OK  [0m] Reached target Initrd Default Target.
> 
> 02:41:51          Starting dracut pre-pivot and cleanup hook...
> 
> 02:41:51 [[32m  OK  [0m] Started dracut pre-pivot and cleanup hook.
> 
> 02:41:51          Starting Cleaning Up and Shutting Down Daemons...
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Timers.
> 
> 02:41:51          Starting Plymouth switch root service...
> 
> 02:41:51 [[32m  OK  [0m] Stopped Cleaning Up and Shutting Down Daemons.
> 
> 02:41:51 [[32m  OK  [0m] Stopped dracut pre-pivot and cleanup hook.
> 
> 02:41:51          Stopping dracut pre-pivot and cleanup hook...
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Remote File Systems.
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Remote File Systems (Pre).
> 
> 02:41:51 [[32m  OK  [0m] Stopped dracut initqueue hook.
> 
> 02:41:51          Stopping dracut initqueue hook...
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Initrd Default Target.
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Basic System.
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Slices.
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Sockets.
> 
> 02:41:51 [[32m  OK  [0m] Stopped target System Initialization.
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Local File Systems.
> 
> 02:41:51 [[32m  OK  [0m] Stopped Apply Kernel Variables.
> 
> 02:41:51          Stopping Apply Kernel Variables...
> 
> 02:41:51 [[32m  OK  [0m] Stopped udev Coldplug all Devices.
> 
> 02:41:51          Stopping udev Coldplug all Devices...
> 
> 02:41:51          Stopping udev Kernel Device Manager...
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Swap.
> 
> 02:41:51 [[32m  OK  [0m] Stopped target Paths.
> 
> 02:41:51 [[32m  OK  [0m] Started Plymouth switch root service.
> 
> 02:41:52 [[32m  OK  [0m] Stopped udev Kernel Device Manager.
> 
> 02:41:52 [[32m  OK  [0m] Stopped dracut pre-udev hook.
> 
> 02:41:52          Stopping dracut pre-udev hook...
> 
> 02:41:52 [[32m  OK  [0m] Stopped dracut cmdline hook.
> 
> 02:41:52          Stopping dracut cmdline hook...
> 
> 02:41:52 [[32m  OK  [0m] Stopped Create Static Device Nodes in /dev.
> 
> 02:41:52          Stopping Create Static Device Nodes in /dev...
> 
> 02:41:52 [[32m  OK  [0m] Stopped Create list of required sta...ce nodes for the current kernel.
> 
> 02:41:52          Stopping Create list of required st... nodes for the current kernel...
> 
> 02:41:52 [[32m  OK  [0m] Closed udev Control Socket.
> 
> 02:41:52 [[32m  OK  [0m] Closed udev Kernel Socket.
> 
> 02:41:52          Starting Cleanup udevd DB...
> 
> 02:41:52 [[32m  OK  [0m] Started Cleanup udevd DB.
> 
> 02:41:52 [[32m  OK  [0m] Reached target Switch Root.
> 
> 02:41:52          Starting Switch Root...
> 
> 02:41:52 [   11.916042] systemd-journald[442]: Received SIGTERM from PID 1 (systemd).
> 02:41:52 [   12.037828] systemd: 25 output lines suppressed due to ratelimiting
> 02:41:52 [   12.267757] SELinux:  Disabled at runtime.
> 02:41:52 [   12.316999] audit: type=1404 audit(1488834718.250:2): selinux=0 auid=4294967295 ses=4294967295
> 02:41:52 [   12.506615] ip_tables: (C) 2000-2006 Netfilter Core Team
> 02:41:52 [   12.507155] systemd[1]: Inserted module 'ip_tables'
> 02:41:52 
> 
> 02:41:52 Welcome to [0;31mRed Hat Enterprise Linux Server 7.2 (Maipo)[0m!
> 
> 02:41:52 
> 
> 02:41:53 [[32m  OK  [0m] Stopped Switch Root.
> 
> 02:41:53 [[32m  OK  [0m] Listening on udev Kernel Socket.
> 
> 02:41:53          Mounting RPC Pipe File System...
> 
> 02:41:53          Starting Replay Read-Ahead Data...
> 
> 02:41:53 [[32m  OK  [0m] Listening on /dev/initctl Compatibility Named Pipe.
> 
> 02:41:53 [[32m  OK  [0m] Listening on LVM2 poll daemon socket.
> 
> 02:41:53          Mounting NFSD configuration filesystem...
> 
> 02:41:53          Starting Create list of required st... nodes for the current kernel...
> 
> 02:41:53 [[32m  OK  [0m] Listening on Delayed Shutdown Socket.
> 
> 02:41:53 [[32m  OK  [0m] Listening on udev Control Socket.
> 
> 02:41:53 [[32m  OK  [0m] Listening on Device-mapper event daemon FIFOs.
> 
> 02:41:53 [[32m  OK  [0m] Set up automount Arbitrary Executab...ats File System Automount Point.
> 
> 02:41:53 [[32m  OK  [0m] Created slice system-serial\x2dgetty.slice.
> 
> 02:41:53 [[32m  OK  [0m] Stopped target Switch Root.
> 
> 02:41:53 [[32m  OK  [0m] Stopped target Initrd File Systems.
> 
> 02:41:53          Mounting Debug File System...
> 
> 02:41:53 [[32m  OK  [0m] Listening on LVM2 metadata daemon socket.
> 
> 02:41:53          Starting Monitoring of LVM2 mirrors... dmeventd or progress polling...
> 
> 02:41:53          Mounting POSIX Message Queue File System...
> 
> 02:41:53 [[32m  OK  [0m] Reached target Encrypted Volumes.
> 
> 02:41:53          Mounting Huge Pages File System...
> 
> 02:41:53 [[32m  OK  [0m] Stopped target Initrd Root File System.
> 
> 02:41:53 [[32m  OK  [0m] Created slice system-getty.slice.
> 
> 02:41:53 [[32m  OK  [0m] Stopped Flush Journal to Persistent Storage.
> 
> 02:41:53 [[32m  OK  [0m] Stopped Journal Service.
> 
> 02:41:53          Starting Journal Service...
> 
> 02:41:53          Starting Collect Read-Ahead Data...
> 
> 02:41:53 [[32m  OK  [0m] Created slice User and Session Slice.
> 
> 02:41:53 [[32m  OK  [0m] Reached target Slices.
> 
> 02:41:53 [   13.423828] systemd-readahead[982]: Bumped block_nr parameter of 8:0 to 20480. This is a temporary hack and should be removed one day.
> 02:41:53 [[32m  OK  [0m] Started Collect Read-Ahead Data.
> 
> 02:41:53 [[32m  OK  [0m] Started Replay Read-Ahead Data.
> 
> 02:41:53          Starting Remount Root and Kernel File Systems...
> 
> 02:41:53          Starting Set Up Additional Binary Formats...
> 
> 02:41:53          Starting Apply Kernel Variables...
> 
> 02:41:53 [[32m  OK  [0m] Started Create list of required sta...ce nodes for the current kernel.
> 
> 02:41:53          Starting Create Static Device Nodes in /dev...
> 
> 02:41:53          Mounting Arbitrary Executable File Formats File System...
> 
> 02:41:53 [[32m  OK  [0m] Started Journal Service.
> 
> 02:41:54 [[32m  OK  [0m] Mounted Debug File System.
> 
> 02:41:54 [   13.777018] EXT4-fs (sda): re-mounted. Opts: (null)
> 02:41:54 [[32m  OK  [0m] Started Remount Root and Kernel File Systems.
> 
> 02:41:54          Starting udev Coldplug all Devices...
> 
> 02:41:54          Starting Configure read-only root support...
> 
> 02:41:54          Starting Flush Journal to Persistent Storage...
> 
> 02:41:54          Starting Load/Save Random Seed...
> 
> 02:41:54 [[32m  OK  [0m] Mounted Huge Pages File System.
> 
> 02:41:54 [[32m  OK  [0m] Mounted POSIX Message Queue File System.
> 
> 02:41:54 [[32m  OK  [0m] Started Apply Kernel Variables.
> 
> 02:41:54 [[32m  OK  [0m] Started Load/Save Random Seed.
> 
> 02:41:54 [   13.822026] systemd-journald[989]: Received request to flush runtime journal from PID 1
> 02:41:54 [[32m  OK  [0m] Started Flush Journal to Persistent Storage.
> 
> 02:41:54 [[32m  OK  [0m] Started udev Coldplug all Devices.
> 
> 02:41:54 [[32m  OK  [0m] Started LVM2 metadata daemon.
> 
> 02:41:54          Starting LVM2 metadata daemon...
> 
> 02:41:54 [[32m  OK  [0m] Started Create Static Device Nodes in /dev.
> 
> 02:41:54 [[32m  OK  [0m] Reached target Local File Systems (Pre).
> 
> 02:41:54          Starting udev Kernel Device Manager...
> 
> 02:41:54 [[32m  OK  [0m] Mounted Arbitrary Executable File Formats File System.
> 
> 02:41:54 [[32m  OK  [0m] Started Set Up Additional Binary Formats.
> 
> 02:41:54 [[32m  OK  [0m] Started Configure read-only root support.
> 
> 02:41:54 [   13.951758] RPC: Registered named UNIX socket transport module.
> 02:41:54 [   13.951769] RPC: Registered udp transport module.
> 02:41:54 [   13.951773] RPC: Registered tcp transport module.
> 02:41:54 [   13.951776] RPC: Registered tcp NFSv4.1 backchannel transport module.
> 02:41:54 [[32m  OK  [0m] Mounted RPC Pipe File System.
> 
> 02:41:54 [   14.074053] ------------[ cut here ]------------
> 02:41:54 [   14.074067] WARNING: CPU: 5 PID: 1003 at kernel/jump_label.c:287 .static_key_set_entries.isra.10+0x34/0x40
> 02:41:54 [   14.074071] Modules linked in: nfsd(E+) auth_rpcgss(E) nfs_acl(E) lockd(E) grace(E) sunrpc(E) binfmt_misc(E) ip_tables(E) ext4(E) mbcache(E) jbd2(E) sd_mod(E) ibmvscsi(E) ibmveth(E) scsi_transport_srp(E)
> 02:41:54 [   14.074087] CPU: 5 PID: 1003 Comm: modprobe Tainted: G            E   4.11.0-rc1-autotest #1
> 02:41:54 [   14.074091] task: c0000000ff789680 task.stack: c0000000ff820000
> 02:41:54 [   14.074094] NIP: c00000000022fc94 LR: c0000000002300bc CTR: 0000000000000000
> 02:41:54 [   14.074097] REGS: c0000000ff8236d0 TRAP: 0700   Tainted: G            E    (4.11.0-rc1-autotest)
> 02:41:54 [   14.074101] MSR: 800000000282b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>
> 02:41:54 [   14.074107]   CR: 48228282  XER: 00000001
> 02:41:54 [   14.074111] CFAR: c00000000022fc64 SOFTE: 1 
> 02:41:54 [   14.074111] GPR00: c000000000230074 c0000000ff823950 c00000000138a500 d00000000ee5db08 
> 02:41:54 [   14.074111] GPR04: d00000000ee60ca7 0000000100000017 c000000001325c78 0000000000000000 
> 02:41:54 [   14.074111] GPR08: 0000000000058165 0000000000000001 c00000000120a500 7f7f7f7f7f7f7f7f 
> 02:41:54 [   14.074111] GPR12: 0000000028222288 c00000000e9f2d00 d00000000edb2480 d00000000edb2480 
> 02:41:54 [   14.074111] GPR16: c0000000ff823dec c0000000ff823da0 000000000000ff20 000001003ccb0470 
> 02:41:54 [   14.074111] GPR20: 0000000000005418 d00000000ee80000 d00000000ee62538 0000000000000001 
> 02:41:54 [   14.074111] GPR24: c00000000120739a 0000000000000000 c0000000011e7900 d00000000ee60d67 
> 02:41:54 [   14.074111] GPR28: 0000000000000000 d00000000ee60e00 d00000000ee5db00 d00000000ee60ca7 
> 02:41:54 [   14.074151] NIP [c00000000022fc94] .static_key_set_entries.isra.10+0x34/0x40
> 02:41:54 [   14.074155] LR [c0000000002300bc] .jump_label_module_notify+0x1ec/0x400
> 02:41:54 [   14.074157] Call Trace:
> 02:41:54 [   14.074160] [c0000000ff823950] [c000000000230074] .jump_label_module_notify+0x1a4/0x400 (unreliable)
> 02:41:54 [   14.074166] [c0000000ff823a20] [c0000000000ffbcc] .notifier_call_chain+0x7c/0xf0
> 02:41:54 [   14.074170] [c0000000ff823ac0] [c000000000100038] .__blocking_notifier_call_chain+0x58/0x90
> 02:41:54 [   14.074175] [c0000000ff823b60] [c00000000018defc] .load_module+0x124c/0x15d0
> 02:41:54 [   14.074179] [c0000000ff823d20] [c00000000018e4f0] .SyS_finit_module+0xa0/0x100
> 02:41:54 [   14.074184] [c0000000ff823e30] [c00000000000b184] system_call+0x38/0xe0
> 02:41:54 [   14.074187] Instruction dump:
> 02:41:54 [   14.074190] 40c20018 e9230000 792907a0 7c844b78 f8830000 4e800020 3d42ffe8 892ace9a 
> 02:41:54 [   14.074196] 2f890000 40feffe0 39200001 992ace9a <0fe00000> 4bffffd0 60000000 788907a1 
> 02:41:54 [   14.074203] ---[ end trace 78f08bafbc2388f2 ]---
> 02:41:54 [   14.074415] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> 02:41:54 [[32m  OK  [0m] Mounted NFSD configuration filesystem.
> 
> 02:41:54 [[32m  OK  [0m] Started udev Kernel Device Manager.
> 
> 02:41:54 [[32m  OK  [0m] Found device /dev/hvc0.
> 
> 02:41:55 %G[   15.144829] ibmveth 30000002 net0: renamed from eth0
> 02:41:55 [[32m  OK  [0m] Started Monitoring of LVM2 mirrors,...ng dmeventd or progress polling.
> 
> 02:41:55 [   15.190260] sd 0:0:1:0: Attached scsi generic sg0 type 0
> 02:41:56 [[32m  OK  [0m] Found device VDASD 6.
> 
> 02:41:56          Activating swap /dev/disk/by-uuid/f...0-0b84-492f-b0c9-924978a0cffb...
> 
> 02:41:56 [   16.279314] Adding 10485696k swap on /dev/sda6.  Priority:-1 extents:1 across:10485696k FS
> 02:41:56 [[32m  OK  [0m] Activated swap /dev/disk/by-uuid/fcd2d140-0b84-492f-b0c9-924978a0cffb.
> 
> 02:41:56 [[32m  OK  [0m] Found device VDASD 5.
> 
> 02:41:56          Mounting /home...
> 
> 02:41:56 [[32m  OK  [0m] Reached target Swap.
> 
> 02:41:56 [[32m  OK  [0m] Found device VDASD 2.
> 
> 02:41:56          Mounting /boot...
> 
> 02:41:56 [   16.426644] sysfs: cannot create duplicate filename '/fs/xfs/sda'
> 02:41:56 [   16.426667] ------------[ cut here ]------------
> 02:41:56 [   16.426675] WARNING: CPU: 14 PID: 1722 at fs/sysfs/dir.c:31 .sysfs_warn_dup+0x78/0xb0
> 02:41:56 [   16.426679] Modules linked in: sg(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) grace(E) sunrpc(E) binfmt_misc(E) ip_tables(E) ext4(E) mbcache(E) jbd2(E) sd_mod(E) ibmvscsi(E) ibmveth(E) scsi_transport_srp(E)
> 02:41:56 [   16.426703] CPU: 14 PID: 1722 Comm: mount Tainted: G        W   E   4.11.0-rc1-autotest #1
> 02:41:56 [   16.426708] task: c0000009ed3f9c80 task.stack: c0000009ed430000
> 02:41:56 [   16.426711] NIP: c0000000003a6c68 LR: c0000000003a6c64 CTR: 0000000001764c5c
> 02:41:56 [   16.426716] REGS: c0000009ed4333c0 TRAP: 0700   Tainted: G        W   E    (4.11.0-rc1-autotest)
> 02:41:56 [   16.426720] MSR: 800000000282b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>
> 02:41:56 [   16.426726]   CR: 22022822  XER: 00000006
> 02:41:56 [   16.426731] CFAR: c000000000994958 SOFTE: 1 
> 02:41:56 [   16.426731] GPR00: c0000000003a6c64 c0000009ed433640 c00000000138a500 0000000000000035 
> 02:41:56 [   16.426731] GPR04: c0000009ff88ada0 c0000009ff8a1658 00000000014cfc2c 0000000000000000 
> 02:41:56 [   16.426731] GPR08: 0000000000000000 c000000000dd146c 00000009feac0000 0000000000003fef 
> 02:41:56 [   16.426731] GPR12: 0000000022022844 c00000000e9f7e00 0000000037409c40 0000000037409c30 
> 02:41:56 [   16.426731] GPR16: 0000000037409c28 ffffffffffffffff 0000000000000000 000000003741f1c8 
> 02:41:56 [   16.426731] GPR20: 00000100147d1270 0000000000000000 00000000c0ed0000 00003fffa0f53384 
> 02:41:56 [   16.426731] GPR24: c00000000394d178 c000000000c054c0 c000000001742e68 c0000000ff3ea640 
> 02:41:56 [   16.426731] GPR28: c00000000394d640 c0000013eec28c28 c0000009f2ab0148 c000000003833000 
> 02:41:56 [   16.426780] NIP [c0000000003a6c68] .sysfs_warn_dup+0x78/0xb0
> 02:41:56 [   16.426784] LR [c0000000003a6c64] .sysfs_warn_dup+0x74/0xb0
> 02:41:56 [   16.426787] Call Trace:
> 02:41:56 [   16.426790] [c0000009ed433640] [c0000000003a6c64] .sysfs_warn_dup+0x74/0xb0 (unreliable)
> 02:41:56 [   16.426796] [c0000009ed4336d0] [c0000000003a6de4] .sysfs_create_dir_ns+0xc4/0xd0
> 02:41:56 [   16.426801] [c0000009ed433760] [c000000000551048] .kobject_add_internal+0xd8/0x450
> 02:41:56 [   16.426807] [c0000009ed433800] [c00000000055141c] .kobject_init_and_add+0x5c/0x90
> 02:41:56 [   16.426813] [c0000009ed433890] [c00000000044ac54] .xfs_mountfs+0x224/0xa30
> 02:41:56 [   16.426818] [c0000009ed433960] [c000000000452a90] .xfs_fs_fill_super+0x490/0x620
> 02:41:56 [   16.426824] [c0000009ed433a10] [c0000000002fefc0] .mount_bdev+0x220/0x260
> 02:41:56 [   16.426828] [c0000009ed433ac0] [c0000000004509b8] .xfs_fs_mount+0x18/0x30
> 02:41:56 [   16.426833] [c0000009ed433b30] [c000000000300520] .mount_fs+0x70/0x210
> 02:41:56 [   16.426838] [c0000009ed433bf0] [c000000000325930] .vfs_kern_mount+0x60/0x1c0
> 02:41:56 [   16.426843] [c0000009ed433cb0] [c00000000032a458] .do_mount+0x268/0xee0
> 02:41:56 [   16.426848] [c0000009ed433d90] [c00000000032b4ec] .SyS_mount+0x8c/0x100
> 02:41:56 [   16.426854] [c0000009ed433e30] [c00000000000b184] system_call+0x38/0xe0
> 02:41:56 [   16.426858] Instruction dump:
> 02:41:56 [   16.426861] 7fa3eb78 38800000 7fe5fb78 38c01000 4bffa929 60000000 3c62ff8b 7fe4fb78 
> 02:41:56 [   16.426869] 38636ec8 7fc5f378 485edcb9 60000000 <0fe00000> 7fe3fb78 4bf1fb01 60000000 
> 02:41:56 [   16.426877] ---[ end trace 78f08bafbc2388f3 ]---
> 02:41:56 [   16.426881] kobject_add_internal failed for sda with -EEXIST, don't try to register things with the same name in the same directory.
> 02:41:56 [   16.426891] ------------[ cut here ]------------
> 02:41:56 [   16.426896] WARNING: CPU: 14 PID: 1722 at lib/kobject.c:240 .kobject_add_internal+0x270/0x450
> 02:41:56 [   16.426900] Modules linked in: sg(E) nfsd(E) auth_rpcgss(E) nfs_acl(E) lockd(E) grace(E) sunrpc(E) binfmt_misc(E) ip_tables(E) ext4(E) mbcache(E) jbd2(E) sd_mod(E) ibmvscsi(E) ibmveth(E) scsi_transport_srp(E)
> 02:41:56 [   16.426917] CPU: 14 PID: 1722 Comm: mount Tainted: G        W   E   4.11.0-rc1-autotest #1
> 02:41:56 [   16.426921] task: c0000009ed3f9c80 task.stack: c0000009ed430000
> 02:41:56 [   16.426925] NIP: c0000000005511e0 LR: c0000000005511dc CTR: 0000000001764c5c
> 02:41:56 [   16.426929] REGS: c0000009ed4334e0 TRAP: 0700   Tainted: G        W   E    (4.11.0-rc1-autotest)
> 02:41:56 [   16.426933] MSR: 800000000282b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>
> 02:41:56 [   16.426939]   CR: 42022822  XER: 00000009
> 02:41:56 [   16.426944] CFAR: c000000000994958 SOFTE: 1 
> 02:41:56 [   16.426944] GPR00: c0000000005511dc c0000009ed433760 c00000000138a500 0000000000000078 
> 02:41:56 [   16.426944] GPR04: 0000000000000000 8000000014af2cb8 00000000014cfd04 0000000000000000 
> 02:41:56 [   16.426944] GPR08: 0000000000000001 0000000000000007 0000000000000006 0000000000003fef 
> 02:41:56 [   16.426944] GPR12: 0000000028022824 c00000000e9f7e00 0000000037409c40 0000000037409c30 
> 02:41:56 [   16.426944] GPR16: 0000000037409c28 ffffffffffffffff 0000000000000000 000000003741f1c8 
> 02:41:56 [   16.426944] GPR20: 00000100147d1270 0000000000000000 00000000c0ed0000 00003fffa0f53384 
> 02:41:56 [   16.426944] GPR24: c00000000394d178 c000000000c054c0 c000000001742e68 c0000000ff3ea640 
> 02:41:56 [   16.426944] GPR28: c00000000394d640 c0000009f3a92e98 ffffffffffffffef c00000000394d638 
> 02:41:56 [   16.426992] NIP [c0000000005511e0] .kobject_add_internal+0x270/0x450
> 02:41:56 [   16.426996] LR [c0000000005511dc] .kobject_add_internal+0x26c/0x450
> 02:41:56 [   16.426999] Call Trace:
> 02:41:56 [   16.427002] [c0000009ed433760] [c0000000005511dc] .kobject_add_internal+0x26c/0x450 (unreliable)
> 02:41:56 [   16.427009] [c0000009ed433800] [c00000000055141c] .kobject_init_and_add+0x5c/0x90
> 02:41:56 [   16.427014] [c0000009ed433890] [c00000000044ac54] .xfs_mountfs+0x224/0xa30
> 02:41:56 [   16.427019] [c0000009ed433960] [c000000000452a90] .xfs_fs_fill_super+0x490/0x620
> 02:41:56 [   16.427024] [c0000009ed433a10] [c0000000002fefc0] .mount_bdev+0x220/0x260
> 02:41:56 [   16.427028] [c0000009ed433ac0] [c0000000004509b8] .xfs_fs_mount+0x18/0x30
> 02:41:56 [   16.427033] [c0000009ed433b30] [c000000000300520] .mount_fs+0x70/0x210
> 02:41:56 [   16.427038] [c0000009ed433bf0] [c000000000325930] .vfs_kern_mount+0x60/0x1c0
> 02:41:56 [   16.427043] [c0000009ed433cb0] [c00000000032a458] .do_mount+0x268/0xee0
> 02:41:56 [   16.427048] [c0000009ed433d90] [c00000000032b4ec] .SyS_mount+0x8c/0x100
> 02:41:56 [   16.427053] [c0000009ed433e30] [c00000000000b184] system_call+0x38/0xe0
> 02:41:56 [   16.427056] Instruction dump:
> 02:41:56 [   16.427059] 4bfff211 2f9effef 39200000 f93f0018 409efeb8 e8bf0000 3c62ff8d 3c82ff68 
> 02:41:56 [   16.427067] 386351d0 38845948 48443741 60000000 <0fe00000> 4bfffec4 60000000 60000000 
> 02:41:56 [   16.427075] ---[ end trace 78f08bafbc2388f4 ]---
> 02:41:56 [[1;31mFAILED[0m] Failed to mount /home.
> 
> 02:41:56 See 'systemctl status home.mount' for details.
> 
> 02:41:56 [[1;33mDEPEND[0m] Dependency failed for Local File Systems.
> 
> 02:41:56 [[1;33mDEPEND[0m] Dependency failed for Relabel all filesystems, if necessary.
> 
> 02:41:56 [[1;33mDEPEND[0m] Dependency failed for Mark the need to relabel after reboot.
> 
> 02:41:56          Starting Preprocess NFS configuration...
> 
> 02:41:56 [[32m  OK  [0m] Closed RPCbind Server Activation Socket.
> 
> 02:41:56 [[32m  OK  [0m] Closed Open-iSCSI iscsiuio Socket.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Dump dmesg to /var/log/dmesg.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Serial Getty on hvc0.
> 
> 02:41:56 [[32m  OK  [0m] Closed Open-iSCSI iscsid Socket.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Getty on tty1.
> 
> 02:41:56 [[32m  OK  [0m] Stopped target Multi-User System.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Postfix Mail Transport Agent.
> 
> 02:41:56 [[32m  OK  [0m] Stopped IBM Performance Management for PowerLinux Systems.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Login Service.
> 
> 02:41:56 [[32m  OK  [0m] Stopped RMC-Resource Monitioring and Control.
> 
> 02:41:56 [[32m  OK  [0m] Stopped SRC-Subsystem Resource Controller.
> 
> 02:41:56 [[32m  OK  [0m] Stopped IBM Power Raid update daemon.
> 
> 02:41:56 [[32m  OK  [0m] Stopped OpenSSH server daemon.
> 
> 02:41:56 [[32m  OK  [0m] Stopped OpenSSH Server Key Generation.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Terminate Plymouth Boot Screen.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Enable periodic update of entitlement certificates..
> 
> 02:41:56 [[32m  OK  [0m] Stopped Virtualization daemon.
> 
> 02:41:56 [[32m  OK  [0m] Stopped irqbalance daemon.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Wait for Plymouth Boot Screen to Quit.
> 
> 02:41:56 [[32m  OK  [0m] Stopped LSB: Bring up/down networking.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Network Manager Wait Online.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Network Manager.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Rollback uncommitted netcf network config change transactions.
> 
> 02:41:56 [[32m  OK  [0m] Stopped IBM Power Raid init daemon.
> 
> 02:41:56 [[32m  OK  [0m] Stopped IBM Power Raid dump daemon.
> 
> 02:41:56 [[32m  OK  [0m] Stopped D-Bus System Message Bus.
> 
> 02:41:56 [[32m  OK  [0m] Reached target Login Prompts.
> 
> 02:41:56 [   16.435977] XFS (sda): Mounting V4 Filesystem
> 02:41:56 [[32m  OK  [0m] Stopped opal_errd (PowerNV platform error handling) Service.
> 
> 02:41:56 [[32m  OK  [0m] Stopped LSB: Starts the Spacewalk Daemon.
> 
> 02:41:56 [[32m  OK  [0m] Stopped GSSAPI Proxy Daemon.
> 
> 02:41:56 [[32m  OK  [0m] Stopped System Logging Service.
> 
> 02:41:56 [[32m  OK  [0m] Closed D-Bus System Message Bus Socket.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Job spooling tools.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Command Scheduler.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Permit User Sessions.
> 
> 02:41:56 [[32m  OK  [0m] Reached target Timers.
> 
> 02:41:56 [[32m  OK  [0m] Stopped Dynamic System Tuning Daemon.
> 
> 02:41:56 [[32m  OK  [0m] Reached target Network.
> 
> 02:41:56          Starting Logout off all iSCSI sessions on shutdown...
> 
> 02:41:56 [[32m  OK  [0m] Reached target Network is Online.
> 
> 02:41:56 [[32m  OK  [0m] Stopped ppc64-diag rtas_errd (platform error handling) Service.
> 
> 02:41:56 [[32m  OK  [0m] Stopped target Basic System.
> 
> 02:41:56 [[32m  OK  [0m] Reached target Paths.
> 
> 02:41:56 [[32m  OK  [0m] Reached target Sockets.
> 
> 02:41:56 [[32m  OK  [0m] Stopped target System Initialization.
> 
> 02:41:56          Starting Tell Plymouth To Write Out Runtime Data...
> 
> 02:41:56          Starting Import network configuration from initramfs...
> 
> 02:41:56 [[32m  OK  [0m] Started Preprocess NFS configuration.
> 
> 02:41:56 [[32m  OK  [0m] Started Logout off all iSCSI sessions on shutdown.
> 
> 02:41:56 [[32m  OK  [0m] Started Import network configuration from initramfs.
> 
> 02:41:57          Starting Create Volatile Files and Directories...
> 
> 02:41:57 [[32m  OK  [0m] Started Emergency Shell.
> 
> 02:41:57          Starting Emergency Shell...
> 
> 02:41:57 [[32m  OK  [0m] Reached target Emergency Mode.
> 
> 02:41:57          Starting Notify NFS peers of a restart...
> 
> 02:41:57 [[32m  OK  [0m] Reached target NFS client services.
> 
> 02:41:57 [[32m  OK  [0m] Reached target Remote File Systems (Pre).
> 
> 02:41:57 [[32m  OK  [0m] Reached target Remote File Systems.
> 
> 02:41:57          Starting Crash recovery kernel arming...
> 
> 02:41:57 [[32m  OK  [0m] Started Tell Plymouth To Write Out Runtime Data.
> 
> 02:41:57 [[32m  OK  [0m] Started Notify NFS peers of a restart.
> 
> 02:41:57 [[32m  OK  [0m] Started Create Volatile Files and Directories.
> 
> 02:41:57          Starting Security Auditing Service...
> 
> 02:41:57 [[32m  OK  [0m] Started Security Auditing Service.
> 
> 02:41:57          Starting Update UTMP about System Boot/Shutdown...
> 
> 02:41:57 [[32m  OK  [0m] Started Update UTMP about System Boot/Shutdown.
> 
> 02:41:57          Starting Update UTMP about System Runlevel Changes...
> 
> 02:41:57 [[32m  OK  [0m] Started Update UTMP about System Runlevel Changes.
> 
> 02:41:57 [[1;31mFAILED[0m] Failed to start Crash recovery kernel arming.
> 
> 02:41:57 See 'systemctl status kdump.service' for details.
> 
> 02:41:58 [   17.966543] XFS (sda): Starting recovery (logdev: internal)
> 02:41:58 [   18.461612] XFS (sda): Ending recovery (logdev: internal)
> 02:41:58 [[32m  OK  [0m] Mounted /boot.
> 
> 02:41:58 Welcome to emergency mode! After logging in, type "journalctl -xb" to view
> 02:41:58 system logs, "systemctl reboot" to reboot, "systemctl default" or ^D to
> 02:41:58 try again to boot into default mode.
> 02:41:58 Give root password for maintenance
> 07:17:04 (or type Control-D to continue):

