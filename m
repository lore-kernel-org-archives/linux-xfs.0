Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0688Vk1036967 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 02:08:31 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 889F41D1162A
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 00:10:37 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id poyNH1PeJJC7pQKl for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 00:10:37 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs: add FITRIM support
Date: Thu, 6 Jan 2011 09:10:29 +0100
References: <20101125112304.GA4195@infradead.org> <201101052307.38379@zmi.at>
	<20110105225039.GD8322@dastard>
In-Reply-To: <20110105225039.GD8322@dastard>
MIME-Version: 1.0
Message-Id: <201101060910.34534@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7962816760921003483=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Lukas Czerner <lczerner@redhat.com>

--===============7962816760921003483==
Content-Type: multipart/signed;
  boundary="nextPart1403829.Rtha2R3Pyy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1403829.Rtha2R3Pyy
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 5. Januar 2011 Dave Chinner wrote:
> No state or additional on-disk
> structures are needed for xfs_fsr to do it's work....

That's not exactly the same - once you defraged a file, you know it's=20
done, and can skip it next time. But you dont know if the (free) space=20
between block 0 and 20 on disk has been rewritten since the last trim=20
run or not used at all, so you'd have to do it all again.
=20
> The background trim is intended to enable even the slowest of
> devices to be trimmed over time, while introducing as little runtime
> overhead and complexity as possible. Hence adding complexity and
> runtime overhead to optimise background trimming tends to defeat the
> primary design goal....

It would be interesting to have real world numbers to see what's "best".=20
I'd imagine a normal file or web server to store tons of files that are=20
mostly read-only, while 5% of it a used a lot, as well as lots of temp=20
files. For this, knowing what's been used would be great.

Also, I'm thinking of a NetApp storage, that has been setup to run=20
deduplication on Sunday. It's best to run trim on Saturday and it should=20
be finished before Sunday. For big storages that might be not easy to=20
finish, if all disk space has to be freed explicitly.

And wouldn't it still be cheaper to keep a "written bmap" than to run=20
over the full space of a (big) disk? I'd say depends on the workload.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1403829.Rtha2R3Pyy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0lePoACgkQzhSR9xwSCbQebgCcDqcuUK6zY0jqKc79Ruq8NkyP
jjcAoNlqZPJ4VrfwPol3WMRj14RSCr0P
=Z+Ew
-----END PGP SIGNATURE-----

--nextPart1403829.Rtha2R3Pyy--


--===============7962816760921003483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7962816760921003483==--
