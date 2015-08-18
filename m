Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DEF847F50
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 02:04:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE84B8F8040
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 00:04:45 -0700 (PDT)
Received: from mail-io0-f172.google.com (mail-io0-f172.google.com
	[209.85.223.172]) by cuda.sgi.com with ESMTP id
	yWljujzqYxaws7ax (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2015 00:04:44 -0700 (PDT)
Received: by iodt126 with SMTP id t126so179351436iod.2
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2015 00:04:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150817193624.GA8444@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-9-git-send-email-jtulak@redhat.com>
	<20150817193624.GA8444@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 18 Aug 2015 09:04:24 +0200
Message-ID: <CACj3i73JFbDaOtggH2JQX6+5hQU3dJFBMObD3qq_BrfEkYA8mw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============7600131422372488231=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============7600131422372488231==
Content-Type: multipart/alternative; boundary=001a113ece145b33a7051d90883f

--001a113ece145b33a7051d90883f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2015 at 9:36 PM, Christoph Hellwig <hch@infradead.org>
wrote:

> On Mon, Aug 17, 2015 at 06:23:23PM +0200, Jan Tulak wrote:
> > Memalign from <malloc.h> was marked obsolete in favor of a posix
> > variant from <stdlib.h>. So replace all calls and remove <malloc.h>
> > includes. This also enhances support on other posix platforms,
> > which doesn't have <malloc.h>.
> >
> > Because posix_memalign returns any error as a return code, not in
> > errno, change relevant checks in code (and add a missing one).
>
> I have to say I hate the posix_memalign calling convention.  Any chance
> you could just provide a memalign impementation using posix_memalign for
> MacOS?
>

I thought about it. However, with memalign from malloc marked obsolete
(and with posix_memalign having guaranteed alignment restrictions [1]), I
saw it better
to use the posix variant everywhere.

I could make a wrapper simulating the old memalign behaviour, but I don't
think it would make sense.

I searched for this, but didn't find any reasonable answer:
How long can be things in standard libraries marked obsolete before
removing?

Cheers,
Jan

[1] man memalign:
       On many systems there are alignment restrictions, for example, on
 buf=E2=80=90
       fers  used  for  direct  block  device  I/O.  POSIX specifies the
path=E2=80=90
       conf(path,_PC_REC_XFER_ALIGN) call that tells what alignment is
needed.
       Now one can use posix_memalign() to satisfy this requirement.

       posix_memalign()  verifies  that  alignment  matches  the
 requirements
       detailed above.  memalign() may not check that the  alignment
 argument
       is correct.

--=20
Jan Tulak
jtulak@redhat.com

--001a113ece145b33a7051d90883f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Mon, Aug 17, 2015 at 9:36 PM, Christoph Hellwig <span dir=3D"ltr">&l=
t;<a href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@infradead.org<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On=
 Mon, Aug 17, 2015 at 06:23:23PM +0200, Jan Tulak wrote:<br>
&gt; Memalign from &lt;malloc.h&gt; was marked obsolete in favor of a posix=
<br>
&gt; variant from &lt;stdlib.h&gt;. So replace all calls and remove &lt;mal=
loc.h&gt;<br>
&gt; includes. This also enhances support on other posix platforms,<br>
&gt; which doesn&#39;t have &lt;malloc.h&gt;.<br>
&gt;<br>
&gt; Because posix_memalign returns any error as a return code, not in<br>
&gt; errno, change relevant checks in code (and add a missing one).<br>
<br>
</span>I have to say I hate the posix_memalign calling convention.=C2=A0 An=
y chance<br>
you could just provide a memalign impementation using posix_memalign for<br=
>
MacOS?<br></blockquote><div><br></div><div>I thought about it. However, wit=
h memalign from malloc marked obsolete</div><div>(and with posix_memalign h=
aving guaranteed alignment restrictions [1]), I saw it better</div><div>to =
use the posix variant everywhere.</div><div><br></div><div>I could make a w=
rapper simulating the old memalign behaviour, but I don&#39;t</div><div>thi=
nk it would make sense.</div><div><br></div><div>I searched for this, but d=
idn&#39;t find any reasonable answer:</div><div>How long can be things in s=
tandard libraries marked obsolete before removing?</div><div><br></div><div=
>Cheers,</div><div>Jan</div><div><br></div><div>[1] man memalign:</div><div=
><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0On many systems there are alignment restri=
ctions, for example, on =C2=A0buf=E2=80=90</div><div>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0fers =C2=A0used =C2=A0for =C2=A0direct =C2=A0block =C2=A0device =C2=
=A0I/O.=C2=A0 POSIX specifies the path=E2=80=90</div><div>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0conf(path,_PC_REC_XFER_ALIGN) call that tells what alignment is n=
eeded.</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0Now one can use posix_memalign(=
) to satisfy this requirement.</div></div><div><br></div><div><div>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0posix_memalign() =C2=A0verifies =C2=A0that =C2=A0alignm=
ent =C2=A0matches =C2=A0the =C2=A0requirements</div><div>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0detailed above. =C2=A0memalign() may not check that the =C2=A0ali=
gnment =C2=A0argument</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0is correct.</div=
></div></div><div><br></div>-- <br><div class=3D"gmail_signature"><div dir=
=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" targe=
t=3D"_blank">jtulak@redhat.com</a><br></div></div>
</div></div>

--001a113ece145b33a7051d90883f--


--===============7600131422372488231==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7600131422372488231==--
