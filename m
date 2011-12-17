Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBHHMkss120719 for <xfs@oss.sgi.com>; Sat, 17 Dec 2011 11:22:47 -0600
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id Tr1xT54TlzWHzkUP
	for <xfs@oss.sgi.com>; Sat, 17 Dec 2011 09:22:45 -0800 (PST)
Received: by wgbdr1 with SMTP id dr1so6153904wgb.32
	for <xfs@oss.sgi.com>; Sat, 17 Dec 2011 09:22:44 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 17 Dec 2011 12:22:44 -0500
Message-ID: <CAEt9JqzmcRT2g6z1k3t5eFM7e1rvrrHQRf_enpvJx+HXgwOERA@mail.gmail.com>
Subject: xfsdump
From: William Moss <bill.m.moss@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5544942886145771455=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5544942886145771455==
Content-Type: multipart/alternative; boundary=f46d0442833231a63904b44cf79a

--f46d0442833231a63904b44cf79a
Content-Type: text/plain; charset=ISO-8859-1

Since approx. kernel 2.6.35 (kernel.org) I have been having a problem with
xfsdump(8) with my custom compiled kernels but not with the one that comes
with openSUSE. During a differential dump (1..9) it will lock up, become a
kernel stuck process that cannot be killed, while determining the files
that need to be dumped. This has not occurred with dump level zero nor with
the kernel as supplied from openSUSE. I have played with the kernel options
that seem relevant to xfs (a find for xfs as well as ACPI, etc.) and
nothing seems to effect the problem. Other than this, everything works fine
and the kernel has better performance and support in the areas that I
compile it for with respect to my hardware. I was hoping that you could
inform me as to what options for the kernel might cause this problem. Note
that a reboot or even an 'init 0 --- init 3' will clear the problem for at
least one more differential dump.

openSUSE: 11.4
CPU : AMD 64 AM2 socket
RAM: 4GB DDR2
Drives: SATA/3 Boot is a 650GB WD, /usr/local is a 1.5TB WD

Kernel: 3.1.4
I compile the kernel with the AMD64 optimization turned on.

Thank you!

--f46d0442833231a63904b44cf79a
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Since approx. kernel 2.6.35 (<a href=3D"http://kernel.org">kernel.org</a>) =
I have been having a problem with xfsdump(8) with my custom compiled kernel=
s but not with the one that comes with openSUSE. During a differential dump=
 (1..9) it will lock up, become a kernel stuck process that cannot be kille=
d, while determining the files that need to be dumped. This has not occurre=
d with dump level zero nor with the kernel as supplied from openSUSE. I hav=
e played with the kernel options that seem relevant to xfs (a find for xfs =
as well as ACPI, etc.) and nothing seems to effect the problem. Other than =
this, everything works fine and the kernel has better performance and suppo=
rt in the areas that I compile it for with respect to my hardware. I was ho=
ping that you could inform me as to what options for the kernel might cause=
 this problem. Note that a reboot or even an &#39;init 0 --- init 3&#39; wi=
ll clear the problem for at least one more differential dump.<br>
<br>openSUSE: 11.4<br>CPU : AMD 64 AM2 socket<br>RAM: 4GB DDR2<br>Drives: S=
ATA/3 Boot is a 650GB WD, /usr/local is a 1.5TB WD<br><br>Kernel: 3.1.4<br>=
I compile the kernel with the AMD64 optimization turned on. <br><br>Thank y=
ou!<br>

--f46d0442833231a63904b44cf79a--


--===============5544942886145771455==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5544942886145771455==--
