Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AC5D87CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 06:43:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6105B8F8033
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 04:43:34 -0700 (PDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
	[209.85.213.175]) by cuda.sgi.com with ESMTP id
	dZLodQ0buTsb8TYX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 04:43:32 -0700 (PDT)
Received: by mail-ig0-f175.google.com with SMTP id gy3so11358768igb.1
	for <xfs@oss.sgi.com>; Thu, 07 Apr 2016 04:43:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5705D0AD.9060106@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-8-git-send-email-jtulak@redhat.com>
	<5705D0AD.9060106@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 7 Apr 2016 13:43:12 +0200
Message-ID: <CACj3i70iaSjKaP0Nx-Z1QpKGNkdOWJBB9rCKMD_Z2ON7mXBroQ@mail.gmail.com>
Subject: Re: [PATCH 07/19] mkfs: structify input parameter passing
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7048184654448064964=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============7048184654448064964==
Content-Type: multipart/alternative; boundary=047d7ba97ee0707e5a052fe396c7

--047d7ba97ee0707e5a052fe396c7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 7, 2016 at 5:14 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

>
> > + *   minval, maxval OPTIONAL
> > + *     These options are used for automatic range check and they have
> to be
> > + *     always used together in pair. If you don't want to limit the ma=
x
> value,
> > + *     use something like UINT_MAX. If no value is given, then you
> either has
>
> then you must either supply your own validation, or ...
>
> > + *     to supply your own validation, or refuse any value in the 'case
> > + *     X_SOMETHING' block. If you forget to pass a min or max value
> here, but
>
> forget to define a min and max value (?)
>
> > + *     call a standard function for validating user's value, it will
> cause an
> > + *     error message notifying you about this issue.
> > + *
> > + *     (Said in another way, you can't have minval and maxval both equ=
al
> > + *     to zero. But if one value is different: minval=3D0 and maxval=
=3D1,
> > + *     then it is OK.)
>
> I think that makes sense ... by the time I got to the end of this I was a
> little confused.  ;)
>
> So you don't have to define min/max, but if you call getnum_checked(), th=
en
> min & max are required, and they can't both be zero - is that correct?
>

=E2=80=8BYes. I couldn't find any usecase, where an option would accept onl=
y single
hardcoded value (0, in this case) as an argument, and nothing else, because
then it doesn't need the argument at all...
=E2=80=8B

And because forgetting the min/maxval is easy (I know it first hand :-) ),
I added the check for minval=3D=3D0 && maxval =3D=3D 0 to raise an error if=
 you
call getnum_checked() for this option.

=E2=80=8BCheers,=E2=80=8B

=E2=80=8BJan=E2=80=8B

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7ba97ee0707e5a052fe396c7
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Thu, Ap=
r 7, 2016 at 5:14 AM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span class=3D""><br>
&gt; + *=C2=A0 =C2=A0minval, maxval OPTIONAL<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0These options are used for automatic range chec=
k and they have to be<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0always used together in pair. If you don&#39;t =
want to limit the max value,<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0use something like UINT_MAX. If no value is giv=
en, then you either has<br>
<br>
</span>then you must either supply your own validation, or ...<br>
<span class=3D""><br>
&gt; + *=C2=A0 =C2=A0 =C2=A0to supply your own validation, or refuse any va=
lue in the &#39;case<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0X_SOMETHING&#39; block. If you forget to pass a=
 min or max value here, but<br>
<br>
</span>forget to define a min and max value (?)<br>
<span class=3D""><br>
&gt; + *=C2=A0 =C2=A0 =C2=A0call a standard function for validating user&#3=
9;s value, it will cause an<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0error message notifying you about this issue.<b=
r>
&gt; + *<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0(Said in another way, you can&#39;t have minval=
 and maxval both equal<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0to zero. But if one value is different: minval=
=3D0 and maxval=3D1,<br>
&gt; + *=C2=A0 =C2=A0 =C2=A0then it is OK.)<br>
<br>
</span>I think that makes sense ... by the time I got to the end of this I =
was a<br>
little confused.=C2=A0 ;)<br>
<br>
So you don&#39;t have to define min/max, but if you call getnum_checked(), =
then<br>
min &amp; max are required, and they can&#39;t both be zero - is that corre=
ct?<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BYes. I =
couldn&#39;t find any usecase, where an option would accept only single har=
dcoded value (0, in this case) as an argument, and nothing else, because th=
en it doesn&#39;t need the argument at all...</div><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=
=8B=C2=A0</div></div><div><div class=3D"gmail_default" style=3D"font-family=
:arial,helvetica,sans-serif;display:inline"><br></div></div><div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:=
inline">And because forgetting the min/maxval is easy (I know it first hand=
 :-) ), I added the check for minval=3D=3D0 &amp;&amp; maxval =3D=3D 0 to r=
aise an error if you call=C2=A0getnum_checked() for this option.</div></div=
></div><div><br></div><div><div class=3D"gmail_default" style=3D"font-famil=
y:arial,helvetica,sans-serif">=E2=80=8BCheers,=E2=80=8B</div><br></div><div=
><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-ser=
if">=E2=80=8BJan=E2=80=8B</div><br></div>-- <br><div class=3D"gmail_signatu=
re"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=
=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0=
/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div><=
/div></div></div>
</div></div>

--047d7ba97ee0707e5a052fe396c7--


--===============7048184654448064964==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7048184654448064964==--
