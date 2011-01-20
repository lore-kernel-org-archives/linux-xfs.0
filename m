Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0K65Qeo034944 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 00:05:26 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 36F751EA38CE
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 22:07:44 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	hEwWAUlEcWWYqlMC for <xfs@oss.sgi.com>;
	Wed, 19 Jan 2011 22:07:44 -0800 (PST)
Received: by qyk12 with SMTP id 12so243275qyk.5
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 22:07:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110120051720.GR16267@dastard>
References: <AANLkTin22efc0cHSmM+2rNQpE2aJoobQCnMwbNUjw617@mail.gmail.com>
	<20110120051720.GR16267@dastard>
Date: Thu, 20 Jan 2011 11:37:44 +0530
Message-ID: <AANLkTik0KUQaRzLeBNR8M=u+ijO6gAZu601zyCp2zmDS@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2085226475682340734=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============2085226475682340734==
Content-Type: multipart/alternative; boundary=0015175cf83cbaee37049a40f381

--0015175cf83cbaee37049a40f381
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I will try to find out the cause for this.
Meanwhile, just a small request/suggestion - in the past this type of
testcases have helped us in finding many problems in XFS.
Can something like this be added to xfstests? This might help.

Thanks,
Amit Sahrawat
On Thu, Jan 20, 2011 at 10:47 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Jan 20, 2011 at 10:34:30AM +0530, Amit Sahrawat wrote:
> > Hi,
> >
> > I am facing issues in XFS for a simple test case.
> > *Target:* ARM
> > *Kernel version:* 2.6.35.9
> >
> > *Test case:*
> > mkfs.xfs -f /dev/sda2
> > mount -t xfs /dev/sda2 /mnt/usb/sda2
> > (Run script - trying to fragment the XFS formatted partition)
> > #!/bin/sh
> > index=0
> > while [ "$?" == 0 ]
> > do
> > index=$((index+1))
> > sync
> > cp /mnt/usb/sda1/setupfile /mnt/usb/sda2/setupfile.$index
> > done
> >
> > Partition Size on which files are being created - 1GB(I need to fragment
> > this first to run other cases)
> > Size of *'setupfile'*  - 16K
> >
> > There used be no such issues till *2.6.34*(last XFS version where we
> tried
> > to create setup). There is no reset involved this time, just simple
> running
> > the script caused this issue.
>
> You have a known good version, a known bad version and a
> reproducable test case. i.e. everything you need to run a git bisect
> and find the commit introduced the regression. Can you do this and
> tell us what that commit is?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0015175cf83cbaee37049a40f381
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi,</div>
<div>=A0</div>
<div>I will try to find out the cause for this.</div>
<div>Meanwhile, just a small request/suggestion - in the past this=A0type o=
f testcases have helped us in finding many problems in XFS. </div>
<div>Can something like this be added to xfstests? This might help. </div>
<div><br>Thanks,</div>
<div>Amit Sahrawat<br></div>
<div class=3D"gmail_quote">On Thu, Jan 20, 2011 at 10:47 AM, Dave Chinner <=
span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit=
.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, Jan 20, 2011 at 10:34:30AM +0530, Amit Sahrawat w=
rote:<br>&gt; Hi,<br>&gt;<br>&gt; I am facing issues in XFS for a simple te=
st case.<br>&gt; *Target:* ARM<br>&gt; *Kernel version:* 2.6.35.9<br>&gt;<b=
r>
&gt; *Test case:*<br>&gt; mkfs.xfs -f /dev/sda2<br>&gt; mount -t xfs /dev/s=
da2 /mnt/usb/sda2<br>&gt; (Run script - trying to fragment the XFS formatte=
d partition)<br>&gt; #!/bin/sh<br>&gt; index=3D0<br>&gt; while [ &quot;$?&q=
uot; =3D=3D 0 ]<br>
&gt; do<br>&gt; index=3D$((index+1))<br>&gt; sync<br>&gt; cp /mnt/usb/sda1/=
setupfile /mnt/usb/sda2/setupfile.$index<br>&gt; done<br>&gt;<br>&gt; Parti=
tion Size on which files are being created - 1GB(I need to fragment<br>&gt;=
 this first to run other cases)<br>
&gt; Size of *&#39;setupfile&#39;* =A0- 16K<br>&gt;<br>&gt; There used be n=
o such issues till *2.6.34*(last XFS version where we tried<br>&gt; to crea=
te setup). There is no reset involved this time, just simple running<br>&gt=
; the script caused this issue.<br>
<br></div>You have a known good version, a known bad version and a<br>repro=
ducable test case. i.e. everything you need to run a git bisect<br>and find=
 the commit introduced the regression. Can you do this and<br>tell us what =
that commit is?<br>
<br>Cheers,<br><br>Dave.<br><font color=3D"#888888">--<br>Dave Chinner<br><=
a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br></font></b=
lockquote></div><br>

--0015175cf83cbaee37049a40f381--


--===============2085226475682340734==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2085226475682340734==--
