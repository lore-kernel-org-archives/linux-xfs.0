Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA710a9Q104881 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 19:00:36 -0600
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id HSjB57rtNXXNbM8f
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Nov 2012 17:02:32 -0800 (PST)
Received: by mail-we0-f181.google.com with SMTP id u54so532753wey.26
	for <xfs@oss.sgi.com>; Tue, 06 Nov 2012 17:02:31 -0800 (PST)
MIME-Version: 1.0
From: huubby zhou <huubby1@gmail.com>
Date: Wed, 7 Nov 2012 09:02:11 +0800
Message-ID: <CANS6a=D4SMMqhGJVMLbr-BWqLb-Z4L4LnofzfhqChBvE9dEtPQ@mail.gmail.com>
Subject: How to reserve disk space in XFS to make the blocks over many files
	continuous?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4956874693761552655=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4956874693761552655==
Content-Type: multipart/alternative; boundary=f46d04426de2e853e304cddd45b7

--f46d04426de2e853e304cddd45b7
Content-Type: text/plain; charset=UTF-8

Hi, folks,

I'm using *CentOS5.8*, with *XFS* filesystem extend storage disks. What I
want to do is, pre-allocating many files, with continuous blocks in
filesystem, both single file and crossing files. That is the start block ID
of the next file is following the end block ID of current file.

I could do space pre-allocation by *posix_allocate()*, problem is the API
zeros all disk space, I can't afford time consuming(I'm not sure if this
API could make the blocks continuous). then I tried
*xfsctl()*<http://linux.die.net/man/3/xfsctl>,
with *XFS_IOC_RESVSP* flag, I can reserve space faster.

The problem with *xfsctl()* is, it could make the blocks continuous for
individual file, but the blocks over files are *not* continuous. For
example, 10 files, a/b/c/d/e/f... reserved. After I do the real writing to
these files, it turns out the file 'b' isn't next to file 'a', and some
file could be far from both previous one and next one, though other files
may be neighboring with each other, rarely.

I use the following code to do the pre-allocation:

ftruncate(fd, FILE_SIZE);

xfs_flock_t flag = {0};
flag.l_whence = SEEK_SET;
flag.l_start  = 0;
flag.l_len    = 512*1024*1024;
xfsctl(fileName, fd, XFS_IOC_RESVSP64, &flag);

My question is, how can I guarantee the file system blocks over files
continuous? Thanks for your time and appreciate your answer.

--f46d04426de2e853e304cddd45b7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi, folks,<div><br></div><div><p style=3D"margin:0px 0px 1em;padding:0px;bo=
rder:0px;font-size:14px;vertical-align:baseline;clear:both;word-wrap:break-=
word;color:rgb(0,0,0);font-family:Arial,&#39;Liberation Sans&#39;,&#39;Deja=
Vu Sans&#39;,sans-serif;line-height:18px">

I&#39;m using=C2=A0<em style=3D"margin:0px;padding:0px;border:0px;vertical-=
align:baseline;background-color:transparent">CentOS5.8</em>, with=C2=A0<em =
style=3D"margin:0px;padding:0px;border:0px;vertical-align:baseline;backgrou=
nd-color:transparent">XFS</em>=C2=A0filesystem extend storage disks. What I=
 want to do is, pre-allocating many files, with continuous blocks in filesy=
stem, both single file and crossing files. That is the start block ID of th=
e next file is following the end block ID of current file.</p>

<p style=3D"margin:0px 0px 1em;padding:0px;border:0px;font-size:14px;vertic=
al-align:baseline;clear:both;word-wrap:break-word;color:rgb(0,0,0);font-fam=
ily:Arial,&#39;Liberation Sans&#39;,&#39;DejaVu Sans&#39;,sans-serif;line-h=
eight:18px">

I could do space pre-allocation by=C2=A0<strong style=3D"margin:0px;padding=
:0px;border:0px;vertical-align:baseline;background-color:transparent">posix=
_allocate()</strong>, problem is the API zeros all disk space, I can&#39;t =
afford time consuming(I&#39;m not sure if this API could make the blocks co=
ntinuous). then I tried=C2=A0<a href=3D"http://linux.die.net/man/3/xfsctl" =
rel=3D"nofollow" style=3D"margin:0px;padding:0px;border:0px;vertical-align:=
baseline;background-color:transparent;color:rgb(74,107,130);text-decoration=
:none"><strong style=3D"margin:0px;padding:0px;border:0px;vertical-align:ba=
seline;background-color:transparent">xfsctl()</strong></a>, with=C2=A0<stro=
ng style=3D"margin:0px;padding:0px;border:0px;vertical-align:baseline;backg=
round-color:transparent">XFS_IOC_RESVSP</strong>=C2=A0flag, I can reserve s=
pace faster.</p>

<p style=3D"margin:0px 0px 1em;padding:0px;border:0px;font-size:14px;vertic=
al-align:baseline;clear:both;word-wrap:break-word;color:rgb(0,0,0);font-fam=
ily:Arial,&#39;Liberation Sans&#39;,&#39;DejaVu Sans&#39;,sans-serif;line-h=
eight:18px">

The problem with=C2=A0<strong style=3D"margin:0px;padding:0px;border:0px;ve=
rtical-align:baseline;background-color:transparent">xfsctl()</strong>=C2=A0=
is, it could make the blocks continuous for individual file, but the blocks=
 over files are=C2=A0<em style=3D"margin:0px;padding:0px;border:0px;vertica=
l-align:baseline;background-color:transparent">not</em>=C2=A0continuous. Fo=
r example, 10 files, a/b/c/d/e/f... reserved. After I do the real writing t=
o these files, it turns out the file &#39;b&#39; isn&#39;t next to file &#3=
9;a&#39;, and some file could be far from both previous one and next one, t=
hough other files may be neighboring with each other, rarely.</p>

<p style=3D"margin:0px 0px 1em;padding:0px;border:0px;font-size:14px;vertic=
al-align:baseline;clear:both;word-wrap:break-word;color:rgb(0,0,0);font-fam=
ily:Arial,&#39;Liberation Sans&#39;,&#39;DejaVu Sans&#39;,sans-serif;line-h=
eight:18px">

I use the following code to do the pre-allocation:</p><pre style=3D"margin-=
top:0px;margin-bottom:10px;padding:5px;border:0px;font-size:14px;vertical-a=
lign:baseline;background-color:rgb(238,238,238);font-family:Consolas,Menlo,=
Monaco,&#39;Lucida Console&#39;,&#39;Liberation Mono&#39;,&#39;DejaVu Sans =
Mono&#39;,&#39;Bitstream Vera Sans Mono&#39;,&#39;Courier New&#39;,monospac=
e,serif;overflow:auto;width:auto;max-height:600px;color:rgb(0,0,0);line-hei=
ght:18px">

<code style=3D"margin:0px;padding:0px;border:0px;vertical-align:baseline;fo=
nt-family:Consolas,Menlo,Monaco,&#39;Lucida Console&#39;,&#39;Liberation Mo=
no&#39;,&#39;DejaVu Sans Mono&#39;,&#39;Bitstream Vera Sans Mono&#39;,&#39;=
Courier New&#39;,monospace,serif">ftruncate(fd, FILE_SIZE);

xfs_flock_t flag =3D {0};
flag.l_whence =3D SEEK_SET;
flag.l_start  =3D 0;
flag.l_len    =3D 512*1024*1024;
xfsctl(fileName, fd, XFS_IOC_RESVSP64, &amp;flag);
</code></pre><p style=3D"margin:0px 0px 1em;padding:0px;border:0px;font-siz=
e:14px;vertical-align:baseline;clear:both;word-wrap:break-word;color:rgb(0,=
0,0);font-family:Arial,&#39;Liberation Sans&#39;,&#39;DejaVu Sans&#39;,sans=
-serif;line-height:18px">

My question is, how can I guarantee the file system blocks over files conti=
nuous? Thanks for your time and appreciate your answer.</p></div>

--f46d04426de2e853e304cddd45b7--


--===============4956874693761552655==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4956874693761552655==--
