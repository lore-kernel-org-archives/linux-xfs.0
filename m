Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o880gBGp004964 for <xfs@oss.sgi.com>; Tue, 7 Sep 2010 19:42:11 -0500
Received: from EXHUB018-3.exch018.msoutlookonline.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21CCB17B7F43
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 17:42:51 -0700 (PDT)
Received: from EXHUB018-3.exch018.msoutlookonline.net
	(exhub018-3.exch018.msoutlookonline.net [64.78.17.18]) by
	cuda.sgi.com with ESMTP id ENwHCUbqcOjZsNzZ for
	<xfs@oss.sgi.com>; Tue, 07 Sep 2010 17:42:51 -0700 (PDT)
From: Brady Chang <bchang@greenplum.com>
Date: Tue, 7 Sep 2010 17:45:41 -0700
Subject: fragmentation question
Message-ID: <C8AC2AC5.6CA9%bchang@greenplum.com>
Content-Language: en
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3660870170882881279=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============3660870170882881279==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_C8AC2AC56CA9bchanggreenplumcom_"

--_000_C8AC2AC56CA9bchanggreenplumcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello All,
I have an issue with fragmentation on a particular device
thanks for any advice.

-Brady

I have a Dell r510 with 12 disks
2xraid 5 (6 disks each)
raid group1:
48 GB   carved out for os mounted as /
remaining space  2.7 TB for xfs mounted as /data1
raid group2:
48 GB  for swap
remaining space 2.7 TB for xfs mounted as /data2

The strange thing is that /data1 never gets fragmented where as /data2 is b=
adly fragmented.
I believe increase allocsize would help, but not sure how to explain why /d=
ata2(/dev/sdd) always gets fragmented and not /data1(/dev/sdb)

It's a data warehouse application.  the I/O is balanced between /data1 and =
/data2:
output of xfs_db
[root@sdw4 data1]# xfs_db -c frag -r /dev/sdb
actual 14353, ideal 13702, fragmentation factor 4.54%
[root@sdw4 data1]# xfs_db -c frag -r /dev/sdd
actual 408674, ideal 13719, fragmentation factor 96.64%
df output
/dev/sdb              2.7T  967G  1.8T  36% /data1
/dev/sdd              2.7T  1.1T  1.7T  39% /data2

LABEL=3D/data1        /data1     xfs     allocsize=3D1048576,logbufs=3D8,no=
atime,nodiratime 0 0
LABEL=3D/data2        /data2     xfs     allocsize=3D1048576,logbufs=3D8,no=
atime,nodiratime 0 0


raid config output:
[root@sdw4 data1]# omreport storage vdisk
List of Virtual Disks in the System

Controller PERC H700 Integrated (Slot 4)
ID                        : 0
Status                    : Ok
Name                      : boot
State                     : Ready
Hot Spare Policy violated : Not Assigned
Virtual Disk Bad Blocks   : No
Secured                   : Not Applicable
Progress                  : Not Applicable
Layout                    : RAID-5
Size                      : 48.99 GB (52602470400 bytes)
Device Name               : /dev/sda
Bus Protocol              : SAS
Media                     : HDD
Read Policy               : No Read Ahead
Write Policy              : Force Write Back
Cache Policy              : Not Applicable
Stripe Element Size       : 128 KB
Disk Cache Policy         : Disabled

ID                        : 1
Status                    : Ok
Name                      : data1
State                     : Ready
Hot Spare Policy violated : Not Assigned
Virtual Disk Bad Blocks   : No
Secured                   : Not Applicable
Progress                  : Not Applicable
Layout                    : RAID-5
Size                      : 2,742.89 GB (2945150484480 bytes)
Device Name               : /dev/sdb
Bus Protocol              : SAS
Media                     : HDD
Read Policy               : No Read Ahead
Write Policy              : Force Write Back
Cache Policy              : Not Applicable
Stripe Element Size       : 128 KB
Disk Cache Policy         : Disabled

ID                        : 2
Status                    : Ok
Name                      : swap
State                     : Ready
Hot Spare Policy violated : Not Assigned
Virtual Disk Bad Blocks   : No
Secured                   : Not Applicable
Progress                  : Not Applicable
Layout                    : RAID-5
Size                      : 48.99 GB (52602470400 bytes)
Device Name               : /dev/sdc
Bus Protocol              : SAS
Media                     : HDD
Read Policy               : No Read Ahead
Write Policy              : Force Write Back
Cache Policy              : Not Applicable
Stripe Element Size       : 128 KB
Disk Cache Policy         : Disabled

ID                        : 3
Status                    : Ok
Name                      : data2
State                     : Ready
Hot Spare Policy violated : Not Assigned
Virtual Disk Bad Blocks   : No
Secured                   : Not Applicable
Progress                  : Not Applicable
Layout                    : RAID-5
Size                      : 2,742.89 GB (2945150484480 bytes)
Device Name               : /dev/sdd
Bus Protocol              : SAS
Media                     : HDD
Read Policy               : No Read Ahead
Write Policy              : Force Write Back
Cache Policy              : Not Applicable
Stripe Element Size       : 128 KB
Disk Cache Policy         : Disabled

--_000_C8AC2AC56CA9bchanggreenplumcom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>fragmentation question</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'>Hello All,<BR>
I have an issue with fragmentation on a particular device<BR>
thanks for any advice.<BR>
<BR>
-Brady<BR>
<BR>
I have a Dell r510 with 12 disks <BR>
2xraid 5 (6 disks each) <BR>
raid group1:<BR>
48 GB &nbsp;&nbsp;carved out for os mounted as / <BR>
remaining space &nbsp;2.7 TB for xfs mounted as /data1<BR>
raid group2:<BR>
48 GB &nbsp;for swap<BR>
remaining space 2.7 TB for xfs mounted as /data2<BR>
<BR>
The strange thing is that /data1 never gets fragmented where as /data2 is b=
adly fragmented.<BR>
I believe increase allocsize would help, but not sure how to explain why /d=
ata2(/dev/sdd) always gets fragmented and not /data1(/dev/sdb)<BR>
<BR>
It's a data warehouse application. &nbsp;the I/O is balanced between /data1=
 and /data2:<BR>
output of xfs_db<BR>
[root@sdw4 data1]# xfs_db -c frag -r /dev/sdb<BR>
actual 14353, ideal 13702, fragmentation factor 4.54%<BR>
[root@sdw4 data1]# xfs_db -c frag -r /dev/sdd<BR>
actual 408674, ideal 13719, fragmentation factor 96.64%<BR>
df output<BR>
/dev/sdb &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;2.7T &nbsp;967G &nbsp;1.8T &nbsp;36% /data1<BR>
/dev/sdd &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;2.7T &nbsp;1.1T &nbsp;1.7T &nbsp;39% /data2<BR>
<BR>
LABEL=3D/data1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/data1 &nbsp;&nbsp=
;&nbsp;&nbsp;xfs &nbsp;&nbsp;&nbsp;&nbsp;allocsize=3D1048576,logbufs=3D8,no=
atime,nodiratime 0 0<BR>
LABEL=3D/data2 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/data2 &nbsp;&nbsp=
;&nbsp;&nbsp;xfs &nbsp;&nbsp;&nbsp;&nbsp;allocsize=3D1048576,logbufs=3D8,no=
atime,nodiratime 0 0<BR>
<BR>
<BR>
raid config output:<BR>
[root@sdw4 data1]# omreport storage vdisk <BR>
List of Virtual Disks in the System<BR>
<BR>
Controller PERC H700 Integrated (Slot 4)<BR>
ID &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 0<BR>
Status &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Ok<BR>
Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: boot<BR>
State &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Ready<BR>
Hot Spare Policy violated : Not Assigned<BR>
Virtual Disk Bad Blocks &nbsp;&nbsp;: No<BR>
Secured &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Not Applicable<BR>
Progress &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Not Applicable<BR>
Layout &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: RAID-5<BR>
Size &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 48.99 GB (5260247=
0400 bytes)<BR>
Device Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;: /dev/sda<BR>
Bus Protocol &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: SAS<BR>
Media &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: HDD<BR>
Read Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;: No Read Ahead<BR>
Write Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: Force Write Back<BR>
Cache Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: Not Applicable<BR>
Stripe Element Size &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 128 KB<BR>
Disk Cache Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Disable=
d<BR>
<BR>
ID &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 1<BR>
Status &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Ok<BR>
Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: data1<BR>
State &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Ready<BR>
Hot Spare Policy violated : Not Assigned<BR>
Virtual Disk Bad Blocks &nbsp;&nbsp;: No<BR>
Secured &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Not Applicable<BR>
Progress &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Not Applicable<BR>
Layout &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: RAID-5<BR>
Size &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 2,742.89 GB (2945=
150484480 bytes)<BR>
Device Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;: /dev/sdb<BR>
Bus Protocol &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: SAS<BR>
Media &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: HDD<BR>
Read Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;: No Read Ahead<BR>
Write Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: Force Write Back<BR>
Cache Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: Not Applicable<BR>
Stripe Element Size &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 128 KB<BR>
Disk Cache Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Disable=
d<BR>
<BR>
ID &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 2<BR>
Status &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Ok<BR>
Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: swap<BR>
State &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Ready<BR>
Hot Spare Policy violated : Not Assigned<BR>
Virtual Disk Bad Blocks &nbsp;&nbsp;: No<BR>
Secured &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Not Applicable<BR>
Progress &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Not Applicable<BR>
Layout &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: RAID-5<BR>
Size &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 48.99 GB (5260247=
0400 bytes)<BR>
Device Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;: /dev/sdc<BR>
Bus Protocol &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: SAS<BR>
Media &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: HDD<BR>
Read Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;: No Read Ahead<BR>
Write Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: Force Write Back<BR>
Cache Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: Not Applicable<BR>
Stripe Element Size &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 128 KB<BR>
Disk Cache Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Disable=
d<BR>
<BR>
ID &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 3<BR>
Status &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Ok<BR>
Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: data2<BR>
State &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Ready<BR>
Hot Spare Policy violated : Not Assigned<BR>
Virtual Disk Bad Blocks &nbsp;&nbsp;: No<BR>
Secured &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Not Applicable<BR>
Progress &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Not Applicable<BR>
Layout &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: RAID-5<BR>
Size &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 2,742.89 GB (2945=
150484480 bytes)<BR>
Device Name &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;: /dev/sdd<BR>
Bus Protocol &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: SAS<BR>
Media &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: HDD<BR>
Read Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;: No Read Ahead<BR>
Write Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: Force Write Back<BR>
Cache Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;: Not Applicable<BR>
Stripe Element Size &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: 128 KB<BR>
Disk Cache Policy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: Disable=
d<BR>
</SPAN></FONT>
</BODY>
</HTML>


--_000_C8AC2AC56CA9bchanggreenplumcom_--


--===============3660870170882881279==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3660870170882881279==--
