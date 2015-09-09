Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 149DE7F37
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 05:11:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 94BC5AC003
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2015 03:11:29 -0700 (PDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
	[209.85.213.175]) by cuda.sgi.com with ESMTP id
	PCfU2woegVu48jGe (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2015 03:11:27 -0700 (PDT)
Received: by igbni9 with SMTP id ni9so10379887igb.0
	for <xfs@oss.sgi.com>; Wed, 09 Sep 2015 03:11:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1441276784-23701-1-git-send-email-jtulak@redhat.com>
References: <1440590555-20463-7-git-send-email-jtulak@redhat.com>
	<1441276784-23701-1-git-send-email-jtulak@redhat.com>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 9 Sep 2015 12:11:08 +0200
Message-ID: <CACj3i72MrbFPnoZ1SpDU0MksBBOENNeAs=gYuxddPmw7am7DZw@mail.gmail.com>
Subject: Re: [PATCH v2 07/11] xfsprogs: change nftw64 to nftw
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8607082054217841662=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Tulak <jtulak@redhat.com>

--===============8607082054217841662==
Content-Type: multipart/alternative; boundary=089e01184e64a8228d051f4db4ee

--089e01184e64a8228d051f4db4ee
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>
> --- a/estimate/xfs_estimate.c
> +++ b/estimate/xfs_estimate.c
> @@ -168,7 +168,7 @@ main(int argc, char **argv)
>                 ndirs=3D0LL;              /* number of directories */
>                 nspecial=3D0LL;           /* number of special files */
>
> -               nftw64(argv[optind], ffn, 40, FTW_PHYS | FTW_MOUNT);
> +               nftw(argv[optind], ffn, 40, FTW_PHYS | FTW_MOUNT);
>
>                 if (__debug) {
>                         printf(_("dirsize=3D%llu\n"), dirsize);
> --
> 2.4.5
>
>
=E2=80=8BNow I noticed this causes a warning:
xfs_estimate.c:171:3: warning: passing argument 2 of =E2=80=98nftw=E2=80=99=
 from
incompatible pointer type

>From ftw.h, the difference is in __nftw_func_t and __nftw64_func_t as a
second argument. However, what we pass in the code is "
int
=E2=80=8B =E2=80=8B
ffn(
=E2=80=8B..., struct stat64 *stb, ...)". =E2=80=8BIf I change this to struc=
t stat, it works
and xfstests -g quick gives the same result as with 64bit variant. So I'm
sending an updated patch.

Cheers,
Jan





--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e01184e64a8228d051f4db4ee
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><div class=3D"gmai=
l_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-styl=
e:solid;padding-left:1ex"><br>
--- a/estimate/xfs_estimate.c<br>
+++ b/estimate/xfs_estimate.c<br>
@@ -168,7 +168,7 @@ main(int argc, char **argv)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ndirs=3D0LL;=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* number of directories */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nspecial=3D0LL;=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* number of special files */<br>
<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nftw64(argv[optind]=
, ffn, 40, FTW_PHYS | FTW_MOUNT);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nftw(argv[optind], =
ffn, 40, FTW_PHYS | FTW_MOUNT);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (__debug) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 printf(_(&quot;dirsize=3D%llu\n&quot;), dirsize);<br>
<span class=3D""><font color=3D"#888888">--<br>
2.4.5<br>
<br></font></span></blockquote><div>=C2=A0</div><div><div class=3D"gmail_de=
fault" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=
=80=8BNow I noticed this causes a warning:</div></div><div><div class=3D"gm=
ail_default" style=3D"display:inline"><font face=3D"arial, helvetica, sans-=
serif">xfs_estimate.c:171:3: warning: passing argument 2 of =E2=80=98nftw=
=E2=80=99 from incompatible pointer type</font><br></div></div><div><div cl=
ass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;displ=
ay:inline"><br></div></div><div><div class=3D"gmail_default" style=3D"font-=
family:arial,helvetica,sans-serif;display:inline">From ftw.h, the differenc=
e is in=C2=A0__nftw_func_t and=C2=A0__nftw64_func_t as a second argument. H=
owever, what we pass in the code is &quot;</div><font face=3D"arial, helvet=
ica, sans-serif">int<div class=3D"gmail_default" style=3D"font-family:arial=
,helvetica,sans-serif;display:inline">=E2=80=8B =E2=80=8B</div></font><span=
 style=3D"font-family:arial,helvetica,sans-serif">ffn(<div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif;display:inline">=E2=
=80=8B..., struct stat64 *stb, ...)&quot;. =E2=80=8BIf I change this to str=
uct stat, it works and xfstests -g quick gives the same result as with 64bi=
t variant. So I&#39;m sending an updated patch.</div></span></div><div><spa=
n style=3D"font-family:arial,helvetica,sans-serif"><div class=3D"gmail_defa=
ult" style=3D"font-family:arial,helvetica,sans-serif;display:inline"><br></=
div></span></div><div><span style=3D"font-family:arial,helvetica,sans-serif=
"><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-se=
rif;display:inline">Cheers,</div></span></div><div><span style=3D"font-fami=
ly:arial,helvetica,sans-serif"><div class=3D"gmail_default" style=3D"font-f=
amily:arial,helvetica,sans-serif;display:inline">Jan</div></span></div><div=
><span style=3D"font-family:arial,helvetica,sans-serif"><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif;display:inline"><=
br></div></span></div><div><span style=3D"font-family:arial,helvetica,sans-=
serif"><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sa=
ns-serif;display:inline"><br></div></span></div><div><span style=3D"font-fa=
mily:arial,helvetica,sans-serif"><div class=3D"gmail_default" style=3D"font=
-family:arial,helvetica,sans-serif;display:inline"><br></div></span></div><=
/div><br clear=3D"all"><div><br></div>-- <br><div class=3D"gmail_signature"=
><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"=
mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a=
 href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a></div></div=
></div></div>
</div></div>

--089e01184e64a8228d051f4db4ee--


--===============8607082054217841662==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8607082054217841662==--
