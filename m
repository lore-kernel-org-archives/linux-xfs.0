Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5DA6D7F47
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 03:13:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA9EDAC029
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 01:13:39 -0700 (PDT)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	MOemAtdj0RguMHIq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 01:13:37 -0700 (PDT)
Received: by igbut12 with SMTP id ut12so44295033igb.0
	for <xfs@oss.sgi.com>; Tue, 01 Sep 2015 01:13:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150831185817.GD349@infradead.org>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-2-git-send-email-jtulak@redhat.com>
	<20150831185817.GD349@infradead.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 1 Sep 2015 10:13:17 +0200
Message-ID: <CACj3i71LQMFnToYaNe7r5j2MRk1chAieXLCY-OmDh5sQ7B+kfg@mail.gmail.com>
Subject: Re: [PATCH 02/11] xfsprogs: avoid dependency on linux
	XATTR_SIZE/LIST_MAX
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7445006532432295348=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============7445006532432295348==
Content-Type: multipart/alternative; boundary=047d7bdca47c7c0682051eab208d

--047d7bdca47c7c0682051eab208d
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 31, 2015 at 8:58 PM, Christoph Hellwig <hch@infradead.org>
wrote:

> > index b1c0c10..d532f44 100644
> > --- a/libhandle/handle.c
> > +++ b/libhandle/handle.c
> > @@ -21,6 +21,8 @@
> >  #include "xfs.h"
> >  #include "handle.h"
> >  #include "parent.h"
> > +#include "xfs/xfs_arch.h"
> > +#include "xfs/xfs_format.h"
>
> These headers should not be used in libhandle.  As mentioned last time I
> think libhandle should get it's own LIBHANDLE_XATTR_LIST_MAX define,
> separate frome the one for the on disk format.
>

=E2=80=8BWell, you wrote about adding it into xfs_format.h. I don't recall =
(and
can't find) anything else regarding XATTR_SIZE...

> Eww, looks like we depend on these Linux values in the on disk
> defintion.  I think we need to add new XFS_XATTR_SIZE_MAX and
> XFS_XATTR_LIST_MAX defintions to xfs_format.h and use them where
> we currently use these.

So =E2=80=8B

=E2=80=8Bthe XFS_ defines in xfs_format=E2=80=8B.h should be there, I just =
need to add
another LIBHANDLE_ variant so we don't include the headers, right?

=E2=80=8BCheers,
Jan=E2=80=8B




--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7bdca47c7c0682051eab208d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Mon, Au=
g 31, 2015 at 8:58 PM, Christoph Hellwig </span><span dir=3D"ltr" style=3D"=
font-family:arial,sans-serif">&lt;<a href=3D"mailto:hch@infradead.org" targ=
et=3D"_blank">hch@infradead.org</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border=
-left-style:solid;padding-left:1ex"><span class=3D"">&gt; index b1c0c10..d5=
32f44 100644<br>
&gt; --- a/libhandle/handle.c<br>
&gt; +++ b/libhandle/handle.c<br>
&gt; @@ -21,6 +21,8 @@<br>
&gt;=C2=A0 #include &quot;xfs.h&quot;<br>
&gt;=C2=A0 #include &quot;handle.h&quot;<br>
&gt;=C2=A0 #include &quot;parent.h&quot;<br>
&gt; +#include &quot;xfs/xfs_arch.h&quot;<br>
&gt; +#include &quot;xfs/xfs_format.h&quot;<br>
<br>
</span>These headers should not be used in libhandle.=C2=A0 As mentioned la=
st time I<br>
think libhandle should get it&#39;s own LIBHANDLE_XATTR_LIST_MAX define,<br=
>
separate frome the one for the on disk format.<br></blockquote><div><br></d=
iv><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,s=
ans-serif;display:inline">=E2=80=8BWell, you wrote about adding it into xfs=
_format.h. I don&#39;t recall (and can&#39;t find) anything else regarding =
XATTR_SIZE...=C2=A0</div></div><div><div class=3D"gmail_default" style=3D"f=
ont-family:arial,helvetica,sans-serif;display:inline"><br></div></div><span=
 style=3D"color:rgb(80,0,80);font-size:12.8000001907349px">&gt; Eww, looks =
like we depend on these Linux values in the on disk</span><br style=3D"colo=
r:rgb(80,0,80);font-size:12.8000001907349px"><span style=3D"color:rgb(80,0,=
80);font-size:12.8000001907349px">&gt; defintion.=C2=A0 I think we need to =
add new XFS_XATTR_SIZE_MAX and</span><br style=3D"color:rgb(80,0,80);font-s=
ize:12.8000001907349px"><span style=3D"color:rgb(80,0,80);font-size:12.8000=
001907349px">&gt; XFS_XATTR_LIST_MAX defintions to xfs_format.h and use the=
m where</span><br style=3D"color:rgb(80,0,80);font-size:12.8000001907349px"=
><div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,san=
s-serif;display:inline"><span style=3D"color:rgb(80,0,80);font-size:12.8000=
001907349px;font-family:arial,sans-serif">&gt; we currently use these.</spa=
n></div></div><div><div class=3D"gmail_default" style=3D"font-family:arial,=
helvetica,sans-serif;display:inline"><br></div></div><div><div class=3D"gma=
il_default" style=3D"font-family:arial,helvetica,sans-serif;display:inline"=
>So =E2=80=8B</div>=C2=A0<div class=3D"gmail_default" style=3D"font-family:=
arial,helvetica,sans-serif;display:inline">=E2=80=8Bthe XFS_ defines in xfs=
_format=E2=80=8B.h should be there, I just need to add another LIBHANDLE_ v=
ariant so we don&#39;t include the headers, right?</div></div><div><div cla=
ss=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;displa=
y:inline"><br></div></div><div><div class=3D"gmail_default" style=3D"font-f=
amily:arial,helvetica,sans-serif">=E2=80=8BCheers,</div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif">Jan=E2=80=8B</di=
v><br></div></div><br><br clear=3D"all"><div><br></div>-- <br><div class=3D=
"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br>=
</div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.=
com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.=
me</a></div></div></div></div>
</div></div>

--047d7bdca47c7c0682051eab208d--


--===============7445006532432295348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7445006532432295348==--
