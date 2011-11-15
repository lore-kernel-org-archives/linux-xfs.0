Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAF9ddhU040180 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 03:39:40 -0600
Received: from kenny.its.monash.edu.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85D491D9C776
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 01:39:38 -0800 (PST)
Received: from kenny.its.monash.edu.au (kenny.its.monash.edu.au
	[130.194.13.164]) by cuda.sgi.com with ESMTP id
	Gvcv0BRuTvYh6QHW for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 01:39:38 -0800 (PST)
Received: from chapman.its.monash.edu.au ([130.194.13.89])
	by kenny.its.monash.edu.au
	(Sun Java System Messaging Server 6.2-4.03 (built Sep 22 2005))
	with ESMTP id <0LUP00HFF4606B80@kenny.its.monash.edu.au> for
	xfs@oss.sgi.com; Tue, 15 Nov 2011 20:39:36 +1100 (EST)
Received: from chapman.its.monash.edu.au (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id DCD567E6149	for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 20:39:35 +1100 (EST)
Received: from mail-yw0-f54.google.com
	(mail-yw0-f54.google.com [209.85.213.54])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)	by chapman.its.monash.edu.au
	(Postfix) with ESMTPS id 05F5A7E6178	for <xfs@oss.sgi.com>; Tue,
	15 Nov 2011 20:39:34 +1100 (EST)
Received: by mail-yw0-f54.google.com with SMTP id 9so4146755ywe.41 for
	<xfs@oss.sgi.com>; Tue, 15 Nov 2011 01:39:34 -0800 (PST)
Date: Tue, 15 Nov 2011 20:39:33 +1100
From: Nathan Scott <nathans@debian.org>
Subject: [patch] xfsprogs - workaround debian build daemon dependency
	resolution
Message-id: <CAAp5ZgPntg0f+edJQFU8n0npBT1+46NqwwiUEtLXZPJoLwVL1g@mail.gmail.com>
MIME-version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0114555294732228947=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0114555294732228947==
Content-type: multipart/alternative; boundary=bcaec520e681d361fc04b1c2c32c

--bcaec520e681d361fc04b1c2c32c
Content-Type: text/plain; charset=ISO-8859-1

Workaround the Debian buildd dependency handling for libreadline5 library
handling

Evidently the buildd daemons process depenencies differently to local
builds, and
expect the first of optional dependencies to be resolved.  Flip the
ordering to match
this dependency.

Signed-off-by: Nathan Scott <nathans@debian.org>


diff --git a/debian/control b/debian/control
index f813a43..89f8c6e 100644
--- a/debian/control
+++ b/debian/control
@@ -4,6 +4,7 @@ Priority: optional
 Maintainer: XFS Development Team <xfs@oss.sgi.com>
 Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <
anibal@debian.org>
 Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool,
libreadline5-dev | libreadline-gplv2-dev, libblkid-dev (>= 2.17)
+Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool,
libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (>= 2.17)
 Standards-Version: 3.9.1
 Homepage: http://oss.sgi.com/projects/xfs/

--bcaec520e681d361fc04b1c2c32c
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Workaround the Debian buildd dependency handling for libreadline5 libr=
ary handling</div><div><br></div><div>Evidently the buildd daemons process =
depenencies differently to local builds, and</div><div>expect the first of =
optional dependencies to be resolved. =A0Flip the ordering to match</div>
<div>this dependency.</div><div><br></div><div>Signed-off-by: Nathan Scott =
&lt;<a href=3D"mailto:nathans@debian.org">nathans@debian.org</a>&gt;</div><=
div><div><br></div><div><br></div><div>diff --git a/debian/control b/debian=
/control</div>
<div>index f813a43..89f8c6e 100644</div><div>--- a/debian/control</div><div=
>+++ b/debian/control</div><div>@@ -4,6 +4,7 @@ Priority: optional</div><di=
v>=A0Maintainer: XFS Development Team &lt;<a href=3D"mailto:xfs@oss.sgi.com=
">xfs@oss.sgi.com</a>&gt;</div>
<div>=A0Uploaders: Nathan Scott &lt;<a href=3D"mailto:nathans@debian.org">n=
athans@debian.org</a>&gt;, Anibal Monsalve Salazar &lt;<a href=3D"mailto:an=
ibal@debian.org">anibal@debian.org</a>&gt;</div><div>=A0Build-Depends: uuid=
-dev, autoconf, debhelper (&gt;=3D 5), gettext, libtool, libreadline5-dev |=
 libreadline-gplv2-dev, libblkid-dev (&gt;=3D 2.17)</div>
<div>+Build-Depends: uuid-dev, autoconf, debhelper (&gt;=3D 5), gettext, li=
btool, libreadline-gplv2-dev | libreadline5-dev, libblkid-dev (&gt;=3D 2.17=
)</div><div>=A0Standards-Version: 3.9.1</div><div>=A0Homepage: <a href=3D"h=
ttp://oss.sgi.com/projects/xfs/">http://oss.sgi.com/projects/xfs/</a></div>
</div><div><br></div><div><br></div>

--bcaec520e681d361fc04b1c2c32c--


--===============0114555294732228947==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0114555294732228947==--
