Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3FJlTMF127012 for <xfs@oss.sgi.com>; Sun, 15 Apr 2012 14:47:30 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ZVuujOoDHD9bEDcQ
	for <xfs@oss.sgi.com>; Sun, 15 Apr 2012 12:47:12 -0700 (PDT)
Message-ID: <4F8B25BE.2060304@hardwarefreak.com>
Date: Sun, 15 Apr 2012 14:47:10 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_check segfault / xfs_repair I/O error
References: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
In-Reply-To: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Drew Wareham <m3rlin@gmail.com>
Cc: xfs@oss.sgi.com

On 4/15/2012 8:15 AM, Drew Wareham wrote:
> Hello Everyone,
> 
> Hopefully this is the correct kind of information to send to this list.
> 
> I have an issue with a large XFS volume (17TB) that mounts, but is not
> readable.  I can view the folder structure on the volume but I can't access
> any of the actual data.  A disk failed in a RAID5 array and while it has
> rebuilt now, it looks like it's caused serious data integrity issues.
> 
> Here is the CentOS release / Kernel version:
>     [root@svr608 ~]# uname -a
>     Linux svr608 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:51 EST 2012
> x86_64 x86_64 x86_64 GNU/Linux
>     [root@svr608 ~]# cat /etc/redhat-release
>     CentOS release 5.8 (Final)
>     [root@svr608 ~]# cat /tmp/yum.list | grep xfs | grep installed
>     kmod-xfs.x86_64                            0.4-2
> installed
>     xfsdump.x86_64                             2.2.46-1.el5.centos
> installed
>     xfsprogs.x86_64                            2.9.4-1.el5.centos
> installed
>     xorg-x11-xfs.x86_64                        1:1.0.2-5.el5_6.1
> installed
> 
> On startup, the OS thinks everything's fine with the drives/volume:
>     SCSI subsystem initialized
>     HP CISS Driver (v 3.6.28-RH2)
>     GSI 20 sharing vector 0x42 and IRQ 20
>     ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 32 (level, low) -> IRQ 66
>     cciss 0000:04:00.0: cciss: Trying to put board into performant mode
>     cciss 0000:04:00.0: Placing controller into performant mode
>      cciss/c0d0: p1 p2 p3 p4 < p5 >
>     usb 5-2: new low speed USB device using uhci_hcd and address 2
>      cciss/c0d1:
>     cciss 0000:04:00.0:       blocks= 35162671280 block_size= 512
>     cciss 0000:04:00.0:       blocks= 35162671280 block_size= 512
>      cciss/c0d2: unknown partition table
>     scsi0 : cciss
>     shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
>     libata version 3.00 loaded.
>     ata_piix 0000:00:1f.2: version 2.12
>     ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 58
>     ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
>     PCI: Setting latency timer of device 0000:00:1f.2 to 64
>     scsi1 : ata_piix
>     scsi2 : ata_piix
>     ata1: SATA max UDMA/133 bmdma 0xff90 irq 14
>     ata2: SATA max UDMA/133 bmdma 0xff98 irq 15
>     usb 5-2: configuration #1 chosen from 1 choice
>     input: Rextron USB as /class/input/input0
>     input,hidraw0: USB HID v1.10 Keyboard [Rextron USB] on
> usb-0000:00:1d.1-2
>     input: Rextron USB as /class/input/input1
>     input,hidraw0: USB HID v1.00 Mouse [Rextron USB] on usb-0000:00:1d.1-2
>     ata1: SATA link down (SStatus 0 SControl 300)
>     ata2: SATA link down (SStatus 0 SControl 300)
>     ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 58
>     ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
>     PCI: Setting latency timer of device 0000:00:1f.5 to 64
>     scsi3 : ata_piix
>     scsi4 : ata_piix
>     ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 58
>     ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 58
>     ata3: SATA link down (SStatus 0 SControl 300)
>     ata4: SATA link down (SStatus 0 SControl 300)
>     device-mapper: uevent: version 1.0.3
>     device-mapper: ioctl: 4.11.6-ioctl (2011-02-18) initialised:
> dm-devel@redhat.com
>     device-mapper: dm-raid45: initialized v0.2594l
>     kjournald starting.  Commit interval 5 seconds
>     EXT3-fs: mounted filesystem with ordered data mode.
>     SELinux:  Disabled at runtime.
>     SELinux:  Unregistering netfilter hooks
>     type=1404 audit(1334501635.200:2): selinux=0 auid=4294967295
> ses=4294967295
>        ... snip (network devices) ...
>     dell-wmi: No known WMI GUID found
>     md: Autodetecting RAID arrays.
>     md: autorun ...
>     md: ... autorun DONE.
>     device-mapper: multipath: version 1.0.6 loaded
>     loop: loaded (max 8 devices)
>     EXT3 FS on cciss/c0d0p5, internal journal
>     kjournald starting.  Commit interval 5 seconds
>     EXT3 FS on cciss/c0d0p3, internal journal
>     EXT3-fs: mounted filesystem with ordered data mode.
>     kjournald starting.  Commit interval 5 seconds
>     EXT3 FS on cciss/c0d0p1, internal journal
>     EXT3-fs: mounted filesystem with ordered data mode.
>     SGI XFS with ACLs, security attributes, large block/inode numbers, no
> debug enabled
>     SGI XFS Quota Management subsystem
>     XFS mounting filesystem cciss/c0d2
>     Ending clean XFS mount for filesystem: cciss/c0d2
>     Adding 4192956k swap on /dev/cciss/c0d0p2.  Priority:-1 extents:1
> across:4192956k
> 
> But even though the volume mounts, when trying to access data it just gives
> a "Structure needs cleaning" error.
> 
> Running xfs_check and xfs_repair yield the following:
>     [root@svr608 ~]# xfs_check /dev/cciss/c0d2
>     bad agf magic # 0x58418706 in ag 0
>     bad agf version # 0x30002 in ag 0
>     /usr/sbin/xfs_check: line 28:  5259 Segmentation fault
> xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1
>     [root@svr608 ~]# xfs_repair -n /dev/cciss/c0d2
>     Phase 1 - find and verify superblock...
>     superblock read failed, offset 0, size 524288, ag 0, rval -1
> 
>     fatal error -- Input/output error
> 
> And they leave the following in dmesg:
>     xfs_db[5259]: segfault at 000000000555a134 rip 00000000004070c3 rsp
> 00007fff986bae50 error 4
>     cciss 0000:04:00.0: cciss: c ffff810037e00000 has CHECK CONDITION sense
> key = 0x3
> 
> And finally if I try to ls or stat a directory, I get the following call
> trace:
>     Call Trace:
>      [<ffffffff8835d8b8>] :xfs:xfs_da_do_buf+0x4ee/0x59c
>      [<ffffffff8835d9b9>] :xfs:xfs_da_read_buf+0x16/0x1b
>      [<ffffffff8835d9b9>] :xfs:xfs_da_read_buf+0x16/0x1b
>      [<ffffffff88362414>] :xfs:xfs_dir2_leaf_lookup_int+0x57/0x24f
>      [<ffffffff88362414>] :xfs:xfs_dir2_leaf_lookup_int+0x57/0x24f
>      [<ffffffff8004ad3e>] try_to_del_timer_sync+0x7f/0x88
>      [<ffffffff883628c5>] :xfs:xfs_dir2_leaf_lookup+0x1f/0xb6
>      [<ffffffff8835f50c>] :xfs:xfs_dir2_isleaf+0x19/0x4a
>      [<ffffffff8003f8b2>] memcpy_toiovec+0x36/0x66
>      [<ffffffff8835fc1a>] :xfs:xfs_dir_lookup+0xf9/0x140
>      [<ffffffff88384309>] :xfs:xfs_lookup+0x49/0xa8
>      [<ffffffff8805c27c>] :ext3:ext3_get_acl+0x63/0x310
>      [<ffffffff8838f772>] :xfs:xfs_vn_lookup+0x3d/0x7b
>      [<ffffffff8000d0b0>] do_lookup+0x126/0x227
>      [<ffffffff80009c59>] __link_path_walk+0x3aa/0xf39
>      [<ffffffff8000eb37>] link_path_walk+0x45/0xb8
>      [<ffffffff8000ce0a>] do_path_lookup+0x294/0x310
>      [<ffffffff80012969>] getname+0x15b/0x1c2
>      [<ffffffff80023a11>] __user_walk_fd+0x37/0x4c
>      [<ffffffff8002898c>] vfs_stat_fd+0x1b/0x4a
>      [<ffffffff80067235>] do_page_fault+0x4cc/0x842
>      [<ffffffff8023074b>] sys_connect+0x7e/0xae
>      [<ffffffff80023741>] sys_newstat+0x19/0x31
>      [<ffffffff8005d229>] tracesys+0x71/0xe0
>      [<ffffffff8005d28d>] tracesys+0xd5/0xe0
> 
>     00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ................
>     Filesystem cciss/c0d2: XFS internal error xfs_da_do_buf(2) at line 2112
> of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8835d9b9
> 
> hpacucli says the array is fine, 

What does an array verify/consistency check say?

> but it looks like it's corrupted to me.
> This is probably a lost cause, but if anyone has any ideas I'd love to hear
> them.

May be.  But I'd exhaust all recovery possibilities before throwing in
the towel.  You need to identify the root cause of this failure before
wiping/recreating this RAID5 array and restoring from tape/D2D.  You say
a single drive in a RAID5 array failed, then all hell broke loose after
reconstructing the array with a spare drive.  Were any errors logged
during the rebuild, either in the controller's log or any Linux system
logs?  If not, and the reconstruction corrupted the array, I'd say you
may have a controller firmware bug on your hands.  Thus I'd update the
firmware to the latest before proceeding to recreate the array and restore.

Interestingly, this exact scenario was brought to my attention on
another list just yesterday relating to a firmware bug in the IBM
DS3000/4000/5000 SAN controllers.  Also after a RAID5 reconstruction.

May 16, 2008 - version 07.15.07.00

   - Fix 432525 - CR139339  Data corruption found on drive after
     reconstruct from GHSP (Global Hot Spare)

Once systems go into production a very large percentage of operators
never upgrade the firmware on system components...until they have a
problem.  Even if the problem isn't firmware related in this case, it'd
be a good idea to update all your firmware anyway, to prevent other
possible problems.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
