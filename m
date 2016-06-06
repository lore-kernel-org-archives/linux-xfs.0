Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B0D3F7CA0
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 02:43:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72E12304043
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2016 00:43:23 -0700 (PDT)
Received: from mail-it0-f53.google.com (mail-it0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id ofdrrPjkuxdspFnm
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jun 2016 00:43:18 -0700 (PDT)
Received: by mail-it0-f53.google.com with SMTP id z189so36070353itg.0
	for <xfs@oss.sgi.com>; Mon, 06 Jun 2016 00:43:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160604003259.GV26977@dastard>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<20160510061054.GI26977@dastard>
	<CACj3i715X7X65=BjSW8GZLhUF-YjQVShC-_Udmxe24XB1ACb1w@mail.gmail.com>
	<20160603005324.GS12670@dastard>
	<CACj3i70LGZ7TKWRdKVTi4MyyL5DhnH5Fr-3Q6O5qhKbYfvWJbA@mail.gmail.com>
	<CACj3i734=8ZJcdJztA76ru93SpdNNUgVtF_tUv2Jy_8U0V9HzQ@mail.gmail.com>
	<20160604003259.GV26977@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Mon, 6 Jun 2016 09:42:58 +0200
Message-ID: <CACj3i7331Zh3AZJ1buOqfWE=aACSefMWYd-n_VvkJ51H-h43Uw@mail.gmail.com>
Subject: Re: [PATCH 00/19 v2] mkfs cleaning
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5374074406771756642=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============5374074406771756642==
Content-Type: multipart/alternative; boundary=001a1144b7d0c8cb1d05349739df

--001a1144b7d0c8cb1d05349739df
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 4, 2016 at 2:32 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Jun 03, 2016 at 02:09:19PM +0200, Jan Tulak wrote:
> > [
> > =E2=80=8Bsnip all, another issue, unrelated to the lsunit one]=E2=80=8B
> >
> > >
> > =E2=80=8BI realised one small glitch with conflicts watching in the cod=
e in
> > combination with flags. It is not regression, I think, because b=E2=80=
=8Before
> now,
> > it was not possible to do something like -l internal=3D0,logdev=3Dsomet=
hing,
> > but now it should be possible.
>
> I think that overly complicates things. My original intent for this
> work was to simplify the interface and code, not make it more
> elaborate to support configurations that are theoretically possible
> but completely redundant.
>
> i.e. '-l internal=3D0,logdev=3Dsomething' is identical in function to
> '-l logdev=3Dsomething', so there is no need to specify internal=3D0.
> AFAICT, therxp eis never a need to specify '-l internal=3D[0|1]'
> because if '-l logdev=3D<foo>' is specified, it implies an external
> log is being configured, and in every other case the log is
> internal.
>
> > The code checks only whether an option was seen, not its value, so it
> > does't know that we are in fact disabling something. I see two ways how
> to
> > do solve it. One is a custom conflict solving for these cases, putting
> some
> > if (flag1 && option2) somewhere once every argument and option is parse=
d.
> > But this goes against what the patchset did and moves it again out of t=
he
> > option table...
> >
> > The other way is to make a special case for flags in the
> conflicts-handling
> > code. Basically, I would extend the structure with something like:
> >
> > { .index =3D L_INTERNAL,
> >   .conflicts =3D { L_FILE,
> >         L_DEV,
> >         LAST_CONFLICT },
> >   .conflicts_ignore_on_false=3Dtrue, // new item, shorter name to be fo=
und
>
> What happens when you have two conflicts, on which you want to
> ignore on false, the other you want to ignore on true?  And where do
> you draw the line? L_SU vs L_SUNIT conflict and throw an error only
> when the values differ?
>
>
=E2=80=8BYeah, that's true... let's call it feature then.

Cheers,
Jan=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a1144b7d0c8cb1d05349739df
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Sat, Ju=
n 4, 2016 at 2:32 AM, Dave Chinner </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Fri, =
Jun 03, 2016 at 02:09:19PM +0200, Jan Tulak wrote:<br>
&gt; [<br>
&gt; =E2=80=8Bsnip all, another issue, unrelated to the lsunit one]=E2=80=
=8B<br>
&gt;<br>
&gt; &gt;<br>
&gt; =E2=80=8BI realised one small glitch with conflicts watching in the co=
de in<br>
&gt; combination with flags. It is not regression, I think, because b=E2=80=
=8Before now,<br>
&gt; it was not possible to do something like -l internal=3D0,logdev=3Dsome=
thing,<br>
&gt; but now it should be possible.<br>
<br>
</span>I think that overly complicates things. My original intent for this<=
br>
work was to simplify the interface and code, not make it more<br>
elaborate to support configurations that are theoretically possible<br>
but completely redundant.<br>
<br>
i.e. &#39;-l internal=3D0,logdev=3Dsomething&#39; is identical in function =
to<br>
&#39;-l logdev=3Dsomething&#39;, so there is no need to specify internal=3D=
0.<br>
AFAICT, therxp eis never a need to specify &#39;-l internal=3D[0|1]&#39;<br=
>
because if &#39;-l logdev=3D&lt;foo&gt;&#39; is specified, it implies an ex=
ternal<br>
log is being configured, and in every other case the log is<br>
internal.<br>
<span class=3D""><br>
&gt; The code checks only whether an option was seen, not its value, so it<=
br>
&gt; does&#39;t know that we are in fact disabling something. I see two way=
s how to<br>
&gt; do solve it. One is a custom conflict solving for these cases, putting=
 some<br>
&gt; if (flag1 &amp;&amp; option2) somewhere once every argument and option=
 is parsed.<br>
&gt; But this goes against what the patchset did and moves it again out of =
the<br>
&gt; option table...<br>
&gt;<br>
&gt; The other way is to make a special case for flags in the conflicts-han=
dling<br>
&gt; code. Basically, I would extend the structure with something like:<br>
&gt;<br>
&gt; { .index =3D L_INTERNAL,<br>
&gt;=C2=A0 =C2=A0.conflicts =3D { L_FILE,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0L_DEV,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0LAST_CONFLICT },<br>
&gt;=C2=A0 =C2=A0.conflicts_ignore_on_false=3Dtrue, // new item, shorter na=
me to be found<br>
<br>
</span>What happens when you have two conflicts, on which you want to<br>
ignore on false, the other you want to ignore on true?=C2=A0 And where do<b=
r>
you draw the line? L_SU vs L_SUNIT conflict and throw an error only<br>
when the values differ?<br>
<div class=3D"HOEnZb"><div class=3D"im trimless-h5 trimless-content"><br></=
div></div></blockquote><div><br></div><div><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BYeah,=
 that&#39;s true... let&#39;s call it feature then.</div></div><div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;displ=
ay:inline"><br></div></div><div><div class=3D"gmail_default" style=3D"font-=
family:arial,helvetica,sans-serif;display:inline">Cheers,</div></div><div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
;display:inline">Jan=E2=80=8B</div>=C2=A0</div></div><div><br></div>-- <br>=
<div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=
=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jt=
ulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"=
mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></=
div>
</div></div>

--001a1144b7d0c8cb1d05349739df--


--===============5374074406771756642==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5374074406771756642==--
