Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8703A29DFA
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 12:08:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 644578F8066
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 10:08:45 -0700 (PDT)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com
	[209.85.223.177]) by cuda.sgi.com with ESMTP id
	ICYXp5h5JisCCsbl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Apr 2013 10:08:44 -0700 (PDT)
Received: by mail-ie0-f177.google.com with SMTP id 9so4787044iec.8
	for <xfs@oss.sgi.com>; Fri, 19 Apr 2013 10:08:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5171790C.70400@sandeen.net>
References: <516C89DF.4070904@redhat.com>
	<CADFMGu+z32O5mVBfO6gb8F03y9mrwB5=nf+7LMbky4ttk2mbFw@mail.gmail.com>
	<BA50C18A-BE51-4658-B05E-3EDB0F11BE36@sandeen.net>
	<CADFMGuKfXwY=Z9dg6+wyX7mKzppu1hQhsqxcr9Fd=DjP4hii9w@mail.gmail.com>
	<CADFMGuLDwde8te0Cs4-T9fdVmq2v22fmSTgkYbULHS3voHzw6A@mail.gmail.com>
	<CADFMGuKmmJCz+FxsFL9KegqzNhhHsG2ZbVjrwCDyNCh1R_Zgpw@mail.gmail.com>
	<516FDBDE.1070406@redhat.com>
	<CADFMGuJ-An9MMmYtOKEjt5JdHmvu-cc0G+y361e_fioYf4j7HQ@mail.gmail.com>
	<51705EC4.4000306@redhat.com>
	<CADFMGu+hPV9RanG7298TAYY4p9gMiBOk0+mq5gf5rhQUWXf4TQ@mail.gmail.com>
	<CADFMGuJYDp-YrPDqsz2KKx6_2RCkP37ZNGPLzdTVOpEgKDMsjA@mail.gmail.com>
	<51715BD4.8080501@sandeen.net>
	<CADFMGuLjsNBeWE8wTDBgophhpixm3p+wY=9QWwk5u483zL0C4g@mail.gmail.com>
	<CADFMGuKuL8=B_NY=pKq5gj3aOK0kW0xuPWA=rSCDyziUgWGX6w@mail.gmail.com>
	<51716DCB.4060407@sandeen.net>
	<CADFMGuJH106wg7zVQrt604DxvDWB_bnor==NEGpJ1Xcr9b+C8A@mail.gmail.com>
	<CADFMGuLcve0a5uiOzZYoVze8tm1UXTPxhEqForMWYsvCyuh0sg@mail.gmail.com>
	<5171790C.70400@sandeen.net>
Date: Sat, 20 Apr 2013 01:08:44 +0800
Message-ID: <CADFMGuKfyw-mCsRn1Y5H5ek+z_nRMHDmW4bG-Ez9ANJm7_ec5A@mail.gmail.com>
Subject: Re: xfs_iunlink_remove: xfs_inotobp() returned error 22 -- debugging
From: =?GB2312?B?t/vTwMzO?= <yongtaofu@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7830701367123215616=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============7830701367123215616==
Content-Type: multipart/alternative; boundary=047d7bd75dec80443104dab9c51c

--047d7bd75dec80443104dab9c51c
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: quoted-printable

There it is, I use latest 279.19.1 and only apply xfs trace path.


2013/4/20 Eric Sandeen <sandeen@sandeen.net>

> On 4/19/13 10:00 AM, =B7=FB=D3=C0=CC=CE wrote:
> > Dear Eric,
> >
> > I checked rh srpm
> https://content-web.rhn.redhat.com/rhn/public/NULL/kernel/2.6.32-279.19.1=
.el6/SRPMS/kernel-2.6.32-279.19.1.el6.src.rpm?__gda__=3D1366390847_8550b856=
8c50ea46b3180266b476353d&ext=3D.rpm
> > And the code is same, as following:
> >
> > __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)
> > {
>
> need to look in lib/rwsem.c not lib/rwsem-spinlock.c
>
> Thanks,
> -Eric
>
>


--=20
=B7=FB=D3=C0=CC=CE

--047d7bd75dec80443104dab9c51c
Content-Type: text/html; charset=GB2312
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">There it is, I use latest 279.19.1 and only apply xfs trac=
e path.<br></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quo=
te">2013/4/20 Eric Sandeen <span dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@=
sandeen.net" target=3D"_blank">sandeen@sandeen.net</a>&gt;</span><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 4/19/13 10:00 AM, =B7=
=FB=D3=C0=CC=CE wrote:<br>
&gt; Dear Eric,<br>
&gt;<br>
</div><div class=3D"im">&gt; I checked rh srpm <a href=3D"https://content-w=
eb.rhn.redhat.com/rhn/public/NULL/kernel/2.6.32-279.19.1.el6/SRPMS/kernel-2=
.6.32-279.19.1.el6.src.rpm?__gda__=3D1366390847_8550b8568c50ea46b3180266b47=
6353d&amp;ext=3D.rpm" target=3D"_blank">https://content-web.rhn.redhat.com/=
rhn/public/NULL/kernel/2.6.32-279.19.1.el6/SRPMS/kernel-2.6.32-279.19.1.el6=
.src.rpm?__gda__=3D1366390847_8550b8568c50ea46b3180266b476353d&amp;ext=3D.r=
pm</a><br>

&gt; And the code is same, as following:<br>
&gt;<br>
&gt; __rwsem_do_wake(struct rw_semaphore *sem, int wakewrite)<br>
&gt; {<br>
<br>
</div>need to look in lib/rwsem.c not lib/rwsem-spinlock.c<br>
<br>
Thanks,<br>
-Eric<br>
<br>
</blockquote></div><br><br clear=3D"all"><br>-- <br>=B7=FB=D3=C0=CC=CE
</div>

--047d7bd75dec80443104dab9c51c--


--===============7830701367123215616==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7830701367123215616==--
