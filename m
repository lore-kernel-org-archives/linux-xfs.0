Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUKJkAT027644 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 14:19:48 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4BD151798351
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 12:19:44 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id iWVNFQ6PcwJA5lUh for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 12:19:44 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] xfs-cmds: fix parallel installs in include/ dirs
Date: Tue, 30 Dec 2008 15:19:41 -0500
References: <49594CD9.3010402@sandeen.net>
	<200812300907.31459.vapier@gentoo.org>
	<20081230171825.GA31624@infradead.org>
In-Reply-To: <20081230171825.GA31624@infradead.org>
MIME-Version: 1.0
Message-Id: <200812301519.42689.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4893403734875291639=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============4893403734875291639==
Content-Type: multipart/signed;
  boundary="nextPart3237594.85lKKOtpmi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3237594.85lKKOtpmi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 30 December 2008 12:18:25 Christoph Hellwig wrote:
> On Tue, Dec 30, 2008 at 09:07:30AM -0500, Mike Frysinger wrote:
> > acl-2.2.47 built fine for me with `./configure && make` and this patch
> > ...
>
> Works now after a make distclean for me.
>
> > that said, if the only purpose of this is to make sure there are symlin=
ks
> > in include/, why not do it at the tail end of configure ?  then there
> > will be no weird parallel magic to worry about, and everything will
> > always be available once configure has finished.
>
> I'll leave that to Eric or anyone else who wants to play a build system
> expert on TV :)

it's easy to do, i just dont know how people feel about the idea in general
diff --git a/configure.in b/configure.in
index 3c46c49..d227630 100644
--- a/configure.in
+++ b/configure.in
@@ -27,4 +27,11 @@ AC_MANUAL_FORMAT
=20
 AC_FUNC_GCC_VISIBILITY
=20
-AC_OUTPUT(include/builddefs)
+AC_CONFIG_FILES(include/builddefs)
+AC_CONFIG_COMMANDS([include-symlinks], [
+	rm -f include/acl include/sys
+	ln -s . include/acl
+	ln -s . include/sys
+])
+AC_OUTPUT
+
diff --git a/include/Makefile b/include/Makefile
index f2eca14..d606fa2 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -10,13 +10,10 @@ LSRCFILES =3D builddefs.in buildmacros buildrules=20
config.h.in
 LDIRT =3D sys acl
=20
 default:
-	rm -f sys acl
-	$(LN_S) . sys
-	$(LN_S) . acl
=20
 include $(BUILDRULES)
=20
-install-dev: default
+install-dev:
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)/sys
 	$(INSTALL) -m 644 acl.h $(PKG_INC_DIR)/sys/acl.h
-mike

--nextPart3237594.85lKKOtpmi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWoJeAAoJEEFjO5/oN/WBIOQP/ib4SJdmQnZExTTbUvBrKPkw
KQx6BFj3/3aAgk3PRJn0uyqFQL1eyuTMbhdtosbS9sRlAxovSB+nB04JxLlN17DL
HfaneSjK2QtZgnhHSD+kZdYqtdOPi55gLB5DxCp4Dx+HvoowtpxIBYGrLWRlez3X
eX3MnAC8tTuB+djg1orp3fO+4Mu278SKt3/YnjjWY1UtczZx8CESLlnNYXYEpy0Q
DCyHmv7/vMtxfi3NjBTF8lRI4aYtI+n1xl/RflwyacutdhYnx02jfMoe0NMFBpcD
yffZJq+MUdPZgpdn42Fuuxh+iqBkQ6DWCYgYoQ5WYjxuNtlmJ0WhMSocnQEfnKsZ
DlUD+jL1vXRb6G5BuK/nz6+Kfc5Vdh2L7LjvSjvEYGabwU0zkoVJFKxRVdd/aajd
YqTN7IqZBP1diO1lDXWdWNOdfM+QX010DraqhAX55UFhVX/lfzKkX+XUDx7K3Kcr
fQLOcIF8gLolc2zKeVncXzQ6w6Mcmu3Q56FXMpITrrfngW6Va9VSSF9KOm5K7vPU
h3fPwawOdr0nSkDd627klhxNRRUre29qvxE3Tmgip0xKt58ZnbEnSeAwytevMsxN
m0ECu10s9XVs95Q2JuK1B3xqYwuUhxSJUBkbq335wT8DHltjRzzS+oT8AcYK/rR7
OfnDawQe570a/qjaiMWk
=aipB
-----END PGP SIGNATURE-----

--nextPart3237594.85lKKOtpmi--


--===============4893403734875291639==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4893403734875291639==--
