Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G7WGGc075664 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:32:37 -0500
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BEA8519BF32
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 00:31:55 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id 5H5bCayR0BIi2afN for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 00:31:55 -0700 (PDT)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Mon, 16 Mar 2009 03:31:48 -0400
References: <200902240010.25434.vapier@gentoo.org>
	<200903101741.07043.agruen@suse.de>
	<20090316070550.GA628@infradead.org>
In-Reply-To: <20090316070550.GA628@infradead.org>
MIME-Version: 1.0
Message-Id: <200903160331.53142.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5587186754700004914=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>, Eric Sandeen <sandeen@sandeen.net>

--===============5587186754700004914==
Content-Type: multipart/signed;
  boundary="nextPart3454592.GTvVCzAhX9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3454592.GTvVCzAhX9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 16 March 2009 03:05:50 Christoph Hellwig wrote:
> On Tue, Mar 10, 2009 at 05:41:06PM +0100, Andreas Gruenbacher wrote:
> > As it turns out, I was running into more trouble with libtoolize from
> > libtool 2.2.6. See this commit in attr.git:
> >
> >   commit 604290f79a199eb0c73a0cd05a473e1801a00673
> >   Author: Andreas Gruenbacher <agruen@suse.de>
> >   Date:   Tue Mar 10 17:00:35 2009 +0100
> >
> >     More libtoolize fixes
>
> That patch breaks the commit for me:
>
> hch@brick:~/work/attr$ make
> libtoolize -c -i -f
> libtoolize: unrecognized option `-i'
> Try `libtoolize --help' for more information.
> make: *** [include/builddefs] Error 1

-i is new to libtool-2

usually what i do is something like:
args=
libtoolize -n --install 2>/dev/null && args="-i"
libtoolize -c -f $args
-mike

--nextPart3454592.GTvVCzAhX9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJvgBpAAoJEEFjO5/oN/WBZqkP/1b9jQbhXd8Kg+Xo33BxkODR
dTRDF95ejmwIZCkhSy2wyiyEvfCZd6c0JRtmnSXZVvN6dkAfhOh3jMTc4wjRgkMv
+1mR+D1RybB6AM/tKw7w9oOIYwrYX54LsVl0Jo+kRMijXRY9wfPFoe28fUo4U87/
yKy029i4j8YVEW2oj5gPyDJAO+LVQE1sraCAfnqfwoO5NZ6E2pZVjpFV8atW7bwr
7ZKm9kbaZf92LECqPDGfc0ZHjozZDMOwkzGN071QYH+EUOI9oLT3cFBgs93DY4ya
GaDJXA2NOflkis6vYDXZMVW+kshapu1rGLK9RthELV8G3IeuQBXZinPa134zigQt
deqAmS7nGbw+cMp9eVE/vDWRkEo7BDXVvELC/E3miPZHrA5rLJGJymcLxoa7ebOI
DN+VbfjZiVrtL2HY/0qAQX3opROpw3X/c/tbWTEEZKHMvKuFgS7nSplcNDAcs4uH
dKuuIzKmRQ76TAaUkli0gIoOrFEglYYZLnQ1ZPYIH/O+T/w+D7TCvD0PXjPdwvRJ
MdQAHtj0Guk4yeX9AI5m3DT9yrZIsu2MsTeJXVgb3AwIFMm+fhizl3v8uQMK4oRU
SaEWDy/ZbCHbcri28QSUEmoEmSrOe3QXj9ZKjgMzNnjwA0zPIQ0IJRdpT5HbEamj
rrTxfSiDWIS5BO5R5xG8
=Lo6q
-----END PGP SIGNATURE-----

--nextPart3454592.GTvVCzAhX9--


--===============5587186754700004914==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5587186754700004914==--
