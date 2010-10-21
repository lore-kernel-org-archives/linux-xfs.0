Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9LDQ12u261314 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 08:26:02 -0500
Received: from mail-pv0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D52B6F411D2
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 06:42:21 -0700 (PDT)
Received: from mail-pv0-f181.google.com (mail-pv0-f181.google.com
	[74.125.83.181]) by cuda.sgi.com with ESMTP id nP6oWYKLtRBlOVrs
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 06:42:21 -0700 (PDT)
Received: by pvg2 with SMTP id 2so1376790pvg.26
	for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 06:27:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101021125219.GA21472@infradead.org>
References: <AANLkTi=wbBhb=s3z9vyw9gL9Qwy0goj+8UtueFyNq+y2@mail.gmail.com>
	<20101021125219.GA21472@infradead.org>
Date: Thu, 21 Oct 2010 18:57:15 +0530
Message-ID: <AANLkTimFuG6cVLkYt+7-Y_8PnapFvmry5RUcmpOHaPco@mail.gmail.com>
Subject: Re: XFS: bad clientid on recovery on MIPS (VIPT cache)
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0365439390917502313=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============0365439390917502313==
Content-Type: multipart/alternative; boundary=001636e90cdd015af00493207ce8

--001636e90cdd015af00493207ce8
Content-Type: text/plain; charset=ISO-8859-1

Thanks for response,

Linux kernel I am using is 2.6.30, where as XFS I have ported until 2.6.34
on given kernel.
Do you think I need the mentioned API
flush_kernel_vmap_range/invalidate_kernel_vmap_range in 2.6.30.9 as well.I
will be grateful if you can provide me sample code for the above API.



On Thu, Oct 21, 2010 at 6:22 PM, Christoph Hellwig <hch@infradead.org>wrote:

> On Thu, Oct 21, 2010 at 05:41:43PM +0530, Ajeet Yadav wrote:
> > Dear member,
> > If I remove USB flash storage from PC/ARM/MIPS target (i.e
> > without umount) while copying file to XFS partition and connect it to
> MIPS
> > target I always get
> > XFS: xlog_recover_process_data: bad clientid
> > XFS: log mount/recovery failed: error 5
> > XFS: log mount failed
> > This problem does not occur, if I connect the same USB flash to PC/ARM
> > target.
> > I have tested this on 2.6.30 - 2.6.34 (It everywhere when concerend with
> > MIPS)
>
> Since Linux 2.6.34 Linux uses the flush_kernel_vmap_range/
> invalidate_kernel_vmap_range APIs to make I/O to vmapped
> areas work on systems with virtually indexed caches.
>
> Unfortunately only arm, parisc and sh actually implement these so far.
> You'll need to implement an implementation of these APIs for your cache
> architecture to make XFS work on MIPS with virtually indexed caches.
>

--001636e90cdd015af00493207ce8
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Thanks for response, </div>
<div>=A0</div>
<div>Linux kernel I am using is 2.6.30, where as XFS I have ported until 2.=
6.34 on given kernel.</div>
<div>Do you think I need the mentioned=A0API flush_kernel_vmap_range/invali=
date_kernel_vmap_range in 2.6.30.9 as well.I will be grateful if you can pr=
ovide me sample code for the above API.=A0=A0</div>
<div><br><br>=A0</div>
<div class=3D"gmail_quote">On Thu, Oct 21, 2010 at 6:22 PM, Christoph Hellw=
ig <span dir=3D"ltr">&lt;<a href=3D"mailto:hch@infradead.org">hch@infradead=
.org</a>&gt;</span> wrote:<br>
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div class=3D"im">On Thu, Oct 21, 2010 at 05:41:43PM +0530, Ajeet Yadav wro=
te:<br>&gt; Dear member,<br>&gt; If I remove USB flash storage from PC/ARM/=
MIPS target (i.e<br>&gt; without umount) while copying file to XFS partitio=
n and connect it to MIPS<br>
&gt; target I always get<br>&gt; XFS: xlog_recover_process_data: bad client=
id<br>&gt; XFS: log mount/recovery failed: error 5<br>&gt; XFS: log mount f=
ailed<br>&gt; This problem does not occur, if I connect the same USB flash =
to PC/ARM<br>
&gt; target.<br>&gt; I have tested this on 2.6.30 - 2.6.34 (It everywhere w=
hen concerend with<br>&gt; MIPS)<br><br></div>Since Linux 2.6.34 Linux uses=
 the flush_kernel_vmap_range/<br>invalidate_kernel_vmap_range APIs to make =
I/O to vmapped<br>
areas work on systems with virtually indexed caches.<br><br>Unfortunately o=
nly arm, parisc and sh actually implement these so far.<br>You&#39;ll need =
to implement an implementation of these APIs for your cache<br>architecture=
 to make XFS work on MIPS with virtually indexed caches.<br>
</blockquote></div><br>

--001636e90cdd015af00493207ce8--


--===============0365439390917502313==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0365439390917502313==--
