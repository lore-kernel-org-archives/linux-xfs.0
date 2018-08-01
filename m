Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f178.google.com ([209.85.208.178]:42720 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730832AbeHAUaq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 16:30:46 -0400
Received: by mail-lj1-f178.google.com with SMTP id f1-v6so17755007ljc.9
        for <linux-xfs@vger.kernel.org>; Wed, 01 Aug 2018 11:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCQCtSpiPiG1S0tq4j+D4DsGf0caTtQCHWyVJJxrT2P5MxPNQ@mail.gmail.com>
 <20180801042146.GI2234@dastard> <CAJCQCtTv4ppBr1jxJBg4hBWfxDO=J2jZVYj-ZvZTADcb7KHT3g@mail.gmail.com>
 <f052c332-e154-9aa7-7cdf-c1b92a7d994d@sandeen.net> <CAJCQCtT9UoXdpF0OhWtEN7x_tKCZksJYY_BLqe-x68c8ubq81A@mail.gmail.com>
 <87156058-fd41-8130-7206-7cdc9e1a85d9@sandeen.net> <20180801114951.a54jwkinr5rb5ori@odin.usersys.redhat.com>
In-Reply-To: <20180801114951.a54jwkinr5rb5ori@odin.usersys.redhat.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 1 Aug 2018 12:43:26 -0600
Message-ID: <CAJCQCtQAOiMcBg4pyy-vJnigMbPOM_U5ub33DzKNcrrv_LzuzA@mail.gmail.com>
Subject: Re: xfsprogs 4.17.0 error building xfs_repair
Content-Type: multipart/alternative; boundary="000000000000aa06830572641254"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, Chris Murphy <lists@colorremedies.com>, Dave Chinner <david@fromorbit.com>, xfs list <linux-xfs@vger.kernel.org>

--000000000000aa06830572641254
Content-Type: text/plain; charset="UTF-8"

On Wed, Aug 1, 2018, 5:49 AM Carlos Maiolino <cmaiolino@redhat.com> wrote:

> On Wed, Aug 01, 2018 at 12:09:15AM -0500, Eric Sandeen wrote:
> > On 8/1/18 12:06 AM, Chris Murphy wrote:
> >
> > > And then I found the xfsprogs.spec file for Fedora 29's xfsprogs which
> contains:
> > >
> > > %configure \
> > >      --enable-readline=yes \
> > >      --enable-blkid=yes \
> > >      --enable-lto=no
> > >
>
> Thing is, unless I'm looking at the wrong file, doc/INSTALL under
> xfsprogs, only
> require such options when building xfsprogs in MacOS, the Linux
> instructions are
> pretty straight forward"
>
> "
>    To build the package and install it manually, use the following steps:
>
>        # make
>        # su root
>        # make install
>        [and optionally, for the development libraries and headers]
>        # make install-dev
> "
>
> Why are you using such options if you are building it on Fedora?
>

User error strikes again?

I'd sooner expect IRIX instructions than macOS instructions.


Chris Murphy

--000000000000aa06830572641254
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Wed, Aug 1, 2018, 5:=
49 AM Carlos Maiolino &lt;<a href=3D"mailto:cmaiolino@redhat.com">cmaiolino=
@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Wed, =
Aug 01, 2018 at 12:09:15AM -0500, Eric Sandeen wrote:<br>
&gt; On 8/1/18 12:06 AM, Chris Murphy wrote:<br>
&gt; <br>
&gt; &gt; And then I found the xfsprogs.spec file for Fedora 29&#39;s xfspr=
ogs which contains:<br>
&gt; &gt; <br>
&gt; &gt; %configure \<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 --enable-readline=3Dyes \<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 --enable-blkid=3Dyes \<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 --enable-lto=3Dno<br>
&gt; &gt; <br>
<br>
Thing is, unless I&#39;m looking at the wrong file, doc/INSTALL under xfspr=
ogs, only<br>
require such options when building xfsprogs in MacOS, the Linux instruction=
s are<br>
pretty straight forward&quot;<br>
<br>
&quot;<br>
=C2=A0 =C2=A0To build the package and install it manually, use the followin=
g steps:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0# make<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0# su root<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0# make install<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0[and optionally, for the development libraries a=
nd headers]<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0# make install-dev<br>
&quot;<br>
<br>
Why are you using such options if you are building it on Fedora?<br></block=
quote></div><div><br></div><div>User error strikes again?</div><div><br></d=
iv><div>I&#39;d sooner expect IRIX instructions than macOS instructions.</d=
iv><div><br></div><div><br></div><div>Chris Murphy</div>

--000000000000aa06830572641254--
