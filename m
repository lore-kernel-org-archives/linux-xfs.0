Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAF9UFDp039966 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 03:30:15 -0600
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 635AF1E9CA4A
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 01:30:13 -0800 (PST)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id jDjAn3eH16FE0sK0 for
	<xfs@oss.sgi.com>; Tue, 15 Nov 2011 01:30:13 -0800 (PST)
Subject: Bug#553875: fixed in xfsprogs 3.1.6
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.553875.B553875.132134926030910@bugs.debian.org>
Date: Tue, 15 Nov 2011 20:27:29 +1100
From: Nathan Scott <nathans@debian.org>
In-reply-to: <20111115061822.GA6219@hall.aurel32.net>
Message-id: <CAAp5ZgMrzSdNdMRszvoCUs_AG3dy3QQrHMRL-EhcW31g0rAdrg@mail.gmail.com>
MIME-version: 1.0
References: <E1ROjxS-0007Tc-0c@franck.debian.org>
	<20111114214850.GA16572@volta.aurel32.net>
	<CAAp5ZgNLZHEJaHU3J+kspf0B6BbAtp=6hhwWbo3_NRLjVxO3=A@mail.gmail.com>
	<20111115061822.GA6219@hall.aurel32.net>
Reply-To: Nathan Scott <nathans@debian.org>, 553875@bugs.debian.org
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0666505794719879871=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: 553875@bugs.debian.org

--===============0666505794719879871==
Content-type: multipart/alternative; boundary=bcaec53af244ada2a304b1c2988f

--bcaec53af244ada2a304b1c2988f
Content-Type: text/plain; charset=ISO-8859-1

Hi,

On 15 November 2011 17:18, Aurelien Jarno <aurelien@aurel32.net> wrote:

> On Tue, Nov 15, 2011 at 12:00:50PM +1100, Nathan Scott wrote:
> > Hi Aurelien,
> >
> > On 15 November 2011 08:48, Aurelien Jarno <aurelien@aurel32.net> wrote:
> >
> > >
> > > This new version basically replaced the build-depends on
> > >  libreadline-gplv2-dev
> > > by a build-depends on
> > >  libreadline5-dev | libreadline-gplv2-dev
> > >
> > > Given libreadline5-dev is not in the archive, the package can't be
> > > built,
> >
> >
> > It seems to work as expected for me (iow, if either of the two are
> > installed, it proceeds with using the installed package).  I tested both
> > variants on latest unstable, so I'm at a loss to explain the failure
> you're
> > seeing - can you forward the build output showing the issue?
>
> The buildd daemons require that the first package of an alternative
> exists in the archive, which is not the case there.


*nod* - right you are - I look after another package which (by sheer good
luck) got these the other the way around, correctly, and its building fine.
 I'll get a patch out for review, and get a new release uploaded soon.

Thanks for the tip, Aurelien!

cheers.

--
Nathan

--bcaec53af244ada2a304b1c2988f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,<br><br><div class=3D"gmail_quote">On 15 November 2011 17:18, Aurelien J=
arno <span dir=3D"ltr">&lt;<a href=3D"mailto:aurelien@aurel32.net">aurelien=
@aurel32.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
On Tue, Nov 15, 2011 at 12:00:50PM +1100, Nathan Scott wrote:<br>
&gt; Hi Aurelien,<br>
&gt;<br>
&gt; On 15 November 2011 08:48, Aurelien Jarno &lt;<a href=3D"mailto:aureli=
en@aurel32.net">aurelien@aurel32.net</a>&gt; wrote:<br>
&gt;<br>
&gt; &gt;<br>
&gt; &gt; This new version basically replaced the build-depends on<br>
&gt; &gt; =A0libreadline-gplv2-dev<br>
&gt; &gt; by a build-depends on<br>
&gt; &gt; =A0libreadline5-dev | libreadline-gplv2-dev<br>
&gt; &gt;<br>
&gt; &gt; Given libreadline5-dev is not in the archive, the package can&#39=
;t be<br>
&gt; &gt; built,<br>
&gt;<br>
&gt;<br>
&gt; It seems to work as expected for me (iow, if either of the two are<br>
&gt; installed, it proceeds with using the installed package). =A0I tested =
both<br>
&gt; variants on latest unstable, so I&#39;m at a loss to explain the failu=
re you&#39;re<br>
&gt; seeing - can you forward the build output showing the issue?<br>
<br>
The buildd daemons require that the first package of an alternative<br>
exists in the archive, which is not the case there.</blockquote><div><br></=
div><div>*nod* - right you are - I look after another package which (by she=
er good luck) got these the other the way around, correctly, and its buildi=
ng fine. =A0I&#39;ll get a patch out for review, and get a new release uplo=
aded soon.</div>
<div><br></div><div>Thanks for the tip, Aurelien!</div><div><br></div><div>=
cheers.</div><div><br></div><div>--</div><div>Nathan</div></div>

--bcaec53af244ada2a304b1c2988f--



--===============0666505794719879871==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0666505794719879871==--
