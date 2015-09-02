Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CEB1A7F5F
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 02:12:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD2ED304048
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 00:12:25 -0700 (PDT)
Received: from mail-ig0-f182.google.com (mail-ig0-f182.google.com
	[209.85.213.182]) by cuda.sgi.com with ESMTP id
	o6ObvTyoEYQTGVvF (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Sep 2015 00:12:24 -0700 (PDT)
Received: by igbut12 with SMTP id ut12so7019406igb.1
	for <xfs@oss.sgi.com>; Wed, 02 Sep 2015 00:12:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150901163120.GA10397@birch.djwong.org>
References: <20150831185944.GI349@infradead.org>
	<1441094672-18368-1-git-send-email-jtulak@redhat.com>
	<20150901163120.GA10397@birch.djwong.org>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 2 Sep 2015 09:12:04 +0200
Message-ID: <CACj3i71w-Yh_USPVwV=-XVdGRXMgHsp4pce7AKQz8uPsmXp+ZA@mail.gmail.com>
Subject: Re: [PATCH v2] xfsprogs: add nftw64 translation for OS X
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2584184821038869211=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

--===============2584184821038869211==
Content-Type: multipart/alternative; boundary=047d7bdc13386c1b81051ebe631a

--047d7bdc13386c1b81051ebe631a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2015 at 6:31 PM, Darrick J. Wong <darrick.wong@oracle.com>
wrote:

> On Tue, Sep 01, 2015 at 10:04:32AM +0200, Jan Tulak wrote:
> > UPDATE: changed to #define
> >
> > OS X has only nftw variant - not the 64 suffix used in xfs.
> >
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > ---
> >  include/darwin.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/darwin.h b/include/darwin.h
> > index 72d9c1d..f0f05b3 100644
> > --- a/include/darwin.h
> > +++ b/include/darwin.h
> > @@ -157,6 +157,8 @@ typedef int64_t           xfs_daddr_t;
> >
> >  #define HAVE_FID     1
> >
> > +#define nftw64 nftw
> > +
>
> Sorry for chiming in late, but there's only one caller of nftw64 and
> several
> callers of nftw; why not just change it to use nftw?
>
> <shrug> There could be other reasons why xfs_estimate requires the -64
> variant, but I don't know. :)
>

=E2=80=8BGood idea. I'll run tests after the change=E2=80=8B

=E2=80=8Band if nothing bad happens, I send
it here.
=E2=80=8B
--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7bdc13386c1b81051ebe631a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Tue, Sep 1, 2015 at 6:31 PM, Darrick J. Wong <span dir=3D"l=
tr">&lt;<a href=3D"mailto:darrick.wong@oracle.com" target=3D"_blank">darric=
k.wong@oracle.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><=
span class=3D"">On Tue, Sep 01, 2015 at 10:04:32AM +0200, Jan Tulak wrote:<=
br>
&gt; UPDATE: changed to #define<br>
&gt;<br>
&gt; OS X has only nftw variant - not the 64 suffix used in xfs.<br>
&gt;<br>
&gt; Signed-off-by: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtul=
ak@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 include/darwin.h | 2 ++<br>
&gt;=C2=A0 1 file changed, 2 insertions(+)<br>
&gt;<br>
&gt; diff --git a/include/darwin.h b/include/darwin.h<br>
&gt; index 72d9c1d..f0f05b3 100644<br>
&gt; --- a/include/darwin.h<br>
&gt; +++ b/include/darwin.h<br>
&gt; @@ -157,6 +157,8 @@ typedef int64_t=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0xfs_daddr_t;<br>
&gt;<br>
&gt;=C2=A0 #define HAVE_FID=C2=A0 =C2=A0 =C2=A01<br>
&gt;<br>
&gt; +#define nftw64 nftw<br>
&gt; +<br>
<br>
</span>Sorry for chiming in late, but there&#39;s only one caller of nftw64=
 and several<br>
callers of nftw; why not just change it to use nftw?<br>
<br>
&lt;shrug&gt; There could be other reasons why xfs_estimate requires the -6=
4<br>
variant, but I don&#39;t know. :)<br></blockquote><div><br></div><div><div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;dis=
play:inline">=E2=80=8BGood idea. I&#39;ll run tests after the change=E2=80=
=8B</div>=C2=A0<div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif;display:inline">=E2=80=8Band if nothing bad happens, I sen=
d</div></div><div><div class=3D"gmail_default" style=3D"font-family:arial,h=
elvetica,sans-serif;display:inline">it here.</div></div><div><div class=3D"=
gmail_default" style=3D"font-family:arial,helvetica,sans-serif;display:inli=
ne">=E2=80=8B</div></div></div>-- <br><div class=3D"gmail_signature"><div d=
ir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:=
jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=
=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div></di=
v></div>
</div></div>

--047d7bdc13386c1b81051ebe631a--


--===============2584184821038869211==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2584184821038869211==--
