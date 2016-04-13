Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 15A197CA7
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 14:07:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB206304059
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:07:04 -0700 (PDT)
Received: from mail-yw0-f180.google.com (mail-yw0-f180.google.com
	[209.85.161.180]) by cuda.sgi.com with ESMTP id
	Cpz4tCXS5Plv5yGr (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:07:02 -0700 (PDT)
Received: by mail-yw0-f180.google.com with SMTP id d68so80619098ywe.1
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 12:07:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570E9040.8010409@sandeen.net>
References: <1460571772-20285-1-git-send-email-zlang@redhat.com>
	<570E9040.8010409@sandeen.net>
Date: Thu, 14 Apr 2016 03:07:01 +0800
Message-ID: <CADVQ27rzngphemi8N1mhNxnYThgyFibgieqMJgRBs=XL2KbSTg@mail.gmail.com>
Subject: Re: [PATCH] xfs: group quota is still enforced if mount v5 xfs with
	gqnoenforce and pqnoenforce
From: Zorro Lang <zorro.lang@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4696188548989173348=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

--===============4696188548989173348==
Content-Type: multipart/alternative; boundary=001a11413da89389100530627b34

--001a11413da89389100530627b34
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

2016=E5=B9=B44=E6=9C=8814=E6=97=A5 02:30=EF=BC=8C"Eric Sandeen" <sandeen@sa=
ndeen.net>=E5=86=99=E9=81=93=EF=BC=9A
>
> This looks fine, but I think Eryu already sent this patch on 3/31:
>
> [PATCH] xfs: add missing break in xfs_parseargs()

Hi,

Sorry for this duplicate patch... I think I missed that patch email from
mail list. Please ignore this DUP patch.

Thanks,
Zorro

>
> -Eric
>
> On 4/13/16 1:22 PM, Zorro Lang wrote:
> > This's a regression bug caused by:
> >
> >   2e74af0 xfs: convert mount option parsing to tokens
> >
> > xfstests xfs/299 can reproduce this bug, it will fail when do
> > gpnoenforce test, the error output as below(diff with 299.out):
> >
> >  *** push past the soft block limit
> >   [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> >   -[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------] 0 0 0 00
[--------]
> >   +[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00
[--------]
> >
> >  *** push past the hard inode limit (expect EDQUOT)
> >   [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> >   -[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none--] 0 0 0 00
[--------]
> >   +[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00
[--------]
> >
> >  *** push past the hard block limit (expect EDQUOT)
> >   [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> >   -[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none--] 0 0 0 00
[--------]
> >   +[NAME] 500 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00
[--------]
> >
> > It shows that group quota is still enforced. But this bug only can
> > be reproduced when mount v5 xfs with gqnoenforce and pqnoenforce
> > options. The reason as I found is a missed "break" in xfs_parseargs()
> > function.
> >
> > After deal with "pqnoenforce", it should break. But the code keep
> > running into "gquota/grpquota" lines, and make gquota enforced.
> >
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >
> > Hi,
> >
> > This's a tiny bug(only one line patch). But it's belong to
> > regression bug and take me a few hours to find the problem.
> > So I hope it can be fixed:)
> >
> > Thanks,
> > Zorro
> >
> >  fs/xfs/xfs_super.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 187e14b..f3c0ffc 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -350,6 +350,7 @@ xfs_parseargs(
> >               case Opt_pqnoenforce:
> >                       mp->m_qflags |=3D (XFS_PQUOTA_ACCT |
XFS_PQUOTA_ACTIVE);
> >                       mp->m_qflags &=3D ~XFS_PQUOTA_ENFD;
> > +                     break;
> >               case Opt_gquota:
> >               case Opt_grpquota:
> >                       mp->m_qflags |=3D (XFS_GQUOTA_ACCT |
XFS_GQUOTA_ACTIVE |
> >
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

--001a11413da89389100530627b34
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
2016=E5=B9=B44=E6=9C=8814=E6=97=A5 02:30=EF=BC=8C&quot;Eric Sandeen&quot; &=
lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@sandeen.net</a>&gt;=E5=86=
=99=E9=81=93=EF=BC=9A<br>
&gt;<br>
&gt; This looks fine, but I think Eryu already sent this patch on 3/31:<br>
&gt;<br>
&gt; [PATCH] xfs: add missing break in xfs_parseargs()</p>
<p dir=3D"ltr">Hi,</p>
<p dir=3D"ltr">Sorry for this duplicate patch... I think I missed that patc=
h email from mail list. Please ignore this DUP patch.</p>
<p dir=3D"ltr">Thanks,<br>
Zorro</p>
<p dir=3D"ltr">&gt;<br>
&gt; -Eric<br>
&gt;<br>
&gt; On 4/13/16 1:22 PM, Zorro Lang wrote:<br>
&gt; &gt; This&#39;s a regression bug caused by:<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A02e74af0 xfs: convert mount option parsing to tokens<b=
r>
&gt; &gt;<br>
&gt; &gt; xfstests xfs/299 can reproduce this bug, it will fail when do<br>
&gt; &gt; gpnoenforce test, the error output as below(diff with 299.out):<b=
r>
&gt; &gt;<br>
&gt; &gt;=C2=A0 *** push past the soft block limit<br>
&gt; &gt;=C2=A0 =C2=A0[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 =
00 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0-[NAME] 140 100 500 00 [--------] 4 4 10 00 [--------=
] 0 0 0 00 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0+[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] =
0 0 0 00 [--------]<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 *** push past the hard inode limit (expect EDQUOT)<br>
&gt; &gt;=C2=A0 =C2=A0[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 =
00 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0-[NAME] 140 100 500 00 [--------] 16 4 10 00 [--none-=
-] 0 0 0 00 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0+[NAME] 140 100 500 00 [7 days] 10 4 10 00 [7 days] 0=
 0 0 00 [--------]<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 *** push past the hard block limit (expect EDQUOT)<br>
&gt; &gt;=C2=A0 =C2=A0[ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 =
00 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0-[NAME] 540 100 500 00 [--none--] 16 4 10 00 [--none-=
-] 0 0 0 00 [--------]<br>
&gt; &gt;=C2=A0 =C2=A0+[NAME] 500 100 500 00 [7 days] 10 4 10 00 [7 days] 0=
 0 0 00 [--------]<br>
&gt; &gt;<br>
&gt; &gt; It shows that group quota is still enforced. But this bug only ca=
n<br>
&gt; &gt; be reproduced when mount v5 xfs with gqnoenforce and pqnoenforce<=
br>
&gt; &gt; options. The reason as I found is a missed &quot;break&quot; in x=
fs_parseargs()<br>
&gt; &gt; function.<br>
&gt; &gt;<br>
&gt; &gt; After deal with &quot;pqnoenforce&quot;, it should break. But the=
 code keep<br>
&gt; &gt; running into &quot;gquota/grpquota&quot; lines, and make gquota e=
nforced.<br>
&gt; &gt;<br>
&gt; &gt; Signed-off-by: Zorro Lang &lt;<a href=3D"mailto:zlang@redhat.com"=
>zlang@redhat.com</a>&gt;<br>
&gt; &gt; ---<br>
&gt; &gt;<br>
&gt; &gt; Hi,<br>
&gt; &gt;<br>
&gt; &gt; This&#39;s a tiny bug(only one line patch). But it&#39;s belong t=
o<br>
&gt; &gt; regression bug and take me a few hours to find the problem.<br>
&gt; &gt; So I hope it can be fixed:)<br>
&gt; &gt;<br>
&gt; &gt; Thanks,<br>
&gt; &gt; Zorro<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 fs/xfs/xfs_super.c | 1 +<br>
&gt; &gt;=C2=A0 1 file changed, 1 insertion(+)<br>
&gt; &gt;<br>
&gt; &gt; diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c<br>
&gt; &gt; index 187e14b..f3c0ffc 100644<br>
&gt; &gt; --- a/fs/xfs/xfs_super.c<br>
&gt; &gt; +++ b/fs/xfs/xfs_super.c<br>
&gt; &gt; @@ -350,6 +350,7 @@ xfs_parseargs(<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case Opt_pq=
noenforce:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0mp-&gt;m_qflags |=3D (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE)=
;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0mp-&gt;m_qflags &amp;=3D ~XFS_PQUOTA_ENFD;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0break;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case Opt_gq=
uota:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0case Opt_gr=
pquota:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0mp-&gt;m_qflags |=3D (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE =
|<br>
&gt; &gt;<br>
&gt;<br>
&gt; _______________________________________________<br>
&gt; xfs mailing list<br>
&gt; <a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
&gt; <a href=3D"http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com=
/mailman/listinfo/xfs</a><br>
</p>

--001a11413da89389100530627b34--


--===============4696188548989173348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4696188548989173348==--
