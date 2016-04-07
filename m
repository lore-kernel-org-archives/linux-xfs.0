Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 21FBF7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 06:54:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE34E8F8033
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 04:54:01 -0700 (PDT)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
	[209.85.213.171]) by cuda.sgi.com with ESMTP id
	3BlqiSTz8fV4R3yi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 04:54:00 -0700 (PDT)
Received: by mail-ig0-f171.google.com with SMTP id ui10so67989506igc.1
	for <xfs@oss.sgi.com>; Thu, 07 Apr 2016 04:54:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160406210128.GC13574@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-4-git-send-email-jtulak@redhat.com>
	<56FDD750.3040002@sandeen.net>
	<CACj3i71=v+p2=mM75Na0Lujt+gQjB1hX=En0K12he+7WF6q=wQ@mail.gmail.com>
	<20160406210128.GC13574@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 7 Apr 2016 13:53:39 +0200
Message-ID: <CACj3i708JX0R1sD5bHmKxE6SqK-D+tseOX0LWZrgNadqNCeLmA@mail.gmail.com>
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1880576146000685008=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============1880576146000685008==
Content-Type: multipart/alternative; boundary=089e01538da0d3d817052fe3bb19

--089e01538da0d3d817052fe3bb19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 6, 2016 at 11:01 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Apr 06, 2016 at 11:12:21AM +0200, Jan Tulak wrote:
> > On Fri, Apr 1, 2016 at 4:05 AM, Eric Sandeen <sandeen@sandeen.net>
> wrote:
> > > On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> > >                 if (sb_feat.finobt && sb_feat.finobtflag) {
> > >                         fprintf(stderr,
> > > _("warning: finobt not supported without CRC support, disabled.\n"));
> > >                 }
> > >                 sb_feat.finobt =3D 0;
> > >
> > > would suffice as before, no? Meh.  Not a big deal I guess....
> > >
> >
> > =E2=80=8BChanged. Honestly, I don't like the strings starting at the be=
ginning of
> > the line, because it breaks the indentation flow, but the rest of the
> code
> > uses this style, so I should stick to it.=E2=80=8B
>
> There's good reason for doing this - it makes it easy to grep the
> source code for a specific error that has been emitted. Indentation
> is useful for demonstrating logic flow, but it's harmful when it
> results in strings you might want to find being split up over
> multiple lines.
>

=E2=80=8BMmm, yeah, a valid point. It is caused by the 80 chars limit, but =
there
are reasons for that too=E2=80=8B...


> > Thank you for the review. I will wait a little longer if someone spots
> > something more, before sending an updated patchset.=E2=80=8B :-)
>
> Just send it - I almost got to pulling in this version and
> fixing the various comments directly myself yesterday....
>

=E2=80=8BOK. I will fix what Eric submitted in the mean time, test it to be=
 sure I
didn't broke anything and send.

Cheers,
Jan


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e01538da0d3d817052fe3bb19
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Wed, Ap=
r 6, 2016 at 11:01 PM, Dave Chinner </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, =
Apr 06, 2016 at 11:12:21AM +0200, Jan Tulak wrote:<br>
&gt; On Fri, Apr 1, 2016 at 4:05 AM, Eric Sandeen &lt;<a href=3D"mailto:san=
deen@sandeen.net">sandeen@sandeen.net</a>&gt; wrote:<br>
&gt; &gt; On 3/24/16 6:15 AM, <a href=3D"mailto:jtulak@redhat.com">jtulak@r=
edhat.com</a> wrote:<br>
</span><span class=3D"">&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if (sb_feat.finobt &amp;&amp; sb_feat.finobtflag) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; &gt; _(&quot;warning: finobt not supported without CRC support, disabl=
ed.\n&quot;));<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br=
>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sb_f=
eat.finobt =3D 0;<br>
&gt; &gt;<br>
&gt; &gt; would suffice as before, no? Meh.=C2=A0 Not a big deal I guess...=
.<br>
&gt; &gt;<br>
&gt;<br>
&gt; =E2=80=8BChanged. Honestly, I don&#39;t like the strings starting at t=
he beginning of<br>
&gt; the line, because it breaks the indentation flow, but the rest of the =
code<br>
&gt; uses this style, so I should stick to it.=E2=80=8B<br>
<br>
</span>There&#39;s good reason for doing this - it makes it easy to grep th=
e<br>
source code for a specific error that has been emitted. Indentation<br>
is useful for demonstrating logic flow, but it&#39;s harmful when it<br>
results in strings you might want to find being split up over<br>
multiple lines.<br></blockquote><div><br></div><div><div class=3D"gmail_def=
ault" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BMmm, yeah, =
a valid point. It is caused by the 80 chars limit, but there are reasons fo=
r that too=E2=80=8B...</div></div><div><br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex">
<span class=3D""><br>
&gt; Thank you for the review. I will wait a little longer if someone spots=
<br>
&gt; something more, before sending an updated patchset.=E2=80=8B :-)<br>
<br>
</span>Just send it - I almost got to pulling in this version and<br>
fixing the various comments directly myself yesterday....<br></blockquote><=
div><br></div><div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif;display:inline">=E2=80=8BOK. I will fix what Eric subm=
itted in the mean time, test it to be sure I didn&#39;t broke anything and =
send.</div></div><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif;display:inline"><br></div></div><div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:inli=
ne">Cheers,</div></div><div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif;display:inline">Jan</div></div></div><br clea=
r=3D"all"><div><br></div>-- <br><div class=3D"gmail_signature"><div dir=3D"=
ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak=
@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mail=
to:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e01538da0d3d817052fe3bb19--


--===============1880576146000685008==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1880576146000685008==--
