Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2021B7F54
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 09:54:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B4D98F8054
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 07:54:37 -0700 (PDT)
Received: from mail-qa0-f54.google.com (mail-qa0-f54.google.com
	[209.85.216.54]) by cuda.sgi.com with ESMTP id MraEkymU1xd91lE0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 10 Sep 2014 07:54:34 -0700 (PDT)
Received: by mail-qa0-f54.google.com with SMTP id x12so17694239qac.27
	for <xfs@oss.sgi.com>; Wed, 10 Sep 2014 07:54:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140910163124.3d879432@harpe.intellique.com>
References: <540F1B01.3020700@mygrande.net> <20140909220645.GH20518@dastard>
	<540FA586.9090308@mygrande.net>
	<CAA43vkVYX+zJQcoTH2iSX7rS9B1D=mnTeyS0QqP+fbKxVY0YZA@mail.gmail.com>
	<540FACAC.3010504@mygrande.net>
	<20140910163124.3d879432@harpe.intellique.com>
Date: Wed, 10 Sep 2014 10:54:33 -0400
Message-ID: <CAA43vkWFqjxWW-hBHPv3MBr_h1uWTkfzCV2z3twCBQpAyXq80g@mail.gmail.com>
Subject: Re: Corrupted files
From: Sean Caron <scaron@umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1861653117084296953=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>, Sean Caron <scaron@umich.edu>
Cc: Leslie Rhorer <lrhorer@mygrande.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============1861653117084296953==
Content-Type: multipart/alternative; boundary=089e0149c46ee3e15b0502b73a95

--089e0149c46ee3e15b0502b73a95
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

I am probably overseeing a similar number (3-4000) of Hitachi A7K3000s,
A7K2000s and WDC RE4s and I probably see a few failures a month. When we
are building a new machine and we get a fresh shipment in, maybe 10%
failure rate right out of the box. Those that survive the burn-in usually
do pretty good. Man, you have my sympathy with that failure rate in excess
of 50%... even the WDC Greens weren't THAT bad (although it probably got
close, as we neared closer and closer to EOLing them... and they had been
moved to third-tier "backup storage" status by that point). Thankfully they
are gone now, LOL.

You're right, esp. in large installations, it's critical to do your
homework on drives, pick a good candidate, validate it and then run with
them. Even with the good ones, you've gotta keep a watchful eye... "when
you buy them in bulk, they fail in bulk".

Best,

Sean



On Wed, Sep 10, 2014 at 10:31 AM, Emmanuel Florac <eflorac@intellique.com>
wrote:

> Le Tue, 09 Sep 2014 20:43:08 -0500
> Leslie Rhorer <lrhorer@mygrande.net> =C3=A9crivait:
>
> >       None of the failed drives were WD green.  All three and the
> > previous four were Seagate.  I realize that is not a large
> > statistical sample.
> >
>
> If you're interested in large statistical samples, on a grand total of
> 4000 1 TB Seagate Barracuda ES2, I had to replace 2100 of them over the
> course of 3 years. I still have a couple of hundred of these
> unfortunate pieces of crap in service, and they still represent the
> vast majority of unexpected RAID malfunctions, urgent replacements,
> late night calls and other "interesting side activities".
>
> I wouldn't buy anything labeled Seagate nowadays. Their drives have
> been the baddest train wreck since the dreaded 9 GB Micropolis back in
> 1994 (or was it 1995?).
>
> --
> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                     |   Intellique
>                     |   <eflorac@intellique.com>
>                     |   +33 1 78 94 84 02
> ------------------------------------------------------------------------
>

--089e0149c46ee3e15b0502b73a95
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I am probably overseeing a similar number (3-4000) of Hita=
chi A7K3000s, A7K2000s and WDC RE4s and I probably see a few failures a mon=
th. When we are building a new machine and we get a fresh shipment in, mayb=
e 10% failure rate right out of the box. Those that survive the burn-in usu=
ally do pretty good. Man, you have my sympathy with that failure rate in ex=
cess of 50%... even the WDC Greens weren&#39;t THAT bad (although it probab=
ly got close, as we neared closer and closer to EOLing them... and they had=
 been moved to third-tier &quot;backup storage&quot; status by that point).=
 Thankfully they are gone now, LOL.<div><br></div><div>You&#39;re right, es=
p. in large installations, it&#39;s critical to do your homework on drives,=
 pick a good candidate, validate it and then run with them. Even with the g=
ood ones, you&#39;ve gotta keep a watchful eye... &quot;when you buy them i=
n bulk, they fail in bulk&quot;.</div><div><br></div><div>Best,</div><div><=
br>Sean</div><div><br><div><br></div></div></div><div class=3D"gmail_extra"=
><br><div class=3D"gmail_quote">On Wed, Sep 10, 2014 at 10:31 AM, Emmanuel =
Florac <span dir=3D"ltr">&lt;<a href=3D"mailto:eflorac@intellique.com" targ=
et=3D"_blank">eflorac@intellique.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">Le Tue, 09 Sep 2014 20:43:08 -0500<br>
Leslie Rhorer &lt;<a href=3D"mailto:lrhorer@mygrande.net">lrhorer@mygrande.=
net</a>&gt; =C3=A9crivait:<br>
<span class=3D""><br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0None of the failed drives were WD green.=C2=
=A0 All three and the<br>
&gt; previous four were Seagate.=C2=A0 I realize that is not a large<br>
&gt; statistical sample.<br>
&gt;<br>
<br>
</span>If you&#39;re interested in large statistical samples, on a grand to=
tal of<br>
4000 1 TB Seagate Barracuda ES2, I had to replace 2100 of them over the<br>
course of 3 years. I still have a couple of hundred of these<br>
unfortunate pieces of crap in service, and they still represent the<br>
vast majority of unexpected RAID malfunctions, urgent replacements,<br>
late night calls and other &quot;interesting side activities&quot;.<br>
<br>
I wouldn&#39;t buy anything labeled Seagate nowadays. Their drives have<br>
been the baddest train wreck since the dreaded 9 GB Micropolis back in<br>
1994 (or was it 1995?).<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
--<br>
------------------------------------------------------------------------<br=
>
Emmanuel Florac=C2=A0 =C2=A0 =C2=A0|=C2=A0 =C2=A0Direction technique<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0Intellique<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0&lt;<a href=3D"mailto:eflorac@intellique.com">eflorac@intellique.=
com</a>&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=
=A0 =C2=A0<a href=3D"tel:%2B33%201%2078%2094%2084%2002" value=3D"+331789484=
02">+33 1 78 94 84 02</a><br>
------------------------------------------------------------------------<br=
>
</div></div></blockquote></div><br></div>

--089e0149c46ee3e15b0502b73a95--


--===============1861653117084296953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1861653117084296953==--
