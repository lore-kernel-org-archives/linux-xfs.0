Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88CF57F72
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 03:06:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4D97C304062
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 01:06:28 -0700 (PDT)
Received: from mail-ig0-f180.google.com (mail-ig0-f180.google.com
	[209.85.213.180]) by cuda.sgi.com with ESMTP id
	g2rlBQKI8rAxbWxc (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 01:06:26 -0700 (PDT)
Received: by igfj19 with SMTP id j19so102496687igf.0
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 01:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150818220119.GL714@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-9-git-send-email-jtulak@redhat.com>
	<20150817193624.GA8444@infradead.org>
	<CACj3i73JFbDaOtggH2JQX6+5hQU3dJFBMObD3qq_BrfEkYA8mw@mail.gmail.com>
	<20150818082046.GK714@dastard>
	<CACj3i714tHuRxmNGve5-Gqn-1yMQaPntyj7ZJYWKw16gkw9bEw@mail.gmail.com>
	<20150818220119.GL714@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 19 Aug 2015 10:06:06 +0200
Message-ID: <CACj3i70yiW1qw9904mRwqEqwP_i7s8dys5tXKj+sGQjK9Wxk4Q@mail.gmail.com>
Subject: Re: [PATCH 08/11] xfsprogs: replace obsolete memalign with
	posix_memalign
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0107717321518438284=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

--===============0107717321518438284==
Content-Type: multipart/alternative; boundary=047d7bdca610d79518051da5828b

--047d7bdca610d79518051da5828b
Content-Type: text/plain; charset=UTF-8

On Wed, Aug 19, 2015 at 12:01 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Aug 18, 2015 at 10:33:49AM +0200, Jan Tulak wrote:
> > On Tue, Aug 18, 2015 at 10:20 AM, Dave Chinner <david@fromorbit.com>
> wrote:
> >
> > > On Tue, Aug 18, 2015 at 09:04:24AM +0200, Jan Tulak wrote:
> > > > I thought about it. However, with memalign from malloc marked
> obsolete
> > > > (and with posix_memalign having guaranteed alignment restrictions
> [1]), I
> > > > saw it better
> > > > to use the posix variant everywhere.
> > >
> > > Putting a sane wrapper around an nasty library function is just
> > > fine. The memalign wrapper makes sense from this perspective - even
> > > gcc can't tell if variables passed to posix_memalign are correctly
> > > initialised or not, whereas no such problems exist for memalign().
> > >
> > > > I could make a wrapper simulating the old memalign behaviour, but I
> don't
> > > > think it would make sense.
> > >
> > > I think it makes more sense than using posix_memalign() everywhere
> > > and then ignoring the return variable that tells you it failed...
> > >
> > > > I searched for this, but didn't find any reasonable answer:
> > > > How long can be things in standard libraries marked obsolete before
> > > > removing?
> > >
> > > With a wrapper, we don't care.
> > >
> > > > [1] man memalign:
> > > >        On many systems there are alignment restrictions, for
> example, on
> > > buf-
> > > >        fers  used  for  direct  block  device  I/O.  POSIX specifies
> the
> > > path-
> > > >        conf(path,_PC_REC_XFER_ALIGN) call that tells what alignment
> is
> > > needed.
> > > >        Now one can use posix_memalign() to satisfy this requirement.
> > > >
> > > >        posix_memalign()  verifies  that  alignment  matches  the
> > > requirements
> > > >        detailed above.  memalign() may not check that the  alignment
> > > argument
> > > >        is correct.
> > >
> > > Yes, you can get it wrong with memalign. But we don't, because we
> > > follow the rules for DIO buffer alignment and set it correctly.
> > > Being able to directly control the alignment of the memory buffer is
> > > a reason for using memalign() over posix_memalign(), not the other
> > > way around.
> > >
> >
> > So a wrapper used on all platforms is an acceptable solution? All right,
> > this explanation makes sense. I will change it that way. The only
> question
> > I have now is whether to use posix_memalign on every platform, or
> whether to
> > make it platform_memalign and use the old memalign inside for Linux.
>
> No need for a wrapper on platforms that support memalign. We can add
> a wrapper when and if memalign ever goes away (which, FWIW, will
> break lots of code). Indeed, we alreadyhave these platform dependent
> "wrappers":
>
> include/darwin.h:#define memalign(a,sz) valloc(sz)
> include/freebsd.h:#define memalign(a,sz)        valloc(sz)
>
> The question now is - do we even need to change anything?
>
>
> https://developer.apple.com/library/ios/documentation/System/Conceptual/ManPages_iPhoneOS/man3/valloc.3.html
>
> "The valloc() function allocates size bytes of memory and returns a
>  pointer to the allocated memory.  The allocated memory is
>  aligned on a page boundary"
>
> Which means it does pretty exactly the same thing as
> posix_memalign(), and so we don't need to change anything, right?
>
>
Mmm, I'm sure I had some issue with valloc - that was why I decided to
replace it.
But now, I can't remember what exactly it was and everything seems to work
the same
with or without it. :-/
So maybe the real cause of the issue was something else, fixed in another
patch,
making this one abundant...

OK, I'm moving it out of the patchset. And I'm thinking about some private
issue
tracker where I can make notes, reference commits and such. :D

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

--047d7bdca610d79518051da5828b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Wed, Aug 19, 2015 at 12:01 AM, Dave Chinner <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div><div>On Tue, A=
ug 18, 2015 at 10:33:49AM +0200, Jan Tulak wrote:<br>
&gt; On Tue, Aug 18, 2015 at 10:20 AM, Dave Chinner &lt;<a href=3D"mailto:d=
avid@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt; wrote:<br=
>
&gt;<br>
&gt; &gt; On Tue, Aug 18, 2015 at 09:04:24AM +0200, Jan Tulak wrote:<br>
&gt; &gt; &gt; I thought about it. However, with memalign from malloc marke=
d obsolete<br>
&gt; &gt; &gt; (and with posix_memalign having guaranteed alignment restric=
tions [1]), I<br>
&gt; &gt; &gt; saw it better<br>
&gt; &gt; &gt; to use the posix variant everywhere.<br>
&gt; &gt;<br>
&gt; &gt; Putting a sane wrapper around an nasty library function is just<b=
r>
&gt; &gt; fine. The memalign wrapper makes sense from this perspective - ev=
en<br>
&gt; &gt; gcc can&#39;t tell if variables passed to posix_memalign are corr=
ectly<br>
&gt; &gt; initialised or not, whereas no such problems exist for memalign()=
.<br>
&gt; &gt;<br>
&gt; &gt; &gt; I could make a wrapper simulating the old memalign behaviour=
, but I don&#39;t<br>
&gt; &gt; &gt; think it would make sense.<br>
&gt; &gt;<br>
&gt; &gt; I think it makes more sense than using posix_memalign() everywher=
e<br>
&gt; &gt; and then ignoring the return variable that tells you it failed...=
<br>
&gt; &gt;<br>
&gt; &gt; &gt; I searched for this, but didn&#39;t find any reasonable answ=
er:<br>
&gt; &gt; &gt; How long can be things in standard libraries marked obsolete=
 before<br>
&gt; &gt; &gt; removing?<br>
&gt; &gt;<br>
&gt; &gt; With a wrapper, we don&#39;t care.<br>
&gt; &gt;<br>
&gt; &gt; &gt; [1] man memalign:<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 On many systems there are alignme=
nt restrictions, for example, on<br>
&gt; &gt; buf-<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 fers=C2=A0 used=C2=A0 for=C2=A0 d=
irect=C2=A0 block=C2=A0 device=C2=A0 I/O.=C2=A0 POSIX specifies the<br>
&gt; &gt; path-<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf(path,_PC_REC_XFER_ALIGN) cal=
l that tells what alignment is<br>
&gt; &gt; needed.<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 Now one can use posix_memalign() =
to satisfy this requirement.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 posix_memalign()=C2=A0 verifies=
=C2=A0 that=C2=A0 alignment=C2=A0 matches=C2=A0 the<br>
&gt; &gt; requirements<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 detailed above.=C2=A0 memalign() =
may not check that the=C2=A0 alignment<br>
&gt; &gt; argument<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 is correct.<br>
&gt; &gt;<br>
&gt; &gt; Yes, you can get it wrong with memalign. But we don&#39;t, becaus=
e we<br>
&gt; &gt; follow the rules for DIO buffer alignment and set it correctly.<b=
r>
&gt; &gt; Being able to directly control the alignment of the memory buffer=
 is<br>
&gt; &gt; a reason for using memalign() over posix_memalign(), not the othe=
r<br>
&gt; &gt; way around.<br>
&gt; &gt;<br>
&gt;<br>
&gt; So a wrapper used on all platforms is an acceptable solution? All righ=
t,<br>
&gt; this explanation makes sense. I will change it that way. The only ques=
tion<br>
&gt; I have now is whether to use posix_memalign on every platform, or whet=
her to<br>
&gt; make it platform_memalign and use the old memalign inside for Linux.<b=
r>
<br>
</div></div>No need for a wrapper on platforms that support memalign. We ca=
n add<br>
a wrapper when and if memalign ever goes away (which, FWIW, will<br>
break lots of code). Indeed, we alreadyhave these platform dependent<br>
&quot;wrappers&quot;:<br>
<br>
include/darwin.h:#define memalign(a,sz) valloc(sz)<br>
include/freebsd.h:#define memalign(a,sz)=C2=A0 =C2=A0 =C2=A0 =C2=A0 valloc(=
sz)<br>
<br>
The question now is - do we even need to change anything?<br>
<br>
<a href=3D"https://developer.apple.com/library/ios/documentation/System/Con=
ceptual/ManPages_iPhoneOS/man3/valloc.3.html" rel=3D"noreferrer" target=3D"=
_blank">https://developer.apple.com/library/ios/documentation/System/Concep=
tual/ManPages_iPhoneOS/man3/valloc.3.html</a><br>
<br>
&quot;The valloc() function allocates size bytes of memory and returns a<br=
>
=C2=A0pointer to the allocated memory.=C2=A0 The allocated memory is<br>
=C2=A0aligned on a page boundary&quot;<br>
<br>
Which means it does pretty exactly the same thing as<br>
posix_memalign(), and so we don&#39;t need to change anything, right?<br>
<div><div><br></div></div></blockquote><div><br></div><div>Mmm, I&#39;m sur=
e I had some issue with valloc - that was why I decided to replace it.</div=
><div>But now, I can&#39;t remember what exactly it was and everything seem=
s to work the same</div><div>with or without it. :-/</div><div>So maybe the=
 real cause of the issue was something else, fixed in another patch,</div><=
div>making this one abundant...</div><div><br></div><div>OK, I&#39;m moving=
 it out of the patchset. And I&#39;m thinking about some private issue</div=
><div>tracker where I can make notes, reference commits and such. :D</div><=
/div><br clear=3D"all"><div>Cheers,</div><div>Jan</div><div><br></div>-- <b=
r><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@re=
dhat.com" target=3D"_blank">jtulak@redhat.com</a><br></div></div>
</div></div>

--047d7bdca610d79518051da5828b--


--===============0107717321518438284==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0107717321518438284==--
