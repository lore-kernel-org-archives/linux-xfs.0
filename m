Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 422187CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 06:16:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABF82AC002
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 04:16:12 -0700 (PDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
	[209.85.213.174]) by cuda.sgi.com with ESMTP id
	0bZaS68mfASsdJ3C (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 07 Apr 2016 04:16:11 -0700 (PDT)
Received: by mail-ig0-f174.google.com with SMTP id g8so67318436igr.0
	for <xfs@oss.sgi.com>; Thu, 07 Apr 2016 04:16:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57059579.9090900@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-5-git-send-email-jtulak@redhat.com>
	<57059579.9090900@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 7 Apr 2016 13:15:51 +0200
Message-ID: <CACj3i71TBOdei0RCQZMVL_nMO58z3htP2S+98+54ZVFAWc_A+w@mail.gmail.com>
Subject: Re: [PATCH 04/19] mkfs: validate all input values
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8690798708003772675=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8690798708003772675==
Content-Type: multipart/alternative; boundary=089e01538da09d8d98052fe33436

--089e01538da09d8d98052fe33436
Content-Type: text/plain; charset=UTF-8

On Thu, Apr 7, 2016 at 1:02 AM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > CHANGELOG
> > o Fix an unsigned < 0 comparison - save getnum result to another variable
> >   and test it, before converting it to unsigned logagno.
>
> ...
>
> > @@ -1468,7 +1485,10 @@ main(
> >                                               respec('l', lopts,
> L_AGNUM);
> >                                       if (ldflag)
> >                                               conflict('l', lopts,
> L_AGNUM, L_DEV);
> > -                                     logagno = atoi(value);
> > +                                     tmp_num = getnum(value, 0, 0,
> false);
> > +                                     if (tmp_num < 0)
> > +                                             illegal(value, "l agno");
> > +                                     logagno = (xfs_agnumber_t)tmp_num;
> >                                       laflag = 1;
> >                                       break;
> >                               case L_FILE:
>
> Why not cast to (__int64_t) like other variables do?  i.e.
>
>
> +                                       logagno = getnum(value, 0, 0,
> false);
> +                                       if ((__int64_t)logagno < 0)
> +                                               illegal(value, "l agno");
>
> or am I missing something?
>
> Nothing I'm aware of. Replaced.



> Thanks,
> -Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e01538da09d8d98052fe33436
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Thu, Ap=
r 7, 2016 at 1:02 AM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On 3/24/=
16 6:15 AM, <a href=3D"mailto:jtulak@redhat.com">jtulak@redhat.com</a> wrot=
e:<br>
&gt; From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner=
@redhat.com</a>&gt;<br>
&gt;<br>
&gt; CHANGELOG<br>
&gt; o Fix an unsigned &lt; 0 comparison - save getnum result to another va=
riable<br>
&gt;=C2=A0 =C2=A0and test it, before converting it to unsigned logagno.<br>
<br>
</span>...<br>
<span class=3D""><br>
&gt; @@ -1468,7 +1485,10 @@ main(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0respec(&#39;l&#39;, lopts, L_AGNUM);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ld=
flag)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0conflict(&#39;l&#39;, lopts, L_AGNUM, L_DEV);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0logagno =3D =
atoi(value);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tmp_num =3D =
getnum(value, 0, 0, false);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (tmp_num =
&lt; 0)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0illegal(value, &quot;l agno&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0logagno =3D =
(xfs_agnumber_t)tmp_num;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0laflag=
 =3D 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case L_FILE:<br>
<br>
</span>Why not cast to (__int64_t) like other variables do?=C2=A0 i.e.<br>
<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0logagno =
=3D getnum(value, 0, 0, false);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ((__in=
t64_t)logagno &lt; 0)<br>
<span class=3D"">+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0illegal(value, &quot;l agno&quot;);<b=
r>
<br>
</span>or am I missing something?<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">Nothing I&#39;m aware of. Replaced.</div><br></div=
><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .=
8ex;border-left:1px #ccc solid;padding-left:1ex">
Thanks,<br>
-Eric<br>
<div class=3D"HOEnZb"><div class=3D"im trimless-h5 trimless-content"><br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" targ=
et=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>=
Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">j=
tulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blan=
k">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e01538da09d8d98052fe33436--


--===============8690798708003772675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8690798708003772675==--
