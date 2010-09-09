Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o89LuAW0119081 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 16:56:10 -0500
Received: from EXHUB018-4.exch018.msoutlookonline.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A1A51E61F47
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 14:56:54 -0700 (PDT)
Received: from EXHUB018-4.exch018.msoutlookonline.net
	(exhub018-4.exch018.msoutlookonline.net [64.78.17.19]) by
	cuda.sgi.com with ESMTP id PivX4fRvke9UYq8M for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 14:56:54 -0700 (PDT)
From: Brady Chang <bchang@greenplum.com>
Date: Thu, 9 Sep 2010 14:59:47 -0700
Subject: Re: fragmentation question
Message-ID: <C8AEA6E3.6E2E%bchang@greenplum.com>
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
Content-Type: multipart/mixed; boundary="===============2573671831867914319=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2573671831867914319==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_C8AEA6E36E2Ebchanggreenplumcom_"

--_000_C8AEA6E36E2Ebchanggreenplumcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

thanks guys for the feedback.
iostat shows balanced io between two filesystems.
testing with RHEL 54, no issues there. seems to be happening on RHEL 55 onl=
y.
I do not have the latest 55 kernel. I'm going to upgrade to the latest 55 k=
ernel and rerun the test.



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



--_000_C8AEA6E36E2Ebchanggreenplumcom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>Re: fragmentation question</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'>thanks guys for the feedback.<BR>
iostat shows balanced io between two filesystems.<BR>
testing with RHEL 54, no issues there. seems to be happening on RHEL 55 onl=
y.<BR>
I do not have the latest 55 kernel. I'm going to upgrade to the latest 55 k=
ernel and rerun the test.<BR>
<BR>
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


--_000_C8AEA6E36E2Ebchanggreenplumcom_--


--===============2573671831867914319==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2573671831867914319==--
