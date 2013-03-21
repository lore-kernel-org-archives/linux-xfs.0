Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67EE17F37
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 12:45:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A15D304032
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 10:45:29 -0700 (PDT)
Received: from mail-la0-f41.google.com (mail-la0-f41.google.com
	[209.85.215.41]) by cuda.sgi.com with ESMTP id gwTZCW4PHxDWQwbf
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Mar 2013 10:45:27 -0700 (PDT)
Received: by mail-la0-f41.google.com with SMTP id fo12so5710756lab.28
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 10:45:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130321010149.GF17758@dastard>
References: <CAEDdjHeo3Giv3Y8pLfYHSbJi07_dv7ywzinCSSkxUwBQe-1fsw@mail.gmail.com>
	<20130320004405.GC17758@dastard>
	<CAEDdjHc139n-FFrW34FLyfKsqFHBy0_LVcVT24aLyCpb4DC9dA@mail.gmail.com>
	<20130321010149.GF17758@dastard>
Date: Thu, 21 Mar 2013 17:45:25 +0000
Message-ID: <CAEDdjHcP_An=CXSo3sL0w373wFfb=Zr-T7C2fUMuDbmrm6DDHQ@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============6477041361539283620=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6477041361539283620==
Content-Type: multipart/alternative; boundary=bcaec554d232518e9504d872e792

--bcaec554d232518e9504d872e792
Content-Type: text/plain; charset=ISO-8859-1

On 21 March 2013 01:01, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Mar 20, 2013 at 06:01:35PM +0000, Pedro Ribeiro wrote:
> > Thanks for the answer Dave.
> >
> > Yes I would definitely say it's a ToI bug that perhaps has been dormant
> so
> > far. Unfortunately the ToI developer is very busy at the moment, so I
> will
> > have to debug and fix it myself.
> > This problem did not occur with 3.7 and the ToI code did not change.
> >
> > Do you have any idea where I can start looking for the XFS change in 3.8
> > that triggered this behaviour in ToI? Or maybe it was a VFS change?
>
> It's almost certainly an XFS change that triggered it, but it
> indicates (once again) that the hibernate code is simply not
> quiescing filesystems properly (i.e. by freezing them). The work
> that caused this problem is stopped by the filesystem when it
> is frozen, and started again when it is thawed...
>
> > PS: the email definitely bounced back, most likely because imageshack is
> > blocked on the sgi server:
> >
> > Technical details of permanent failure:
> > Google tried to deliver your message, but it was rejected by the server
> for
> > the recipient domain oss.sgi.com by cuda-allmx.sgi.com. [192.48.176.16].
> >
> > The error that the other server returned was:
> > 554 rejecting banned content
>
> IOWs, a stupid spam filter.
>
> I'll see if I can get this fixed.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

Actually I've nailed it down to a commit between 3.7.1 and 3.7.10. I'll do
some git bisection and come back with the results.

Regarding ToI and filesystem freezing, I guess I need to start delving into
the code to see if I can fix it - long but fun journey ahead I guess.

Regards,
Pedro

--bcaec554d232518e9504d872e792
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><br><div class=3D"gmail=
_quote">On 21 March 2013 01:01, Dave Chinner <span dir=3D"ltr">&lt;<a href=
=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&g=
t;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div class=3D"im">On Wed, Mar 20, 2013 at 06:01:35PM +0000=
, Pedro Ribeiro wrote:<br>

&gt; Thanks for the answer Dave.<br>
&gt;<br>
&gt; Yes I would definitely say it&#39;s a ToI bug that perhaps has been do=
rmant so<br>
&gt; far. Unfortunately the ToI developer is very busy at the moment, so I =
will<br>
&gt; have to debug and fix it myself.<br>
&gt; This problem did not occur with 3.7 and the ToI code did not change.<b=
r>
&gt;<br>
&gt; Do you have any idea where I can start looking for the XFS change in 3=
.8<br>
&gt; that triggered this behaviour in ToI? Or maybe it was a VFS change?<br=
>
<br>
</div>It&#39;s almost certainly an XFS change that triggered it, but it<br>
indicates (once again) that the hibernate code is simply not<br>
quiescing filesystems properly (i.e. by freezing them). The work<br>
that caused this problem is stopped by the filesystem when it<br>
is frozen, and started again when it is thawed...<br>
<div class=3D"im"><br>
&gt; PS: the email definitely bounced back, most likely because imageshack =
is<br>
&gt; blocked on the sgi server:<br>
&gt;<br>
&gt; Technical details of permanent failure:<br>
&gt; Google tried to deliver your message, but it was rejected by the serve=
r for<br>
&gt; the recipient domain <a href=3D"http://oss.sgi.com" target=3D"_blank">=
oss.sgi.com</a> by <a href=3D"http://cuda-allmx.sgi.com" target=3D"_blank">=
cuda-allmx.sgi.com</a>. [192.48.176.16].<br>
&gt;<br>
&gt; The error that the other server returned was:<br>
&gt; 554 rejecting banned content<br>
<br>
</div>IOWs, a stupid spam filter.<br>
<br>
I&#39;ll see if I can get this fixed.<br>
<div class=3D""><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a></div></div><=
/blockquote><div><br></div><div>Actually I&#39;ve nailed it down to a commi=
t between 3.7.1 and 3.7.10. I&#39;ll do some git bisection and come back wi=
th the results.</div>
<div><br></div><div>Regarding ToI and filesystem freezing, I guess I need t=
o start delving into the code to see if I can fix it - long but fun journey=
 ahead I guess.</div><div><br></div><div>Regards,</div><div>Pedro=A0</div>
</div><br></div></div>

--bcaec554d232518e9504d872e792--


--===============6477041361539283620==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6477041361539283620==--
