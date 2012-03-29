Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2T06WQb249098 for <xfs@oss.sgi.com>; Wed, 28 Mar 2012 19:06:33 -0500
Received: from mho-02-ewr.mailhop.org (mho-02-ewr.mailhop.org [204.13.248.72])
	by cuda.sgi.com with ESMTP id VZrlbhplFCvcPNxe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 28 Mar 2012 17:06:30 -0700 (PDT)
Received: from cpe-70-116-136-110.tx.res.rr.com ([70.116.136.110] helo=KirkPC)
	by mho-02-ewr.mailhop.org with esmtpa (Exim 4.72)
	(envelope-from <kirkande@tx.rr.com>) id 1SD2sn-0008c3-4F
	for xfs@oss.sgi.com; Thu, 29 Mar 2012 00:06:29 +0000
From: "Kirk Anderson" <kirkande@tx.rr.com>
Subject: Buffalo LS-Q4.0 Raid 5 XFS errors
Date: Wed, 28 Mar 2012 19:06:22 -0500
Message-ID: <004b01cd0d3f$c6d4fbc0$547ef340$@tx.rr.com>
MIME-Version: 1.0
Content-Language: en-us
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1794269173095748791=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multipart message in MIME format.

--===============1794269173095748791==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_004C_01CD0D15.DE0ADAA0"
Content-Language: en-us

This is a multipart message in MIME format.

------=_NextPart_000_004C_01CD0D15.DE0ADAA0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

I have a Buffalo LS-QLF55 4TB Raid 5 box.  It is out of warranty.  It was
using firmware 1.10.    The unit stopped responding and would not power down
through the web interface, nor the power button on the front of the unit.  I
unplugged the unit and plugged it back in.  The unit now shows the drives as
unformatted.  I have provided some information below and would greatly
appreciate some guidance as to what my next steps are to minimize my data
loss.  Any and all help is greatly appreciated.  Thanks, Kirk

 

 

root@LS-QLF55:~# uname -a

Linux LS-QLF55 2.6.22.7 #395 Thu May 21 22:24:49 JST 2009 armv5tejl unknown

root@LS-QLF55:~#

 

root@LS-QLF55:~# mount -t xfs /dev/md2 /mnt/array1

mount: mounting /dev/md2 on /mnt/array1 failed: Structure needs cleaning

 

root@LS-QLF55:~# mount -t xfs -o,ro,norecovery /dev/md2 /mnt/array1

mount: mounting /dev/md2 on /mnt/array1 failed: Structure needs cleaning

root@LS-QLF55:~#

 

Partial dmesg as it is lengthy.

 

root@LS-QLF55:~# dmesg

7:c6b86000 r6:00000000 r5:c6b85000 r4:00008000

[<c0099098>] (do_kern_mount+0x0/0xdc) from [<c00aebdc>]
(do_mount+0x578/0x5c8)

r8:00008000 r7:c6b85000 r6:00000008 r5:00000000 r4:00000000

[<c00ae664>] (do_mount+0x0/0x5c8) from [<c00aecb8>] (sys_mount+0x8c/0xd4)

[<c00aec2c>] (sys_mount+0x0/0xd4) from [<c0026f00>]
(ret_fast_syscall+0x0/0x2c)

r7:00000015 r6:00000000 r5:beba7abc r4:00000000

XFS: log mount/recovery failed: error 117

XFS: log mount failed

Filesystem "md2": Disabling barriers, not supported by the underlying device

XFS mounting filesystem md2

Starting XFS recovery on filesystem: md2 (logdev: internal)

Filesystem "md2": xfs_inode_recover: Bad inode magic number, dino ptr =
0xc6d2c000, dino bp = 0xc782fa80, ino = 256

Filesystem "md2": XFS internal error xlog_recover_do_inode_trans(1) at line
2310 of file fs/xfs/xfs_log_recover.c.  Caller 0xc017f368

[<c002b758>] (dump_stack+0x0/0x14) from [<c01666fc>]
(xfs_error_report+0x54/0x64)

[<c01666a8>] (xfs_error_report+0x0/0x64) from [<c017eb2c>]
(xlog_recover_do_inode_trans+0x28c/0x8ac)

[<c017e8a0>] (xlog_recover_do_inode_trans+0x0/0x8ac) from [<c017f368>]
(xlog_recover_do_trans+0x80/0x154)

[<c017f2e8>] (xlog_recover_do_trans+0x0/0x154) from [<c017f478>]
(xlog_recover_commit_trans+0x3c/0x54)

[<c017f43c>] (xlog_recover_commit_trans+0x0/0x54) from [<c017f5f4>]
(xlog_recover_process_data+0x164/0x224)

r7:c725e204 r6:c0b802d8 r5:08be0000 r4:e5000000

[<c017f490>] (xlog_recover_process_data+0x0/0x224) from [<c017f9b4>]
(xlog_do_recovery_pass+0x300/0x828)

[<c017f6b4>] (xlog_do_recovery_pass+0x0/0x828) from [<c017ff54>]
(xlog_do_log_recovery+0x78/0x9c)

[<c017fedc>] (xlog_do_log_recovery+0x0/0x9c) from [<c017ff98>]
(xlog_do_recover+0x20/0x138)

r9:00000000 r8:ad3a5038 r7:c0cb8aa0 r6:c0cb8aa0 r5:00000000

r4:0000be08

 

root@LS-QLF55:~# cat /proc/mdstat

Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]

md2 : active raid5 sda6[0] sdd6[3] sdc6[2] sdb6[1]

      2906278656 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

 

md1 : active raid1 sda2[0] sdd2[3] sdc2[2] sdb2[1]

      5004160 blocks [4/4] [UUUU]

 

md10 : active raid1 sda5[0] sdd5[3] sdc5[2] sdb5[1]

      1003904 blocks [4/4] [UUUU]

 

md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]

      1003904 blocks [4/4] [UUUU]

 

unused devices: <none>

root@LS-QLF55:~#

 

 

 

root@LS-QLF55:~# cat /proc/partitions

major minor  #blocks  name

 

   8     0  976761527 sda

   8     1    1004031 sda1

   8     2    5004247 sda2

   8     4          1 sda4

   8     5    1004031 sda5

   8     6  968759631 sda6

   8    16  976761527 sdb

   8    17    1004031 sdb1

   8    18    5004247 sdb2

   8    20          1 sdb4

   8    21    1004031 sdb5

   8    22  968759631 sdb6

   8    32  976761527 sdc

   8    33    1004031 sdc1

   8    34    5004247 sdc2

   8    36          1 sdc4

   8    37    1004031 sdc5

   8    38  968759631 sdc6

   8    48  976762584 sdd

   8    49    1004031 sdd1

   8    50    5004247 sdd2

   8    52          1 sdd4

   8    53    1004031 sdd5

   8    54  968759631 sdd6

  31     0        256 mtdblock0

   9     0    1003904 md0

   9    10    1003904 md10

   9     1    5004160 md1

   9     2 2906278656 md2

root@LS-QLF55:~#

 

 

root@LS-QLF55:~# mdadm --examine /dev/sda6

/dev/sda6:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : 89944e67:449d284c:d2881af4:19e5a1cb

  Creation Time : Thu Feb 26 20:33:41 2009

     Raid Level : raid5

    Device Size : 968759552 (923.88 GiB 992.01 GB)

     Array Size : 2906278656 (2771.64 GiB 2976.03 GB)

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 2

 

    Update Time : Wed Mar 28 07:28:40 2012

          State : clean

Active Devices : 4

Working Devices : 4

Failed Devices : 0

  Spare Devices : 0

       Checksum : 36a3ffda - correct

         Events : 0.12

 

         Layout : left-symmetric

     Chunk Size : 64K

 

      Number   Major   Minor   RaidDevice State

this     0       8        6        0      active sync   /dev/sda6

 

   0     0       8        6        0      active sync   /dev/sda6

   1     1       8       22        1      active sync   /dev/sdb6

   2     2       8       38        2      active sync   /dev/sdc6

   3     3       8       54        3      active sync   /dev/sdd6

root@LS-QLF55:~#

 

root@LS-QLF55:~# mdadm --examine /dev/sdb6

/dev/sdb6:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : 89944e67:449d284c:d2881af4:19e5a1cb

  Creation Time : Thu Feb 26 20:33:41 2009

     Raid Level : raid5

    Device Size : 968759552 (923.88 GiB 992.01 GB)

     Array Size : 2906278656 (2771.64 GiB 2976.03 GB)

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 2

 

    Update Time : Wed Mar 28 07:28:40 2012

          State : clean

Active Devices : 4

Working Devices : 4

Failed Devices : 0

  Spare Devices : 0

       Checksum : 36a3ffec - correct

         Events : 0.12

 

         Layout : left-symmetric

     Chunk Size : 64K

 

      Number   Major   Minor   RaidDevice State

this     1       8       22        1      active sync   /dev/sdb6

 

   0     0       8        6        0      active sync   /dev/sda6

   1     1       8       22        1      active sync   /dev/sdb6

   2     2       8       38        2      active sync   /dev/sdc6

   3     3       8       54        3      active sync   /dev/sdd6

root@LS-QLF55:~#

 

root@LS-QLF55:~# mdadm --examine /dev/sdc6

/dev/sdc6:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : 89944e67:449d284c:d2881af4:19e5a1cb

  Creation Time : Thu Feb 26 20:33:41 2009

     Raid Level : raid5

    Device Size : 968759552 (923.88 GiB 992.01 GB)

     Array Size : 2906278656 (2771.64 GiB 2976.03 GB)

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 2

 

    Update Time : Wed Mar 28 07:28:40 2012

          State : clean

Active Devices : 4

Working Devices : 4

Failed Devices : 0

  Spare Devices : 0

       Checksum : 36a3fffe - correct

         Events : 0.12

 

         Layout : left-symmetric

     Chunk Size : 64K

 

      Number   Major   Minor   RaidDevice State

this     2       8       38        2      active sync   /dev/sdc6

 

   0     0       8        6        0      active sync   /dev/sda6

   1     1       8       22        1      active sync   /dev/sdb6

   2     2       8       38        2      active sync   /dev/sdc6

   3     3       8       54        3      active sync   /dev/sdd6

root@LS-QLF55:~#

 

root@LS-QLF55:~# mdadm --examine /dev/sdd6

/dev/sdd6:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : 89944e67:449d284c:d2881af4:19e5a1cb

  Creation Time : Thu Feb 26 20:33:41 2009

     Raid Level : raid5

    Device Size : 968759552 (923.88 GiB 992.01 GB)

     Array Size : 2906278656 (2771.64 GiB 2976.03 GB)

   Raid Devices : 4

  Total Devices : 4

Preferred Minor : 2

 

    Update Time : Wed Mar 28 07:28:40 2012

          State : clean

Active Devices : 4

Working Devices : 4

Failed Devices : 0

  Spare Devices : 0

       Checksum : 36a40010 - correct

         Events : 0.12

 

         Layout : left-symmetric

     Chunk Size : 64K

 

      Number   Major   Minor   RaidDevice State

this     3       8       54        3      active sync   /dev/sdd6

 

   0     0       8        6        0      active sync   /dev/sda6

   1     1       8       22        1      active sync   /dev/sdb6

   2     2       8       38        2      active sync   /dev/sdc6

   3     3       8       54        3      active sync   /dev/sdd6

root@LS-QLF55:~#

 

 


------=_NextPart_000_004C_01CD0D15.DE0ADAA0
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><meta =
http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 14 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DEN-US link=3Dblue =
vlink=3Dpurple><div class=3DWordSection1><p class=3DMsoNormal>I have a =
Buffalo LS-QLF55 4TB Raid 5 box.&nbsp; It is out of warranty.&nbsp; It =
was using firmware 1.10.&nbsp; &nbsp;&nbsp;The unit stopped responding =
and would not power down through the web interface, nor the power button =
on the front of the unit.&nbsp; I unplugged the unit and plugged it back =
in.&nbsp; The unit now shows the drives as unformatted.&nbsp; I have =
provided some information below and would greatly appreciate some =
guidance as to what my next steps are to minimize my data loss.&nbsp; =
Any and all help is greatly appreciated.&nbsp; Thanks, =
Kirk<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# uname -a<o:p></o:p></p><p =
class=3DMsoNormal>Linux LS-QLF55 2.6.22.7 #395 Thu May 21 22:24:49 JST =
2009 armv5tejl unknown<o:p></o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~#<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# mount -t xfs /dev/md2 =
/mnt/array1<o:p></o:p></p><p class=3DMsoNormal>mount: mounting /dev/md2 =
on /mnt/array1 failed: Structure needs cleaning<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# mount -t xfs -o,ro,norecovery =
/dev/md2 /mnt/array1<o:p></o:p></p><p class=3DMsoNormal>mount: mounting =
/dev/md2 on /mnt/array1 failed: Structure needs =
cleaning<o:p></o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~#<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>Partial =
dmesg as it is lengthy.<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# dmesg<o:p></o:p></p><p =
class=3DMsoNormal>7:c6b86000 r6:00000000 r5:c6b85000 =
r4:00008000<o:p></o:p></p><p class=3DMsoNormal>[&lt;c0099098&gt;] =
(do_kern_mount+0x0/0xdc) from [&lt;c00aebdc&gt;] =
(do_mount+0x578/0x5c8)<o:p></o:p></p><p class=3DMsoNormal> r8:00008000 =
r7:c6b85000 r6:00000008 r5:00000000 r4:00000000<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c00ae664&gt;] (do_mount+0x0/0x5c8) from =
[&lt;c00aecb8&gt;] (sys_mount+0x8c/0xd4)<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c00aec2c&gt;] (sys_mount+0x0/0xd4) from =
[&lt;c0026f00&gt;] (ret_fast_syscall+0x0/0x2c)<o:p></o:p></p><p =
class=3DMsoNormal> r7:00000015 r6:00000000 r5:beba7abc =
r4:00000000<o:p></o:p></p><p class=3DMsoNormal>XFS: log mount/recovery =
failed: error 117<o:p></o:p></p><p class=3DMsoNormal>XFS: log mount =
failed<o:p></o:p></p><p class=3DMsoNormal>Filesystem &quot;md2&quot;: =
Disabling barriers, not supported by the underlying =
device<o:p></o:p></p><p class=3DMsoNormal>XFS mounting filesystem =
md2<o:p></o:p></p><p class=3DMsoNormal>Starting XFS recovery on =
filesystem: md2 (logdev: internal)<o:p></o:p></p><p =
class=3DMsoNormal>Filesystem &quot;md2&quot;: xfs_inode_recover: Bad =
inode magic number, dino ptr =3D 0xc6d2c000, dino bp =3D 0xc782fa80, ino =
=3D 256<o:p></o:p></p><p class=3DMsoNormal>Filesystem &quot;md2&quot;: =
XFS internal error xlog_recover_do_inode_trans(1) at line 2310 of file =
fs/xfs/xfs_log_recover.c.&nbsp; Caller 0xc017f368<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c002b758&gt;] (dump_stack+0x0/0x14) from =
[&lt;c01666fc&gt;] (xfs_error_report+0x54/0x64)<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c01666a8&gt;] (xfs_error_report+0x0/0x64) from =
[&lt;c017eb2c&gt;] =
(xlog_recover_do_inode_trans+0x28c/0x8ac)<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c017e8a0&gt;] =
(xlog_recover_do_inode_trans+0x0/0x8ac) from [&lt;c017f368&gt;] =
(xlog_recover_do_trans+0x80/0x154)<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c017f2e8&gt;] (xlog_recover_do_trans+0x0/0x154) =
from [&lt;c017f478&gt;] =
(xlog_recover_commit_trans+0x3c/0x54)<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c017f43c&gt;] =
(xlog_recover_commit_trans+0x0/0x54) from [&lt;c017f5f4&gt;] =
(xlog_recover_process_data+0x164/0x224)<o:p></o:p></p><p =
class=3DMsoNormal> r7:c725e204 r6:c0b802d8 r5:08be0000 =
r4:e5000000<o:p></o:p></p><p class=3DMsoNormal>[&lt;c017f490&gt;] =
(xlog_recover_process_data+0x0/0x224) from [&lt;c017f9b4&gt;] =
(xlog_do_recovery_pass+0x300/0x828)<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c017f6b4&gt;] (xlog_do_recovery_pass+0x0/0x828) =
from [&lt;c017ff54&gt;] =
(xlog_do_log_recovery+0x78/0x9c)<o:p></o:p></p><p =
class=3DMsoNormal>[&lt;c017fedc&gt;] (xlog_do_log_recovery+0x0/0x9c) =
from [&lt;c017ff98&gt;] (xlog_do_recover+0x20/0x138)<o:p></o:p></p><p =
class=3DMsoNormal> r9:00000000 r8:ad3a5038 r7:c0cb8aa0 r6:c0cb8aa0 =
r5:00000000<o:p></o:p></p><p =
class=3DMsoNormal>r4:0000be08<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# cat /proc/mdstat<o:p></o:p></p><p =
class=3DMsoNormal>Personalities : [raid0] [raid1] [raid6] [raid5] =
[raid4]<o:p></o:p></p><p class=3DMsoNormal>md2 : active raid5 sda6[0] =
sdd6[3] sdc6[2] sdb6[1]<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2906278656 blocks level =
5, 64k chunk, algorithm 2 [4/4] [UUUU]<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>md1 : active =
raid1 sda2[0] sdd2[3] sdc2[2] sdb2[1]<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5004160 blocks [4/4] =
[UUUU]<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>md10 : active raid1 sda5[0] sdd5[3] sdc5[2] =
sdb5[1]<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1003904 blocks [4/4] =
[UUUU]<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>md0 : active raid1 sda1[0] sdd1[3] sdc1[2] =
sdb1[1]<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1003904 blocks [4/4] =
[UUUU]<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>unused devices: &lt;none&gt;<o:p></o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~#<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# cat /proc/partitions<o:p></o:p></p><p =
class=3DMsoNormal>major minor&nbsp; #blocks&nbsp; name<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 976761527 sda<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp; 1004031 sda1<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp; 5004247 sda2<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp; =
4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 =
sda4<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp;&nbsp;&nbsp; 1004031 =
sda5<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp; 6&nbsp; 968759631 sda6<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 16&nbsp; 976761527 =
sdb<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; =
17&nbsp;&nbsp;&nbsp; 1004031 sdb1<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 18&nbsp;&nbsp;&nbsp; =
5004247 sdb2<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp; =
20&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 =
sdb4<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; =
21&nbsp;&nbsp;&nbsp; 1004031 sdb5<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 22&nbsp; 968759631 =
sdb6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; =
32&nbsp; 976761527 sdc<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp; 33&nbsp;&nbsp;&nbsp; 1004031 sdc1<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 34&nbsp;&nbsp;&nbsp; =
5004247 sdc2<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp; =
36&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 =
sdc4<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; =
37&nbsp;&nbsp;&nbsp; 1004031 sdc5<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp; &nbsp;&nbsp;38&nbsp; 968759631 =
sdc6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; =
48&nbsp; 976762584 sdd<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp; 49&nbsp;&nbsp;&nbsp; 1004031 sdd1<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 50&nbsp;&nbsp;&nbsp; =
5004247 sdd2<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp; =
52&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 =
sdd4<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; =
53&nbsp;&nbsp;&nbsp; 1004031 sdd5<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp; 54&nbsp; 968759631 =
sdd6<o:p></o:p></p><p class=3DMsoNormal>&nbsp; =
31&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
256 mtdblock0<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
9&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 1003904 =
md0<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; 9&nbsp;&nbsp;&nbsp; =
10&nbsp;&nbsp;&nbsp; 1003904 md10<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 9&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp; 5004160 md1<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 9&nbsp;&nbsp;&nbsp;&nbsp; 2 2906278656 =
md2<o:p></o:p></p><p class=3DMsoNormal>root@LS-QLF55:~#<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# mdadm --examine =
/dev/sda6<o:p></o:p></p><p class=3DMsoNormal>/dev/sda6:<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Magic : a92b4efc<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Version : =
00.90.00<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; UUID : 89944e67:449d284c:d2881af4:19e5a1cb<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp; Creation Time : Thu Feb 26 20:33:41 =
2009<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Raid =
Level : raid5<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp; =
Device Size : 968759552 (923.88 GiB 992.01 GB)<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Array Size : 2906278656 =
(2771.64 GiB 2976.03 GB)<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
Raid Devices : 4<o:p></o:p></p><p class=3DMsoNormal>&nbsp; Total Devices =
: 4<o:p></o:p></p><p class=3DMsoNormal>Preferred Minor : =
2<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp; Update Time : Wed Mar 28 07:28:40 =
2012<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
State : clean<o:p></o:p></p><p class=3DMsoNormal> Active Devices : =
4<o:p></o:p></p><p class=3DMsoNormal>Working Devices : =
4<o:p></o:p></p><p class=3DMsoNormal> Failed Devices : =
0<o:p></o:p></p><p class=3DMsoNormal>&nbsp; Spare Devices : =
0<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Checksum : =
36a3ffda - correct<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Events : 0.12<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Layout : left-symmetric<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Chunk Size : =
64K<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Number&nbsp;&nbsp; =
Major&nbsp;&nbsp; Minor&nbsp;&nbsp; RaidDevice State<o:p></o:p></p><p =
class=3DMsoNormal>this&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sda6<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sda6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
22&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdb6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; 2 =
&nbsp;&nbsp;&nbsp;&nbsp;2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
38&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdc6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
54&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdd6<o:p></o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~#<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# mdadm --examine =
/dev/sdb6<o:p></o:p></p><p class=3DMsoNormal>/dev/sdb6:<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Magic : a92b4efc<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Version : =
00.90.00<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;UUID : =
89944e67:449d284c:d2881af4:19e5a1cb<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp; Creation Time : Thu Feb 26 20:33:41 =
2009<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Raid =
Level : raid5<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp; =
Device Size : 968759552 (923.88 GiB 992.01 GB)<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Array Size : 2906278656 =
(2771.64 GiB 2976.03 GB)<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
Raid Devices : 4<o:p></o:p></p><p class=3DMsoNormal>&nbsp; Total Devices =
: 4<o:p></o:p></p><p class=3DMsoNormal>Preferred Minor : =
2<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp; Update Time : Wed Mar 28 07:28:40 =
2012<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
State : clean<o:p></o:p></p><p class=3DMsoNormal> Active Devices : =
4<o:p></o:p></p><p class=3DMsoNormal>Working Devices : =
4<o:p></o:p></p><p class=3DMsoNormal> Failed Devices : =
0<o:p></o:p></p><p class=3DMsoNormal>&nbsp; Spare Devices : =
0<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Checksum : =
36a3ffec - correct<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Events : 0.12<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Layout : left-symmetric<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Chunk Size : =
64K<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Number&nbsp;&nbsp; =
Major&nbsp;&nbsp; Minor&nbsp;&nbsp; RaidDevice State<o:p></o:p></p><p =
class=3DMsoNormal>this&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
22&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdb6<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sda6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
22&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;active sync&nbsp;&nbsp; /dev/sdb6<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
38&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdc6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
54&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdd6<o:p></o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~#<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# mdadm --examine =
/dev/sdc6<o:p></o:p></p><p class=3DMsoNormal>/dev/sdc6:<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Magic : a92b4efc<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Version : =
00.90.00<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; UUID : 89944e67:449d284c:d2881af4:19e5a1cb<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp; Creation Time : Thu Feb 26 20:33:41 =
2009<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Raid =
Level : raid5<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp; =
Device Size : 968759552 (923.88 GiB 992.01 GB)<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Array Size : 2906278656 =
(2771.64 GiB 2976.03 GB)<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
Raid Devices : 4<o:p></o:p></p><p class=3DMsoNormal>&nbsp; Total Devices =
: 4<o:p></o:p></p><p class=3DMsoNormal>Preferred Minor : =
2<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp; Update Time : Wed Mar 28 07:28:40 =
2012<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
State : clean<o:p></o:p></p><p class=3DMsoNormal> Active Devices : =
4<o:p></o:p></p><p class=3DMsoNormal>Working Devices : =
4<o:p></o:p></p><p class=3DMsoNormal> Failed Devices : =
0<o:p></o:p></p><p class=3DMsoNormal>&nbsp; Spare Devices : =
0<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Checksum : =
36a3fffe - correct<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Events : 0.12<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Layout : left-symmetric<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Chunk Size : =
64K<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Number&nbsp;&nbsp; =
Major&nbsp;&nbsp; Minor&nbsp;&nbsp; RaidDevice State<o:p></o:p></p><p =
class=3DMsoNormal>this&nbsp;&nbsp;&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
38&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdc6<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sda6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
22&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdb6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
38&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdc6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
54&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdd6<o:p></o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~#<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~# mdadm --examine =
/dev/sdd6<o:p></o:p></p><p class=3DMsoNormal>/dev/sdd6:<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Magic : a92b4efc<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Version : =
00.90.00<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; UUID : 89944e67:449d284c:d2881af4:19e5a1cb<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp; Creation Time : Thu Feb 26 20:33:41 =
2009<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Raid =
Level : raid5<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp;&nbsp; =
Device Size : 968759552 (923.88 GiB 992.01 GB)<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Array Size : 2906278656 =
(2771.64 GiB 2976.03 GB)<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
Raid Devices : 4<o:p></o:p></p><p class=3DMsoNormal>&nbsp; Total Devices =
: 4<o:p></o:p></p><p class=3DMsoNormal>Preferred Minor : =
2<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp; Update Time : Wed Mar 28 07:28:40 =
2012<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
State : clean<o:p></o:p></p><p class=3DMsoNormal> Active Devices : =
4<o:p></o:p></p><p class=3DMsoNormal>Working Devices : =
4<o:p></o:p></p><p class=3DMsoNormal> Failed Devices : =
0<o:p></o:p></p><p class=3DMsoNormal>&nbsp; Spare Devices : =
0<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Checksum : =
36a40010 - correct<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Events : 0.12<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
Layout : left-symmetric<o:p></o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp; Chunk Size : =
64K<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Number&nbsp;&nbsp; =
Major&nbsp;&nbsp; Minor&nbsp;&nbsp; RaidDevice State<o:p></o:p></p><p =
class=3DMsoNormal>this&nbsp;&nbsp;&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
54&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdd6<o:p></o:p></p><p class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal>&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sda6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
22&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdb6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
38&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdc6<o:p></o:p></p><p class=3DMsoNormal>&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
54&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; active sync&nbsp;&nbsp; =
/dev/sdd6<o:p></o:p></p><p =
class=3DMsoNormal>root@LS-QLF55:~#<o:p></o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p><p =
class=3DMsoNormal><o:p>&nbsp;</o:p></p></div></body></html>
------=_NextPart_000_004C_01CD0D15.DE0ADAA0--


--===============1794269173095748791==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1794269173095748791==--
