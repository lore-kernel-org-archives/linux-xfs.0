Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KBVsPH075118 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 05:31:54 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7010E1EA3D8C
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 03:34:13 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	viSR54mf6O69U3vR for <xfs@oss.sgi.com>;
	Thu, 20 Jan 2011 03:34:13 -0800 (PST)
Received: by qyj19 with SMTP id 19so1873807qyj.5
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 03:34:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110120104958.GT16267@dastard>
References: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
	<20110120051720.GR16267@dastard>
	<AANLkTik0KUQaRzLeBNR8M=u+ijO6gAZu601zyCp2zmDS@mail.gmail.com>
	<AANLkTi=yvf0ww4_C+H8xz6-5UWHKYSV2amCC9p-0tXrr@mail.gmail.com>
	<20110120104958.GT16267@dastard>
Date: Thu, 20 Jan 2011 17:04:12 +0530
Message-ID: <AANLkTimHN_YQ+07M+kMMucm+PypZBoF6CLzkHHQwFJLJ@mail.gmail.com>
Subject: Re: XFS - issues with writes using sync
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0091704990943327302=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0091704990943327302==
Content-Type: multipart/alternative; boundary=0015175cf83c46a7ae049a4583c3

--0015175cf83c46a7ae049a4583c3
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jan 20, 2011 at 4:19 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jan 20, 2011 at 12:08:21PM +0530, Amit Sahrawat wrote:
> > Hi,
> > I tried with the same test case - just removed 'sync' command from the
> > script(please check script below) to check the behaviour.
> ....
> > I really doubt about the stability of 2.6.35.9, it is not passing our
> basic
> > tests. Checking few more things, before deciding about the patches which
> got
> > introduced between 2.6.34 ~ 2.6.35.9(around 102).
>
> 2.6.35 is perfectly fine on x86, so I suspect that it is something
> ARM specific. Most likely it is related to the VIVT platform support
> changes, but you really need to bisect so we know exactly waht
> change has broken such basic functionality on your platform.
>
> >> yes, this is quite possible - last time, we found an issue like this on
MIPS(related with flushing).


> Note that the bug may not even be in XFS, so you really need to do a
> full bisect, not just of the changes in xfs in that time...
>
>> if other activities are not assigned in the mean time :), I will verify
the exact reason for this issue. I do have working and issue causing setups
- so will check with both and update.

Thanks,
Amit Sahrawat

--0015175cf83c46a7ae049a4583c3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br>
<div class=3D"gmail_quote">On Thu, Jan 20, 2011 at 4:19 PM, Dave Chinner <s=
pan dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.=
com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, Jan 20, 2011 at 12:08:21PM +0530, Amit Sahrawat w=
rote:<br>&gt; Hi,<br></div>
<div class=3D"im">&gt; I tried with the same test case - just removed &#39;=
sync&#39; command from the<br>&gt; script(please check script below) to che=
ck the behaviour.<br></div>....<br>
<div class=3D"im">&gt; I really doubt about the stability of 2.6.35.9, it i=
s not passing our basic<br>&gt; tests. Checking few more things, before dec=
iding about the patches which got<br>&gt; introduced between 2.6.34 ~ 2.6.3=
5.9(around 102).<br>
<br></div>2.6.35 is perfectly fine on x86, so I suspect that it is somethin=
g<br>ARM specific. Most likely it is related to the VIVT platform support<b=
r>changes, but you really need to bisect so we know exactly waht<br>change =
has broken such basic functionality on your platform.<br>
<br></blockquote>
<div>&gt;&gt; yes, this is quite possible - last time, we found an issue li=
ke this on MIPS(related with flushing).</div>
<div>=A0</div>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">Note that the bug may not even b=
e in XFS, so you really need to do a<br>full bisect, not just of the change=
s in xfs in that time...<br>
</blockquote>
<div>&gt;&gt; if other activities are not assigned in the mean time :), I w=
ill verify the exact reason for this issue. I do have working and issue cau=
sing setups - so will check with both and update.</div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat</div></div>

--0015175cf83c46a7ae049a4583c3--


--===============0091704990943327302==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0091704990943327302==--
