Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p11765b1164167 for <xfs@oss.sgi.com>; Tue, 1 Feb 2011 01:06:06 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA8DB1A6330B
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 23:08:33 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id QVAXIxO40yJTGyIw
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 23:08:33 -0800 (PST)
Received: by qwe5 with SMTP id 5so6889295qwe.26
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 23:08:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikyOfkbtxN3Et5YZRJ2rPpdsVouJkyRW4fDbUG7@mail.gmail.com>
References: <AANLkTimoZE8kD2Qz+ynZhceGuHqZxe9VSHKXho_tbdWi@mail.gmail.com>
	<AANLkTikyOfkbtxN3Et5YZRJ2rPpdsVouJkyRW4fDbUG7@mail.gmail.com>
Date: Tue, 1 Feb 2011 16:08:33 +0900
Message-ID: <AANLkTimF7ie1DSka0MYQRdF04kcaQZ3rHJerhSdsV_yt@mail.gmail.com>
Subject: Re: [patch] xfsprogs: repair never return if device removed
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2264491511562687580=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2264491511562687580==
Content-Type: multipart/alternative; boundary=0015175cb2c24c8972049b333364

--0015175cb2c24c8972049b333364
Content-Type: text/plain; charset=ISO-8859-1

xfsprogs: repair hang in find secondary sb on device removal

xfs_repair does not handle read() error, while searching secondary
superblock.This problem is identified with a simple test case.

Delete primary superblock of xfs partition with
        #dd if=/dev/zero of=/dev/sda1 bs=512 count=1
        #sync
Run xfs_repair,
While its searching for secondary superblock, remove the storage.
xfs_repair will loop in never ending ............

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

diff -Nurp xfsprogs-3.0.5/repair/sb.c xfsprogs-3.0.5-dirty/repair/sb.c
--- xfsprogs-3.0.5/repair/sb.c  2011-01-28 20:23:02.000000000 +0900
+++ xfsprogs-3.0.5-dirty/repair/sb.c    2011-02-01 15:46:35.000000000 +0900
@@ -122,7 +122,7 @@ find_secondary_sb(xfs_sb_t *rsb)
                        done = 1;
                }

-               if (!done && (bsize = read(x.dfd, sb, BSIZE)) == 0)  {
+               if (!done && (bsize = read(x.dfd, sb, BSIZE)) <= 0)  {
                        done = 1;
                }

--0015175cb2c24c8972049b333364
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>xfsprogs: repair hang in find secondary sb on device removal<br>=A0<br=
>xfs_repair does not handle read() error, while searching secondary<br>supe=
rblock.This problem is identified with a simple test case.<br>=A0<br>Delete=
 primary superblock of xfs partition with<br>
=A0=A0=A0=A0=A0=A0=A0 #dd if=3D/dev/zero of=3D/dev/sda1 bs=3D512 count=3D1<=
br>=A0=A0=A0=A0=A0=A0=A0 #sync<br>Run xfs_repair,<br>While its searching fo=
r secondary superblock, remove the storage.<br>xfs_repair will loop in neve=
r ending ............<br>=A0<br>Signed-off-by: Ajeet Yadav &lt;<a href=3D"m=
ailto:ajeet.yadav.77@gmail.com">ajeet.yadav.77@gmail.com</a>&gt;<br>
=A0<br>diff -Nurp xfsprogs-3.0.5/repair/sb.c xfsprogs-3.0.5-dirty/repair/sb=
.c<br>--- xfsprogs-3.0.5/repair/sb.c=A0 2011-01-28 20:23:02.000000000 +0900=
<br>+++ xfsprogs-3.0.5-dirty/repair/sb.c=A0=A0=A0 2011-02-01 15:46:35.00000=
0000 +0900<br>
@@ -122,7 +122,7 @@ find_secondary_sb(xfs_sb_t *rsb)<br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 done =3D 1;<br>=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<br>=A0<br>-=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 if (!done &amp;&amp; (bsize =3D read(x.dfd, sb, BSIZE=
)) =3D=3D 0)=A0 {<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!done =
&amp;&amp; (bsize =3D read(x.dfd, sb, BSIZE)) &lt;=3D 0)=A0 {<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 done =
=3D 1;<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }</div>
<div>=A0</div>

--0015175cb2c24c8972049b333364--


--===============2264491511562687580==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2264491511562687580==--
