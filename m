Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0CF6D7F47
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 11:50:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4665DAC002
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 09:50:41 -0700 (PDT)
Received: from pp-mta2.drexelmed.edu ([198.17.30.173]) by cuda.sgi.com with
	ESMTP id Zqg7TIJl7Jf3qsjg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2015 09:50:35 -0700 (PDT)
Received: from pps.filterd (pp-mta2.drexelmed.edu [127.0.0.1])
	by pp-mta2.drexelmed.edu (8.15.0.59/8.14.7) with SMTP id t8GGnrI7032503
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 12:50:34 -0400
Received: from ncb-sv-103.ducom.edu ([10.16.20.136])
	by pp-mta2.drexelmed.edu with ESMTP id 1wyb6sr4sv-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2015 12:50:33 -0400
From: "Earl, Joshua P" <Joshua.Earl@DrexelMed.edu>
Subject: RE: xfsxyncd in 'D' state
Date: Wed, 16 Sep 2015 16:50:29 +0000
Message-ID: <2CC86DBF85FEEC41A2DFE1647B40613D5DAF2CA0@NCB-SV-117.DUCOM.edu>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3754353935003665871=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3754353935003665871==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_2CC86DBF85FEEC41A2DFE1647B40613D5DAF2CA0NCBSV117DUCOMed_"

--_000_2CC86DBF85FEEC41A2DFE1647B40613D5DAF2CA0NCBSV117DUCOMed_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I was also able to get the xfs_info after finally getting the drive remount=
ed:

[root@ncb-sv-016 ~]# xfs_info /home
meta-data=3D/dev/sdb1              isize=3D256    agcount=3D70, agsize=3D26=
8435455 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D0
data     =3D                       bsize=3D4096   blocks=3D18554637056, ima=
xpct=3D1
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

From: Earl, Joshua P
Sent: Tuesday, September 15, 2015 1:53 PM
To: 'xfs@oss.sgi.com' <xfs@oss.sgi.com>
Subject: xfsxyncd in 'D' state

Hello, I hope I'm writing to the correct list.  I've recently run into a pr=
oblem, which has me stumped.  I'm running a cluster which shares an xfs fil=
esystem to 10 nodes via nfs.  This has been working for almost two years.  =
However, I've been running into trouble with the drive where if anything tr=
ies to write to it at certain times it will simply hang, and every process =
trying to write will also hang and go into the 'D' state.  For example (jus=
t editing a text file with emacs):

[root@ncb-sv-016 ~]# ps aux|grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      2216  0.0  0.0      0     0 ?        D    11:28   0:00 [xfssyncd/=
sdb1]
archana   7708  0.0  0.0 249700 13352 pts/0    D    11:35   0:00 emacs thin=
gs
root     11453  0.0  0.0 103312   868 pts/1    S+   12:47   0:00 grep D

This will remain like this for hours.  Can't remount/unmount drive (sends t=
he unmount command into 'D' state)

I have no idea what's going on or how to fix it, but I'm hoping you guys mi=
ght be able to point me in the right direction. Here is the info that's req=
uested in the FAQ:
?  kernel version (uname -a)
Linux ncb-sv-016.ducom.edu 2.6.32-358.23.2.el6.x86_64 #1 SMP Wed Oct 16 18:=
37:12 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
?  xfsprogs version (xfs_repair -V)
xfs_repair version 3.1.1
?  number of CPUs
16
?  contents of /proc/meminfo
?  contents of /proc/mounts
?  contents of /proc/partitions
Attached except for mounts (not currently in the /proc directory, attached =
the fstab instead (hopefully helpful?)
?  RAID layout (hardware and/or software) The RAID-6 is the problem one
Unit  UnitType  Status         %RCmpl  %V/I/M  Stripe  Size(GB)  Cache  AVr=
fy
---------------------------------------------------------------------------=
---
u0    RAID-1    OK             -       -       -       3725.28   RiW    ON
u1    RAID-6    OK             -       -       64K     70780.3   RiW    ON
u2    SPARE     OK             -       -       -       3726.01   -      OFF

VPort Status         Unit Size      Type  Phy Encl-Slot    Model
---------------------------------------------------------------------------=
---
p8    OK             u0   3.63 TB   SATA  -   /c0/e0/slt0  WDC WD4000FYYZ-0=
1UL
p9    OK             u1   3.63 TB   SATA  -   /c0/e0/slt4  WDC WD4000FYYZ-0=
1UL
p10   OK             u1   3.63 TB   SATA  -   /c0/e0/slt8  WDC WD4000FYYZ-0=
1UL
p11   OK             u1   3.63 TB   SATA  -   /c0/e0/slt12 WDC WD4000FYYZ-0=
1UL
p12   OK             u1   3.63 TB   SATA  -   /c0/e0/slt16 WDC WD4000FYYZ-0=
1UL
p13   OK             u1   3.63 TB   SATA  -   /c0/e0/slt20 WDC WD4000FYYZ-0=
1UL
p14   OK             u0   3.63 TB   SATA  -   /c0/e0/slt1  WDC WD4000FYYZ-0=
1UL
p15   OK             u1   3.63 TB   SATA  -   /c0/e0/slt5  WDC WD4000FYYZ-0=
1UL
p16   OK             u1   3.63 TB   SATA  -   /c0/e0/slt9  WDC WD4000FYYZ-0=
1UL
p17   OK             u1   3.63 TB   SATA  -   /c0/e0/slt13 WDC WD4000FYYZ-0=
1UL
p18   OK             u1   3.63 TB   SATA  -   /c0/e0/slt17 WDC WD4000FYYZ-0=
1UL
p19   OK             u1   3.63 TB   SATA  -   /c0/e0/slt21 WDC WD4000FYYZ-0=
1UL
p20   OK             u1   3.63 TB   SATA  -   /c0/e0/slt2  WDC WD4000FYYZ-0=
1UL
p21   OK             u1   3.63 TB   SATA  -   /c0/e0/slt6  WDC WD4000FYYZ-0=
1UL
p22   OK             u1   3.63 TB   SATA  -   /c0/e0/slt10 WDC WD4000FYYZ-0=
1UL
p23   OK             u1   3.63 TB   SATA  -   /c0/e0/slt14 WDC WD4000FYYZ-0=
1UL
p24   OK             u1   3.63 TB   SATA  -   /c0/e0/slt18 WDC WD4000FYYZ-0=
1UL
p25   OK             u1   3.63 TB   SATA  -   /c0/e0/slt22 WDC WD4000FYYZ-0=
1UL
p26   OK             u1   3.63 TB   SATA  -   /c0/e0/slt3  WDC WD4000FYYZ-0=
1UL
p27   OK             u1   3.63 TB   SATA  -   /c0/e0/slt7  WDC WD4000FYYZ-0=
1UL
p28   OK             u1   3.63 TB   SATA  -   /c0/e0/slt11 WDC WD4000FYYZ-0=
1UL
p29   OK             u1   3.63 TB   SATA  -   /c0/e0/slt15 WDC WD4000FYYZ-0=
1UL
p30   OK             u1   3.63 TB   SATA  -   /c0/e0/slt19 WDC WD4000FYYZ-0=
1UL
p31   OK             u2   3.63 TB   SATA  -   /c0/e0/slt23 WDC WD4000FYYZ-0=
1UL
?  LVM configuration
I don't *think* these are in an LVM.. I could be wrong.
?  type of disks you are using
Models included above in raid config.
?  write cache status of drives
?  size of BBWC and mode it is running in
?  xfs_info output on the filesystem in question
For the above three questions I'm not sure how to get the the cache status =
of the drives, or what the BBWC is? xfs_info won't currently run (I'm waiti=
ng on the drive to unmount) but I ran an xfs_check and an xfs_repair -n and=
 no errors were shown.
?  dmesg output showing all error messages and stack traces
Then you need to describe your workload that is causing the problem, and a =
demonstration of the bad behaviour that is occurring. If it is a performanc=
e problem, then 30s - 1 minute samples of:
1.    iostat -x -d -m 5
[root@ncb-sv-016 ~]# iostat -x -d -m 5
Linux 2.6.32-358.23.2.el6.x86_64 (ncb-sv-016.ducom.edu)       09/15/2015   =
 _x86_64_      (16 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.29     3.61    5.78    3.58     0.10     0.03    28.27 =
    0.05    5.19   2.39   2.24
sdb               1.02     8.66   31.50    3.91     0.33     0.12    26.14 =
    5.94  167.54  27.47  97.25

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     1.60    0.00    2.00     0.00     0.01    14.40 =
    0.01    4.30   4.30   0.86
sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00 =
    6.46 6332.75 1250.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     3.60    0.00    7.00     0.00     0.04    12.11 =
    0.02    0.60   1.77   1.24
sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00 =
    6.28 6256.60 1000.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.40     0.00     0.00     8.00 =
    0.00   42.50  12.00   0.48
sdb               0.00     0.00    0.00    1.20     0.00     0.04    64.00 =
    5.86 5846.33 833.33 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     0.60    0.00    0.60     0.00     0.00    16.00 =
    0.01   12.67  12.67   0.76
sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00 =
    6.86 5725.20 1000.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00 =
    0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00 =
    6.06 5459.00 1000.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     4.00    0.00    1.60     0.00     0.02    26.00 =
    0.01    6.75   6.50   1.04
sdb               0.00     0.00    0.00    1.00     0.00     0.03    51.20 =
    7.05 5670.40 1000.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00    29.40    0.00    2.60     0.00     0.12    98.46 =
    0.01    4.54   4.08   1.06
sdb               0.00     0.00    0.00    1.20     0.00     0.03    53.33 =
    6.54 7428.50 833.33 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     9.60    0.00   15.80     0.00     0.10    12.86 =
    0.57   35.82   3.37   5.32
sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00 =
    6.30 5889.20 1000.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     7.80    0.00   12.80     0.00     0.08    12.38 =
    0.74   58.09  15.06  19.28
sdb               0.00     0.00    0.00    1.20     0.00     0.04    64.00 =
    6.49 6140.83 833.33 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     4.80    0.00    3.20     0.00     0.03    20.00 =
    0.01    0.06   3.12   1.00
sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00 =
    5.10 6489.25 1250.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.20     0.00     0.00     8.00 =
    0.02  152.00 103.00   2.06
sdb               0.00     0.00    0.00    1.00     0.00     0.03    64.00 =
    6.75 5791.00 1000.20 100.02

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00    61.20    0.00   11.80     0.00     0.29    49.49 =
    0.01    0.88   0.69   0.82
sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00 =
    6.37 5569.71 714.14  99.98

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     0.40    0.00    0.60     0.00     0.00    13.33 =
    0.01   24.33  24.33   1.46
sdb               0.00     0.00    0.00    1.60     0.00     0.05    64.00 =
    5.77 5162.00 625.12 100.02

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.40     0.00     0.00     8.00 =
    0.00    3.00   1.50   0.06
sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00 =
    5.08 3428.50 1250.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     1.60    0.00    0.80     0.00     0.01    24.00 =
    0.01   10.75  10.75   0.86
sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00 =
    5.86 3932.14 714.29 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     2.00    0.00    4.80     0.00     0.03    11.33 =
    0.01    2.21   2.08   1.00
sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00 =
    5.60 3992.71 714.29 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     5.00    0.00   18.20     0.00     0.09    10.20 =
    0.02    1.13   0.03   0.06
sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00 =
    5.44 4208.86 714.29 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     1.40    0.00    0.60     0.00     0.01    26.67 =
    0.02   27.00  27.00   1.62
sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00 =
    5.22 4325.43 714.29 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     0.60    0.00    0.40     0.00     0.00    20.00 =
    0.01   15.50  15.50   0.62
sdb               0.00     0.00    0.00    1.60     0.00     0.05    64.00 =
    5.06 4022.75 625.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00 =
    0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.80     0.00     0.03    64.00 =
    5.08 3495.50 1250.00 100.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz =
avgqu-sz   await  svctm  %util
sda               0.00     1.60    0.00    1.60     0.00     0.01    12.00 =
    0.07   42.88  42.50   6.80
sdb               0.00     0.00    0.00    1.40     0.00     0.04    64.00 =
    5.82 3894.71 714.29 100.00
2.    vmstat 5
[root@ncb-sv-016 ~]# vmstat 5
procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu=
-----
r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id w=
a st
0  0      0 126125768  19456 405396    0    0    28    10  421  150  0  0 9=
9  0  0
0  0      0 126125520  19464 405396    0    0     0    34 6679 13281  0  0 =
100  0  0
1  0      0 126124896  19472 405392    0    0     0    38 6718 13310  0  0 =
100  0  0
0  0      0 126125312  19472 405400    0    0     0    74 6658 13256  0  0 =
100  0  0
0  0      0 126125440  19480 405392    0    0     0    60 6664 13291  0  0 =
100  0  0
2  0      0 126125440  19480 405400    0    0     0    26 6660 13272  0  0 =
100  0  0
0  0      0 126125680  19488 405400    0    0     0    30 6659 13282  0  0 =
100  0  0
2  0      0 126125696  19496 405396    0    0     0   117 6686 13298  0  0 =
100  0  0
1  0      0 126125568  19496 405400    0    0     0    33 6661 13287  0  0 =
100  0  0
0  0      0 126125816  19504 405400    0    0     0    30 6663 13271  0  0 =
100  0  0
1  0      0 126125816  19504 405400    0    0     0    27 6659 13285  0  0 =
100  0  0
0  0      0 126125696  19512 405400    0    0     0    75 6670 13269  0  0 =
100  0  0
0  0      0 126125816  19520 405400    0    0     0    55 6671 13286  0  0 =
100  0  0
2  0      0 126125696  19528 405396    0    0     0    34 6670 13284  0  0 =
100  0  0
0  0      0 126125272  19528 405400    0    0     0    26 6700 13298  0  0 =
100  0  0
0  0      0 126125408  19536 405400    0    0     0    61 6660 13277  0  0 =
100  0  0
1  0      0 126125536  19544 405392    0    0     0    98 6677 13281  0  0 =
100  0  0
can give us insight into the IO and memory utilisation of your machine at t=
he time of the problem.
If the filesystem is hanging, then capture the output of the dmesg command =
after running:
# echo w > /proc/sysrq-trigger
# dmesg
will tell us all the hung processes in the machine, often pointing us direc=
tly to the cause of the hang.
Attached

Thanks!

Josh Earl, MS
Research Instructor
Drexel College of Medicine
Center for Advanced Microbial Processing (CAMP)
Institute of Molecular Medicine and Infectious Disease
(215) 762-8133

________________________________

This email and any accompanying attachments are confidential. The informati=
on is intended solely for the use of the individual to whom it is addressed=
. Any review, disclosure, copying, distribution, or use of this email commu=
nication by others is strictly prohibited. If you are not the intended reci=
pient, please notify the sender immediately and delete all copies. Thank yo=
u for your cooperation.

--_000_2CC86DBF85FEEC41A2DFE1647B40613D5DAF2CA0NCBSV117DUCOMed_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Consolas;
	panose-1:2 11 6 9 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
p
	{mso-style-priority:99;
	mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman",serif;}
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";}
span.EmailStyle20
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.EmailStyle21
	{mso-style-type:personal-reply;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:859009705;
	mso-list-template-ids:-53680196;}
@list l0:level1
	{mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level2
	{mso-level-tab-stop:1.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level3
	{mso-level-tab-stop:1.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level4
	{mso-level-tab-stop:2.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level5
	{mso-level-tab-stop:2.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level6
	{mso-level-tab-stop:3.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level7
	{mso-level-tab-stop:3.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level8
	{mso-level-tab-stop:4.0in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l0:level9
	{mso-level-tab-stop:4.5in;
	mso-level-number-position:left;
	text-indent:-.25in;}
@list l1
	{mso-list-id:1937398149;
	mso-list-template-ids:972035278;}
@list l1:level1
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1:level2
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:1.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:1.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:2.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1:level5
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:2.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:3.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:3.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1:level8
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:4.0in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
@list l1:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:4.5in;
	mso-level-number-position:left;
	text-indent:-.25in;
	mso-ansi-font-size:10.0pt;
	font-family:Wingdings;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span style=3D"color:#1F497D">I was also able to get=
 the xfs_info after finally getting the drive remounted:<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">[=
root@ncb-sv-016 ~]# xfs_info /home<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">m=
eta-data=3D/dev/sdb1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; isize=3D256&nbsp;&nbsp;&nbsp; agcount=3D70, agsize=
=3D268435455 blks<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=3D512&nbsp;&nbsp; attr=3D2, projid=
32bit=3D0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">d=
ata&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; blocks=3D18554637056, imaxpct=3D1<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sunit=3D0&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;s=
width=3D0 blks<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">n=
aming&nbsp;&nbsp; =3Dversion 2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp;&nbsp; ascii-ci=3D0<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">l=
og&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3Dinternal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; bsize=3D4096&nbsp;&nb=
sp; blocks=3D521728, version=3D2<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sectsz=3D512&nbsp;&nbsp; sunit=3D0 blks, =
lazy-count=3D1<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas;color:#1F497D">r=
ealtime =3Dnone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; extsz=3D4096&nbsp;&nbsp; b=
locks=3D0, rtextents=3D0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"color:#1F497D"><o:p>&nbsp;</o:p></spa=
n></p>
<div>
<div style=3D"border:none;border-top:solid #E1E1E1 1.0pt;padding:3.0pt 0in =
0in 0in">
<p class=3D"MsoNormal"><b>From:</b> Earl, Joshua P <br>
<b>Sent:</b> Tuesday, September 15, 2015 1:53 PM<br>
<b>To:</b> 'xfs@oss.sgi.com' &lt;xfs@oss.sgi.com&gt;<br>
<b>Subject:</b> xfsxyncd in 'D' state<o:p></o:p></p>
</div>
</div>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Hello, I hope I&#8217;m writing to the correct list.=
&nbsp; I&#8217;ve recently run into a problem, which has me stumped.&nbsp; =
I&#8217;m running a cluster which shares an xfs filesystem to 10 nodes via =
nfs.&nbsp; This has been working for almost two years.&nbsp; However, I&#82=
17;ve
 been running into trouble with the drive where if anything tries to write =
to it at certain times it will simply hang, and every process trying to wri=
te will also hang and go into the &#8216;D&#8217; state.&nbsp; For example =
(just editing a text file with emacs):<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas">[root@ncb-sv-01=
6 ~]# ps aux|grep D<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas">USER&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp; PID %CPU %MEM&nbsp;&nbsp;&nbsp; VSZ&nbsp;&nbsp; R=
SS TTY&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; STAT START&nbsp;&nbsp; TIME COMMAND<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas">root&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; 2216&nbsp; 0.0&nbsp; 0.0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
0&nbsp;&nbsp;&nbsp;&nbsp; 0 ?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D&n=
bsp;&nbsp;&nbsp; 11:28&nbsp;&nbsp; 0:00 [xfssyncd/sdb1]<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas">archana&nbsp;&n=
bsp; 7708&nbsp; 0.0&nbsp; 0.0 249700 13352 pts/0&nbsp;&nbsp;&nbsp; D&nbsp;&=
nbsp;&nbsp; 11:35&nbsp;&nbsp; 0:00 emacs things<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas">root&nbsp;&nbsp=
;&nbsp;&nbsp; 11453&nbsp; 0.0&nbsp; 0.0 103312&nbsp;&nbsp; 868 pts/1&nbsp;&=
nbsp;&nbsp; S&#43;&nbsp;&nbsp; 12:47&nbsp;&nbsp; 0:00 grep D<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span style=3D"font-family:Consolas"><o:p>&nbsp;</o:=
p></span></p>
<p class=3D"MsoNormal">This will remain like this for hours.&nbsp; Can&#821=
7;t remount/unmount drive (sends the unmount command into &#8216;D&#8217; s=
tate)<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I have no idea what&#8217;s going on or how to fix i=
t, but I&#8217;m hoping you guys might be able to point me in the right dir=
ection. Here is the info that&#8217;s requested in the FAQ:<o:p></o:p></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">kernel version (uname -a)<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">Linux ncb-sv-016.ducom.edu 2.6.32-358.23.2.el6.x86_64 #1 SMP Wed =
Oct 16 18:37:12 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux<o:p></o:p></span></=
p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">xfsprogs version (xfs_repair -V)<o=
:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">xfs_repair version 3.1.1<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">number of CPUs<o:p></o:p></span></=
p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">16<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">contents of /proc/meminfo<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">contents of /proc/mounts<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">contents of /proc/partitions<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">Attached except for mounts (not currently in the /proc directory,=
 attached the fstab instead (hopefully helpful?)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">RAID layout (hardware and/or softw=
are) The RAID-6 is the problem one<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Unit&nbsp;=
 UnitType&nbsp; Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; %RCm=
pl&nbsp; %V/I/M&nbsp; Stripe&nbsp; Size(GB)&nbsp; Cache&nbsp; AVrfy<o:p></o=
:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">----------=
--------------------------------------------------------------------<o:p></=
o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">u0&nbsp;&n=
bsp;&nbsp; RAID-1&nbsp;&nbsp;&nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
3725.28&nbsp;&nbsp; RiW&nbsp;&nbsp;&nbsp; ON&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">u1&nbsp;&n=
bsp;&nbsp; RAID-6&nbsp;&nbsp;&nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 64K&nbsp;&nbsp;&nbsp;&nbsp; 70780.3&nb=
sp;&nbsp; RiW&nbsp;&nbsp;&nbsp; ON&nbsp;&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">u2&nbsp;&n=
bsp;&nbsp; SPARE&nbsp;&nbsp;&nbsp;&nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp; 3726.01&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; OFF&nbsp;&nbsp;&nb=
sp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">VPort Stat=
us&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Unit Size&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp; Type&nbsp; Phy Encl-Slot&nbsp;&nbsp;&nbsp; Model<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">----------=
--------------------------------------------------------------------<o:p></=
o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p8&nbsp;&n=
bsp;&nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; u0&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/=
e0/slt0&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p9&nbsp;&n=
bsp;&nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/=
e0/slt4&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p10&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t8&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p11&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t12 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p12&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t16 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p13&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t20 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p14&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u0&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t1&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p15&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t5&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p16&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t9&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p17&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t13 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p18&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t17 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p19&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t21 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p20&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t2&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p21&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t6&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p22&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t10 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p23&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t14 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p24&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t18 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p25&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t22 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p26&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t3&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p27&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t7&nbsp; WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p28&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t11 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p29&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t15 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p30&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u1&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t19 WDC WD4000FYYZ-01UL
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">p31&nbsp;&=
nbsp; OK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; u2&nbsp;&nbsp; 3.63 TB&nbsp;&nbsp; SATA&nbsp; -&nbsp;&nbsp; /c0/e0/sl=
t23 WDC WD4000FYYZ-01UL<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">LVM configuration<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">I don&#8217;t *<b>think</b>* these are in an LVM.. I could be wro=
ng.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">type of disks you are using<o:p></=
o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">Models included above in raid config.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">write cache status of drives<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">size of BBWC and mode it is runnin=
g in<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">xfs_info output on the filesystem =
in question<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:1.2pt;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">For the above three questions I&#8217;m not sure how to get the t=
he cache status of the drives, or what the BBWC is? xfs_info won&#8217;t cu=
rrently run (I&#8217;m waiting on the drive to unmount) but I
 ran an xfs_check and an xfs_repair &#8211;n and no errors were shown.<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:19.2pt;text-indent:-.25in;line-height:14.3pt;mso-list:l1 level=
1 lfo2;background:white">
<![if !supportLists]><span style=3D"font-size:10.0pt;font-family:Wingdings;=
color:black"><span style=3D"mso-list:Ignore">&sect;<span style=3D"font:7.0p=
t &quot;Times New Roman&quot;">&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">dmesg output showing all error mes=
sages and stack traces<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:4.8pt;margin-right:0in;m=
argin-bottom:6.0pt;margin-left:0in;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">Then you need to describe your workload that is causing the probl=
em, and a demonstration of the bad behaviour that is occurring. If it is a =
performance problem, then 30s - 1 minute samples
 of:<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:38.4pt;text-indent:-.25in;line-height:14.3pt;mso-list:l0 level=
1 lfo4;background:white">
<![if !supportLists]><span style=3D"font-size:9.5pt;font-family:&quot;Arial=
&quot;,sans-serif;color:black"><span style=3D"mso-list:Ignore">1.<span styl=
e=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">iostat -x -d -m 5<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">[root@ncb-sv-016 ~]# iostat -x -d -m 5<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Linux 2.6.=
32-358.23.2.el6.x86_64 (ncb-sv-016.ducom.edu) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 09/15/2015 &nbsp;&nbsp; _x86_64_&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (16 CPU)<o=
:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.29&nbsp;&nbsp;&nbsp;&nbsp; 3.61&nbsp;&nbsp;&nbsp; 5.78&nbsp;&nbsp;&nbs=
p; 3.58&nbsp;&nbsp;&nbsp;&nbsp; 0.10&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 28.27&nbsp;&nbsp;&nbsp;&nbsp; 0.05&nbsp;&nbsp;&nbsp; 5.19&nbsp;&nb=
sp; 2.39&nbsp;&nbsp; 2.24<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nb=
sp;1.02&nbsp;&nbsp;&nbsp;&nbsp; 8.66&nbsp;&nbsp; 31.50&nbsp;&nbsp;&nbsp; 3.=
91&nbsp;&nbsp;&nbsp;&nbsp; 0.33&nbsp;&nbsp;&nbsp;&nbsp; 0.12&nbsp;&nbsp;&nb=
sp; 26.14&nbsp;&nbsp;&nbsp;&nbsp; 5.94&nbsp; 167.54&nbsp; 27.47&nbsp; 97.25=
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 1.60&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 2.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00 &nbsp;&nbsp;&nbsp;&nbsp;0.01&nbsp;&nbs=
p;&nbsp; 14.40&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp;&nbsp; 4.30&nbsp;&nb=
sp; 4.30&nbsp;&nbsp; 0.86<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.80&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 6.46 6332.75 1250.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 3.60&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 7.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 12.11&nbsp;&nbsp;&nbsp;&nbsp; 0.02&nbsp;&nbsp;&nbsp; 0.60&nbsp;&nb=
sp; 1.77&nbsp;&nbsp; 1.24<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 6.28 6256.60 1000.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbs=
p;&nbsp;&nbsp; 8.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 42.50&nbsp; 12=
.00&nbsp;&nbsp; 0.48<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.20&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.86 5846.33 833.33 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00 &nbsp;&nbsp;&nbsp;&nbsp;0.60&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.60&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbs=
p;&nbsp; 16.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp; 12.67&nbsp; 12.67&n=
bsp;&nbsp; 0.76<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 6.86 5725.20 1000.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbs=
p;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbs=
p;&nbsp; 0.00&nbsp;&nbsp; 0.00<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 6.06 5459.00 1000.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 4.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.60&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.02&nbsp;&nbs=
p;&nbsp; 26.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp;&nbsp; 6.75&nbsp;&nb=
sp; 6.50&nbsp;&nbsp; 1.04<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 51.20&nbsp;&nbsp;&nbsp;&nbsp; 7.05 5670.40 1000.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp; 29.40&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 2.=
60&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.12&nbsp;&nbsp;&nb=
sp; 98.46&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp;&nbsp; 4.54&nbsp;&nbsp; 4=
.08&nbsp;&nbsp; 1.06<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.20&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 53.33&nbsp;&nbsp;&nbsp;&nbsp; 6.54 7428.50 833.33 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp; &nbsp;&nbsp;&nbsp;9.60&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 15.=
80&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.10&nbsp;&nbsp;&nb=
sp; 12.86&nbsp;&nbsp;&nbsp;&nbsp; 0.57&nbsp;&nbsp; 35.82&nbsp;&nbsp; 3.37&n=
bsp;&nbsp; 5.32<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 6.30 5889.20 1000.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 7.80&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 12.=
80&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.08&nbsp;&nbsp;&nb=
sp; 12.38&nbsp;&nbsp;&nbsp;&nbsp; 0.74&nbsp;&nbsp; 58.09&nbsp; 15.06&nbsp; =
19.28<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.20&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 6.49 6140.83 833.33 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 4.80&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 3.20&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 20.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp;&nbsp; 0.06&nbsp;&nb=
sp; 3.12&nbsp;&nbsp; 1.00<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.80&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.10 6489.25 1250.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00 &nbsp;&nbsp;&nbsp;&nbsp;0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.20&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbs=
p;&nbsp;&nbsp; 8.00&nbsp;&nbsp;&nbsp;&nbsp; 0.02&nbsp; 152.00 103.00&nbsp;&=
nbsp; 2.06<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 6.75 5791.00 1000.20 100.02<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp; 61.20&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 11.80&nb=
sp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.29&nbsp;&nbsp;&nbsp; 4=
9.49&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp;&nbsp; 0.88&nbsp;&nbsp; 0.69&n=
bsp;&nbsp; 0.82<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 6.37 5569.71 714.14&nbsp; 99.98<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.40&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.60&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbs=
p;&nbsp; 13.33&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp; 24.33&nbsp; 24.33&n=
bsp;&nbsp; 1.46<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.60&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.05&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.77 5162.00 625.12 100.02<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbs=
p;&nbsp;&nbsp; 8.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 3.00&nbs=
p;&nbsp; 1.50&nbsp;&nbsp; 0.06<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.80&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.08 3428.50 1250.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp; &nbsp;&nbsp;1.60&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.80&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbs=
p;&nbsp; 24.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp; 10.75&nbsp; 10.75&n=
bsp;&nbsp; 0.86<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.86 3932.14 714.29 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 2.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 4.80&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 11.33&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp;&nbsp; 2.21&nbsp;&nb=
sp; 2.08&nbsp;&nbsp; 1.00<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.60 3992.71 714.29 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 5.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp; 18.=
20&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.09&nbsp;&nbsp;&nb=
sp; 10.20&nbsp;&nbsp;&nbsp;&nbsp; 0.02&nbsp;&nbsp;&nbsp; 1.13&nbsp;&nbsp; 0=
.03&nbsp;&nbsp; 0.06<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.44 4208.86 714.29 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp; &nbsp;&nbsp;&nbsp;1.40&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.60&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbs=
p;&nbsp; 26.67&nbsp;&nbsp;&nbsp;&nbsp; 0.02&nbsp;&nbsp; 27.00&nbsp; 27.00&n=
bsp;&nbsp; 1.62<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.22 4325.43 714.29 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.60&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbs=
p;&nbsp; 20.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbsp; 15.50&nbsp; 15.50&n=
bsp;&nbsp; 0.62<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.60&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.05&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.06 4022.75 625.00 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbs=
p;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbs=
p;&nbsp; 0.00&nbsp;&nbsp; 0.00<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 0.80 &nbsp;&nbsp;&nbsp;&nbsp;0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.03&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.08 3495.50 1250.00 100.00<o:p></o:=
p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black"><o:p>&nbsp=
;</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">Device:&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; rrqm/s&nbsp;&nbsp; wrqm/s&nbs=
p;&nbsp;&nbsp;&nbsp; r/s&nbsp;&nbsp;&nbsp;&nbsp; w/s&nbsp;&nbsp;&nbsp; rMB/=
s&nbsp;&nbsp;&nbsp; wMB/s avgrq-sz avgqu-sz&nbsp;&nbsp; await&nbsp; svctm&n=
bsp; %util<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sda&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 1.60&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.60&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.01&nbsp;&nbs=
p;&nbsp; 12.00&nbsp;&nbsp;&nbsp;&nbsp; 0.07&nbsp;&nbsp; 42.88&nbsp; 42.50&n=
bsp;&nbsp; 6.80<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">sdb&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbs=
p; 1.40&nbsp;&nbsp;&nbsp;&nbsp; 0.00&nbsp;&nbsp;&nbsp;&nbsp; 0.04&nbsp;&nbs=
p;&nbsp; 64.00&nbsp;&nbsp;&nbsp;&nbsp; 5.82 3894.71 714.29 100.00<o:p></o:p=
></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;margin-left:38.4pt;text-indent:-.25in;line-height:14.3pt;mso-list:l0 level=
1 lfo4;background:white">
<![if !supportLists]><span style=3D"font-size:9.5pt;font-family:&quot;Arial=
&quot;,sans-serif;color:black"><span style=3D"mso-list:Ignore">2.<span styl=
e=3D"font:7.0pt &quot;Times New Roman&quot;">&nbsp;&nbsp;&nbsp;
</span></span></span><![endif]><span style=3D"font-size:9.5pt;font-family:&=
quot;Arial&quot;,sans-serif;color:black">vmstat 5<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">[root@ncb-sv-016 ~]# vmstat 5<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">procs ----=
-------memory---------- ---swap-- -----io---- --system-- -----cpu-----<o:p>=
</o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">r&nbsp; b&=
nbsp;&nbsp; swpd&nbsp;&nbsp; free&nbsp;&nbsp; buff&nbsp; cache&nbsp;&nbsp; =
si&nbsp;&nbsp; so&nbsp;&nbsp;&nbsp; bi&nbsp;&nbsp;&nbsp; bo&nbsp;&nbsp; in&=
nbsp;&nbsp; cs us sy id wa st<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125768&nbsp; 19456 405396&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 28&nbsp;&nbsp;&nbsp; 10&nbsp; 4=
21&nbsp; 150&nbsp; 0&nbsp; 0 99&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125520&nbsp; 19464 405396&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 34 66=
79 13281&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">1&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126124896&nbsp; 19472 405392&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 38 67=
18 13310&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125312&nbsp; 19472 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 74 66=
58 13256&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125440&nbsp; 19480 405392&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 60 66=
64 13291&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">2&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125440&nbsp; 19480 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 26 66=
60 13272&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125680&nbsp; 19488 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 30 66=
59 13282&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">2&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125696&nbsp; 19496 405396&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; 117 6686 13=
298&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">1&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125568&nbsp; 19496 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 33 66=
61 13287&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125816&nbsp; 19504 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 30 66=
63 13271&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">1&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125816&nbsp; 19504 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 27 66=
59 13285&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125696&nbsp; 19512 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 75 66=
70 13269&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125816&nbsp; 19520 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 55 66=
71 13286&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">2&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125696&nbsp; 19528 405396&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 34 66=
70 13284&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125272&nbsp; 19528 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 26 67=
00 13298&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">0&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125408&nbsp; 19536 405400&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 61 66=
60 13277&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:auto;margin-bottom:1.2pt=
;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:Consolas;color:black">1&nbsp; 0&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 126125536&nbsp; 19544 405392&nbsp;&nbsp;&nb=
sp; 0&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp;&nbsp; 98 66=
77 13281&nbsp; 0&nbsp; 0 100&nbsp; 0&nbsp; 0&nbsp;&nbsp;&nbsp;
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:4.8pt;margin-right:0in;m=
argin-bottom:6.0pt;margin-left:0in;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">can give us insight into the IO and memory utilisation of your ma=
chine at the time of the problem.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:4.8pt;margin-right:0in;m=
argin-bottom:6.0pt;margin-left:0in;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">If the filesystem is hanging, then capture the output of the dmes=
g command after running:<o:p></o:p></span></p>
<div style=3D"border:dashed #2F6FAB 1.0pt;padding:12.0pt 12.0pt 12.0pt 12.0=
pt">
<p class=3D"MsoNormal" style=3D"line-height:13.2pt;background:#F9F9F9"><spa=
n style=3D"font-size:9.5pt;font-family:&quot;Courier New&quot;;color:black"=
># echo w &gt; /proc/sysrq-trigger<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:13.2pt;background:#F9F9F9"><spa=
n style=3D"font-size:9.5pt;font-family:&quot;Courier New&quot;;color:black"=
># dmesg<o:p></o:p></span></p>
</div>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:4.8pt;margin-right:0in;m=
argin-bottom:6.0pt;margin-left:0in;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">will tell us all the hung processes in the machine, often pointin=
g us directly to the cause of the hang.<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"mso-margin-top-alt:4.8pt;margin-right:0in;m=
argin-bottom:6.0pt;margin-left:0in;line-height:14.3pt;background:white">
<span style=3D"font-size:9.5pt;font-family:&quot;Arial&quot;,sans-serif;col=
or:black">Attached<o:p></o:p></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks!<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Josh Earl, MS<o:p></o:p></p>
<p class=3D"MsoNormal">Research Instructor<o:p></o:p></p>
<p class=3D"MsoNormal"><span style=3D"color:black">Drexel College of Medici=
ne<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:13.5pt;background:white"><span =
style=3D"color:black">Center for Advanced Microbial Processing (CAMP)<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal" style=3D"line-height:13.5pt;background:white"><span =
style=3D"color:black">Institute of Molecular Medicine and Infectious Diseas=
e<o:p></o:p></span></p>
<p class=3D"MsoNormal">(215) 762-8133<span style=3D"color:black"><o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
<hr>
<div>
<p style=3D"font-size:8pt; font-style: italic; line-height:10pt; font-famil=
y:Arial, Helvetica, sans-serif">
This email and any accompanying attachments are confidential. The informati=
on is intended solely for the use of the individual to whom it is addressed=
. Any review, disclosure, copying, distribution, or use of this email commu=
nication by others is strictly prohibited.
 If you are not the intended recipient, please notify the sender immediatel=
y and delete all copies. Thank you for your cooperation.
</p>
</div>
</body>
</html>

--_000_2CC86DBF85FEEC41A2DFE1647B40613D5DAF2CA0NCBSV117DUCOMed_--


--===============3754353935003665871==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3754353935003665871==--
