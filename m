Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB23dw4Y250093 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 21:39:59 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 809E5160AE7B
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 19:41:41 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	iNVnWkD3UcJXTpfw for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 19:41:41 -0800 (PST)
Received: by qyk11 with SMTP id 11so3582780qyk.5
	for <xfs@oss.sgi.com>; Wed, 01 Dec 2010 19:41:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101202021609.GV16922@dastard>
References: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
	<20101202021609.GV16922@dastard>
Date: Thu, 2 Dec 2010 09:11:40 +0530
Message-ID: <AANLkTimbZABKjAxwhCE-kT8PYbkU+4UGMQLTGMuCQe3a@mail.gmail.com>
Subject: Re: XFS file system corruption(Return Bad Transaction) kernel - 2.6.34
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1435619550644711252=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen-xfs@sandeen.net, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============1435619550644711252==
Content-Type: multipart/alternative; boundary=00163630f43528de3504966533b4

--00163630f43528de3504966533b4
Content-Type: text/plain; charset=ISO-8859-1

"TEGRA" by mistake happended to be the name of directory where I maintained
logs :)
I am using MIPS with VIPT cache(fixes included - regarding bad client id).


Thanks,
Amit Sahrawat

On Thu, Dec 2, 2010 at 7:46 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Dec 01, 2010 at 12:44:58PM +0530, Amit Sahrawat wrote:
> > Dear Member,
> >
> > I am getting following corruption on XFS formatted disk during a simple
> copy
> > operation:
> > sd 9:0:0:0: Attached scsi removable disk sdc
> > sd 9:0:0:0: Attached scsi generic sg2 type 0
> > XFS mounting filesystem sdc2
> > Starting XFS recovery on filesystem: sdc2 (logdev: internal)
> > XFS: xlog_recover_process_data: bad transaction
> > XFS: log mount/recovery failed: error 5
> > XFS: log mount failed
> > [root@localhost TEGRA]#
>
> "TEGRA" - You're running on an ARM device? If so, what kernel are
> you running? i.e. does it have the VIVT cache aliasing fixes in it?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--00163630f43528de3504966533b4
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>&quot;TEGRA&quot; by mistake happended to be the name of directory whe=
re I maintained logs :)</div>
<div>I am using MIPS with VIPT cache(fixes included - regarding bad client =
id).</div>
<div>=A0</div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat<br><br></div>
<div class=3D"gmail_quote">On Thu, Dec 2, 2010 at 7:46 AM, Dave Chinner <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.c=
om</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Wed, Dec 01, 2010 at 12:44:58PM +0530, Amit Sahrawat w=
rote:<br>&gt; Dear Member,<br>&gt;<br>&gt; I am getting following corruptio=
n on XFS formatted disk during a simple copy<br>&gt; operation:<br>&gt; sd =
9:0:0:0: Attached scsi removable disk sdc<br>
&gt; sd 9:0:0:0: Attached scsi generic sg2 type 0<br>&gt; XFS mounting file=
system sdc2<br>&gt; Starting XFS recovery on filesystem: sdc2 (logdev: inte=
rnal)<br>&gt; XFS: xlog_recover_process_data: bad transaction<br>&gt; XFS: =
log mount/recovery failed: error 5<br>
&gt; XFS: log mount failed<br>&gt; [root@localhost TEGRA]#<br><br></div>&qu=
ot;TEGRA&quot; - You&#39;re running on an ARM device? If so, what kernel ar=
e<br>you running? i.e. does it have the VIVT cache aliasing fixes in it?<br=
>
<br>Cheers,<br><br>Dave.<br><font color=3D"#888888">--<br>Dave Chinner<br><=
a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br></font></b=
lockquote></div><br>

--00163630f43528de3504966533b4--


--===============1435619550644711252==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1435619550644711252==--
