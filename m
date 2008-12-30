Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUE86hl018283 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 08:08:07 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0948A51EED
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 06:08:04 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id FgExX6twhb3JNoNc for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 06:08:04 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] xfs-cmds: fix parallel installs in include/ dirs
Date: Tue, 30 Dec 2008 09:07:30 -0500
References: <49594CD9.3010402@sandeen.net>
	<20081230115224.GA24210@infradead.org>
	<20081230124936.GA26322@infradead.org>
In-Reply-To: <20081230124936.GA26322@infradead.org>
MIME-Version: 1.0
Message-Id: <200812300907.31459.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8966207423978649929=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============8966207423978649929==
Content-Type: multipart/signed;
  boundary="nextPart1970246.qyBhUC4vSn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1970246.qyBhUC4vSn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 30 December 2008 07:49:36 Christoph Hellwig wrote:
> On Tue, Dec 30, 2008 at 06:52:24AM -0500, Christoph Hellwig wrote:
> > On Mon, Dec 29, 2008 at 04:19:05PM -0600, Eric Sandeen wrote:
> > > This is for http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D759
> > > "fix parallel issue with include/ symlinks"
> > >
> > > Doing something like "make -j2 install install-dev" would lead
> > > to a race of removing & creating symlinks in include/
> > >
> > > Thanks to Mike for reporting & suggesting the fix.
> >
> > Looks good and I've put in in my queue.
>
> Actually spoken too soon.   This breaks the acl build for me with:
>
>  gcc -g -O2 -DNDEBUG -funsigned-char -fno-strict-aliasing -Wall
>  -DVERSION=3D\"2.2.47\" -DLOCALEDIR=3D\"/usr/share/locale\"
>  -DPACKAGE=3D\"acl\" -I../include -D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64
>  -include perm_copy.h -c acl_get_fd.c  -fPIC -DPIC -o .libs/acl_get_fd.o
>  acl_get_fd.c:27:24: error: acl/libacl.h: No such file or directory
>  acl_get_fd.c: In function 'acl_get_fd':
>  acl_get_fd.c:62: warning: implicit declaration of function
>  'acl_from_mode'
>  acl_get_fd.c:62: warning: return makes pointer from integer without a
>  cast
>
> It looks like the acl link in include/ doesn't get created properly
> with this patch.

acl-2.2.47 built fine for me with `./configure && make` and this patch ...

that said, if the only purpose of this is to make sure there are symlinks i=
n=20
include/, why not do it at the tail end of configure ?  then there will be =
no=20
weird parallel magic to worry about, and everything will always be availabl=
e=20
once configure has finished.
-mike

--nextPart1970246.qyBhUC4vSn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWisjAAoJEEFjO5/oN/WBcWYP/01WT05fKKeyMNDfGP0jFkLP
iTX6idpM966Tw4tJvo6i6gQDXGvTPKkZY9MpjyjHRODEv73weRYr1hO6PLcPZhzG
FOW0SIgIt4QxGH0S7LpZkEtTkwsri1/QLQL5fw7TDCJ8bLgQpvEsABh9AzTqmXvU
lXThsXGYepFAUTSDVl7j3hIKlqrcRaOzfOYwPzEXWWCvgZ+S2dRxAVE2hqTOPrrN
SEf2mj4OPoWA8swX2XSzfoDrdfI1EckVkvePoDQXljflR0aAbOol9S6vJDXb/7fv
1UGYql0MEWBHS+YgJOtUaIobrvNy+xwHvnvRVnxNsbGcFzsbKXSnNfMQr6yn7c0J
6yCMvWtp8T7+4m8+lYZpDAllFUxlQ831Jx7Oqks1W5B7UbnqXIHRAFO40Xfqtme+
Em1yIoxebRlXUAP9JVXM4hzTEv0okCaag36u9hzb/l+J/6SKwWOeQUDCOJH+FtkK
2zp9jIiuClirh2qf/38alMzQTvglS3+p1+pWWqR5W4hvfPs9JX54jfv7iU1YFgES
OUBtj5maoTKkSxAeayqsSwPjHMCPy8xxzSzlWMjyXiiyVTDSdSkg70bzcXPZ4jfV
RJo0nK5a20DJfjeodPZLE/Zwnk75wuCaOXCpKDxsSXCnPGFBuIAPPPYzKW4LO33v
u5orxIlOtXuochGllN89
=zBn6
-----END PGP SIGNATURE-----

--nextPart1970246.qyBhUC4vSn--


--===============8966207423978649929==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8966207423978649929==--
