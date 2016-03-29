Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4C0097CA0
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 12:15:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1790AC002
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 10:14:59 -0700 (PDT)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com
	[209.85.213.179]) by cuda.sgi.com with ESMTP id
	UnE8U4UJmZcQOjfm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 10:14:54 -0700 (PDT)
Received: by mail-ig0-f179.google.com with SMTP id ui10so10638585igc.1
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 10:14:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FAAAB4.7090602@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-3-git-send-email-jtulak@redhat.com>
	<56F416E8.5000704@sandeen.net>
	<CACj3i71Ae1p8E35SrmpEiMen+mFY7MgQa2fHPueALDnF+HNRrQ@mail.gmail.com>
	<56FAAAB4.7090602@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 29 Mar 2016 19:14:34 +0200
Message-ID: <CACj3i71aD4LbeRPeKD4gRFNW1vVAdg4Do62-gQ+gK8NcyQg2YQ@mail.gmail.com>
Subject: Re: [PATCH 02/19] mkfs: sanitise ftype parameter values.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1994715929374101445=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============1994715929374101445==
Content-Type: multipart/alternative; boundary=089e013c60ecf0d859052f332af3

--089e013c60ecf0d859052f332af3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 29, 2016 at 6:17 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

>
>
> On 3/29/16 11:11 AM, Jan Tulak wrote:
> > On Thu, Mar 24, 2016 at 5:33 PM, Eric Sandeen <sandeen@sandeen.net
> <mailto:sandeen@sandeen.net>>wrote:
> >
> >
> >
> >     On 3/24/16 6:15 AM, jtulak@redhat.com <mailto:jtulak@redhat.com>
> wrote:
> >     > From: Dave Chinner <dchinner@redhat.com <mailto:
> dchinner@redhat.com>>
> >     >
> >     > Because passing "-n ftype=3D2" should fail.
> >
> >     but passing crc=3D1 ftype=3D1 shouldn't fail, should it?
> >     Seems like it will here.
> >
> >
> > =E2=80=8BFrom man page:
> > When  CRCs are enabled via -m crc=3D1, the ftype functionality is alway=
s
> enabled. This feature can not be
> > =E2=80=8B
> > turned off for such filesystem configurations.=E2=80=8B
> >
> >
> > =E2=80=8BSo I think it should not be possible to enter both crc and fty=
pe at
> > the same time - which is the current behaviour. It feels strange a
> > bit to allow ftype=3D1 (which does nothing with crc=3D1), but fail on
> > ftype=3D0=E2=80=8B
>
> My point is that -m crc=3D1 -d ftype=3D1 simply restates the defaults.
> Why should that combination fail?
>
> And -m crc=3D0 -d ftype=3D0 is also perfectly acceptable.
>
> In fact, -m crc=3D1 -d ftype=3D0 is the only one of the 4 combinations
> which is not ok, but AFAICT your patch fails the other 3 as well.
>

=E2=80=8BI removed the entire crc check - there is another one later in the=
 code,
so this was 1) redundant, 2) wrong, because it depended on whether -m crc=
=3D0
was before or after -n ftype (if after, default crc value was used for the
check).

However, it causes lots of conflicts on the following patches, so I will
send it later, once there are more changes...

Cheers, and thanks for catching it.

Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e013c60ecf0d859052f332af3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Tue, Ma=
r 29, 2016 at 6:17 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><br>
<br>
On 3/29/16 11:11 AM, Jan Tulak wrote:<br>
&gt; On Thu, Mar 24, 2016 at 5:33 PM, Eric Sandeen &lt;<a href=3D"mailto:sa=
ndeen@sandeen.net">sandeen@sandeen.net</a> &lt;mailto:<a href=3D"mailto:san=
deen@sandeen.net">sandeen@sandeen.net</a>&gt;&gt;wrote:<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0On 3/24/16 6:15 AM, <a href=3D"mailto:jtulak@redhat=
.com">jtulak@redhat.com</a> &lt;mailto:<a href=3D"mailto:jtulak@redhat.com"=
>jtulak@redhat.com</a>&gt; wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; From: Dave Chinner &lt;<a href=3D"mailto:dchin=
ner@redhat.com">dchinner@redhat.com</a> &lt;mailto:<a href=3D"mailto:dchinn=
er@redhat.com">dchinner@redhat.com</a>&gt;&gt;<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Because passing &quot;-n ftype=3D2&quot; shoul=
d fail.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0but passing crc=3D1 ftype=3D1 shouldn&#39;t fail, s=
hould it?<br>
&gt;=C2=A0 =C2=A0 =C2=A0Seems like it will here.<br>
&gt;<br>
&gt;<br>
&gt; =E2=80=8BFrom man page:<br>
&gt; When=C2=A0 CRCs are enabled via -m crc=3D1, the ftype functionality is=
 always enabled. This feature can not be<br>
&gt; =E2=80=8B<br>
&gt; turned off for such filesystem configurations.=E2=80=8B<br>
&gt;<br>
&gt;<br>
&gt; =E2=80=8BSo I think it should not be possible to enter both crc and ft=
ype at<br>
&gt; the same time - which is the current behaviour. It feels strange a<br>
&gt; bit to allow ftype=3D1 (which does nothing with crc=3D1), but fail on<=
br>
&gt; ftype=3D0=E2=80=8B<br>
<br>
</span>My point is that -m crc=3D1 -d ftype=3D1 simply restates the default=
s.<br>
Why should that combination fail?<br>
<br>
And -m crc=3D0 -d ftype=3D0 is also perfectly acceptable.<br>
<br>
In fact, -m crc=3D1 -d ftype=3D0 is the only one of the 4 combinations<br>
which is not ok, but AFAICT your patch fails the other 3 as well.<br></bloc=
kquote><div><br></div><div><div class=3D"gmail_default" style=3D"font-famil=
y:arial,helvetica,sans-serif;display:inline">=E2=80=8BI removed the entire =
crc check - there is another one later in the code, so this was 1) redundan=
t, 2) wrong, because it depended on whether -m crc=3D0 was before or after =
-n ftype (if after, default crc value was used for the check).</div></div><=
div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-=
serif;display:inline"><br></div></div><div><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif;display:inline">However, it ca=
uses lots of conflicts on the following patches, so I will send it later, o=
nce there are more changes...</div></div><div><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></div><=
/div><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica=
,sans-serif;display:inline">Cheers, and thanks for catching it.</div></div>=
<div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans=
-serif;display:inline"><br></div></div><div><div class=3D"gmail_default" st=
yle=3D"font-family:arial,helvetica,sans-serif;display:inline">Jan</div></di=
v><div><br></div></div>-- <br><div class=3D"gmail_signature"><div dir=3D"lt=
r"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@r=
edhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto=
:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e013c60ecf0d859052f332af3--


--===============1994715929374101445==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1994715929374101445==--
