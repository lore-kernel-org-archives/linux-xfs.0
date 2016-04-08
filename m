Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 97FBD7CC9
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 10:57:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 28DC5AC002
	for <xfs@oss.sgi.com>; Fri,  8 Apr 2016 08:57:20 -0700 (PDT)
Received: from mail-ig0-f178.google.com (mail-ig0-f178.google.com
	[209.85.213.178]) by cuda.sgi.com with ESMTP id
	bwE5RasDDZHes1jZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Apr 2016 08:57:18 -0700 (PDT)
Received: by mail-ig0-f178.google.com with SMTP id f1so16324694igr.1
	for <xfs@oss.sgi.com>; Fri, 08 Apr 2016 08:57:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5707D35E.7070703@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-16-git-send-email-jtulak@redhat.com>
	<5706FA7C.7020103@sandeen.net>
	<CACj3i73JEzCj-4kp3=H9mjXCKYgcOUYCOyq-aZSWZFXUih+0MA@mail.gmail.com>
	<5707D35E.7070703@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 8 Apr 2016 17:56:58 +0200
Message-ID: <CACj3i70Xm2qqTxMvgGZrnM6q1UZL1UJPoGeR=OkWJ_vuVKoEaw@mail.gmail.com>
Subject: Re: [PATCH 15/19] mkfs: don't treat files as though they are block
	devices
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8027683467601773090=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8027683467601773090==
Content-Type: multipart/alternative; boundary=047d7b1637add1193e052ffb3f91

--047d7b1637add1193e052ffb3f91
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 8, 2016 at 5:50 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 4/8/16 9:58 AM, Jan Tulak wrote:
> >     Ok, platform_findsizes already explicitly handled regular files, an=
d
> tries to
> >     find out via an xfs ioctl what the minimum DIO size is, and uses
> that for
> >     the sector size for the filesystem in the iamge.
> >
> >
> >     Now you stat & get the blocksize, and use that instead, but it's
> likely
> >     to be different:
> >
> >     i.e. before:
> >
> >     # mkfs/mkfs.xfs -f fsfile
> >     meta-data=3Dfsfile                 isize=3D512    agcount=3D4,
> agsize=3D65536 blks
> >              =3D                       sectsz=3D512   attr=3D2, projid3=
2bit=3D1
> >
> >     after:
> >
> >     # mkfs/mkfs.xfs -f fsfile
> >     meta-data=3Dfsfile                 isize=3D512    agcount=3D4,
> agsize=3D65536 blks
> >              =3D                       sectsz=3D4096  attr=3D2, projid3=
2bit=3D1
> >
> >     and also, now:
> >
> >     # mkfs/mkfs.xfs -f -dfile,name=3Dfsfile,size=3D1g -b size=3D2048
> >     block size 2048 cannot be smaller than logical sector size 4096
> >
> >     What prompted you to make this change, was there some other problem
> you
> >     needed to fix?
> >
> >
> > =E2=80=8BBut DIO is disabled for the files, per the commit message:
> > [...] and turning off
> > direct IO. Then ensure that we check the "isfile" options before
> > doing things that are specific to block devices.  Also, as direct IO
> > is disabled for files, use statfs() for getting host FS blocksize,
> > not platform_findsizes().=E2=80=8B
>
> But doing DIO to the file during mkfs isn't the issue I'm talking about;
> For example a vm image hosted in a file will have direct IO done to it
> when it is in use, and filesystem block size is not the controlling
> factor there.
>
> With your change, we can no longer make i.e. a 2k fs image hosted on a 4k
> fs.  i.e. your change regresses this commit:
>
> commit 98dd72d3b239050138cf9eb9373c83743878a7d2
> Author: Eric Sandeen <sandeen@sandeen.net>
> Date:   Fri Dec 18 12:15:25 2015 +1100
>
>     mkfs: get sector size from host fs d_miniosz when mkfs'ing file
>
>     Now that we allow logical-sector-sized DIOs even if our xfs
>     filesystem is set to physical-sector-sized "sectors," we can
>     allow the creation of filesystem images with block and sector
>     sizes down to the host device's logical sector size, rather
>     than the filesystem's sector size.
>
>     So in platform_findsizes(), change our query of the filesystem
>     to an XFS_IOC_DIOINFO query, and use the returned d_miniosz for
>     sector size in the S_IFREG case.
>
>     This allows the creation of i.e. a 2k block sized image on
>     an xfs filesystem w/ 4k sector size created on a 4k/512
>     block device, which would otherwise fail today.
>
>     Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>     Reviewed-by: Dave Chinner <dchinner@redhat.com>
>     Signed-off-by: Dave Chinner <david@fromorbit.com>
>
>
> > So we have to use whatever the underlying fs tells us, not what the
> physical device has, right?
>
> Well, tells us about what?  XFS can tell us its block size, but also can
> tell us about minimum size and alignment required for direct IO, which is
> more relevant to a filesystem image than the filesystem's block size.
>
> > =E2=80=8B Rather, I wonder if there is any reason to keep the
> > platform_findsizes part about regular files - it shouldn't get into
> > the branch ever.
>
> In general, having a wrapper which finds sizes of a target, regardless of
> platform, device, or file, makes sense to me rather than having stat call=
s
> in various other places...
>
> -Eric
>

It seems I misunderstood some things about what =E2=80=8Bhappens/what shoul=
d happen
with files. :-)
I will see what happens with the tests, what difference in the results is
with this patch in the original version.

=E2=80=8BCheers,
Jan=E2=80=8B



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7b1637add1193e052ffb3f91
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Fri, Ap=
r 8, 2016 at 5:50 PM, Eric Sandeen </span><span dir=3D"ltr" style=3D"font-f=
amily:arial,sans-serif">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=
=3D"_blank">sandeen@sandeen.net</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"HOEnZb"><di=
v class=3D"h5">On 4/8/16 9:58 AM, Jan Tulak wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0Ok, platform_findsizes already explicitly handled r=
egular files, and tries to<br>
&gt;=C2=A0 =C2=A0 =C2=A0find out via an xfs ioctl what the minimum DIO size=
 is, and uses that for<br>
&gt;=C2=A0 =C2=A0 =C2=A0the sector size for the filesystem in the iamge.<br=
>
&gt;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Now you stat &amp; get the blocksize, and use that =
instead, but it&#39;s likely<br>
&gt;=C2=A0 =C2=A0 =C2=A0to be different:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0i.e. before:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0# mkfs/mkfs.xfs -f fsfile<br>
&gt;=C2=A0 =C2=A0 =C2=A0meta-data=3Dfsfile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0isize=3D512=C2=A0 =C2=A0 agcount=3D4, agsize=
=3D65536 blks<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sectsz=3D=
512=C2=A0 =C2=A0attr=3D2, projid32bit=3D1<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0after:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0# mkfs/mkfs.xfs -f fsfile<br>
&gt;=C2=A0 =C2=A0 =C2=A0meta-data=3Dfsfile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0isize=3D512=C2=A0 =C2=A0 agcount=3D4, agsize=
=3D65536 blks<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =3D=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0sectsz=3D=
4096=C2=A0 attr=3D2, projid32bit=3D1<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0and also, now:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0# mkfs/mkfs.xfs -f -dfile,name=3Dfsfile,size=3D1g -=
b size=3D2048<br>
&gt;=C2=A0 =C2=A0 =C2=A0block size 2048 cannot be smaller than logical sect=
or size 4096<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0What prompted you to make this change, was there so=
me other problem you<br>
&gt;=C2=A0 =C2=A0 =C2=A0needed to fix?<br>
&gt;<br>
&gt;<br>
&gt; =E2=80=8BBut DIO is disabled for the files, per the commit message:<br=
>
&gt; [...] and turning off<br>
&gt; direct IO. Then ensure that we check the &quot;isfile&quot; options be=
fore<br>
&gt; doing things that are specific to block devices.=C2=A0 Also, as direct=
 IO<br>
&gt; is disabled for files, use statfs() for getting host FS blocksize,<br>
&gt; not platform_findsizes().=E2=80=8B<br>
<br>
</div></div>But doing DIO to the file during mkfs isn&#39;t the issue I&#39=
;m talking about;<br>
For example a vm image hosted in a file will have direct IO done to it<br>
when it is in use, and filesystem block size is not the controlling<br>
factor there.<br>
<br>
With your change, we can no longer make i.e. a 2k fs image hosted on a 4k<b=
r>
fs.=C2=A0 i.e. your change regresses this commit:<br>
<br>
commit 98dd72d3b239050138cf9eb9373c83743878a7d2<br>
Author: Eric Sandeen &lt;<a href=3D"mailto:sandeen@sandeen.net">sandeen@san=
deen.net</a>&gt;<br>
Date:=C2=A0 =C2=A0Fri Dec 18 12:15:25 2015 +1100<br>
<br>
=C2=A0 =C2=A0 mkfs: get sector size from host fs d_miniosz when mkfs&#39;in=
g file<br>
<br>
=C2=A0 =C2=A0 Now that we allow logical-sector-sized DIOs even if our xfs<b=
r>
=C2=A0 =C2=A0 filesystem is set to physical-sector-sized &quot;sectors,&quo=
t; we can<br>
=C2=A0 =C2=A0 allow the creation of filesystem images with block and sector=
<br>
=C2=A0 =C2=A0 sizes down to the host device&#39;s logical sector size, rath=
er<br>
=C2=A0 =C2=A0 than the filesystem&#39;s sector size.<br>
<br>
=C2=A0 =C2=A0 So in platform_findsizes(), change our query of the filesyste=
m<br>
=C2=A0 =C2=A0 to an XFS_IOC_DIOINFO query, and use the returned d_miniosz f=
or<br>
=C2=A0 =C2=A0 sector size in the S_IFREG case.<br>
<br>
=C2=A0 =C2=A0 This allows the creation of i.e. a 2k block sized image on<br=
>
=C2=A0 =C2=A0 an xfs filesystem w/ 4k sector size created on a 4k/512<br>
=C2=A0 =C2=A0 block device, which would otherwise fail today.<br>
<br>
=C2=A0 =C2=A0 Signed-off-by: Eric Sandeen &lt;<a href=3D"mailto:sandeen@red=
hat.com">sandeen@redhat.com</a>&gt;<br>
=C2=A0 =C2=A0 Reviewed-by: Dave Chinner &lt;<a href=3D"mailto:dchinner@redh=
at.com">dchinner@redhat.com</a>&gt;<br>
=C2=A0 =C2=A0 Signed-off-by: Dave Chinner &lt;<a href=3D"mailto:david@fromo=
rbit.com">david@fromorbit.com</a>&gt;<br>
<span class=3D""><br>
<br>
&gt; So we have to use whatever the underlying fs tells us, not what the ph=
ysical device has, right?<br>
<br>
</span>Well, tells us about what?=C2=A0 XFS can tell us its block size, but=
 also can<br>
tell us about minimum size and alignment required for direct IO, which is<b=
r>
more relevant to a filesystem image than the filesystem&#39;s block size.<b=
r>
<span class=3D""><br>
&gt; =E2=80=8B Rather, I wonder if there is any reason to keep the<br>
&gt; platform_findsizes part about regular files - it shouldn&#39;t get int=
o<br>
&gt; the branch ever.<br>
<br>
</span>In general, having a wrapper which finds sizes of a target, regardle=
ss of<br>
platform, device, or file, makes sense to me rather than having stat calls<=
br>
in various other places...<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Eric<br></font></span></blockquote><div><br></div><div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif;display:inline">I=
t seems I misunderstood some things about what =E2=80=8Bhappens/what should=
 happen with files. :-)</div></div><div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif;display:inline">I will see what =
happens with the tests, what difference in the results is with this patch i=
n the original version.</div></div></div><div class=3D"gmail_extra"><br></d=
iv><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-s=
erif">=E2=80=8BCheers,</div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif">Jan=E2=80=8B</div><br><br clear=3D"all"><div=
><br></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div=
 dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" t=
arget=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.m=
e" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--047d7b1637add1193e052ffb3f91--


--===============8027683467601773090==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8027683467601773090==--
