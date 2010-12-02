Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB2CLrrG016765 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 06:21:53 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C8D811BC14D
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 04:23:35 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id h3IOyiltgDKwAChJ
	for <xfs@oss.sgi.com>; Thu, 02 Dec 2010 04:23:35 -0800 (PST)
Received: by qwe5 with SMTP id 5so8157860qwe.26
	for <xfs@oss.sgi.com>; Thu, 02 Dec 2010 04:23:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimO0+qJ7SLh720nFh9Sw+4hdshuipRXxDSSORmp@mail.gmail.com>
References: <AANLkTikzCpQ1j9uWGSTY9TEguVDvAB5AVYtbDtdePFci@mail.gmail.com>
	<4CF661C7.2020103@sandeen.net>
	<AANLkTimiST8VNVsV49mniKLBudSxFj+O883Mwwe7ucac@mail.gmail.com>
	<20101202041312.GX16922@dastard>
	<AANLkTimO0+qJ7SLh720nFh9Sw+4hdshuipRXxDSSORmp@mail.gmail.com>
Date: Thu, 2 Dec 2010 17:53:34 +0530
Message-ID: <AANLkTi=oCRo7U_A7UwJ8hfg9kZN4aRuiYStVvv008Rbe@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============4621423683363234815=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen-xfs@sandeen.net, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

--===============4621423683363234815==
Content-Type: multipart/alternative; boundary=0015175cddbe918a5304966c7de2

--0015175cddbe918a5304966c7de2
Content-Type: text/plain; charset=ISO-8859-1

By tracing back to find the cause of the issue:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=commitdiff;h=f95022161d23ee661a48af8f280472209f513a67
This patch results in generating different behaviour for write. - it makes
dependency on xfssyncd(for which default time out value is 3000centisecs -
cat /proc/sys/fs/xfs/xfssyncd_centisecs) - 30secs is too large for
committing to disc.
So, either this value can be lowered or this patch can be reverted so that
pdflush takes care of all this.
Removing the changes from this patch seems viable solution at this moment.

What do you suggest?

Thanks,
Amit Sahrawat



On Thu, Dec 2, 2010 at 10:08 AM, Amit Sahrawat <amit.sahrawat83@gmail.com>wrote:

> I am not able to reproduce the same behaviour on 2.6.30.9, had it been on
> all versions - this can safely be termed as behaviour. But from 2.6.31
> onwards this is very much reproducable, especially the change in behaviour
> of writing to disk.
> I will try more things and update if I can find anything new in this.
>
> Thanks,
> Amit Sahrawat
>
>   On Thu, Dec 2, 2010 at 9:43 AM, Dave Chinner <david@fromorbit.com>wrote:
>
>> On Thu, Dec 02, 2010 at 09:10:08AM +0530, Amit Sahrawat wrote:
>> > While the copy operation is in progress, simply unplug the usb device
>> and
>> > then replug.
>>
>> That's pretty much a guaranteed recipe for data and filesystem
>> corruption regardless of the filesystem you are using. Even if you
>> are lucky enough that there was is no IO being issued while the
>> device is unplugged, what guarantee is there that the device even
>> comes back with the same device name? Further, if the device is usb
>> powered, there is no guarantee that the drive caches were
>> flushed correctly before the unplug so random log and metadata
>> corruptions are definitely possible.
>>
>> Cheers,
>>
>> Dave.
>> --
>> Dave Chinner
>> david@fromorbit.com
>>
>
>

--0015175cddbe918a5304966c7de2
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>By tracing back to find the cause of the issue:</div>
<div><a href=3D"http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.=
6.31.y.git;a=3Dcommitdiff;h=3Df95022161d23ee661a48af8f280472209f513a67">htt=
p://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.31.y.git;a=3Dcomm=
itdiff;h=3Df95022161d23ee661a48af8f280472209f513a67</a></div>

<div>This patch results in generating different behaviour for write. - it m=
akes dependency on xfssyncd(for which default time out value is 3000centise=
cs - cat /proc/sys/fs/xfs/xfssyncd_centisecs) - 30secs is too large for com=
mitting to disc.</div>

<div>So, either this value can be lowered or this patch can be reverted so =
that pdflush takes care of all this.</div>
<div>Removing the changes from this patch seems viable solution at this mom=
ent.</div>
<div>=A0</div>
<div>What do you suggest?</div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat</div>
<div><br><br>=A0</div>
<div class=3D"gmail_quote">On Thu, Dec 2, 2010 at 10:08 AM, Amit Sahrawat <=
span dir=3D"ltr">&lt;<a href=3D"mailto:amit.sahrawat83@gmail.com">amit.sahr=
awat83@gmail.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>I am not able to reproduce the same behaviour on 2.6.30.9, had it been=
 on all versions - this can safely be termed as behaviour. But from 2.6.31 =
onwards this is very much reproducable, especially the change in behaviour =
of writing to disk.</div>

<div>I will try more things and update if I can find anything new in this.<=
/div>
<div>=A0</div>
<div>Thanks,</div>
<div>Amit Sahrawat<font color=3D"#888888"><br><br></font></div>
<div>
<div></div>
<div class=3D"h5">
<div class=3D"gmail_quote">On Thu, Dec 2, 2010 at 9:43 AM, Dave Chinner <sp=
an dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank"=
>david@fromorbit.com</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>On Thu, Dec 02, 2010 at 09:10:08AM +0530, Amit Sahrawat wrote:<br>&gt;=
 While the copy operation is in progress, simply unplug the usb device and<=
br>&gt; then replug.<br><br></div>That&#39;s pretty much a guaranteed recip=
e for data and filesystem<br>
corruption regardless of the filesystem you are using. Even if you<br>are l=
ucky enough that there was is no IO being issued while the<br>device is unp=
lugged, what guarantee is there that the device even<br>comes back with the=
 same device name? Further, if the device is usb<br>
powered, there is no guarantee that the drive caches were<br>flushed correc=
tly before the unplug so random log and metadata<br>corruptions are definit=
ely possible.<br>
<div>
<div></div>
<div><br>Cheers,<br><br>Dave.<br>--<br>Dave Chinner<br><a href=3D"mailto:da=
vid@fromorbit.com" target=3D"_blank">david@fromorbit.com</a><br></div></div=
></blockquote></div><br></div></div></blockquote></div><br>

--0015175cddbe918a5304966c7de2--


--===============4621423683363234815==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4621423683363234815==--
