Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A49007CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 07:32:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6C1548F8037
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:32:14 -0700 (PDT)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com
	[209.85.223.181]) by cuda.sgi.com with ESMTP id
	VSDMizPDLLRzTtIC (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:32:13 -0700 (PDT)
Received: by mail-io0-f181.google.com with SMTP id 2so101756547ioy.1
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:32:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160413213758.GR567@dastard>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<20160408000910.GB21804@dastard>
	<CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
	<20160408230843.GE567@dastard>
	<CACj3i71Grs8deYRtTaGmTmgBTrge-VKQKpn1Azj_y8=KQHWbgg@mail.gmail.com>
	<570E7129.3080900@sandeen.net> <20160413213758.GR567@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 14 Apr 2016 14:31:53 +0200
Message-ID: <CACj3i73tr1jY8ZQkunyCtRTzYezZyDHcxpFcf3WJpbffWd_h4g@mail.gmail.com>
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0959078317471419951=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============0959078317471419951==
Content-Type: multipart/alternative; boundary=001a113eb35e6eb75705307115b3

--001a113eb35e6eb75705307115b3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2016 at 11:37 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Apr 13, 2016 at 11:17:45AM -0500, Eric Sandeen wrote:
> > On 4/13/16 10:08 AM, Jan Tulak wrote:
> >
> > ...
> >
> > > All right=E2=80=8B, I will keep the O_TRUNC there. However, should it
> > > truncate the file every time, or should we offer a way how to avoid
> > > the file truncating? Until now, mkfs behaved differently based on
> > > whether -d file was given, or not. Your explanation suggests that we
> > > should truncate every time, right?
> >
> > There are probably valid reasons to keep size as well as to truncate;
> > it's not immediately clear to me how we should handle it.
>
> That's easy: don't specify -dfile or -dsize, and instead let mkfs
> detect that it is file automatically. Because it's not given a size,
> or that it's supposed to be a file, it should not attempt to change
> the "device" in any way.
>
> When block devices grow fallocate support, we can unify the discard
> behaviour to be a hole punch, and then it will work identically on
> devices and files treated this way.
>
> > Honestly, at this point, in the interest of getting the other fixes in,
> > I think I might rather see the truncating behavior unchanged from what
> > we have today; we can tackle that as a separate problem at a later date=
.
>
> Yup, don't change it in this patch series.
>
>
Looking on this patch again, I think that it can be removed entirely. After
reverting the O_CREATE part, the only thing it does is differentiating
error messages between files and block devices, which is not worth of a
patch.

Cheers,
Jan

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--001a113eb35e6eb75705307115b3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><span style=3D"font-family:arial,sans-serif">On Wed, Ap=
r 13, 2016 at 11:37 PM, Dave Chinner </span><span dir=3D"ltr" style=3D"font=
-family:arial,sans-serif">&lt;<a href=3D"mailto:david@fromorbit.com" target=
=3D"_blank">david@fromorbit.com</a>&gt;</span><span style=3D"font-family:ar=
ial,sans-serif"> wrote:</span><br></div><div class=3D"gmail_extra"><div cla=
ss=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 =
.8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Wed, =
Apr 13, 2016 at 11:17:45AM -0500, Eric Sandeen wrote:<br>
&gt; On 4/13/16 10:08 AM, Jan Tulak wrote:<br>
&gt;<br>
&gt; ...<br>
&gt;<br>
&gt; &gt; All right=E2=80=8B, I will keep the O_TRUNC there. However, shoul=
d it<br>
&gt; &gt; truncate the file every time, or should we offer a way how to avo=
id<br>
&gt; &gt; the file truncating? Until now, mkfs behaved differently based on=
<br>
&gt; &gt; whether -d file was given, or not. Your explanation suggests that=
 we<br>
&gt; &gt; should truncate every time, right?<br>
&gt;<br>
&gt; There are probably valid reasons to keep size as well as to truncate;<=
br>
&gt; it&#39;s not immediately clear to me how we should handle it.<br>
<br>
</span>That&#39;s easy: don&#39;t specify -dfile or -dsize, and instead let=
 mkfs<br>
detect that it is file automatically. Because it&#39;s not given a size,<br=
>
or that it&#39;s supposed to be a file, it should not attempt to change<br>
the &quot;device&quot; in any way.<br>
<br>
When block devices grow fallocate support, we can unify the discard<br>
behaviour to be a hole punch, and then it will work identically on<br>
devices and files treated this way.<br>
<span class=3D""><br>
&gt; Honestly, at this point, in the interest of getting the other fixes in=
,<br>
&gt; I think I might rather see the truncating behavior unchanged from what=
<br>
&gt; we have today; we can tackle that as a separate problem at a later dat=
e.<br>
<br>
</span>Yup, don&#39;t change it in this patch series.<br>
<span class=3D"im HOEnZb"><br></span></blockquote><div><br></div><div><div =
class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;dis=
play:inline">Looking on this patch again, I think that it can be removed en=
tirely. After reverting the O_CREATE part, the only thing it does is differ=
entiating error messages between files and block devices, which is not wort=
h of a patch.</div></div><div><div class=3D"gmail_default" style=3D"font-fa=
mily:arial,helvetica,sans-serif;display:inline"><br></div></div><div><div c=
lass=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;disp=
lay:inline">Cheers,</div></div><div><div class=3D"gmail_default" style=3D"f=
ont-family:arial,helvetica,sans-serif;display:inline">Jan</div></div></div>=
<div><br></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div>=
<div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.co=
m" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tul=
ak.me" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--001a113eb35e6eb75705307115b3--


--===============0959078317471419951==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0959078317471419951==--
