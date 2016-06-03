Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF0927CA0
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 07:09:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B106AC021
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 05:09:41 -0700 (PDT)
Received: from mail-io0-f176.google.com (mail-io0-f176.google.com
	[209.85.223.176]) by cuda.sgi.com with ESMTP id
	fzEINqgTHCHyr0mD (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2016 05:09:39 -0700 (PDT)
Received: by mail-io0-f176.google.com with SMTP id p194so72973508iod.1
	for <xfs@oss.sgi.com>; Fri, 03 Jun 2016 05:09:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACj3i70LGZ7TKWRdKVTi4MyyL5DhnH5Fr-3Q6O5qhKbYfvWJbA@mail.gmail.com>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<20160510061054.GI26977@dastard>
	<CACj3i715X7X65=BjSW8GZLhUF-YjQVShC-_Udmxe24XB1ACb1w@mail.gmail.com>
	<20160603005324.GS12670@dastard>
	<CACj3i70LGZ7TKWRdKVTi4MyyL5DhnH5Fr-3Q6O5qhKbYfvWJbA@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 3 Jun 2016 14:09:19 +0200
Message-ID: <CACj3i734=8ZJcdJztA76ru93SpdNNUgVtF_tUv2Jy_8U0V9HzQ@mail.gmail.com>
Subject: Re: [PATCH 00/19 v2] mkfs cleaning
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8382126082811320890=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============8382126082811320890==
Content-Type: multipart/alternative; boundary=001a113ecd9cd208e005345e980a

--001a113ecd9cd208e005345e980a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[
=E2=80=8Bsnip all, another issue, unrelated to the lsunit one]=E2=80=8B

>
=E2=80=8BI realised one small glitch with conflicts watching in the code in
combination with flags. It is not regression, I think, because b=E2=80=8Bef=
ore now,
it was not possible to do something like -l internal=3D0,logdev=3Dsomething=
,
but now it should be possible.

The code checks only whether an option was seen, not its value, so it
does't know that we are in fact disabling something. I see two ways how to
do solve it. One is a custom conflict solving for these cases, putting some
if (flag1 && option2) somewhere once every argument and option is parsed.
But this goes against what the patchset did and moves it again out of the
option table...

The other way is to make a special case for flags in the conflicts-handling
code. Basically, I would extend the structure with something like:

{ .index =3D L_INTERNAL,
  .conflicts =3D { L_FILE,
        L_DEV,
        LAST_CONFLICT },
  .conflicts_ignore_on_false=3Dtrue, // new item, shorter name to be found
  .minval =3D 0,
  .maxval =3D 1,
  .defaultval =3D 1,
},

And then, if a conflict is found, it checks the value and if the value is
false/zero, then ignore the conflict. A more generic code would allow for
any given value, but I think that this would be useful only for flags, so
"on_false" and possibly "on_true" would be enough.

=E2=80=8BAny comments?

Thanks,
Jan=E2=80=8B




--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ecd9cd208e005345e980a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><div class=3D"gmai=
l_quote">[<div class=3D"gmail_default" style=3D"font-family:arial,helvetica=
,sans-serif;display:inline">=E2=80=8Bsnip all, another issue, unrelated to =
the lsunit one]=E2=80=8B</div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;border=
-left-color:rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div class=
=3D"gmail_extra"><span class=3D""><div data-smartmail=3D"gmail_signature"><=
div dir=3D"ltr"><div></div></div></div>
</span></div></div>
</blockquote></div><div class=3D"gmail_quote"><div class=3D"gmail_default" =
style=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></div><=
/div><div class=3D"gmail_quote"><div class=3D"gmail_default" style=3D"font-=
family:arial,helvetica,sans-serif">=E2=80=8BI realised one small glitch wit=
h conflicts watching in the code in combination with flags. It is not regre=
ssion, I think, because b=E2=80=8Before now, it was not possible to do some=
thing like -l internal=3D0,logdev=3Dsomething, but now it should be possibl=
e.</div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif"><br></div><div class=3D"gmail_default" style=3D"font-family:aria=
l,helvetica,sans-serif">The code checks only whether an option was seen, no=
t its value, so it does&#39;t know that we are in fact disabling something.=
 I see two ways how to do solve it. One is a custom conflict solving for th=
ese cases, putting some if (flag1 &amp;&amp; option2) somewhere once every =
argument and option is parsed. But this goes against what the patchset did =
and moves it again out of the option table...</div><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=
=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">The oth=
er way is to make a special case for flags in the conflicts-handling code. =
Basically, I would extend the structure with something like:</div><div clas=
s=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif"><br></=
div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-=
serif"><div class=3D"gmail_default">{ .index =3D L_INTERNAL,</div><div clas=
s=3D"gmail_default">=C2=A0 .conflicts =3D { L_FILE,</div><div class=3D"gmai=
l_default">=C2=A0 =C2=A0 =C2=A0 =C2=A0 L_DEV,</div><div class=3D"gmail_defa=
ult">=C2=A0 =C2=A0 =C2=A0 =C2=A0 LAST_CONFLICT },</div><div class=3D"gmail_=
default">=C2=A0 .conflicts_ignore_on_false=3Dtrue, // new item, shorter nam=
e to be found<br></div><div class=3D"gmail_default">=C2=A0 .minval =3D 0,</=
div><div class=3D"gmail_default">=C2=A0 .maxval =3D 1,</div><div class=3D"g=
mail_default">=C2=A0 .defaultval =3D 1,</div><div class=3D"gmail_default">}=
,</div><div class=3D"gmail_default"><br></div><div class=3D"gmail_default">=
And then, if a conflict is found, it checks the value and if the value is f=
alse/zero, then ignore the conflict. A more generic code would allow for an=
y given value, but I think that this would be useful only for flags, so &qu=
ot;on_false&quot; and possibly &quot;on_true&quot; would be enough.</div></=
div></div><div class=3D"gmail_quote"><br><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BAny comments?</div><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=
<br></div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica=
,sans-serif">Thanks,</div><div class=3D"gmail_default" style=3D"font-family=
:arial,helvetica,sans-serif">Jan=E2=80=8B</div><br></div><br><br clear=3D"a=
ll"><div><br></div>-- <br><div class=3D"gmail_signature" data-smartmail=3D"=
gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br><=
/div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.c=
om</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.m=
e</a></div></div></div></div>
</div></div>

--001a113ecd9cd208e005345e980a--


--===============8382126082811320890==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8382126082811320890==--
