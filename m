Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA9597CBF
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 13:01:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A8E17304048
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 11:01:39 -0700 (PDT)
Received: from mail-la0-f54.google.com (mail-la0-f54.google.com
	[209.85.215.54]) by cuda.sgi.com with ESMTP id CXKApQ6lxukF4aXi
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Mar 2013 11:01:37 -0700 (PDT)
Received: by mail-la0-f54.google.com with SMTP id gw10so3525898lab.27
	for <xfs@oss.sgi.com>; Wed, 20 Mar 2013 11:01:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130320004405.GC17758@dastard>
References: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
	<20130320004405.GC17758@dastard>
Date: Wed, 20 Mar 2013 18:01:35 +0000
Message-ID: <CAEDdjHc139n-FFrW34FLyfKsqFHBy0_LVcVT24aLyCpb4DC9dA@mail.gmail.com>
Subject: Re: Crash with 3.8.3 and TuxOnIce
From: Pedro Ribeiro <pedrib@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2967938632068532472=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2967938632068532472==
Content-Type: multipart/alternative; boundary=f46d040168b347539604d85f03ab

--f46d040168b347539604d85f03ab
Content-Type: text/plain; charset=ISO-8859-1

Thanks for the answer Dave.

Yes I would definitely say it's a ToI bug that perhaps has been dormant so
far. Unfortunately the ToI developer is very busy at the moment, so I will
have to debug and fix it myself.
This problem did not occur with 3.7 and the ToI code did not change.

Do you have any idea where I can start looking for the XFS change in 3.8
that triggered this behaviour in ToI? Or maybe it was a VFS change?

PS: the email definitely bounced back, most likely because imageshack is
blocked on the sgi server:

Technical details of permanent failure:
Google tried to deliver your message, but it was rejected by the server for
the recipient domain oss.sgi.com by cuda-allmx.sgi.com. [192.48.176.16].

The error that the other server returned was:
554 rejecting banned content

Regards,
Pedro

On 20 March 2013 00:44, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Mar 19, 2013 at 11:31:16PM +0000, Pedro Ribeiro wrote:
> > Hi,
> >
> > I'm using a TuxOnIce enabled kernel, and recently moved from 3.7.1 to
> > 3.8.3. The former used to work nicely, but now I get a hard crash when I
> > try to hibernate.
> > This is solely related to TuxOnIce as it does not happen in the default
> > hibernation.
> >
> > I know this is an unsupported out of tree patch, but can you please help
> me
> > debug it or point in the right direction?
> >
> > Unfortunately as this was a kernel crash all I have are crappy photos,
> but
> > they do show a readable stack trace:
> > img18[dot]imageshack[dot]us/img18/395/imag0228hp[dot]jpg
> > img13[dot]imageshack[dot]us/img13/4375/imag0231p[dot]jpg
> >
> > (I removed the HTTP part and the dots off the links else it would bounce
> > back from the list)
>
> The list doesn't bounce URLs. Please make then clicky in future.
>
> As it is, your kernel has oopsed in submit_bio() when writing a log
> buffer writing a dummy log record.
>
> The xfs_log_worker is trying to cover the log, and it seems like the
> IO subsystem below it is doing something wrong. Perhaps Tux-on-Ice
> is killing the IO subsystem without having first stopped all the
> async filesystem processing first?
>
> Looks like a Tux-on-ICE problem to me...
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--f46d040168b347539604d85f03ab
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra">Thanks for the answer Dave.<div=
><br></div><div>Yes I would definitely say it&#39;s a ToI bug that perhaps =
has been dormant so far. Unfortunately the ToI developer is very busy at th=
e moment, so I will have to debug and fix it myself.</div>
<div>This problem did not occur with 3.7 and the ToI code did not change.</=
div><div><br></div><div>Do you have any idea where I can start looking for =
the XFS change in 3.8 that triggered this behaviour in ToI? Or maybe it was=
 a VFS change?</div>
<div><br></div><div style>PS: the email definitely bounced back, most likel=
y because imageshack is blocked on the sgi server:</div><div style><br></di=
v><div style><span style=3D"font-family:arial,sans-serif;font-size:13px">Te=
chnical details of permanent failure:</span><br style=3D"font-family:arial,=
sans-serif;font-size:13px">
<span style=3D"font-family:arial,sans-serif;font-size:13px">Google tried to=
 deliver your message, but it was rejected by the server for the recipient =
domain=A0</span><a href=3D"http://oss.sgi.com/" target=3D"_blank" style=3D"=
font-family:arial,sans-serif;font-size:13px">oss.sgi.com</a><span style=3D"=
font-family:arial,sans-serif;font-size:13px">=A0by=A0</span><a href=3D"http=
://cuda-allmx.sgi.com/" target=3D"_blank" style=3D"font-family:arial,sans-s=
erif;font-size:13px">cuda-allmx.sgi.com</a><span style=3D"font-family:arial=
,sans-serif;font-size:13px">. [192.48.176.16].</span><br style=3D"font-fami=
ly:arial,sans-serif;font-size:13px">
<br style=3D"font-family:arial,sans-serif;font-size:13px"><span style=3D"fo=
nt-family:arial,sans-serif;font-size:13px">The error that the other server =
returned was:</span><br style=3D"font-family:arial,sans-serif;font-size:13p=
x">
<span style=3D"font-family:arial,sans-serif;font-size:13px">554 rejecting b=
anned content</span><br></div><div style><span style=3D"font-family:arial,s=
ans-serif;font-size:13px"><br></span></div><div style><span style=3D"font-f=
amily:arial,sans-serif;font-size:13px">Regards,</span></div>
<div style><span style=3D"font-family:arial,sans-serif;font-size:13px">Pedr=
o</span></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On =
20 March 2013 00:44, Dave Chinner=A0<span dir=3D"ltr">&lt;<a href=3D"mailto=
:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span>=
=A0wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div class=3D""><div class=3D"h5">On Tue, Mar 19, 2013 at =
11:31:16PM +0000, Pedro Ribeiro wrote:<br>
&gt; Hi,<br>&gt;<br>&gt; I&#39;m using a TuxOnIce enabled kernel, and recen=
tly moved from 3.7.1 to<br>&gt; 3.8.3. The former used to work nicely, but =
now I get a hard crash when I<br>&gt; try to hibernate.<br>&gt; This is sol=
ely related to TuxOnIce as it does not happen in the default<br>
&gt; hibernation.<br>&gt;<br>&gt; I know this is an unsupported out of tree=
 patch, but can you please help me<br>&gt; debug it or point in the right d=
irection?<br>&gt;<br>&gt; Unfortunately as this was a kernel crash all I ha=
ve are crappy photos, but<br>
&gt; they do show a readable stack trace:<br>&gt; img18[dot]imageshack[dot]=
us/img18/395/imag0228hp[dot]jpg<br>&gt; img13[dot]imageshack[dot]us/img13/4=
375/imag0231p[dot]jpg<br>&gt;<br>&gt; (I removed the HTTP part and the dots=
 off the links else it would bounce<br>
&gt; back from the list)<br><br></div></div>The list doesn&#39;t bounce URL=
s. Please make then clicky in future.<br><br>As it is, your kernel has oops=
ed in submit_bio() when writing a log<br>buffer writing a dummy log record.=
<br>
<br>The xfs_log_worker is trying to cover the log, and it seems like the<br=
>IO subsystem below it is doing something wrong. Perhaps Tux-on-Ice<br>is k=
illing the IO subsystem without having first stopped all the<br>async files=
ystem processing first?<br>
<br>Looks like a Tux-on-ICE problem to me...<br><br>Cheers,<br><br>Dave.<br=
><span class=3D""><font color=3D"#888888">--<br>Dave Chinner<br><a href=3D"=
mailto:david@fromorbit.com">david@fromorbit.com</a><br></font></span></bloc=
kquote>
<div><span class=3D""><br></span></div></div></div></div></div>

--f46d040168b347539604d85f03ab--


--===============2967938632068532472==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2967938632068532472==--
