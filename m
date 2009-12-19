Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBJ78PQJ060297 for <xfs@oss.sgi.com>; Sat, 19 Dec 2009 01:08:25 -0600
Received: from EXHUB018-3.exch018.msoutlookonline.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD7C019B30CF
	for <xfs@oss.sgi.com>; Fri, 18 Dec 2009 23:09:05 -0800 (PST)
Received: from EXHUB018-3.exch018.msoutlookonline.net
	(exhub018-3.exch018.msoutlookonline.net [64.78.17.18]) by
	cuda.sgi.com with ESMTP id YmCol7STQnmCYTAe for
	<xfs@oss.sgi.com>; Fri, 18 Dec 2009 23:09:05 -0800 (PST)
From: Brady Chang <bchang@greenplum.com>
Date: Fri, 18 Dec 2009 23:09:00 -0800
Subject: xfs in memory corruption
Message-ID: <C751BC0C.A22%bchang@greenplum.com>
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
Content-Type: multipart/mixed; boundary="===============1166403085749286239=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1166403085749286239==
Content-Language: en
Content-Type: multipart/alternative;
	boundary="_000_C751BC0CA22bchanggreenplumcom_"

--_000_C751BC0CA22bchanggreenplumcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi all, got the following error on one of our test machines. SLES10 SP2 wit=
h stock kernel

I've not had the chance to scrutinize complete /var/log/messages for additi=
onal helpful info.
Any advanced help is appreciated.

thanks!
-Brady

Dec 23 14:21:45 sdw5 kernel: Filesystem "sde": XFS internal error xfs_trans=
_cancel at line 1175 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff8826ca0c
Dec 23 14:21:45 sdw5 kernel:
Dec 23 14:21:45 sdw5 kernel: Call Trace: <ffffffff88265456>{:xfs:xfs_trans_=
cancel+91}
Dec 23 14:21:45 sdw5 kernel:        <ffffffff8826ca0c>{:xfs:xfs_create+1395=
} <ffffffff8827700b>{:xfs:xfs_vn_mknod+429}
Dec 23 14:21:45 sdw5 kernel:        <ffffffff80192f3a>{vfs_create+390} <fff=
fffff801962cf>{open_namei+421}
Dec 23 14:21:45 sdw5 kernel:        <ffffffff80184313>{do_filp_open+28} <ff=
ffffff80184374>{do_sys_open+69}
Dec 23 14:21:45 sdw5 kernel:        <ffffffff8010ae42>{system_call+126}
Dec 23 14:21:45 sdw5 kernel: xfs_force_shutdown(sde,0x8) called from line 1=
176 of file fs/xfs/xfs_trans.c.  Return address =3D 0xffffffff88265475
Dec 23 14:21:45 sdw5 kernel: postgres[5990]: segfault at 00007fff36319618 r=
ip 0000000000999556 rsp 00007fff36319620 error 6
Dec 23 14:21:45 sdw5 kernel: postgres[6152]: segfault at 00007fffd0793e00 r=
ip 00002ab7dad22d0d rsp 00007fffd0793dd0 error 6
Dec 23 14:21:45 sdw5 kernel: Filesystem "sde": Corruption of in-memory data=
 detected.  Shutting down filesystem: sde
Dec 23 14:21:45 sdw5 kernel: Please umount the filesystem, and rectify the =
problem(s)
Dec 23 14:21:45 sdw5 kernel: postgres[6170]: segfault at 00007fff5eb9efd0 r=
ip 00002aff4c918d0d rsp 00007fff5eb9efa0 error 6
Dec 23 14:21:45 sdw5 kernel: postgres[6062]: segfault at 00007fff32585878 r=
ip 0000000000999556 rsp 00007fff32585880 error 6

--_000_C751BC0CA22bchanggreenplumcom_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<HTML>
<HEAD>
<TITLE>xfs in memory corruption</TITLE>
</HEAD>
<BODY>
<FONT FACE=3D"Calibri, Verdana, Helvetica, Arial"><SPAN STYLE=3D'font-size:=
11pt'>Hi all, got the following error on one of our test machines. SLES10 S=
P2 with stock kernel<BR>
<BR>
I've not had the chance to scrutinize complete /var/log/messages for additi=
onal helpful info.<BR>
Any advanced help is appreciated.<BR>
<BR>
thanks!<BR>
-Brady<BR>
<BR>
Dec 23 14:21:45 sdw5 kernel: Filesystem &quot;sde&quot;: XFS internal error=
 xfs_trans_cancel at line 1175 of file fs/xfs/xfs_trans.c. =A0Caller 0xffff=
ffff8826ca0c<BR>
Dec 23 14:21:45 sdw5 kernel:<BR>
Dec 23 14:21:45 sdw5 kernel: Call Trace: &lt;ffffffff88265456&gt;{:xfs:xfs_=
trans_cancel+91}<BR>
Dec 23 14:21:45 sdw5 kernel: =A0=A0=A0=A0=A0=A0=A0&lt;ffffffff8826ca0c&gt;{=
:xfs:xfs_create+1395} &lt;ffffffff8827700b&gt;{:xfs:xfs_vn_mknod+429}<BR>
Dec 23 14:21:45 sdw5 kernel: =A0=A0=A0=A0=A0=A0=A0&lt;ffffffff80192f3a&gt;{=
vfs_create+390} &lt;ffffffff801962cf&gt;{open_namei+421}<BR>
Dec 23 14:21:45 sdw5 kernel: =A0=A0=A0=A0=A0=A0=A0&lt;ffffffff80184313&gt;{=
do_filp_open+28} &lt;ffffffff80184374&gt;{do_sys_open+69}<BR>
Dec 23 14:21:45 sdw5 kernel: =A0=A0=A0=A0=A0=A0=A0&lt;ffffffff8010ae42&gt;{=
system_call+126}<BR>
Dec 23 14:21:45 sdw5 kernel: xfs_force_shutdown(sde,0x8) called from line 1=
176 of file fs/xfs/xfs_trans.c. =A0Return address =3D 0xffffffff88265475<BR=
>
Dec 23 14:21:45 sdw5 kernel: postgres[5990]: segfault at 00007fff36319618 r=
ip 0000000000999556 rsp 00007fff36319620 error 6<BR>
Dec 23 14:21:45 sdw5 kernel: postgres[6152]: segfault at 00007fffd0793e00 r=
ip 00002ab7dad22d0d rsp 00007fffd0793dd0 error 6<BR>
Dec 23 14:21:45 sdw5 kernel: Filesystem &quot;sde&quot;: Corruption of in-m=
emory data detected. =A0Shutting down filesystem: sde<BR>
Dec 23 14:21:45 sdw5 kernel: Please umount the filesystem, and rectify the =
problem(s)<BR>
Dec 23 14:21:45 sdw5 kernel: postgres[6170]: segfault at 00007fff5eb9efd0 r=
ip 00002aff4c918d0d rsp 00007fff5eb9efa0 error 6<BR>
Dec 23 14:21:45 sdw5 kernel: postgres[6062]: segfault at 00007fff32585878 r=
ip 0000000000999556 rsp 00007fff32585880 error 6</SPAN></FONT>
</BODY>
</HTML>


--_000_C751BC0CA22bchanggreenplumcom_--


--===============1166403085749286239==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1166403085749286239==--
