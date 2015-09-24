Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 44ADD7F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 04:26:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C379EAC005
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 02:26:56 -0700 (PDT)
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com
	[209.85.213.172]) by cuda.sgi.com with ESMTP id
	2OF4NWcdRwuVtu2B (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Sep 2015 02:26:55 -0700 (PDT)
Received: by igcpb10 with SMTP id pb10so10707889igc.1
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 02:26:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150923032550.GO3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-11-git-send-email-jtulak@redhat.com>
	<20150923032550.GO3902@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 24 Sep 2015 11:26:34 +0200
Message-ID: <CACj3i71cWQi0-YQuSEpVHP8P_6aTXJZZbzB84rhREa9kDpFZ8w@mail.gmail.com>
Subject: Re: [PATCH 10/14] xfsprogs: Add a timer implementation for OS X
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8088488961542890701=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8088488961542890701==
Content-Type: multipart/alternative; boundary=047d7bdca610f42f5905207ad455

--047d7bdca610f42f5905207ad455
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2015 at 5:25 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 15, 2015 at 11:59:20AM +0200, Jan Tulak wrote:
> > OS X does not have the timer used in xfs_repair.
> > Add a simple implementation providing the required
> > capabilities.
> ....
> >  #endif       /* __XFS_DARWIN_H__ */
> > diff --git a/repair/progress.c b/repair/progress.c
> > index 27cbaef..0fee7dc 100644
> > --- a/repair/progress.c
> > +++ b/repair/progress.c
> > @@ -184,10 +184,22 @@ progress_rpt_thread (void *p)
> >        */
> >
> >       timespec.it_value.tv_sec =3D msgp->interval;
> > -     timespec.it_value.tv_nsec =3D 0;
> >       timespec.it_interval.tv_sec =3D msgp->interval;
> > +     /*
> > +      * On some platforms (like OS X), timers and time things are
> slightly
> > +      * different: itimerspec is replaced with itimerval and timeval
> struct
> > +      * has no tv_nsec, but just tv_usec member.
> > +      * For compatibility, itimerspec is a macro defined to the existi=
ng
> > +      * itimerval on these platforms, and in such case, use usec inste=
ad
> > +      * of nsec.
> > +      */
> > +#ifndef itimerspec
> > +     timespec.it_value.tv_nsec =3D 0;
> >       timespec.it_interval.tv_nsec =3D 0;
> > -
> > +#else
> > +     timespec.it_value.tv_usec =3D 0;
> > +     timespec.it_interval.tv_usec =3D 0;
> > +#endif
>
> That's pretty nasty. How about this:
>
>         memset(&timespec, 0, sizeof(timespec));
>         timespec.it_value.tv_sec =3D msgp->interval;
>         timespec.it_interval.tv_sec =3D msgp->interval;
>

=E2=80=8BThis is much better and elegant =E2=80=8Bsolution. :-)

Cheers,
Jan


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7bdca610f42f5905207ad455
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Wed, Sep 23, 2015 at 5:25 AM, Dave Chinner <span dir=3D"ltr=
">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromor=
bit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">On Tue, Sep 15, 2015 at 11:59:20AM +0200, Jan Tulak wrote:<br>
&gt; OS X does not have the timer used in xfs_repair.<br>
&gt; Add a simple implementation providing the required<br>
&gt; capabilities.<br>
</span>....<br>
<div><div class=3D"h5">&gt;=C2=A0 #endif=C2=A0 =C2=A0 =C2=A0 =C2=A0/* __XFS=
_DARWIN_H__ */<br>
&gt; diff --git a/repair/progress.c b/repair/progress.c<br>
&gt; index 27cbaef..0fee7dc 100644<br>
&gt; --- a/repair/progress.c<br>
&gt; +++ b/repair/progress.c<br>
&gt; @@ -184,10 +184,22 @@ progress_rpt_thread (void *p)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0timespec.it_value.tv_sec =3D msgp-&gt;interv=
al;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0timespec.it_value.tv_nsec =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0timespec.it_interval.tv_sec =3D msgp-&gt;int=
erval;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * On some platforms (like OS X), timers and time=
 things are slightly<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * different: itimerspec is replaced with itimerv=
al and timeval struct<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * has no tv_nsec, but just tv_usec member.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * For compatibility, itimerspec is a macro defin=
ed to the existing<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * itimerval on these platforms, and in such case=
, use usec instead<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * of nsec.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +#ifndef itimerspec<br>
&gt; +=C2=A0 =C2=A0 =C2=A0timespec.it_value.tv_nsec =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0timespec.it_interval.tv_nsec =3D 0;<br>
&gt; -<br>
&gt; +#else<br>
&gt; +=C2=A0 =C2=A0 =C2=A0timespec.it_value.tv_usec =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0timespec.it_interval.tv_usec =3D 0;<br>
&gt; +#endif<br>
<br>
</div></div>That&#39;s pretty nasty. How about this:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memset(&amp;timespec, 0, sizeof(timespec));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 timespec.it_value.tv_sec =3D msgp-&gt;interval;=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 timespec.it_interval.tv_sec =3D msgp-&gt;interv=
al;<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BThis is=
 much better and elegant =E2=80=8Bsolution. :-)</div></div><div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:=
inline"><br></div></div><div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif;display:inline">Cheers,</div></div><div><div=
 class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;di=
splay:inline">Jan</div></div></div><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>=
Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">j=
tulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blan=
k">jan@tulak.me</a></div></div></div></div>
</div></div>

--047d7bdca610f42f5905207ad455--


--===============8088488961542890701==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8088488961542890701==--
