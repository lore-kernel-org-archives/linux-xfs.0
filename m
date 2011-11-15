Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAF237DN010304 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 20:03:07 -0600
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 39DC4154910A
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 18:03:05 -0800 (PST)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id MSXLAqEjsX3TIc7B for
	<xfs@oss.sgi.com>; Mon, 14 Nov 2011 18:03:05 -0800 (PST)
Subject: Bug#553875: fixed in xfsprogs 3.1.6
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.553875.B553875.132132245629870@bugs.debian.org>
Date: Tue, 15 Nov 2011 12:00:50 +1100
From: Nathan Scott <nathans@debian.org>
In-reply-to: <20111114214850.GA16572@volta.aurel32.net>
Message-id: <CAAp5ZgNLZHEJaHU3J+kspf0B6BbAtp=6hhwWbo3_NRLjVxO3=A@mail.gmail.com>
MIME-version: 1.0
References: <E1ROjxS-0007Tc-0c@franck.debian.org>
	<20111114214850.GA16572@volta.aurel32.net>
Reply-To: Nathan Scott <nathans@debian.org>, 553875@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0456475234934826068=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: 553875@bugs.debian.org

--===============0456475234934826068==
Content-type: multipart/alternative; boundary=bcaec520e6edbaafde04b1bb84ba

--bcaec520e6edbaafde04b1bb84ba
Content-Type: text/plain; charset=ISO-8859-1

Hi Aurelien,

On 15 November 2011 08:48, Aurelien Jarno <aurelien@aurel32.net> wrote:

>
> This new version basically replaced the build-depends on
>  libreadline-gplv2-dev
> by a build-depends on
>  libreadline5-dev | libreadline-gplv2-dev
>
> Given libreadline5-dev is not in the archive, the package can't be
> built,


It seems to work as expected for me (iow, if either of the two are
installed, it proceeds with using the installed package).  I tested both
variants on latest unstable, so I'm at a loss to explain the failure you're
seeing - can you forward the build output showing the issue?

Allowing either package to satisfy the dependency means more people have
been able to continue to build and use these packages, which helps those
users who are not using unstable, so unless its not feasible I'd prefer to
leave that option open to them.

cheers.

--
Nathan

--bcaec520e6edbaafde04b1bb84ba
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Aurelien,<br><br><div class=3D"gmail_quote">On 15 November 2011 08:48, A=
urelien Jarno <span dir=3D"ltr">&lt;<a href=3D"mailto:aurelien@aurel32.net"=
>aurelien@aurel32.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_q=
uote" style=3D"margin: 0pt 0pt 0pt 0.8ex; border-left: 1px solid rgb(204, 2=
04, 204); padding-left: 1ex;">
<br>
This new version basically replaced the build-depends on<br>
 =A0libreadline-gplv2-dev<br>
by a build-depends on<br>
 =A0libreadline5-dev | libreadline-gplv2-dev<br>
<br>
Given libreadline5-dev is not in the archive, the package can&#39;t be<br>
built,</blockquote><div><br>It seems to work as expected for me (iow, if ei=
ther of the two are installed, it proceeds with using the installed package=
).=A0 I tested both variants on latest unstable, so I&#39;m at a loss to ex=
plain the failure you&#39;re seeing - can you forward the build output show=
ing the issue?<br>
<br>Allowing either package to satisfy the dependency means more people hav=
e been able to continue to build and use these packages, which helps those =
users who are not using unstable, so unless its not feasible I&#39;d prefer=
 to leave that option open to them.<br>
<br></div>cheers.<br></div><br>--<br>Nathan<br>

--bcaec520e6edbaafde04b1bb84ba--



--===============0456475234934826068==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0456475234934826068==--
