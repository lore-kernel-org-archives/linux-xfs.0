Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1AB627CA7
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 11:23:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E044AC003
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:23:45 -0700 (PDT)
Received: from mail-ig0-f181.google.com (mail-ig0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	qPGonS4L1mkq9Gmw (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:23:41 -0700 (PDT)
Received: by mail-ig0-f181.google.com with SMTP id f1so124781250igr.1
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 09:23:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570E7129.3080900@sandeen.net>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-18-git-send-email-jtulak@redhat.com>
	<20160408000910.GB21804@dastard>
	<CACj3i73f_v=70pGrrLkRpHB-6UwiOOM2F9Sbu2aZMaJGmBLeiQ@mail.gmail.com>
	<20160408230843.GE567@dastard>
	<CACj3i71Grs8deYRtTaGmTmgBTrge-VKQKpn1Azj_y8=KQHWbgg@mail.gmail.com>
	<570E7129.3080900@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Wed, 13 Apr 2016 18:23:21 +0200
Message-ID: <CACj3i722SbMYzPG9KR6QJJsTVs2Nju6csGKF=+f+PYjbHPYYQA@mail.gmail.com>
Subject: Re: [PATCH 17/19] xfsprogs: disable truncating of files
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8429731991127948273=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============8429731991127948273==
Content-Type: multipart/alternative; boundary=047d7b1637ad61cda40530603377

--047d7b1637ad61cda40530603377
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 13, 2016 at 6:17 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 4/13/16 10:08 AM, Jan Tulak wrote:
>
> ...
>
> > All right=E2=80=8B, I will keep the O_TRUNC there. However, should it
> > truncate the file every time, or should we offer a way how to avoid
> > the file truncating? Until now, mkfs behaved differently based on
> > whether -d file was given, or not. Your explanation suggests that we
> > should truncate every time, right?
>
> There are probably valid reasons to keep size as well as to truncate;
> it's not immediately clear to me how we should handle it.
>
> Honestly, at this point, in the interest of getting the other fixes in,
> I think I might rather see the truncating behavior unchanged from what
> we have today; we can tackle that as a separate problem at a later date.
>
> What do you think?
>
> =E2=80=8BFor keeping the size, the easiest way might be to implicitly set=
 xi.dsize
(or whatever) to the current size. Of course, after a check for -d
file,name,size combo. AFAIK (without looking to the code, I'm just ending
for today and in the middle of shutting everything down :-) ), we =E2=80=8B=
do the
truncation after the combo check. So this should be no big issue... I will
look on this tomorrow, to know better.

Cheers,
Jan



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7b1637ad61cda40530603377
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Wed, Apr 13, 2016 at 6:17 PM, Eric Sandeen <span dir=3D"ltr=
">&lt;<a href=3D"mailto:sandeen@sandeen.net" target=3D"_blank">sandeen@sand=
een.net</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,2=
04,204);border-left-style:solid;padding-left:1ex">On 4/13/16 10:08 AM, Jan =
Tulak wrote:<br>
<br>
...<br>
<span><br>
&gt; All right=E2=80=8B, I will keep the O_TRUNC there. However, should it<=
br>
&gt; truncate the file every time, or should we offer a way how to avoid<br=
>
&gt; the file truncating? Until now, mkfs behaved differently based on<br>
&gt; whether -d file was given, or not. Your explanation suggests that we<b=
r>
&gt; should truncate every time, right?<br>
<br>
</span>There are probably valid reasons to keep size as well as to truncate=
;<br>
it&#39;s not immediately clear to me how we should handle it.<br>
<br>
Honestly, at this point, in the interest of getting the other fixes in,<br>
I think I might rather see the truncating behavior unchanged from what<br>
we have today; we can tackle that as a separate problem at a later date.<br=
>
<br>
What do you think?<br>
<br></blockquote><div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif">=E2=80=8BFor keeping the size, the easiest way mig=
ht be to implicitly set xi.dsize (or whatever) to the current size. Of cour=
se, after a check for -d file,name,size combo. AFAIK (without looking to th=
e code, I&#39;m just ending for today and in the middle of shutting everyth=
ing down :-) ), we =E2=80=8Bdo the truncation after=C2=A0<span style=3D"col=
or:rgb(80,0,80);font-size:12.8px;font-family:arial,sans-serif">the combo ch=
eck. So this should be no big issue... I will look on this tomorrow, to kno=
w better.</span></div><div class=3D"gmail_default" style=3D"font-family:ari=
al,helvetica,sans-serif"><span style=3D"color:rgb(80,0,80);font-size:12.8px=
;font-family:arial,sans-serif"><br></span></div><div class=3D"gmail_default=
" style=3D"font-family:arial,helvetica,sans-serif"><span style=3D"color:rgb=
(80,0,80);font-size:12.8px;font-family:arial,sans-serif">Cheers,</span></di=
v><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-se=
rif"><span style=3D"color:rgb(80,0,80);font-size:12.8px;font-family:arial,s=
ans-serif">Jan</span></div><br></div><div><br></div></div><div><br></div>--=
 <br><div><div dir=3D"ltr"><div><div dir=3D"ltr"><div>Jan Tulak<br></div><a=
 href=3D"mailto:jtulak@redhat.com" target=3D"_blank">jtulak@redhat.com</a>=
=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_blank">jan@tulak.me</a><=
/div></div></div></div>
</div></div>

--047d7b1637ad61cda40530603377--


--===============8429731991127948273==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8429731991127948273==--
