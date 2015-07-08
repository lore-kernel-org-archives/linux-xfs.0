Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B3CA17F5F
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 05:28:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F1B4AC002
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 03:28:26 -0700 (PDT)
Received: from columba.intomics.com (columba.intomics.com [77.72.50.68]) by
	cuda.sgi.com with ESMTP id 49SMgdskvrvYiOS5 for
	<xfs@oss.sgi.com>; Wed, 08 Jul 2015 03:28:21 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by columba.intomics.com (Postfix) with ESMTP id 6829F220581
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 12:28:20 +0200 (CEST)
Received: from columba ([127.0.0.1])
	by localhost (columba.intomics.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id D7rBNDGZ-coB for <xfs@oss.sgi.com>;
	Wed,  8 Jul 2015 12:28:17 +0200 (CEST)
Received: from dhcp-0-1-94.intomics.com (dhcp-0-1-94.intomics.com [10.0.1.94])
	(Authenticated sender: rbh)
	by columba.intomics.com (Postfix) with ESMTPSA id BF3BC22058C
	for <xfs@oss.sgi.com>; Wed,  8 Jul 2015 12:28:17 +0200 (CEST)
From: Rasmus Borup Hansen <rbh@intomics.com>
Message-Id: <7B558BFF-FC46-4378-84C0-4442C1209F45@intomics.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: "Internal error xfs_attr3_leaf_write_verify at line 216",
	"directory flags set on non-directory inode" and other errors
Date: Wed, 8 Jul 2015 12:28:19 +0200
References: <FD7C5F18-48F3-461B-9604-0E3BDBB7AD69@intomics.com>
	<20150625184132.773a5ecd@harpe.intellique.com>
	<09CE9E14-9E6B-4587-9049-35B6C67016EF@intomics.com>
	<DBDC024E-67E6-4F11-995F-467AD085109F@intomics.com>
	<20150702112623.1c83d473@harpe.intellique.com>
	<E293B208-AA72-4076-97B0-753C8680D1AE@intomics.com>
	<20150703235500.GR7943@dastard>
	<0F9CF77D-1DA5-41DD-87AA-7F4109F08EFB@intomics.com>
	<20150707001900.GU7943@dastard>
In-Reply-To: <20150707001900.GU7943@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4925467533080673499=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4925467533080673499==
Content-Type: multipart/alternative; boundary="Apple-Mail=_EE089567-6066-4BA4-98F8-D90F6CC22FDC"


--Apple-Mail=_EE089567-6066-4BA4-98F8-D90F6CC22FDC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

> On 07 Jul 2015, at 02:19, Dave Chinner <david@fromorbit.com> wrote:
>=20
> On Mon, Jul 06, 2015 at 01:08:52PM +0200, Rasmus Borup Hansen wrote:
>> I've made a metadump and I'm running another xfs_repair, but given
>> that the first metadump is 132 GB, will you still be interested in
>> looking at the dumps?
>=20
> That's significantly larger than my monthly download quota.  How big
> is it once you compress it?

One metadump is 25 GB when compressed with xz -9. The server the files =
currently reside on is not very fast, so I've only compressed one of =
them so far.

I used the strings command on the metadump files and discovered that =
they contain fragments of files that we really don't want to leave our =
IT systems. However, if you think it's worth the effort, I could set up =
a virtual machine with the metadump files and give you access with your =
SSH public key. But then you'll have to tell me which tools you'll need =
for investigating the files.

> Also, because of the size of the metadump, I'll need some context
> about the hardware it is running on. Can you you please also provide
> the information in:
>=20
> =
http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when=
_reporting_a_problem.3F
>=20
> so I have a better idea of environment the problem is showing up in.

$ uname -a
Linux mammuthus 3.13.0-55-generic #94-Ubuntu SMP Thu Jun 18 00:27:10 UTC =
2015 x86_64 x86_64 x86_64 GNU/Linux

$ ./xfs_repair -V
xfs_repair version 3.2.3

$ cat /proc/cpuinfo | grep processor | wc -l
2

$ cat /proc/meminfo
MemTotal:       10228560 kB
MemFree:          300612 kB
Buffers:          111996 kB
Cached:          3569448 kB
SwapCached:         7836 kB
Active:          1915848 kB
Inactive:        2510244 kB
Active(anon):     358064 kB
Inactive(anon):   386784 kB
Active(file):    1557784 kB
Inactive(file):  2123460 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2088956 kB
SwapFree:        2042964 kB
Dirty:              3972 kB
Writeback:             0 kB
AnonPages:        739808 kB
Mapped:            18340 kB
Shmem:                72 kB
Slab:            4672980 kB
SReclaimable:    3927540 kB
SUnreclaim:       745440 kB
KernelStack:        2328 kB
PageTables:         8840 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     7203236 kB
Committed_AS:    1152936 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      309048 kB
VmallocChunk:   34359412736 kB
HardwareCorrupted:     0 kB
AnonHugePages:      8192 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       62052 kB
DirectMap2M:    10414080 kB

$ cat /proc/mounts
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,relatime,size=3D5103100k,nr_inodes=3D1275775,mode=3D=
755 0 0
devpts /dev/pts devpts =
rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmode=3D000 0 0
tmpfs /run tmpfs rw,nosuid,noexec,relatime,size=3D1022856k,mode=3D755 0 =
0
/dev/mapper/mammuthus-root / ext4 =
rw,relatime,errors=3Dremount-ro,data=3Dordered 0 0
none /sys/fs/cgroup tmpfs rw,relatime,size=3D4k,mode=3D755 0 0
none /sys/fs/fuse/connections fusectl rw,relatime 0 0
none /sys/kernel/debug debugfs rw,relatime 0 0
none /sys/kernel/security securityfs rw,relatime 0 0
none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 0
none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
none /run/user tmpfs =
rw,nosuid,nodev,noexec,relatime,size=3D102400k,mode=3D755 0 0
none /sys/fs/pstore pstore rw,relatime 0 0
/dev/sdd1 /boot ext2 rw,relatime 0 0
systemd /sys/fs/cgroup/systemd cgroup =
rw,nosuid,nodev,noexec,relatime,name=3Dsystemd 0 0
/dev/mapper/backup02-limited_backup /limited_backup xfs =
rw,noatime,attr2,inode64,logbsize=3D256k,noquota 0 0
/dev/mapper/backup02-timemachine /timemachine_backup ext4 =
rw,relatime,errors=3Dremount-ro,data=3Dordered,jqfmt=3Dvfsv0,usrjquota=3D.=
aquota.user,grpjquota=3D.aquota.group 0 0
/dev/mapper/backup01-data /backup xfs =
rw,noatime,attr2,inode64,logbsize=3D256k,noquota 0 0

This is what /proc/mounts looks like currently. When the error first =
occurred there was no /dev/mapper/backup02 volume group and =
/dev/mapper/backup01-data (which has the file system that behaves =
strangely) was mounted with user and project quota. Of course, the file =
system was not mounted when running xfs_repair.

$ cat /proc/partitions
major minor  #blocks  name

   8       16 19529728000 sdb
   8       17 19529726959 sdb1
   8        0 39064698880 sda
   8        1 39064697839 sda1
 252        0 39064694784 dm-0
   8       32  976224256 sdc
   8       33  976223215 sdc1
   8       48  155713536 sdd
   8       49     248832 sdd1
   8       50          1 sdd2
   8       53  155461632 sdd5
 252        1  153370624 dm-1
 252        2    2088960 dm-2
 252        3   33554432 dm-3
 252        4  942665728 dm-4
 252        5 5368709120 dm-5
 252        6 14161014784 dm-6

I'm using hardware RAID level 6 with a Dell PERC H800 controller and an =
MD1200 disk enclosure with 12 4 TB disks configured as a single "virtual =
disk":

$ /opt/dell/srvadmin/bin/omreport storage vdisk controller=3D0
List of Virtual Disks on Controller PERC H800 Adapter (Slot 1)

Controller PERC H800 Adapter (Slot 1)
ID                                : 0
Status                            : Ok
Name                              : mammuthus01
State                             : Ready
Hot Spare Policy violated         : Not Assigned
Encrypted                         : No
Layout                            : RAID-6
Size                              : 37,255.00 GB (40002251653120 bytes)
T10 Protection Information Status : No
Associated Fluid Cache State      : Not Applicable
Device Name                       : /dev/sda
Bus Protocol                      : SAS
Media                             : HDD
Read Policy                       : Adaptive Read Ahead
Write Policy                      : Write Back
Cache Policy                      : Not Applicable
Stripe Element Size               : 64 KB
Disk Cache Policy                 : Disabled

This "virtual disk" is the only member of the volume group "backup01":

$ sudo pvscan
  PV /dev/sdd5   VG mammuthus   lvm2 [148.26 GiB / 0    free]
  PV /dev/sdc1   VG extra       lvm2 [931.00 GiB / 0    free]
  PV /dev/sdb1   VG backup02    lvm2 [18.19 TiB / 0    free]
  PV /dev/sda1   VG backup01    lvm2 [36.38 TiB / 0    free]
  Total: 4 [55.62 TiB] / in use: 4 [55.62 TiB] / in no VG: 0 [0   ]

This volume group has a single logical volume:

$ sudo lvscan
  ACTIVE            '/dev/mammuthus/root' [146.27 GiB] inherit
  ACTIVE            '/dev/mammuthus/swap_1' [1.99 GiB] inherit
  ACTIVE            '/dev/extra/swap' [32.00 GiB] inherit
  ACTIVE            '/dev/extra/files' [899.00 GiB] inherit
  ACTIVE            '/dev/backup02/timemachine' [5.00 TiB] inherit
  ACTIVE            '/dev/backup02/limited_backup' [13.19 TiB] inherit
  ACTIVE            '/dev/backup01/data' [36.38 TiB] inherit

The drives are 12 4 TB 7.2 RPK Near-Line SAS 3.5" hot plug drives:

$ /opt/dell/srvadmin/bin/omreport storage pdisk controller=3D0 =
connector=3D0
List of Physical Disks on Connector 0 of Controller PERC H800 Adapter =
(Slot 1)

Controller PERC H800 Adapter (Slot 1)
ID                              : 0:0:0
Status                          : Ok
Name                            : Physical Disk 0:0:0
State                           : Online
Power Status                    : Spun Up
Bus Protocol                    : SAS
Media                           : HDD
Part of Cache Pool              : Not Applicable
Remaining Rated Write Endurance : Not Applicable
Failure Predicted               : No
Revision                        : GS0D
Driver Version                  : Not Applicable
Model Number                    : Not Applicable
T10 PI Capable                  : No
Certified                       : Yes
Encryption Capable              : No
Encrypted                       : Not Applicable
Progress                        : Not Applicable
Mirror Set ID                   : Not Applicable
Capacity                        : 3,725.50 GB (4000225165312 bytes)
Used RAID Disk Space            : 3,725.50 GB (4000225165312 bytes)
Available RAID Disk Space       : 0.00 GB (0 bytes)
Hot Spare                       : No
Vendor ID                       : DELL(tm)
Product ID                      : ST4000NM0023
Serial No.                      : Z1Z4BNJ3
Part Number                     : TH0529FG2123345Q022HA02
Negotiated Speed                : 6.00 Gbps
Capable Speed                   : 6.00 Gbps
PCIe Maximum Link Width         : Not Applicable
PCIe Negotiated Link Width      : Not Applicable
Sector Size                     : 512B
Device Write Cache              : Not Applicable
Manufacture Day                 : 04
Manufacture Week                : 21
Manufacture Year                : 2014
SAS Address                     : 5000C50058C0F211

(Only output for the first drive show; the others are similar.)

The individual drives don't use write caches, but the storage controller =
has 512 MB cache with battery backup operating in write-back mode.

$ xfs_info /backup/
meta-data=3D/dev/mapper/backup01-data isize=3D256    agcount=3D37, =
agsize=3D268435455 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D9766173696, =
imaxpct=3D5
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0

Output from ls when listing "lost+found":

$ ls -laF /backup/lost+found/
ls: /backup/lost+found/11539619467: Structure needs cleaning
total 4
drwxr-xr-x 2 root root     32 Jun 30 07:43 ./
drwxr-xr-x 5 root root     74 Jul  2 12:55 ../
-rw-rw-rw- 1 tsj  intomics  0 Jun 23 16:11 11539619467

Relevant output from dmesg (the errors are generated by the ls command =
above):

[444852.252110] XFS (dm-0): Mounting Filesystem
[444854.630181] XFS (dm-0): Ending clean mount
[503166.397439] ffff880114063000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 =
00 00 00  ................
[503166.425056] ffff880114063010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 =
00 00 00  ..... ..........
[503166.453484] ffff880114063020: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[503166.480812] ffff880114063030: 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00  ................
[503166.508386] XFS (dm-0): Internal error xfs_attr3_leaf_read_verify at =
line 246 of file /build/buildd/linux-3.13.0/fs/xfs/xfs_attr_leaf.c.  =
Caller 0xffffffffa00d4885
[503166.562354] CPU: 1 PID: 3342 Comm: kworker/1:1H Not tainted =
3.13.0-55-generic #94-Ubuntu
[503166.562356] Hardware name: Dell Inc. PowerEdge R310/05XKKK, BIOS =
1.8.2 08/17/2011
[503166.562394] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[503166.562398]  0000000000000001 ffff8802af92bd68 ffffffff81723294 =
ffff88004d1b2000
[503166.562402]  ffff8802af92bd80 ffffffffa00d76fb ffffffffa00d4885 =
ffff8802af92bdb8
[503166.562403]  ffffffffa00d7755 000000f600200400 ffff88001b216a00 =
ffff88004d1b2000
[503166.562406] Call Trace:
[503166.562415]  [<ffffffff81723294>] dump_stack+0x45/0x56
[503166.562426]  [<ffffffffa00d76fb>] xfs_error_report+0x3b/0x40 [xfs]
[503166.562436]  [<ffffffffa00d4885>] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]
[503166.562446]  [<ffffffffa00d7755>] xfs_corruption_error+0x55/0x80 =
[xfs]
[503166.562459]  [<ffffffffa00f4bdd>] =
xfs_attr3_leaf_read_verify+0x6d/0xf0 [xfs]
[503166.562469]  [<ffffffffa00d4885>] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]
[503166.562479]  [<ffffffffa00d4885>] xfs_buf_iodone_work+0x85/0xf0 =
[xfs]
[503166.562483]  [<ffffffff81083b22>] process_one_work+0x182/0x450
[503166.562485]  [<ffffffff81084911>] worker_thread+0x121/0x410
[503166.562487]  [<ffffffff810847f0>] ? rescuer_thread+0x430/0x430
[503166.562489]  [<ffffffff8108b702>] kthread+0xd2/0xf0
[503166.562491]  [<ffffffff8108b630>] ? =
kthread_create_on_node+0x1c0/0x1c0
[503166.562494]  [<ffffffff81733ca8>] ret_from_fork+0x58/0x90
[503166.562496]  [<ffffffff8108b630>] ? =
kthread_create_on_node+0x1c0/0x1c0
[503166.562498] XFS (dm-0): Corruption detected. Unmount and run =
xfs_repair
[503166.589297] XFS (dm-0): metadata I/O error: block 0x157e84da0 =
("xfs_trans_read_buf_map") error 117 numblks 8

The error occurs even though the file system is not doing anything else.

Intomics is a contract research organization specialized in deriving =
core biological insight from large scale data. We help our clients in =
the pharmaceutical industry develop tomorrow's medicines better, faster, =
and cheaper through optimized use of biomedical data.
-----------------------------------------------------------------
Hansen, Rasmus Borup              Intomics - from data to biology
System Administrator              Diplomvej 377
Scientific Programmer             DK-2800 Kgs. Lyngby
                                  Denmark
E: rbh@intomics.com               W: http://www.intomics.com/
P: +45 5167 7972                  P: +45 8880 7979


--Apple-Mail=_EE089567-6066-4BA4-98F8-D90F6CC22FDC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div><blockquote type=3D"cite" class=3D""><div class=3D"">On =
07 Jul 2015, at 02:19, Dave Chinner &lt;<a =
href=3D"mailto:david@fromorbit.com" class=3D"">david@fromorbit.com</a>&gt;=
 wrote:</div><br class=3D"Apple-interchange-newline"><div class=3D"">On =
Mon, Jul 06, 2015 at 01:08:52PM +0200, Rasmus Borup Hansen wrote:<br =
class=3D""><blockquote type=3D"cite" class=3D"">I've made a metadump and =
I'm running another xfs_repair, but given<br class=3D"">that the first =
metadump is 132 GB, will you still be interested in<br class=3D"">looking =
at the dumps?<br class=3D""></blockquote><br class=3D"">That's =
significantly larger than my monthly download quota. &nbsp;How big<br =
class=3D"">is it once you compress it?<br =
class=3D""></div></blockquote><div><br class=3D""></div><div>One =
metadump is 25 GB when compressed with <font face=3D"Courier New" =
class=3D"">xz -9</font>. The server the files currently reside on is not =
very fast, so I've only compressed one of them so far.</div><div><br =
class=3D""></div><div>I used the <font face=3D"Courier New" =
class=3D"">strings</font> command on the metadump files and discovered =
that they contain fragments of files that we really don't want to leave =
our IT systems. However, if you think it's worth the effort, I could set =
up a virtual machine with the metadump files and give you access with =
your SSH public key. But then you'll have to tell me which tools you'll =
need for investigating the files.</div><br class=3D""><blockquote =
type=3D"cite" class=3D""><div class=3D"">Also, because of the size of =
the metadump, I'll need some context<br class=3D"">about the hardware it =
is running on. Can you you please also provide<br class=3D"">the =
information in:<br class=3D""><br class=3D""><a =
href=3D"http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_incl=
ude_when_reporting_a_problem.3F" =
class=3D"">http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_i=
nclude_when_reporting_a_problem.3F</a><br class=3D""><br class=3D"">so I =
have a better idea of environment the problem is showing up in.<br =
class=3D""></div></blockquote><div><br class=3D""></div><div><div =
class=3D""><div class=3D""><font face=3D"Courier New" class=3D"">$ <i =
class=3D"">uname -a</i></font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">Linux mammuthus 3.13.0-55-generic #94-Ubuntu SMP Thu Jun =
18 00:27:10 UTC 2015 x86_64 x86_64 x86_64 =
GNU/Linux</font></div></div><div class=3D""><font face=3D"Courier New" =
class=3D""><br class=3D""></font></div><div class=3D""><div =
class=3D""><font face=3D"Courier New" class=3D"">$ <i =
class=3D"">./xfs_repair -V</i></font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">xfs_repair version <b =
class=3D"">3.2.3</b></font></div></div><div class=3D""><font =
face=3D"Courier New" class=3D""><br class=3D""></font></div><div =
class=3D""><div class=3D""><font face=3D"Courier New" class=3D"">$ <i =
class=3D"">cat /proc/cpuinfo | grep processor | wc =
-l</i></font></div><div class=3D""><font face=3D"Courier New" =
class=3D""><b class=3D"">2</b></font></div></div><div class=3D""><font =
face=3D"Courier New" class=3D""><br class=3D""></font></div><div =
class=3D""><div class=3D""><font face=3D"Courier New" class=3D"">$ <i =
class=3D"">cat /proc/meminfo</i></font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">MemTotal: &nbsp; &nbsp; &nbsp; 10228560 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">MemFree: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;300612 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Buffers: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;111996 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Cached: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;3569448 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">SwapCached: &nbsp; &nbsp; &nbsp; &nbsp; 7836 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Active: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1915848 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Inactive: &nbsp; &nbsp; &nbsp; &nbsp;2510244 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Active(anon): &nbsp; &nbsp; 358064 kB</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Inactive(anon): &nbsp; =
386784 kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Active(file): &nbsp; &nbsp;1557784 kB</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Inactive(file): =
&nbsp;2123460 kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Unevictable: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Mlocked: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">SwapTotal: &nbsp; &nbsp; &nbsp; 2088956 kB</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">SwapFree: &nbsp; &nbsp; =
&nbsp; &nbsp;2042964 kB</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">Dirty: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;3972 kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Writeback: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">AnonPages: &nbsp; &nbsp; &nbsp; &nbsp;739808 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Mapped: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;18340 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Shmem: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;72 kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Slab: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;4672980 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">SReclaimable: &nbsp; &nbsp;3927540 kB</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">SUnreclaim: &nbsp; =
&nbsp; &nbsp; 745440 kB</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">KernelStack: &nbsp; &nbsp; &nbsp; &nbsp;2328 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">PageTables: &nbsp; &nbsp; &nbsp; &nbsp; 8840 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">NFS_Unstable: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Bounce: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;0 kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">WritebackTmp: &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">CommitLimit: &nbsp; &nbsp; 7203236 kB</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Committed_AS: &nbsp; =
&nbsp;1152936 kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">VmallocTotal: &nbsp; 34359738367 kB</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">VmallocUsed: &nbsp; =
&nbsp; &nbsp;309048 kB</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">VmallocChunk: &nbsp; 34359412736 kB</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">HardwareCorrupted: =
&nbsp; &nbsp; 0 kB</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">AnonHugePages: &nbsp; &nbsp; &nbsp;8192 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">HugePages_Total: &nbsp; &nbsp; &nbsp; 0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">HugePages_Free: &nbsp; =
&nbsp; &nbsp; &nbsp;0</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">HugePages_Rsvd: &nbsp; &nbsp; &nbsp; =
&nbsp;0</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">HugePages_Surp: &nbsp; &nbsp; &nbsp; &nbsp;0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Hugepagesize: &nbsp; =
&nbsp; &nbsp; 2048 kB</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">DirectMap4k: &nbsp; &nbsp; &nbsp; 62052 =
kB</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">DirectMap2M: &nbsp; &nbsp;10414080 kB</font></div></div><div =
class=3D""><font face=3D"Courier New" class=3D""><br =
class=3D""></font></div><div class=3D""><div class=3D""><font =
face=3D"Courier New" class=3D"">$ <i class=3D"">cat =
/proc/mounts</i></font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">rootfs / rootfs rw 0 0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">sysfs /sys sysfs =
rw,nosuid,nodev,noexec,relatime 0 0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">proc /proc proc =
rw,nosuid,nodev,noexec,relatime 0 0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">udev /dev devtmpfs =
rw,relatime,size=3D5103100k,nr_inodes=3D1275775,mode=3D755 0 =
0</font></div><div class=3D""><font face=3D"Courier New" class=3D"">devpts=
 /dev/pts devpts rw,nosuid,noexec,relatime,gid=3D5,mode=3D620,ptmxmode=3D0=
00 0 0</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">tmpfs /run tmpfs =
rw,nosuid,noexec,relatime,size=3D1022856k,mode=3D755 0 =
0</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">/dev/mapper/mammuthus-root / ext4 =
rw,relatime,errors=3Dremount-ro,data=3Dordered 0 0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">none /sys/fs/cgroup =
tmpfs rw,relatime,size=3D4k,mode=3D755 0 0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">none =
/sys/fs/fuse/connections fusectl rw,relatime 0 0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">none /sys/kernel/debug =
debugfs rw,relatime 0 0</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">none /sys/kernel/security securityfs rw,relatime 0 =
0</font></div><div class=3D""><font face=3D"Courier New" class=3D"">none =
/run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=3D5120k 0 =
0</font></div><div class=3D""><font face=3D"Courier New" class=3D"">none =
/run/shm tmpfs rw,nosuid,nodev,relatime 0 0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">none /run/user tmpfs =
rw,nosuid,nodev,noexec,relatime,size=3D102400k,mode=3D755 0 =
0</font></div><div class=3D""><font face=3D"Courier New" class=3D"">none =
/sys/fs/pstore pstore rw,relatime 0 0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">/dev/sdd1 /boot ext2 rw,relatime 0 =
0</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">systemd /sys/fs/cgroup/systemd cgroup =
rw,nosuid,nodev,noexec,relatime,name=3Dsystemd 0 0</font></div><div =
class=3D""><font face=3D"Courier New" =
class=3D"">/dev/mapper/backup02-limited_backup /limited_backup xfs =
rw,noatime,attr2,inode64,logbsize=3D256k,noquota 0 0</font></div><div =
class=3D""><font face=3D"Courier New" =
class=3D"">/dev/mapper/backup02-timemachine /timemachine_backup ext4 =
rw,relatime,errors=3Dremount-ro,data=3Dordered,jqfmt=3Dvfsv0,usrjquota=3D.=
aquota.user,grpjquota=3D.aquota.group 0 0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D""><b =
class=3D"">/dev/mapper/backup01-data /backup xfs =
rw,noatime,attr2,inode64,logbsize=3D256k,noquota 0 =
0</b></font></div></div><div class=3D""><br =
class=3D""></div></div></div><div class=3D""><div class=3D"">This is =
what <font face=3D"Courier New" class=3D"">/proc/mounts</font> looks =
like currently. When the error first occurred there was no <font =
face=3D"Courier New" class=3D"">/dev/mapper/backup02</font> volume group =
and <font face=3D"Courier New" class=3D"">/dev/mapper/backup01-data</font>=
 (which has the file system that behaves strangely) was mounted with =
user and project quota. Of course, the file system was not mounted when =
running <font face=3D"Courier New" class=3D"">xfs_repair</font>.</div><div=
 class=3D""><br class=3D""></div><div class=3D""><div class=3D""><font =
face=3D"Courier New" class=3D"">$ <i class=3D"">cat =
/proc/partitions</i></font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">major minor &nbsp;#blocks &nbsp;name</font></div><div =
class=3D""><font face=3D"Courier New" class=3D""><br =
class=3D""></font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; 16 19529728000 =
sdb</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; 17 19529726959 =
sdb1</font></div><div class=3D""><font face=3D"Courier New" class=3D""><b =
class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; &nbsp;0 39064698880 =
sda</b></font></div><div class=3D""><font face=3D"Courier New" =
class=3D""><b class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; &nbsp;1 =
39064697839 sda1</b></font></div><div class=3D""><font face=3D"Courier =
New" class=3D""><b class=3D"">&nbsp;252 &nbsp; &nbsp; &nbsp; &nbsp;0 =
39064694784 dm-0</b></font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; 32 &nbsp;976224256 =
sdc</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; 33 &nbsp;976223215 =
sdc1</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; 48 &nbsp;155713536 =
sdd</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; 49 &nbsp; &nbsp; 248832 =
sdd1</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; 50 &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;1 sdd2</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">&nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp; 53 &nbsp;155461632 =
sdd5</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp;252 &nbsp; &nbsp; &nbsp; &nbsp;1 &nbsp;153370624 =
dm-1</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp;252 &nbsp; &nbsp; &nbsp; &nbsp;2 &nbsp; &nbsp;2088960 =
dm-2</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp;252 &nbsp; &nbsp; &nbsp; &nbsp;3 &nbsp; 33554432 =
dm-3</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp;252 &nbsp; &nbsp; &nbsp; &nbsp;4 &nbsp;942665728 =
dm-4</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp;252 &nbsp; &nbsp; &nbsp; &nbsp;5 5368709120 =
dm-5</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp;252 &nbsp; &nbsp; &nbsp; &nbsp;6 14161014784 =
dm-6</font></div></div><div class=3D""><br class=3D""></div><div =
class=3D"">I'm using hardware RAID level 6 with a Dell PERC H800 =
controller and an MD1200 disk enclosure with 12 4 TB disks configured as =
a single "virtual disk":</div><div class=3D""><br class=3D""></div><div =
class=3D""><div class=3D""><font face=3D"Courier New" class=3D"">$ <i =
class=3D"">/opt/dell/srvadmin/bin/omreport storage vdisk =
controller=3D0</i></font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">List of Virtual Disks on Controller PERC H800 Adapter =
(Slot 1)</font></div><div class=3D""><font face=3D"Courier New" =
class=3D""><br class=3D""></font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Controller PERC H800 Adapter (Slot =
1)</font></div><div class=3D""><font face=3D"Courier New" class=3D"">ID =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: 0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Status &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp;: Ok</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Name &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: =
mammuthus01</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">State &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : Ready</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Hot Spare Policy =
violated &nbsp; &nbsp; &nbsp; &nbsp; : Not Assigned</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Encrypted &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : =
No</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Layout &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: <b =
class=3D"">RAID-6</b></font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">Size &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: 37,255.00 GB =
(40002251653120 bytes)</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">T10 Protection Information Status : No</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Associated Fluid Cache =
State &nbsp; &nbsp; &nbsp;: Not Applicable</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Device Name &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : =
<b class=3D"">/dev/sda</b></font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Bus Protocol &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: SAS</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Media &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; : HDD</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">Read Policy &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : Adaptive Read =
Ahead</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Write Policy &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;: <b class=3D"">Write =
Back</b></font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Cache Policy &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;: Not Applicable</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Stripe Element Size =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : 64 =
KB</font></div><div class=3D""><font face=3D"Courier New" class=3D"">Disk =
Cache Policy &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : =
Disabled</font></div></div><div class=3D""><br class=3D""></div><div =
class=3D"">This "virtual disk" is the only member of the volume group =
"backup01":</div><div class=3D""><br class=3D""></div><div class=3D""><div=
 class=3D""><font face=3D"Courier New" class=3D"">$ <i class=3D"">sudo =
pvscan</i></font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; PV /dev/sdd5 &nbsp; VG mammuthus &nbsp; lvm2 [148.26 =
GiB / 0 &nbsp; &nbsp;free]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">&nbsp; PV /dev/sdc1 &nbsp; VG extra =
&nbsp; &nbsp; &nbsp; lvm2 [931.00 GiB / 0 &nbsp; =
&nbsp;free]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; PV /dev/sdb1 &nbsp; VG backup02 &nbsp; &nbsp;lvm2 =
[18.19 TiB / 0 &nbsp; &nbsp;free]</font></div><div class=3D""><b =
class=3D""><font face=3D"Courier New" class=3D"">&nbsp; PV /dev/sda1 =
&nbsp; VG backup01 &nbsp; &nbsp;lvm2 [36.38 TiB / 0 &nbsp; =
&nbsp;free]</font></b></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; Total: 4 [55.62 TiB] / in use: 4 [55.62 TiB] / in no =
VG: 0 [0 &nbsp; ]</font></div></div><div class=3D""><br =
class=3D""></div><div class=3D"">This volume group has a single logical =
volume:</div><div class=3D""><br class=3D""></div><div class=3D""><div =
class=3D""><font face=3D"Courier New" class=3D"">$ <i class=3D"">sudo =
lvscan</i></font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; ACTIVE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;'/dev/mammuthus/root' [146.27 GiB] inherit</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">&nbsp; ACTIVE &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'/dev/mammuthus/swap_1' [1.99 GiB] =
inherit</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; ACTIVE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;'/dev/extra/swap' [32.00 GiB] inherit</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">&nbsp; ACTIVE &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'/dev/extra/files' [899.00 GiB] =
inherit</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; ACTIVE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;'/dev/backup02/timemachine' [5.00 TiB] inherit</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">&nbsp; ACTIVE &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;'/dev/backup02/limited_backup' [13.19 =
TiB] inherit</font></div><div class=3D""><b class=3D""><font =
face=3D"Courier New" class=3D"">&nbsp; ACTIVE &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;'/dev/backup01/data' [36.38 TiB] =
inherit</font></b></div></div><div class=3D""><br class=3D""></div><div =
class=3D"">The drives are 12 4 TB 7.2 RPK Near-Line SAS 3.5" hot plug =
drives:</div><div class=3D""><br class=3D""></div><div class=3D""><div =
class=3D""><font face=3D"Courier New" class=3D"">$ <i =
class=3D"">/opt/dell/srvadmin/bin/omreport storage pdisk controller=3D0 =
connector=3D0</i></font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">List of Physical Disks on Connector 0 of Controller PERC H800 =
Adapter (Slot 1)</font></div><div class=3D""><font face=3D"Courier New" =
class=3D""><br class=3D""></font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Controller PERC H800 Adapter (Slot =
1)</font></div><div class=3D""><font face=3D"Courier New" class=3D"">ID =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: 0:0:0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Status &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;: Ok</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Name &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: Physical Disk =
0:0:0</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">State &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : Online</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Power Status &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: Spun =
Up</font></div><div class=3D""><font face=3D"Courier New" class=3D"">Bus =
Protocol &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;: SAS</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Media &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : HDD</font></div><div class=3D""><font=
 face=3D"Courier New" class=3D"">Part of Cache Pool &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;: Not Applicable</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Remaining Rated Write =
Endurance : Not Applicable</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Failure Predicted &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; : No</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Revision &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: =
GS0D</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Driver Version &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;: Not Applicable</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Model Number &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: Not =
Applicable</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">T10 PI Capable &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;: No</font></div><div class=3D""><font face=3D"Courier=
 New" class=3D"">Certified &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : Yes</font></div><div class=3D""><font=
 face=3D"Courier New" class=3D"">Encryption Capable &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;: No</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Encrypted &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : Not =
Applicable</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Progress &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: Not Applicable</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Mirror Set ID &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : Not =
Applicable</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Capacity &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: 3,725.50 GB (4000225165312 =
bytes)</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Used RAID Disk Space &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;: 3,725.50 GB (4000225165312 bytes)</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Available RAID Disk =
Space &nbsp; &nbsp; &nbsp; : 0.00 GB (0 bytes)</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Hot Spare &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : =
No</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Vendor ID &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; : DELL(tm)</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Product ID &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: =
ST4000NM0023</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Serial No. &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;: Z1Z4BNJ3</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Part Number &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : =
TH0529FG2123345Q022HA02</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">Negotiated Speed &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;: 6.00 Gbps</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Capable Speed &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : 6.00 Gbps</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">PCIe Maximum Link Width =
&nbsp; &nbsp; &nbsp; &nbsp; : Not Applicable</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">PCIe Negotiated Link =
Width &nbsp; &nbsp; &nbsp;: Not Applicable</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">Sector Size &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : =
512B</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">Device Write Cache &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;: Not Applicable</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">Manufacture Day &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; : 04</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Manufacture Week &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: 21</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">Manufacture Year &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;: 2014</font></div><div class=3D""><font=
 face=3D"Courier New" class=3D"">SAS Address &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; : =
5000C50058C0F211</font></div></div><div class=3D""><br =
class=3D""></div><div class=3D"">(Only output for the first drive show; =
the others are similar.)</div><div class=3D""><br class=3D""></div><div =
class=3D"">The individual drives don't use write caches, but the storage =
controller has 512 MB cache with battery backup operating in write-back =
mode.</div><div class=3D""><br class=3D""></div><div class=3D""><span =
style=3D"font-family: 'Courier New';" class=3D"">$ </span><font =
face=3D"Courier New" class=3D""><i class=3D"">xfs_info =
/backup/</i></font></div><div class=3D""><div class=3D""><font =
face=3D"Courier New" class=3D"">meta-data=3D/dev/mapper/backup01-data =
isize=3D256 &nbsp; &nbsp;agcount=3D37, agsize=3D268435455 =
blks</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sectsz=3D512 =
&nbsp; attr=3D2</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">data &nbsp; &nbsp; =3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; =
blocks=3D9766173696, imaxpct=3D5</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; sunit=3D0 &nbsp; &nbsp; &nbsp;swidth=3D0 blks</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">naming &nbsp; =3Dversion =
2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bsize=3D4096 &nbsp; =
ascii-ci=3D0</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">log &nbsp; &nbsp; &nbsp;=3Dinternal &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; blocks=3D521728, =
version=3D2</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sectsz=3D512 =
&nbsp; sunit=3D0 blks, lazy-count=3D1</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">realtime =3Dnone &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; extsz=3D4096 &nbsp; blocks=3D0, =
rtextents=3D0</font></div></div><div class=3D""><br class=3D""></div><div =
class=3D"">Output from <font face=3D"Courier New" class=3D"">ls</font> =
when listing "lost+found":</div><div class=3D""><br class=3D""></div><div =
class=3D""><div class=3D""><font face=3D"Courier New" class=3D"">$ <i =
class=3D"">ls -laF /backup/lost+found/</i></font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">ls: =
/backup/lost+found/11539619467: Structure needs =
cleaning</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">total 4</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">drwxr-xr-x 2 root root &nbsp; &nbsp; 32 Jun 30 07:43 =
./</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">drwxr-xr-x 5 root root &nbsp; &nbsp; 74 Jul &nbsp;2 12:55 =
../</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">-rw-rw-rw- 1 tsj &nbsp;intomics &nbsp;0 Jun 23 16:11 =
11539619467</font></div></div><div class=3D""><br class=3D""></div><div =
class=3D"">Relevant output from <font face=3D"Courier New" =
class=3D"">dmesg</font> (the errors are generated by the <font =
face=3D"Courier New" class=3D"">ls</font> command above):</div><div =
class=3D""><br class=3D""></div><div class=3D""><div class=3D""><font =
face=3D"Courier New" class=3D"">[444852.252110] XFS (dm-0): Mounting =
Filesystem</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[444854.630181] XFS (dm-0): Ending clean =
mount</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[503166.397439] ffff880114063000: 00 00 00 00 00 00 00 00 fb =
ee 00 00 00 00 00 00 &nbsp;................</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[503166.425056] =
ffff880114063010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00 =
&nbsp;..... ..........</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[503166.453484] ffff880114063020: 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 &nbsp;................</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[503166.480812] =
ffff880114063030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
&nbsp;................</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[503166.508386] XFS (dm-0): Internal error =
xfs_attr3_leaf_read_verify at line 246 of file =
/build/buildd/linux-3.13.0/fs/xfs/xfs_attr_leaf.c. &nbsp;Caller =
0xffffffffa00d4885</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[503166.562354] CPU: 1 PID: 3342 Comm: kworker/1:1H Not =
tainted 3.13.0-55-generic #94-Ubuntu</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562356] Hardware name: Dell Inc. =
PowerEdge R310/05XKKK, BIOS 1.8.2 08/17/2011</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[503166.562394] =
Workqueue: xfslogd xfs_buf_iodone_work [xfs]</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[503166.562398] =
&nbsp;0000000000000001 ffff8802af92bd68 ffffffff81723294 =
ffff88004d1b2000</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[503166.562402] &nbsp;ffff8802af92bd80 ffffffffa00d76fb =
ffffffffa00d4885 ffff8802af92bdb8</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562403] &nbsp;ffffffffa00d7755 =
000000f600200400 ffff88001b216a00 ffff88004d1b2000</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[503166.562406] Call =
Trace:</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[503166.562415] &nbsp;[&lt;ffffffff81723294&gt;] =
dump_stack+0x45/0x56</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[503166.562426] &nbsp;[&lt;ffffffffa00d76fb&gt;] =
xfs_error_report+0x3b/0x40 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562436] =
&nbsp;[&lt;ffffffffa00d4885&gt;] ? xfs_buf_iodone_work+0x85/0xf0 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[503166.562446] &nbsp;[&lt;ffffffffa00d7755&gt;] =
xfs_corruption_error+0x55/0x80 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562459] =
&nbsp;[&lt;ffffffffa00f4bdd&gt;] xfs_attr3_leaf_read_verify+0x6d/0xf0 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[503166.562469] &nbsp;[&lt;ffffffffa00d4885&gt;] ? =
xfs_buf_iodone_work+0x85/0xf0 [xfs]</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562479] =
&nbsp;[&lt;ffffffffa00d4885&gt;] xfs_buf_iodone_work+0x85/0xf0 =
[xfs]</font></div><div class=3D""><font face=3D"Courier New" =
class=3D"">[503166.562483] &nbsp;[&lt;ffffffff81083b22&gt;] =
process_one_work+0x182/0x450</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562485] =
&nbsp;[&lt;ffffffff81084911&gt;] =
worker_thread+0x121/0x410</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562487] =
&nbsp;[&lt;ffffffff810847f0&gt;] ? =
rescuer_thread+0x430/0x430</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562489] =
&nbsp;[&lt;ffffffff8108b702&gt;] kthread+0xd2/0xf0</font></div><div =
class=3D""><font face=3D"Courier New" class=3D"">[503166.562491] =
&nbsp;[&lt;ffffffff8108b630&gt;] ? =
kthread_create_on_node+0x1c0/0x1c0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562494] =
&nbsp;[&lt;ffffffff81733ca8&gt;] =
ret_from_fork+0x58/0x90</font></div><div class=3D""><font face=3D"Courier =
New" class=3D"">[503166.562496] &nbsp;[&lt;ffffffff8108b630&gt;] ? =
kthread_create_on_node+0x1c0/0x1c0</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.562498] XFS (dm-0): Corruption =
detected. Unmount and run xfs_repair</font></div><div class=3D""><font =
face=3D"Courier New" class=3D"">[503166.589297] XFS (dm-0): metadata I/O =
error: block 0x157e84da0 ("xfs_trans_read_buf_map") error 117 numblks =
8</font></div></div><div class=3D""><br class=3D""></div><div =
class=3D"">The error occurs even though the file system is not doing =
anything else.</div><br class=3D""><div class=3D""><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; =
border-spacing: 0px;"><i class=3D"">Intomics is a contract research =
organization specialized in deriving core biological insight from large =
scale data. We help our clients in the pharmaceutical&nbsp;industry =
develop tomorrow's medicines better, faster, and cheaper through =
optimized use of biomedical data.</i><span class=3D"Apple-style-span" =
style=3D"border-collapse: separate; orphans: 2; text-align: =
-webkit-auto; widows: 2; border-spacing: 0px;"><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space;" class=3D""><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier =
New'">-----------------------------------------------------------------</f=
ont></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">Hansen, Rasmus Borup &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp;Intomics - from data to biology</font></div><div =
class=3D""><font class=3D"Apple-style-span" face=3D"'Courier =
New'">System Administrator &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;Diplomvej 377</font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">Scientific Programmer =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; DK-2800 Kgs. =
Lyngby</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
Denmark</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'">E: <a href=3D"mailto:rbh@intomics.com" =
class=3D"">rbh@intomics.com</a> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; W: <a href=3D"http://www.intomics.com/" =
class=3D"">http://www.intomics.com/</a></font></div><div class=3D""><font =
class=3D"Apple-style-span" face=3D"'Courier New'">P: +45 5167 7972 =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;P: +45 =
8880 7979</font></div><div class=3D""><font class=3D"Apple-style-span" =
face=3D"'Courier New'"><br =
class=3D""></font></div></div></span></span></div></div></body></html>=

--Apple-Mail=_EE089567-6066-4BA4-98F8-D90F6CC22FDC--


--===============4925467533080673499==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4925467533080673499==--
