Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q715tuZQ254760 for <xfs@oss.sgi.com>; Wed, 1 Aug 2012 00:55:56 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	3F1Ng8bn5o541xbP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 31 Jul 2012 22:55:55 -0700 (PDT)
Received: by obbup19 with SMTP id up19so12850980obb.26
	for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 22:55:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5018A8C7.8050406@hardwarefreak.com>
References: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
	<20120730030333.GE2877@dastard>
	<CAGou9MheeBWxajd65szNfDB2L+VVoZ7SypEdUKj7np3L0H8fHA@mail.gmail.com>
	<CAGou9MgMHbTPebFUDXdyLvrUr4T9wo-geNtaPUft9uUmOaju6Q@mail.gmail.com>
	<50186E51.1020107@hardwarefreak.com>
	<CAGou9MhneejOuhX4c8G06c3Zh7dxF-OtZ+=mT-7fho_u1Q3zWw@mail.gmail.com>
	<5018A8C7.8050406@hardwarefreak.com>
Date: Tue, 31 Jul 2012 22:55:54 -0700
Message-ID: <CAGou9Mj=8xcF4YwaSQYp0_BbJW_Ms1sasDDRNxL1oh0oR7zupw@mail.gmail.com>
Subject: Re: realtime section bugs still around
From: Jason Newton <nevion@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5099553210007132437=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============5099553210007132437==
Content-Type: multipart/alternative; boundary=e89a8fb200fab8ff6804c62df2f6

--e89a8fb200fab8ff6804c62df2f6
Content-Type: text/plain; charset=UTF-8

On Tue, Jul 31, 2012 at 8:55 PM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

>
> Intel Matrix RAID is fakeraid.  Designed for consumer workloads.  You're
> shoving a decidedly non consumer, high b/w IO stream through it.  Don't
> expect much.  In fact I'm surprised you're using consumer grade gear for
> this application.  You are designing this software/system for a
> commercial use case, correct?  If so I'd get some better hardware.
>
> CPU overhead for fakeraid will be similar to md/RAID, depending on the
> vendor and implementation.  In some cases it may be much higher than md.
>

I see.  Its important things stay COTS and small... things are sort of in a
prototyping phase with some size and power constraints.  We had problems
packaging what we already have and consider we already have some
specialized io hardware we've had to account for..  There's just not much
if any room available anymore.  We're getting refined tasks in the future
and requirements will change as well... in particular this disk streaming
component is perhaps a one-off  thing that we were notified of late in the
game.

I did read around that from intel sources that Matrix Storage it really
more of a hybrid solution... after all, they make sata controllers... and
they already have to put up with 6Gb/s in hardware. But maybe they save a
penny on the real-estate.. so maybe it's just fluff from intel PR.  What
kind of hardware do you need in addition to make hardware raid 0 or 1
though.... .

>
> > 2.  ATA overhead
> >> 3.  IRQ/MSI overhead
> >> 4.  Etc.
> >>
> >> All these small bits add up to more than negligible CPU overhead at high
> >> data rates.
> >>
> >
> > Regarding the others, how would I go about measuring their overhead...
>
> To what end?
>
> Just to figure out for sure what the bottlenecks are and whether they can
be dealt with rather than looking at it as opaque system and assuming
nothing can be done.  Also as a learning experience.

--
> Stan
>
>

--e89a8fb200fab8ff6804c62df2f6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Tue, Jul 31, 2012 at 8:55 PM, Stan Ho=
eppner <span dir=3D"ltr">&lt;<a href=3D"mailto:stan@hardwarefreak.com" targ=
et=3D"_blank">stan@hardwarefreak.com</a>&gt;</span> wrote:<br><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;=
padding-left:1ex">
<div class=3D"im"><br>
</div>Intel Matrix RAID is fakeraid. =C2=A0Designed for consumer workloads.=
 =C2=A0You&#39;re<br>
shoving a decidedly non consumer, high b/w IO stream through it. =C2=A0Don&=
#39;t<br>
expect much. =C2=A0In fact I&#39;m surprised you&#39;re using consumer grad=
e gear for<br>
this application. =C2=A0You are designing this software/system for a<br>
commercial use case, correct? =C2=A0If so I&#39;d get some better hardware.=
<br>
<br>
CPU overhead for fakeraid will be similar to md/RAID, depending on the<br>
vendor and implementation. =C2=A0In some cases it may be much higher than m=
d.<br></blockquote><div><br>I see.=C2=A0 Its important things stay COTS and=
 small... things are sort of in a prototyping phase with some size and powe=
r constraints.=C2=A0 We had problems packaging what we already have and con=
sider we already have some specialized io hardware we&#39;ve had to account=
 for..=C2=A0 There&#39;s just not much if any room available anymore.=C2=A0=
 We&#39;re getting refined tasks in the future and requirements will change=
 as well... in particular this disk streaming component is perhaps a one-of=
f=C2=A0 thing that we were notified of late in the game.<br>
<br>I did read around that from intel sources that Matrix Storage it really=
 more of a hybrid solution... after all, they make sata controllers... and =
they already have to put up with 6Gb/s in hardware. But maybe they save a p=
enny on the real-estate.. so maybe it&#39;s just fluff from intel PR.=C2=A0=
 What kind of hardware do you need in addition to make hardware raid 0 or 1=
 though.... .<br>
</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">
<div class=3D"im"><br>
&gt; 2. =C2=A0ATA overhead<br>
&gt;&gt; 3. =C2=A0IRQ/MSI overhead<br>
&gt;&gt; 4. =C2=A0Etc.<br>
&gt;&gt;<br>
&gt;&gt; All these small bits add up to more than negligible CPU overhead a=
t high<br>
&gt;&gt; data rates.<br>
&gt;&gt;<br>
&gt;<br>
&gt; Regarding the others, how would I go about measuring their overhead...=
<br>
<br>
</div>To what end?<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br></font></span></blockquo=
te><div>Just to figure out for sure what the bottlenecks are and whether th=
ey can be dealt with rather than looking at it as opaque system and assumin=
g nothing can be done.=C2=A0 Also as a learning experience.<br>
<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex"><span class=3D"HOEnZb"><font color=
=3D"#888888">
--<br>
Stan<br>
<br>
</font></span></blockquote></div><br>

--e89a8fb200fab8ff6804c62df2f6--


--===============5099553210007132437==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5099553210007132437==--
