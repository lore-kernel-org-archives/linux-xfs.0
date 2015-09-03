Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CA5F17F58
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 05:37:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB078304043
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 03:37:44 -0700 (PDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com
	[209.85.223.173]) by cuda.sgi.com with ESMTP id
	YxZAvRvWWH7G57RT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 03:37:43 -0700 (PDT)
Received: by ioiz6 with SMTP id z6so52580085ioi.2
	for <xfs@oss.sgi.com>; Thu, 03 Sep 2015 03:37:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150903103317.GV3902@dastard>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-10-git-send-email-jtulak@redhat.com>
	<20150831190120.GK349@infradead.org>
	<CACj3i73Px4Zxfyz1GMZN=4r_LeONPMwfLT=P7C7bNDDshJ1ipA@mail.gmail.com>
	<20150903103317.GV3902@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 3 Sep 2015 12:37:23 +0200
Message-ID: <CACj3i739DYP5tgzs7a5m9FgBv4oveL8D+ML66A2nc-4z8gVrqQ@mail.gmail.com>
Subject: Re: [PATCH 10/11] xfsprogs: add dummy mntent for OS X
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5702825119840090075=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

--===============5702825119840090075==
Content-Type: multipart/alternative; boundary=001a11409e3e89ccc1051ed55f77

--001a11409e3e89ccc1051ed55f77
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2015 at 12:33 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Sep 03, 2015 at 11:01:44AM +0200, Jan Tulak wrote:
> > On Mon, Aug 31, 2015 at 9:01 PM, Christoph Hellwig <hch@infradead.org>
> > wrote:
> >
> > > On Wed, Aug 26, 2015 at 02:02:34PM +0200, Jan Tulak wrote:
> > > > Because these calls are used only by xfs_fsr, which can't
> > > > work on OS X unless a way how to mount XFS is found,
> > > > there is not use in implementing these calls.
> > >
> > > Take a look at the quota code for the BSD alternative to mntent.
> > > That code should be moved into a common location and used by fsr.
> > >
> >
> > =E2=80=8BI tried to find it, but didn't found... Could you point me whe=
re it is?
> > Quota/freebsd.h has just few lines with one definition with errno =3D
> > -ENOSYS, and in other files in quota/, I didn't saw anything BSD
> specific.
>
> I think Christoph is refering to the code in libxcmd/paths.c:
>
> #if defined(HAVE_GETMNTENT)
> ....
> #elif defined(HAVE_GETMNTINFO)
> ....
> #else
> # error "How do I extract info about mounted filesystems on this platform=
?"
> #endif
> #
>
> HAVE_GETMNTINFO is for BSD systems, IIRC.
>
>
=E2=80=8BAll right, I will look on this. Thanks. :-)

Cheers,
Jan=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a11409e3e89ccc1051ed55f77
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Thu, Sep 3, 2015 at 12:33 PM, Dave Chinner <span dir=3D"ltr=
">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromor=
bit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=
=3D"">On Thu, Sep 03, 2015 at 11:01:44AM +0200, Jan Tulak wrote:<br>
&gt; On Mon, Aug 31, 2015 at 9:01 PM, Christoph Hellwig &lt;<a href=3D"mail=
to:hch@infradead.org">hch@infradead.org</a>&gt;<br>
&gt; wrote:<br>
&gt;<br>
&gt; &gt; On Wed, Aug 26, 2015 at 02:02:34PM +0200, Jan Tulak wrote:<br>
&gt; &gt; &gt; Because these calls are used only by xfs_fsr, which can&#39;=
t<br>
&gt; &gt; &gt; work on OS X unless a way how to mount XFS is found,<br>
&gt; &gt; &gt; there is not use in implementing these calls.<br>
&gt; &gt;<br>
&gt; &gt; Take a look at the quota code for the BSD alternative to mntent.<=
br>
&gt; &gt; That code should be moved into a common location and used by fsr.=
<br>
&gt; &gt;<br>
&gt;<br>
&gt; =E2=80=8BI tried to find it, but didn&#39;t found... Could you point m=
e where it is?<br>
&gt; Quota/freebsd.h has just few lines with one definition with errno =3D<=
br>
&gt; -ENOSYS, and in other files in quota/, I didn&#39;t saw anything BSD s=
pecific.<br>
<br>
</span>I think Christoph is refering to the code in libxcmd/paths.c:<br>
<br>
#if defined(HAVE_GETMNTENT)<br>
....<br>
#elif defined(HAVE_GETMNTINFO)<br>
....<br>
#else<br>
# error &quot;How do I extract info about mounted filesystems on this platf=
orm?&quot;<br>
#endif<br>
#<br>
<br>
HAVE_GETMNTINFO is for BSD systems, IIRC.<br>
<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BAll right, =
I will look on this. Thanks. :-)</div></div><div><div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></di=
v></div><div><div class=3D"gmail_default" style=3D"font-family:arial,helvet=
ica,sans-serif;display:inline">Cheers,</div></div><div><div class=3D"gmail_=
default" style=3D"font-family:arial,helvetica,sans-serif;display:inline">Ja=
n=E2=80=8B</div>=C2=A0</div></div><div><br></div>-- <br><div class=3D"gmail=
_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div>=
<a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a=
>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a>=
</div></div></div></div>
</div></div>

--001a11409e3e89ccc1051ed55f77--


--===============5702825119840090075==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5702825119840090075==--
