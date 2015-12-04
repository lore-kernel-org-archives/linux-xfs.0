Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 853457F37
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 06:20:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 75362304048
	for <xfs@oss.sgi.com>; Fri,  4 Dec 2015 04:20:47 -0800 (PST)
Received: from mail-ig0-f181.google.com (mail-ig0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	VhtzG15y46jvgC9s (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Dec 2015 04:20:46 -0800 (PST)
Received: by igcto18 with SMTP id to18so34534676igc.0
	for <xfs@oss.sgi.com>; Fri, 04 Dec 2015 04:20:46 -0800 (PST)
MIME-Version: 1.0
From: Jan Tulak <jtulak@redhat.com>
Date: Fri, 4 Dec 2015 13:20:26 +0100
Message-ID: <CACj3i71kgpqNvg0ru=-4x6gtJ8faOVn-P=y_AM+xwoKbm-55tQ@mail.gmail.com>
Subject: Is test xfs/096 correct?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7674721886286249985=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

--===============7674721886286249985==
Content-Type: multipart/alternative; boundary=047d7b10cd6b73156b0526118920

--047d7b10cd6b73156b0526118920
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi.

I'm looking on test xfs/096 and I'm not sure if I got it right:

"test out mkfs_xfs output on IRIX/Linux and some of its error handling,
ensure pv#920679 is addressed" - this, and things like "$max_lr_size +
4096" all looks like mkfs should be catching invalid input. Yet the .out
file instead looks like it should create the FS correctly (it contains the
created fs stats instead of mkfs's usage and some error).

So either I'm reading the test wrong, or the patch approves invalid
behaviour. I hit this test because when I added a stricter input
validation, this patch started to fail as mkfs is now refusing to create
the fs with these arguments.

BTW: I tried to look for the mentioned pv number, but didn't found it -
where should I look further?
=E2=80=8BCheers
Jan=E2=80=8B

--=20
Jan Tulak
jtulak@redhat.com / jan@tulak.me

--047d7b10cd6b73156b0526118920
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:arial,he=
lvetica,sans-serif">







<p class=3D"">Hi.</p><p class=3D"">I&#39;m looking on test xfs/096 and I&#3=
9;m not sure if I got it right:</p><p class=3D"">&quot;test out mkfs_xfs ou=
tput on IRIX/Linux and some of its error handling, ensure pv#920679 is addr=
essed&quot; - this, and things like &quot;$max_lr_size + 4096&quot; all loo=
ks like mkfs should be catching invalid input. Yet the .out file instead lo=
oks like it should create the FS correctly (it contains the created fs stat=
s instead of mkfs&#39;s usage and some error).</p>
<p class=3D"">So either I&#39;m reading the test wrong, or the patch approv=
es invalid behaviour. I hit this test because when I added a stricter input=
 validation, this patch started to fail as mkfs is now refusing to create t=
he fs with these arguments.</p><p class=3D"">BTW: I tried to look for the m=
entioned pv number, but didn&#39;t found it - where should I look further?<=
/p></div><div><div class=3D"gmail_default" style=3D"font-family:arial,helve=
tica,sans-serif">=E2=80=8BCheers</div><div class=3D"gmail_default" style=3D=
"font-family:arial,helvetica,sans-serif">Jan=E2=80=8B</div><br></div>-- <br=
><div class=3D"gmail_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div=
>Jan Tulak<br></div><a href=3D"mailto:jtulak@redhat.com" target=3D"_blank">=
jtulak@redhat.com</a>=C2=A0/ <a href=3D"mailto:jan@tulak.me" target=3D"_bla=
nk">jan@tulak.me</a></div></div></div></div>
</div>

--047d7b10cd6b73156b0526118920--


--===============7674721886286249985==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7674721886286249985==--
