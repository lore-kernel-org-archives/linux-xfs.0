Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F24E27F5A
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 07:41:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB1BB8F8040
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2014 05:41:10 -0700 (PDT)
Received: from mail-qc0-f171.google.com (mail-qc0-f171.google.com
	[209.85.216.171]) by cuda.sgi.com with ESMTP id
	mDvlGZIF52X3qHEf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 05 Jul 2014 05:41:08 -0700 (PDT)
Received: by mail-qc0-f171.google.com with SMTP id w7so2240406qcr.16
	for <xfs@oss.sgi.com>; Sat, 05 Jul 2014 05:41:07 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 Jul 2014 14:41:06 +0200
Message-ID: <CAA85NCjXU7rK8C4AcQ4Tnxowx5MFBUyAoLW_nuwmKyOFL-_PgQ@mail.gmail.com>
Subject: Data loss XFS with RT kernel on Debian.
From: Jan de Kruyf <jan.de.kruyf@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2896802728854414142=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2896802728854414142==
Content-Type: multipart/alternative; boundary=001a11c1747648813a04fd718e56

--001a11c1747648813a04fd718e56
Content-Type: text/plain; charset=UTF-8

Hallo,

While doing a reasonably high density job like rsynching a subdirectory
from one place to another, or tarring it to a pipe and untarring it at the
other end, I note that the cpu usage goes practically to 100% and when I
after 5 minutes or so I reset the computer the writing has not finished at
all.
However on the stock Debian kernel it works without a problem.

Could I still use this combination in an industrial environment reading and
writing reasonably short text files? So far I did not experience this
problem with normal day to day use. It stuck up its head during
installation of   gnat-gpl-2014-x86_64-linux-bin from the
http://libre.adacore.com/download/ page. The offending code is in the
Makefile in the top directory page. The Xterm will give you the place where
it gets stuck.

Regards,

Jan de Kruijf.


Her are the details of the installation:

root@jan:~# xfs_info -V
xfs_info version 3.1.7

root@jan:~# xfs_info /usr
meta-data=/dev/sda3 isize=256 agcount=4, agsize=732416 blks
              = sectsz=512 attr=2
       data = bsize=4096 blocks=2929664, imaxpct=25
               = sunit=0 swidth=0 blks
naming =version 2 bsize=4096 ascii-ci=0
log =internal bsize=4096 blocks=2560, version=2
       = sectsz=512 sunit=0 blks, lazy-count=1
realtime =none extsz=4096 blocks=0, rtextents=0

This combination does not work:
root@jan:~# uname -a
Linux jan 3.14-0.bpo.1-rt-amd64 #1 SMP PREEMPT RT Debian 3.14.7-1~bpo70+1
(2014-06-21) x86_64 GNU/Linux

Also kernel 3.10-0.bpo.3-rt-amd64 does not work

But this combination works:
 root@jan:~# uname -a
Linux jan 3.2.0-4-amd64 #1 SMP Debian 3.2.57-3+deb7u2 x86_64 GNU/Linux

--001a11c1747648813a04fd718e56
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hallo,<br></div><div><br></div><div>While doing a rea=
sonably high density job like rsynching a subdirectory from one place to an=
other, or tarring it to a pipe and untarring it at the other end, I note th=
at the cpu usage goes practically to 100% and when I after 5 minutes or so =
I reset the computer the writing has not finished at all.</div>
<div>However on the stock Debian kernel it works without a problem.</div><d=
iv><br></div><div>Could I still use this combination in an industrial envir=
onment reading and writing reasonably short text files? So far I did not ex=
perience this problem with normal day to day use. It stuck up its head duri=
ng installation of=C2=A0 =C2=A0gnat-gpl-2014-x86_64-linux-bin from the <a h=
ref=3D"http://libre.adacore.com/download">http://libre.adacore.com/download=
</a>/ page. The offending code is in the Makefile in the top directory page=
. The Xterm will give you the place where it gets stuck.</div>
<div><br></div><div>Regards,</div><div><br></div><div>Jan de Kruijf.</div><=
div><br></div><div><br></div><div>Her are the details of the installation:<=
/div><div><br></div><div>root@jan:~# xfs_info -V<br>xfs_info version 3.1.7<=
/div>
<div><br></div><div>root@jan:~# xfs_info /usr<br>meta-data=3D/dev/sda3     =
         isize=3D256    agcount=3D4, agsize=3D732416 blks</div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D                       sectsz=
=3D512   attr=3D2<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0data     =3D               =
        bsize=3D4096   blocks=3D2929664, imaxpct=3D25<br>
=C2=A0        =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D          =
             sunit=3D0      swidth=3D0 blks<br>naming   =3Dversion 2       =
       bsize=3D4096   ascii-ci=3D0<br>log      =3Dinternal               bs=
ize=3D4096   blocks=3D2560, version=3D2<br>=C2=A0        =C2=A0 =C2=A0 =C2=
=A0=3D                       sectsz=3D512   sunit=3D0 blks, lazy-count=3D1<=
br>
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0=
</div><div><br></div><div>This combination does not work:</div><div>root@ja=
n:~# uname -a<br>Linux jan 3.14-0.bpo.1-rt-amd64 #1 SMP PREEMPT RT Debian 3=
.14.7-1~bpo70+1 (2014-06-21) x86_64 GNU/Linux</div>
<div><br></div><div>Also kernel 3.10-0.bpo.3-rt-amd64 does not work</div><d=
iv><br></div><div>But this combination works:</div><div>=C2=A0root@jan:~# u=
name -a<br>Linux jan 3.2.0-4-amd64 #1 SMP Debian 3.2.57-3+deb7u2 x86_64 GNU=
/Linux</div>
</div>

--001a11c1747648813a04fd718e56--


--===============2896802728854414142==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2896802728854414142==--
