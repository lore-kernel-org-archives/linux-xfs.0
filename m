Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47CiJjP044694 for <xfs@oss.sgi.com>; Mon, 7 May 2012 07:44:19 -0500
Received: from mail-wi0-f169.google.com (mail-wi0-f169.google.com
	[209.85.212.169]) by cuda.sgi.com with ESMTP id
	rFt21w8lRatNkbvV (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 05:44:18 -0700 (PDT)
Received: by wibhn14 with SMTP id hn14so846721wib.2
	for <xfs@oss.sgi.com>; Mon, 07 May 2012 05:44:17 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 May 2012 20:44:17 +0800
Message-ID: <CAF7KpS-r4zRXZxBU3U8ohxA85-rEvbAzCewYZDr44MNdP+YmFg@mail.gmail.com>
Subject: fallocate bug?
From: Zhu Han <schumi.han@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2336685928020412430=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2336685928020412430==
Content-Type: multipart/alternative; boundary=f46d043892abd4f7ae04bf71a0a1

--f46d043892abd4f7ae04bf71a0a1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Seems like xfs of CentOS 6.X occupies much more storage space than desired
if fallocate is used against the file. Here is the step to reproduce it:

By the way, is it normal when the file is moved around after the
preallocated region is filled with data?

$ uname -r
2.6.32-220.7.1.el6.x86_64

$fallocate -n --offset 0 -l 1G file    ---->Write a little more data than
the preallocated size

$ xfs_bmap -p -vv file
file:
 EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET
TOTAL FLAGS
   0: [0..2097151]:    2593408088..2595505239 21 (29420144..31517295)
2097152 10000

$ dd if=3D/dev/zero of=3D/tmp/file bs=3D1M count=3D1026 conv=3Dfsync

$ xfs_bmap -p -vv file
file:
 EXT: FILE-OFFSET      BLOCK-RANGE            AG AG-OFFSET
TOTAL FLAGS
   0: [0..4194303]:    2709184016..2713378319 22 (23101408..27295711)
4194304 00000

$ du -h --apparent-size file
1.1G    file

$du -h file
2.0G

best regards,
=E9=9F=A9=E7=AB=B9(Zhu Han)

--f46d043892abd4f7ae04bf71a0a1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Seems like xfs of CentOS 6.X occupies much more storage space than desired =
if fallocate is used against the file. Here is the step to reproduce it:<br=
><br>By the way, is it normal when the file is moved around after the preal=
located region is filled with data? <br>
<br>$ uname -r<br>2.6.32-220.7.1.el6.x86_64<br><br>$fallocate -n --offset 0=
 -l 1G file=C2=A0=C2=A0=C2=A0 ----&gt;Write a little more data than the pre=
allocated size<br><br>$ xfs_bmap -p -vv file<br>file:<br>=C2=A0EXT: FILE-OF=
FSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 AG AG-OFFSET=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL FLAGS<br>
=C2=A0=C2=A0 0: [0..2097151]:=C2=A0=C2=A0=C2=A0 2593408088..2595505239 21 (=
29420144..31517295) 2097152 10000<br><br>$ dd if=3D/dev/zero of=3D/tmp/file=
 bs=3D1M count=3D1026 conv=3Dfsync<br><br>$ xfs_bmap -p -vv file<br>file:<b=
r>=C2=A0EXT: FILE-OFFSET=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLOCK-RANGE=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 AG AG-OFFSET=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 TOTAL FLAGS<br>
=C2=A0=C2=A0 0: [0..4194303]:=C2=A0=C2=A0=C2=A0 2709184016..2713378319 22 (=
23101408..27295711) 4194304 00000<br><br>$ du -h --apparent-size file<br>1.=
1G=C2=A0=C2=A0=C2=A0 file<br><br>$du -h file<br>2.0G<br><br clear=3D"all">b=
est regards,<br>
=E9=9F=A9=E7=AB=B9(Zhu Han)<br>

--f46d043892abd4f7ae04bf71a0a1--


--===============2336685928020412430==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2336685928020412430==--
