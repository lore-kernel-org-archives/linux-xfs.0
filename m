Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB24b6Ds254156 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 22:37:07 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BF711B726B
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 20:38:50 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	ZRaJN3asFSpqn6Ac for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 20:38:50 -0800 (PST)
Received: by qyk12 with SMTP id 12so8761266qyk.5
	for <xfs@oss.sgi.com>; Wed, 01 Dec 2010 20:38:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101202041312.GX16922@dastard>
References: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
	<4CF661C7.2020103@sandeen.net>
	<AANLkTimiST8VNVsV49mniKLBudSxFj+O883Mwwe7ucac@mail.gmail.com>
	<20101202041312.GX16922@dastard>
Date: Thu, 2 Dec 2010 10:08:49 +0530
Message-ID: <AANLkTimO0+qJ7SLh720nFh9Sw+4hdshuipRXxDSSORmp@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============0807093056903392619=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen-xfs@sandeen.net, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============0807093056903392619==
Content-Type: multipart/alternative; boundary=0015175caa80889cee049665ffdf

--0015175caa80889cee049665ffdf
Content-Type: text/plain; charset=ISO-8859-1

I am not able to reproduce the same behaviour on 2.6.30.9, had it been on
all versions - this can safely be termed as behaviour. But from 2.6.31
onwards this is very much reproducable, especially the change in behaviour
of writing to disk.
I will try more things and update if I can find anything new in this.

Thanks,
Amit Sahrawat

On Thu, Dec 2, 2010 at 9:43 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Dec 02, 2010 at 09:10:08AM +0530, Amit Sahrawat wrote:
> > While the copy operation is in progress, simply unplug the usb device and
> > then replug.
>
> That's pretty much a guaranteed recipe for data and filesystem
> corruption regardless of the filesystem you are using. Even if you
> are lucky enough that there was is no IO being issued while the
> device is unplugged, what guarantee is there that the device even
> comes back with the same device name? Further, if the device is usb
> powered, there is no guarantee that the drive caches were
> flushed correctly before the unplug so random log and metadata
> corruptions are definitely possible.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0015175caa80889cee049665ffdf
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>I am not able to reproduce the same behaviour on 2.6.30.9, had it been=
 on all versions - this can safely be termed as behaviour. But from 2.6.31 =
onwards this is very much reproducable, especially the change in behaviour =
of writing to disk.</div>

<div>I will try more things and update if I can find anything new in this.<=
/div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat<br><br></div>
<div class=3D"gmail_quote">On Thu, Dec 2, 2010 at 9:43 AM, Dave Chinner <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.c=
om</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, Dec 02, 2010 at 09:10:08AM +0530, Amit Sahrawat w=
rote:<br>&gt; While the copy operation is in progress, simply unplug the us=
b device and<br>&gt; then replug.<br><br></div>That&#39;s pretty much a gua=
ranteed recipe for data and filesystem<br>
corruption regardless of the filesystem you are using. Even if you<br>are l=
ucky enough that there was is no IO being issued while the<br>device is unp=
lugged, what guarantee is there that the device even<br>comes back with the=
 same device name? Further, if the device is usb<br>
powered, there is no guarantee that the drive caches were<br>flushed correc=
tly before the unplug so random log and metadata<br>corruptions are definit=
ely possible.<br>
<div>
<div></div>
<div class=3D"h5"><br>Cheers,<br><br>Dave.<br>--<br>Dave Chinner<br><a href=
=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br></div></div></bl=
ockquote></div><br>

--0015175caa80889cee049665ffdf--


--===============0807093056903392619==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0807093056903392619==--
