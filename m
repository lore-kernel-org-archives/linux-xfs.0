Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E4C6E7F6C
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 21:19:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7B7D304059
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 19:19:19 -0700 (PDT)
Received: from mail-ve0-f179.google.com (mail-ve0-f179.google.com
	[209.85.128.179]) by cuda.sgi.com with ESMTP id
	TRioGASY1cPqeQ5A (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 19:19:18 -0700 (PDT)
Received: by mail-ve0-f179.google.com with SMTP id d10so2170677vea.10
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 19:19:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130727013024.GS13468@dastard>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
	<CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
	<20130726205018.GM3111@sgi.com>
	<CAA+BczSpn7Cu2rZWJ9Q2b1-Xh0365R9ykGxKHHymtRm2Q7xCuA@mail.gmail.com>
	<CAA+BczTt-ZN7DU8gpWAY0SdL0KWL2Z_y8qKvmxMn7b+T9frK4Q@mail.gmail.com>
	<20130727013024.GS13468@dastard>
Date: Sat, 27 Jul 2013 22:19:17 -0400
Message-ID: <CAA+BczTywXKd_76dAtT9DkSk=zKdoFOjHfXzF+bhrj_F54DnJQ@mail.gmail.com>
Subject: Re: understanding speculative preallocation
From: Jason Rosenberg <jbr@squareup.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2399631285166381695=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, stan@hardwarefreak.com, xfs@oss.sgi.com

--===============2399631285166381695==
Content-Type: multipart/alternative; boundary=20cf3079bd9ab969dd04e2890070

--20cf3079bd9ab969dd04e2890070
Content-Type: text/plain; charset=ISO-8859-1

Thanks Dave,

The automatic prealloc removal, if no new writes after 5 minutes, sounds
perfect for my use case.  But realistically, I'm not likely to get our org
to push/find an os update just for this purpose too easily.

So, in the meantime, the question remains, assuming I have the version I
have currently (dynamic preallocation, persists indefinitely until the file
is closed/app quits, etc.), will this idea work (e.g. close the file after
writing, then re-open read-only?).  Currently, the app does keep the files
open indefinitely long after writing has stopped, and this is of course
resulting in the preallocation persisting indefinitely.

Jason


On Fri, Jul 26, 2013 at 9:30 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Jul 26, 2013 at 05:11:55PM -0400, Jason Rosenberg wrote:
> > Is it safe to say that speculative preallocation will not be used if a
> file
> > is opened read-only?
> >
> > It turns out that the kafka server does indeed write lots of log files,
> and
> > rotate them after they reach a max size, but never closes the files until
> > the app exits, or until it deletes the files.  This is because it needs
> to
> > make them available for reading, etc.   So, an obvious change for kafka
> > might be to close each log file after rotating, and then re-open it
> > read-only for consumers of the data.  Does that sound like a solution
> that
> > would pro-actively release pre-allocated storage?
>
> No need - the mainline code that has a periodic background scan that
> stops buildup of unused prealocation. i.e. if the file is clean for
> 5 minutes, then the prealloc will be removed. Hence it doesn't
> matter what the application does with it - if it holds it open and
> doesn't write to the file, then the prealloc will get removed. More
> will be added the next time the file is written, but until then it
> won't use excessive space.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--20cf3079bd9ab969dd04e2890070
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Dave,<div><br></div><div>The automatic prealloc rem=
oval, if no new writes after 5 minutes, sounds perfect for my use case. =A0=
But realistically, I&#39;m not likely to get our org to push/find an os upd=
ate just for this purpose too easily.</div>
<div><br></div><div>So, in the meantime, the question remains, assuming I h=
ave the version I have currently (dynamic preallocation, persists indefinit=
ely until the file is closed/app quits, etc.), will this idea work (e.g. cl=
ose the file after writing, then re-open read-only?). =A0Currently, the app=
 does keep the files open indefinitely long after writing has stopped, and =
this is of course resulting in the preallocation persisting indefinitely.</=
div>
<div><br></div><div>Jason</div></div><div class=3D"gmail_extra"><br><br><di=
v class=3D"gmail_quote">On Fri, Jul 26, 2013 at 9:30 PM, Dave Chinner <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">d=
avid@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Fri, Jul 26, 2013 at 05=
:11:55PM -0400, Jason Rosenberg wrote:<br>
</div><div class=3D"im">&gt; Is it safe to say that speculative preallocati=
on will not be used if a file<br>
&gt; is opened read-only?<br>
&gt;<br>
&gt; It turns out that the kafka server does indeed write lots of log files=
, and<br>
&gt; rotate them after they reach a max size, but never closes the files un=
til<br>
&gt; the app exits, or until it deletes the files. =A0This is because it ne=
eds to<br>
&gt; make them available for reading, etc. =A0 So, an obvious change for ka=
fka<br>
&gt; might be to close each log file after rotating, and then re-open it<br=
>
&gt; read-only for consumers of the data. =A0Does that sound like a solutio=
n that<br>
&gt; would pro-actively release pre-allocated storage?<br>
<br>
</div>No need - the mainline code that has a periodic background scan that<=
br>
stops buildup of unused prealocation. i.e. if the file is clean for<br>
5 minutes, then the prealloc will be removed. Hence it doesn&#39;t<br>
matter what the application does with it - if it holds it open and<br>
doesn&#39;t write to the file, then the prealloc will get removed. More<br>
will be added the next time the file is written, but until then it<br>
won&#39;t use excessive space.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--20cf3079bd9ab969dd04e2890070--


--===============2399631285166381695==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2399631285166381695==--
