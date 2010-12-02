Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB23cPjH250034 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 21:38:26 -0600
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 674DB1C8632C
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 19:40:09 -0800 (PST)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	H01HP3eCEGbY5XD7 for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 19:40:09 -0800 (PST)
Received: by qyk11 with SMTP id 11so3581544qyk.5
	for <xfs@oss.sgi.com>; Wed, 01 Dec 2010 19:40:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF661C7.2020103@sandeen.net>
References: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
	<4CF661C7.2020103@sandeen.net>
Date: Thu, 2 Dec 2010 09:10:08 +0530
Message-ID: <AANLkTimiST8VNVsV49mniKLBudSxFj+O883Mwwe7ucac@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4652462825307157332=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen-xfs@sandeen.net, xfs@oss.sgi.com

--===============4652462825307157332==
Content-Type: multipart/alternative; boundary=00163630f435a9c7700496652d68

--00163630f435a9c7700496652d68
Content-Type: text/plain; charset=ISO-8859-1

While the copy operation is in progress, simply unplug the usb device and
then replug.
The issue can be seen from XFS (2.6.31) onwards, I am trying to figure out
the changes between 2.6.30.9 and 2.6.31.
One thing I noticed is - there is difference in speed for 2 versions - in
case of 2.6.30.9 if I remove the USB within '5' seconds - I can see the file
being created at the destination and some data written, while in case of
2.6.31(onwards), it takes around 20 seconds to get some data to disk.
I am using MIPS at the moment with VIPT(fixes included)

Please let me know if this information is useful.

Thanks,
Amit Sahrawat
On Wed, Dec 1, 2010 at 8:25 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 12/1/10 1:14 AM, Amit Sahrawat wrote:
> > Dear Member,
> >
> > I am getting following corruption on XFS formatted disk during a simple
> copy operation:
> > sd 9:0:0:0: Attached scsi removable disk sdc
> > sd 9:0:0:0: Attached scsi generic sg2 type 0
> > XFS mounting filesystem sdc2
> > Starting XFS recovery on filesystem: sdc2 (logdev: internal)
> > XFS: xlog_recover_process_data: bad transaction
> > XFS: log mount/recovery failed: error 5
> > XFS: log mount failed
>
> hm, that's not a simple copy operation, that is a mount failing;
> your log appears to be corrupted.
>
> offhand I'm going to blame it on having a write cache enabled
> on your drive, and having barriers either off, or not working
> properly.
>
> -Eric
>
>

--00163630f435a9c7700496652d68
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>While the copy operation is in progress, simply unplug the usb device =
and then replug.</div>
<div>The issue can be seen from XFS (2.6.31) onwards, I am trying to figure=
 out the changes between 2.6.30.9 and 2.6.31.</div>
<div>One thing I noticed is - there is difference in speed for 2 versions -=
 in case of 2.6.30.9 if I remove the USB within &#39;5&#39; seconds - I can=
 see the file being created at the destination and some data written, while=
 in case of 2.6.31(onwards), it takes=A0around 20 seconds to get some data =
to disk.</div>

<div>I am using MIPS at the moment with VIPT(fixes included)</div>
<div><br>Please let me know if this information is useful.</div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat<br></div>
<div class=3D"gmail_quote">On Wed, Dec 1, 2010 at 8:25 PM, Eric Sandeen <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.n=
et</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On 12/1/10 1:14 AM, Amit Sahrawat wrote:<br>&gt; Dear Mem=
ber,<br>&gt;<br>&gt; I am getting following corruption on XFS formatted dis=
k during a simple copy operation:<br>&gt; sd 9:0:0:0: Attached scsi removab=
le disk sdc<br>
&gt; sd 9:0:0:0: Attached scsi generic sg2 type 0<br>&gt; XFS mounting file=
system sdc2<br>&gt; Starting XFS recovery on filesystem: sdc2 (logdev: inte=
rnal)<br>&gt; XFS: xlog_recover_process_data: bad transaction<br>&gt; XFS: =
log mount/recovery failed: error 5<br>
&gt; XFS: log mount failed<br><br></div>hm, that&#39;s not a simple copy op=
eration, that is a mount failing;<br>your log appears to be corrupted.<br><=
br>offhand I&#39;m going to blame it on having a write cache enabled<br>
on your drive, and having barriers either off, or not working<br>properly.<=
br><font color=3D"#888888"><br>-Eric<br><br></font></blockquote></div><br>

--00163630f435a9c7700496652d68--


--===============4652462825307157332==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4652462825307157332==--
