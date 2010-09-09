Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89NbSSs121811 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 18:37:28 -0500
Received: from EXHUB018-3.exch018.msoutlookonline.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DD8F117C9193
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 16:38:13 -0700 (PDT)
Received: from EXHUB018-3.exch018.msoutlookonline.net
	(exhub018-3.exch018.msoutlookonline.net [64.78.17.18]) by
	cuda.sgi.com with ESMTP id oSHk9SM9AxsC5oiC for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 16:38:13 -0700 (PDT)
From: Brady Chang <bchang@greenplum.com>
Date: Thu, 9 Sep 2010 16:41:04 -0700
Subject: Re: fragmentation question
Message-ID: <C8AEBEA0.6E43%bchang@greenplum.com>
In-Reply-To: <4C895A7D.1030208@sandeen.net>
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
Content-Type: multipart/mixed; boundary="===============7279969534480672307=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7279969534480672307==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_C8AEBEA06E43bchanggreenplumcom_"

--_000_C8AEBEA06E43bchanggreenplumcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thanks,
after couple runs of tpc-H , RHEL 5.4 /dev/sdd is heavily fragmented.
so back to the original problem. it always happen on /dev/sdd


[root@sdw9 data1]# xfs_db -c frag -r /dev/sdb
actual 1773, ideal 1731, fragmentation factor 2.37%

[root@sdw9 data1]# xfs_db -c frag -r /dev/sdd
actual 43384, ideal 1726, fragmentation factor 96.02%

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


67 files on both /dev/sdb and /dev/sdd.


On 9/9/10 3:06 PM, "Eric Sandeen" <sandeen@sandeen.net> wrote:

On 09/09/2010 04:59 PM, Brady Chang wrote:
> thanks guys for the feedback.
> iostat shows balanced io between two filesystems.
> testing with RHEL 54, no issues there. seems to be happening on RHEL 55
> only.

There were no xfs changes between 5.4 and 5.5 that should be relevant,
only a single bugfixes for 5.5, related to fallocate error returns.

Just FWIW.

-Eric


--_000_C8AEBEA06E43bchanggreenplumcom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: fragmentation question</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'>Thanks,<BR>
after couple runs of tpc-H , RHEL 5.4 /dev/sdd is heavily fragmented. <BR>
so back to the original problem. it always happen on /dev/sdd<BR>
<BR>
<BR>
[root@sdw9 data1]# xfs_db -c frag -r /dev/sdb<BR>
actual 1773, ideal 1731, fragmentation factor 2.37%<BR>
<BR>
[root@sdw9 data1]# xfs_db -c frag -r /dev/sdd<BR>
actual 43384, ideal 1726, fragmentation factor 96.02%<BR>
<BR>
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
nbsp;<B>blocks=3D32768</B>, version=3D1<BR>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=3D &nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sectsz=3D512 &nbsp;&nbsp;sunit=3D0 =
blks, lazy-count=3D0<BR>
realtime =3Dnone &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;extsz=3D4096 &nbsp;&nbsp;=
blocks=3D0, rtextents=3D0<BR>
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
sp;&nbsp;&nbsp;bsize=3D4096 &nbsp;&nbsp;blocks=3D<B>719030880</B>, imaxpct=
=3D25<BR>
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
<BR>
67 files on both /dev/sdb and /dev/sdd.<BR>
<BR>
<BR>
On 9/9/10 3:06 PM, &quot;Eric Sandeen&quot; &lt;<a href=3D"sandeen@sandeen.=
net">sandeen@sandeen.net</a>&gt; wrote:<BR>
<BR>
</SPAN></FONT><BLOCKQUOTE><FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"=
><SPAN STYLE=3D'font-size:11pt'>On 09/09/2010 04:59 PM, Brady Chang wrote:<=
BR>
&gt; thanks guys for the feedback.<BR>
&gt; iostat shows balanced io between two filesystems.<BR>
&gt; testing with RHEL 54, no issues there. seems to be happening on RHEL 5=
5<BR>
&gt; only.<BR>
<BR>
There were no xfs changes between 5.4 and 5.5 that should be relevant,<BR>
only a single bugfixes for 5.5, related to fallocate error returns.<BR>
<BR>
Just FWIW.<BR>
<BR>
-Eric<BR>
<BR>
</SPAN></FONT></BLOCKQUOTE>
</BODY>
</HTML>


--_000_C8AEBEA06E43bchanggreenplumcom_--


--===============7279969534480672307==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7279969534480672307==--
