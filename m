Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C013E7CA0
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 11:12:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9011B30404E
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 09:12:03 -0700 (PDT)
Received: from mail-ig0-f169.google.com (mail-ig0-f169.google.com
	[209.85.213.169]) by cuda.sgi.com with ESMTP id
	Jbaq0q9lPG2nOovJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 09:12:02 -0700 (PDT)
Received: by mail-ig0-f169.google.com with SMTP id nk17so79748524igb.1
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 09:12:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56F416E8.5000704@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-3-git-send-email-jtulak@redhat.com>
	<56F416E8.5000704@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 29 Mar 2016 18:11:42 +0200
Message-ID: <CACj3i71Ae1p8E35SrmpEiMen+mFY7MgQa2fHPueALDnF+HNRrQ@mail.gmail.com>
Subject: Re: [PATCH 02/19] mkfs: sanitise ftype parameter values.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0580070764788334427=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============0580070764788334427==
Content-Type: multipart/alternative; boundary=047d7ba97ee01891ce052f324ad2

--047d7ba97ee01891ce052f324ad2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 24, 2016 at 5:33 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

>
>
> On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > Because passing "-n ftype=3D2" should fail.
>
> but passing crc=3D1 ftype=3D1 shouldn't fail, should it?
> Seems like it will here.
>

=E2=80=8BFrom man page:
When  CRCs are enabled via -m crc=3D1, the ftype functionality is always
enabled. This feature can not be
=E2=80=8B
turned off for such filesystem configurations.=E2=80=8B


=E2=80=8BSo I think it should not be possible to enter both crc and ftype a=
t the
same time - which is the current behaviour. It feels strange a bit to allow
ftype=3D1 (which does nothing with crc=3D1), but fail on ftype=3D0=E2=80=8B

=E2=80=8BJan=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7ba97ee01891ce052f324ad2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Thu, Ma=
r 24, 2016 at 5:33 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span class=3D""><br>
<br>
On 3/24/16 6:15 AM, <a href=3D"mailto:jtulak@redhat.com">jtulak@redhat.com<=
/a> wrote:<br>
&gt; From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner=
@redhat.com</a>&gt;<br>
&gt;<br>
&gt; Because passing &quot;-n ftype=3D2&quot; should fail.<br>
<br>
</span>but passing crc=3D1 ftype=3D1 shouldn&#39;t fail, should it?<br>
Seems like it will here.<br></blockquote><div><br></div><div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:inli=
ne">=E2=80=8BFrom man page:</div></div><div><font face=3D"arial, helvetica,=
 sans-serif">When =C2=A0CRCs are enabled via -m crc=3D1, the ftype func</fo=
nt><span style=3D"font-family:arial,helvetica,sans-serif">tionality is alwa=
ys enabled. This feature can not be<div class=3D"gmail_default" style=3D"fo=
nt-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B=C2=A0</div><=
/span><div class=3D"gmail_default" style=3D"display:inline"><font face=3D"a=
rial, helvetica, sans-serif">turned off for such filesystem configurations.=
=E2=80=8B</font></div>=C2=A0</div><div><br></div><div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BSo I thin=
k it should not be possible to enter both crc and ftype at the same time - =
which is the current behaviour. It feels strange a bit to allow ftype=3D1 (=
which does nothing with crc=3D1), but fail on ftype=3D0=E2=80=8B</div><br><=
/div></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetic=
a,sans-serif">=E2=80=8BJan=E2=80=8B</div><br clear=3D"all"><div><br></div>-=
- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"=
><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_bl=
ank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D=
"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--047d7ba97ee01891ce052f324ad2--


--===============0580070764788334427==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0580070764788334427==--
