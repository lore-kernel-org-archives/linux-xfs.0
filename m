Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 39ADD7CA2
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 05:00:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C005F8F8033
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 03:00:12 -0700 (PDT)
Received: from mail-ig0-f174.google.com (mail-ig0-f174.google.com
	[209.85.213.174]) by cuda.sgi.com with ESMTP id
	Gyu7BlPnYykY4wug (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 03:00:10 -0700 (PDT)
Received: by mail-ig0-f174.google.com with SMTP id s8so15168392ign.0
	for <xfs@oss.sgi.com>; Tue, 03 May 2016 03:00:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ab11d986-a605-4070-9932-eb9dc3e9cff0@sandeen.net>
References: <1461311383-30897-1-git-send-email-jtulak@redhat.com>
	<1461941267-31556-1-git-send-email-jtulak@redhat.com>
	<ab11d986-a605-4070-9932-eb9dc3e9cff0@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 3 May 2016 11:59:50 +0200
Message-ID: <CACj3i73ZDuvL-M6F8gRNB8e0mmrNB_DuWz323dWZsCGSZd4yEQ@mail.gmail.com>
Subject: Re: [PATCH 15/19 v3] mkfs: don't treat files as though they are block
	devices
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4756605547461793450=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============4756605547461793450==
Content-Type: multipart/alternative; boundary=089e0158b06ca602d50531ed2c89

--089e0158b06ca602d50531ed2c89
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2016 at 9:11 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

>
>
> On 4/29/16 9:47 AM, Jan Tulak wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > If the device is actually a file, and "-d file" is not specified,
> > mkfs will try to treat it as a block device and get stuff wrong.
> > Image files don't necessarily have the same sector sizes as the
> > block device or filesystem underlying the image file, nor should we
> > be issuing discard ioctls on image files.
> >
> > To fix this sanely, only require "-d file" if the device name is
> > invalid to trigger creation of the file. Otherwise, use stat() to
> > determine if the device is a file or block device and deal with that
> > appropriately by setting the "isfile" variables and turning off
> > direct IO. Then ensure that we check the "isfile" options before
> > doing things that are specific to block devices.
> >
> > Other file/blockdev issues fixed:
> >       - use getstr to detect specifying the data device name
> >         twice.
> >       - check file/size/name parameters before anything else.
> >       - overwrite checks need to be done before the image file is
> >         opened and potentially truncated.
> >       - blkid_get_topology() should not be called for image files,
> >         so warn when it is called that way.
> >       - zero_old_xfs_structures() emits a spurious error:
> >               "existing superblock read failed: Success"
> >         when it is run on a truncated image file. Don't warn if we
> >         see this problem on an image file.
> >       - Don't issue discards on image files.
> >       - Use fsync() for image files, not BLKFLSBUF in
> >         platform_flush_device() for Linux.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> >
> > ---
> > CHANGES:
> > * read image file size in advance of O_TRUNC in case of dfile&&dcreat
> > Signed-off-by: Jan Tulak <jtulak@redhat.com>
> > ---
> >  libxfs/init.c   |  21 ++++++-
> >  libxfs/linux.c  |  11 +++-
> >  mkfs/xfs_mkfs.c | 182
> ++++++++++++++++++++++++++++++++++++++------------------
> >  3 files changed, 154 insertions(+), 60 deletions(-)
> >
> > diff --git a/libxfs/init.c b/libxfs/init.c
> > index 8d747e8..c7ae00d 100644
> > --- a/libxfs/init.c
> > +++ b/libxfs/init.c
> > @@ -253,8 +253,15 @@ libxfs_init(libxfs_init_t *a)
> >       rtname =3D a->rtname;
> >       a->dfd =3D a->logfd =3D a->rtfd =3D -1;
> >       a->ddev =3D a->logdev =3D a->rtdev =3D 0;
> > -     a->dbsize =3D a->lbsize =3D a->rtbsize =3D 0;
> > -     a->dsize =3D a->logBBsize =3D a->logBBstart =3D a->rtsize =3D 0;
> > +     a->lbsize =3D a->rtbsize =3D 0;
> > +     a->logBBsize =3D a->logBBstart =3D a->rtsize =3D 0;
> > +
> > +     // We can reset dbsize only when it is not a file, or we won't
> > +     // truncate it. Otherwise, we loose the size of the file forever.
>
> please don't use c++ comments in xfsprogs, we use /* comments */
>

Sorry. =E2=80=8B:-[ =E2=80=8B



>
> ...
>
> >  static void
> > +check_device_type(
> > +     const char      *name,
> > +     int             *isfile,
> > +     bool            no_size,
> > +     bool            no_name,
> > +     int             *create,
> > +     bool            force_overwrite,
> > +     const char      *optname)
> > +{
> > +     struct stat64 statbuf;
> > +     /*
> > +     if (*isfile && (no_size || no_name)) {
> > +             fprintf(stderr,
> > +     _("if -%s file then -%s name and -%s size are required\n"),
> > +                     optname, optname, optname);
> > +             usage();
> > +     }*/
>
> What is this?
>
> =E2=80=8BAgain :-[
I commented it out during the development and then forgot to really delete
it.=E2=80=8B



> Jan, I'm just going to go back to the original patches posted in your V2
> series,
> and either give them Reviewed-by's, or send followup fix-up patches with =
a
>
> Eric Sandeen <sandeen@redhat.com>: fixed up foo, bar, baz
>
> tag and a Reviewed-by to go with it, I think that might be the fastest
> path to
> finally getting this stuff merged.
>
>
=E2=80=8BOK, whatever you think is the best. :-)=E2=80=8B

Thanks,
Jan




> Thanks,
> -Eric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e0158b06ca602d50531ed2c89
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Fri, Apr 29, 2016 at 9:11 PM, Eric Sandeen <span dir=3D"ltr=
">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sand=
een.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;bor=
der-left-color:rgb(204,204,204);padding-left:1ex"><div class=3D""><div clas=
s=3D"h5"><br>
<br>
On 4/29/16 9:47 AM, Jan Tulak wrote:<br>
&gt; From: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com">dchinner=
@redhat.com</a>&gt;<br>
&gt;<br>
&gt; If the device is actually a file, and &quot;-d file&quot; is not speci=
fied,<br>
&gt; mkfs will try to treat it as a block device and get stuff wrong.<br>
&gt; Image files don&#39;t necessarily have the same sector sizes as the<br=
>
&gt; block device or filesystem underlying the image file, nor should we<br=
>
&gt; be issuing discard ioctls on image files.<br>
&gt;<br>
&gt; To fix this sanely, only require &quot;-d file&quot; if the device nam=
e is<br>
&gt; invalid to trigger creation of the file. Otherwise, use stat() to<br>
&gt; determine if the device is a file or block device and deal with that<b=
r>
&gt; appropriately by setting the &quot;isfile&quot; variables and turning =
off<br>
&gt; direct IO. Then ensure that we check the &quot;isfile&quot; options be=
fore<br>
&gt; doing things that are specific to block devices.<br>
&gt;<br>
&gt; Other file/blockdev issues fixed:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- use getstr to detect specifying the data d=
evice name<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0twice.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- check file/size/name parameters before any=
thing else.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- overwrite checks need to be done before th=
e image file is<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0opened and potentially truncated.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- blkid_get_topology() should not be called =
for image files,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0so warn when it is called that way.<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- zero_old_xfs_structures() emits a spurious=
 error:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&quot;existing s=
uperblock read failed: Success&quot;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0when it is run on a truncated image f=
ile. Don&#39;t warn if we<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0see this problem on an image file.<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- Don&#39;t issue discards on image files.<b=
r>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- Use fsync() for image files, not BLKFLSBUF=
 in<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0platform_flush_device() for Linux.<br=
>
&gt;<br>
&gt; Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redhat.com"=
>dchinner@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtul=
ak@redhat.com</a>&gt;<br>
&gt;<br>
&gt; ---<br>
&gt; CHANGES:<br>
&gt; * read image file size in advance of O_TRUNC in case of dfile&amp;&amp=
;dcreat<br>
&gt; Signed-off-by: Jan Tulak &lt;<a href=3D"mailto:jtulak@redhat.com">jtul=
ak@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 libxfs/init.c=C2=A0 =C2=A0|=C2=A0 21 ++++++-<br>
&gt;=C2=A0 libxfs/linux.c=C2=A0 |=C2=A0 11 +++-<br>
&gt;=C2=A0 mkfs/xfs_mkfs.c | 182 ++++++++++++++++++++++++++++++++++++++----=
--------------<br>
&gt;=C2=A0 3 files changed, 154 insertions(+), 60 deletions(-)<br>
&gt;<br>
&gt; diff --git a/libxfs/init.c b/libxfs/init.c<br>
&gt; index 8d747e8..c7ae00d 100644<br>
&gt; --- a/libxfs/init.c<br>
&gt; +++ b/libxfs/init.c<br>
&gt; @@ -253,8 +253,15 @@ libxfs_init(libxfs_init_t *a)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0rtname =3D a-&gt;rtname;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0a-&gt;dfd =3D a-&gt;logfd =3D a-&gt;rtfd =3D=
 -1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0a-&gt;ddev =3D a-&gt;logdev =3D a-&gt;rtdev =
=3D 0;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0a-&gt;dbsize =3D a-&gt;lbsize =3D a-&gt;rtbsize =
=3D 0;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0a-&gt;dsize =3D a-&gt;logBBsize =3D a-&gt;logBBst=
art =3D a-&gt;rtsize =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0a-&gt;lbsize =3D a-&gt;rtbsize =3D 0;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0a-&gt;logBBsize =3D a-&gt;logBBstart =3D a-&gt;rt=
size =3D 0;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0// We can reset dbsize only when it is not a file=
, or we won&#39;t<br>
&gt; +=C2=A0 =C2=A0 =C2=A0// truncate it. Otherwise, we loose the size of t=
he file forever.<br>
<br>
</div></div>please don&#39;t use c++ comments in xfsprogs, we use /* commen=
ts */<br></blockquote><div><br></div><div><div class=3D"gmail_default" styl=
e=3D"font-family:arial,helvetica,sans-serif">Sorry. =E2=80=8B:-[ =E2=80=8B<=
/div><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"=
margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;bord=
er-left-color:rgb(204,204,204);padding-left:1ex">
<br>
...<br>
<span class=3D""><br>
&gt;=C2=A0 static void<br>
&gt; +check_device_type(<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const char=C2=A0 =C2=A0 =C2=A0 *name,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0*isfile,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_=
size,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 no_=
name,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0*create,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for=
ce_overwrite,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0const char=C2=A0 =C2=A0 =C2=A0 *optname)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0struct stat64 statbuf;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (*isfile &amp;&amp; (no_size || no_name)) {<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0_(&quot;if -%s file then -%s name and -%s size ar=
e required\n&quot;),<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0optname, optname, optname);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0usage();<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}*/<br>
<br>
</span>What is this?<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">=E2=80=8BAgain :-[</div><div class=3D"gmail_defaul=
t" style=3D"font-family:arial,helvetica,sans-serif">I commented it out duri=
ng the development and then forgot to really delete it.=E2=80=8B</div><br><=
/div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;border-left-co=
lor:rgb(204,204,204);padding-left:1ex">
Jan, I&#39;m just going to go back to the original patches posted in your V=
2 series,<br>
and either give them Reviewed-by&#39;s, or send followup fix-up patches wit=
h a<br>
<br>
Eric Sandeen &lt;<a href=3D"mailto:sandeen@redhat.com">sandeen@redhat.com</=
a>&gt;: fixed up foo, bar, baz<br>
<br>
tag and a Reviewed-by to go with it, I think that might be the fastest path=
 to<br>
finally getting this stuff merged.<br>
<br></blockquote><div><br></div><div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif">=E2=80=8BOK, whatever you think is =
the best. :-)=E2=80=8B</div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif">Thanks,</div><div class=3D"gmai=
l_default" style=3D"font-family:arial,helvetica,sans-serif">Jan</div><br></=
div><div><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-style:solid;=
border-left-color:rgb(204,204,204);padding-left:1ex">
Thanks,<br>
-Eric<br>
<div class=3D""><div class=3D"h5"><br>
_______________________________________________<br>
xfs mailing list<br>
<a href=3D"mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a><br>
<a href=3D"http://oss.sgi.com/mailman/listinfo/xfs" rel=3D"noreferrer" targ=
et=3D"_blank">http://oss.sgi.com/mailman/listinfo/xfs</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div>=
Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">j=
tulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blan=
k">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e0158b06ca602d50531ed2c89--


--===============4756605547461793450==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4756605547461793450==--
