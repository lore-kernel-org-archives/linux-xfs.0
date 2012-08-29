Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7TIWRVq054489 for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 13:32:27 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id RbzNBs1C8Ghvljzb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 29 Aug 2012 11:33:18 -0700 (PDT)
Received: by dadg9 with SMTP id g9so795766dad.26
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2012 11:33:18 -0700 (PDT)
From: Blair Sonnen <blair.sonnen@gmail.com>
Subject: XFS or MDADM issue?
Message-Id: <EEB5584C-116B-4D39-8765-D3ED0F982B98@gmail.com>
Date: Wed, 29 Aug 2012 12:33:14 -0600
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8300200094496826805=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8300200094496826805==
Content-Type: multipart/alternative; boundary="Apple-Mail=_146D8E69-B5E4-46CE-9761-E9EF4483FDBC"


--Apple-Mail=_146D8E69-B5E4-46CE-9761-E9EF4483FDBC
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


Greetings.  I do not know where to inquire next for my issue and I would =
appreciate it if anyone could suggest something to potentially help =
regarding XFS.  I have already submitted this bug report to mdadm on =
5/31 (http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D675394#5), with =
no updates as of yet. =20

Please read my bug report and let me know if I should be considering =
this a potential XFS issue.  Thank you for any help you may lend and =
your time!




-Blair Sonnen

blair.sonnen@gmail.com
801.696.4353





--Apple-Mail=_146D8E69-B5E4-46CE-9761-E9EF4483FDBC
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_E1204288-79FB-41BE-A9B3-0F88876A8DFB"


--Apple-Mail=_E1204288-79FB-41BE-A9B3-0F88876A8DFB
Content-Transfer-Encoding: 7bit
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv="Content-Type" content="text/html charset=us-ascii"></head><body style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space; "><div><br></div><div>Greetings. &nbsp;I do not know where to inquire next for my issue and I would appreciate it if anyone could suggest something to potentially help regarding XFS. &nbsp;I have already submitted this bug report to mdadm on 5/31 (<a href="http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=675394#5">http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=675394#5</a>), with no updates as of yet. &nbsp;</div><div><br></div><div>Please read my bug report and let me know if I should be considering this a potential XFS issue. &nbsp;Thank you for any help you may lend and your time!</div><div><br></div><div></div></body></html>
--Apple-Mail=_E1204288-79FB-41BE-A9B3-0F88876A8DFB
Content-Disposition: attachment;
	filename=Debian_reportbug_PCS.txt
Content-Type: text/plain;
	name="Debian_reportbug_PCS.txt"
Content-Transfer-Encoding: quoted-printable


Bottom line: since growing my raid array, and switching raid levels =
using MDADM, I am unable to successfully copy a file to my array.  The =
resulting file always has different md5sum values from the original =
file, and is corrupted.=20

In addition to this, it appears that all files on my raid array have =
different md5sums after this procedure.

File System: XFS
mdadm --detail /dev/md127
=
--------------------------------------------------------------------------=
----------------------------------------------------------
/dev/md127:
        Version : 0.90
  Creation Time : Sun Jan 25 22:44:41 2009
     Raid Level : raid6
     Array Size : 8790815616 (8383.58 GiB 9001.80 GB)
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
   Raid Devices : 8
  Total Devices : 8
Preferred Minor : 127
    Persistence : Superblock is persistent

    Update Time : Mon May  7 00:51:55 2012
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : d861d754:1a1065fe:c230666b:5103eba0
         Events : 0.386680

    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8      113        3      active sync   /dev/sdh1
       4       8       17        4      active sync   /dev/sdb1
       5       8       96        5      active sync   /dev/sdg
       6       8       80        6      active sync   /dev/sdf
       7       8       64        7      active sync   /dev/sde
=
--------------------------------------------------------------------------=
------------------------------------------------------------------

This raid re-arrangement was done the following way:

1) Started with 5 devices in raid 5 array, functioning correctly.=20
2) <Shutdown -h>
3) Installed 3 additional hard disks, all same manufacturer and size, =
however newer firmware. I verified the firmware was compatible via the =
manufacturers website.
4) Booted up, determined device names
5) successfully Added the drives to the array, by :<mdadm /dev/md127 =
--add /dev/sdg> etc. =20
6) successfully grew the array <mdadm --grow /dev/md127 -n 8 -l 6>, took =
a very long time as expected
7) successfully resized the file system <xfs_growfs -d /dev/md127>

Then, I started noticing problems with files on the array.  =
Specifically, the md5sums from the files on the raid array no longer =
matched the original md5sums from files copied to the array prior to the =
above commands.

I figured I would confirm the problem with the following test procedure:

1) mkdir Test_Files/
2) dd if=3D/dev/urandom bs=3D1024 count=3D5000000 of=3D5GB_Rand,
   dd if=3D/dev/zero bs=3D1024 count=3D5000000 of=3D5GB_Zero
3) md5sum test:

Original Test Files created on Boot Drive

blair@debian:~$ md5sum /home/blair/Test_Files/5GB_Rand=C2=A0
0fed0abb19ea7962830e54108631ddac =C2=A0/home/blair/Test_Files/5GB_Rand

blair@debian:~$ md5sum /home/blair/Test_Files/5GB_Zero
20096e4b3b80a3896dec3d7fdf5d1bfc =C2=A0/home/blair/Test_Files/5GB_Zero

4) Copied files to /dev/md127 raid array
5) md5sum test on copied files:

blair@debian:~$ md5sum /mnt/movies/Test_Files/5GB_Rand=C2=A0
419175a78977007f3d5e97dcaf414b61 =C2=A0/mnt/movies/Test_Files/5GB_Rand

blair@debian:~$ md5sum /mnt/movies/Test_Files/5GB_Zero
5846bed2b52532719d4812172a8078ce =C2=A0/mnt/movies/Test_Files/5GB_Zero

6) Copied files from md/127 array back to Boot Drive
7) md5sum test:

blair@debian:~$ md5sum /home/blair/Test_Files/Test_Files_Copy/5GB_Rand=C2=A0=

419175a78977007f3d5e97dcaf414b61 =
=C2=A0/home/blair/Test_Files/Test_Files_Copy/5GB_Rand

blair@debian:~$ md5sum /home/blair/Test_Files/Test_Files_Copy/5GB_Zero
5846bed2b52532719d4812172a8078ce =
=C2=A0/home/blair/Test_Files/Test_Files_Copy/5GB_Zero


I am not sure what I have done in the process that would have created =
this problem.  I am filing this bug report to mdadm because I have =
successfully grown my raid in the past, using mdadm with the XFS =
filesystem. In that instance it was from 4 devices to 5 devices, both on =
raid 5 (no level switch), and growing the xfs filesystem accordingly.  =
These file problems started as soon as I executed the recent grow to 8 =
devices and level 6 as indicated above. =20

In order to install three extra drives, I installed an internal Sata =
host adapter, as my board only had 6 Sata ports integrated.  Not sure =
this is relevant. =20





=20





--Apple-Mail=_E1204288-79FB-41BE-A9B3-0F88876A8DFB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
"><div></div><div><br></div><br><div apple-content-edited=3D"true">
<span class=3D"Apple-style-span" style=3D"border-collapse: separate; =
color: rgb(0, 0, 0); font-family: 'Helvetica Neue'; font-style: normal; =
font-variant: normal; font-weight: normal; letter-spacing: normal; =
line-height: normal; orphans: 2; text-align: auto; text-indent: 0px; =
text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; =
-webkit-border-horizontal-spacing: 0px; -webkit-border-vertical-spacing: =
0px; -webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; font-size: medium; "><span =
class=3D"Apple-style-span" style=3D"border-collapse: separate; color: =
rgb(0, 0, 0); font-family: 'Helvetica Neue'; font-size: medium; =
font-style: normal; font-variant: normal; font-weight: normal; =
letter-spacing: normal; line-height: normal; orphans: 2; text-indent: =
0px; text-transform: none; white-space: normal; widows: 2; word-spacing: =
0px; -webkit-border-horizontal-spacing: 0px; =
-webkit-border-vertical-spacing: 0px; =
-webkit-text-decorations-in-effect: none; -webkit-text-size-adjust: =
auto; -webkit-text-stroke-width: 0px; "><div style=3D"word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; ">-Blair Sonnen<br><br><a =
href=3D"mailto:blair.sonnen@gmail.com">blair.sonnen@gmail.com</a><br>801.6=
96.4353<br><br><br><br></div></span></span>
</div>

<br></body></html>=

--Apple-Mail=_E1204288-79FB-41BE-A9B3-0F88876A8DFB--

--Apple-Mail=_146D8E69-B5E4-46CE-9761-E9EF4483FDBC--


--===============8300200094496826805==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8300200094496826805==--
