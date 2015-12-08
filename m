Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CBE227F50
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 12:48:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A976B8F8037
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 10:48:52 -0800 (PST)
Received: from mail-ig0-f176.google.com (mail-ig0-f176.google.com
	[209.85.213.176]) by cuda.sgi.com with ESMTP id
	i0XMg0L9ARI0TFKS (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Dec 2015 10:48:51 -0800 (PST)
Received: by igbxm8 with SMTP id xm8so23733367igb.1
	for <xfs@oss.sgi.com>; Tue, 08 Dec 2015 10:48:51 -0800 (PST)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 8 Dec 2015 19:48:31 +0100
Message-ID: <CACj3i73f4_KZ8qUN4Gqz_bg3TCTbgdsg9PZ6UvMSRm+9JHN0JA@mail.gmail.com>
Subject: xfsprogs: Removal of trailing whitespaces
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6712468591874443249=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============6712468591874443249==
Content-Type: multipart/alternative; boundary=089e013c649eb62b860526676ca8

--089e013c649eb62b860526676ca8
Content-Type: text/plain; charset=UTF-8

Hi,

I decided to remove trailing whitespaces on various locations in the code
of xfsprogs, mainly because I have enabled highlighting of these, and they
were flashing into my eyes whenever I scrolled around. :-)

I looked for the last commit touching some of the lines with trailing
blanks and in all cases I found that the lines were last changed in 2011 or
earlier. Maybe there can be something newer, I didn't checked the story of
every one, but it seems that they are here for a long time, and will be
still if I don't remove them.

Right now, I have 14 patches, one for every tool/directory, where some
change occurred. About 140 lines changed in 52 files in total. I thought
that separating it this way makes for easier fix if it causes a conflict
with some other patch, however I can merge them into a single patch.

Should I send it separated as it is, or merge it into a single patch?

Cheers,
Jan

-- 
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e013c649eb62b860526676ca8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif">Hi,</div><div class=3D"gmail_default" style=3D"font-fam=
ily:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_default" styl=
e=3D"font-family:arial,helvetica,sans-serif">I decided to remove trailing w=
hitespaces on various locations in the code of xfsprogs, mainly because I h=
ave enabled highlighting of these, and they were flashing into my eyes when=
ever I scrolled around. :-)=C2=A0</div><div class=3D"gmail_default" style=
=3D"font-family:arial,helvetica,sans-serif"><br></div><div class=3D"gmail_d=
efault" style=3D"font-family:arial,helvetica,sans-serif"><div class=3D"gmai=
l_default">I looked for the last commit touching some of the lines with tra=
iling blanks and in all cases I found that the lines were last changed in 2=
011 or earlier. Maybe there can be something newer, I didn&#39;t checked th=
e story of every one, but it seems that they are here for a long time, and =
will be still if I don&#39;t remove them.=C2=A0</div><div><br></div></div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
">Right now, I have 14 patches, one for every tool/directory, where some ch=
ange occurred. About 140 lines changed in 52 files in total. I thought that=
 separating it this way makes for easier fix if it causes a conflict with s=
ome other patch, however I can merge them into a single patch.=C2=A0</div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
"><br></div><div class=3D"gmail_default" style=3D"font-family:arial,helveti=
ca,sans-serif">Should I send it separated as it is, or merge it into a sing=
le patch?</div><div class=3D"gmail_default" style=3D"font-family:arial,helv=
etica,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-fami=
ly:arial,helvetica,sans-serif">Cheers,</div><div class=3D"gmail_default" st=
yle=3D"font-family:arial,helvetica,sans-serif">Jan</div><div class=3D"gmail=
_default" style=3D"font-family:arial,helvetica,sans-serif"><br></div>-- <br=
><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div=
>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">=
jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_bla=
nk">jan@tulak.me</a></div></div></div></div>
</div>

--089e013c649eb62b860526676ca8--


--===============6712468591874443249==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6712468591874443249==--
