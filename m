Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1C34A7F37
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 03:28:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C80DAC005
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 01:28:27 -0700 (PDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	vexVV5cGUBWFcpY1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Sep 2015 01:28:25 -0700 (PDT)
Received: by ioii196 with SMTP id i196so69367968ioi.3
	for <xfs@oss.sgi.com>; Thu, 24 Sep 2015 01:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150923031532.GN3902@dastard>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
	<1442311164-12921-5-git-send-email-jtulak@redhat.com>
	<20150923031532.GN3902@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 24 Sep 2015 10:28:05 +0200
Message-ID: <CACj3i715Tiy0prfeYgLfEfupe8aGxJuv5yvDOi+AE08ofueO_A@mail.gmail.com>
Subject: Re: [PATCH 04/14] xfsprogs: prefix XATTR_LIST_MAX with XFS_
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1944220706651847592=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============1944220706651847592==
Content-Type: multipart/alternative; boundary=001a113ff20ecc58aa05207a0384

--001a113ff20ecc58aa05207a0384
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2015 at 5:15 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Sep 15, 2015 at 11:59:14AM +0200, Jan Tulak wrote:
> > WILL CHANGE THE COMMIT MESSAGE.
>
> OK?

> All right, I make the renaming with define - though I'm not sure
> > that with the ifdef for OS X and SIZE_MAX moved to a standalone patch
> > we need it - shouldn't be this change rather dropped?
> >
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > ---
> >  include/xfs.h      | 2 ++
> >  libhandle/handle.c | 4 ++--
> >  libhandle/jdm.c    | 4 ++--
> >  3 files changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/xfs.h b/include/xfs.h
> > index bc94068..8ee0106 100644
> > --- a/include/xfs.h
> > +++ b/include/xfs.h
> > @@ -53,6 +53,8 @@
> >  # define ASSERT(EX)  ((void) 0)
> >  #endif
> >
> > +#define XFS_XATTR_LIST_MAX XATTR_LIST_MAX
> > +
>
> This does not belong here - it is a limit that applies to the ioctl
> API and so must be the same in userspace and the kernel. Such
> definitions belong in libxfs/xfs_fs.h, and should respect local OS
> limits if defined. e.g. something like:
>
> #ifdef XATTR_LIST_MAX
> #define XFS_XATTR_LIST_MAX XATTR_LIST_MAX
> #else
> #define XFS_XATTR_LIST_MAX 65536
> #endif
>
>
=E2=80=8BOK, =E2=80=8Bthat makes sense.



> Will work on both the kernel and userspace side. This will also need
> a kernel side patch...


=E2=80=8BNow, this is something where I may need a bit help/confirmation, I=
 guess.=E2=80=8B
What I suppose I should do is:

1) Clone linux-xfs (git://
git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git)
2) Edit linux-xfs/fs/xfs/libxfs/xfs_fs.h and add the same change there
3) Send it to this mailing list as usual, with "[PATCH] xfs: ..."

(The same goes for the other patch with the kernel need too.)

Is it all right? Correct repository URL? :-)

Thanks,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ff20ecc58aa05207a0384
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Wed, Se=
p 23, 2015 at 5:15 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span>On Tue, Sep 15, 2015 at 11:59:14A=
M +0200, Jan Tulak wrote:<br>
&gt; WILL CHANGE THE COMMIT MESSAGE.<br>
<br>
</span>OK?=C2=A0</blockquote><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,2=
04);border-left-style:solid;padding-left:1ex"><span>
&gt; All right, I make the renaming with define - though I&#39;m not sure<b=
r>
&gt; that with the ifdef for OS X and SIZE_MAX moved to a standalone patch<=
br>
&gt; we need it - shouldn&#39;t be this change rather dropped?<br>
&gt;<br>
&gt; Signed-off-by: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com" targ=
et=3D"_blank">jtulak@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 include/xfs.h=C2=A0 =C2=A0 =C2=A0 | 2 ++<br>
&gt;=C2=A0 libhandle/handle.c | 4 ++--<br>
&gt;=C2=A0 libhandle/jdm.c=C2=A0 =C2=A0 | 4 ++--<br>
&gt;=C2=A0 3 files changed, 6 insertions(+), 4 deletions(-)<br>
&gt;<br>
&gt; diff --git a/include/xfs.h b/include/xfs.h<br>
&gt; index bc94068..8ee0106 100644<br>
&gt; --- a/include/xfs.h<br>
&gt; +++ b/include/xfs.h<br>
&gt; @@ -53,6 +53,8 @@<br>
&gt;=C2=A0 # define ASSERT(EX)=C2=A0 ((void) 0)<br>
&gt;=C2=A0 #endif<br>
&gt;<br>
&gt; +#define XFS_XATTR_LIST_MAX XATTR_LIST_MAX<br>
&gt; +<br>
<br>
</span>This does not belong here - it is a limit that applies to the ioctl<=
br>
API and so must be the same in userspace and the kernel. Such<br>
definitions belong in libxfs/xfs_fs.h, and should respect local OS<br>
limits if defined. e.g. something like:<br>
<br>
#ifdef XATTR_LIST_MAX<br>
#define XFS_XATTR_LIST_MAX XATTR_LIST_MAX<br>
#else<br>
#define XFS_XATTR_LIST_MAX 65536<br>
#endif<br>
<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif">=E2=80=8BOK, =E2=80=8Bthat makes se=
nse.</div><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(2=
04,204,204);border-left-style:solid;padding-left:1ex">
Will work on both the kernel and userspace side. This will also need<br>
a kernel side patch...</blockquote><div><br></div><div class=3D"gmail_defau=
lt" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BNow, this is =
something where I may need a bit help/confirmation, I guess.=E2=80=8B</div>=
<div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-seri=
f">What I suppose I should do is:</div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif">1) Clone linux-xfs=
 (git://<a href=3D"http://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux=
-xfs.git" target=3D"_blank">git.kernel.org/pub/scm/linux/kernel/git/dgc/lin=
ux-xfs.git</a>)</div><div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif">2) Edit=C2=A0linux-xfs/fs/xfs/libxfs/xfs_fs.h and a=
dd the same change there</div><div class=3D"gmail_default" style=3D"font-fa=
mily:arial,helvetica,sans-serif">3) Send it to this mailing list as usual, =
with &quot;[PATCH] xfs: ...&quot;</div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif">(The same goes for=
 the other patch with the kernel need too.)</div><div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D=
"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Is it all =
right? Correct repository URL? :-)</div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif">Thanks,</div><div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Ja=
n</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif"><br></div></div>-- <br><div><div dir=3D"ltr"><div><div dir=3D"ltr=
"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_b=
lank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=
=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--001a113ff20ecc58aa05207a0384--


--===============1944220706651847592==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1944220706651847592==--
