Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A40EB7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 06:00:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 61DF28F8033
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 04:00:25 -0700 (PDT)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com
	[209.85.220.178]) by cuda.sgi.com with ESMTP id
	LWhgK496emAMYaSF (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 31 May 2016 04:00:23 -0700 (PDT)
Received: by mail-qk0-f178.google.com with SMTP id c140so7155898qke.2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 04:00:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160531031010.GB12670@dastard>
References: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
	<20160530050452.GM26977@dastard>
	<9BD371B3-8A44-481C-B9E4-381BAE0B6B79@gmail.com>
	<CAGbZs7i66XWt3PF1_-L-WeBtdH80nfAOv+-Ary+ORKHxFGOLFg@mail.gmail.com>
	<20160531031010.GB12670@dastard>
Date: Tue, 31 May 2016 19:00:22 +0800
Message-ID: <CAGbZs7g9nfDFXKkhW-pgiVu1quRQDwMYxeAtLoky+xFcfx7WmQ@mail.gmail.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc
From: =?UTF-8?B?6ZmI5a6X5b+X?= <baotiao@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0737719996636041463=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============0737719996636041463==
Content-Type: multipart/alternative; boundary=94eb2c1249c686895a05342147cc

--94eb2c1249c686895a05342147cc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

can we change the existing file's extent size?


On Tue, May 31, 2016 at 11:10 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, May 31, 2016 at 10:43:36AM +0800, =E9=99=88=E5=AE=97=E5=BF=97 wro=
te:
> > I have fint the way to change the extent size hint
> > mkfs.xfs -r extsize=3D40960 /dev/sda1
>
> Ah, no, that isn't the extsize I'm refering to. That's for realtime
> device configuration at mkfs, not a per-inode extent size hint.
>
> When you create the image file do this:
>
> $ xfs_io -f -c "extsize 1m" /path/to/new/vm_image
> $ qemu-image create -f qcow2 /path/to/new/vm_image 10g
> $ xfs_io -c extsize /path/to/new/vm_image
> [1048576] /path/to/new/vm_image
> $
>
> And now the qcow2 image file will have extents allocated in
> multiples of 1MB.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



--=20
---
Blog: http://www.chenzongzhi.info
Twitter: https://twitter.com/baotiao <https://twitter.com/#%21/baotiao>
Git: https://github.com/baotiao

--94eb2c1249c686895a05342147cc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">can we change the existing file&#39;s extent size?<br><br>=
</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, May=
 31, 2016 at 11:10 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto=
:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> =
wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bord=
er-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Tue, May 31, 2=
016 at 10:43:36AM +0800, =E9=99=88=E5=AE=97=E5=BF=97 wrote:<br>
&gt; I have fint the way to change the extent size hint<br>
&gt; mkfs.xfs -r extsize=3D40960 /dev/sda1<br>
<br>
</span>Ah, no, that isn&#39;t the extsize I&#39;m refering to. That&#39;s f=
or realtime<br>
device configuration at mkfs, not a per-inode extent size hint.<br>
<br>
When you create the image file do this:<br>
<br>
$ xfs_io -f -c &quot;extsize 1m&quot; /path/to/new/vm_image<br>
$ qemu-image create -f qcow2 /path/to/new/vm_image 10g<br>
$ xfs_io -c extsize /path/to/new/vm_image<br>
[1048576] /path/to/new/vm_image<br>
$<br>
<br>
And now the qcow2 image file will have extents allocated in<br>
multiples of 1MB.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div class=
=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><d=
iv>---<br>Blog: <a href=3D"http://www.chenzongzhi.info" target=3D"_blank">h=
ttp://www.chenzongzhi.info</a><br>Twitter: <a href=3D"https://twitter.com/#=
%21/baotiao" target=3D"_blank">https://twitter.com/baotiao</a><br>Git: <a h=
ref=3D"https://github.com/baotiao" target=3D"_blank">https://github.com/bao=
tiao</a><br></div></div></div>
</div>

--94eb2c1249c686895a05342147cc--


--===============0737719996636041463==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0737719996636041463==--
