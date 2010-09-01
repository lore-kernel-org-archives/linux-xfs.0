Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o810MLi4091973 for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 19:22:22 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A52540C4E
	for <xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:22:59 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Cof1A6JxhiFtR9NT for
	<xfs@oss.sgi.com>; Tue, 31 Aug 2010 17:22:59 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Date: Wed, 1 Sep 2010 02:22:31 +0200
References: <201009010130.41500@zmi.at> <20100901000631.GO705@dastard>
In-Reply-To: <20100901000631.GO705@dastard>
MIME-Version: 1.0
Message-Id: <201009010222.57350@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4979916487037470756=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4979916487037470756==
Content-Type: multipart/signed;
  boundary="nextPart1437051.Y1BxbpQFyr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1437051.Y1BxbpQFyr
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 1. September 2010 Dave Chinner wrote:
> You're probably getting RMW cycles on inode writeback. I've been
> noticing this lately with my benchmarking - the VM is being _very
> aggressive_ reclaiming page cache pages vs inode caches and as a
> result the inode buffers used for IO are being reclaimed between the
> time it takes to create the inodes and when they are written back.
> Hence you get lots of reads occurring during inode writeback.
>=20
> By issuing a sync, you clear out all the inode writeback and all the
> RMW cycles go away. As a result, there is more disk throughput
> availble for the unlink processes.  There is a good chance this is
> the case as the number of reads after the sync drop by an order of
> magnitude...

Nice explanation.
=20
> > Now it can be that the sync just causes more writes and stalls
> > reads so overall it's slower, but I'm wondering why none of the
> > devices says "100% util", which should be the case on deletes? Or
> > is this again the "mistake" of the utilization calculation that
> > writes do not really show up there?
>=20
> You're probably CPU bound, not IO bound.

This is a hexa-core AMD Phenom(tm) II X6 1090T Processor with up to=20
3.2GHz per core, so that shouldn't be - or is there only one core used?=20
I think I read somewhere that each AG should get a core or so...
=20
Thanks for your explanation.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1437051.Y1BxbpQFyr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx9nOEACgkQzhSR9xwSCbTM8ACfWqqqc9RSN3r5illX4wKdQkbA
GK4AoOmjgJagdjlScOwgS563COyJ+B+p
=zwYX
-----END PGP SIGNATURE-----

--nextPart1437051.Y1BxbpQFyr--


--===============4979916487037470756==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4979916487037470756==--
