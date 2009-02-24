Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1OEt0gJ149592 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 08:55:01 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 246F81994715
	for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 06:54:29 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id K9mdEjxpbAB0fDWc for
	<xfs@oss.sgi.com>; Tue, 24 Feb 2009 06:54:29 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix parallel build failures in xfsprogs-3.0.0
Date: Tue, 24 Feb 2009 09:53:56 -0500
References: <200902240010.25434.vapier@gentoo.org>
	<200902240221.44184.vapier@gentoo.org>
	<20090224131523.GA1579@infradead.org>
In-Reply-To: <20090224131523.GA1579@infradead.org>
MIME-Version: 1.0
Message-Id: <200902240953.56992.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7532184661526168123=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

--===============7532184661526168123==
Content-Type: multipart/signed;
  boundary="nextPart3929187.qLK9l9TxEq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3929187.qLK9l9TxEq
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 24 February 2009 08:15:23 Christoph Hellwig wrote:
> On Tue, Feb 24, 2009 at 02:21:43AM -0500, Mike Frysinger wrote:
> > On Tuesday 24 February 2009 00:22:40 Eric Sandeen wrote:
> > > Mike Frysinger wrote:
> > > > i noticed that xfsprogs-3.0.0 sometimes fails to build in parallel
> > > > with an error about fsr not being able to find libhandle.  looking =
at
> > > > the top level Makefile shows the obvious missing depend (fsr:
> > > > libhandle). playing around a bit found a few more not so obvious
> > > > missing depends on the include subdir, so i fixed that too.
> > >
> > > Oh, can you resend with a formal Signed-off-by: line?  Being a little
> > > nitpicky here but we follow the same process as kernel patches.
> >
> > where is the git tree now ?  i tried git://oss.sgi.com/xfs-cmds but that
> > seems to be dead now.
>
> http://git.kernel.org/?p=3Dfs/xfs/xfsprogs-dev.git;a=3Dtree for the bleed=
ing
> edge development tree.

ok, so i'll base all my patches on the git trees that are available on=20
kernel.org.

the xfs.org wiki talks about git trees on sgi.com, but some of them are old=
=20
and/or moved (like the xfs-cmds one) ...
=2Dmike

--nextPart3929187.qLK9l9TxEq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJpAoEAAoJEEFjO5/oN/WBlyAP/jGYzsHnMzDQTFPuAUkJ8QOW
psHOfrmmuePqmZ2b9bmdsjfH6aN0ePM5grjQYbR0ODURi5a9AcDi5zGKQ9AvNHYF
jmlB5wU3c1Kg5VQrIrvPho/TSvySGasj7u7SS7lBnl1GLNaHFK29y+FzU2+b7J1q
tR7+FzRAM1gjRuy+z4VVibL/Bj9cDE2gSCGziCKZwhJ1U1/0M3GRhXUsOMgyn+BG
N5ilouiymnb5uStwI3qdAbP8eetxRIFnqQxA7feWmkuYqMmLHobbnCqh5oSPJgJD
halKWqfcDcSP2SGfo8Pvo2upRH2FXDUHub5r5EcvbGfTdsN2Sq7NSvhvCuGv4nYg
VFwMXMrOFn+iTlj87KabFhDxQvfPIZsWqIqP76DvD47w9FYD4vlErGNYZzoSx0Cz
LEqX/bjp2FwASzc/MkvbsdZjbHBQBzlL/wcO5qkDosAhkI8SHLgK91W7k7W9ysg8
IkELFCuHMjBhRP1H4byhFvH7WFqdaEWZPqVI4RtNM61QsDPnZFmt/Kjpf+S1qQ2a
bqsXFvWZkcCCR++Iu0V6iRty95sJ3tqlZ2lggt/rwN7PGtQYcciXXtalfnr8P+SE
RnYLqShgnxGYayD6aePt60DtgWo//IhjDYUiLgmV0OL9uCBIw3HUkqv6EwIVX4AG
Qmf4w41brj5GhQVtLR0H
=/jbx
-----END PGP SIGNATURE-----

--nextPart3929187.qLK9l9TxEq--


--===============7532184661526168123==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7532184661526168123==--
