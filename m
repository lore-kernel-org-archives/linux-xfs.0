Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D11B77F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 07:59:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BB9DD304039
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 05:59:43 -0700 (PDT)
Received: from mail-io0-f169.google.com (mail-io0-f169.google.com
	[209.85.223.169]) by cuda.sgi.com with ESMTP id
	AEYHvb6f58yPZz6Q (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 05:59:42 -0700 (PDT)
Received: by iodb91 with SMTP id b91so83228296iod.1
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 05:59:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <117593154.2602203.1438690346097.JavaMail.zimbra@redhat.com>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
	<1438612789-17486-9-git-send-email-jtulak@redhat.com>
	<20150804112103.GF18906@infradead.org>
	<117593154.2602203.1438690346097.JavaMail.zimbra@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 14 Aug 2015 14:59:22 +0200
Message-ID: <CACj3i71DniP0WTBdsa3+chm6odq6wyXV1A-Ce+YcxQnia2+sNg@mail.gmail.com>
Subject: Re: [PATCH v3 08/11] xfsprogs: Add fls check into autoconf
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5201632876411874182=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============5201632876411874182==
Content-Type: multipart/alternative; boundary=001a113ece1473a780051d450639

--001a113ece1473a780051d450639
Content-Type: text/plain; charset=UTF-8

On Tue, Aug 4, 2015 at 2:12 PM, Jan Tulak <jtulak@redhat.com> wrote:

>
>
> ----- Original Message -----
> > From: "Christoph Hellwig" <hch@infradead.org>
> > To: "Jan Tulak" <jtulak@redhat.com>
> > Cc: hch@infradead.org, xfs@oss.sgi.com
> > Sent: Tuesday, August 4, 2015 1:21:03 PM
> > Subject: Re: [PATCH v3 08/11] xfsprogs: Add fls check into autoconf
> >
> > Can't you just use something like:
> >
> > AC_CHECK_DECL([fls],
> >         [AC_DEFINE([HAVE_FLS_PROTOTYPE], [1],
> >        [Define to 1 if have fls prototype])],
> >        [],
> >        [#include <string.h>])
> >
>
> You mean to replace the entire autoconf part of the patch with this?
> I will try it. Autoconf is still a bit of a black magic for me, so I
> used the already existing checks. :-)
>

Hi Chris,
did you want the result to be this? (I didn't get any clarification of what
you mean, so I'm asking again. :-) )

#
# Check if we have a flc call (Mac OS X)
#
AC_DEFUN([AC_HAVE_FLS],
  [ AC_CHECK_DECL([fls],
       have_fls=yes,
       [],
       [#include <string.h>]
       )
    AC_SUBST(have_fls)
  ])

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com

--001a113ece1473a780051d450639
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On T=
ue, Aug 4, 2015 at 2:12 PM, Jan Tulak <span dir=3D"ltr">&lt;<a href=3D"mail=
to:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>&gt;</span> wr=
ote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border=
-left:1px #ccc solid;padding-left:1ex"><span><br>
<br>
----- Original Message -----<br>
&gt; From: &quot;Christoph Hellwig&quot; &lt;<a href=3D"mailto:hch@infradea=
d.org" target=3D"_blank">hch@infradead.org</a>&gt;<br>
&gt; To: &quot;Jan Tulak&quot; &lt;<a href=3D"mailto:jtulak@redhat.com" tar=
get=3D"_blank">jtulak@redhat.com</a>&gt;<br>
&gt; Cc: <a href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@infrade=
ad.org</a>, <a href=3D"mailto:xfs@oss.sgi.com" target=3D"_blank">xfs@oss.sg=
i.com</a><br>
&gt; Sent: Tuesday, August 4, 2015 1:21:03 PM<br>
&gt; Subject: Re: [PATCH v3 08/11] xfsprogs: Add fls check into autoconf<br=
>
&gt;<br>
&gt; Can&#39;t you just use something like:<br>
&gt;<br>
&gt; AC_CHECK_DECL([fls],<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[AC_DEFINE([HAVE_FLS_PROTOTYPE], [1],=
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 [Define to 1 if have fls prototype])],<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 [],<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 [#include &lt;string.h&gt;])<br>
&gt;<br>
<br>
</span>You mean to replace the entire autoconf part of the patch with this?=
<br>
I will try it. Autoconf is still a bit of a black magic for me, so I<br>
used the already existing checks. :-)<br></blockquote><div><br></div><div>H=
i Chris,</div><div>did you want the result to be this? (I didn&#39;t get an=
y clarification of what you mean, so I&#39;m asking again. :-) )</div><div>=
<br></div><div><div>#</div><div># Check if we have a flc call (Mac OS X)</d=
iv><div>#</div><div>AC_DEFUN([AC_HAVE_FLS],</div><div>=C2=A0 [ AC_CHECK_DEC=
L([fls],</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0have_fls=3Dyes,</div><div>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0[],</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0[#include =
&lt;string.h&gt;]</div><div>=C2=A0 =C2=A0 =C2=A0 =C2=A0)</div><div>=C2=A0 =
=C2=A0 AC_SUBST(have_fls)</div><div>=C2=A0 ])=C2=A0</div><div><br></div></d=
iv><div>Cheers,</div><div>Jan</div><div><br></div></div>-- <br><div><div di=
r=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" targ=
et=3D"_blank">jtulak@redhat.com</a><br></div></div>
</div></div>

--001a113ece1473a780051d450639--


--===============5201632876411874182==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5201632876411874182==--
