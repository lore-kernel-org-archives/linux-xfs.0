Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q722chW4103599 for <xfs@oss.sgi.com>; Wed, 1 Aug 2012 21:38:43 -0500
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	qhweeQHHIAniNQhH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Aug 2012 19:38:42 -0700 (PDT)
Received: by obbup19 with SMTP id up19so14348358obb.26
	for <xfs@oss.sgi.com>; Wed, 01 Aug 2012 19:38:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5019CC34.5050003@hardwarefreak.com>
References: <CAGou9MgezsS=2+SngGWBJv5Npsuqacx1VPJwvMuf0FS+XnXt8A@mail.gmail.com>
	<20120730030333.GE2877@dastard>
	<CAGou9MheeBWxajd65szNfDB2L+VVoZ7SypEdUKj7np3L0H8fHA@mail.gmail.com>
	<CAGou9MgMHbTPebFUDXdyLvrUr4T9wo-geNtaPUft9uUmOaju6Q@mail.gmail.com>
	<50186E51.1020107@hardwarefreak.com>
	<CAGou9MhneejOuhX4c8G06c3Zh7dxF-OtZ+=mT-7fho_u1Q3zWw@mail.gmail.com>
	<5018A8C7.8050406@hardwarefreak.com>
	<CAGou9Mj=8xcF4YwaSQYp0_BbJW_Ms1sasDDRNxL1oh0oR7zupw@mail.gmail.com>
	<5019CC34.5050003@hardwarefreak.com>
Date: Wed, 1 Aug 2012 19:38:41 -0700
Message-ID: <CAGou9Mg4teJU3VHWxDK3-y1MMxN_FQ-Dpk3E1KzX0pNdLEHNOQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2811515554304958924=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: xfs@oss.sgi.com

--===============2811515554304958924==
Content-Type: multipart/alternative; boundary=f46d0445181141a95204c63f4f54

--f46d0445181141a95204c63f4f54
Content-Type: text/plain; charset=UTF-8

On Wed, Aug 1, 2012 at 5:39 PM, Stan Hoeppner <stan@hardwarefreak.com>wrote:

> On 8/1/2012 12:55 AM, Jason Newton wrote:
>
> >> Just to figure out for sure what the bottlenecks are and whether they
> can
> > be dealt with rather than looking at it as opaque system and assuming
> > nothing can be done.  Also as a learning experience.
>
> Jason, have you considered something like this to solve your problems?
>
> RAM is cheap.  Far cheaper than attacking this problem with any other
> hardware type.  And you can't easily solve it by rewriting to use AIO,
> given the effort involved with that.
>
> You should be able to fit 32GB of RAM on the board.  Create a 24GB RAM
> disk and use that for writing your 5.7MB frame files in real time.  This
> eliminates any latency and stutter issues during capture.  Treat the RAM
> disk as a FIFO, taking each new file and copying it out to SSD after
> it's been closed, then delete the original.  This gives you in essence a
> very fast buffer.  If my math is correct, 24,000MB / 300MB/s = roughly
> 80 seconds of buffer at a 300MB/s streaming capture rate, 40 seconds at
> 600MB/s.
>

The system has a single slot of SODIMM. We have an 8GB DDR3 stick in it.
I've added a circular buffer for each frame and limit it to some number of
frames (so far 2 seconds, I haven't had time to experiment with it yet).
The serialization thread is now separate and consumes the circular buffer
so we're effectively talking about the same thing sans files.  This solves
the problem but as I mentioned before... I do have a desire to seek out the
sources of the latency and cpu usage... I'm not really sure of how to go
about it though.

>
> This should be very easy to implement, and cheaper than all other
> alternatives.  It should eliminate all possible latency issues, though
> it will increase CPU cycles due to the data movement to/from the RAM
> disk, though how much I can't guess at this point.  8GB RAM disk will
> give you 26 seconds of buffering at 300MB/s, and a 4GB RAM disk will
> give you 13 seconds of buffering.  If 13 seconds is sufficient, you can
> implement this on a machine with only 8GB RAM, assuming you need no more
> than 4GB for kernel/user space/application.
>
> Agreed that it's the easiest and cheapest solution. Average performance
probably won't change but burst of cpu will as it compensates for the high
latency writes in future cycles... this is undesirable but I think OK (the
important stuff is at high priority on SCHED_RR, these serialization
threads are high priority SCHED_OTHER).  Again, I haven't had time to test
it as I've been putting out other fires.

-Jason

--f46d0445181141a95204c63f4f54
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 1, 2012 at 5:39 PM, Stan Hoeppner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:stan@hardwarefreak.com" target=3D"_blank">stan@hardwarefreak.com=
</a>&gt;</span> wrote:<br><div class=3D"gmail_quote"><blockquote class=3D"g=
mail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-l=
eft:1ex">
<div class=3D"im">On 8/1/2012 12:55 AM, Jason Newton wrote:<br>
<br>
&gt;&gt; Just to figure out for sure what the bottlenecks are and whether t=
hey can<br>
&gt; be dealt with rather than looking at it as opaque system and assuming<=
br>
&gt; nothing can be done. =C2=A0Also as a learning experience.<br>
<br>
</div>Jason, have you considered something like this to solve your problems=
?<br>
<br>
RAM is cheap. =C2=A0Far cheaper than attacking this problem with any other<=
br>
hardware type. =C2=A0And you can&#39;t easily solve it by rewriting to use =
AIO,<br>
given the effort involved with that.<br>
<br>
You should be able to fit 32GB of RAM on the board. =C2=A0Create a 24GB RAM=
<br>
disk and use that for writing your 5.7MB frame files in real time. =C2=A0Th=
is<br>
eliminates any latency and stutter issues during capture. =C2=A0Treat the R=
AM<br>
disk as a FIFO, taking each new file and copying it out to SSD after<br>
it&#39;s been closed, then delete the original. =C2=A0This gives you in ess=
ence a<br>
very fast buffer. =C2=A0If my math is correct, 24,000MB / 300MB/s =3D rough=
ly<br>
80 seconds of buffer at a 300MB/s streaming capture rate, 40 seconds at<br>
600MB/s.<br></blockquote><div>=C2=A0</div><div>The system has a single slot=
 of SODIMM. We have an 8GB DDR3 stick in it.=C2=A0 I&#39;ve added a circula=
r buffer for each frame and limit it to some number of frames (so far 2 sec=
onds, I haven&#39;t had time to experiment with it yet).=C2=A0 The serializ=
ation thread is now separate and consumes the circular buffer so we&#39;re =
effectively talking about the same thing sans files.=C2=A0 This solves the =
problem but as I mentioned before... I do have a desire to seek out the sou=
rces of the latency and cpu usage... I&#39;m not really sure of how to go a=
bout it though.<br>
</div><blockquote class=3D"gmail_quote" style=3D"margin:0pt 0pt 0pt 0.8ex;b=
order-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
This should be very easy to implement, and cheaper than all other<br>
alternatives. =C2=A0It should eliminate all possible latency issues, though=
<br>
it will increase CPU cycles due to the data movement to/from the RAM<br>
disk, though how much I can&#39;t guess at this point. =C2=A08GB RAM disk w=
ill<br>
give you 26 seconds of buffering at 300MB/s, and a 4GB RAM disk will<br>
give you 13 seconds of buffering. =C2=A0If 13 seconds is sufficient, you ca=
n<br>
implement this on a machine with only 8GB RAM, assuming you need no more<br=
>
than 4GB for kernel/user space/application.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br></font></span></blockquo=
te><div>Agreed that it&#39;s the easiest and cheapest solution. Average per=
formance probably won&#39;t change but burst of cpu will as it compensates =
for the high latency writes in future cycles... this is undesirable but I t=
hink OK (the important stuff is at high priority on SCHED_RR, these seriali=
zation threads are high priority SCHED_OTHER).=C2=A0 Again, I haven&#39;t h=
ad time to test it as I&#39;ve been putting out other fires.<br>
<br>-Jason<br></div></div>

--f46d0445181141a95204c63f4f54--


--===============2811515554304958924==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2811515554304958924==--
