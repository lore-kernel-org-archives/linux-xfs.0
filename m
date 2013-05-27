Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04D527F37
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 20:17:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CA5D48F8035
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 18:17:38 -0700 (PDT)
Received: from mail-qc0-f169.google.com (mail-qc0-f169.google.com
	[209.85.216.169]) by cuda.sgi.com with ESMTP id
	FmKq5bi2g9cZmgpZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 26 May 2013 18:17:34 -0700 (PDT)
Received: by mail-qc0-f169.google.com with SMTP id k15so3297256qcv.0
	for <xfs@oss.sgi.com>; Sun, 26 May 2013 18:17:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130526224805.GN24543@dastard>
References: <CAEH94LjnVn-uD6cfwOcChC4wq1PppcD8BN30F93SD=YjdTbbuw@mail.gmail.com>
	<20130526224449.GM24543@dastard> <20130526224805.GN24543@dastard>
Date: Mon, 27 May 2013 09:17:33 +0800
Message-ID: <CAEH94LgpLg=KjntHmuBw-3RQvkR4UD0YjTRvtFRdZUKdYk+2BA@mail.gmail.com>
Subject: Re: xfsprogs: is it one issue?
From: Zhi Yong Wu <zwu.kernel@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5935189399158505598=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfstests <xfs@oss.sgi.com>

--===============5935189399158505598==
Content-Type: multipart/alternative; boundary=0015175ce0bacdaef504dda8e994

--0015175ce0bacdaef504dda8e994
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

It has been solved based on your suggestion, thanks


On Mon, May 27, 2013 at 6:48 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Mon, May 27, 2013 at 08:44:49AM +1000, Dave Chinner wrote:
> > On Sun, May 26, 2013 at 12:29:11AM +0800, Zhi Yong Wu wrote:
> > > HI,
> > >
> > > Did anyone hit this issue?
> > >
> > > [root@f15 xfsprogs]# make
> > > Building include
> > > Building libxfs
> > >     [TEST]    CRC32
> > > In file included from ../include/libxfs.h:584:0,
> > >                  from crc32.c:36:
> > > ../include/xfs/xfs_ialloc.h:75:2: error: unknown type name =91umode_t=
=92
> > > gmake[2]: *** [crc32selftest] Error 1
> > > gmake[1]: *** [libxfs] Error 2
> > > make: *** [default] Error 2
> >
> > Install the latest kernel headers package for your distro.
>
> Actually, on debian it's part of a libc-dev package:
>
> $ grep -r umode /usr/include |head -1
> /usr/include/asm-generic/types.h:typedef unsigned short umode_t
> $ apt-file search /usr/include/asm-generic/types.h
> linux-libc-dev: /usr/include/asm-generic/types.h
> $
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>



--=20
Regards,

Zhi Yong Wu

--0015175ce0bacdaef504dda8e994
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">It has been solved based on your suggestion, thanks<br></d=
iv><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Mon, Ma=
y 27, 2013 at 6:48 AM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"mailto=
:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</span> =
wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><div class=3D"h5">On M=
on, May 27, 2013 at 08:44:49AM +1000, Dave Chinner wrote:<br>
&gt; On Sun, May 26, 2013 at 12:29:11AM +0800, Zhi Yong Wu wrote:<br>
&gt; &gt; HI,<br>
&gt; &gt;<br>
&gt; &gt; Did anyone hit this issue?<br>
&gt; &gt;<br>
&gt; &gt; [root@f15 xfsprogs]# make<br>
&gt; &gt; Building include<br>
&gt; &gt; Building libxfs<br>
&gt; &gt; =A0 =A0 [TEST] =A0 =A0CRC32<br>
&gt; &gt; In file included from ../include/libxfs.h:584:0,<br>
&gt; &gt; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0from crc32.c:36:<br>
&gt; &gt; ../include/xfs/xfs_ialloc.h:75:2: error: unknown type name =91umo=
de_t=92<br>
&gt; &gt; gmake[2]: *** [crc32selftest] Error 1<br>
&gt; &gt; gmake[1]: *** [libxfs] Error 2<br>
&gt; &gt; make: *** [default] Error 2<br>
&gt;<br>
&gt; Install the latest kernel headers package for your distro.<br>
<br>
</div></div>Actually, on debian it&#39;s part of a libc-dev package:<br>
<br>
$ grep -r umode /usr/include |head -1<br>
/usr/include/asm-generic/types.h:typedef unsigned short umode_t<br>
$ apt-file search /usr/include/asm-generic/types.h<br>
linux-libc-dev: /usr/include/asm-generic/types.h<br>
<div class=3D"HOEnZb"><div class=3D"h5">$<br>
<br>
Cheers,<br>
<br>
Dave.<br>
--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><br>-- <br><div>Regard=
s,</div><div>=A0</div><div>Zhi Yong Wu</div>
</div>

--0015175ce0bacdaef504dda8e994--


--===============5935189399158505598==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5935189399158505598==--
