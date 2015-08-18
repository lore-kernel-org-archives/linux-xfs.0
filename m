Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C99B57F50
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 03:34:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 638BEAC009
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 01:34:11 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com
	[209.85.223.174]) by cuda.sgi.com with ESMTP id
	OX5biR69DPJrhFfN (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 01:34:09 -0700 (PDT)
Received: by iods203 with SMTP id s203so180923972iod.0
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 01:34:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150818082046.GK714@dastard>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-9-git-send-email-jtulak@redhat.com>
	<20150817193624.GA8444@infradead.org>
	<CACj3i73JFbDaOtggH2JQX6+5hQU3dJFBMObD3qq_BrfEkYA8mw@mail.gmail.com>
	<20150818082046.GK714@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 18 Aug 2015 10:33:49 +0200
Message-ID: <CACj3i714tHuRxmNGve5-Gqn-1yMQaPntyj7ZJYWKw16gkw9bEw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============2131609883799172988=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

--===============2131609883799172988==
Content-Type: multipart/alternative; boundary=001a113ece14286376051d91c857

--001a113ece14286376051d91c857
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 18, 2015 at 10:20 AM, Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Aug 18, 2015 at 09:04:24AM +0200, Jan Tulak wrote:
> > I thought about it. However, with memalign from malloc marked obsolete
> > (and with posix_memalign having guaranteed alignment restrictions [1]), I
> > saw it better
> > to use the posix variant everywhere.
>
> Putting a sane wrapper around an nasty library function is just
> fine. The memalign wrapper makes sense from this perspective - even
> gcc can't tell if variables passed to posix_memalign are correctly
> initialised or not, whereas no such problems exist for memalign().
>
> > I could make a wrapper simulating the old memalign behaviour, but I don't
> > think it would make sense.
>
> I think it makes more sense than using posix_memalign() everywhere
> and then ignoring the return variable that tells you it failed...
>
> > I searched for this, but didn't find any reasonable answer:
> > How long can be things in standard libraries marked obsolete before
> > removing?
>
> With a wrapper, we don't care.
>
> > [1] man memalign:
> >        On many systems there are alignment restrictions, for example, on
> buf-
> >        fers  used  for  direct  block  device  I/O.  POSIX specifies the
> path-
> >        conf(path,_PC_REC_XFER_ALIGN) call that tells what alignment is
> needed.
> >        Now one can use posix_memalign() to satisfy this requirement.
> >
> >        posix_memalign()  verifies  that  alignment  matches  the
> requirements
> >        detailed above.  memalign() may not check that the  alignment
> argument
> >        is correct.
>
> Yes, you can get it wrong with memalign. But we don't, because we
> follow the rules for DIO buffer alignment and set it correctly.
> Being able to directly control the alignment of the memory buffer is
> a reason for using memalign() over posix_memalign(), not the other
> way around.
>

So a wrapper used on all platforms is an acceptable solution? All right,
this explanation makes sense. I will change it that way. The only question
I have now is whether to use posix_memalign on every platform, or whether to
make it platform_memalign and use the old memalign inside for Linux.

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

--001a113ece14286376051d91c857
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Tue, Aug 18, 2015 at 10:20 AM, Dave Chinner <span dir=3D"ltr">&lt;<a=
 href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On=
 Tue, Aug 18, 2015 at 09:04:24AM +0200, Jan Tulak wrote:<br>
&gt; I thought about it. However, with memalign from malloc marked obsolete=
<br>
&gt; (and with posix_memalign having guaranteed alignment restrictions [1])=
, I<br>
&gt; saw it better<br>
&gt; to use the posix variant everywhere.<br>
<br>
</span>Putting a sane wrapper around an nasty library function is just<br>
fine. The memalign wrapper makes sense from this perspective - even<br>
gcc can&#39;t tell if variables passed to posix_memalign are correctly<br>
initialised or not, whereas no such problems exist for memalign().<br>
<span class=3D""><br>
&gt; I could make a wrapper simulating the old memalign behaviour, but I do=
n&#39;t<br>
&gt; think it would make sense.<br>
<br>
</span>I think it makes more sense than using posix_memalign() everywhere<b=
r>
and then ignoring the return variable that tells you it failed...<br>
<span class=3D""><br>
&gt; I searched for this, but didn&#39;t find any reasonable answer:<br>
&gt; How long can be things in standard libraries marked obsolete before<br=
>
&gt; removing?<br>
<br>
</span>With a wrapper, we don&#39;t care.<br>
<br>
&gt; [1] man memalign:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 On many systems there are alignment restric=
tions, for example, on buf-<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 fers=C2=A0 used=C2=A0 for=C2=A0 direct=C2=
=A0 block=C2=A0 device=C2=A0 I/O.=C2=A0 POSIX specifies the path-<br>
<span class=3D"">&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 conf(path,_PC_REC_XFER_ALI=
GN) call that tells what alignment is needed.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 Now one can use posix_memalign() to satisfy=
 this requirement.<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 posix_memalign()=C2=A0 verifies=C2=A0 that=
=C2=A0 alignment=C2=A0 matches=C2=A0 the=C2=A0 requirements<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 detailed above.=C2=A0 memalign() may not ch=
eck that the=C2=A0 alignment argument<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 is correct.<br>
<br>
</span>Yes, you can get it wrong with memalign. But we don&#39;t, because w=
e<br>
follow the rules for DIO buffer alignment and set it correctly.<br>
Being able to directly control the alignment of the memory buffer is<br>
a reason for using memalign() over posix_memalign(), not the other<br>
way around.<br></blockquote><div><br></div><div>So a wrapper used on all pl=
atforms is an acceptable solution?=C2=A0<span style=3D"background-color:rgb=
a(200,200,200,0.0470588)">All right,=C2=A0</span></div><div><span style=3D"=
background-color:rgba(200,200,200,0.0470588)">this explanation makes sense.=
</span><span style=3D"background-color:rgba(200,200,200,0.0470588)">=C2=A0<=
/span>I will change it that way. The only question</div><div>I have now is =
whether to use posix_memalign on every platform, or whether to</div><div>ma=
ke it platform_memalign and use the old memalign inside=C2=A0<span style=3D=
"background-color:rgba(200,200,200,0.0470588)">for Linux</span>.</div><div>=
<br></div><div>Cheers,</div><div>Jan</div><div><br></div></div>-- <br><div =
class=3D"gmail_signature"><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=
=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a><br></=
div></div>
</div></div>

--001a113ece14286376051d91c857--


--===============2131609883799172988==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2131609883799172988==--
