Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EF2897F3F
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 12:01:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD6E58F8064
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:01:54 -0700 (PDT)
Received: from mail-vb0-f44.google.com (mail-vb0-f44.google.com
	[209.85.212.44]) by cuda.sgi.com with ESMTP id J3HC1JOKDaNiE35G
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:01:53 -0700 (PDT)
Received: by mail-vb0-f44.google.com with SMTP id p14so1312341vbm.31
	for <xfs@oss.sgi.com>; Thu, 17 Oct 2013 10:01:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131017040654.GQ4446@dastard>
References: <CAGa4099etDS8eBGCQ_Se2oQxObO8ZSqHpGeXzeUCpCz3S7XnBw@mail.gmail.com>
	<20131017040654.GQ4446@dastard>
Date: Thu, 17 Oct 2013 10:01:53 -0700
Message-ID: <CAGa409_dbHBK=MVuQf8Z2YSmgTTqBGkG07XvD4bPhn=pHF9Seg@mail.gmail.com>
Subject: Re: xfs_repair fatal error -- name create failed in lost+found,
	filesystem may be out of space
From: Viet Nguyen <vietnguyen@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8491776702681574144=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============8491776702681574144==
Content-Type: multipart/alternative; boundary=001a11c2c1ea49fb9b04e8f2c667

--001a11c2c1ea49fb9b04e8f2c667
Content-Type: text/plain; charset=ISO-8859-1

The corruption was detected after a power outage. The underlying system is
an LSI RAID 6, according to the controller, the RAID integrity checks out,
though I don't know if I could trust that. This is the second time this
server has suffered xfs corruption after a power outage. The strange thing
is that there hasn't been any writes made to the filesystem for weeks. The
server passed a memtest, and xfs_repair fails consistently at the same
point. So I'm not sure what's going on there.

Is there any other particular details I could provide?


On Wed, Oct 16, 2013 at 9:06 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Oct 16, 2013 at 08:57:20PM -0700, Viet Nguyen wrote:
> > Hi,
> > Me again. I've got get another corrupted drive and I'm getting a
> different
> > error for xfs_repair:
> >
> > fatal error -- name create failed in lost+found (117), filesystem may be
> > out of space
>
> Error 117 is telling you that the filesystem is corrupted. i.e.
> attempting to make a new name for a lost inode has resulted in
> detection of a new corruption or previously undetected or
> uncorrected corruption in the filesystem.
>
> Given the amount of damage your filesystem sustained, that's not
> totally unexpected, especially if you are running 3.2.0-alpha.
> Can you provide more details about the failure?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--001a11c2c1ea49fb9b04e8f2c667
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The corruption was detected after a power outage. The unde=
rlying system is an LSI RAID 6, according to the controller, the RAID integ=
rity checks out, though I don&#39;t know if I could trust that. This is the=
 second time this server has suffered xfs corruption after a power outage. =
The strange thing is that there hasn&#39;t been any writes made to the file=
system for weeks. The server passed a memtest, and xfs_repair fails consist=
ently at the same point. So I&#39;m not sure what&#39;s going on there.<div=
>
<br></div><div>Is there any other particular details I could provide?</div>=
</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Wed,=
 Oct 16, 2013 at 9:06 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mai=
lto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</spa=
n> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Wed, Oct 16, 2013 at 08=
:57:20PM -0700, Viet Nguyen wrote:<br>
&gt; Hi,<br>
&gt; Me again. I&#39;ve got get another corrupted drive and I&#39;m getting=
 a different<br>
&gt; error for xfs_repair:<br>
&gt;<br>
&gt; fatal error -- name create failed in lost+found (117), filesystem may =
be<br>
&gt; out of space<br>
<br>
</div>Error 117 is telling you that the filesystem is corrupted. i.e.<br>
attempting to make a new name for a lost inode has resulted in<br>
detection of a new corruption or previously undetected or<br>
uncorrected corruption in the filesystem.<br>
<br>
Given the amount of damage your filesystem sustained, that&#39;s not<br>
totally unexpected, especially if you are running 3.2.0-alpha.<br>
Can you provide more details about the failure?<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D"HOEnZb"><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div>

--001a11c2c1ea49fb9b04e8f2c667--


--===============8491776702681574144==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8491776702681574144==--
