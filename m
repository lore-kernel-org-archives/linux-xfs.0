Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0V2cnLA059378 for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 20:38:49 -0600
Received: from mail-qy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3BA029D1DE
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 18:41:16 -0800 (PST)
Received: from mail-qy0-f181.google.com (mail-qy0-f181.google.com
	[209.85.216.181]) by cuda.sgi.com with ESMTP id
	XnsOhwCnmAGN33mv for <xfs@oss.sgi.com>;
	Sun, 30 Jan 2011 18:41:16 -0800 (PST)
Received: by qyk12 with SMTP id 12so5613782qyk.5
	for <xfs@oss.sgi.com>; Sun, 30 Jan 2011 18:41:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimoZE8kD2Qz+ynZhceGuHqZxe9VSHKXho_tbdWi@mail.gmail.com>
References: <AANLkTimoZE8kD2Qz+ynZhceGuHqZxe9VSHKXho_tbdWi@mail.gmail.com>
Date: Mon, 31 Jan 2011 11:41:16 +0900
Message-ID: <AANLkTikyOfkbtxN3Et5YZRJ2rPpdsVouJkyRW4fDbUG7@mail.gmail.com>
Subject: Re: [patch] xfsprogs: repair never return if device removed
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1633251768088387584=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1633251768088387584==
Content-Type: multipart/alternative; boundary=00163646db8295ce3d049b1b5948

--00163646db8295ce3d049b1b5948
Content-Type: text/plain; charset=ISO-8859-1

I did not receive and response / reviews on patch.

diff -Nurp xfsprogs/repair/sb.c xfsprogs-dirty/repair/sb.c

--- xfsprogs/repair/sb.c 2011-01-28 20:23:02.000000000 +0900

+++ xfsprogs-dirty/repair/sb.c 2011-01-28 20:21:06.000000000 +0900

@@ -122,8 +122,9 @@ find_secondary_sb(xfs_sb_t *rsb)

done = 1;

}

- if (!done && (bsize = read(x.dfd, sb, BSIZE)) == 0) {

+ if (!done && (bsize = read(x.dfd, sb, BSIZE)) <= 0) {

done = 1;

+ do_warn(_("Couldn't find candidate secondary superblock, exiting...\n"));

}

do_warn(".");

On Fri, Jan 28, 2011 at 8:31 PM, Ajeet Yadav <ajeet.yadav.77@gmail.com>wrote:

> xfsprogs all version, delete primary superblock of xfs partition
>
> dd if=/dev/zero of=/dev/sda1 bs=512 count=1
> sync
>
> Run xfs_repair in partition, while its searching for secondary superblock,
> remove the disk (USB) xfs_repair will never exit and will loop in never
> ending ............
>
> Please find patch attached with mail
>

--00163646db8295ce3d049b1b5948
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>I did not receive and response / reviews on patch.</div>
<div><span lang=3D"EN">
<p>diff -Nurp xfsprogs/repair/sb.c xfsprogs-dirty/repair/sb.c</p>
<p>--- xfsprogs/repair/sb.c 2011-01-28 20:23:02.000000000 +0900</p>
<p>+++ xfsprogs-dirty/repair/sb.c 2011-01-28 20:21:06.000000000 +0900</p>
<p>@@ -122,8 +122,9 @@ find_secondary_sb(xfs_sb_t *rsb)</p>
<p>done =3D 1;</p>
<p>}</p>
<p></p>
<p>- if (!done &amp;&amp; (bsize =3D read(x.dfd, sb, BSIZE)) =3D=3D 0) {</p=
>
<p>+ if (!done &amp;&amp; (bsize =3D read(x.dfd, sb, BSIZE)) &lt;=3D 0) {</=
p>
<p>done =3D 1;</p>
<p>+ do_warn(_(&quot;Couldn&#39;t find candidate secondary superblock, exit=
ing...\n&quot;));</p>
<p>}</p>
<p></p>
<p>do_warn(&quot;.&quot;);</p></span><br>On Fri, Jan 28, 2011 at 8:31 PM, A=
jeet Yadav <span dir=3D"ltr">&lt;<a href=3D"mailto:ajeet.yadav.77@gmail.com=
">ajeet.yadav.77@gmail.com</a>&gt;</span> wrote:<br></div>
<div class=3D"gmail_quote">
<blockquote style=3D"BORDER-LEFT: #ccc 1px solid; MARGIN: 0px 0px 0px 0.8ex=
; PADDING-LEFT: 1ex" class=3D"gmail_quote">
<div>xfsprogs all version, delete primary superblock of xfs partition</div>
<div>=A0</div>
<div>dd if=3D/dev/zero of=3D/dev/sda1 bs=3D512 count=3D1</div>
<div>sync</div>
<div>=A0</div>
<div>Run xfs_repair in partition, while its searching for secondary superbl=
ock, remove the disk (USB) xfs_repair will never exit and will loop in neve=
r ending ............</div>
<div>=A0</div>
<div>Please find patch attached with mail</div></blockquote></div><br>

--00163646db8295ce3d049b1b5948--


--===============1633251768088387584==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1633251768088387584==--
