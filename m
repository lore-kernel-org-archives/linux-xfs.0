Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DE0A37F3F
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 04:34:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE15D304043
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 02:34:18 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	RkCl1iOA821x66Ex (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Sep 2015 02:34:17 -0700 (PDT)
Received: by ioiz6 with SMTP id z6so70272038ioi.2
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 02:34:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150923033218.GP3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-12-git-send-email-jtulak@redhat.com>
	<20150923033218.GP3902@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 24 Sep 2015 11:33:57 +0200
Message-ID: <CACj3i72EXEis7Th8r-c3GmxuVp6pefoE=_XsCwqY6auAz8eLvA@mail.gmail.com>
Subject: Re: [PATCH 11/14] xfsprogs: Add statvfs64 for osx
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4580950269547719171=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============4580950269547719171==
Content-Type: multipart/alternative; boundary=001a113ec2ac552d9705207aefe2

--001a113ec2ac552d9705207aefe2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2015 at 5:32 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 15, 2015 at 11:59:21AM +0200, Jan Tulak wrote:
> > Simply rename statvfs64 to statfs with a #define.
> > OSX version of statvfs is missing some members, so if the renaming
> > is in effect (stavfs64 is defined), don't try to use them and go
> > directly for the other member value.
> >
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > ---
> >  fsr/xfs_fsr.c        | 14 ++++++++++++++
> >  include/builddefs.in |  2 +-
> >  include/darwin.h     |  5 +++++
> >  3 files changed, 20 insertions(+), 1 deletion(-)
> >
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index e1b7bd6..5f95cdc 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
> > @@ -36,6 +36,12 @@
> >  #  include <mntent.h>
> >  #endif
> >
> > +#ifdef __APPLE__
> > +//#  define statvfs64 statfs;
> > +#  include <sys/param.h>
> > +#  include <sys/mount.h>
> > +#endif
>
> Why is this here? We've included libxfs.h in this file, so we've
> got access to the platform specific includes already, and later in
> the patch you put the commented out define there...
>

=E2=80=8BMost likely because I messed it in a rebase during some conflict. =
I try to
check for these things, but apparently this one escaped. Removing it
again=E2=80=8B..

Thanks for catching it.

Cheers,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ec2ac552d9705207aefe2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Wed, Se=
p 23, 2015 at 5:32 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Tue, =
Sep 15, 2015 at 11:59:21AM +0200, Jan Tulak wrote:<br>
&gt; Simply rename statvfs64 to statfs with a #define.<br>
&gt; OSX version of statvfs is missing some members, so if the renaming<br>
&gt; is in effect (stavfs64 is defined), don&#39;t try to use them and go<b=
r>
&gt; directly for the other member value.<br>
&gt;<br>
&gt; Signed-off-by: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtul=
ak@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 fsr/xfs_fsr.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 14 ++++++++++++++<br>
&gt;=C2=A0 include/<a href=3D"http://builddefs.in" rel=3D"noreferrer" targe=
t=3D"_blank">builddefs.in</a> |=C2=A0 2 +-<br>
&gt;=C2=A0 include/darwin.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 5 +++++<br>
&gt;=C2=A0 3 files changed, 20 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c<br>
&gt; index e1b7bd6..5f95cdc 100644<br>
&gt; --- a/fsr/xfs_fsr.c<br>
&gt; +++ b/fsr/xfs_fsr.c<br>
&gt; @@ -36,6 +36,12 @@<br>
&gt;=C2=A0 #=C2=A0 include &lt;mntent.h&gt;<br>
&gt;=C2=A0 #endif<br>
&gt;<br>
&gt; +#ifdef __APPLE__<br>
&gt; +//#=C2=A0 define statvfs64 statfs;<br>
&gt; +#=C2=A0 include &lt;sys/param.h&gt;<br>
&gt; +#=C2=A0 include &lt;sys/mount.h&gt;<br>
&gt; +#endif<br>
<br>
</span>Why is this here? We&#39;ve included libxfs.h in this file, so we&#3=
9;ve<br>
got access to the platform specific includes already, and later in<br>
the patch you put the commented out define there...<br></blockquote><div><b=
r></div><div><div class=3D"gmail_default" style=3D"font-family:arial,helvet=
ica,sans-serif;display:inline">=E2=80=8BMost likely because I messed it in =
a rebase during some conflict. I try to check for these things, but apparen=
tly this one escaped. Removing it again=E2=80=8B..</div></div><div><div cla=
ss=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;displa=
y:inline"><br></div></div></div><div class=3D"gmail_default" style=3D"font-=
family:arial,helvetica,sans-serif">Thanks for catching it.</div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br></d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif">Cheers,</div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif">Jan</div><div><br></div>-- <br><div class=3D"gmail_si=
gnature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a =
href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=
=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a><=
/div></div></div></div>
</div></div>

--001a113ec2ac552d9705207aefe2--


--===============4580950269547719171==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4580950269547719171==--
