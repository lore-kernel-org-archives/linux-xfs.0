Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F33F17F37
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 03:46:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF4E9304039
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 01:46:03 -0700 (PDT)
Received: from mail-ig0-f179.google.com (mail-ig0-f179.google.com
	[209.85.213.179]) by cuda.sgi.com with ESMTP id
	Rzsfz19XWeeto1vn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 01:46:02 -0700 (PDT)
Received: by igbni9 with SMTP id ni9so53117654igb.1
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 01:46:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151013045442.GG31326@dastard>
References: <1442311164-12921-13-git-send-email-jtulak@redhat.com>
	<1443542653-10525-1-git-send-email-jtulak@redhat.com>
	<20151013045442.GG31326@dastard>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 13 Oct 2015 10:45:42 +0200
Message-ID: <CACj3i71BHhH_DJ=pQjVepT1pKGE63iWQeXFUwhLQMvmULojx8w@mail.gmail.com>
Subject: Re: [PATCH 12/14 v2] xfsprogs: make fsr use mntinfo when there is no
	mntent
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5462867050285372457=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============5462867050285372457==
Content-Type: multipart/alternative; boundary=089e013cc168c57df20521f879a3

--089e013cc168c57df20521f879a3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 13, 2015 at 6:54 AM, Dave Chinner <david@fromorbit.com> wrote:
>
> this stuff here. This iteration should be able to be done via the
> cursor abstraction, such as by keeping the iteration information
> within the cursor...
>
> =E2=80=8BAh, sorry! I forgot to change the other #if...

=E2=80=8BFixing it right now.

Cheers,
Jan=E2=80=8B



--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--089e013cc168c57df20521f879a3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif"><br></div><div class=3D"gmail_extra"><br><div class=3D"=
gmail_quote">On Tue, Oct 13, 2015 at 6:54 AM, Dave Chinner <span dir=3D"ltr=
">&lt;<a href=3D"mailto:david@fromorbit.com" target=3D"_blank">david@fromor=
bit.com</a>&gt;</span> wrote:<blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">this stuff here=
. This iteration should be able to be done via the<br>
cursor abstraction, such as by keeping the iteration information<br>
within the cursor...<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br></div></div></blockquote><div><=
div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif=
;display:inline">=E2=80=8BAh, sorry! I forgot to change the other #if...</d=
iv>=C2=A0<div class=3D"gmail_default" style=3D"font-family:arial,helvetica,=
sans-serif;display:inline">=E2=80=8BFixing it right now.</div></div><div><d=
iv class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-serif;=
display:inline"><br></div></div><div><div class=3D"gmail_default" style=3D"=
font-family:arial,helvetica,sans-serif;display:inline">Cheers,</div></div><=
div><div class=3D"gmail_default" style=3D"font-family:arial,helvetica,sans-=
serif;display:inline">Jan=E2=80=8B</div></div></div><br><br clear=3D"all"><=
div><br></div>-- <br><div class=3D"gmail_signature"><div dir=3D"ltr"><div><=
div dir=3D"ltr"><div>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com=
" target=3D"_blank">jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tula=
k.me" target=3D"_blank">jan@tulak.me</a></div></div></div></div>
</div></div>

--089e013cc168c57df20521f879a3--


--===============5462867050285372457==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5462867050285372457==--
