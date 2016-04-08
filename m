Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5A61F7CA6
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 05:31:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12CC6304039
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 03:31:04 -0700 (PDT)
Received: from mail-io0-f182.google.com (mail-io0-f182.google.com
	[209.85.223.182]) by cuda.sgi.com with ESMTP id
	XVRyPTvAuC99uvqR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 03:31:01 -0700 (PDT)
Received: by mail-io0-f182.google.com with SMTP id g185so126748641ioa.2
	for <xfs@oss.sgi.com>; Fri, 08 Apr 2016 03:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5706981A.9090904@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-9-git-send-email-jtulak@redhat.com>
	<5706981A.9090904@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 8 Apr 2016 12:30:40 +0200
Message-ID: <CACj3i71TB=VkjCGpNCjOXs7Tuc6ayZEQbfuaFqZ85jPkTBx1=Q@mail.gmail.com>
Subject: Re: [PATCH 08/19] mkfs: getbool is redundant
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7900948485977426455=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============7900948485977426455==
Content-Type: multipart/alternative; boundary=001a113ebe20ed1890052ff6b079

--001a113ebe20ed1890052ff6b079
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 7, 2016 at 7:25 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

>
>
> "Many options allow for an optional argument of 0 or 1, ..."
>
> > +disable or enable the functionality, in a forward-compatible syntax.
>
> What does "forward-compatible syntax" mean?  I'm not sure that clarifies
> anything for the reader.
>
> =E2=80=8BYeah, I should reformulate it, I think. The meaning is that it w=
on't
matter what the defaults are now, or will be in the future. E.g., if you
had a script creating a fs without crc before, when it was disabled by
default, and we changed the default, you are now creating with the crc. But
if you give it -m crc=3D0, then no matter what the default is, you have it
always disabled.

How about changing the line to "Boolean options allows for optional
argument of value 0 or 1, to explicitly disable or enable the
functionality," and dropping the forward-compatible part?



> Otherwise this looks ok to me; Dave explained that it is intentional to
> make every single option accept a value, whether it is now
> boolean or a numeric value, so there is no such thing as a bare "--flag"
> anymore; such flags are always "--flag [0|1]" now, right?
>

=E2=80=8BFor options inside of -m, -d and such, yes. Top-level flags, that =
is -f,
-q, -N, -K and -V, are still only flags, but these don't change the FS
attributes. They are something different from the other. Still, I wonder
whether they should accept [0|1] too...

=E2=80=8B


>
> > @@ -312,10 +315,12 @@ and
> >  .B swidth
> >  values.
> >  .TP
> > -.BI noalign
> > -This option disables automatic geometry detection and creates the
> filesystem
> > +.BI noalign[=3D value ]
> > +If the
> > +.I value
> > +is 1, this option disables automatic geometry detection and creates th=
e
> filesystem
> >  without stripe geometry alignment even if the underlying storage devic=
e
> provides
> > -this information.
> > +this information. 0 disables this option, that is, enables automatic
> detection.
> >  .RE
> >  .TP
> >  .B \-f
>
> The realtime section of the manpage needs this same fixup now too, I gues=
s.
>
> Done=E2=80=8B



> Thanks,
> -Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

=E2=80=8BThanks,
Jan=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ebe20ed1890052ff6b079
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Thu, Ap=
r 7, 2016 at 7:25 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><div class=3D""><div class=3D"h5"><br><=
br>
</div></div>&quot;Many options allow for an optional argument of 0 or 1, ..=
.&quot;<br>
<span class=3D""><br>
&gt; +disable or enable the functionality, in a forward-compatible syntax.<=
br>
<br>
</span>What does &quot;forward-compatible syntax&quot; mean?=C2=A0 I&#39;m =
not sure that clarifies<br>
anything for the reader.<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">=E2=80=8BYeah, I should reformulate it, I think. T=
he meaning is that it won&#39;t matter what the defaults are now, or will b=
e in the future. E.g., if you had a script creating a fs without crc before=
, when it was disabled by default, and we changed the default, you are now =
creating with the crc. But if you give it -m crc=3D0, then no matter what t=
he default is, you have it always disabled.</div><div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D=
"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">How about =
changing the line to &quot;Boolean options allows for optional argument of =
value 0 or 1, to explicitly disable or enable the functionality,&quot; and =
dropping the forward-compatible part?</div><br></div><div>=C2=A0</div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left-=
width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;paddin=
g-left:1ex">
Otherwise this looks ok to me; Dave explained that it is intentional to<br>
make every single option accept a value, whether it is now<br>
boolean or a numeric value, so there is no such thing as a bare &quot;--fla=
g&quot;<br>
anymore; such flags are always &quot;--flag [0|1]&quot; now, right?<br></bl=
ockquote><div><div class=3D"gmail_default" style=3D"font-family:arial,helve=
tica,sans-serif;display:inline"><br></div></div><div><div class=3D"gmail_de=
fault" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BFor option=
s inside of -m, -d and such, yes. Top-level flags, that is -f, -q, -N, -K a=
nd -V, are still only flags, but these don&#39;t change the FS attributes. =
They are something different from the other. Still, I wonder whether they s=
hould accept [0|1] too...</div><br></div><div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B</=
div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-le=
ft-style:solid;padding-left:1ex">
<span class=3D""><br>
&gt; @@ -312,10 +315,12 @@ and<br>
&gt;=C2=A0 .B swidth<br>
&gt;=C2=A0 values.<br>
&gt;=C2=A0 .TP<br>
&gt; -.BI noalign<br>
&gt; -This option disables automatic geometry detection and creates the fil=
esystem<br>
&gt; +.BI noalign[=3D value ]<br>
&gt; +If the<br>
&gt; +.I value<br>
&gt; +is 1, this option disables automatic geometry detection and creates t=
he filesystem<br>
&gt;=C2=A0 without stripe geometry alignment even if the underlying storage=
 device provides<br>
&gt; -this information.<br>
&gt; +this information. 0 disables this option, that is, enables automatic =
detection.<br>
&gt;=C2=A0 .RE<br>
&gt;=C2=A0 .TP<br>
&gt;=C2=A0 .B \-f<br>
<br>
</span>The realtime section of the manpage needs this same fixup now too, I=
 guess.<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">Done=E2=80=8B</div><br></div><div>=C2=A0</div><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;paddi=
ng-left:1ex">
Thanks,<br>
-Eric<br>
<div class=3D""><div class=3D"h5"><br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" targ=
et=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><div class=3D"gmail_default" style=3D"fo=
nt-family:arial,helvetica,sans-serif">=E2=80=8BThanks,</div><div class=3D"g=
mail_default" style=3D"font-family:arial,helvetica,sans-serif">Jan=E2=80=8B=
</div><br clear=3D"all"><div><br></div>-- <br><div class=3D"gmail_signature=
"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D=
"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <=
a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></di=
v></div></div>
</div></div>

--001a113ebe20ed1890052ff6b079--


--===============7900948485977426455==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7900948485977426455==--
