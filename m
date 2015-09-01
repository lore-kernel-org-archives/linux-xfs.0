Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A2997F47
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 03:35:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 05F68AC004
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 01:35:58 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com
	[209.85.223.170]) by cuda.sgi.com with ESMTP id
	UFeCBYQRGq1yZhal (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 01:35:57 -0700 (PDT)
Received: by iog7 with SMTP id 7so63660927iog.2
	for <xfs@oss.sgi.com>; Tue, 01 Sep 2015 01:35:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACj3i71LQMFnToYaNe7r5j2MRk1chAieXLCY-OmDh5sQ7B+kfg@mail.gmail.com>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-2-git-send-email-jtulak@redhat.com>
	<20150831185817.GD349@infradead.org>
	<CACj3i71LQMFnToYaNe7r5j2MRk1chAieXLCY-OmDh5sQ7B+kfg@mail.gmail.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 1 Sep 2015 10:35:37 +0200
Message-ID: <CACj3i72j-0-eyR38wRx+Bb+6WWjtVyESP+UFBFpFH_z_8bQ85A@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="===============8473456944317960646=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8473456944317960646==
Content-Type: multipart/alternative; boundary=001a113ece145dce82051eab7002

--001a113ece145dce82051eab7002
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ah, never mind, I noticed I didn't read the last part of Dave's email. It
looks clear now.

Jan

On Tue, Sep 1, 2015 at 10:13 AM, Jan Tulak <jtulak@redhat.com> wrote:

> On Mon, Aug 31, 2015 at 8:58 PM, Christoph Hellwig <hch@infradead.org>
> wrote:
>
>> > index b1c0c10..d532f44 100644
>> > --- a/libhandle/handle.c
>> > +++ b/libhandle/handle.c
>> > @@ -21,6 +21,8 @@
>> >  #include "xfs.h"
>> >  #include "handle.h"
>> >  #include "parent.h"
>> > +#include "xfs/xfs_arch.h"
>> > +#include "xfs/xfs_format.h"
>>
>> These headers should not be used in libhandle.  As mentioned last time I
>> think libhandle should get it's own LIBHANDLE_XATTR_LIST_MAX define,
>> separate frome the one for the on disk format.
>>
>
> =E2=80=8BWell, you wrote about adding it into xfs_format.h. I don't recal=
l (and
> can't find) anything else regarding XATTR_SIZE...
>
> > Eww, looks like we depend on these Linux values in the on disk
> > defintion.  I think we need to add new XFS_XATTR_SIZE_MAX and
> > XFS_XATTR_LIST_MAX defintions to xfs_format.h and use them where
> > we currently use these.
>
> So =E2=80=8B
>
> =E2=80=8Bthe XFS_ defines in xfs_format=E2=80=8B.h should be there, I jus=
t need to add
> another LIBHANDLE_ variant so we don't include the headers, right?
>
> =E2=80=8BCheers,
> Jan=E2=80=8B
>
>
>
>
> --
> Jan Tulak
> jtulak@redhat.com / jan@tulak.me
>



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113ece145dce82051eab7002
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif">Ah, never mind, I noticed I didn&#39;t read the last pa=
rt of Dave&#39;s email. It looks clear now.</div><div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D=
"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Jan</div><=
/div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Tue, Sep =
1, 2015 at 10:13 AM, Jan Tulak <span dir=3D"ltr">&lt;<a href=3D"mailto:jtul=
ak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>&gt;</span> wrote:<br=
><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1=
px #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div><div class=3D"h5"><di=
v class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">=
<span style=3D"font-family:arial,sans-serif">On Mon, Aug 31, 2015 at 8:58 P=
M, Christoph Hellwig </span><span dir=3D"ltr" style=3D"font-family:arial,sa=
ns-serif">&lt;<a href=3D"mailto:hch@infradead.org" target=3D"_blank">hch@in=
fradead.org</a>&gt;</span><span style=3D"font-family:arial,sans-serif"> wro=
te:</span><br></div></div></div><div class=3D"gmail_extra"><div class=3D"gm=
ail_quote"><div><div class=3D"h5"><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(20=
4,204,204);border-left-style:solid;padding-left:1ex"><span>&gt; index b1c0c=
10..d532f44 100644<br>
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
iv></div></div><div><div class=3D"gmail_default" style=3D"font-family:arial=
,helvetica,sans-serif;display:inline">=E2=80=8BWell, you wrote about adding=
 it into xfs_format.h. I don&#39;t recall (and can&#39;t find) anything els=
e regarding XATTR_SIZE...=C2=A0</div></div><div><div class=3D"gmail_default=
" style=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></div=
></div><span style=3D"color:rgb(80,0,80);font-size:12.8000001907349px">&gt;=
 Eww, looks like we depend on these Linux values in the on disk</span><br s=
tyle=3D"color:rgb(80,0,80);font-size:12.8000001907349px"><span style=3D"col=
or:rgb(80,0,80);font-size:12.8000001907349px">&gt; defintion.=C2=A0 I think=
 we need to add new XFS_XATTR_SIZE_MAX and</span><br style=3D"color:rgb(80,=
0,80);font-size:12.8000001907349px"><span style=3D"color:rgb(80,0,80);font-=
size:12.8000001907349px">&gt; XFS_XATTR_LIST_MAX defintions to xfs_format.h=
 and use them where</span><br style=3D"color:rgb(80,0,80);font-size:12.8000=
001907349px"><div><div class=3D"gmail_default" style=3D"font-family:arial,h=
elvetica,sans-serif;display:inline"><span style=3D"color:rgb(80,0,80);font-=
size:12.8000001907349px;font-family:arial,sans-serif">&gt; we currently use=
 these.</span></div></div><div><div class=3D"gmail_default" style=3D"font-f=
amily:arial,helvetica,sans-serif;display:inline"><br></div></div><div><div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;dis=
play:inline">So =E2=80=8B</div>=C2=A0<div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif;display:inline">=E2=80=8Bthe XFS_ de=
fines in xfs_format=E2=80=8B.h should be there, I just need to add another =
LIBHANDLE_ variant so we don&#39;t include the headers, right?</div></div><=
div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-=
serif;display:inline"><br></div></div><div><div class=3D"gmail_default" sty=
le=3D"font-family:arial,helvetica,sans-serif">=E2=80=8BCheers,</div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif">Jan=
=E2=80=8B</div><br></div></div><span class=3D""><br><br clear=3D"all"><div>=
<br></div>-- <br><div><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak=
<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@red=
hat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tu=
lak.me</a></div></div></div></div>
</span></div></div>
</blockquote></div><br><br clear=3D"all"><div><br></div>-- <br><div class=
=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<=
br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redh=
at.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tul=
ak.me</a></div></div></div></div>
</div>

--001a113ece145dce82051eab7002--


--===============8473456944317960646==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8473456944317960646==--
