Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF5107CA3
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 05:07:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3FA0AAC002
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 03:06:57 -0700 (PDT)
Received: from mail-io0-f175.google.com (mail-io0-f175.google.com
	[209.85.223.175]) by cuda.sgi.com with ESMTP id
	C0Gb9wfBeYHV2Cjh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 03:06:56 -0700 (PDT)
Received: by mail-io0-f175.google.com with SMTP id q128so126110273iof.3
	for <xfs@oss.sgi.com>; Fri, 08 Apr 2016 03:06:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160408000910.GB21804@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<20160408000910.GB21804@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 8 Apr 2016 12:06:35 +0200
Message-ID: <CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6834151922592098578=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============6834151922592098578==
Content-Type: multipart/alternative; boundary=001a113ebe20cd6509052ff65a7d

--001a113ebe20cd6509052ff65a7d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 8, 2016 at 2:09 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Mar 24, 2016 at 12:15:34PM +0100, jtulak@redhat.com wrote:
> > From: Jan Tulak <jtulak@redhat.com>
> >
> > Unify mkfs.xfs behaviour a bit and never truncate files. If the user
> > is trying to mkfs an existing file, we don't want to destroy anything
> > he did with the file before (sparse file, allocations...)
>
> Why not? We do that with discard-by-default to block devices,
> O_TRUNC is exactly the same situation with a file - we completely
> re-initialise the file from a known state if mkfs has been asked to
> create the file.
>
> =E2=80=8BBut AFAIK, we don't zero-out entire spindle devices, we don't as=
k if the
drive skips some blocks (i.e. because they are bad),=E2=80=8B and we don't =
care
about what an underlaying layer (like LVM) did with the block device. From
this point of view, we shouldn't care about the file either.

I can be missing something, though.


> > @@ -1059,9 +1063,9 @@ check_device_type(
> >       }
> >
> >       /*
> > -      * We only want to completely truncate and recreate an existing
> file if
> > -      * we were specifically told it was a file. Set the create flag
> only in
> > -      * this case to trigger that behaviour.
> > +      * We only want to create a file only if we were specifically tol=
d
> > +      * we want a file. Set the create flag only in this case to trigg=
er
> > +      * that behaviour.
> >        */
> >       if (S_ISREG(statbuf.st_mode)) {
> >               if (!*isfile)
>
> i.e. this situation.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ebe20cd6509052ff65a7d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Ap=
r 8, 2016 at 2:09 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Thu, =
Mar 24, 2016 at 12:15:34PM +0100, <a href=3D"mailto:jtulak@redhat.com">jtul=
ak@redhat.com</a> wrote:<br>
&gt; From: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtulak@redhat=
.com</a>&gt;<br>
&gt;<br>
&gt; Unify mkfs.xfs behaviour a bit and never truncate files. If the user<b=
r>
&gt; is trying to mkfs an existing file, we don&#39;t want to destroy anyth=
ing<br>
&gt; he did with the file before (sparse file, allocations...)<br>
<br>
</span>Why not? We do that with discard-by-default to block devices,<br>
O_TRUNC is exactly the same situation with a file - we completely<br>
re-initialise the file from a known state if mkfs has been asked to<br>
create the file.<br>
<span class=3D""><br></span></blockquote><div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BBut AFAIK, we don=
&#39;t zero-out entire spindle devices, we don&#39;t ask if the drive skips=
 some blocks (i.e. because they are bad),=E2=80=8B and we don&#39;t care ab=
out what an underlaying layer (like LVM) did with the block device. From th=
is point of view, we shouldn&#39;t care about the file either.</div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br>=
</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,san=
s-serif">I can be missing something, though.</div></div><div><br></div><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex"><span class=3D"">
<br>
&gt; @@ -1059,9 +1063,9 @@ check_device_type(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * We only want to completely truncate and recrea=
te an existing file if<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * we were specifically told it was a file. Set t=
he create flag only in<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * this case to trigger that behaviour.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * We only want to create a file only if we were =
specifically told<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * we want a file. Set the create flag only in th=
is case to trigger<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * that behaviour.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (S_ISREG(statbuf.st_mode)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!*isfile)<br=
>
<br>
</span>i.e. this situation.<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><di=
v>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank"=
>jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_bl=
ank">jan@tulak.me</a></div></div></div></div>
</div></div>

--001a113ebe20cd6509052ff65a7d--


--===============6834151922592098578==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6834151922592098578==--
