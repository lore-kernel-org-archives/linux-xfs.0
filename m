Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D1B07CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 04:42:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CEDA5AC009
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 02:42:07 -0700 (PDT)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
	[209.85.213.182]) by cuda.sgi.com with ESMTP id
	GylMGR6uG2elEaCg (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 02:42:05 -0700 (PDT)
Received: by mail-ig0-f182.google.com with SMTP id ui10so65588315igc.1
	for <xfs@oss.sgi.com>; Thu, 07 Apr 2016 02:42:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570582AA.9020909@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<570582AA.9020909@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 7 Apr 2016 11:41:45 +0200
Message-ID: <CACj3i73aXdgGdN-Mk=5xiURxveZeBnDpJDVPfut98Qatrzb7TQ@mail.gmail.com>
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0177615101112112731=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============0177615101112112731==
Content-Type: multipart/alternative; boundary=047d7ba97ee0241f59052fe1e403

--047d7ba97ee0241f59052fe1e403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 6, 2016 at 11:42 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> > From: Jan Tulak <jtulak@redhat.com>
> >
> > Unify mkfs.xfs behaviour a bit and never truncate files. If the user
> > is trying to mkfs an existing file, we don't want to destroy anything
> > he did with the file before (sparse file, allocations...)
>
> Hm, I guess so ...  What motivated this change?  I see that it
> changes behavior, but I'm not sure what it unifies or fixes -
> can you explain more?
>
> Both, I think. The non-truncating is a new change, a fix of undesired sid=
e
effects, where user lost his changes to the file, like sparse file... The
rest should be unifying the behavior w.r.t. mkfs arguments. Do you think
that the O_TRUNC change should be a separate patch?


> > +     if (*isfile && statres !=3D 0 && (no_size || no_name)) {
>
> statres !=3D0 doesn't imply ENOENT; it could be EACCES
> or several other errors.  You'd need to check errno to know
> for sure.
>
> =E2=80=8BWell, then I need to print two errors. One if the file doesn't e=
xists,
but additional arguments will fix it, and one for other cases, where I will
print the specific error...

=E2=80=8BCheers,
Jan=E2=80=8B



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7ba97ee0241f59052fe1e403
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Wed, Ap=
r 6, 2016 at 11:42 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-=
family:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 3/24/=
16 6:15 AM, <a href=3D"mailto:jtulak@redhat.com">jtulak@redhat.com</a> wrot=
e:<br>
&gt; From: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtulak@redhat=
.com</a>&gt;<br>
&gt;<br>
&gt; Unify mkfs.xfs behaviour a bit and never truncate files. If the user<b=
r>
&gt; is trying to mkfs an existing file, we don&#39;t want to destroy anyth=
ing<br>
&gt; he did with the file before (sparse file, allocations...)<br>
<br>
</span>Hm, I guess so ...=C2=A0 What motivated this change?=C2=A0 I see tha=
t it<br>
changes behavior, but I&#39;m not sure what it unifies or fixes -<br>
can you explain more?<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">Both, I think. The non-truncating is a new change,=
 a fix of undesired side effects, where user lost his changes to the file, =
like sparse file... The rest should be unifying the behavior w.r.t. mkfs ar=
guments. Do you think that the O_TRUNC change should be a separate patch?</=
div></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica=
,sans-serif"><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div><div class=3D"im=
 trimless-h5 trimless-content"><br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (*isfile &amp;&amp; statres !=3D 0 &amp;&amp; =
(no_size || no_name)) {<br>
<br>
</div></div>statres !=3D0 doesn&#39;t imply ENOENT; it could be EACCES<br>
or several other errors.=C2=A0 You&#39;d need to check errno to know<br>
for sure.<br><br></blockquote><div><div class=3D"gmail_default" style=3D"fo=
nt-family:arial,helvetica,sans-serif;display:inline">=E2=80=8BWell, then I =
need to print two errors. One if the file doesn&#39;t exists, but additiona=
l arguments will fix it, and one for other cases, where I will print the sp=
ecific error...=C2=A0</div></div></div><div class=3D"gmail_extra"><br></div=
><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-ser=
if">=E2=80=8BCheers,</div><div class=3D"gmail_default" style=3D"font-family=
:arial,helvetica,sans-serif">Jan=E2=80=8B</div><br><br clear=3D"all"><div><=
br></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div d=
ir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" tar=
get=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me"=
 target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--047d7ba97ee0241f59052fe1e403--


--===============0177615101112112731==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0177615101112112731==--
