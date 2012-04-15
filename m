Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3FDFV4r091450 for <xfs@oss.sgi.com>; Sun, 15 Apr 2012 08:15:31 -0500
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	KzpBevFwykf14glX (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 06:15:30 -0700 (PDT)
Received: by iagk10 with SMTP id k10so7135388iag.26
	for <xfs@oss.sgi.com>; Sun, 15 Apr 2012 06:15:29 -0700 (PDT)
MIME-Version: 1.0
From: Drew Wareham <m3rlin@gmail.com>
Date: Sun, 15 Apr 2012 23:15:09 +1000
Message-ID: <CALcU-6goaENFYsvUxz3yQD=w6ipmHuo-GxoRHT1GaQ6+yW5-pA@mail.gmail.com>
Subject: xfs_check segfault / xfs_repair I/O error
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1600121233694008946=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1600121233694008946==
Content-Type: multipart/alternative; boundary=14dae934097bed0ec304bdb77f46

--14dae934097bed0ec304bdb77f46
Content-Type: text/plain; charset=UTF-8

Hello Everyone,

Hopefully this is the correct kind of information to send to this list.

I have an issue with a large XFS volume (17TB) that mounts, but is not
readable.  I can view the folder structure on the volume but I can't access
any of the actual data.  A disk failed in a RAID5 array and while it has
rebuilt now, it looks like it's caused serious data integrity issues.

Here is the CentOS release / Kernel version:
    [root@svr608 ~]# uname -a
    Linux svr608 2.6.18-308.1.1.el5 #1 SMP Wed Mar 7 04:16:51 EST 2012
x86_64 x86_64 x86_64 GNU/Linux
    [root@svr608 ~]# cat /etc/redhat-release
    CentOS release 5.8 (Final)
    [root@svr608 ~]# cat /tmp/yum.list | grep xfs | grep installed
    kmod-xfs.x86_64                            0.4-2
installed
    xfsdump.x86_64                             2.2.46-1.el5.centos
installed
    xfsprogs.x86_64                            2.9.4-1.el5.centos
installed
    xorg-x11-xfs.x86_64                        1:1.0.2-5.el5_6.1
installed

On startup, the OS thinks everything's fine with the drives/volume:
    SCSI subsystem initialized
    HP CISS Driver (v 3.6.28-RH2)
    GSI 20 sharing vector 0x42 and IRQ 20
    ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 32 (level, low) -> IRQ 66
    cciss 0000:04:00.0: cciss: Trying to put board into performant mode
    cciss 0000:04:00.0: Placing controller into performant mode
     cciss/c0d0: p1 p2 p3 p4 < p5 >
    usb 5-2: new low speed USB device using uhci_hcd and address 2
     cciss/c0d1:
    cciss 0000:04:00.0:       blocks= 35162671280 block_size= 512
    cciss 0000:04:00.0:       blocks= 35162671280 block_size= 512
     cciss/c0d2: unknown partition table
    scsi0 : cciss
    shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
    libata version 3.00 loaded.
    ata_piix 0000:00:1f.2: version 2.12
    ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 58
    ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
    PCI: Setting latency timer of device 0000:00:1f.2 to 64
    scsi1 : ata_piix
    scsi2 : ata_piix
    ata1: SATA max UDMA/133 bmdma 0xff90 irq 14
    ata2: SATA max UDMA/133 bmdma 0xff98 irq 15
    usb 5-2: configuration #1 chosen from 1 choice
    input: Rextron USB as /class/input/input0
    input,hidraw0: USB HID v1.10 Keyboard [Rextron USB] on
usb-0000:00:1d.1-2
    input: Rextron USB as /class/input/input1
    input,hidraw0: USB HID v1.00 Mouse [Rextron USB] on usb-0000:00:1d.1-2
    ata1: SATA link down (SStatus 0 SControl 300)
    ata2: SATA link down (SStatus 0 SControl 300)
    ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 58
    ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
    PCI: Setting latency timer of device 0000:00:1f.5 to 64
    scsi3 : ata_piix
    scsi4 : ata_piix
    ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0xc400 irq 58
    ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xc480 bmdma 0xc408 irq 58
    ata3: SATA link down (SStatus 0 SControl 300)
    ata4: SATA link down (SStatus 0 SControl 300)
    device-mapper: uevent: version 1.0.3
    device-mapper: ioctl: 4.11.6-ioctl (2011-02-18) initialised:
dm-devel@redhat.com
    device-mapper: dm-raid45: initialized v0.2594l
    kjournald starting.  Commit interval 5 seconds
    EXT3-fs: mounted filesystem with ordered data mode.
    SELinux:  Disabled at runtime.
    SELinux:  Unregistering netfilter hooks
    type=1404 audit(1334501635.200:2): selinux=0 auid=4294967295
ses=4294967295
       ... snip (network devices) ...
    dell-wmi: No known WMI GUID found
    md: Autodetecting RAID arrays.
    md: autorun ...
    md: ... autorun DONE.
    device-mapper: multipath: version 1.0.6 loaded
    loop: loaded (max 8 devices)
    EXT3 FS on cciss/c0d0p5, internal journal
    kjournald starting.  Commit interval 5 seconds
    EXT3 FS on cciss/c0d0p3, internal journal
    EXT3-fs: mounted filesystem with ordered data mode.
    kjournald starting.  Commit interval 5 seconds
    EXT3 FS on cciss/c0d0p1, internal journal
    EXT3-fs: mounted filesystem with ordered data mode.
    SGI XFS with ACLs, security attributes, large block/inode numbers, no
debug enabled
    SGI XFS Quota Management subsystem
    XFS mounting filesystem cciss/c0d2
    Ending clean XFS mount for filesystem: cciss/c0d2
    Adding 4192956k swap on /dev/cciss/c0d0p2.  Priority:-1 extents:1
across:4192956k

But even though the volume mounts, when trying to access data it just gives
a "Structure needs cleaning" error.

Running xfs_check and xfs_repair yield the following:
    [root@svr608 ~]# xfs_check /dev/cciss/c0d2
    bad agf magic # 0x58418706 in ag 0
    bad agf version # 0x30002 in ag 0
    /usr/sbin/xfs_check: line 28:  5259 Segmentation fault
xfs_db$DBOPTS -i -p xfs_check -c "check$OPTS" $1
    [root@svr608 ~]# xfs_repair -n /dev/cciss/c0d2
    Phase 1 - find and verify superblock...
    superblock read failed, offset 0, size 524288, ag 0, rval -1

    fatal error -- Input/output error

And they leave the following in dmesg:
    xfs_db[5259]: segfault at 000000000555a134 rip 00000000004070c3 rsp
00007fff986bae50 error 4
    cciss 0000:04:00.0: cciss: c ffff810037e00000 has CHECK CONDITION sense
key = 0x3

And finally if I try to ls or stat a directory, I get the following call
trace:
    Call Trace:
     [<ffffffff8835d8b8>] :xfs:xfs_da_do_buf+0x4ee/0x59c
     [<ffffffff8835d9b9>] :xfs:xfs_da_read_buf+0x16/0x1b
     [<ffffffff8835d9b9>] :xfs:xfs_da_read_buf+0x16/0x1b
     [<ffffffff88362414>] :xfs:xfs_dir2_leaf_lookup_int+0x57/0x24f
     [<ffffffff88362414>] :xfs:xfs_dir2_leaf_lookup_int+0x57/0x24f
     [<ffffffff8004ad3e>] try_to_del_timer_sync+0x7f/0x88
     [<ffffffff883628c5>] :xfs:xfs_dir2_leaf_lookup+0x1f/0xb6
     [<ffffffff8835f50c>] :xfs:xfs_dir2_isleaf+0x19/0x4a
     [<ffffffff8003f8b2>] memcpy_toiovec+0x36/0x66
     [<ffffffff8835fc1a>] :xfs:xfs_dir_lookup+0xf9/0x140
     [<ffffffff88384309>] :xfs:xfs_lookup+0x49/0xa8
     [<ffffffff8805c27c>] :ext3:ext3_get_acl+0x63/0x310
     [<ffffffff8838f772>] :xfs:xfs_vn_lookup+0x3d/0x7b
     [<ffffffff8000d0b0>] do_lookup+0x126/0x227
     [<ffffffff80009c59>] __link_path_walk+0x3aa/0xf39
     [<ffffffff8000eb37>] link_path_walk+0x45/0xb8
     [<ffffffff8000ce0a>] do_path_lookup+0x294/0x310
     [<ffffffff80012969>] getname+0x15b/0x1c2
     [<ffffffff80023a11>] __user_walk_fd+0x37/0x4c
     [<ffffffff8002898c>] vfs_stat_fd+0x1b/0x4a
     [<ffffffff80067235>] do_page_fault+0x4cc/0x842
     [<ffffffff8023074b>] sys_connect+0x7e/0xae
     [<ffffffff80023741>] sys_newstat+0x19/0x31
     [<ffffffff8005d229>] tracesys+0x71/0xe0
     [<ffffffff8005d28d>] tracesys+0xd5/0xe0

    00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
................
    Filesystem cciss/c0d2: XFS internal error xfs_da_do_buf(2) at line 2112
of file fs/xfs/xfs_da_btree.c.  Caller 0xffffffff8835d9b9

hpacucli says the array is fine, but it looks like it's corrupted to me.
This is probably a lost cause, but if anyone has any ideas I'd love to hear
them.


Thanks,

Drew

--14dae934097bed0ec304bdb77f46
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello Everyone,<br><br>Hopefully this is the correct kind of information to=
 send to this list.<br><br>I have an issue with a large XFS volume (17TB) t=
hat mounts, but is not readable.=C2=A0 I can view the folder structure on t=
he volume but I can&#39;t access any of the actual data.=C2=A0 A disk faile=
d in a RAID5 array and while it has rebuilt now, it looks like it&#39;s cau=
sed serious data integrity issues.<br>

<br>Here is the CentOS release / Kernel version:<br>=C2=A0=C2=A0=C2=A0 [roo=
t@svr608 ~]# uname -a<br>=C2=A0=C2=A0=C2=A0 Linux svr608 2.6.18-308.1.1.el5=
 #1 SMP Wed Mar 7 04:16:51 EST 2012 x86_64 x86_64 x86_64 GNU/Linux<br>=C2=
=A0=C2=A0=C2=A0 [root@svr608 ~]# cat /etc/redhat-release<br>

=C2=A0=C2=A0=C2=A0 CentOS release 5.8 (Final)<br>=C2=A0=C2=A0=C2=A0 [root@s=
vr608 ~]# cat /tmp/yum.list | grep xfs | grep installed<br>=C2=A0=C2=A0=C2=
=A0 kmod-xfs.x86_64=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.4-2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 installed<br>=C2=A0=C2=A0=C2=A0 xfsdump.x86_64=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 2.2.46-1.el5.centos=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 installed<br>

=C2=A0=C2=A0=C2=A0 xfsprogs.x86_64=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2.9.4-1.el5.centos=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 installed<br>=C2=A0=C2=A0=
=C2=A0 xorg-x11-xfs.x86_64=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 1:1.0.2-5.el5_6.1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 installed<br><br>On startup, the OS thinks everything&#3=
9;s fine with the drives/volume:<br>

=C2=A0=C2=A0=C2=A0 SCSI subsystem initialized<br>=C2=A0=C2=A0=C2=A0 HP CISS=
 Driver (v 3.6.28-RH2)<br>=C2=A0=C2=A0=C2=A0 GSI 20 sharing vector 0x42 and=
 IRQ 20<br>=C2=A0=C2=A0=C2=A0 ACPI: PCI Interrupt 0000:04:00.0[A] -&gt; GSI=
 32 (level, low) -&gt; IRQ 66<br>=C2=A0=C2=A0=C2=A0 cciss 0000:04:00.0: cci=
ss: Trying to put board into performant mode<br>

=C2=A0=C2=A0=C2=A0 cciss 0000:04:00.0: Placing controller into performant m=
ode<br>=C2=A0=C2=A0=C2=A0 =C2=A0cciss/c0d0: p1 p2 p3 p4 &lt; p5 &gt;<br>=C2=
=A0=C2=A0=C2=A0 usb 5-2: new low speed USB device using uhci_hcd and addres=
s 2<br>=C2=A0=C2=A0=C2=A0 =C2=A0cciss/c0d1:<br>=C2=A0=C2=A0=C2=A0 cciss 000=
0:04:00.0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blocks=3D 35162671280 block_=
size=3D 512<br>

=C2=A0=C2=A0=C2=A0 cciss 0000:04:00.0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
blocks=3D 35162671280 block_size=3D 512<br>=C2=A0=C2=A0=C2=A0 =C2=A0cciss/c=
0d2: unknown partition table<br>=C2=A0=C2=A0=C2=A0 scsi0 : cciss<br>=C2=A0=
=C2=A0=C2=A0 shpchp: Standard Hot Plug PCI Controller Driver version: 0.4<b=
r>=C2=A0=C2=A0=C2=A0 libata version 3.00 loaded.<br>

=C2=A0=C2=A0=C2=A0 ata_piix 0000:00:1f.2: version 2.12<br>=C2=A0=C2=A0=C2=
=A0 ACPI: PCI Interrupt 0000:00:1f.2[B] -&gt; GSI 19 (level, low) -&gt; IRQ=
 58<br>=C2=A0=C2=A0=C2=A0 ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]<br>=C2=
=A0=C2=A0=C2=A0 PCI: Setting latency timer of device 0000:00:1f.2 to 64<br>

=C2=A0=C2=A0=C2=A0 scsi1 : ata_piix<br>=C2=A0=C2=A0=C2=A0 scsi2 : ata_piix<=
br>=C2=A0=C2=A0=C2=A0 ata1: SATA max UDMA/133 bmdma 0xff90 irq 14<br>=C2=A0=
=C2=A0=C2=A0 ata2: SATA max UDMA/133 bmdma 0xff98 irq 15<br>=C2=A0=C2=A0=C2=
=A0 usb 5-2: configuration #1 chosen from 1 choice<br>=C2=A0=C2=A0=C2=A0 in=
put: Rextron USB as /class/input/input0<br>

=C2=A0=C2=A0=C2=A0 input,hidraw0: USB HID v1.10 Keyboard [Rextron USB] on u=
sb-0000:00:1d.1-2<br>=C2=A0=C2=A0=C2=A0 input: Rextron USB as /class/input/=
input1<br>=C2=A0=C2=A0=C2=A0 input,hidraw0: USB HID v1.00 Mouse [Rextron US=
B] on usb-0000:00:1d.1-2<br>=C2=A0=C2=A0=C2=A0 ata1: SATA link down (SStatu=
s 0 SControl 300)<br>

=C2=A0=C2=A0=C2=A0 ata2: SATA link down (SStatus 0 SControl 300)<br>=C2=A0=
=C2=A0=C2=A0 ACPI: PCI Interrupt 0000:00:1f.5[B] -&gt; GSI 19 (level, low) =
-&gt; IRQ 58<br>=C2=A0=C2=A0=C2=A0 ata_piix 0000:00:1f.5: MAP [ P0 -- P1 --=
 ]<br>=C2=A0=C2=A0=C2=A0 PCI: Setting latency timer of device 0000:00:1f.5 =
to 64<br>

=C2=A0=C2=A0=C2=A0 scsi3 : ata_piix<br>=C2=A0=C2=A0=C2=A0 scsi4 : ata_piix<=
br>=C2=A0=C2=A0=C2=A0 ata3: SATA max UDMA/133 cmd 0xcc00 ctl 0xc880 bmdma 0=
xc400 irq 58<br>=C2=A0=C2=A0=C2=A0 ata4: SATA max UDMA/133 cmd 0xc800 ctl 0=
xc480 bmdma 0xc408 irq 58<br>=C2=A0=C2=A0=C2=A0 ata3: SATA link down (SStat=
us 0 SControl 300)<br>

=C2=A0=C2=A0=C2=A0 ata4: SATA link down (SStatus 0 SControl 300)<br>=C2=A0=
=C2=A0=C2=A0 device-mapper: uevent: version 1.0.3<br>=C2=A0=C2=A0=C2=A0 dev=
ice-mapper: ioctl: 4.11.6-ioctl (2011-02-18) initialised: <a href=3D"mailto=
:dm-devel@redhat.com">dm-devel@redhat.com</a><br>

=C2=A0=C2=A0=C2=A0 device-mapper: dm-raid45: initialized v0.2594l<br>=C2=A0=
=C2=A0=C2=A0 kjournald starting.=C2=A0 Commit interval 5 seconds<br>=C2=A0=
=C2=A0=C2=A0 EXT3-fs: mounted filesystem with ordered data mode.<br>=C2=A0=
=C2=A0=C2=A0 SELinux:=C2=A0 Disabled at runtime.<br>=C2=A0=C2=A0=C2=A0 SELi=
nux:=C2=A0 Unregistering netfilter hooks<br>

=C2=A0=C2=A0=C2=A0 type=3D1404 audit(1334501635.200:2): selinux=3D0 auid=3D=
4294967295 ses=3D4294967295<br>=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0 ... snip (ne=
twork devices) ...<br>=C2=A0=C2=A0=C2=A0 dell-wmi: No known WMI GUID found<=
br>=C2=A0=C2=A0=C2=A0 md: Autodetecting RAID arrays.<br>=C2=A0=C2=A0=C2=A0 =
md: autorun ...<br>

=C2=A0=C2=A0=C2=A0 md: ... autorun DONE.<br>=C2=A0=C2=A0=C2=A0 device-mappe=
r: multipath: version 1.0.6 loaded<br>=C2=A0=C2=A0=C2=A0 loop: loaded (max =
8 devices)<br>=C2=A0=C2=A0=C2=A0 EXT3 FS on cciss/c0d0p5, internal journal<=
br>=C2=A0=C2=A0=C2=A0 kjournald starting.=C2=A0 Commit interval 5 seconds<b=
r>

=C2=A0=C2=A0=C2=A0 EXT3 FS on cciss/c0d0p3, internal journal<br>=C2=A0=C2=
=A0=C2=A0 EXT3-fs: mounted filesystem with ordered data mode.<br>=C2=A0=C2=
=A0=C2=A0 kjournald starting.=C2=A0 Commit interval 5 seconds<br>=C2=A0=C2=
=A0=C2=A0 EXT3 FS on cciss/c0d0p1, internal journal<br>=C2=A0=C2=A0=C2=A0 E=
XT3-fs: mounted filesystem with ordered data mode.<br>

=C2=A0=C2=A0=C2=A0 SGI XFS with ACLs, security attributes, large block/inod=
e numbers, no debug enabled<br>=C2=A0=C2=A0=C2=A0 SGI XFS Quota Management =
subsystem<br>=C2=A0=C2=A0=C2=A0 XFS mounting filesystem cciss/c0d2<br>=C2=
=A0=C2=A0=C2=A0 Ending clean XFS mount for filesystem: cciss/c0d2<br>

=C2=A0=C2=A0=C2=A0 Adding 4192956k swap on /dev/cciss/c0d0p2.=C2=A0 Priorit=
y:-1 extents:1 across:4192956k<br><br>But even though the volume mounts, wh=
en trying to access data it just gives a &quot;Structure needs cleaning&quo=
t; error.<br><br>

Running xfs_check and xfs_repair yield the following:<br>=C2=A0=C2=A0=C2=A0=
 [root@svr608 ~]# xfs_check /dev/cciss/c0d2<br>=C2=A0=C2=A0=C2=A0 bad agf m=
agic # 0x58418706 in ag 0<br>=C2=A0=C2=A0=C2=A0 bad agf version # 0x30002 i=
n ag 0<br>=C2=A0=C2=A0=C2=A0 /usr/sbin/xfs_check: line 28:=C2=A0 5259 Segme=
ntation fault=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 xfs_db$DBOPTS -i -p xfs_check -=
c &quot;check$OPTS&quot; $1<br>

=C2=A0=C2=A0=C2=A0 [root@svr608 ~]# xfs_repair -n /dev/cciss/c0d2<br>=C2=A0=
=C2=A0=C2=A0 Phase 1 - find and verify superblock...<br>=C2=A0=C2=A0=C2=A0 =
superblock read failed, offset 0, size 524288, ag 0, rval -1<br><br>=C2=A0=
=C2=A0=C2=A0 fatal error -- Input/output error<br><br>And they leave the fo=
llowing in dmesg:<br>

=C2=A0=C2=A0=C2=A0 xfs_db[5259]: segfault at 000000000555a134 rip 000000000=
04070c3 rsp 00007fff986bae50 error 4<br>=C2=A0=C2=A0=C2=A0 cciss 0000:04:00=
.0: cciss: c ffff810037e00000 has CHECK CONDITION sense key =3D 0x3<br><br>=
And finally if I try to ls or stat a directory, I get the following call tr=
ace:<br>

=C2=A0=C2=A0=C2=A0 Call Trace:<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff883=
5d8b8&gt;] :xfs:xfs_da_do_buf+0x4ee/0x59c<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;=
ffffffff8835d9b9&gt;] :xfs:xfs_da_read_buf+0x16/0x1b<br>=C2=A0=C2=A0=C2=A0 =
=C2=A0[&lt;ffffffff8835d9b9&gt;] :xfs:xfs_da_read_buf+0x16/0x1b<br>=C2=A0=
=C2=A0=C2=A0 =C2=A0[&lt;ffffffff88362414&gt;] :xfs:xfs_dir2_leaf_lookup_int=
+0x57/0x24f<br>

=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff88362414&gt;] :xfs:xfs_dir2_leaf_look=
up_int+0x57/0x24f<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8004ad3e&gt;] tr=
y_to_del_timer_sync+0x7f/0x88<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8836=
28c5&gt;] :xfs:xfs_dir2_leaf_lookup+0x1f/0xb6<br>=C2=A0=C2=A0=C2=A0 =C2=A0[=
&lt;ffffffff8835f50c&gt;] :xfs:xfs_dir2_isleaf+0x19/0x4a<br>

=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8003f8b2&gt;] memcpy_toiovec+0x36/0x6=
6<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8835fc1a&gt;] :xfs:xfs_dir_looku=
p+0xf9/0x140<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff88384309&gt;] :xfs:xf=
s_lookup+0x49/0xa8<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8805c27c&gt;] :=
ext3:ext3_get_acl+0x63/0x310<br>

=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8838f772&gt;] :xfs:xfs_vn_lookup+0x3d=
/0x7b<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8000d0b0&gt;] do_lookup+0x12=
6/0x227<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff80009c59&gt;] __link_path_=
walk+0x3aa/0xf39<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8000eb37&gt;] lin=
k_path_walk+0x45/0xb8<br>

=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8000ce0a&gt;] do_path_lookup+0x294/0x=
310<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff80012969&gt;] getname+0x15b/0x=
1c2<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff80023a11&gt;] __user_walk_fd+0=
x37/0x4c<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8002898c&gt;] vfs_stat_fd=
+0x1b/0x4a<br>

=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff80067235&gt;] do_page_fault+0x4cc/0x8=
42<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8023074b&gt;] sys_connect+0x7e/=
0xae<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff80023741&gt;] sys_newstat+0x1=
9/0x31<br>=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8005d229&gt;] tracesys+0x71=
/0xe0<br>

=C2=A0=C2=A0=C2=A0 =C2=A0[&lt;ffffffff8005d28d&gt;] tracesys+0xd5/0xe0<br><=
br>=C2=A0=C2=A0=C2=A0 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00=C2=A0 ................<br>=C2=A0=C2=A0=C2=A0 Filesystem cciss/c0d2: XF=
S internal error xfs_da_do_buf(2) at line 2112 of file fs/xfs/xfs_da_btree.=
c.=C2=A0 Caller 0xffffffff8835d9b9<br>

<br>hpacucli says the array is fine, but it looks like it&#39;s corrupted t=
o me.=C2=A0 This is probably a lost cause, but if anyone has any ideas I&#3=
9;d love to hear them.<br><br><br>Thanks,<br><br>Drew<br>

--14dae934097bed0ec304bdb77f46--


--===============1600121233694008946==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1600121233694008946==--
