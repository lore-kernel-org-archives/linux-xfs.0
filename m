Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 92E257F47
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 02:21:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 908E1304051
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 00:21:12 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	PNY3aJUb6edZZmOe (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2015 00:21:09 -0700 (PDT)
Received: by wicgb1 with SMTP id gb1so104688855wic.1
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 00:21:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150917081757.48aaf891@galadriel.home>
References: <CAH-PCH7W4yTDRhAiKQwN_wQJMx2sTitQYrLNPcLYHvJRucXBjA@mail.gmail.com>
	<20150917081757.48aaf891@galadriel.home>
Date: Thu, 17 Sep 2015 09:21:07 +0200
Message-ID: <CAH-PCH6w31ChsBzr4x91sf1CPi=qtACuypnpT0PqmGbKxG_5UA@mail.gmail.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
From: Ferenc Kovacs <tyra3l@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1640889505717541282=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

--===============1640889505717541282==
Content-Type: multipart/alternative; boundary=001a1130cbae4b5f1a051fec42ad

--001a1130cbae4b5f1a051fec42ad
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2015. szept. 17. 8:17 ezt =C3=ADrta ("Emmanuel Florac" <eflorac@intellique.=
com>):
>
> Le Wed, 16 Sep 2015 15:50:13 +0200 vous =C3=A9criviez:
>
> > Hi,
> >
> > have you found a resolution to your problem?
> > we are facing a similar issue(fs corruption every time when
> > rebuilding the array) with an Adaptec Series 8 Raid controller.
>
> The problem didn't occur anymore after I deactivated
> individual disks write caching in the "controller settings". This is
> only adjustable through the RAID BIOS though, not through arcconf
> apparently.
> This seems to apply to all of 5xx5, 6xx5, 7xx5 series. I never rebuilt
> an array with a 8xx5 yet (though I have some). I don't know why this is
> not the default settings (default keeps the disks write cache active
> instead). Adaptec support and engineering deny that the problem exists,
> though I've sent many logs and defined a test procedure that allow to
> reproduce the problem reliably enough.
> Thanks god for XFS. ext4 is completely unaware of the corruptions, but
> they're present nonetheless (md5summing files before, during and
> after rebuild)...
>

Thanks for the info!

> BTW I'm curious, where did you find this address? This isn't the one
> I'm using on the XFS mailing list...

I was using the gmane archives to read your thread and the there the domain
part is truncated for privacy(even from your signature) so I googled your
mail handle with your full name and this address was the first result.

--001a1130cbae4b5f1a051fec42ad
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
2015. szept. 17. 8:17 ezt =C3=ADrta (&quot;Emmanuel Florac&quot; &lt;<a hre=
f=3D"mailto:eflorac@intellique.com">eflorac@intellique.com</a>&gt;):<br>
&gt;<br>
&gt; Le Wed, 16 Sep 2015 15:50:13 +0200 vous =C3=A9criviez:<br>
&gt;<br>
&gt; &gt; Hi,<br>
&gt; &gt;<br>
&gt; &gt; have you found a resolution to your problem?<br>
&gt; &gt; we are facing a similar issue(fs corruption every time when<br>
&gt; &gt; rebuilding the array) with an Adaptec Series 8 Raid controller.<b=
r>
&gt;<br>
&gt; The problem didn&#39;t occur anymore after I deactivated<br>
&gt; individual disks write caching in the &quot;controller settings&quot;.=
 This is<br>
&gt; only adjustable through the RAID BIOS though, not through arcconf<br>
&gt; apparently.<br>
&gt; This seems to apply to all of 5xx5, 6xx5, 7xx5 series. I never rebuilt=
<br>
&gt; an array with a 8xx5 yet (though I have some). I don&#39;t know why th=
is is<br>
&gt; not the default settings (default keeps the disks write cache active<b=
r>
&gt; instead). Adaptec support and engineering deny that the problem exists=
,<br>
&gt; though I&#39;ve sent many logs and defined a test procedure that allow=
 to<br>
&gt; reproduce the problem reliably enough.<br>
&gt; Thanks god for XFS. ext4 is completely unaware of the corruptions, but=
<br>
&gt; they&#39;re present nonetheless (md5summing files before, during and<b=
r>
&gt; after rebuild)...<br>
&gt;</p>
<p dir=3D"ltr">Thanks for the info!</p>
<p dir=3D"ltr">&gt; BTW I&#39;m curious, where did you find this address? T=
his isn&#39;t the one<br>
&gt; I&#39;m using on the XFS mailing list...</p>
<p dir=3D"ltr">I was using the gmane archives to read your thread and the t=
here the domain part is truncated for privacy(even from your signature) so =
I googled your mail handle with your full name and this address was the fir=
st result.</p>

--001a1130cbae4b5f1a051fec42ad--


--===============1640889505717541282==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1640889505717541282==--
