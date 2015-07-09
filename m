Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B369A7F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 12:33:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 985158F8049
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 10:33:58 -0700 (PDT)
Received: from mrout4.yahoo.com (mrout4.yahoo.com [216.145.54.109]) by
	cuda.sgi.com with ESMTP id kHXZd9xrHdw45glp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 10:33:55 -0700 (PDT)
Received: from omp1007.mail.ne1.yahoo.com (omp1007.mail.ne1.yahoo.com
	[98.138.87.7])
	by mrout4.yahoo.com (8.14.9/8.14.9/y.out) with ESMTP id t69HXFqi073774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 9 Jul 2015 10:33:16 -0700 (PDT)
Date: Thu, 9 Jul 2015 17:32:50 +0000 (UTC)
From: Hogan Whittall <whittalh@yahoo-inc.com>
Message-ID: <110866563.1804043.1436463170539.JavaMail.yahoo@mail.yahoo.com>
Subject: Issue with RHEL6 mkfs.xfs (3.1.1+), HP P420 RAID, and MySQL
	replication
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5488718859376395651=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============5488718859376395651==
Content-Type: multipart/alternative;
	boundary="----=_Part_1804042_1960197275.1436463170531"

------=_Part_1804042_1960197275.1436463170531
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,
Recently we encountered a previously-reported issue regarding write amplifi=
cation with MySQL replication and XFS when used with certain RAID controlle=
rs (In our case, HP P420). =C2=A0That issue exactly matches our issue and w=
as documented by someone else here -=C2=A0http://oss.sgi.com/archives/xfs/2=
013-03/msg00133.html=C2=A0- but I don't see any resolution. =C2=A0I will sa=
y that the problem *does not* exist when mkfs.xfs 2.9.6 is used to format t=
he filesystem on RHEL6 as that sets sunit=3D0 and swidth=3D0 instead of set=
ting based on minimum_io_size and optimal_io_size.
We have systems that are identical in how they are built and configured, we=
 can take a RHEL6 box that has the MySQL partition formatted with mkfs.xfs =
v3.1.1 and reproduce the write amplification problem with MySQL replication=
 every single time. =C2=A0If we take the same box and format the MySQL part=
ition with mkfs.xfs 2.9.6, then bring up MySQL with the exact same configur=
ation there is no problem. =C2=A0I've included the working and broken setti=
ngs below. =C2=A0If it's not the sunit/swidth settings then what will cause=
 7-10MB/s worth of writes to the XFS partition to become over 200MB/s downs=
tream? =C2=A0The actual data change on the disks is not 200MB/s, but becaus=
e the write ops are truly being amplified and not just being misreported ou=
r MySQL slaves with the bad XFS settings cannot keep up and the lag steadil=
y increases with no hope of ever becoming current.
I am happy to try some other settings/options with the RHEL6 mkfs.xfs to se=
e if replication performance is able to match that of systems formatted wit=
h mkfs.xfs 2.9.6, but the values set by 3.1.1 with the P420 RAID do not wor=
k for MySQL replication. =C2=A0We have ruled out everything else as a possi=
ble cause, the absolute only difference on these systems is what values are=
 set by mkfs.xfs.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=C2=A0Working RHEL6 XFS partition:
meta-data=3D/dev/mapper/sys-home =C2=A0 isize=3D256 =C2=A0 =C2=A0agcount=3D=
4, agsize=3D71271680 blks=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=
=3D512 =C2=A0 attr=3D2, projid32bit=3D0data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D409=
6 =C2=A0 blocks=3D285086720, imaxpct=3D5=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 sunit=3D0 =C2=A0 =C2=A0 =C2=A0swidth=3D0 blksnaming =C2=A0 =3Dversio=
n 2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bsize=3D4096 =C2=A0 asc=
ii-ci=3D0log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D32768, version=3D2=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D0 blks, lazy=
-count=3D0realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=C2=A0
Broken RHEL6 XFS partition:
meta-data=3D/dev/mapper/sys-home =C2=A0 isize=3D256 =C2=A0 =C2=A0agcount=3D=
32, agsize=3D8908992 blks=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=
=3D512 =C2=A0 attr=3D2, projid32bit=3D0data =C2=A0 =C2=A0 =3D =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bsize=3D409=
6 =C2=A0 blocks=3D285086720, imaxpct=3D5=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 sunit=3D64 =C2=A0 =C2=A0 swidth=3D128 blksnaming =C2=A0 =3Dversion 2=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bsize=3D4096 =C2=A0 ascii-=
ci=3D0log =C2=A0 =C2=A0 =C2=A0=3Dinternal =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 bsize=3D4096 =C2=A0 blocks=3D139264, version=3D2=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sectsz=3D512 =C2=A0 sunit=3D64 blks, laz=
y-count=3D1realtime =3Dnone =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 extsz=3D4096 =C2=A0 blocks=3D0, rtextents=3D0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=C2=A0

Thanks!
-Hogan
------=_Part_1804042_1960197275.1436463170531
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><body><div style=3D"color:#000; background-color:#fff; font-family:He=
lveticaNeue-Light, Helvetica Neue Light, Helvetica Neue, Helvetica, Arial, =
Lucida Grande, sans-serif;font-size:16px"><div id=3D"yui_3_16_0_1_143645421=
7132_37949">Hello,</div><div id=3D"yui_3_16_0_1_1436454217132_37949"><br></=
div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr">Recently we en=
countered a previously-reported issue regarding write amplification with My=
SQL replication and XFS when used with certain RAID controllers (In our cas=
e, HP P420). &nbsp;That issue exactly matches our issue and was documented =
by someone else here -&nbsp;<a href=3D"http://oss.sgi.com/archives/xfs/2013=
-03/msg00133.html" id=3D"yui_3_16_0_1_1436454217132_38091">http://oss.sgi.c=
om/archives/xfs/2013-03/msg00133.html</a>&nbsp;- but I don't see any resolu=
tion. &nbsp;I will say that the problem *does not* exist when mkfs.xfs 2.9.=
6 is used to format the filesystem on RHEL6 as that sets sunit=3D0 and swid=
th=3D0 instead of setting based on minimum_io_size and optimal_io_size.</di=
v><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr"><br></div><div i=
d=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr">We have systems that are=
 identical in how they are built and configured, we can take a RHEL6 box th=
at has the MySQL partition formatted with mkfs.xfs v3.1.1 and reproduce the=
 write amplification problem with MySQL replication every single time. &nbs=
p;If we take the same box and format the MySQL partition with mkfs.xfs 2.9.=
6, then bring up MySQL with the exact same configuration there is no proble=
m. &nbsp;I've included the working and broken settings below. &nbsp;If it's=
 not the sunit/swidth settings then what will cause 7-10MB/s worth of write=
s to the XFS partition to become over 200MB/s downstream? &nbsp;The actual =
data change on the disks is not 200MB/s, but because the write ops are trul=
y being amplified and not just being misreported our MySQL slaves with the =
bad XFS settings cannot keep up and the lag steadily increases with no hope=
 of ever becoming current.</div><div id=3D"yui_3_16_0_1_1436454217132_37949=
" dir=3D"ltr"><br></div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D=
"ltr">I am happy to try some other settings/options with the RHEL6 mkfs.xfs=
 to see if replication performance is able to match that of systems formatt=
ed with mkfs.xfs 2.9.6, but the values set by 3.1.1 with the P420 RAID do n=
ot work for MySQL replication. &nbsp;We have ruled out everything else as a=
 possible cause, the absolute only difference on these systems is what valu=
es are set by mkfs.xfs.</div><div id=3D"yui_3_16_0_1_1436454217132_37949" d=
ir=3D"ltr"><br></div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"lt=
r">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D&nbsp;</div><div id=3D"yui_3_16_0_1_143645=
4217132_37949" dir=3D"ltr">Working RHEL6 XFS partition:</div><div id=3D"yui=
_3_16_0_1_1436454217132_37949" dir=3D"ltr"><br></div><div id=3D"yui_3_16_0_=
1_1436454217132_37949" dir=3D"ltr" class=3D"">meta-data=3D/dev/mapper/sys-h=
ome &nbsp; isize=3D256 &nbsp; &nbsp;agcount=3D4, agsize=3D71271680 blks</di=
v><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr" class=3D"">&nbsp=
; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sectsz=3D512 &nbsp; attr=3D2, projid32bi=
t=3D0</div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr" class=
=3D"">data &nbsp; &nbsp; =3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; blocks=3D285086720, imax=
pct=3D5</div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr" class=
=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sunit=3D0 &nbsp; &nbsp; &nbsp=
;swidth=3D0 blks</div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"l=
tr" class=3D"">naming &nbsp; =3Dversion 2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp=
; &nbsp; &nbsp;bsize=3D4096 &nbsp; ascii-ci=3D0</div><div id=3D"yui_3_16_0_=
1_1436454217132_37949" dir=3D"ltr" class=3D"">log &nbsp; &nbsp; &nbsp;=3Din=
ternal &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp;=
 blocks=3D32768, version=3D2</div><div id=3D"yui_3_16_0_1_1436454217132_379=
49" dir=3D"ltr" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nb=
sp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sectsz=
=3D512 &nbsp; sunit=3D0 blks, lazy-count=3D0</div><div id=3D"yui_3_16_0_1_1=
436454217132_37949" dir=3D"ltr" class=3D"">realtime =3Dnone &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; extsz=3D4096 &nbsp; blocks=
=3D0, rtextents=3D0</div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=
=3D"ltr" class=3D""><br></div><div id=3D"yui_3_16_0_1_1436454217132_37949" =
dir=3D"ltr" class=3D"">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D&nbsp;<br></div><div =
id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr" class=3D"">Broken RHEL6=
 XFS partition:</div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"lt=
r" class=3D""><br></div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D=
"ltr" class=3D"">meta-data=3D/dev/mapper/sys-home &nbsp; isize=3D256 &nbsp;=
 &nbsp;agcount=3D32, agsize=3D8908992 blks</div><div id=3D"yui_3_16_0_1_143=
6454217132_37949" dir=3D"ltr" class=3D"">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
=3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; sectsz=3D512 &nbsp; attr=3D2, projid32bit=3D0</div><div id=3D"yui_3_1=
6_0_1_1436454217132_37949" dir=3D"ltr" class=3D"">data &nbsp; &nbsp; =3D &n=
bsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
bsize=3D4096 &nbsp; blocks=3D285086720, imaxpct=3D5</div><div id=3D"yui_3_1=
6_0_1_1436454217132_37949" dir=3D"ltr" class=3D"">&nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; sunit=3D64 &nbsp; &nbsp; swidth=3D128 blks</div><div id=3D"y=
ui_3_16_0_1_1436454217132_37949" dir=3D"ltr" class=3D"">naming &nbsp; =3Dve=
rsion 2 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;bsize=3D4096 &nbsp;=
 ascii-ci=3D0</div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr"=
 class=3D"">log &nbsp; &nbsp; &nbsp;=3Dinternal &nbsp; &nbsp; &nbsp; &nbsp;=
 &nbsp; &nbsp; &nbsp; bsize=3D4096 &nbsp; blocks=3D139264, version=3D2</div=
><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr" class=3D"">&nbsp;=
 &nbsp; &nbsp; &nbsp; &nbsp;=3D &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp; &nbsp; sectsz=3D512 &nbsp; sunit=3D64 blks, lazy=
-count=3D1</div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr" cl=
ass=3D"">realtime =3Dnone &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; extsz=3D4096 &nbsp; blocks=3D0, rtextents=3D0</div><div id=3D=
"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr"><br></div><div id=3D"yui_3_1=
6_0_1_1436454217132_37949" dir=3D"ltr">=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D&nbsp;=
<br></div><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr"><br></di=
v><div id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr">Thanks!</div><di=
v id=3D"yui_3_16_0_1_1436454217132_37949" dir=3D"ltr"><br></div><div id=3D"=
yui_3_16_0_1_1436454217132_37949" dir=3D"ltr">-Hogan</div></div></body></ht=
ml>
------=_Part_1804042_1960197275.1436463170531--


--===============5488718859376395651==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5488718859376395651==--
