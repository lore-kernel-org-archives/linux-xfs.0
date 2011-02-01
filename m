Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p112s55g143668 for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 20:54:05 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43A1F2A188C
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 18:56:32 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id NPTkPBaZzOPLRQ8q
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 18:56:32 -0800 (PST)
Received: by qwe5 with SMTP id 5so6711939qwe.26
	for <xfs@oss.sgi.com>; Mon, 31 Jan 2011 18:56:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110131041729.GJ21311@dastard>
References: <AANLkTiktigbHHHsYrxRBja6LxQ3N_gAq_KAoLNYGRB=r@mail.gmail.com>
	<20110131041729.GJ21311@dastard>
Date: Tue, 1 Feb 2011 11:56:32 +0900
Message-ID: <AANLkTinKMEzgmnNLQowSToVY45HJYBY2ktipAf9DE3pB@mail.gmail.com>
Subject: Re: [patch] xfsprogs: repair pagefault due to missed out sanity NULL
	check
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0114700587998418325=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0114700587998418325==
Content-Type: multipart/alternative; boundary=0015175cd0fc038043049b2fae10

--0015175cd0fc038043049b2fae10
Content-Type: text/plain; charset=ISO-8859-1

xfsprogs: repair pagefaults due to unhandled NULL check in da_read_buf()

xfs_repair does not correctly handle bplist[i] for error situations in
function da_read_buf(). If libxfs_readbuf() fails then bplist[i] = NULL,
but error handing code calls libxfs_putbuf(bdlist[i]) for all indexes of i
without first checking whether its NULL. This result in pagefault in
libpthread library during pthread_mutex_unlock().
This problem is identified when we remove the storage while xfs_repair
is running on it.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>

diff -Nurp xfsprogs/repair/dir2.c xfsprogs-dirty/repair/dir2.c
--- xfsprogs/repair/dir2.c      2010-07-16 13:07:09.000000000 +0900
+++ xfsprogs-dirty/repair/dir2.c        2011-01-28 18:49:21.000000000 +0900
@@ -110,9 +110,10 @@ da_read_buf(
                bplist[i] = libxfs_readbuf(mp->m_dev,
                                XFS_FSB_TO_DADDR(mp, bmp[i].startblock),
                                XFS_FSB_TO_BB(mp, bmp[i].blockcount), 0);
-               if (!bplist[i])
+               if (!bplist[i]){
+                       nex = i;
                        goto failed;
-
+               }
                pftrace("readbuf %p (%llu, %d)", bplist[i],
                        (long long)XFS_BUF_ADDR(bplist[i]),
                        XFS_BUF_COUNT(bplist[i]));

--0015175cd0fc038043049b2fae10
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>xfsprogs: repair pagefaults due to unhandled NULL check in da_read_buf=
()<br>=A0<br>xfs_repair does not correctly handle bplist[i] for error situa=
tions in<br>function da_read_buf(). If libxfs_readbuf() fails then bplist[i=
] =3D NULL,<br>
but error handing code calls libxfs_putbuf(bdlist[i]) for all indexes of i<=
br>without first checking whether its NULL. This result in pagefault in<br>=
libpthread library during pthread_mutex_unlock().<br>This problem is identi=
fied when we remove the storage while xfs_repair<br>
is running on it.<br>=A0<br>Signed-off-by: Ajeet Yadav &lt;<a href=3D"mailt=
o:ajeet.yadav.77@gmail.com">ajeet.yadav.77@gmail.com</a>&gt;<br>=A0<br>diff=
 -Nurp xfsprogs/repair/dir2.c xfsprogs-dirty/repair/dir2.c<br>--- xfsprogs/=
repair/dir2.c=A0=A0=A0=A0=A0 2010-07-16 13:07:09.000000000 +0900<br>
+++ xfsprogs-dirty/repair/dir2.c=A0=A0=A0=A0=A0=A0=A0 2011-01-28 18:49:21.0=
00000000 +0900<br>@@ -110,9 +110,10 @@ da_read_buf(<br>=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 bplist[i] =3D libxfs_readbuf(mp-&gt;m_dev,<br>=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 XFS_FSB_TO_DADDR(mp, bmp[i].startblock),<br>
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 XFS_FSB_TO_BB(mp, bmp[i].blockcount), 0);<br>-=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (!bplist[i])<br>+=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 if (!bplist[i]){<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nex =3D i;<br>=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto failed;<br>
-<br>+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }<br>=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 pftrace(&quot;readbuf %p (%llu, %d)&quot;, bplist[=
i],<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 (long long)XFS_BUF_ADDR(bplist[i]),<br>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 XFS_BUF_COUNT(bplist[i]));</div>

--0015175cd0fc038043049b2fae10--


--===============0114700587998418325==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0114700587998418325==--
