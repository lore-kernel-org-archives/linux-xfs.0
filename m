Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC77A7F37
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 09:20:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45DF5AC001
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 07:20:18 -0800 (PST)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[81.169.146.160]) by cuda.sgi.com with ESMTP id
	UB4RlHJIdTZLZvVV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Dec 2015 07:20:03 -0800 (PST)
Received: from [192.168.1.115] (204.249.193.82.static.ediscom.de
	[82.193.249.204]) by smtp.strato.de (RZmta 37.14 AUTH)
	with ESMTPSA id j063e3rB8FK1R9i
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with
	521 ECDH bits, eq. 15360 bits RSA))
	(Client did not present a certificate) for <xfs@oss.sgi.com>;
	Tue, 8 Dec 2015 16:20:01 +0100 (CET)
From: Dietmar Putz <putz@3qmedien.net>
Subject: Metadata corruption detected at xfs_attr3_leaf_write_verify /
	Internal error xfs_attr3_leaf_write_verify
Message-ID: <5666F521.5060602@3qmedien.net>
Date: Tue, 8 Dec 2015 16:20:01 +0100
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5485618804850123213=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============5485618804850123213==
Content-Type: multipart/alternative;
 boundary="------------070807060201020309090804"

This is a multi-part message in MIME format.
--------------070807060201020309090804
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello all,

recently we had some updates in a gluster environment as described in :
https://www.gluster.org/pipermail/gluster-users/2015-December/024509.html

since then we are faced to the below show errors.
otherwise as stated in the report on gluster.org not always the same 
nodes of the cluster are affected but those who are currently being used 
by a gluster-client. all clients running ubuntu 12.04.5 or 14.04.3 with 
3.13.0-67 or ~71 and using the same glusterfs-client version as 
installed on the glusterfs server (gfs 3.6.7).
we made several tests with different kernel version like 3.13.0-24, 
3.13.0-67 and 3.13.0-71. in any case we received error messages as shown 
below for gluster-ger-ber-12-int.
After upgrade to kernel 3.19.0-39 the error message turns from "Internal 
error xfs_attr3_leaf_write_verify...." to "Metadata corruption detected 
at xfs_attr3_leaf_write_verify..." as shown below for 
gluster-ger-ber-11-int.
in any case the behavior is the same...the file system becomes 
inaccessible and returns an Input/output error. xfs_check does not show 
any information and xfs_repair does not show any error. it is sufficient 
to remount the file system and it is accessible again.

similar reports are existing :
http://oss.sgi.com/archives/xfs/2015-11/msg00459.html
https://bugs.launchpad.net/ubuntu/+source/linux-lts-trusty/+bug/1468039

we decided to downgrade the kernel on the glusterfs-server nodes to

3.8.4-030804-generic #201303201832 SMP Wed Mar 20 22:33:00 UTC 2013 
x86_64 x86_64 x86_64 GNU/Linux

since then the error disappeared.
for both below shown errors a trace output is available (trace-cmd 
record -e xfs\*).


best regards
dietmar




gluster-ger-ber-11-int : (kernel 3.19.0-39)

[56909.996801] XFS (sdc1): xfs_log_force: error -5 returned.
[56910.019110] XFS (sdc1): xfs_log_force: error -5 returned.
[56934.013585] XFS (sdc1): Mounting V4 Filesystem
[56934.149640] XFS (sdc1): Starting recovery (logdev: internal)
[56934.577267] XFS (sdc1): Ending recovery (logdev: internal)
[58674.887753] XFS (sdc1): Mounting V4 Filesystem
[58675.000355] XFS (sdc1): Ending clean mount
[58724.547431] init: statd main process (1490) killed by KILL signal
[58724.547440] init: statd main process ended, respawning
[65828.900368] bash (23057): drop_caches: 3
[67475.972089] nr_pdflush_threads exported in /proc is scheduled for removal
[73715.250762] XFS (sdc1): Metadata corruption detected at 
xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs], block 0x44482d730
[73715.250803] XFS (sdc1): Unmount and run xfs_repair
[73715.250816] XFS (sdc1): First 64 bytes of corrupted metadata buffer:
[73715.250832] ffff8807f7b07000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 
00 00 00  ................
[73715.250856] ffff8807f7b07010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 
00 00 00  ..... ..........
[73715.250876] ffff8807f7b07020: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00  ................
[73715.250907] ffff8807f7b07030: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00  ................
[73715.250941] XFS (sdc1): xfs_do_force_shutdown(0x8) called from line 
1249 of file 
/build/linux-lts-vivid-1jarlV/linux-lts-vivid-3.19.0/fs/xfs/xfs_buf.c. 
Return address = 0xffffffffc02bbd22
[73715.251375] XFS (sdc1): Corruption of in-memory data detected.  
Shutting down filesystem
[73715.251398] XFS (sdc1): Please umount the filesystem and rectify the 
problem(s)
[73715.302287] XFS (sdc1): xfs_log_force: error -5 returned.
[73730.431543] XFS (sdc1): xfs_log_force: error -5 returned.



gluster-ger-ber-12-int : (kernel 3.13.0-67)

[159046.531752] XFS (sdc1): Mounting Filesystem
[159046.675156] XFS (sdc1): Starting recovery (logdev: internal)
[159047.240939] XFS (sdc1): Ending recovery (logdev: internal)
[159064.372532] XFS (sdc1): Mounting Filesystem
[159064.496445] XFS (sdc1): Ending clean mount
[160598.216262] XFS (sdc1): Mounting Filesystem
[160598.403044] XFS (sdc1): Ending clean mount
[160673.912887] init: statd main process (21051) killed by KILL signal
[160673.912897] init: statd main process ended, respawning
[160674.035234] init: statd main process (8122) terminated with status 1
[160674.035240] init: statd main process ended, respawning
[175683.930045] ffff8807a8f59000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 
00 00 00  ................
[175683.932979] ffff8807a8f59010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 
00 00 00  ..... ..........
[175683.935812] ffff8807a8f59020: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00  ................
[175683.938644] ffff8807a8f59030: 00 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00  ................
[175683.940870] XFS (sdc1): Internal error xfs_attr3_leaf_write_verify 
at line 216 of file 
/build/linux-XHaR1x/linux-3.13.0/fs/xfs/xfs_attr_leaf.c.  Caller 
0xffffffffa01936f0
[175683.943857] CPU: 2 PID: 7874 Comm: xfsaild/sdc1 Not tainted 
3.13.0-67-generic #110-Ubuntu
[175683.943859] Hardware name: Supermicro X10SLL-F/X10SLL-F, BIOS 1.1b 
11/01/2013
[175683.943861]  0000000000000001 ffff8807ef1ffbd0 ffffffff817240e0 
ffff880036846000
[175683.943866]  ffff8807ef1ffbe8 ffffffffa01976fb ffffffffa01936f0 
ffff8807ef1ffc20
[175683.943870]  ffffffffa0197755 000000d80020fc00 ffff88075c2b4900 
ffff88025fbea488
[175683.943873] Call Trace:
[175683.943883]  [<ffffffff817240e0>] dump_stack+0x45/0x56
[175683.943917]  [<ffffffffa01976fb>] xfs_error_report+0x3b/0x40 [xfs]
[175683.943933]  [<ffffffffa01936f0>] ? _xfs_buf_ioapply+0x70/0x3a0 [xfs]
[175683.943948]  [<ffffffffa0197755>] xfs_corruption_error+0x55/0x80 [xfs]
[175683.943968]  [<ffffffffa01b4b70>] 
xfs_attr3_leaf_write_verify+0x100/0x120 [xfs]
[175683.943983]  [<ffffffffa01936f0>] ? _xfs_buf_ioapply+0x70/0x3a0 [xfs]
[175683.943998]  [<ffffffffa01953d5>] ? xfs_bdstrat_cb+0x55/0xb0 [xfs]
[175683.944012]  [<ffffffffa01936f0>] _xfs_buf_ioapply+0x70/0x3a0 [xfs]
[175683.944017]  [<ffffffff81122a1d>] ? 
trace_buffer_unlock_commit+0x4d/0x60
[175683.944030]  [<ffffffffa01854d2>] ? 
ftrace_raw_event_xfs_buf_class+0xf2/0x100 [xfs]
[175683.944045]  [<ffffffffa0195322>] ? xfs_buf_iorequest+0x32/0x90 [xfs]
[175683.944059]  [<ffffffffa01953d5>] ? xfs_bdstrat_cb+0x55/0xb0 [xfs]
[175683.944073]  [<ffffffffa0195336>] xfs_buf_iorequest+0x46/0x90 [xfs]
[175683.944087]  [<ffffffffa01953d5>] xfs_bdstrat_cb+0x55/0xb0 [xfs]
[175683.944102]  [<ffffffffa019556b>] 
__xfs_buf_delwri_submit+0x13b/0x210 [xfs]
[175683.944117]  [<ffffffffa0196000>] ? 
xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
[175683.944132]  [<ffffffffa0196000>] 
xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
[175683.944157]  [<ffffffffa01f4d27>] xfsaild+0x237/0x5c0 [xfs]
[175683.944181]  [<ffffffffa01f4af0>] ? 
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[175683.944186]  [<ffffffff8108b7d2>] kthread+0xd2/0xf0
[175683.944189]  [<ffffffff8108b700>] ? kthread_create_on_node+0x1c0/0x1c0
[175683.944193]  [<ffffffff81734c28>] ret_from_fork+0x58/0x90
[175683.944196]  [<ffffffff8108b700>] ? kthread_create_on_node+0x1c0/0x1c0
[175683.944199] XFS (sdc1): Corruption detected. Unmount and run xfs_repair
[175683.945754] XFS (sdc1): xfs_do_force_shutdown(0x8) called from line 
1320 of file /build/linux-XHaR1x/linux-3.13.0/fs/xfs/xfs_buf.c.  Return 
address = 0xffffffffa019371c
[175683.946133] XFS (sdc1): Corruption of in-memory data detected.  
Shutting down filesystem
[175683.947204] XFS (sdc1): Please umount the filesystem and rectify the 
problem(s)
[175713.963171] XFS (sdc1): xfs_log_force: error 5 returned.
[175744.014122] XFS (sdc1): xfs_log_force: error 5 returned.



Kernel-Version :
[ 09:07:53 ] - root@gluster-ger-ber-12  /home/admin $uname -a
Linux gluster-ger-ber-12 3.13.0-67-generic #110-Ubuntu SMP Fri Oct 23 
13:24:41 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux



xfsprogs Version :
[ 09:20:36 ] - root@gluster-ger-ber-12  /home/admin $xfs_repair -V
xfs_repair version 3.1.9


Number and type of CPU :
1 CPU
model name    : Intel(R) Xeon(R) CPU E3-1230 v3 @ 3.30GHz


[ 09:21:49 ] - root@gluster-ger-ber-12  /home/admin $more /proc/meminfo
MemTotal:       32907248 kB
MemFree:          258068 kB
Buffers:           99024 kB
Cached:         31446816 kB
SwapCached:         3836 kB
Active:         15800552 kB
Inactive:       15975832 kB
Active(anon):      44396 kB
Inactive(anon):   186212 kB
Active(file):   15756156 kB
Inactive(file): 15789620 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:      33510396 kB
SwapFree:       33449196 kB
Dirty:                 4 kB
Writeback:             0 kB
AnonPages:        227736 kB
Mapped:             9772 kB
Shmem:                64 kB
Slab:             451404 kB
SReclaimable:     400636 kB
SUnreclaim:        50768 kB
KernelStack:        1560 kB
PageTables:         4128 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    49964020 kB
Committed_AS:     598956 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      161180 kB
VmallocChunk:   34359537664 kB
HardwareCorrupted:     0 kB
AnonHugePages:    126976 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       85232 kB
DirectMap2M:     3018752 kB
DirectMap1G:    30408704 kB


[ 09:21:54 ] - root@gluster-ger-ber-12  /home/admin $more /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=16442840k,nr_inodes=4110710,mode=755 
0 0
devpts /dev/pts devpts 
rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=3290728k,mode=755 0 0
/dev/disk/by-uuid/b1db3d58-26c3-4ed1-a53d-34cb11978ba5 / ext4 
rw,relatime,errors=remount-ro,data=ordered 0 0
none /sys/fs/cgroup tmpfs rw,relatime,size=4k,mode=755 0 0
none /sys/fs/fuse/connections fusectl rw,relatime 0 0
none /sys/kernel/debug debugfs rw,relatime 0 0
none /sys/kernel/security securityfs rw,relatime 0 0
none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
none /run/user tmpfs 
rw,nosuid,nodev,noexec,relatime,size=102400k,mode=755 0 0
none /sys/fs/pstore pstore rw,relatime 0 0
/dev/sdb1 /data ext4 rw,relatime,data=ordered 0 0
rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
systemd /sys/fs/cgroup/systemd cgroup 
rw,nosuid,nodev,noexec,relatime,name=systemd 0 0
gluster-ger-ber-12-int:/ger-ber-01 /sdn fuse.glusterfs 
rw,relatime,user_id=0,group_id=0,default_permissions,allow_other,max_read=131072 
0 0
/dev/sdc1 /gluster-export xfs rw,relatime,attr2,inode64,noquota 0 0
[ 09:22:20 ] - root@gluster-ger-ber-12  /home/admin $


[ 09:22:20 ] - root@gluster-ger-ber-12  /home/admin $more /proc/partitions
major minor  #blocks  name

    8        0  209715200 sda
    8        1  176201728 sda1
    8        2          1 sda2
    8        5   33510400 sda5
    8       16 3696754688 sdb
    8       17 3696753647 sdb1
    8       32 19532349440 sdc
    8       33 19532348399 sdc1
[ 09:22:39 ] - root@gluster-ger-ber-12  /home/admin $


[ 09:23:22 ] - root@gluster-ger-ber-12  /home/admin $lspci -v | more
...
05:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS 2208 
[Thunderbolt] (rev 05)
     Subsystem: LSI Logic / Symbios Logic MegaRAID SAS 9271-8i
     Flags: bus master, fast devsel, latency 0, IRQ 16
     I/O ports at b000 [size=256]
     Memory at f7160000 (64-bit, non-prefetchable) [size=16K]
     Memory at f7100000 (64-bit, non-prefetchable) [size=256K]
     Expansion ROM at f7140000 [disabled] [size=128K]
     Capabilities: [50] Power Management version 3
     Capabilities: [68] Express Endpoint, MSI 00
     Capabilities: [d0] Vital Product Data
     Capabilities: [a8] MSI: Enable- Count=1/1 Maskable- 64bit+
     Capabilities: [c0] MSI-X: Enable+ Count=16 Masked-
     Capabilities: [100] Advanced Error Reporting
     Capabilities: [1e0] #19
     Capabilities: [1c0] Power Budgeting <?>
     Capabilities: [190] #16
     Capabilities: [148] Alternative Routing-ID Interpretation (ARI)
     Kernel driver in use: megaraid_sas
     Kernel modules: megaraid_sas



Affected Virtual Drive : 2
[ 09:24:14 ] - root@gluster-ger-ber-12  /home/admin $megacli -LDInfo 
-Lall -aALL


Adapter 0 -- Virtual Drive Information:
Virtual Drive: 0 (Target Id: 0)
Name                :
RAID Level          : Primary-1, Secondary-0, RAID Level Qualifier-0
Size                : 200.0 GB
Sector Size         : 512
Is VD emulated      : Yes
Mirror Data         : 200.0 GB
State               : Optimal
Strip Size          : 256 KB
Number Of Drives    : 2
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if 
Bad BBU
Current Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if 
Bad BBU
Default Access Policy: Read/Write
Current Access Policy: Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
PI type: No PI

Is VD Cached: No


Virtual Drive: 1 (Target Id: 1)
Name                :
RAID Level          : Primary-1, Secondary-0, RAID Level Qualifier-0
Size                : 3.442 TB
Sector Size         : 512
Is VD emulated      : Yes
Mirror Data         : 3.442 TB
State               : Optimal
Strip Size          : 256 KB
Number Of Drives    : 2
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if 
Bad BBU
Current Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if 
Bad BBU
Default Access Policy: Read/Write
Current Access Policy: Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
PI type: No PI

Is VD Cached: No


Virtual Drive: 2 (Target Id: 2)
Name                :
RAID Level          : Primary-5, Secondary-0, RAID Level Qualifier-3
Size                : 18.190 TB
Sector Size         : 512
Is VD emulated      : Yes
Parity Size         : 3.637 TB
State               : Optimal
Strip Size          : 256 KB
Number Of Drives    : 6
Span Depth          : 1
Default Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if 
Bad BBU
Current Cache Policy: WriteBack, ReadAhead, Direct, No Write Cache if 
Bad BBU
Default Access Policy: Read/Write
Current Access Policy: Read/Write
Disk Cache Policy   : Disk's Default
Encryption Type     : None
PI type: No PI

Is VD Cached: No



Exit Code: 0x00
[ 09:24:17 ] - root@gluster-ger-ber-12  /home/admin $




All disks are of same type : HGST Ultrastar 7K4000 512e 4TB
[ 09:25:27 ] - root@gluster-ger-ber-12  /home/admin $megacli -PDList 
-aALL | more
...
Enclosure Device ID: 252
Slot Number: 2
Drive's position: DiskGroup: 1, Span: 0, Arm: 0
Enclosure position: N/A
Device Id: 9
WWN: 5000cca23dd7cc1d
Sequence Number: 2
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Last Predictive Failure Event Seq Number: 0
PD Type: SATA

Raw Size: 3.638 TB [0x1d1c0beb0 Sectors]
Non Coerced Size: 3.637 TB [0x1d1b0beb0 Sectors]
Coerced Size: 3.637 TB [0x1d1b00000 Sectors]
Sector Size:  512
Logical Sector Size:  512
Physical Sector Size:  4096
Firmware state: Online, Spun Up
Commissioned Spare : Yes
Emergency Spare : No
Device Firmware Level: A580
Shield Counter: 0
Successful diagnostics completion on :  N/A
SAS Address(0): 0x4433221101000000
Connected Port Number: 1(path0)
Inquiry Data:       PK1334PBHPAW2PHGST 
HUS724040ALE640                    MJAOA580
FDE Capable: Not Capable
FDE Enable: Disable
Secured: Unsecured
Locked: Unlocked
Needs EKM Attention: No
Foreign State: None
Device Speed: 6.0Gb/s
Link Speed: 6.0Gb/s
Media Type: Hard Disk Device
Drive:  Not Certified
Drive Temperature :43C (109.40 F)
PI Eligibility:  No
Drive is formatted for PI information:  No
PI: No PI
Drive's NCQ setting : N/A
Port-0 :
Port status: Active
Port's Linkspeed: 6.0Gb/s
Drive has flagged a S.M.A.R.T alert : No

[ 09:26:17 ] - root@gluster-ger-ber-12  /home/admin $megacli -PDList 
-aALL | grep "Inquiry Data"
Inquiry Data:       PK1334PBHPAD0PHGST 
HUS724040ALE640                    MJAOA580
Inquiry Data:       PK1334PBHP5X2PHGST 
HUS724040ALE640                    MJAOA580
Inquiry Data:       PK1334PBHPAW2PHGST 
HUS724040ALE640                    MJAOA580
Inquiry Data:       PK1334PBHP5HJPHGST 
HUS724040ALE640                    MJAOA580
Inquiry Data:       PK1334PBHP59ZPHGST 
HUS724040ALE640                    MJAOA580
Inquiry Data:       PK1334PBHP831PHGST 
HUS724040ALE640                    MJAOA580
Inquiry Data:       PK1334PBHP5Z4PHGST 
HUS724040ALE640                    MJAOA580
Inquiry Data:       PK1338P4GNXEEBHGST 
HUS724040ALE640                    MJAOA580
[ 09:26:29 ] - root@gluster-ger-ber-12  /home/admin $


[ 09:36:05 ] - root@gluster-ger-ber-12  /home/admin $fuser -c 
/gluster-export
Cannot stat /gluster-export: Input/output error
[ 09:36:16 ] - root@gluster-ger-ber-12  /home/admin $umount /gluster-export
[ 09:36:25 ] - root@gluster-ger-ber-12  /home/admin $mount /gluster-export/
[ 09:36:29 ] - root@gluster-ger-ber-12  /home/admin $xfs_info 
/gluster-export/
meta-data=/dev/sdc1              isize=256 agcount=32, agsize=152596472 
blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096 blocks=4883087099, imaxpct=5
          =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096 ascii-ci=0
log      =internal               bsize=4096 blocks=521728, version=2
          =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
[ 09:36:36 ] - root@gluster-ger-ber-12  /home/admin $



[ 09:28:20 ] - root@gluster-ger-ber-12  /home/admin $echo w > 
/proc/sysrq-trigger

dmesg :
[Fri Dec  4 09:28:34 2015] SysRq : Show Blocked State
[Fri Dec  4 09:28:34 2015]   task PC stack   pid father
[Fri Dec  4 09:28:34 2015] Sched Debug Version: v0.11, 3.13.0-67-generic 
#110-Ubuntu
[Fri Dec  4 09:28:34 2015] ktime : 136344498.523371
[Fri Dec  4 09:28:34 2015] sched_clk : 136212618.303317
[Fri Dec  4 09:28:34 2015] cpu_clk : 136212618.303397
[Fri Dec  4 09:28:34 2015] jiffies : 4328978420
[Fri Dec  4 09:28:34 2015] sched_clock_stable : 1

[Fri Dec  4 09:28:34 2015] sysctl_sched
[Fri Dec  4 09:28:34 2015] .sysctl_sched_latency                    : 
24.000000
[Fri Dec  4 09:28:34 2015] .sysctl_sched_min_granularity            : 
3.000000
[Fri Dec  4 09:28:34 2015] .sysctl_sched_wakeup_granularity         : 
4.000000
[Fri Dec  4 09:28:34 2015] .sysctl_sched_child_runs_first           : 0
[Fri Dec  4 09:28:34 2015] .sysctl_sched_features                   : 77435
[Fri Dec  4 09:28:34 2015] .sysctl_sched_tunable_scaling            : 1 
(logaritmic)

[Fri Dec  4 09:28:34 2015] cpu#0, 3300.307 MHz
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .nr_switches                   : 147348638
[Fri Dec  4 09:28:34 2015] .nr_load_updates               : 11437772
[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            : -28382
[Fri Dec  4 09:28:34 2015] .next_balance                  : 4328.978407
[Fri Dec  4 09:28:34 2015] .curr->pid                     : 0
[Fri Dec  4 09:28:34 2015] .clock                         : 
136212614.957368
[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   : 0
[Fri Dec  4 09:28:34 2015] .yld_count                     : 3
[Fri Dec  4 09:28:34 2015] .sched_count                   : 236776897
[Fri Dec  4 09:28:34 2015] .sched_goidle                  : 66160497
[Fri Dec  4 09:28:34 2015] .avg_idle                      : 1000000
[Fri Dec  4 09:28:34 2015] .ttwu_count                    : 72435010
[Fri Dec  4 09:28:34 2015] .ttwu_local                    : 11357966

[Fri Dec  4 09:28:34 2015] cfs_rq[0]:/autogroup-1402
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 270.992157
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 269.013532
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-26475674.528669
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 0
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 0
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 15
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .se->exec_start                : 
136212614.939755
[Fri Dec  4 09:28:34 2015] .se->vruntime                  : 26475931.652185
[Fri Dec  4 09:28:34 2015] .se->sum_exec_runtime          : 270.992157
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_start     : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.exec_max       : 1.112867
[Fri Dec  4 09:28:34 2015] .se->statistics.slice_max      : 0.021923
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_max       : 0.071390
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_sum       : 2.037234
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_count     : 8501
[Fri Dec  4 09:28:34 2015] .se->load.weight               : 2
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_sum      : 105
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_period   : 47280
[Fri Dec  4 09:28:34 2015] .se->avg.load_avg_contrib      : 0
[Fri Dec  4 09:28:34 2015] .se->avg.decay_count           : 129902473

[Fri Dec  4 09:28:34 2015] cfs_rq[0]:/
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 3846527.725695
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 26475943.542201
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 0.000000
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 98
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 3
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 12
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_sum         : 143
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_period      : 47611

[Fri Dec  4 09:28:34 2015] rt_rq[0]:
[Fri Dec  4 09:28:34 2015] .rt_nr_running                 : 0
[Fri Dec  4 09:28:34 2015] .rt_throttled                  : 0
[Fri Dec  4 09:28:34 2015] .rt_time                       : 0.014935
[Fri Dec  4 09:28:34 2015] .rt_runtime                    : 950.000000

[Fri Dec  4 09:28:34 2015] runnable tasks:
[Fri Dec  4 09:28:34 2015]             task   PID tree-key switches  
prio     exec-runtime         sum-exec sum-sleep
[Fri Dec  4 09:28:34 2015] 
----------------------------------------------------------------------------------------------------------
[Fri Dec  4 09:28:34 2015]         kthreadd     2 26474982.577430       
631   120  26474982.577430 29.113277 136195518.581352 0 /
[Fri Dec  4 09:28:34 2015]      ksoftirqd/0     3 26474983.604407    
192950   120  26474983.604407 3698.783802 136191450.813456 0 /
[Fri Dec  4 09:28:34 2015]     kworker/0:0H     5 3300.494478         
6   100      3300.494478         0.071207 6008.439787 0 /
[Fri Dec  4 09:28:34 2015]        rcu_sched     7 26475932.336758  
14122966   120  26475932.336758 283940.908724 135759709.558946 0 /
[Fri Dec  4 09:28:34 2015]           rcu_bh    16 70.281892         2   
120        70.281892 0.000707 0.000587 0 /
[Fri Dec  4 09:28:34 2015]          rcuob/0    17 72.282352         2   
120        72.282352 0.000801 0.000662 0 /
[Fri Dec  4 09:28:34 2015]          rcuob/1    18 74.282814         2   
120        74.282814 0.000776 0.000634 0 /
[Fri Dec  4 09:28:34 2015]          rcuob/2    19 76.283269         2   
120        76.283269 0.000848 0.000602 0 /
[Fri Dec  4 09:28:34 2015]          rcuob/3    20 78.283650         2   
120        78.283650 0.000775 0.000598 0 /
[Fri Dec  4 09:28:34 2015]          rcuob/4    21 80.284102         2   
120        80.284102 0.000854 0.000663 0 /
[Fri Dec  4 09:28:34 2015]          rcuob/5    22 82.284536         2   
120        82.284536 0.000809 0.000580 0 /
[Fri Dec  4 09:28:34 2015]          rcuob/6    23 84.285021         2   
120        84.285021 0.000888 0.000637 0 /
[Fri Dec  4 09:28:34 2015]          rcuob/7    24 86.285485         2   
120        86.285485 0.000872 0.000639 0 /
[Fri Dec  4 09:28:34 2015]      migration/0    25 0.000000     27167     
0         0.000000       797.682052 0.000750 0 /
[Fri Dec  4 09:28:34 2015]       watchdog/0    26 -5.953704     
34090     0        -5.953704       751.540781 13.772317 0 /
[Fri Dec  4 09:28:34 2015]            khubd    71 3244.446742       
104   120      3244.446742        61.411241 2754.046153 0 /
[Fri Dec  4 09:28:34 2015]          kswapd0    77 26205841.066711     
30811   120  26205841.066711 76229.909278 134072768.865772 0 /
[Fri Dec  4 09:28:34 2015]       khugepaged    79 26475677.591690     
13973   139  26475677.591690 2084.204182 136203770.797993 0 /
[Fri Dec  4 09:28:34 2015]     kworker/0:1H   379 23223356.272823     
57528   100  23223356.272823 1125.377178 107458262.671565 0 /
[Fri Dec  4 09:28:34 2015]    systemd-udevd   441 111.205459      1936   
120       111.205459       347.271266 136018099.023055 0 /autogroup-90
[Fri Dec  4 09:28:34 2015]           kipmi0   511 26475943.542201    
464248   139  26475943.542201 822445.570486 135379234.199855 0 /
[Fri Dec  4 09:28:34 2015]      in:imuxsock   557 309.267197      5651   
120       309.267197       333.499493 136004317.631646 0 /autogroup-112
[Fri Dec  4 09:28:34 2015]            acpid  1095 0.855489         5   
120         0.855489         0.524418 17.527620 0 /autogroup-224
[Fri Dec  4 09:28:34 2015]      kworker/0:0 16096 26475931.584455    
957170   120  26475931.584455 20895.761903 53442927.054945 0 /
[Fri Dec  4 09:28:34 2015]    kworker/u17:1 25496 26122951.277120     
10489   100  26122951.277120 186.192347 46014951.975247 0 /
[Fri Dec  4 09:28:34 2015]         glusterd 10248 20892.577731     
43829   120     20892.577731      2767.803349 43744498.428498 0 
/autogroup-1375
[Fri Dec  4 09:28:34 2015]         glusterd 10249 13989.146111        
10   120     13989.146111         0.277888 34507872.284027 0 
/autogroup-1375
[Fri Dec  4 09:28:34 2015]        glusterfs 10350 6719.390861     
43778   120      6719.390861     10489.910435 43733358.086887 0 
/autogroup-1382
[Fri Dec  4 09:28:34 2015]      kworker/0:1 17609 
22321475.749296         2   120  22321475.749296 0.050026 0.043033 0 /
[Fri Dec  4 09:28:34 2015]             sshd 13731 269.013532     11291   
120       269.013532       301.287578 2062023.641370 0 /autogroup-1402
[Fri Dec  4 09:28:34 2015]             bash 13732 0.623405        63   
120         0.623405        61.403465 5212.815794 0 /autogroup-1403

[Fri Dec  4 09:28:34 2015] cpu#1, 3300.307 MHz
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .nr_switches                   : 140802404
[Fri Dec  4 09:28:34 2015] .nr_load_updates               : 11046184
[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            : -37147
[Fri Dec  4 09:28:34 2015] .next_balance                  : 4328.978404
[Fri Dec  4 09:28:34 2015] .curr->pid                     : 0
[Fri Dec  4 09:28:34 2015] .clock                         : 
136212543.982417
[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   : 0
[Fri Dec  4 09:28:34 2015] .yld_count                     : 0
[Fri Dec  4 09:28:34 2015] .sched_count                   : 223822273
[Fri Dec  4 09:28:34 2015] .sched_goidle                  : 63146083
[Fri Dec  4 09:28:34 2015] .avg_idle                      : 1000000
[Fri Dec  4 09:28:34 2015] .ttwu_count                    : 76646395
[Fri Dec  4 09:28:34 2015] .ttwu_local                    : 10364838

[Fri Dec  4 09:28:34 2015] cfs_rq[1]:/autogroup-161
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 41.418053
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 40.369477
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-26475903.172724
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 0
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 0
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .se->exec_start                : 
136212390.652070
[Fri Dec  4 09:28:34 2015] .se->vruntime                  : 25423116.862434
[Fri Dec  4 09:28:34 2015] .se->sum_exec_runtime          : 41.418053
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_start     : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.exec_max       : 0.396702
[Fri Dec  4 09:28:34 2015] .se->statistics.slice_max      : 0.073704
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_max       : 0.182166
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_sum       : 1.361087
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_count     : 850
[Fri Dec  4 09:28:34 2015] .se->load.weight               : 2
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_sum      : 2
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_period   : 47625
[Fri Dec  4 09:28:34 2015] .se->avg.load_avg_contrib      : 0
[Fri Dec  4 09:28:34 2015] .se->avg.decay_count           : 129902259

[Fri Dec  4 09:28:34 2015] cfs_rq[1]:/
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 3806336.668940
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 25423128.794116
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : -1052814.748085
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 92
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 1
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 12
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_sum         : 62
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_period      : 46935

[Fri Dec  4 09:28:34 2015] rt_rq[1]:
[Fri Dec  4 09:28:34 2015] .rt_nr_running                 : 0
[Fri Dec  4 09:28:34 2015] .rt_throttled                  : 0
[Fri Dec  4 09:28:34 2015] .rt_time                       : 0.027093
[Fri Dec  4 09:28:34 2015] .rt_runtime                    : 950.000000

[Fri Dec  4 09:28:34 2015] runnable tasks:
[Fri Dec  4 09:28:34 2015]             task   PID tree-key switches  
prio     exec-runtime         sum-exec sum-sleep
[Fri Dec  4 09:28:34 2015] 
----------------------------------------------------------------------------------------------------------
[Fri Dec  4 09:28:34 2015]          rcuos/0     8 25423118.245296   
2404401   120  25423118.245296 101131.182197 136110439.328825 0 /
[Fri Dec  4 09:28:34 2015]          rcuos/2    10 25423116.874811   
2422938   120  25423116.874811 101151.958178 136110314.686513 0 /
[Fri Dec  4 09:28:34 2015]       watchdog/1    27 -2.951694     
34090     0        -2.951694 757.129747 0.000729 0 /
[Fri Dec  4 09:28:34 2015]      migration/1    28 0.000000     24068     
0         0.000000       469.233325 0.000679 0 /
[Fri Dec  4 09:28:34 2015]      ksoftirqd/1    29 25421716.842085    
181729   120  25421716.842085 3477.138497 136182012.889144 0 /
[Fri Dec  4 09:28:34 2015]     kworker/1:0H    31 4613.719467         
7   100      4613.719467         0.037461 10189.369938 0 /
[Fri Dec  4 09:28:34 2015]       khungtaskd    76 25421933.541670      
1138   120  25421933.541670 84.284528 136187978.841882 0 /
[Fri Dec  4 09:28:34 2015]        scsi_eh_5   186 3365.916452        
14   120      3365.916452 1.760553 397.345031 0 /
[Fri Dec  4 09:28:34 2015]      jbd2/sda1-8   209 25422648.851152    
100906   120  25422648.851152 6159.882209 136198241.371272 0 /
[Fri Dec  4 09:28:34 2015]          xfslogd   372 3448.379981         
2   100      3448.379981 0.004590 0.002710 0 /
[Fri Dec  4 09:28:34 2015]  upstart-file-br   436 12.500126      3968   
120        12.500126        94.531374 136015292.474727 0 /autogroup-86
[Fri Dec  4 09:28:34 2015]   systemd-logind   669 44.037315       300   
120        44.037315       248.585829 134260598.704251 0 /autogroup-149
[Fri Dec  4 09:28:34 2015]          rpcbind   722 40.369477      4768   
120        40.369477       234.292584 136204838.488381 0 /autogroup-161
[Fri Dec  4 09:28:34 2015]            getty  1044 0.070244        65   
120         0.070244         1.286122 38.280862 0 /autogroup-195
[Fri Dec  4 09:28:34 2015]             cron  1104 52.826625      2331   
120        52.826625       151.901350 136158801.398533 0 /autogroup-220
[Fri Dec  4 09:28:34 2015]     kworker/1:1H  2618 22530547.872807     
65641   100  22530547.872807 1320.284728 107453816.441771 0 /
[Fri Dec  4 09:28:34 2015]        rpc.statd 27870 0.450345        10   
120         0.450345         2.718404 1.565635 0 /autogroup-997
[Fri Dec  4 09:28:34 2015]         glusterd 10250 17662.746416       
749   120     17662.746416       178.191852 43741936.432719 0 
/autogroup-1375
[Fri Dec  4 09:28:34 2015]        glusterfs 10345 2653.426150        
95   120      2653.426150         2.679007 43685955.773205 0 
/autogroup-1380
[Fri Dec  4 09:28:34 2015]      kworker/1:0 11396 25423117.034513    
515020   120  25423117.034513 12511.346039 42714718.828356 0 /
[Fri Dec  4 09:28:34 2015]      kworker/1:1 23002 
22479768.454215         2   120  22479768.454215 0.055400 0.015166 0 /
[Fri Dec  4 09:28:34 2015]    kworker/u16:1 10511 25422395.165519     
12740   120  25422395.165519 833.068573 5769174.355062 0 /

[Fri Dec  4 09:28:34 2015] cpu#2, 3300.307 MHz
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .nr_switches                   : 140954660
[Fri Dec  4 09:28:34 2015] .nr_load_updates               : 10911251
[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            : -32246
[Fri Dec  4 09:28:34 2015] .next_balance                  : 4328.978418
[Fri Dec  4 09:28:34 2015] .curr->pid                     : 0
[Fri Dec  4 09:28:34 2015] .clock                         : 
136212595.926891
[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   : 0
[Fri Dec  4 09:28:34 2015] .yld_count                     : 0
[Fri Dec  4 09:28:34 2015] .sched_count                   : 224643151
[Fri Dec  4 09:28:34 2015] .sched_goidle                  : 63182858
[Fri Dec  4 09:28:34 2015] .avg_idle                      : 1000000
[Fri Dec  4 09:28:34 2015] .ttwu_count                    : 75899548
[Fri Dec  4 09:28:34 2015] .ttwu_local                    : 10349699

[Fri Dec  4 09:28:34 2015] cfs_rq[2]:/
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 3804562.837849
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 25555626.301013
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : -920317.241188
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 97
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 1
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 12
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_sum         : 54
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_period      : 46771

[Fri Dec  4 09:28:34 2015] rt_rq[2]:
[Fri Dec  4 09:28:34 2015] .rt_nr_running                 : 0
[Fri Dec  4 09:28:34 2015] .rt_throttled                  : 0
[Fri Dec  4 09:28:34 2015] .rt_time                       : 0.021579
[Fri Dec  4 09:28:34 2015] .rt_runtime                    : 950.000000

[Fri Dec  4 09:28:34 2015] runnable tasks:
[Fri Dec  4 09:28:34 2015]             task   PID tree-key switches  
prio     exec-runtime         sum-exec sum-sleep
[Fri Dec  4 09:28:34 2015] 
----------------------------------------------------------------------------------------------------------
[Fri Dec  4 09:28:34 2015]             init     1 425.097653     14333   
120       425.097653      3392.591086 136201613.341830 0 /autogroup-2
[Fri Dec  4 09:28:34 2015]          rcuos/4    12 25555614.399222   
2395326   120  25555614.399222 111227.287682 136100481.939047 0 /
[Fri Dec  4 09:28:34 2015]       watchdog/2    32 -5.980436     
34089     0        -5.980436 701.341717 0.001035 0 /
[Fri Dec  4 09:28:34 2015]      migration/2    33 0.000000     24044     
0         0.000000       454.356563 0.000708 0 /
[Fri Dec  4 09:28:34 2015]      ksoftirqd/2    34 25552774.096697    
168290   120  25552774.096697 3062.808230 136155517.391477 0 /
[Fri Dec  4 09:28:34 2015]     kworker/2:0H    36 2206.597279         
7   100      2206.597279         0.043895 10213.196941 0 /
[Fri Dec  4 09:28:34 2015]        scsi_eh_1   182 1345.845801        
14   120      1345.845801 2.310343 416.263941 0 /
[Fri Dec  4 09:28:34 2015]        scsi_eh_2   183 1347.737725         
7   120      1347.737725 4.297015 455.843697 0 /
[Fri Dec  4 09:28:34 2015]        scsi_eh_6   187 1344.576241        
14   120      1344.576241 1.167670 400.858524 0 /
[Fri Dec  4 09:28:34 2015]         xfsalloc   370 1491.536262         
2   100      1491.536262 0.005613 0.002823 0 /
[Fri Dec  4 09:28:34 2015]    xfs_mru_cache   371 1503.541080         
2   100      1503.541080 0.005434 0.020169 0 /
[Fri Dec  4 09:28:34 2015]      dbus-daemon   562 35.997923      5207   
120        35.997923       321.379628 136014456.290568 0 /autogroup-114
[Fri Dec  4 09:28:34 2015]            getty  1048 0.798035        66   
120         0.798035         1.038112 22.919171 0 /autogroup-199
[Fri Dec  4 09:28:34 2015]        rpc.statd  2610 0.113453         7   
120         0.113453         2.541659 1.078356 0 /autogroup-287
[Fri Dec  4 09:28:34 2015]     kworker/2:1H  2627 22621782.659664     
62070   100  22621782.659664 1335.191062 107314569.211629 0 /
[Fri Dec  4 09:28:34 2015]         glusterd 10251 15677.807241       
772   120     15677.807241       163.402191 43741947.895943 0 
/autogroup-1375
[Fri Dec  4 09:28:34 2015]        glusterfs 10341 3025.652327     
28750   120      3025.652327      4494.806148 43740371.067623 0 
/autogroup-1380
[Fri Dec  4 09:28:34 2015]        glusterfs 10353 7848.836436        
77   120      7848.836436         3.043855 43432185.230605 0 
/autogroup-1382
[Fri Dec  4 09:28:34 2015]      kworker/2:1 10915 25555614.472845    
539514   120  25555614.472845 12494.506682 43240143.702078 0 /
[Fri Dec  4 09:28:34 2015]      kworker/2:0 20081 
22180323.415652         3   120  22180323.415652 0.062509 7.314314 0 /
[Fri Dec  4 09:28:34 2015]             sudo 13768 15.649688        15   
120        15.649688        23.750716 2492.693892 0 /autogroup-1403

[Fri Dec  4 09:28:34 2015] cpu#3, 3300.307 MHz
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .nr_switches                   : 141335883
[Fri Dec  4 09:28:34 2015] .nr_load_updates               : 10970238
[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            : -17617
[Fri Dec  4 09:28:34 2015] .next_balance                  : 4328.978392
[Fri Dec  4 09:28:34 2015] .curr->pid                     : 0
[Fri Dec  4 09:28:34 2015] .clock                         : 
136212595.942930
[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   : 0
[Fri Dec  4 09:28:34 2015] .yld_count                     : 3
[Fri Dec  4 09:28:34 2015] .sched_count                   : 228167931
[Fri Dec  4 09:28:34 2015] .sched_goidle                  : 63329458
[Fri Dec  4 09:28:34 2015] .avg_idle                      : 1000000
[Fri Dec  4 09:28:34 2015] .ttwu_count                    : 75973716
[Fri Dec  4 09:28:34 2015] .ttwu_local                    : 10639601

[Fri Dec  4 09:28:34 2015] cfs_rq[3]:/autogroup-1375
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 18586.219722
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 18069.862107
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-26457873.680094
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 0
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 0
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .se->exec_start                : 
136212425.591062
[Fri Dec  4 09:28:34 2015] .se->vruntime                  : 26094251.418506
[Fri Dec  4 09:28:34 2015] .se->sum_exec_runtime          : 18586.383623
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_start     : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.exec_max       : 3.983940
[Fri Dec  4 09:28:34 2015] .se->statistics.slice_max      : 3.673064
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_max       : 0.114982
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_sum       : 21.381169
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_count     : 89939
[Fri Dec  4 09:28:34 2015] .se->load.weight               : 2
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_sum      : 11
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_period   : 47166
[Fri Dec  4 09:28:34 2015] .se->avg.load_avg_contrib      : 0
[Fri Dec  4 09:28:34 2015] .se->avg.decay_count           : 129902292

[Fri Dec  4 09:28:34 2015] cfs_rq[3]:/
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 3820771.181635
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 26094262.988915
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : -381680.553286
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 71
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 2
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 12
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_sum         : 95
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_period      : 47669

[Fri Dec  4 09:28:34 2015] rt_rq[3]:
[Fri Dec  4 09:28:34 2015] .rt_nr_running                 : 0
[Fri Dec  4 09:28:34 2015] .rt_throttled                  : 0
[Fri Dec  4 09:28:34 2015] .rt_time                       : 0.022099
[Fri Dec  4 09:28:34 2015] .rt_runtime                    : 950.000000

[Fri Dec  4 09:28:34 2015] runnable tasks:
[Fri Dec  4 09:28:34 2015]             task   PID tree-key switches  
prio     exec-runtime         sum-exec sum-sleep
[Fri Dec  4 09:28:34 2015] 
----------------------------------------------------------------------------------------------------------
[Fri Dec  4 09:28:34 2015]          rcuos/1     9 26094251.119927   
2397714   120  26094251.119927 100698.380729 136110789.493453 0 /
[Fri Dec  4 09:28:34 2015]          rcuos/3    11 26094251.350073   
2404544   120  26094251.350073 100861.304213 136110827.001807 0 /
[Fri Dec  4 09:28:34 2015]          rcuos/6    14 26094026.859325   
2330692   120  26094026.859325 108121.695870 136100747.700861 0 /
[Fri Dec  4 09:28:34 2015]       watchdog/3    37 -5.979836     
34090     0        -5.979836 701.406503 0.000996 0 /
[Fri Dec  4 09:28:34 2015]      migration/3    38 0.000000     25006     
0         0.000000       614.308545 0.000704 0 /
[Fri Dec  4 09:28:34 2015]      ksoftirqd/3    39 26094030.002911    
217683   120  26094030.002911 4097.101172 136204388.184594 0 /
[Fri Dec  4 09:28:34 2015]     kworker/3:0H    41 4923.752898         
7   100      4923.752898         0.038445 10357.144096 0 /
[Fri Dec  4 09:28:34 2015]    fsnotify_mark    80 17395580.736262        
37   120  17395580.736262 0.282814 92409161.796469 0 /
[Fri Dec  4 09:28:34 2015]  upstart-udev-br   397 30.716080      6127   
120        30.716080       230.662890 136015275.419172 0 /autogroup-61
[Fri Dec  4 09:28:34 2015]    rs:main Q:Reg   559 321.032885      8007   
120       321.032885       923.248259 136186466.324339 0 /autogroup-112
[Fri Dec  4 09:28:34 2015]             nrpe  1112 11371.926125     
12125   120     11371.926125      2129.552313 136190562.066576 0 
/autogroup-221
[Fri Dec  4 09:28:34 2015]            gdbus  2081 0.744015         8   
120         0.744015         0.330701 0.277507 0 /autogroup-266
[Fri Dec  4 09:28:34 2015]     kworker/3:1H  2651 23006607.509737     
80448   100  23006607.509737 1510.460473 107363258.764220 0 /
[Fri Dec  4 09:28:34 2015]        rpc.statd 13685 0.096523        10   
120         0.096523         3.059160 47.016680 0 /autogroup-1290
[Fri Dec  4 09:28:34 2015]     xfsaild/sdc1 10017 26094253.544465    
828662   120  26094253.544465 34547.387217 43827248.923976 0 /
[Fri Dec  4 09:28:34 2015]         glusterd 10247 18069.862107    
677281   120     18069.862107    142247.429572 43604482.413832 0 
/autogroup-1375
[Fri Dec  4 09:28:34 2015]        glusterfs 10342 3936.822141     
43845   120      3936.822141     10474.508007 43734386.395618 0 
/autogroup-1380
[Fri Dec  4 09:28:34 2015]        rpc.statd 10411 0.147194         8   
120         0.147194         1.668909 41.767193 0 /autogroup-1386
[Fri Dec  4 09:28:34 2015]      kworker/3:2 20448 
25855231.751517         4   120  25855231.751517 0.089043 
30095580.227654 0 /
[Fri Dec  4 09:28:34 2015]    kworker/u16:2 13596 26094251.167465      
1422   120  26094251.167465 92.576014 2148231.314437 0 /
[Fri Dec  4 09:28:34 2015]      kworker/3:0 13638 26094251.086440     
24951   120  26094251.086440 579.316363 2063718.158999 0 /

[Fri Dec  4 09:28:34 2015] cpu#4, 3300.307 MHz
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .nr_switches                   : 105568159
[Fri Dec  4 09:28:34 2015] .nr_load_updates               : 6630800
[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            : 51868
[Fri Dec  4 09:28:34 2015] .next_balance                  : 4328.978327
[Fri Dec  4 09:28:34 2015] .curr->pid                     : 0
[Fri Dec  4 09:28:34 2015] .clock                         : 
136212240.234656
[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   : 0
[Fri Dec  4 09:28:34 2015] .yld_count                     : 0
[Fri Dec  4 09:28:34 2015] .sched_count                   : 106391214
[Fri Dec  4 09:28:34 2015] .sched_goidle                  : 45071812
[Fri Dec  4 09:28:34 2015] .avg_idle                      : 1000000
[Fri Dec  4 09:28:34 2015] .ttwu_count                    : 54601820
[Fri Dec  4 09:28:34 2015] .ttwu_local                    : 7541787

[Fri Dec  4 09:28:34 2015] cfs_rq[4]:/autogroup-1382
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 1228.651419
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 1235.325126
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-26474708.217075
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 0
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 1
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 1
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 4
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 1
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 4
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .se->exec_start                : 
136212197.612794
[Fri Dec  4 09:28:34 2015] .se->vruntime                  : 11078932.597413
[Fri Dec  4 09:28:34 2015] .se->sum_exec_runtime          : 1228.847115
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_start     : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.exec_max       : 0.335102
[Fri Dec  4 09:28:34 2015] .se->statistics.slice_max      : 0.158210
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_max       : 0.107315
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_sum       : 0.959447
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_count     : 25830
[Fri Dec  4 09:28:34 2015] .se->load.weight               : 2
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_sum      : 191
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_period   : 47148
[Fri Dec  4 09:28:34 2015] .se->avg.load_avg_contrib      : 1
[Fri Dec  4 09:28:34 2015] .se->avg.decay_count           : 129902075

[Fri Dec  4 09:28:34 2015] cfs_rq[4]:/
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 2996672.618810
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 11078943.311719
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-15397000.230482
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 63
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 4
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 12
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_sum         : 226
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_period      : 47270

[Fri Dec  4 09:28:34 2015] rt_rq[4]:
[Fri Dec  4 09:28:34 2015] .rt_nr_running                 : 0
[Fri Dec  4 09:28:34 2015] .rt_throttled                  : 0
[Fri Dec  4 09:28:34 2015] .rt_time                       : 0.022828
[Fri Dec  4 09:28:34 2015] .rt_runtime                    : 950.000000

[Fri Dec  4 09:28:34 2015] runnable tasks:
[Fri Dec  4 09:28:34 2015]             task   PID tree-key switches  
prio     exec-runtime         sum-exec sum-sleep
[Fri Dec  4 09:28:34 2015] 
----------------------------------------------------------------------------------------------------------
[Fri Dec  4 09:28:34 2015]       watchdog/4    42 -8.976676     
34089     0        -8.976676 703.393709 0.001054 0 /
[Fri Dec  4 09:28:34 2015]      migration/4    43 0.000000    522672     
0         0.000000      5586.023859 0.000878 0 /
[Fri Dec  4 09:28:34 2015]      ksoftirqd/4    44 11078931.375157    
123872   120  11078931.375157 2699.457434 136206908.221620 0 /
[Fri Dec  4 09:28:34 2015]     kworker/4:0H    46 5183.354019         
7   100      5183.354019         0.024152 11346.424817 0 /
[Fri Dec  4 09:28:34 2015]               md    72 22.959158         2   
100        22.959158 0.003847 0.001519 0 /
[Fri Dec  4 09:28:34 2015]       devfreq_wq    73 34.962134         2   
100        34.962134 0.003250 0.001585 0 /
[Fri Dec  4 09:28:34 2015]             ksmd    78 95.024195         2   
125        95.024195 0.009110 0.003632 0 /
[Fri Dec  4 09:28:34 2015]  ecryptfs-kthrea    81 131.098695         2   
120       131.098695 0.009268 0.003717 0 /
[Fri Dec  4 09:28:34 2015]           crypto    82 143.106878         2   
100       143.106878 0.008849 0.003485 0 /
[Fri Dec  4 09:28:34 2015]         kthrotld    94 287.247167         2   
100       287.247167 0.008570 0.003546 0 /
[Fri Dec  4 09:28:34 2015]          deferwq   121 1852.932827         
4   100      1852.932827 0.103774 345.509759 0 /
[Fri Dec  4 09:28:34 2015]        scsi_eh_3   184 2330.673890        
14   120      2330.673890 1.123806 406.763399 0 /
[Fri Dec  4 09:28:34 2015]  upstart-socket-   685 1.976600      2449   
120         1.976600        66.649380 136014443.116090 0 /autogroup-158
[Fri Dec  4 09:28:34 2015]         whoopsie  1655 2.701519       102   
120         2.701519        11.748913 129474990.452082 0 /autogroup-266
[Fri Dec  4 09:28:34 2015]            getty  2435 0.212606         2   
120         0.212606         1.152749 0.000000 0 /autogroup-272
[Fri Dec  4 09:28:34 2015]     kworker/4:1H  2724 11034545.666401    
514255   100  11034545.666401 17271.001339 107436722.892382 0 /
[Fri Dec  4 09:28:34 2015]          kauditd  2997 37493.612764         
2   120     37493.612764 0.033370 0.003881 0 /
[Fri Dec  4 09:28:34 2015]      kworker/4:2  1093 11078932.083317    
281743   120  11078932.083317 8749.842765 50514657.114231 0 /
[Fri Dec  4 09:28:34 2015]        glusterfs 10413 23.728867         4   
120        23.728867 0.291486 0.175916 0 /autogroup-1380
[Fri Dec  4 09:28:34 2015]        glusterfs 10349 1235.325126    
296202   120      1235.325126     11713.948549 43732121.550028 0 
/autogroup-1382
[Fri Dec  4 09:28:34 2015]        glusterfs 10351 10.962439         1   
120        10.962439 0.011024 0.000000 0 /autogroup-1382
[Fri Dec  4 09:28:34 2015]        glusterfs 10352 1200.277837       
107   120      1200.277837         2.656723 43432185.809267 0 
/autogroup-1382
[Fri Dec  4 09:28:34 2015]        rpc.statd 10406 0.263949        11   
120         0.263949         2.779534 83.848029 0 /autogroup-1384
[Fri Dec  4 09:28:34 2015]      kworker/4:0 10440 9518517.060530        
30   120   9518517.060530 0.171060 229429.421687 0 /
[Fri Dec  4 09:28:34 2015]    kworker/u17:2 11300 11078931.312338     
21530   100  11078931.312338 483.672855 42835471.064931 0 /

[Fri Dec  4 09:28:34 2015] cpu#5, 3300.307 MHz
[Fri Dec  4 09:28:34 2015] .nr_running                    : 2
[Fri Dec  4 09:28:34 2015] .load                          : 2048
[Fri Dec  4 09:28:34 2015] .nr_switches                   : 100712644
[Fri Dec  4 09:28:34 2015] .nr_load_updates               : 6659188
[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            : 15496
[Fri Dec  4 09:28:34 2015] .next_balance                  : 4328.978415
[Fri Dec  4 09:28:34 2015] .curr->pid                     : 13770
[Fri Dec  4 09:28:34 2015] .clock                         : 
136212615.014357
[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   : 0
[Fri Dec  4 09:28:34 2015] .yld_count                     : 0
[Fri Dec  4 09:28:34 2015] .sched_count                   : 101658031
[Fri Dec  4 09:28:34 2015] .sched_goidle                  : 42813946
[Fri Dec  4 09:28:34 2015] .avg_idle                      : 1000000
[Fri Dec  4 09:28:34 2015] .ttwu_count                    : 59500415
[Fri Dec  4 09:28:34 2015] .ttwu_local                    : 7597598

[Fri Dec  4 09:28:34 2015] cfs_rq[5]:/autogroup-1403
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 230.543841
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 355.983581
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-26475587.558620
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 41
[Fri Dec  4 09:28:34 2015] .nr_running                    : 1
[Fri Dec  4 09:28:34 2015] .load                          : 1024
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 0
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .se->exec_start                : 
136212615.014357
[Fri Dec  4 09:28:34 2015] .se->vruntime                  : 10971035.472023
[Fri Dec  4 09:28:34 2015] .se->sum_exec_runtime          : 230.606599
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_start     : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.exec_max       : 2.722919
[Fri Dec  4 09:28:34 2015] .se->statistics.slice_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_max       : 0.109354
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_sum       : 3.479993
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_count     : 708
[Fri Dec  4 09:28:34 2015] .se->load.weight               : 1024
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_sum      : 0
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_period   : 47759
[Fri Dec  4 09:28:34 2015] .se->avg.load_avg_contrib      : 0
[Fri Dec  4 09:28:34 2015] .se->avg.decay_count           : 0

[Fri Dec  4 09:28:34 2015] cfs_rq[5]:/
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 2993175.284119
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 10971032.566799
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 10971044.027893
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 10971032.566799
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-15504899.514308
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 57
[Fri Dec  4 09:28:34 2015] .nr_running                    : 2
[Fri Dec  4 09:28:34 2015] .load                          : 2048
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 1
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 12
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_sum         : 92
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_period      : 47167

[Fri Dec  4 09:28:34 2015] rt_rq[5]:
[Fri Dec  4 09:28:34 2015] .rt_nr_running                 : 0
[Fri Dec  4 09:28:34 2015] .rt_throttled                  : 0
[Fri Dec  4 09:28:34 2015] .rt_time                       : 0.022568
[Fri Dec  4 09:28:34 2015] .rt_runtime                    : 950.000000

[Fri Dec  4 09:28:34 2015] runnable tasks:
[Fri Dec  4 09:28:34 2015]             task   PID tree-key switches  
prio     exec-runtime         sum-exec sum-sleep
[Fri Dec  4 09:28:34 2015] 
----------------------------------------------------------------------------------------------------------
[Fri Dec  4 09:28:34 2015]          rcuos/5    13 10971033.584866   
2331731   120  10971033.584866 108385.921359 136102683.479070 0 /
[Fri Dec  4 09:28:34 2015]       watchdog/5    47 -8.983447     
34089     0        -8.983447 695.200256 0.001978 0 /
[Fri Dec  4 09:28:34 2015]      migration/5    48 0.000000    494869     
0         0.000000      5210.341551 0.000957 0 /
[Fri Dec  4 09:28:34 2015]      ksoftirqd/5    49 10971032.115937    
120815   120  10971032.115937 2524.385728 136205075.696253 0 /
[Fri Dec  4 09:28:34 2015]     kworker/5:0H    51 1314.433845         
7   100      1314.433845         0.019130 5759.479654 0 /
[Fri Dec  4 09:28:34 2015]     kworker/5:1H   376 10924705.883613    
592663   100  10924705.883613 19824.511923 107439684.007966 0 /
[Fri Dec  4 09:28:34 2015]       rpc.idmapd   501 0.876436         2   
120         0.876436         0.221789 0.000000 0 /autogroup-103
[Fri Dec  4 09:28:34 2015]        in:imklog   558 63.680250      2456   
120        63.680250       152.211282 136187204.501111 0 /autogroup-112
[Fri Dec  4 09:28:34 2015]            gmain  2004 11.112020         3   
120        11.112020 0.033785 0.003892 0 /autogroup-266
[Fri Dec  4 09:28:34 2015]      kworker/5:2 17595 10869059.735478    
307364   120  10869059.735478 6109.767622 24108162.604994 0 /
[Fri Dec  4 09:28:34 2015]    xfs-data/sdc1 10014 7962554.998970         
2   100   7962554.998970 0.026140 0.017214 0 /
[Fri Dec  4 09:28:34 2015]     xfs-cil/sdc1 10016 7962567.017092         
2   100   7962567.017092 0.020740 0.023641 0 /
[Fri Dec  4 09:28:34 2015]      kworker/5:1 10568 10971032.566799    
128641   120  10971032.566799 3374.264692 43640364.953312 0 /
[Fri Dec  4 09:28:34 2015] R           bash 13770 355.983581       605   
120       355.983581       135.107161 2054353.015184 0 /autogroup-1403
[Fri Dec  4 09:28:34 2015]    kworker/u16:0 15748 
10971027.953261         2   120  10971027.953261 0.064451 0.041840 0 /

[Fri Dec  4 09:28:34 2015] cpu#6, 3300.307 MHz
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .nr_switches                   : 101330059
[Fri Dec  4 09:28:34 2015] .nr_load_updates               : 6673995
[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            : 4721
[Fri Dec  4 09:28:34 2015] .next_balance                  : 4328.978308
[Fri Dec  4 09:28:34 2015] .curr->pid                     : 0
[Fri Dec  4 09:28:34 2015] .clock                         : 
136212587.968700
[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   : 0
[Fri Dec  4 09:28:34 2015] .yld_count                     : 0
[Fri Dec  4 09:28:34 2015] .sched_count                   : 102357004
[Fri Dec  4 09:28:34 2015] .sched_goidle                  : 43064796
[Fri Dec  4 09:28:34 2015] .avg_idle                      : 1000000
[Fri Dec  4 09:28:34 2015] .ttwu_count                    : 59140573
[Fri Dec  4 09:28:34 2015] .ttwu_local                    : 7662707

[Fri Dec  4 09:28:34 2015] cfs_rq[6]:/
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 2942612.370030
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 10885288.919952
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-15590654.622249
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 60
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 0
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 12
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_sum         : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_period      : 47343

[Fri Dec  4 09:28:34 2015] rt_rq[6]:
[Fri Dec  4 09:28:34 2015] .rt_nr_running                 : 0
[Fri Dec  4 09:28:34 2015] .rt_throttled                  : 0
[Fri Dec  4 09:28:34 2015] .rt_time                       : 0.024601
[Fri Dec  4 09:28:34 2015] .rt_runtime                    : 950.000000

[Fri Dec  4 09:28:34 2015] runnable tasks:
[Fri Dec  4 09:28:34 2015]             task   PID tree-key switches  
prio     exec-runtime         sum-exec sum-sleep
[Fri Dec  4 09:28:34 2015] 
----------------------------------------------------------------------------------------------------------
[Fri Dec  4 09:28:34 2015]       watchdog/6    52 -8.983438     
34089     0        -8.983438 746.694608 0.001229 0 /
[Fri Dec  4 09:28:34 2015]      migration/6    53 0.000000    500995     
0         0.000000      5374.899305 0.000708 0 /
[Fri Dec  4 09:28:34 2015]      ksoftirqd/6    54 10885277.093904    
227411   120  10885277.093904 3544.811483 136206245.341403 0 /
[Fri Dec  4 09:28:34 2015]     kworker/6:0H    56 3696.921460         
7   100      3696.921460         0.028692 10119.614540 0 /
[Fri Dec  4 09:28:34 2015]        kdevtmpfs    63 3078.228300       
209   120      3078.228300         4.819342 7275.772029 0 /
[Fri Dec  4 09:28:34 2015]  charger_manager   122 187.040595         2   
100       187.040595 0.020085 0.007776 0 /
[Fri Dec  4 09:28:34 2015]        scsi_eh_0   181 1007.316465         
2   120      1007.316465 0.438704 0.085498 0 /
[Fri Dec  4 09:28:34 2015]        scsi_eh_4   185 2377.025540        
14   120      2377.025540 2.156366 401.832292 0 /
[Fri Dec  4 09:28:34 2015]  ext4-rsv-conver   210 2510.395347         
2   100      2510.395347 0.067114 0.041280 0 /
[Fri Dec  4 09:28:34 2015]      jbd2/sdb1-8   353 2546.575108         
2   120      2546.575108 0.060667 0.035684 0 /
[Fri Dec  4 09:28:34 2015]  ext4-rsv-conver   354 2558.630045         
2   100      2558.630045 0.055979 0.037283 0 /
[Fri Dec  4 09:28:34 2015]           rpciod   459 2638.698180         
2   100      2638.698180 0.005582 0.003100 0 /
[Fri Dec  4 09:28:34 2015]           nfsiod   464 2650.703138         
2   100      2650.703138 0.005447 0.002335 0 /
[Fri Dec  4 09:28:34 2015]  kvm-irqfd-clean   553 3025.776387         
2   100      3025.776387 0.012426 0.003151 0 /
[Fri Dec  4 09:28:34 2015]         ttm_swap   554 3037.781006         
2   100      3037.781006 0.005123 0.002415 0 /
[Fri Dec  4 09:28:34 2015]         rsyslogd   555 25.224250        13   
120        25.224250         1.580098 126966223.143891 0 /autogroup-112
[Fri Dec  4 09:28:34 2015]            getty  1053 0.316572         2   
120         0.316572         0.942951 0.000000 0 /autogroup-204
[Fri Dec  4 09:28:34 2015]            getty  1054 0.367943         2   
120         0.367943         0.851462 0.000000 0 /autogroup-205
[Fri Dec  4 09:28:34 2015]            getty  1056 0.340820         2   
120         0.340820         0.915774 0.000000 0 /autogroup-207
[Fri Dec  4 09:28:34 2015]             sshd  1078 327.941777       405   
120       327.941777        82.683192 134259926.849503 0 /autogroup-217
[Fri Dec  4 09:28:34 2015]     kworker/6:1H  2617 10839732.580783    
585771   100  10839732.580783 20183.712003 107397527.261184 0 /
[Fri Dec  4 09:28:34 2015]      kworker/6:0 16800 10803459.202410    
346761   120  10803459.202410 7185.014710 26461601.428861 0 /
[Fri Dec  4 09:28:34 2015]    xfs-conv/sdc1 10015 7888235.754725         
2   100   7888235.754725 0.024640 0.007303 0 /
[Fri Dec  4 09:28:34 2015]         glusterd 10331 390.262786         4   
120       390.262786 0.031971 0.013309 0 /autogroup-1375
[Fri Dec  4 09:28:34 2015]      kworker/6:1 11097 10885277.920224    
115607   120  10885277.920224 2798.397167 43052617.893022 0 /
[Fri Dec  4 09:28:34 2015]               su 13769 101.611241        10   
120       101.611241 6.988278 19.152158 0 /autogroup-1403

[Fri Dec  4 09:28:34 2015] cpu#7, 3300.307 MHz
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .nr_switches                   : 102128665
[Fri Dec  4 09:28:34 2015] .nr_load_updates               : 6775064
[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            : 43307
[Fri Dec  4 09:28:34 2015] .next_balance                  : 4328.978170
[Fri Dec  4 09:28:34 2015] .curr->pid                     : 0
[Fri Dec  4 09:28:34 2015] .clock                         : 
136212276.212312
[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   : 0
[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   : 0
[Fri Dec  4 09:28:34 2015] .yld_count                     : 0
[Fri Dec  4 09:28:34 2015] .sched_count                   : 103210194
[Fri Dec  4 09:28:34 2015] .sched_goidle                  : 43510224
[Fri Dec  4 09:28:34 2015] .avg_idle                      : 1000000
[Fri Dec  4 09:28:34 2015] .ttwu_count                    : 59131825
[Fri Dec  4 09:28:34 2015] .ttwu_local                    : 7981886

[Fri Dec  4 09:28:34 2015] cfs_rq[7]:/autogroup-297
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 53.219583
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 52.171007
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-26475891.371194
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 0
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 0
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .se->exec_start                : 
136212125.099063
[Fri Dec  4 09:28:34 2015] .se->vruntime                  : 10974006.018491
[Fri Dec  4 09:28:34 2015] .se->sum_exec_runtime          : 53.219583
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_start     : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_start    : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.sleep_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.block_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.exec_max       : 0.466913
[Fri Dec  4 09:28:34 2015] .se->statistics.slice_max      : 0.000000
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_max       : 0.002284
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_sum       : 0.003771
[Fri Dec  4 09:28:34 2015] .se->statistics.wait_count     : 936
[Fri Dec  4 09:28:34 2015] .se->load.weight               : 2
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_sum      : 2
[Fri Dec  4 09:28:34 2015] .se->avg.runnable_avg_period   : 47607
[Fri Dec  4 09:28:34 2015] .se->avg.load_avg_contrib      : 0
[Fri Dec  4 09:28:34 2015] .se->avg.decay_count           : 129902006

[Fri Dec  4 09:28:34 2015] cfs_rq[7]:/
[Fri Dec  4 09:28:34 2015] .exec_clock                    : 2988906.266991
[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .min_vruntime                  : 10974017.588045
[Fri Dec  4 09:28:34 2015] .max_vruntime                  : 0.000001
[Fri Dec  4 09:28:34 2015] .spread                        : 0.000000
[Fri Dec  4 09:28:34 2015] .spread0                       : 
-15501925.954156
[Fri Dec  4 09:28:34 2015] .nr_spread_over                : 64
[Fri Dec  4 09:28:34 2015] .nr_running                    : 0
[Fri Dec  4 09:28:34 2015] .load                          : 0
[Fri Dec  4 09:28:34 2015] .runnable_load_avg             : 0
[Fri Dec  4 09:28:34 2015] .blocked_load_avg              : 0
[Fri Dec  4 09:28:34 2015] .tg_load_contrib               : 0
[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           : 0
[Fri Dec  4 09:28:34 2015] .tg_load_avg                   : 0
[Fri Dec  4 09:28:34 2015] .tg->runnable_avg              : 12
[Fri Dec  4 09:28:34 2015] .tg->cfs_bandwidth.timer_active: 0
[Fri Dec  4 09:28:34 2015] .throttled                     : 0
[Fri Dec  4 09:28:34 2015] .throttle_count                : 0
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_sum         : 3
[Fri Dec  4 09:28:34 2015] .avg->runnable_avg_period      : 47050

[Fri Dec  4 09:28:34 2015] rt_rq[7]:
[Fri Dec  4 09:28:34 2015] .rt_nr_running                 : 0
[Fri Dec  4 09:28:34 2015] .rt_throttled                  : 0
[Fri Dec  4 09:28:34 2015] .rt_time                       : 0.023187
[Fri Dec  4 09:28:34 2015] .rt_runtime                    : 950.000000

[Fri Dec  4 09:28:34 2015] runnable tasks:
[Fri Dec  4 09:28:34 2015]             task   PID tree-key switches  
prio     exec-runtime         sum-exec sum-sleep
[Fri Dec  4 09:28:34 2015] 
----------------------------------------------------------------------------------------------------------
[Fri Dec  4 09:28:34 2015]          rcuos/7    15 10974007.991598   
2382699   120  10974007.991598 110085.790054 136101357.927665 0 /
[Fri Dec  4 09:28:34 2015]       watchdog/7    57 -8.982100     
34089     0        -8.982100 703.493670 0.001050 0 /
[Fri Dec  4 09:28:34 2015]      migration/7    58 0.000000    526347     
0         0.000000      5656.020194 0.000729 0 /
[Fri Dec  4 09:28:34 2015]      ksoftirqd/7    59 10974005.644505    
124819   120  10974005.644505 2720.084599 136202330.704909 0 /
[Fri Dec  4 09:28:34 2015]     kworker/7:0H    61 4090.966692         
7   100      4090.966692         0.025188 10735.407280 0 /
[Fri Dec  4 09:28:34 2015]          khelper    62 10.956262         2   
100        10.956262 0.005331 0.002345 0 /
[Fri Dec  4 09:28:34 2015]            netns    64 35.000828         2   
100        35.000828 0.003422 0.001643 0 /
[Fri Dec  4 09:28:34 2015]        writeback    65 47.003840         2   
100        47.003840 0.003331 0.001576 0 /
[Fri Dec  4 09:28:34 2015]      kintegrityd    66 59.006725         2   
100        59.006725 0.003165 0.001356 0 /
[Fri Dec  4 09:28:34 2015]           bioset    67 71.009702         2   
100        71.009702 0.003268 0.001227 0 /
[Fri Dec  4 09:28:34 2015]          kblockd    69 95.014561         2   
100        95.014561 0.003339 0.001176 0 /
[Fri Dec  4 09:28:34 2015]          ata_sff    70 103.018850         2   
100       103.018850 0.004569 0.001682 0 /
[Fri Dec  4 09:28:34 2015]              atd  1105 0.504305        45   
120         0.504305         2.077412 133071116.634185 0 /autogroup-222
[Fri Dec  4 09:28:34 2015]       irqbalance  1243 524.318196     13688   
120       524.318196     20988.724370 136178139.182247 0 /autogroup-261
[Fri Dec  4 09:28:34 2015]     kworker/7:1H  2717 10921547.648508    
651792   100  10921547.648508 22042.496277 107431179.258583 0 /
[Fri Dec  4 09:28:34 2015]             ntpd  2920 52.171007    137327   
120        52.171007      8227.627639 136171806.565453 0 /autogroup-297
[Fri Dec  4 09:28:34 2015]      kworker/7:0  9210 10974005.838109    
218615   120  10974005.838109 4608.186376 44449710.811257 0 /
[Fri Dec  4 09:28:34 2015]        glusterfs 10343 10.997945         3   
120        10.997945 0.046530 0.092406 0 /autogroup-1380
[Fri Dec  4 09:28:34 2015]        glusterfs 10344 1077.778544        
77   120      1077.778544         2.718423 43685955.763044 0 
/autogroup-1380
[Fri Dec  4 09:28:34 2015]      kworker/7:2 12998 
10782985.841970         2   120  10782985.841970 0.017175 0.004086 0 /
[Fri Dec  4 09:28:34 2015]             sshd 13632 2570.449211        
67   120      2570.449211        30.289697 2971.025095 0 /autogroup-1402
[Fri Dec  4 09:28:34 2015]
[ 09:30:50 ] - root@gluster-ger-ber-12  /home/admin $

-- 
Dietmar Putz
3Q Medien GmbH
Wetzlarer Str. 86
D-14482 Potsdam
  
Telefax:  +49 (0)331 / 2797 866 - 1
Telefon:  +49 (0)331 / 2792 866 - 8
Mobile:   +49 171 / 90 160 39
Mail:     putz@3qmedien.net


--------------070807060201020309090804
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hello all,<br>
    <br>
    recently we had some updates in a gluster environment as described
    in :<br>
<a class="moz-txt-link-freetext" href="https://www.gluster.org/pipermail/gluster-users/2015-December/024509.html">https://www.gluster.org/pipermail/gluster-users/2015-December/024509.html</a><br>
    <br>
    since then we are faced to the below show errors.<br>
    otherwise as stated in the report on gluster.org not always the same
    nodes of the cluster are affected but those who are currently being
    used by a gluster-client. all clients running ubuntu 12.04.5 or
    14.04.3 with 3.13.0-67 or ~71 and using the same glusterfs-client
    version as installed on the glusterfs server (gfs 3.6.7).<br>
    we made several tests with different kernel version like 3.13.0-24,
    3.13.0-67 and 3.13.0-71. in any case we received error messages as
    shown below for gluster-ger-ber-12-int.<br>
    After upgrade to kernel 3.19.0-39 the error message turns from
    "Internal error xfs_attr3_leaf_write_verify...." to "Metadata
    corruption detected at xfs_attr3_leaf_write_verify..." as shown
    below for gluster-ger-ber-11-int.<br>
    in any case the behavior is the same...the file system becomes
    inaccessible and returns an Input/output error. xfs_check does not
    show any information and xfs_repair does not show any error. it is
    sufficient to remount the file system and it is accessible again.<br>
    <br>
    similar reports are existing :<br>
    <a class="moz-txt-link-freetext" href="http://oss.sgi.com/archives/xfs/2015-11/msg00459.html">http://oss.sgi.com/archives/xfs/2015-11/msg00459.html</a><br>
<a class="moz-txt-link-freetext" href="https://bugs.launchpad.net/ubuntu/+source/linux-lts-trusty/+bug/1468039">https://bugs.launchpad.net/ubuntu/+source/linux-lts-trusty/+bug/1468039</a><br>
    <br>
    we decided to downgrade the kernel on the glusterfs-server nodes to<br>
     <br>
    3.8.4-030804-generic #201303201832 SMP Wed Mar 20 22:33:00 UTC 2013
    x86_64 x86_64 x86_64 GNU/Linux<br>
    <br>
    since then the error disappeared.<br>
    for both below shown errors a trace output is available (trace-cmd
    record -e xfs\*).<br>
    <br>
    <br>
    best regards<br>
    dietmar<br>
    <br>
    <br>
    <br>
    <br>
    gluster-ger-ber-11-int : (kernel 3.19.0-39)<br>
    <br>
    <tt>[56909.996801] XFS (sdc1): xfs_log_force: error -5 returned.</tt><tt><br>
    </tt><tt> [56910.019110] XFS (sdc1): xfs_log_force: error -5
      returned.</tt><tt><br>
    </tt><tt> [56934.013585] XFS (sdc1): Mounting V4 Filesystem</tt><tt><br>
    </tt><tt> [56934.149640] XFS (sdc1): Starting recovery (logdev:
      internal)</tt><tt><br>
    </tt><tt> [56934.577267] XFS (sdc1): Ending recovery (logdev:
      internal)</tt><tt><br>
    </tt><tt> [58674.887753] XFS (sdc1): Mounting V4 Filesystem</tt><tt><br>
    </tt><tt> [58675.000355] XFS (sdc1): Ending clean mount</tt><tt><br>
    </tt><tt> [58724.547431] init: statd main process (1490) killed by
      KILL signal</tt><tt><br>
    </tt><tt> [58724.547440] init: statd main process ended, respawning</tt><tt><br>
    </tt><tt> [65828.900368] bash (23057): drop_caches: 3</tt><tt><br>
    </tt><tt> [67475.972089] nr_pdflush_threads exported in /proc is
      scheduled for removal</tt><tt><br>
    </tt><tt> [73715.250762] XFS (sdc1): Metadata corruption detected at
      xfs_attr3_leaf_write_verify+0xe5/0x100 [xfs], block 0x44482d730</tt><tt><br>
    </tt><tt> [73715.250803] XFS (sdc1): Unmount and run xfs_repair</tt><tt><br>
    </tt><tt> [73715.250816] XFS (sdc1): First 64 bytes of corrupted
      metadata buffer:</tt><tt><br>
    </tt><tt> [73715.250832] ffff8807f7b07000: 00 00 00 00 00 00 00 00
      fb ee 00 00 00 00 00 00  ................</tt><tt><br>
    </tt><tt> [73715.250856] ffff8807f7b07010: 10 00 00 00 00 20 0f e0
      00 00 00 00 00 00 00 00  ..... ..........</tt><tt><br>
    </tt><tt> [73715.250876] ffff8807f7b07020: 00 00 00 00 00 00 00 00
      00 00 00 00 00 00 00 00  ................</tt><tt><br>
    </tt><tt> [73715.250907] ffff8807f7b07030: 00 00 00 00 00 00 00 00
      00 00 00 00 00 00 00 00  ................</tt><tt><br>
    </tt><tt> [73715.250941] XFS (sdc1): xfs_do_force_shutdown(0x8)
      called from line 1249 of file
      /build/linux-lts-vivid-1jarlV/linux-lts-vivid-3.19.0/fs/xfs/xfs_buf.c. 
      Return address = 0xffffffffc02bbd22</tt><tt><br>
    </tt><tt> [73715.251375] XFS (sdc1): Corruption of in-memory data
      detected.  Shutting down filesystem</tt><tt><br>
    </tt><tt> [73715.251398] XFS (sdc1): Please umount the filesystem
      and rectify the problem(s)</tt><tt><br>
    </tt><tt> [73715.302287] XFS (sdc1): xfs_log_force: error -5
      returned.</tt><tt><br>
    </tt><tt> [73730.431543] XFS (sdc1): xfs_log_force: error -5
      returned.</tt><tt><br>
    </tt><tt> </tt><br>
    <br>
    <br>
    gluster-ger-ber-12-int : (kernel 3.13.0-67) <br>
    <br>
    <tt>[159046.531752] XFS (sdc1): Mounting Filesystem
    </tt><tt><br>
    </tt><tt>[159046.675156] XFS (sdc1): Starting recovery (logdev:
      internal)
    </tt><tt><br>
    </tt><tt>[159047.240939] XFS (sdc1): Ending recovery (logdev:
      internal)
    </tt><tt><br>
    </tt><tt>[159064.372532] XFS (sdc1): Mounting Filesystem
    </tt><tt><br>
    </tt><tt>[159064.496445] XFS (sdc1): Ending clean mount
    </tt><tt><br>
    </tt><tt>[160598.216262] XFS (sdc1): Mounting Filesystem
    </tt><tt><br>
    </tt><tt>[160598.403044] XFS (sdc1): Ending clean mount
    </tt><tt><br>
    </tt><tt>[160673.912887] init: statd main process (21051) killed by
      KILL signal
    </tt><tt><br>
    </tt><tt>[160673.912897] init: statd main process ended, respawning
    </tt><tt><br>
    </tt><tt>[160674.035234] init: statd main process (8122) terminated
      with status 1
    </tt><tt><br>
    </tt><tt>[160674.035240] init: statd main process ended, respawning
    </tt><tt><br>
    </tt><tt>[175683.930045] ffff8807a8f59000: 00 00 00 00 00 00 00 00
      fb ee 00 00 00 00 00 00  ................
    </tt><tt><br>
    </tt><tt>[175683.932979] ffff8807a8f59010: 10 00 00 00 00 20 0f e0
      00 00 00 00 00 00 00 00  ..... ..........
    </tt><tt><br>
    </tt><tt>[175683.935812] ffff8807a8f59020: 00 00 00 00 00 00 00 00
      00 00 00 00 00 00 00 00  ................
    </tt><tt><br>
    </tt><tt>[175683.938644] ffff8807a8f59030: 00 00 00 00 00 00 00 00
      00 00 00 00 00 00 00 00  ................
    </tt><tt><br>
    </tt><tt>[175683.940870] XFS (sdc1): Internal error
      xfs_attr3_leaf_write_verify at line 216 of file
      /build/linux-XHaR1x/linux-3.13.0/fs/xfs/xfs_attr_leaf.c.  Caller
      0xffffffffa01936f0
    </tt><tt><br>
    </tt><tt>[175683.943857] CPU: 2 PID: 7874 Comm: xfsaild/sdc1 Not
      tainted 3.13.0-67-generic #110-Ubuntu
    </tt><tt><br>
    </tt><tt>[175683.943859] Hardware name: Supermicro
      X10SLL-F/X10SLL-F, BIOS 1.1b 11/01/2013
    </tt><tt><br>
    </tt><tt>[175683.943861]  0000000000000001 ffff8807ef1ffbd0
      ffffffff817240e0 ffff880036846000
    </tt><tt><br>
    </tt><tt>[175683.943866]  ffff8807ef1ffbe8 ffffffffa01976fb
      ffffffffa01936f0 ffff8807ef1ffc20
    </tt><tt><br>
    </tt><tt>[175683.943870]  ffffffffa0197755 000000d80020fc00
      ffff88075c2b4900 ffff88025fbea488
    </tt><tt><br>
    </tt><tt>[175683.943873] Call Trace:
    </tt><tt><br>
    </tt><tt>[175683.943883]  [&lt;ffffffff817240e0&gt;]
      dump_stack+0x45/0x56
    </tt><tt><br>
    </tt><tt>[175683.943917]  [&lt;ffffffffa01976fb&gt;]
      xfs_error_report+0x3b/0x40 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.943933]  [&lt;ffffffffa01936f0&gt;] ?
      _xfs_buf_ioapply+0x70/0x3a0 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.943948]  [&lt;ffffffffa0197755&gt;]
      xfs_corruption_error+0x55/0x80 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.943968]  [&lt;ffffffffa01b4b70&gt;]
      xfs_attr3_leaf_write_verify+0x100/0x120 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.943983]  [&lt;ffffffffa01936f0&gt;] ?
      _xfs_buf_ioapply+0x70/0x3a0 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.943998]  [&lt;ffffffffa01953d5&gt;] ?
      xfs_bdstrat_cb+0x55/0xb0 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944012]  [&lt;ffffffffa01936f0&gt;]
      _xfs_buf_ioapply+0x70/0x3a0 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944017]  [&lt;ffffffff81122a1d&gt;] ?
      trace_buffer_unlock_commit+0x4d/0x60
    </tt><tt><br>
    </tt><tt>[175683.944030]  [&lt;ffffffffa01854d2&gt;] ?
      ftrace_raw_event_xfs_buf_class+0xf2/0x100 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944045]  [&lt;ffffffffa0195322&gt;] ?
      xfs_buf_iorequest+0x32/0x90 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944059]  [&lt;ffffffffa01953d5&gt;] ?
      xfs_bdstrat_cb+0x55/0xb0 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944073]  [&lt;ffffffffa0195336&gt;]
      xfs_buf_iorequest+0x46/0x90 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944087]  [&lt;ffffffffa01953d5&gt;]
      xfs_bdstrat_cb+0x55/0xb0 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944102]  [&lt;ffffffffa019556b&gt;]
      __xfs_buf_delwri_submit+0x13b/0x210 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944117]  [&lt;ffffffffa0196000&gt;] ?
      xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944132]  [&lt;ffffffffa0196000&gt;]
      xfs_buf_delwri_submit_nowait+0x20/0x30 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944157]  [&lt;ffffffffa01f4d27&gt;]
      xfsaild+0x237/0x5c0 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944181]  [&lt;ffffffffa01f4af0&gt;] ?
      xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
    </tt><tt><br>
    </tt><tt>[175683.944186]  [&lt;ffffffff8108b7d2&gt;]
      kthread+0xd2/0xf0
    </tt><tt><br>
    </tt><tt>[175683.944189]  [&lt;ffffffff8108b700&gt;] ?
      kthread_create_on_node+0x1c0/0x1c0
    </tt><tt><br>
    </tt><tt>[175683.944193]  [&lt;ffffffff81734c28&gt;]
      ret_from_fork+0x58/0x90
    </tt><tt><br>
    </tt><tt>[175683.944196]  [&lt;ffffffff8108b700&gt;] ?
      kthread_create_on_node+0x1c0/0x1c0
    </tt><tt><br>
    </tt><tt>[175683.944199] XFS (sdc1): Corruption detected. Unmount
      and run xfs_repair
    </tt><tt><br>
    </tt><tt>[175683.945754] XFS (sdc1): xfs_do_force_shutdown(0x8)
      called from line 1320 of file
      /build/linux-XHaR1x/linux-3.13.0/fs/xfs/xfs_buf.c.  Return address
      = 0xffffffffa019371c
    </tt><tt><br>
    </tt><tt>[175683.946133] XFS (sdc1): Corruption of in-memory data
      detected.  Shutting down filesystem
    </tt><tt><br>
    </tt><tt>[175683.947204] XFS (sdc1): Please umount the filesystem
      and rectify the problem(s)
    </tt><tt><br>
    </tt><tt>[175713.963171] XFS (sdc1): xfs_log_force: error 5
      returned.
    </tt><tt><br>
    </tt><tt>[175744.014122] XFS (sdc1): xfs_log_force: error 5
      returned.
      <br>
      <br>
      <br>
    </tt><br>
    <tt>Kernel-Version :
    </tt><tt><br>
    </tt><tt>[ 09:07:53 ] - root@gluster-ger-ber-12  /home/admin $uname
      -a
    </tt><tt><br>
    </tt><tt>Linux gluster-ger-ber-12 3.13.0-67-generic #110-Ubuntu SMP
      Fri Oct 23 13:24:41 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>xfsprogs Version :
    </tt><tt><br>
    </tt><tt>[ 09:20:36 ] - root@gluster-ger-ber-12  /home/admin
      $xfs_repair -V
    </tt><tt><br>
    </tt><tt>xfs_repair version 3.1.9
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Number and type of CPU :
    </tt><tt><br>
    </tt><tt>1 CPU
    </tt><tt><br>
    </tt><tt>model name    : Intel(R) Xeon(R) CPU E3-1230 v3 @ 3.30GHz
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[ 09:21:49 ] - root@gluster-ger-ber-12  /home/admin $more
      /proc/meminfo
    </tt><tt><br>
    </tt><tt>MemTotal:       32907248 kB
    </tt><tt><br>
    </tt><tt>MemFree:          258068 kB
    </tt><tt><br>
    </tt><tt>Buffers:           99024 kB
    </tt><tt><br>
    </tt><tt>Cached:         31446816 kB
    </tt><tt><br>
    </tt><tt>SwapCached:         3836 kB
    </tt><tt><br>
    </tt><tt>Active:         15800552 kB
    </tt><tt><br>
    </tt><tt>Inactive:       15975832 kB
    </tt><tt><br>
    </tt><tt>Active(anon):      44396 kB
    </tt><tt><br>
    </tt><tt>Inactive(anon):   186212 kB
    </tt><tt><br>
    </tt><tt>Active(file):   15756156 kB
    </tt><tt><br>
    </tt><tt>Inactive(file): 15789620 kB
    </tt><tt><br>
    </tt><tt>Unevictable:           0 kB
    </tt><tt><br>
    </tt><tt>Mlocked:               0 kB
    </tt><tt><br>
    </tt><tt>SwapTotal:      33510396 kB
    </tt><tt><br>
    </tt><tt>SwapFree:       33449196 kB
    </tt><tt><br>
    </tt><tt>Dirty:                 4 kB
    </tt><tt><br>
    </tt><tt>Writeback:             0 kB
    </tt><tt><br>
    </tt><tt>AnonPages:        227736 kB
    </tt><tt><br>
    </tt><tt>Mapped:             9772 kB
    </tt><tt><br>
    </tt><tt>Shmem:                64 kB
    </tt><tt><br>
    </tt><tt>Slab:             451404 kB
    </tt><tt><br>
    </tt><tt>SReclaimable:     400636 kB
    </tt><tt><br>
    </tt><tt>SUnreclaim:        50768 kB
    </tt><tt><br>
    </tt><tt>KernelStack:        1560 kB
    </tt><tt><br>
    </tt><tt>PageTables:         4128 kB
    </tt><tt><br>
    </tt><tt>NFS_Unstable:          0 kB
    </tt><tt><br>
    </tt><tt>Bounce:                0 kB
    </tt><tt><br>
    </tt><tt>WritebackTmp:          0 kB
    </tt><tt><br>
    </tt><tt>CommitLimit:    49964020 kB
    </tt><tt><br>
    </tt><tt>Committed_AS:     598956 kB
    </tt><tt><br>
    </tt><tt>VmallocTotal:   34359738367 kB
    </tt><tt><br>
    </tt><tt>VmallocUsed:      161180 kB
    </tt><tt><br>
    </tt><tt>VmallocChunk:   34359537664 kB
    </tt><tt><br>
    </tt><tt>HardwareCorrupted:     0 kB
    </tt><tt><br>
    </tt><tt>AnonHugePages:    126976 kB
    </tt><tt><br>
    </tt><tt>HugePages_Total:       0
    </tt><tt><br>
    </tt><tt>HugePages_Free:        0
    </tt><tt><br>
    </tt><tt>HugePages_Rsvd:        0
    </tt><tt><br>
    </tt><tt>HugePages_Surp:        0
    </tt><tt><br>
    </tt><tt>Hugepagesize:       2048 kB
    </tt><tt><br>
    </tt><tt>DirectMap4k:       85232 kB
    </tt><tt><br>
    </tt><tt>DirectMap2M:     3018752 kB
    </tt><tt><br>
    </tt><tt>DirectMap1G:    30408704 kB
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[ 09:21:54 ] - root@gluster-ger-ber-12  /home/admin $more
      /proc/mounts
    </tt><tt><br>
    </tt><tt>rootfs / rootfs rw 0 0
    </tt><tt><br>
    </tt><tt>sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
    </tt><tt><br>
    </tt><tt>proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
    </tt><tt><br>
    </tt><tt>udev /dev devtmpfs
      rw,relatime,size=16442840k,nr_inodes=4110710,mode=755 0 0
    </tt><tt><br>
    </tt><tt>devpts /dev/pts devpts
      rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
    </tt><tt><br>
    </tt><tt>tmpfs /run tmpfs
      rw,nosuid,noexec,relatime,size=3290728k,mode=755 0 0
    </tt><tt><br>
    </tt><tt>/dev/disk/by-uuid/b1db3d58-26c3-4ed1-a53d-34cb11978ba5 /
      ext4 rw,relatime,errors=remount-ro,data=ordered 0 0
    </tt><tt><br>
    </tt><tt>none /sys/fs/cgroup tmpfs rw,relatime,size=4k,mode=755 0 0
    </tt><tt><br>
    </tt><tt>none /sys/fs/fuse/connections fusectl rw,relatime 0 0
    </tt><tt><br>
    </tt><tt>none /sys/kernel/debug debugfs rw,relatime 0 0
    </tt><tt><br>
    </tt><tt>none /sys/kernel/security securityfs rw,relatime 0 0
    </tt><tt><br>
    </tt><tt>none /run/lock tmpfs
      rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
    </tt><tt><br>
    </tt><tt>none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
    </tt><tt><br>
    </tt><tt>none /run/user tmpfs
      rw,nosuid,nodev,noexec,relatime,size=102400k,mode=755 0 0
    </tt><tt><br>
    </tt><tt>none /sys/fs/pstore pstore rw,relatime 0 0
    </tt><tt><br>
    </tt><tt>/dev/sdb1 /data ext4 rw,relatime,data=ordered 0 0
    </tt><tt><br>
    </tt><tt>rpc_pipefs /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
    </tt><tt><br>
    </tt><tt>systemd /sys/fs/cgroup/systemd cgroup
      rw,nosuid,nodev,noexec,relatime,name=systemd 0 0
    </tt><tt><br>
    </tt><tt>gluster-ger-ber-12-int:/ger-ber-01 /sdn fuse.glusterfs
      rw,relatime,user_id=0,group_id=0,default_permissions,allow_other,max_read=131072
      0 0
    </tt><tt><br>
    </tt><tt>/dev/sdc1 /gluster-export xfs
      rw,relatime,attr2,inode64,noquota 0 0
    </tt><tt><br>
    </tt><tt>[ 09:22:20 ] - root@gluster-ger-ber-12  /home/admin $
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[ 09:22:20 ] - root@gluster-ger-ber-12  /home/admin $more
      /proc/partitions
    </tt><tt><br>
    </tt><tt>major minor  #blocks  name
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>   8        0  209715200 sda
    </tt><tt><br>
    </tt><tt>   8        1  176201728 sda1
    </tt><tt><br>
    </tt><tt>   8        2          1 sda2
    </tt><tt><br>
    </tt><tt>   8        5   33510400 sda5
    </tt><tt><br>
    </tt><tt>   8       16 3696754688 sdb
    </tt><tt><br>
    </tt><tt>   8       17 3696753647 sdb1
    </tt><tt><br>
    </tt><tt>   8       32 19532349440 sdc
    </tt><tt><br>
    </tt><tt>   8       33 19532348399 sdc1
    </tt><tt><br>
    </tt><tt>[ 09:22:39 ] - root@gluster-ger-ber-12  /home/admin $
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[ 09:23:22 ] - root@gluster-ger-ber-12  /home/admin $lspci
      -v | more
    </tt><tt><br>
    </tt><tt>...
    </tt><tt><br>
    </tt><tt>05:00.0 RAID bus controller: LSI Logic / Symbios Logic
      MegaRAID SAS 2208 [Thunderbolt] (rev 05)
    </tt><tt><br>
    </tt><tt>    Subsystem: LSI Logic / Symbios Logic MegaRAID SAS
      9271-8i
    </tt><tt><br>
    </tt><tt>    Flags: bus master, fast devsel, latency 0, IRQ 16
    </tt><tt><br>
    </tt><tt>    I/O ports at b000 [size=256]
    </tt><tt><br>
    </tt><tt>    Memory at f7160000 (64-bit, non-prefetchable)
      [size=16K]
    </tt><tt><br>
    </tt><tt>    Memory at f7100000 (64-bit, non-prefetchable)
      [size=256K]
    </tt><tt><br>
    </tt><tt>    Expansion ROM at f7140000 [disabled] [size=128K]
    </tt><tt><br>
    </tt><tt>    Capabilities: [50] Power Management version 3
    </tt><tt><br>
    </tt><tt>    Capabilities: [68] Express Endpoint, MSI 00
    </tt><tt><br>
    </tt><tt>    Capabilities: [d0] Vital Product Data
    </tt><tt><br>
    </tt><tt>    Capabilities: [a8] MSI: Enable- Count=1/1 Maskable-
      64bit+
    </tt><tt><br>
    </tt><tt>    Capabilities: [c0] MSI-X: Enable+ Count=16 Masked-
    </tt><tt><br>
    </tt><tt>    Capabilities: [100] Advanced Error Reporting
    </tt><tt><br>
    </tt><tt>    Capabilities: [1e0] #19
    </tt><tt><br>
    </tt><tt>    Capabilities: [1c0] Power Budgeting &lt;?&gt;
    </tt><tt><br>
    </tt><tt>    Capabilities: [190] #16
    </tt><tt><br>
    </tt><tt>    Capabilities: [148] Alternative Routing-ID
      Interpretation (ARI)
    </tt><tt><br>
    </tt><tt>    Kernel driver in use: megaraid_sas
    </tt><tt><br>
    </tt><tt>    Kernel modules: megaraid_sas
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Affected Virtual Drive : 2
    </tt><tt><br>
    </tt><tt>[ 09:24:14 ] - root@gluster-ger-ber-12  /home/admin
      $megacli -LDInfo -Lall -aALL
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Adapter 0 -- Virtual Drive Information:
    </tt><tt><br>
    </tt><tt>Virtual Drive: 0 (Target Id: 0)
    </tt><tt><br>
    </tt><tt>Name                :
    </tt><tt><br>
    </tt><tt>RAID Level          : Primary-1, Secondary-0, RAID Level
      Qualifier-0
    </tt><tt><br>
    </tt><tt>Size                : 200.0 GB
    </tt><tt><br>
    </tt><tt>Sector Size         : 512
    </tt><tt><br>
    </tt><tt>Is VD emulated      : Yes
    </tt><tt><br>
    </tt><tt>Mirror Data         : 200.0 GB
    </tt><tt><br>
    </tt><tt>State               : Optimal
    </tt><tt><br>
    </tt><tt>Strip Size          : 256 KB
    </tt><tt><br>
    </tt><tt>Number Of Drives    : 2
    </tt><tt><br>
    </tt><tt>Span Depth          : 1
    </tt><tt><br>
    </tt><tt>Default Cache Policy: WriteBack, ReadAhead, Direct, No
      Write Cache if Bad BBU
    </tt><tt><br>
    </tt><tt>Current Cache Policy: WriteBack, ReadAhead, Direct, No
      Write Cache if Bad BBU
    </tt><tt><br>
    </tt><tt>Default Access Policy: Read/Write
    </tt><tt><br>
    </tt><tt>Current Access Policy: Read/Write
    </tt><tt><br>
    </tt><tt>Disk Cache Policy   : Disk's Default
    </tt><tt><br>
    </tt><tt>Encryption Type     : None
    </tt><tt><br>
    </tt><tt>PI type: No PI
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Is VD Cached: No
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Virtual Drive: 1 (Target Id: 1)
    </tt><tt><br>
    </tt><tt>Name                :
    </tt><tt><br>
    </tt><tt>RAID Level          : Primary-1, Secondary-0, RAID Level
      Qualifier-0
    </tt><tt><br>
    </tt><tt>Size                : 3.442 TB
    </tt><tt><br>
    </tt><tt>Sector Size         : 512
    </tt><tt><br>
    </tt><tt>Is VD emulated      : Yes
    </tt><tt><br>
    </tt><tt>Mirror Data         : 3.442 TB
    </tt><tt><br>
    </tt><tt>State               : Optimal
    </tt><tt><br>
    </tt><tt>Strip Size          : 256 KB
    </tt><tt><br>
    </tt><tt>Number Of Drives    : 2
    </tt><tt><br>
    </tt><tt>Span Depth          : 1
    </tt><tt><br>
    </tt><tt>Default Cache Policy: WriteBack, ReadAhead, Direct, No
      Write Cache if Bad BBU
    </tt><tt><br>
    </tt><tt>Current Cache Policy: WriteBack, ReadAhead, Direct, No
      Write Cache if Bad BBU
    </tt><tt><br>
    </tt><tt>Default Access Policy: Read/Write
    </tt><tt><br>
    </tt><tt>Current Access Policy: Read/Write
    </tt><tt><br>
    </tt><tt>Disk Cache Policy   : Disk's Default
    </tt><tt><br>
    </tt><tt>Encryption Type     : None
    </tt><tt><br>
    </tt><tt>PI type: No PI
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Is VD Cached: No
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Virtual Drive: 2 (Target Id: 2)
    </tt><tt><br>
    </tt><tt>Name                :
    </tt><tt><br>
    </tt><tt>RAID Level          : Primary-5, Secondary-0, RAID Level
      Qualifier-3
    </tt><tt><br>
    </tt><tt>Size                : 18.190 TB
    </tt><tt><br>
    </tt><tt>Sector Size         : 512
    </tt><tt><br>
    </tt><tt>Is VD emulated      : Yes
    </tt><tt><br>
    </tt><tt>Parity Size         : 3.637 TB
    </tt><tt><br>
    </tt><tt>State               : Optimal
    </tt><tt><br>
    </tt><tt>Strip Size          : 256 KB
    </tt><tt><br>
    </tt><tt>Number Of Drives    : 6
    </tt><tt><br>
    </tt><tt>Span Depth          : 1
    </tt><tt><br>
    </tt><tt>Default Cache Policy: WriteBack, ReadAhead, Direct, No
      Write Cache if Bad BBU
    </tt><tt><br>
    </tt><tt>Current Cache Policy: WriteBack, ReadAhead, Direct, No
      Write Cache if Bad BBU
    </tt><tt><br>
    </tt><tt>Default Access Policy: Read/Write
    </tt><tt><br>
    </tt><tt>Current Access Policy: Read/Write
    </tt><tt><br>
    </tt><tt>Disk Cache Policy   : Disk's Default
    </tt><tt><br>
    </tt><tt>Encryption Type     : None
    </tt><tt><br>
    </tt><tt>PI type: No PI
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Is VD Cached: No
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Exit Code: 0x00
    </tt><tt><br>
    </tt><tt>[ 09:24:17 ] - root@gluster-ger-ber-12  /home/admin $
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>All disks are of same type : HGST Ultrastar 7K4000 512e 4TB
    </tt><tt><br>
    </tt><tt>[ 09:25:27 ] - root@gluster-ger-ber-12  /home/admin
      $megacli -PDList -aALL | more
    </tt><tt><br>
    </tt><tt>...
    </tt><tt><br>
    </tt><tt>Enclosure Device ID: 252
    </tt><tt><br>
    </tt><tt>Slot Number: 2
    </tt><tt><br>
    </tt><tt>Drive's position: DiskGroup: 1, Span: 0, Arm: 0
    </tt><tt><br>
    </tt><tt>Enclosure position: N/A
    </tt><tt><br>
    </tt><tt>Device Id: 9
    </tt><tt><br>
    </tt><tt>WWN: 5000cca23dd7cc1d
    </tt><tt><br>
    </tt><tt>Sequence Number: 2
    </tt><tt><br>
    </tt><tt>Media Error Count: 0
    </tt><tt><br>
    </tt><tt>Other Error Count: 0
    </tt><tt><br>
    </tt><tt>Predictive Failure Count: 0
    </tt><tt><br>
    </tt><tt>Last Predictive Failure Event Seq Number: 0
    </tt><tt><br>
    </tt><tt>PD Type: SATA
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>Raw Size: 3.638 TB [0x1d1c0beb0 Sectors]
    </tt><tt><br>
    </tt><tt>Non Coerced Size: 3.637 TB [0x1d1b0beb0 Sectors]
    </tt><tt><br>
    </tt><tt>Coerced Size: 3.637 TB [0x1d1b00000 Sectors]
    </tt><tt><br>
    </tt><tt>Sector Size:  512
    </tt><tt><br>
    </tt><tt>Logical Sector Size:  512
    </tt><tt><br>
    </tt><tt>Physical Sector Size:  4096
    </tt><tt><br>
    </tt><tt>Firmware state: Online, Spun Up
    </tt><tt><br>
    </tt><tt>Commissioned Spare : Yes
    </tt><tt><br>
    </tt><tt>Emergency Spare : No
    </tt><tt><br>
    </tt><tt>Device Firmware Level: A580
    </tt><tt><br>
    </tt><tt>Shield Counter: 0
    </tt><tt><br>
    </tt><tt>Successful diagnostics completion on :  N/A
    </tt><tt><br>
    </tt><tt>SAS Address(0): 0x4433221101000000
    </tt><tt><br>
    </tt><tt>Connected Port Number: 1(path0)
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1334PBHPAW2PHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>FDE Capable: Not Capable
    </tt><tt><br>
    </tt><tt>FDE Enable: Disable
    </tt><tt><br>
    </tt><tt>Secured: Unsecured
    </tt><tt><br>
    </tt><tt>Locked: Unlocked
    </tt><tt><br>
    </tt><tt>Needs EKM Attention: No
    </tt><tt><br>
    </tt><tt>Foreign State: None
    </tt><tt><br>
    </tt><tt>Device Speed: 6.0Gb/s
    </tt><tt><br>
    </tt><tt>Link Speed: 6.0Gb/s
    </tt><tt><br>
    </tt><tt>Media Type: Hard Disk Device
    </tt><tt><br>
    </tt><tt>Drive:  Not Certified
    </tt><tt><br>
    </tt><tt>Drive Temperature :43C (109.40 F)
    </tt><tt><br>
    </tt><tt>PI Eligibility:  No
    </tt><tt><br>
    </tt><tt>Drive is formatted for PI information:  No
    </tt><tt><br>
    </tt><tt>PI: No PI
    </tt><tt><br>
    </tt><tt>Drive's NCQ setting : N/A
    </tt><tt><br>
    </tt><tt>Port-0 :
    </tt><tt><br>
    </tt><tt>Port status: Active
    </tt><tt><br>
    </tt><tt>Port's Linkspeed: 6.0Gb/s
    </tt><tt><br>
    </tt><tt>Drive has flagged a S.M.A.R.T alert : No
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[ 09:26:17 ] - root@gluster-ger-ber-12  /home/admin
      $megacli -PDList -aALL | grep "Inquiry Data"
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1334PBHPAD0PHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1334PBHP5X2PHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1334PBHPAW2PHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1334PBHP5HJPHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1334PBHP59ZPHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1334PBHP831PHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1334PBHP5Z4PHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>Inquiry Data:       PK1338P4GNXEEBHGST
      HUS724040ALE640                    MJAOA580
    </tt><tt><br>
    </tt><tt>[ 09:26:29 ] - root@gluster-ger-ber-12  /home/admin $
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[ 09:36:05 ] - root@gluster-ger-ber-12  /home/admin $fuser
      -c /gluster-export
    </tt><tt><br>
    </tt><tt>Cannot stat /gluster-export: Input/output error
    </tt><tt><br>
    </tt><tt>[ 09:36:16 ] - root@gluster-ger-ber-12  /home/admin $umount
      /gluster-export
    </tt><tt><br>
    </tt><tt>[ 09:36:25 ] - root@gluster-ger-ber-12  /home/admin $mount
    </tt><tt><i class="moz-txt-slash"><span class="moz-txt-tag">/</span>gluster-export<span
          class="moz-txt-tag">/</span></i></tt><tt>
    </tt><tt><br>
    </tt><tt>[ 09:36:29 ] - root@gluster-ger-ber-12  /home/admin
      $xfs_info </tt><tt><i class="moz-txt-slash"><span
          class="moz-txt-tag">/</span>gluster-export<span
          class="moz-txt-tag">/</span></i></tt><tt>
    </tt><tt><br>
    </tt><tt>meta-data=/dev/sdc1              isize=256 agcount=32,
      agsize=152596472 blks
    </tt><tt><br>
    </tt><tt>         =                       sectsz=512   attr=2
    </tt><tt><br>
    </tt><tt>data     =                       bsize=4096
      blocks=4883087099, imaxpct=5
    </tt><tt><br>
    </tt><tt>         =                       sunit=0      swidth=0 blks
    </tt><tt><br>
    </tt><tt>naming   =version 2              bsize=4096 ascii-ci=0
    </tt><tt><br>
    </tt><tt>log      =internal               bsize=4096 blocks=521728,
      version=2
    </tt><tt><br>
    </tt><tt>         =                       sectsz=512   sunit=0 blks,
      lazy-count=1
    </tt><tt><br>
    </tt><tt>realtime =none                   extsz=4096   blocks=0,
      rtextents=0
    </tt><tt><br>
    </tt><tt>[ 09:36:36 ] - root@gluster-ger-ber-12  /home/admin $
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt><br>
    </tt><tt>[ 09:28:20 ] - root@gluster-ger-ber-12  /home/admin $echo w
      &gt; /proc/sysrq-trigger
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>dmesg :
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] SysRq : Show Blocked State
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]   task PC stack   pid father
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] Sched Debug Version: v0.11,
      3.13.0-67-generic #110-Ubuntu
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] ktime : 136344498.523371
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] sched_clk : 136212618.303317
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu_clk : 136212618.303397
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] jiffies : 4328978420
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] sched_clock_stable : 1
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] sysctl_sched
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .sysctl_sched_latency                    : 24.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .sysctl_sched_min_granularity            : 3.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .sysctl_sched_wakeup_granularity         : 4.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .sysctl_sched_child_runs_first           : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .sysctl_sched_features                   : 77435
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .sysctl_sched_tunable_scaling            : 1 (logaritmic)
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu#0, 3300.307 MHz
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_switches                   :
      147348638
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_load_updates               :
      11437772
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            :
      -28382
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .next_balance                  :
      4328.978407
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .curr-&gt;pid                     : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .clock                         :
      136212614.957368
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .yld_count                     :
      3
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_count                   :
      236776897
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_goidle                  :
      66160497
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .avg_idle                      :
      1000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_count                    :
      72435010
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_local                    :
      11357966
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[0]:/autogroup-1402
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      270.992157
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      269.013532
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -26475674.528669
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      15
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;exec_start                : 136212614.939755
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;vruntime                  : 26475931.652185
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;sum_exec_runtime          : 270.992157
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_start     : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.exec_max       : 1.112867
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.slice_max      : 0.021923
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_max       : 0.071390
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_sum       : 2.037234
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_count     : 8501
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;load.weight               : 2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_sum      : 105
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_period   : 47280
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.load_avg_contrib      : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.decay_count           : 129902473
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[0]:/
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      3846527.725695
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      26475943.542201
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      98
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      3
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 12
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_sum         : 143
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_period      : 47611
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] rt_rq[0]:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_nr_running                 :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_throttled                  :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_time                       :
      0.014935
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_runtime                    :
      950.000000
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] runnable tasks:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             task   PID tree-key 
      switches  prio     exec-runtime         sum-exec sum-sleep
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
----------------------------------------------------------------------------------------------------------</tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         kthreadd     2
      26474982.577430       631   120  26474982.577430 29.113277
      136195518.581352 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      ksoftirqd/0     3
      26474983.604407    192950   120  26474983.604407 3698.783802
      136191450.813456 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/0:0H     5
      3300.494478         6   100      3300.494478         0.071207
      6008.439787 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        rcu_sched     7
      26475932.336758  14122966   120  26475932.336758 283940.908724
      135759709.558946 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]           rcu_bh    16
      70.281892         2   120        70.281892 0.000707 0.000587 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuob/0    17
      72.282352         2   120        72.282352 0.000801 0.000662 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuob/1    18
      74.282814         2   120        74.282814 0.000776 0.000634 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuob/2    19
      76.283269         2   120        76.283269 0.000848 0.000602 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuob/3    20
      78.283650         2   120        78.283650 0.000775 0.000598 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuob/4    21
      80.284102         2   120        80.284102 0.000854 0.000663 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuob/5    22
      82.284536         2   120        82.284536 0.000809 0.000580 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuob/6    23
      84.285021         2   120        84.285021 0.000888 0.000637 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuob/7    24
      86.285485         2   120        86.285485 0.000872 0.000639 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      migration/0    25
      0.000000     27167     0         0.000000       797.682052
      0.000750 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       watchdog/0    26
      -5.953704     34090     0        -5.953704       751.540781
      13.772317 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            khubd    71
      3244.446742       104   120      3244.446742        61.411241
      2754.046153 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          kswapd0    77
      26205841.066711     30811   120  26205841.066711 76229.909278
      134072768.865772 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       khugepaged    79
      26475677.591690     13973   139  26475677.591690 2084.204182
      136203770.797993 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/0:1H   379
      23223356.272823     57528   100  23223356.272823 1125.377178
      107458262.671565 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    systemd-udevd   441
      111.205459      1936   120       111.205459       347.271266
      136018099.023055 0 /autogroup-90
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]           kipmi0   511
      26475943.542201    464248   139  26475943.542201 822445.570486
      135379234.199855 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      in:imuxsock   557
      309.267197      5651   120       309.267197       333.499493
      136004317.631646 0 /autogroup-112
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            acpid  1095
      0.855489         5   120         0.855489         0.524418
      17.527620 0 /autogroup-224
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/0:0 16096
      26475931.584455    957170   120  26475931.584455 20895.761903
      53442927.054945 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    kworker/u17:1 25496
      26122951.277120     10489   100  26122951.277120 186.192347
      46014951.975247 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         glusterd 10248
      20892.577731     43829   120     20892.577731      2767.803349
      43744498.428498 0 /autogroup-1375
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         glusterd 10249
      13989.146111        10   120     13989.146111         0.277888
      34507872.284027 0 /autogroup-1375
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10350
      6719.390861     43778   120      6719.390861     10489.910435
      43733358.086887 0 /autogroup-1382
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/0:1 17609
      22321475.749296         2   120  22321475.749296 0.050026        
      0.043033 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             sshd 13731
      269.013532     11291   120       269.013532       301.287578
      2062023.641370 0 /autogroup-1402
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             bash 13732
      0.623405        63   120         0.623405        61.403465
      5212.815794 0 /autogroup-1403
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu#1, 3300.307 MHz
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_switches                   :
      140802404
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_load_updates               :
      11046184
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            :
      -37147
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .next_balance                  :
      4328.978404
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .curr-&gt;pid                     : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .clock                         :
      136212543.982417
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .yld_count                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_count                   :
      223822273
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_goidle                  :
      63146083
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .avg_idle                      :
      1000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_count                    :
      76646395
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_local                    :
      10364838
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[1]:/autogroup-161
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      41.418053
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      40.369477
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -26475903.172724
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;exec_start                : 136212390.652070
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;vruntime                  : 25423116.862434
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;sum_exec_runtime          : 41.418053
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_start     : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.exec_max       : 0.396702
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.slice_max      : 0.073704
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_max       : 0.182166
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_sum       : 1.361087
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_count     : 850
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;load.weight               : 2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_sum      : 2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_period   : 47625
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.load_avg_contrib      : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.decay_count           : 129902259
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[1]:/
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      3806336.668940
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      25423128.794116
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -1052814.748085
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      92
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      1
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 12
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_sum         : 62
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_period      : 46935
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] rt_rq[1]:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_nr_running                 :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_throttled                  :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_time                       :
      0.027093
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_runtime                    :
      950.000000
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] runnable tasks:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             task   PID tree-key 
      switches  prio     exec-runtime         sum-exec sum-sleep
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
----------------------------------------------------------------------------------------------------------</tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuos/0     8
      25423118.245296   2404401   120  25423118.245296 101131.182197
      136110439.328825 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuos/2    10
      25423116.874811   2422938   120  25423116.874811 101151.958178
      136110314.686513 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       watchdog/1    27
      -2.951694     34090     0        -2.951694 757.129747 0.000729 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      migration/1    28
      0.000000     24068     0         0.000000       469.233325
      0.000679 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      ksoftirqd/1    29
      25421716.842085    181729   120  25421716.842085 3477.138497
      136182012.889144 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/1:0H    31
      4613.719467         7   100      4613.719467         0.037461
      10189.369938 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       khungtaskd    76
      25421933.541670      1138   120  25421933.541670 84.284528
      136187978.841882 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        scsi_eh_5   186
      3365.916452        14   120      3365.916452 1.760553 397.345031 0
      /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      jbd2/sda1-8   209
      25422648.851152    100906   120  25422648.851152 6159.882209
      136198241.371272 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          xfslogd   372
      3448.379981         2   100      3448.379981 0.004590 0.002710 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]  upstart-file-br   436
      12.500126      3968   120        12.500126        94.531374
      136015292.474727 0 /autogroup-86
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]   systemd-logind   669
      44.037315       300   120        44.037315       248.585829
      134260598.704251 0 /autogroup-149
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rpcbind   722
      40.369477      4768   120        40.369477       234.292584
      136204838.488381 0 /autogroup-161
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            getty  1044
      0.070244        65   120         0.070244         1.286122
      38.280862 0 /autogroup-195
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             cron  1104
      52.826625      2331   120        52.826625       151.901350
      136158801.398533 0 /autogroup-220
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/1:1H  2618
      22530547.872807     65641   100  22530547.872807 1320.284728
      107453816.441771 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        rpc.statd 27870
      0.450345        10   120         0.450345         2.718404
      1.565635 0 /autogroup-997
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         glusterd 10250
      17662.746416       749   120     17662.746416       178.191852
      43741936.432719 0 /autogroup-1375
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10345
      2653.426150        95   120      2653.426150         2.679007
      43685955.773205 0 /autogroup-1380
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/1:0 11396
      25423117.034513    515020   120  25423117.034513 12511.346039
      42714718.828356 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/1:1 23002
      22479768.454215         2   120  22479768.454215 0.055400        
      0.015166 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    kworker/u16:1 10511
      25422395.165519     12740   120  25422395.165519 833.068573
      5769174.355062 0 /
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu#2, 3300.307 MHz
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_switches                   :
      140954660
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_load_updates               :
      10911251
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            :
      -32246
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .next_balance                  :
      4328.978418
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .curr-&gt;pid                     : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .clock                         :
      136212595.926891
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .yld_count                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_count                   :
      224643151
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_goidle                  :
      63182858
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .avg_idle                      :
      1000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_count                    :
      75899548
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_local                    :
      10349699
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[2]:/
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      3804562.837849
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      25555626.301013
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -920317.241188
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      97
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      1
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 12
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_sum         : 54
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_period      : 46771
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] rt_rq[2]:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_nr_running                 :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_throttled                  :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_time                       :
      0.021579
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_runtime                    :
      950.000000
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] runnable tasks:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             task   PID tree-key 
      switches  prio     exec-runtime         sum-exec sum-sleep
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
----------------------------------------------------------------------------------------------------------</tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             init     1
      425.097653     14333   120       425.097653      3392.591086
      136201613.341830 0 /autogroup-2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuos/4    12
      25555614.399222   2395326   120  25555614.399222 111227.287682
      136100481.939047 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       watchdog/2    32
      -5.980436     34089     0        -5.980436 701.341717 0.001035 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      migration/2    33
      0.000000     24044     0         0.000000       454.356563
      0.000708 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      ksoftirqd/2    34
      25552774.096697    168290   120  25552774.096697 3062.808230
      136155517.391477 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/2:0H    36
      2206.597279         7   100      2206.597279         0.043895
      10213.196941 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        scsi_eh_1   182
      1345.845801        14   120      1345.845801 2.310343 416.263941 0
      /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        scsi_eh_2   183
      1347.737725         7   120      1347.737725 4.297015 455.843697 0
      /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        scsi_eh_6   187
      1344.576241        14   120      1344.576241 1.167670 400.858524 0
      /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         xfsalloc   370
      1491.536262         2   100      1491.536262 0.005613 0.002823 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    xfs_mru_cache   371
      1503.541080         2   100      1503.541080 0.005434 0.020169 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      dbus-daemon   562
      35.997923      5207   120        35.997923       321.379628
      136014456.290568 0 /autogroup-114
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            getty  1048
      0.798035        66   120         0.798035         1.038112
      22.919171 0 /autogroup-199
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        rpc.statd  2610
      0.113453         7   120         0.113453         2.541659
      1.078356 0 /autogroup-287
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/2:1H  2627
      22621782.659664     62070   100  22621782.659664 1335.191062
      107314569.211629 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         glusterd 10251
      15677.807241       772   120     15677.807241       163.402191
      43741947.895943 0 /autogroup-1375
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10341
      3025.652327     28750   120      3025.652327      4494.806148
      43740371.067623 0 /autogroup-1380
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10353
      7848.836436        77   120      7848.836436         3.043855
      43432185.230605 0 /autogroup-1382
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/2:1 10915
      25555614.472845    539514   120  25555614.472845 12494.506682
      43240143.702078 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/2:0 20081
      22180323.415652         3   120  22180323.415652 0.062509        
      7.314314 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             sudo 13768
      15.649688        15   120        15.649688        23.750716
      2492.693892 0 /autogroup-1403
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu#3, 3300.307 MHz
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_switches                   :
      141335883
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_load_updates               :
      10970238
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            :
      -17617
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .next_balance                  :
      4328.978392
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .curr-&gt;pid                     : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .clock                         :
      136212595.942930
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .yld_count                     :
      3
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_count                   :
      228167931
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_goidle                  :
      63329458
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .avg_idle                      :
      1000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_count                    :
      75973716
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_local                    :
      10639601
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[3]:/autogroup-1375
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      18586.219722
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      18069.862107
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -26457873.680094
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;exec_start                : 136212425.591062
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;vruntime                  : 26094251.418506
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;sum_exec_runtime          : 18586.383623
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_start     : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.exec_max       : 3.983940
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.slice_max      : 3.673064
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_max       : 0.114982
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_sum       : 21.381169
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_count     : 89939
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;load.weight               : 2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_sum      : 11
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_period   : 47166
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.load_avg_contrib      : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.decay_count           : 129902292
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[3]:/
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      3820771.181635
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      26094262.988915
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -381680.553286
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      71
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 12
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_sum         : 95
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_period      : 47669
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] rt_rq[3]:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_nr_running                 :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_throttled                  :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_time                       :
      0.022099
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_runtime                    :
      950.000000
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] runnable tasks:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             task   PID tree-key 
      switches  prio     exec-runtime         sum-exec sum-sleep
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
----------------------------------------------------------------------------------------------------------</tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuos/1     9
      26094251.119927   2397714   120  26094251.119927 100698.380729
      136110789.493453 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuos/3    11
      26094251.350073   2404544   120  26094251.350073 100861.304213
      136110827.001807 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuos/6    14
      26094026.859325   2330692   120  26094026.859325 108121.695870
      136100747.700861 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       watchdog/3    37
      -5.979836     34090     0        -5.979836 701.406503 0.000996 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      migration/3    38
      0.000000     25006     0         0.000000       614.308545
      0.000704 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      ksoftirqd/3    39
      26094030.002911    217683   120  26094030.002911 4097.101172
      136204388.184594 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/3:0H    41
      4923.752898         7   100      4923.752898         0.038445
      10357.144096 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    fsnotify_mark    80
      17395580.736262        37   120  17395580.736262 0.282814
      92409161.796469 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]  upstart-udev-br   397
      30.716080      6127   120        30.716080       230.662890
      136015275.419172 0 /autogroup-61
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    rs:main Q:Reg   559
      321.032885      8007   120       321.032885       923.248259
      136186466.324339 0 /autogroup-112
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             nrpe  1112
      11371.926125     12125   120     11371.926125      2129.552313
      136190562.066576 0 /autogroup-221
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            gdbus  2081
      0.744015         8   120         0.744015         0.330701
      0.277507 0 /autogroup-266
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/3:1H  2651
      23006607.509737     80448   100  23006607.509737 1510.460473
      107363258.764220 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        rpc.statd 13685
      0.096523        10   120         0.096523         3.059160
      47.016680 0 /autogroup-1290
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     xfsaild/sdc1 10017
      26094253.544465    828662   120  26094253.544465 34547.387217
      43827248.923976 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         glusterd 10247
      18069.862107    677281   120     18069.862107    142247.429572
      43604482.413832 0 /autogroup-1375
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10342
      3936.822141     43845   120      3936.822141     10474.508007
      43734386.395618 0 /autogroup-1380
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        rpc.statd 10411
      0.147194         8   120         0.147194         1.668909
      41.767193 0 /autogroup-1386
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/3:2 20448
      25855231.751517         4   120  25855231.751517 0.089043
      30095580.227654 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    kworker/u16:2 13596
      26094251.167465      1422   120  26094251.167465 92.576014
      2148231.314437 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/3:0 13638
      26094251.086440     24951   120  26094251.086440 579.316363
      2063718.158999 0 /
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu#4, 3300.307 MHz
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_switches                   :
      105568159
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_load_updates               :
      6630800
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            :
      51868
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .next_balance                  :
      4328.978327
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .curr-&gt;pid                     : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .clock                         :
      136212240.234656
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .yld_count                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_count                   :
      106391214
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_goidle                  :
      45071812
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .avg_idle                      :
      1000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_count                    :
      54601820
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_local                    :
      7541787
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[4]:/autogroup-1382
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      1228.651419
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      1235.325126
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -26474708.217075
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      1
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      1
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      4
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      1
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 4
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;exec_start                : 136212197.612794
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;vruntime                  : 11078932.597413
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;sum_exec_runtime          : 1228.847115
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_start     : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.exec_max       : 0.335102
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.slice_max      : 0.158210
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_max       : 0.107315
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_sum       : 0.959447
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_count     : 25830
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;load.weight               : 2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_sum      : 191
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_period   : 47148
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.load_avg_contrib      : 1
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.decay_count           : 129902075
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[4]:/
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      2996672.618810
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      11078943.311719
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -15397000.230482
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      63
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      4
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 12
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_sum         : 226
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_period      : 47270
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] rt_rq[4]:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_nr_running                 :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_throttled                  :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_time                       :
      0.022828
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_runtime                    :
      950.000000
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] runnable tasks:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             task   PID tree-key 
      switches  prio     exec-runtime         sum-exec sum-sleep
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
----------------------------------------------------------------------------------------------------------</tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       watchdog/4    42
      -8.976676     34089     0        -8.976676 703.393709 0.001054 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      migration/4    43
      0.000000    522672     0         0.000000      5586.023859
      0.000878 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      ksoftirqd/4    44
      11078931.375157    123872   120  11078931.375157 2699.457434
      136206908.221620 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/4:0H    46
      5183.354019         7   100      5183.354019         0.024152
      11346.424817 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]               md    72
      22.959158         2   100        22.959158 0.003847 0.001519 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       devfreq_wq    73
      34.962134         2   100        34.962134 0.003250 0.001585 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             ksmd    78
      95.024195         2   125        95.024195 0.009110 0.003632 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]  ecryptfs-kthrea    81
      131.098695         2   120       131.098695 0.009268 0.003717 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]           crypto    82
      143.106878         2   100       143.106878 0.008849 0.003485 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         kthrotld    94
      287.247167         2   100       287.247167 0.008570 0.003546 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          deferwq   121
      1852.932827         4   100      1852.932827 0.103774 345.509759 0
      /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        scsi_eh_3   184
      2330.673890        14   120      2330.673890 1.123806 406.763399 0
      /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]  upstart-socket-   685
      1.976600      2449   120         1.976600        66.649380
      136014443.116090 0 /autogroup-158
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         whoopsie  1655
      2.701519       102   120         2.701519        11.748913
      129474990.452082 0 /autogroup-266
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            getty  2435
      0.212606         2   120         0.212606         1.152749
      0.000000 0 /autogroup-272
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/4:1H  2724
      11034545.666401    514255   100  11034545.666401 17271.001339
      107436722.892382 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          kauditd  2997
      37493.612764         2   120     37493.612764 0.033370 0.003881 0
      /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/4:2  1093
      11078932.083317    281743   120  11078932.083317 8749.842765
      50514657.114231 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10413
      23.728867         4   120        23.728867 0.291486 0.175916 0
      /autogroup-1380
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10349
      1235.325126    296202   120      1235.325126     11713.948549
      43732121.550028 0 /autogroup-1382
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10351
      10.962439         1   120        10.962439 0.011024 0.000000 0
      /autogroup-1382
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10352
      1200.277837       107   120      1200.277837         2.656723
      43432185.809267 0 /autogroup-1382
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        rpc.statd 10406
      0.263949        11   120         0.263949         2.779534
      83.848029 0 /autogroup-1384
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/4:0 10440
      9518517.060530        30   120   9518517.060530 0.171060
      229429.421687 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    kworker/u17:2 11300
      11078931.312338     21530   100  11078931.312338 483.672855
      42835471.064931 0 /
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu#5, 3300.307 MHz
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      2048
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_switches                   :
      100712644
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_load_updates               :
      6659188
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            :
      15496
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .next_balance                  :
      4328.978415
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .curr-&gt;pid                     : 13770
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .clock                         :
      136212615.014357
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .yld_count                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_count                   :
      101658031
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_goidle                  :
      42813946
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .avg_idle                      :
      1000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_count                    :
      59500415
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_local                    :
      7597598
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[5]:/autogroup-1403
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      230.543841
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      355.983581
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -26475587.558620
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      41
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      1
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      1024
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;exec_start                : 136212615.014357
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;vruntime                  : 10971035.472023
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;sum_exec_runtime          : 230.606599
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_start     : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.exec_max       : 2.722919
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.slice_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_max       : 0.109354
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_sum       : 3.479993
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_count     : 708
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;load.weight               : 1024
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_sum      : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_period   : 47759
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.load_avg_contrib      : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.decay_count           : 0
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[5]:/
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      2993175.284119
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      10971032.566799
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      10971044.027893
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      10971032.566799
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -15504899.514308
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      57
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      2048
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      1
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 12
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_sum         : 92
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_period      : 47167
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] rt_rq[5]:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_nr_running                 :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_throttled                  :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_time                       :
      0.022568
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_runtime                    :
      950.000000
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] runnable tasks:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             task   PID tree-key 
      switches  prio     exec-runtime         sum-exec sum-sleep
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
----------------------------------------------------------------------------------------------------------</tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuos/5    13
      10971033.584866   2331731   120  10971033.584866 108385.921359
      136102683.479070 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       watchdog/5    47
      -8.983447     34089     0        -8.983447 695.200256 0.001978 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      migration/5    48
      0.000000    494869     0         0.000000      5210.341551
      0.000957 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      ksoftirqd/5    49
      10971032.115937    120815   120  10971032.115937 2524.385728
      136205075.696253 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/5:0H    51
      1314.433845         7   100      1314.433845         0.019130
      5759.479654 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/5:1H   376
      10924705.883613    592663   100  10924705.883613 19824.511923
      107439684.007966 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       rpc.idmapd   501
      0.876436         2   120         0.876436         0.221789
      0.000000 0 /autogroup-103
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        in:imklog   558
      63.680250      2456   120        63.680250       152.211282
      136187204.501111 0 /autogroup-112
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            gmain  2004
      11.112020         3   120        11.112020 0.033785 0.003892 0
      /autogroup-266
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/5:2 17595
      10869059.735478    307364   120  10869059.735478 6109.767622
      24108162.604994 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    xfs-data/sdc1 10014
      7962554.998970         2   100   7962554.998970 0.026140 0.017214
      0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     xfs-cil/sdc1 10016
      7962567.017092         2   100   7962567.017092 0.020740 0.023641
      0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/5:1 10568
      10971032.566799    128641   120  10971032.566799 3374.264692
      43640364.953312 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] R           bash 13770
      355.983581       605   120       355.983581       135.107161
      2054353.015184 0 /autogroup-1403
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    kworker/u16:0 15748
      10971027.953261         2   120  10971027.953261 0.064451        
      0.041840 0 /
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu#6, 3300.307 MHz
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_switches                   :
      101330059
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_load_updates               :
      6673995
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            :
      4721
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .next_balance                  :
      4328.978308
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .curr-&gt;pid                     : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .clock                         :
      136212587.968700
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .yld_count                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_count                   :
      102357004
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_goidle                  :
      43064796
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .avg_idle                      :
      1000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_count                    :
      59140573
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_local                    :
      7662707
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[6]:/
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      2942612.370030
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      10885288.919952
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -15590654.622249
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      60
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 12
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_sum         : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_period      : 47343
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] rt_rq[6]:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_nr_running                 :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_throttled                  :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_time                       :
      0.024601
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_runtime                    :
      950.000000
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] runnable tasks:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             task   PID tree-key 
      switches  prio     exec-runtime         sum-exec sum-sleep
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
----------------------------------------------------------------------------------------------------------</tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       watchdog/6    52
      -8.983438     34089     0        -8.983438 746.694608 0.001229 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      migration/6    53
      0.000000    500995     0         0.000000      5374.899305
      0.000708 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      ksoftirqd/6    54
      10885277.093904    227411   120  10885277.093904 3544.811483
      136206245.341403 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/6:0H    56
      3696.921460         7   100      3696.921460         0.028692
      10119.614540 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        kdevtmpfs    63
      3078.228300       209   120      3078.228300         4.819342
      7275.772029 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]  charger_manager   122
      187.040595         2   100       187.040595 0.020085 0.007776 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        scsi_eh_0   181
      1007.316465         2   120      1007.316465 0.438704 0.085498 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        scsi_eh_4   185
      2377.025540        14   120      2377.025540 2.156366 401.832292 0
      /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]  ext4-rsv-conver   210
      2510.395347         2   100      2510.395347 0.067114 0.041280 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      jbd2/sdb1-8   353
      2546.575108         2   120      2546.575108 0.060667 0.035684 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]  ext4-rsv-conver   354
      2558.630045         2   100      2558.630045 0.055979 0.037283 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]           rpciod   459
      2638.698180         2   100      2638.698180 0.005582 0.003100 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]           nfsiod   464
      2650.703138         2   100      2650.703138 0.005447 0.002335 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]  kvm-irqfd-clean   553
      3025.776387         2   100      3025.776387 0.012426 0.003151 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         ttm_swap   554
      3037.781006         2   100      3037.781006 0.005123 0.002415 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         rsyslogd   555
      25.224250        13   120        25.224250         1.580098
      126966223.143891 0 /autogroup-112
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            getty  1053
      0.316572         2   120         0.316572         0.942951
      0.000000 0 /autogroup-204
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            getty  1054
      0.367943         2   120         0.367943         0.851462
      0.000000 0 /autogroup-205
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            getty  1056
      0.340820         2   120         0.340820         0.915774
      0.000000 0 /autogroup-207
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             sshd  1078
      327.941777       405   120       327.941777        82.683192
      134259926.849503 0 /autogroup-217
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/6:1H  2617
      10839732.580783    585771   100  10839732.580783 20183.712003
      107397527.261184 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/6:0 16800
      10803459.202410    346761   120  10803459.202410 7185.014710
      26461601.428861 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]    xfs-conv/sdc1 10015
      7888235.754725         2   100   7888235.754725 0.024640 0.007303
      0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]         glusterd 10331
      390.262786         4   120       390.262786 0.031971 0.013309 0
      /autogroup-1375
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/6:1 11097
      10885277.920224    115607   120  10885277.920224 2798.397167
      43052617.893022 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]               su 13769
      101.611241        10   120       101.611241 6.988278 19.152158 0
      /autogroup-1403
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cpu#7, 3300.307 MHz
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_switches                   :
      102128665
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_load_updates               :
      6775064
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_uninterruptible            :
      43307
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .next_balance                  :
      4328.978170
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .curr-&gt;pid                     : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .clock                         :
      136212276.212312
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[0]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[1]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[2]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[3]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .cpu_load[4]                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .yld_count                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_count                   :
      103210194
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .sched_goidle                  :
      43510224
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .avg_idle                      :
      1000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_count                    :
      59131825
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .ttwu_local                    :
      7981886
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[7]:/autogroup-297
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      53.219583
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      52.171007
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -26475891.371194
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;exec_start                : 136212125.099063
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;vruntime                  : 10974006.018491
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;sum_exec_runtime          : 53.219583
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_start     : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_start    : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.sleep_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.block_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.exec_max       : 0.466913
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.slice_max      : 0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_max       : 0.002284
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_sum       : 0.003771
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;statistics.wait_count     : 936
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;load.weight               : 2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_sum      : 2
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.runnable_avg_period   : 47607
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.load_avg_contrib      : 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .se-&gt;avg.decay_count           : 129902006
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] cfs_rq[7]:/
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .exec_clock                    :
      2988906.266991
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .MIN_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .min_vruntime                  :
      10974017.588045
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .max_vruntime                  :
      0.000001
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread                        :
      0.000000
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .spread0                       :
      -15501925.954156
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_spread_over                :
      64
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .nr_running                    :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .load                          :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .runnable_load_avg             :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .blocked_load_avg              :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_contrib               :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_runnable_contrib           :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .tg_load_avg                   :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;runnable_avg              : 12
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .tg-&gt;cfs_bandwidth.timer_active: 0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttled                     :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .throttle_count                :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_sum         : 3
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
      .avg-&gt;runnable_avg_period      : 47050
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] rt_rq[7]:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_nr_running                 :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_throttled                  :
      0
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_time                       :
      0.023187
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] .rt_runtime                    :
      950.000000
    </tt><tt><br>
    </tt><tt>
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015] runnable tasks:
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             task   PID tree-key 
      switches  prio     exec-runtime         sum-exec sum-sleep
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
----------------------------------------------------------------------------------------------------------</tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          rcuos/7    15
      10974007.991598   2382699   120  10974007.991598 110085.790054
      136101357.927665 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       watchdog/7    57
      -8.982100     34089     0        -8.982100 703.493670 0.001050 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      migration/7    58
      0.000000    526347     0         0.000000      5656.020194
      0.000729 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      ksoftirqd/7    59
      10974005.644505    124819   120  10974005.644505 2720.084599
      136202330.704909 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/7:0H    61
      4090.966692         7   100      4090.966692         0.025188
      10735.407280 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          khelper    62
      10.956262         2   100        10.956262 0.005331 0.002345 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]            netns    64
      35.000828         2   100        35.000828 0.003422 0.001643 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        writeback    65
      47.003840         2   100        47.003840 0.003331 0.001576 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kintegrityd    66
      59.006725         2   100        59.006725 0.003165 0.001356 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]           bioset    67
      71.009702         2   100        71.009702 0.003268 0.001227 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          kblockd    69
      95.014561         2   100        95.014561 0.003339 0.001176 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]          ata_sff    70
      103.018850         2   100       103.018850 0.004569 0.001682 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]              atd  1105
      0.504305        45   120         0.504305         2.077412
      133071116.634185 0 /autogroup-222
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]       irqbalance  1243
      524.318196     13688   120       524.318196     20988.724370
      136178139.182247 0 /autogroup-261
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]     kworker/7:1H  2717
      10921547.648508    651792   100  10921547.648508 22042.496277
      107431179.258583 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             ntpd  2920
      52.171007    137327   120        52.171007      8227.627639
      136171806.565453 0 /autogroup-297
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/7:0  9210
      10974005.838109    218615   120  10974005.838109 4608.186376
      44449710.811257 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10343
      10.997945         3   120        10.997945 0.046530 0.092406 0
      /autogroup-1380
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]        glusterfs 10344
      1077.778544        77   120      1077.778544         2.718423
      43685955.763044 0 /autogroup-1380
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]      kworker/7:2 12998
      10782985.841970         2   120  10782985.841970 0.017175        
      0.004086 0 /
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]             sshd 13632
      2570.449211        67   120      2570.449211        30.289697
      2971.025095 0 /autogroup-1402
    </tt><tt><br>
    </tt><tt>[Fri Dec  4 09:28:34 2015]
    </tt><tt><br>
    </tt><tt>[ 09:30:50 ] - root@gluster-ger-ber-12  /home/admin $
    </tt><br>
    <pre class="moz-signature" cols="72">-- 
Dietmar Putz
3Q Medien GmbH
Wetzlarer Str. 86
D-14482 Potsdam
 
Telefax:  +49 (0)331 / 2797 866 - 1
Telefon:  +49 (0)331 / 2792 866 - 8
Mobile:   +49 171 / 90 160 39
Mail:     <a class="moz-txt-link-abbreviated" href="mailto:putz@3qmedien.net">putz@3qmedien.net</a> </pre>
  </body>
</html>

--------------070807060201020309090804--


--===============5485618804850123213==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5485618804850123213==--
