Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p79AAup4086621 for <xfs@oss.sgi.com>; Tue, 9 Aug 2011 05:10:56 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 928A1151EA0F
	for <xfs@oss.sgi.com>; Tue,  9 Aug 2011 03:12:15 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id GB4QJJnlzDVq04Gk for
	<xfs@oss.sgi.com>; Tue, 09 Aug 2011 03:12:15 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: frequent kernel BUG and lockups - 2.6.39 + xfs_fsr
Date: Tue, 9 Aug 2011 12:10:48 +0200
References: <20110806122556.GB20341@schmorp.de> <20110807102625.GJ3162@dastard>
	<20110808190222.GB7087@schmorp.de>
In-Reply-To: <20110808190222.GB7087@schmorp.de>
MIME-Version: 1.0
Message-Id: <201108091210.50204@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8405201519439335420=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Marc Lehmann <schmorp@schmorp.de>

--===============8405201519439335420==
Content-Type: multipart/signed;
  boundary="nextPart11241885.FcYF9bLRWF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart11241885.FcYF9bLRWF
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 8. August 2011 Marc Lehmann wrote:

=46irst of all, please calm down. Getting personal is not bringing us=20
anywhere.

> > On older kernels (2.6.34 and earlier) I can corrupt filesystems
> > using xfs-fsr just by crafting a file with a specific layout.
[snip]
> > IOWs, xfs_fsr on old kernels is actually dangerous and should not
> > be used if you
>=20
> Logic error - if I can corrupt an XFS without special privileges then
> this is not a problem with xfs_fsr, but simply a kernel bug in the
> xfs code. And a rather big one, one step below a remote exploit.

No, it's not a kernel bug because as long as you don't use xfs_fsr,=20
nothing will ever happen.

And the rest of the mail goes into lots of details which look very=20
strange to me. I've double checked with our servers, which generally=20
have these xfs mount options:=20
(rw,nodiratime,relatime,logbufs=3D8,logbsize=3D256k,attr2,barrier,largeio,s=
walloc)
and sometimes also=20
,allocsize=3D64m
and I can't find evidence for fragmentation that would be harmful.Yes=20
they are fragmented, of course. When you write to ~500 log files a time=20
via syslog (as we do on some servers), there must be some fragmentation.=20
The allocsize option helps a lot there. I looked at one webserver access=20
log, it has 640MB with 99 fragments, but that's not a lot. On our=20
Spamgate I see 250MB logs with 374 fragments. That's a bit more, but we=20
don't use the allocsize option there, which I changed now that I looked=20
at it ;-)

But your words
> If XFS is bad at append-only workloads, which is the most common type
> of workload, then XFS fails to be very relevant for the real world.

may be valid for your world, not mine. We have webservers, fileservers=20
and database servers, all of which are not really append style, but more=20
delete-and-recreate. Well, db-servers are rather exceptional here.

Append style is mostly for log files, at least on our servers.

But if the numbers for fragmentation on your servers are true, you must=20
have a very good test case for fragmentation prevention. Therefore it=20
could be really interesting if you could grab what Dave Chinner asked=20
for:
> If you think it's a good workload that we should use, then capture a
> typical directory profile and the IO/filesystem operations made on a
> busy server for an hour or so. Then write a script to reproduce that
> directory structure and IO pattern.....

And maybe he could use it for optimizations. Is there any tool on Linux=20
to record such I/O patterns? Would need to keep all metadata and data=20
operations for a partition to be interesting.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart11241885.FcYF9bLRWF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk5BB6oACgkQzhSR9xwSCbTAhgCfR5j2x54b73ZwSJ+gybruLxHs
Pf4AoJ4Ri0uE2KHpQA0M+5Mfm6BvI7JS
=yi9J
-----END PGP SIGNATURE-----

--nextPart11241885.FcYF9bLRWF--


--===============8405201519439335420==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8405201519439335420==--
