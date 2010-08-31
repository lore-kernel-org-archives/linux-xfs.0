Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7VMnTZY087414 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:49:30 -0500
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F4135D76398
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:00:39 -0700 (PDT)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id lMBjVhvePDVoksL1
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 16:00:39 -0700 (PDT)
Received: by qwe5 with SMTP id 5so5873049qwe.26
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 15:50:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100831003050.GL705@dastard>
References: <AANLkTin-zf0chkk68pGfwDRt03QaKmNdsP3=goDEUS+p@mail.gmail.com>
	<4C7C26E8.9070308@sandeen.net>
	<AANLkTinXDQoo7ZU+w2V7N7zBrxdS=Tc71MNZ7M4R5A9w@mail.gmail.com>
	<20100831003050.GL705@dastard>
Date: Tue, 31 Aug 2010 17:50:06 -0500
Message-ID: <AANLkTi=CVi5F4qMtWAgxneA_NcJgGSogK-G1x4awtOSz@mail.gmail.com>
Subject: Re: What should to do with ASSERT failed
From: Mike Gao <ygao.linux@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1522413427280905975=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============1522413427280905975==
Content-Type: multipart/alternative; boundary=0015175caade08bb7b048f266726

--0015175caade08bb7b048f266726
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

What kind of logic there could be?

I notice that in old version, if page has no buffer in writepage, then xfs
will create a empty buffer and attach to page. This logic there at least
untill 2.6.33. But now xfs need this never happens (assert) when coming to
writepage.  But I guess, when use mmap, there is no buffer attach to page
because it operates on page directly on kernel. xfs should create buffer
before submit bio. There must be sth I don't know. Maybe sbd can help me
out.

Thanks very much,
Mike


On Mon, Aug 30, 2010 at 7:30 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, Aug 30, 2010 at 05:56:07PM -0500, Mike Gao wrote:
> > Thanks very much for help. The kernel is pretty old, 2.6.19 but the xfs
> is
> > pretty new.
> > the block size is 512 and use mmap for test with write and read compare=
.
> > (xfstest 074).
>
> Can you reproduce it on a more recent kernel? The buffer flags are
> modified by code outside XFS which could be significantly different in
> 2.6.19 comapred to 2.6.34/35, so it may not be a=EE=80=80problem with the
> XFS code as such....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--0015175caade08bb7b048f266726
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

What kind of logic there could be?<div><br></div><div>I notice that in old =
version, if page has no buffer in writepage, then xfs will create a empty b=
uffer and attach to page. This logic there at least untill 2.6.33. But now =
xfs need this never happens (assert) when coming to writepage. =C2=A0But I =
guess, when use mmap, there is no buffer attach to page because it operates=
 on page directly on kernel. xfs should create buffer before submit bio. Th=
ere must be sth I don&#39;t know.=C2=A0Maybe sbd can help me out.</div>
<div><br></div><div>Thanks very much,</div><div>Mike</div><div><br><br><div=
 class=3D"gmail_quote">On Mon, Aug 30, 2010 at 7:30 PM, Dave Chinner <span =
dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com<=
/a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;"><div class=3D"im">On Mon, Aug 30, 2010 at 0=
5:56:07PM -0500, Mike Gao wrote:<br>
</div><div class=3D"im">&gt; Thanks very much for help. The kernel is prett=
y old, 2.6.19 but the xfs is<br>
&gt; pretty new.<br>
&gt; the block size is 512 and use mmap for test with write and read compar=
e.<br>
&gt; (xfstest 074).<br>
<br>
</div><div><div></div><div class=3D"h5">Can you reproduce it on a more rece=
nt kernel? The buffer flags are<br>
modified by code outside XFS which could be significantly different in<br>
2.6.19 comapred to 2.6.34/35, so it may not be a=EE=80=80problem with the<b=
r>
XFS code as such....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br></div>

--0015175caade08bb7b048f266726--


--===============1522413427280905975==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1522413427280905975==--
