Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5R4F7JK031155 for <xfs@oss.sgi.com>; Sun, 26 Jun 2011 23:15:07 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1CF12FEF5
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2011 21:15:06 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	2qxtCelTFxdluqS6 for <xfs@oss.sgi.com>;
	Sun, 26 Jun 2011 21:15:06 -0700 (PDT)
Received: by eyh5 with SMTP id 5so1522047eyh.26
	for <xfs@oss.sgi.com>; Sun, 26 Jun 2011 21:15:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110625000924.GB32466@dastard>
References: <BANLkTinCLAb3X59J=SnXgEkeRCLgB6FAGg@mail.gmail.com>
	<20110625000924.GB32466@dastard>
Date: Mon, 27 Jun 2011 09:45:05 +0530
Message-ID: <BANLkTi=wAx7NXVKJBHaq_husC9xVrEFbDg@mail.gmail.com>
Subject: Re: Failure of test case : 250
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6423076697283637211=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============6423076697283637211==
Content-Type: multipart/alternative; boundary=0016364d1f8bca4c2604a6a9cbd0

--0016364d1f8bca4c2604a6a9cbd0
Content-Type: text/plain; charset=ISO-8859-1

Thanks, I will install TOT kernel and verify the behaviour on that.

Thanks & Regards,
Amit Sahrawat

On Sat, Jun 25, 2011 at 5:39 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Jun 24, 2011 at 11:49:45AM +0530, Amit Sahrawat wrote:
> > Dear All,
> >
> > Test Case : 250 results in failure on x86(2.6.31.y) and ARM(2.6.35.13..)
>
> The XFS_WANT_CORRUPTED_GOTO bug wasn't fixed until 3.0-rc1 (bf59170
> xfs: obey minleft values during extent allocation correctly), so of
> course you'll get that failure on .31 and .35 kernels.
>
> Amit, I'd suggest that you try to reproduce the problems you have on
> a top of tree kernel first before reporting them. Most of us XFS
> developers don't really have time to triage or solve failures on old
> kernels like 2.6.31 or 2.6.35 and so are ignoring your bug reports.
> Reporting bugs on old kernels that have since been fixed is really
> just a waste of our (limited) time. If you find a bug that isn't
> fixed on TOT, then we'll triage it and get it fixed in TOT.
>
> However, if you can't reproduce them on top of tree, then you need
> to go an find the commit (kernel, xfsprogs or xfstests) yourself
> that makes the test pass and back port it to your tree. Same for if
> we fix a bug you report in TOT - we're not going to backport the
> fixes to your trees for you. We'll review backported patches if you
> post them to the list, but we don't have time (or motivation) to do
> the backports and QA them for you.
>
> And if you are backporting to a long term stable tree, feel free to
> submit the tested backports to stable@kernel.org (cc'ing the xfs
> list so they can be reviewed, of course) so that everyone else can
> also benefit from your work....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0016364d1f8bca4c2604a6a9cbd0
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Thanks, I will install TOT kernel and verify the behaviour on that.</d=
iv><div>=A0</div><div>Thanks &amp; Regards,</div><div>Amit Sahrawat<br><br>=
</div><div class=3D"gmail_quote">On Sat, Jun 25, 2011 at 5:39 AM, Dave Chin=
ner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@from=
orbit.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"margin: 0px 0px 0px 0.8ex; padding-left: 1ex; border-l=
eft-color: rgb(204, 204, 204); border-left-width: 1px; border-left-style: s=
olid;" class=3D"gmail_quote"><div class=3D"im">On Fri, Jun 24, 2011 at 11:4=
9:45AM +0530, Amit Sahrawat wrote:<br>

&gt; Dear All,<br>
&gt;<br>
&gt; Test Case : 250 results in failure on x86(2.6.31.y) and ARM(2.6.35.13.=
.)<br>
<br>
</div>The XFS_WANT_CORRUPTED_GOTO bug wasn&#39;t fixed until 3.0-rc1 (bf591=
70<br>
xfs: obey minleft values during extent allocation correctly), so of<br>
course you&#39;ll get that failure on .31 and .35 kernels.<br>
<br>
Amit, I&#39;d suggest that you try to reproduce the problems you have on<br=
>
a top of tree kernel first before reporting them. Most of us XFS<br>
developers don&#39;t really have time to triage or solve failures on old<br=
>
kernels like 2.6.31 or 2.6.35 and so are ignoring your bug reports.<br>
Reporting bugs on old kernels that have since been fixed is really<br>
just a waste of our (limited) time. If you find a bug that isn&#39;t<br>
fixed on TOT, then we&#39;ll triage it and get it fixed in TOT.<br>
<br>
However, if you can&#39;t reproduce them on top of tree, then you need<br>
to go an find the commit (kernel, xfsprogs or xfstests) yourself<br>
that makes the test pass and back port it to your tree. Same for if<br>
we fix a bug you report in TOT - we&#39;re not going to backport the<br>
fixes to your trees for you. We&#39;ll review backported patches if you<br>
post them to the list, but we don&#39;t have time (or motivation) to do<br>
the backports and QA them for you.<br>
<br>
And if you are backporting to a long term stable tree, feel free to<br>
submit the tested backports to <a href=3D"mailto:stable@kernel.org">stable@=
kernel.org</a> (cc&#39;ing the xfs<br>
list so they can be reviewed, of course) so that everyone else can<br>
also benefit from your work....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></blockquote></div><br>

--0016364d1f8bca4c2604a6a9cbd0--


--===============6423076697283637211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6423076697283637211==--
