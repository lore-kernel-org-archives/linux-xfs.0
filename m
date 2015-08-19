Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9D3C57F77
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 04:15:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 18F2BAC006
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 02:15:03 -0700 (PDT)
Received: from mail-ig0-f172.google.com (mail-ig0-f172.google.com
	[209.85.213.172]) by cuda.sgi.com with ESMTP id
	4hNyCoACzLVWQhGi (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 02:15:01 -0700 (PDT)
Received: by igui7 with SMTP id i7so1274843igu.0
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 02:15:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150819080940.GA13130@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-6-git-send-email-jtulak@redhat.com>
	<20150818214557.GC3902@dastard>
	<20150819080940.GA13130@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 19 Aug 2015 11:14:42 +0200
Message-ID: <CACj3i71T77Hov5PyAfgGGmh3Ga4Q8Rk67sZ7yxVWtOYYUaEQYQ@mail.gmail.com>
Subject: Re: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7164422631923986516=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============7164422631923986516==
Content-Type: multipart/alternative; boundary=089e01160a022bef73051da678e9

--089e01160a022bef73051da678e9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2015 at 10:09 AM, Christoph Hellwig <hch@infradead.org>
wrote:
>
> On Wed, Aug 19, 2015 at 07:45:57AM +1000, Dave Chinner wrote:
> > Hmmm, looks like I accidentally comitted an earlier version of this
> > patch yesterday. Jan, can you send delta patches to what I committed
> > to address more recent review comments? Sorry, my bad.

I guess my chaotic versioning can be blamed. :-)

> Can you revert it for now? I think most of these changes are incorrect

I agree, revert seems like a better idea. Especially if we want to split
things
like removing the XATTR_ dependency move into standalone commits.

> and should either be dropped for now by disabling fsx

I proposed dropping some tools earlier, but there was a valid point about
the possibility to break something when not even trying to compile it.
i.e. with the XATTR_ -> XFS_XATTR mentioned in the first reply to this patc=
h
(which I already moved to a separate patch), it is necessary to add

#include "xfs/xfs_arch.h"
#include "xfs/xfs_format.h"

into libhandle/handle.c. But
=E2=80=8B
I found
=E2=80=8B
this
=E2=80=8B
when I tried to compile it. If it was
in fsr and fsr wasn't compiling, I would most likely send a patch which
would
be thrown
=E2=80=8B
back
=E2=80=8B
on my head immediately. ;-)

So I think
=E2=80=8B =E2=80=8B
it is better to have "bad dummy stuff" than not compile it
at all
=E2=80=8B
.

> or will need
=E2=80=8B
a major rework.

Working on it. :-)

Cheers,
Jan

--
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e01160a022bef73051da678e9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Wed, Aug 19, 2015 at 10:09 AM, Christoph Hellwig &lt;<a=
 href=3D"mailto:hch@infradead.org">hch@infradead.org</a>&gt; wrote:<br>&gt;=
<br>&gt; On Wed, Aug 19, 2015 at 07:45:57AM +1000, Dave Chinner wrote:<br>&=
gt; &gt; Hmmm, looks like I accidentally comitted an earlier version of thi=
s<br>&gt; &gt; patch yesterday. Jan, can you send delta patches to what I c=
ommitted<br>&gt; &gt; to address more recent review comments? Sorry, my bad=
.<br><br>I guess my chaotic versioning can be blamed. :-)<br><br>&gt; Can y=
ou revert it for now? I think most of these changes are incorrect<br><br>I =
agree, revert seems like a better idea. Especially if we want to split thin=
gs<br>like removing the XATTR_ dependency move into standalone commits.<br>=
<br>&gt; and should either be dropped for now by disabling fsx <br><br>I pr=
oposed dropping some tools earlier, but there was a valid point about<br>th=
e possibility to break something when not even trying to compile it.<br>i.e=
. with the XATTR_ -&gt; XFS_XATTR mentioned in the first reply to this patc=
h<br>(which I already moved to a separate patch), it is necessary to add<br=
><br>#include &quot;xfs/xfs_arch.h&quot;<br>#include &quot;xfs/xfs_format.h=
&quot;<br><br>into libhandle/handle.c. But<div class=3D"gmail_default" styl=
e=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8B=C2=A0=
</div>I found<div class=3D"gmail_default" style=3D"font-family:arial,helvet=
ica,sans-serif;display:inline">=E2=80=8B=C2=A0</div>this<div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=
=E2=80=8B=C2=A0</div>when I tried to compile it. If it was<br>in fsr and fs=
r wasn&#39;t compiling, I would most likely send a patch which would<br>be =
thrown<div class=3D"gmail_default" style=3D"font-family:arial,helvetica,san=
s-serif;display:inline">=E2=80=8B=C2=A0</div>back<div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=80=
=8B=C2=A0</div>on my head immediately. ;-)<br><br>So I think<div class=3D"g=
mail_default" style=3D"font-family:arial,helvetica,sans-serif;display:inlin=
e">=E2=80=8B =E2=80=8B</div>it is better to have &quot;bad dummy stuff&quot=
; than not compile it<br>at all<div class=3D"gmail_default" style=3D"font-f=
amily:arial,helvetica,sans-serif;display:inline">=E2=80=8B</div>.<br><br>&g=
t; or will need<div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif;display:inline">=E2=80=8B=C2=A0</div>a major rework.<br><b=
r>Working on it. :-)<br><br>Cheers,<br>Jan<br><br>--<br>Jan Tulak<br><a hre=
f=3D"mailto:jtulak@redhat.com">jtulak@redhat.com</a> / <a href=3D"mailto:ja=
n@tulak.me">jan@tulak.me</a><div><div><div class=3D"gmail_extra">
</div></div></div></div>

--089e01160a022bef73051da678e9--


--===============7164422631923986516==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7164422631923986516==--
