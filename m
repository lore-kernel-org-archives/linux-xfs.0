Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 012EE7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 05:50:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B448A304039
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 03:50:44 -0700 (PDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com
	[209.85.223.173]) by cuda.sgi.com with ESMTP id
	Cd8KcaPqF610Kj8Q (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 03:50:43 -0700 (PDT)
Received: by mail-io0-f173.google.com with SMTP id 2so89078963ioy.1
	for <xfs@oss.sgi.com>; Thu, 07 Apr 2016 03:50:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57057B2A.3000100@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-19-git-send-email-jtulak@redhat.com>
	<57057B2A.3000100@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 7 Apr 2016 12:50:23 +0200
Message-ID: <CACj3i736w-nnDzBDOiBf39cJ3AUHqeVL9_Y8EbUgaMa9S7PToA@mail.gmail.com>
Subject: Re: [PATCH 18/19] mkfs: unit conversions are case insensitive
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8968940034323706173=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8968940034323706173==
Content-Type: multipart/alternative; boundary=001a11427d748f5ed0052fe2d998

--001a11427d748f5ed0052fe2d998
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 6, 2016 at 11:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> > From: Jan Tulak <jtulak@redhat.com>
> >
> > Solves the question "Should I use 10g or 10G?"
>
> Might be nicer to do it like the cvtnum in libxcmd:
>
>         c =3D tolower(*sp);
>         switch (c) {
>         case 'b':
>                 return i * blocksize;
> ...
>
=E2=80=8BYeah, changed.
=E2=80=8B


>
> (hm, why do we have 3 copies of cvtnum?)
>

=E2=80=8BWhere? =E2=80=8B
 =E2=80=8B

=E2=80=8B$ pwd
=E2=80=8B/some/path/xfsprogs-dev

$ grep -r "cvtnum(size_t" . |grep -v "^Binary"
=E2=80=8B./include/input.h:extern long long cvtnum(size_t blocksize, size_t
sectorsize, char *s);
./io/init.h:extern void init_cvtnum(size_t *blocksize, size_t *sectsize);

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a11427d748f5ed0052fe2d998
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Wed, Ap=
r 6, 2016 at 11:10 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span class=3D"">On 3/24/16 6:15 AM, <a=
 href=3D"mailto:jtulak@redhat.com">jtulak@redhat.com</a> wrote:<br>
&gt; From: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtulak@redhat=
.com</a>&gt;<br>
&gt;<br>
&gt; Solves the question &quot;Should I use 10g or 10G?&quot;<br>
<br>
</span>Might be nicer to do it like the cvtnum in libxcmd:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 c =3D tolower(*sp);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (c) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 case &#39;b&#39;:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return i * blocksiz=
e;<br>
...<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif;display:inline">=E2=80=8BYeah, changed.</div></d=
iv><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif;display:inline">=E2=80=8B</div>=C2=A0</div><blockquote class=3D"g=
mail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-=
left-color:rgb(204,204,204);border-left-style:solid;padding-left:1ex">
<br>
(hm, why do we have 3 copies of cvtnum?)<br></blockquote><div><br></div><di=
v><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-se=
rif;display:inline">=E2=80=8BWhere? =E2=80=8B</div>=C2=A0<span style=3D"fon=
t-family:arial,helvetica,sans-serif">=E2=80=8B</span></div><div><span style=
=3D"font-family:arial,helvetica,sans-serif"><br></span></div><div><div clas=
s=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=
=8B$ pwd</div><div class=3D"gmail_default" style=3D"font-family:arial,helve=
tica,sans-serif">=E2=80=8B/some/path/xfsprogs-dev</div><br></div><div>$ gre=
p -r &quot;cvtnum(size_t&quot; . |grep -v &quot;^Binary&quot;</div><div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=
=E2=80=8B./include/input.h:extern long long cvtnum(size_t blocksize, size_t=
 sectorsize, char *s);</div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif">./io/init.h:extern void init_cvtnum(size_t *=
blocksize, size_t *sectsize);</div><div><br></div></div></div>-- <br><div c=
lass=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tu=
lak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@=
redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan=
@tulak.me</a></div></div></div></div>
</div></div>

--001a11427d748f5ed0052fe2d998--


--===============8968940034323706173==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8968940034323706173==--
