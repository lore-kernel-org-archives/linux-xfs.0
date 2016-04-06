Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DAF427CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 04:12:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD7968F8035
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 02:12:42 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	GDEh8XQDP8qzcKF2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 02:12:41 -0700 (PDT)
Received: by mail-io0-f174.google.com with SMTP id q128so48874053iof.3
	for <xfs@oss.sgi.com>; Wed, 06 Apr 2016 02:12:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56FDD750.3040002@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-4-git-send-email-jtulak@redhat.com>
	<56FDD750.3040002@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 6 Apr 2016 11:12:21 +0200
Message-ID: <CACj3i71=v+p2=mM75Na0Lujt+gQjB1hX=En0K12he+7WF6q=wQ@mail.gmail.com>
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4159958651969504982=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============4159958651969504982==
Content-Type: multipart/alternative; boundary=001a11427d74200291052fcd5d7a

--001a11427d74200291052fcd5d7a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 1, 2016 at 4:05 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
>


> Just FYI - generally, the patch changelog goes below the "---"
> so it doesn't end up as part of the changelog in git.
>
> =E2=80=8BGood idea, next time it should be there.=E2=80=8B


> >       } else {
> >               /*
> >                * The kernel doesn't currently support crc=3D0,finobt=3D=
1
> > -              * filesystems. If crcs are not enabled and the user has
> > -              * explicitly turned them off then silently turn them off
> > -              * to avoid an unnecessary warning. If the user explicitl=
y
> > -              * tried to use crc=3D0,finobt=3D1, then issue a warning =
before
> > -              * turning them off.
> > +              * filesystems. If crcs are not enabled and the user has
> not
> > +              * explicitly turned finobt on, then silently turn it off
> to
> > +              * avoid an unnecessary warning. If the user explicitly
> tried
> > +              * to use crc=3D0,finobt=3D1, then issue a warning before
> turning
> > +              * them off.
> >                */
> > -             if (finobt && finobtflag) {
> > -                     fprintf(stderr,
> > -_("warning: finobt not supported without CRC support, disabled.\n"));
> > +             if (sb_feat.finobt){
> > +                     if (sb_feat.finobtflag) {
> > +                             fprintf(stderr,
> > +     _("warning: finobt not supported without CRC support,
> disabled.\n"));
> > +                     }
> > +                     sb_feat.finobt =3D 0;
> >               }
> > -             finobt =3D 0;
> >       }
>
> Is there any other case in mkfs where options are automatically disabled?
> I don't think so .. I'd just prefer a failure here, not a fix-up, even
> with the warning.  But I guess that's how it was before, so probably
> not something to change in this patch.  So never mind.  :)
>
> =E2=80=8BWell, it was so, but as I'm trying to get rid of inconsistencies=
, I
changed it to a failure if both crc=3D0 and finobt=3D1 are explicitly used.



> But, do we need the extra indentation?
>
>                 if (sb_feat.finobt && sb_feat.finobtflag) {
>                         fprintf(stderr,
> _("warning: finobt not supported without CRC support, disabled.\n"));
>                 }
>                 sb_feat.finobt =3D 0;
>
> would suffice as before, no? Meh.  Not a big deal I guess....
>

=E2=80=8BChanged. Honestly, I don't like the strings starting at the beginn=
ing of
the line, because it breaks the indentation flow, but the rest of the code
uses this style, so I should stick to it.=E2=80=8B



> > @@ -2962,7 +3038,7 @@ _("size %s specified for log subvolume is too
> large, maximum is %lld blocks\n"),
> >               /*
> >                * Free INO btree root block
> >                */
> > -             if (!finobt) {
> > +             if (!sb_feat.finobt){
>                                     ^ please fix whitespace :)
>

=E2=80=8BDone.

Thank you for the review. I will wait a little longer if someone spots
something more, before sending an updated patchset.=E2=80=8B :-)

=E2=80=8BCheers,
Jan=E2=80=8B


--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a11427d74200291052fcd5d7a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><br><div class=
=3D"gmail_quote">On Fri, Apr 1, 2016 at 4:05 AM, Eric Sandeen <span dir=3D"=
ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@s=
andeen.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span cl=
ass=3D"">On 3/24/16 6:15 AM, <a href=3D"mailto:jtulak@redhat.com">jtulak@re=
dhat.com</a> wrote:<br></span></blockquote><div>=C2=A0</div><blockquote cla=
ss=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;pa=
dding-left:1ex"><span class=3D"">
</span>Just FYI - generally, the patch changelog goes below the &quot;---&q=
uot;<br>
so it doesn&#39;t end up as part of the changelog in git.<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">=E2=80=8BGood idea, next time it should be there.=
=E2=80=8B</div></div><div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif"><br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * The kernel do=
esn&#39;t currently support crc=3D0,finobt=3D1<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * filesystems. If cr=
cs are not enabled and the user has<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * explicitly turned =
them off then silently turn them off<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * to avoid an unnece=
ssary warning. If the user explicitly<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * tried to use crc=
=3D0,finobt=3D1, then issue a warning before<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * turning them off.<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * filesystems. If cr=
cs are not enabled and the user has not<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * explicitly turned =
finobt on, then silently turn it off to<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * avoid an unnecessa=
ry warning. If the user explicitly tried<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * to use crc=3D0,fin=
obt=3D1, then issue a warning before turning<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * them off.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (finobt &amp;&amp;=
 finobtflag) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0fprintf(stderr,<br>
&gt; -_(&quot;warning: finobt not supported without CRC support, disabled.\=
n&quot;));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sb_feat.finobt){<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0if (sb_feat.finobtflag) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;warning: finobt not supported without CRC=
 support, disabled.\n&quot;));<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0sb_feat.finobt =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0finobt =3D 0;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
<br>
</span>Is there any other case in mkfs where options are automatically disa=
bled?<br>
I don&#39;t think so .. I&#39;d just prefer a failure here, not a fix-up, e=
ven<br>
with the warning.=C2=A0 But I guess that&#39;s how it was before, so probab=
ly<br>
not something to change in this patch.=C2=A0 So never mind.=C2=A0 :)<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">=E2=80=8BWell, it was so, but as I&#39;m trying to=
 get rid of inconsistencies, I changed it to a failure if both crc=3D0 and =
finobt=3D1 are explicitly used.=C2=A0</div><br></div><div>=C2=A0</div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #cc=
c solid;padding-left:1ex">
But, do we need the extra indentation?<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sb_feat.finobt =
&amp;&amp; sb_feat.finobtflag) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 fprintf(stderr,<br>
<span class=3D"">_(&quot;warning: finobt not supported without CRC support,=
 disabled.\n&quot;));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
</span>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sb_feat.fino=
bt =3D 0;<br>
<br>
would suffice as before, no? Meh.=C2=A0 Not a big deal I guess....<br></blo=
ckquote><div>=C2=A0</div><div><div class=3D"gmail_default" style=3D"font-fa=
mily:arial,helvetica,sans-serif;display:inline">=E2=80=8BChanged. Honestly,=
 I don&#39;t like the strings starting at the beginning of the line, becaus=
e it breaks the indentation flow, but the rest of the code uses this style,=
 so I should stick to it.=E2=80=8B</div>=C2=A0</div><div><br></div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc s=
olid;padding-left:1ex">
<span class=3D""><br>
&gt; @@ -2962,7 +3038,7 @@ _(&quot;size %s specified for log subvolume is t=
oo large, maximum is %lld blocks\n&quot;),<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Free INO btre=
e root block<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!finobt) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!sb_feat.finobt){=
<br>
</span>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^ please fix wh=
itespace :)<div class=3D"HOEnZb"><div class=3D"im trimless-h5 trimless-cont=
ent"></div></div></blockquote><div><br></div><div><div class=3D"gmail_defau=
lt" style=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BDone.</div><d=
iv class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"=
><br></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetic=
a,sans-serif">Thank you for the review. I will wait a little longer if some=
one spots something more, before sending an updated patchset.=E2=80=8B :-)<=
/div><br></div><div><div class=3D"gmail_default" style=3D"font-family:arial=
,helvetica,sans-serif">=E2=80=8BCheers,</div><div class=3D"gmail_default" s=
tyle=3D"font-family:arial,helvetica,sans-serif">Jan=E2=80=8B</div><br></div=
></div><div><br></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr=
"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@re=
dhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:=
jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--001a11427d74200291052fcd5d7a--


--===============4159958651969504982==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4159958651969504982==--
