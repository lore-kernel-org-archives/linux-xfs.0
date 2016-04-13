Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 288C87CB6
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 10:43:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF3B68F8033
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 08:43:36 -0700 (PDT)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	Q5Lb3ebKtoVRlbMw (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 08:43:35 -0700 (PDT)
Received: by mail-io0-f171.google.com with SMTP id o126so75261837iod.0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 08:43:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5708811C.5090909@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
	<CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
	<5708811C.5090909@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 13 Apr 2016 17:43:15 +0200
Message-ID: <CACj3i70KKoBXL8NicEZiG_xrvjaAx27xGjD50jz=oQH7kmrJwA@mail.gmail.com>
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0517849638529572397=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============0517849638529572397==
Content-Type: multipart/alternative; boundary=001a113eb35e00a3fb05305fa44a

--001a113eb35e00a3fb05305fa44a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 9, 2016 at 6:12 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

>
>
> On 4/8/16 9:58 AM, Jan Tulak wrote:
> >     This one causes at least one interesting issue:
> >
> >     #mkfs/mkfs.xfs
> >     Error accessing specified device (null): Bad address
> >     Usage: mkfs.xfs
> >     ...
> >
> >     because:
> >
> >             check_device_type(dfile, &xi.disfile, !dsize, !dfile,
> >                               Nflag ? NULL : &xi.dcreat,
> force_overwrite, "d");
> >
> >     so "dfile" can be NULL, but that function immediately tries to stat
> it.
> >
> >
> > =E2=80=8BA simple if NULL, then usage() should take care of this...
>
> Well, think hard about that.  If dfile =3D=3D NULL and bails with usage()=
, then
> what is the point of having !dfile as a function argument?
>
> Validation of having a target specified as either -dfile=3D or as the las=
t
> argument
> should probably happen before the call to check_device_type.
>
>
But what about this?

case D_NAME:
      xi.dname =3D getstr(value, &dopts, D_     NAME);

[...]

if (argc - optind > 1) {
      [print error]
} else if (argc - optind =3D=3D 1) {
       dfile =3D xi.volname =3D getstr(argv[optind], &dopts, D_NAME);
} else
       dfile =3D xi.dname;=E2=80=8B

}

[
=E2=80=8B... until the first occurence of dfile]

check_device_type(dfile, &xi.disfile, !dsize, !dfile,
         Nflag ? NULL : &xi.dcreat, force_overwrite, "d");
=E2=80=8B
=E2=80=8Bso if there is -d name=3D and nothing at the end, then dfile conta=
ins D_NAME
value. If there is a path at the end, then, then no matter about -d name,
we have dfile filled with something. So I can't find a way how to have
dfile =3D=3D NULL without omitting both a path as the last argument, and
-dname...

The no_name (!dfile) argument is in check_device_type() for a single reason
- raising error on
if (*isfile && (no_size || no_name))

But !string is true only when string=3D=3DNULL. For an empty string: !"" is=
 0.
So I don't see the reason for no_name argument at all - it seems to
confuse, and in current use can be replaced with test to NULL, or !name.

DTTO for xi.logname/xi.rtname.

=E2=80=8BCheers,
Jan=E2=80=8B

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113eb35e00a3fb05305fa44a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Sat, Ap=
r 9, 2016 at 6:12 AM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span class=3D""><br>
<br>
On 4/8/16 9:58 AM, Jan Tulak wrote:<br>
</span><span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0This one causes at least on=
e interesting issue:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0#mkfs/mkfs.xfs<br>
&gt;=C2=A0 =C2=A0 =C2=A0Error accessing specified device (null): Bad addres=
s<br>
&gt;=C2=A0 =C2=A0 =C2=A0Usage: mkfs.xfs<br>
&gt;=C2=A0 =C2=A0 =C2=A0...<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0because:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0check_device_type(dfile=
, &amp;xi.disfile, !dsize, !dfile,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Nflag ? NULL : &amp;xi.dcreat, for=
ce_overwrite, &quot;d&quot;);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0so &quot;dfile&quot; can be NULL, but that function=
 immediately tries to stat it.<br>
&gt;<br>
&gt;<br>
&gt; =E2=80=8BA simple if NULL, then usage() should take care of this...<br=
>
<br>
</span>Well, think hard about that.=C2=A0 If dfile =3D=3D NULL and bails wi=
th usage(), then<br>
what is the point of having !dfile as a function argument?<br>
<br>
Validation of having a target specified as either -dfile=3D or as the last =
argument<br>
should probably happen before the call to check_device_type.<br>
<span class=3D""><font color=3D"#888888"><br></font></span></blockquote><di=
v><br></div><div><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif;display:inline">But what about this?</div></div><div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;d=
isplay:inline"><br></div></div><div><div class=3D"gmail_default" style=3D"d=
isplay:inline"><font face=3D"arial, helvetica, sans-serif"><div style=3D"">=
case D_NAME:</div><div style=3D"">=C2=A0 =C2=A0 =C2=A0 xi.dname =3D getstr(=
value, &amp;dopts, D_ =C2=A0 =C2=A0 NAME);</div><div style=3D""><br></div><=
/font></div></div><div><div class=3D"gmail_default" style=3D"font-family:ar=
ial,helvetica,sans-serif;display:inline">[...]</div></div><div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:=
inline"><br></div></div><div><div class=3D"gmail_default" style=3D"display:=
inline"><font face=3D"arial, helvetica, sans-serif">if (argc - optind &gt; =
1) {</font><br></div></div><div><div class=3D"gmail_default" style=3D"displ=
ay:inline"><font face=3D"arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=A0=
 [print error]</font></div></div><div><font face=3D"arial, helvetica, sans-=
serif">} else if (argc - optind =3D=3D 1) {</font></div><div><font face=3D"=
arial, helvetica, sans-serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0dfile =3D xi.volna=
me =3D getstr(argv[optind], &amp;dopts, D_NAME);</font></div><div><font fac=
e=3D"arial, helvetica, sans-serif">} else</font></div><div><div class=3D"gm=
ail_default" style=3D"display:inline"><font face=3D"arial, helvetica, sans-=
serif">=C2=A0 =C2=A0 =C2=A0 =C2=A0dfile =3D xi.dname;=E2=80=8B</font></div>=
=C2=A0</div><div>}</div><div><br></div></div><div class=3D"gmail_extra">[<d=
iv class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;=
display:inline">=E2=80=8B... until the first occurence of dfile]</div></div=
><div class=3D"gmail_extra"><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif;display:inline"><br></div></div><div class=3D=
"gmail_extra"><div class=3D"gmail_default" style=3D"font-family:arial,helve=
tica,sans-serif;display:inline"><span style=3D"font-family:arial,sans-serif=
">check_device_type(dfile, &amp;xi.disfile, !dsize, !dfile,</span><br style=
=3D"font-family:arial,sans-serif"><span style=3D"font-family:arial,sans-ser=
if">=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Nflag ? NULL : &amp;xi.dcreat, force_=
overwrite, &quot;d&quot;);</span><br></div></div><div class=3D"gmail_extra"=
><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-ser=
if;display:inline">=E2=80=8B</div></div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif">=E2=80=8Bso if there is -d name=
=3D and nothing at the end, then dfile contains D_NAME value. If there is a=
 path at the end, then, then no matter about -d name, we have dfile filled =
with something. So I can&#39;t find a way how to have dfile =3D=3D NULL wit=
hout omitting both a path as the last argument, and -dname...</div><div cla=
ss=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br><=
/div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans=
-serif">The no_name (!dfile) argument is in=C2=A0check_device_type() for a =
single reason - raising error on</div><div class=3D"gmail_default" style=3D=
"font-family:arial,helvetica,sans-serif">if (*isfile &amp;&amp; (no_size ||=
 no_name))</div><div class=3D"gmail_default" style=3D"font-family:arial,hel=
vetica,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif">But !string is true only when string=3D=3DN=
ULL. For an empty string: !&quot;&quot; is 0. So I don&#39;t see the reason=
 for no_name argument at all - it seems to confuse, and in current use can =
be replaced with test to NULL, or !name.</div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gm=
ail_default" style=3D"font-family:arial,helvetica,sans-serif">DTTO for xi.l=
ogname/xi.rtname.</div><br clear=3D"all"><div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BCheers,</div><div=
 class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">J=
an=E2=80=8B</div><br></div>-- <br><div class=3D"gmail_signature"><div dir=
=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jt=
ulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"=
mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></=
div>
</div></div>

--001a113eb35e00a3fb05305fa44a--


--===============0517849638529572397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0517849638529572397==--
