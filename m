Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89NedsB121896 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 18:40:40 -0500
Received: from EXHUB018-3.exch018.msoutlookonline.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D41C317C91AA
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 16:41:24 -0700 (PDT)
Received: from EXHUB018-3.exch018.msoutlookonline.net
	(exhub018-3.exch018.msoutlookonline.net [64.78.17.18]) by
	cuda.sgi.com with ESMTP id HfVJbviDmNA7GpAr for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 16:41:24 -0700 (PDT)
From: Brady Chang <bchang@greenplum.com>
Date: Thu, 9 Sep 2010 16:44:16 -0700
Subject: Re: fragmentation question
Message-ID: <C8AEBF60.6E45%bchang@greenplum.com>
In-Reply-To: <4C88EB62.5060000@sandeen.net>
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
Content-Type: multipart/mixed; boundary="===============1484455186113515449=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1484455186113515449==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_C8AEBF606E45bchanggreenplumcom_"

--_000_C8AEBF606E45bchanggreenplumcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

xfs_info output after the TPC-H runs are the same.

[root@sdw9 data1]# xfs_info /dev/sdd
meta-data=3D/dev/sdd               isize=3D256    agcount=3D32, agsize=3D22=
469715 blks
         =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D719030880, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks, unwritte=
n=3D1
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0
[root@sdw9 data1]# xfs_info /dev/sdb
meta-data=3D/dev/sdb               isize=3D256    agcount=3D32, agsize=3D22=
469715 blks
         =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D719030880, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks, unwritte=
n=3D1
naming   =3Dversion 2              bsize=3D4096
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

[root@sdw9 data1]# xfs_db -c frag -r /dev/sdb
actual 1799, ideal 1748, fragmentation factor 2.83%
[root@sdw9 data1]# xfs_db -c frag -r /dev/sdd
actual 54324, ideal 1749, fragmentation factor 96.78%


On 9/9/10 7:12 AM, "Eric Sandeen" <sandeen@sandeen.net> wrote:

Brady Chang wrote:
> Hello All,
> I have an issue with fragmentation on a particular device
> thanks for any advice.
>
> -Brady
>
> I have a Dell r510 with 12 disks
> 2xraid 5 (6 disks each)
> raid group1:
> 48 GB   carved out for os mounted as /
> remaining space  2.7 TB for xfs mounted as /data1
> raid group2:
> 48 GB  for swap
> remaining space 2.7 TB for xfs mounted as /data2
>
> The strange thing is that /data1 never gets fragmented where as /data2
> is badly fragmented.
> I believe increase allocsize would help, but not sure how to explain why
> /data2(/dev/sdd) always gets fragmented and not /data1(/dev/sdb)
>
> It's a data warehouse application.  the I/O is balanced between /data1
> and /data2:
> output of xfs_db
> [root@sdw4 data1]# xfs_db -c frag -r /dev/sdb
> actual 14353, ideal 13702, fragmentation factor 4.54%
> [root@sdw4 data1]# xfs_db -c frag -r /dev/sdd
> actual 408674, ideal 13719, fragmentation factor 96.64%

so each file has 30 extents on average (actual/ideal)

> df output
> /dev/sdb              2.7T  967G  1.8T  36% /data1
> /dev/sdd              2.7T  1.1T  1.7T  39% /data2

1.1T/408674 extents is ~3M per extent, not so good.

How many files are on each fs?

> LABEL=3D/data1        /data1     xfs
>     allocsize=3D1048576,logbufs=3D8,noatime,nodiratime 0 0
> LABEL=3D/data2        /data2     xfs
>     allocsize=3D1048576,logbufs=3D8,noatime,nodiratime 0 0

Everything but the first option is default, BTW.

Is xfs_info output on the 2 filesystems the same?

Otherwise Emmanuel's idea is a good one, maybe it's not
as balanced as you think it is, or maybe they have aged
differently and have different amounts of freespace
(see the freesp command in xfs_db)

> By the way, the os is RHEL 5.5 kernel 2.6.18-194.11.1.el5

Was Red Hat support not helpful?

-Eric



--_000_C8AEBF606E45bchanggreenplumcom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: fragmentation question</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'>xfs_info output after the TPC-H runs are the same.<BR>
<BR>
[root@sdw9 data1]# xfs_info /dev/sdd<BR>
meta-data=3D/dev/sdd &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;isize=3D256 &nbsp;&nbsp;&nbsp;agcount=3D32, a=
gsize=3D22469715 blks<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sectsz=3D512 &nbsp;&nbsp;attr=3D0<B=
R>
data &nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;bsize=3D4096 &nbsp;&nbsp;blocks=3D719030880, imaxpct=3D25<BR=
>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sunit=3D0 &nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;swidth=3D0 blks, unwritten=3D1<BR>
naming &nbsp;&nbsp;=3Dversion 2 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bsize=3D4096 &nbsp;<BR>
log &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3Dinternal &nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bsize=3D4096 &nbsp;&=
nbsp;blocks=3D32768, version=3D1<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sectsz=3D512 &nbsp;&nbsp;sunit=3D0 =
blks, lazy-count=3D0<BR>
realtime =3Dnone &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;extsz=3D4096 &nbsp;&nbsp;=
blocks=3D0, rtextents=3D0<BR>
[root@sdw9 data1]# xfs_info /dev/sdb<BR>
meta-data=3D/dev/sdb &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;isize=3D256 &nbsp;&nbsp;&nbsp;agcount=3D32, a=
gsize=3D22469715 blks<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sectsz=3D512 &nbsp;&nbsp;attr=3D0<B=
R>
data &nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;bsize=3D4096 &nbsp;&nbsp;blocks=3D719030880, imaxpct=3D25<BR=
>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sunit=3D0 &nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;swidth=3D0 blks, unwritten=3D1<BR>
naming &nbsp;&nbsp;=3Dversion 2 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bsize=3D4096 &nbsp;<BR>
log &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3Dinternal &nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bsize=3D4096 &nbsp;&=
nbsp;blocks=3D32768, version=3D1<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sectsz=3D512 &nbsp;&nbsp;sunit=3D0 =
blks, lazy-count=3D0<BR>
realtime =3Dnone &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;extsz=3D4096 &nbsp;&nbsp;=
blocks=3D0, rtextents=3D0<BR>
<BR>
[root@sdw9 data1]# xfs_db -c frag -r /dev/sdb<BR>
actual 1799, ideal 1748, fragmentation factor 2.83%<BR>
[root@sdw9 data1]# xfs_db -c frag -r /dev/sdd<BR>
actual 54324, ideal 1749, fragmentation factor 96.78%<BR>
<BR>
<BR>
On 9/9/10 7:12 AM, &quot;Eric Sandeen&quot; &lt;<a href=3D"sandeen@sandeen.=
net">sandeen@sandeen.net</a>&gt; wrote:<BR>
<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"=
><SPAN STYLE=3D'font-size:11pt'>Brady Chang wrote:<BR>
&gt; Hello All,<BR>
&gt; I have an issue with fragmentation on a particular device<BR>
&gt; thanks for any advice.<BR>
&gt;<BR>
&gt; -Brady<BR>
&gt;<BR>
&gt; I have a Dell r510 with 12 disks<BR>
&gt; 2xraid 5 (6 disks each)<BR>
&gt; raid group1:<BR>
&gt; 48 GB &nbsp;&nbsp;carved out for os mounted as /<BR>
&gt; remaining space &nbsp;2.7 TB for xfs mounted as /data1<BR>
&gt; raid group2:<BR>
&gt; 48 GB &nbsp;for swap<BR>
&gt; remaining space 2.7 TB for xfs mounted as /data2<BR>
&gt;<BR>
&gt; The strange thing is that /data1 never gets fragmented where as /data2=
<BR>
&gt; is badly fragmented.<BR>
&gt; I believe increase allocsize would help, but not sure how to explain w=
hy<BR>
&gt; /data2(/dev/sdd) always gets fragmented and not /data1(/dev/sdb)<BR>
&gt;<BR>
&gt; It's a data warehouse application. &nbsp;the I/O is balanced between /=
data1<BR>
&gt; and /data2:<BR>
&gt; output of xfs_db<BR>
&gt; [root@sdw4 data1]# xfs_db -c frag -r /dev/sdb<BR>
&gt; actual 14353, ideal 13702, fragmentation factor 4.54%<BR>
&gt; [root@sdw4 data1]# xfs_db -c frag -r /dev/sdd<BR>
&gt; actual 408674, ideal 13719, fragmentation factor 96.64%<BR>
<BR>
so each file has 30 extents on average (actual/ideal)<BR>
<BR>
&gt; df output<BR>
&gt; /dev/sdb &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;2.7T &nbsp;967G &nbsp;1.8T &nbsp;36% /data1<BR>
&gt; /dev/sdd &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;2.7T &nbsp;1.1T &nbsp;1.7T &nbsp;39% /data2<BR>
<BR>
1.1T/408674 extents is ~3M per extent, not so good.<BR>
<BR>
How many files are on each fs?<BR>
<BR>
&gt; LABEL=3D/data1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/data1 &nbsp;=
&nbsp;&nbsp;&nbsp;xfs<BR>
&gt; &nbsp;&nbsp;&nbsp;&nbsp;allocsize=3D1048576,logbufs=3D8,noatime,nodira=
time 0 0<BR>
&gt; LABEL=3D/data2 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/data2 &nbsp;=
&nbsp;&nbsp;&nbsp;xfs<BR>
&gt; &nbsp;&nbsp;&nbsp;&nbsp;allocsize=3D1048576,logbufs=3D8,noatime,nodira=
time 0 0<BR>
<BR>
Everything but the first option is default, BTW.<BR>
<BR>
Is xfs_info output on the 2 filesystems the same?<BR>
<BR>
Otherwise Emmanuel's idea is a good one, maybe it's not<BR>
as balanced as you think it is, or maybe they have aged<BR>
differently and have different amounts of freespace<BR>
(see the freesp command in xfs_db)<BR>
<BR>
&gt; By the way, the os is RHEL 5.5 kernel 2.6.18-194.11.1.el5<BR>
<BR>
Was Red Hat support not helpful?<BR>
<BR>
-Eric<BR>
<BR>
<BR>
</SPAN></FONT></BLOCKQUOTE>
</BODY>
</HTML>


--_000_C8AEBF606E45bchanggreenplumcom_--


--===============1484455186113515449==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1484455186113515449==--
