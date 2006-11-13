Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Nov 2006 21:22:05 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAD5LpaG002986
	for <xfs@oss.sgi.com>; Sun, 12 Nov 2006 21:21:52 -0800
Subject: Re: XFS_IOC_RESVSP64 versus XFS_IOC_ALLOCSP64 with multiple threads
From: Stewart Smith <stewart@mysql.com>
In-Reply-To: <12275452-56ED-4921-899F-EFF1C05B251A@sgi.com>
References: <1163381602.11914.10.camel@localhost.localdomain>
	 <965ECEF2-971D-46A1-B3F2-C6C1860C9ED8@sgi.com>
	 <1163390942.14517.12.camel@localhost.localdomain>
	 <12275452-56ED-4921-899F-EFF1C05B251A@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Sxd6HlS88lQbZ5tP45OJ"
Date: Mon, 13 Nov 2006 16:20:50 +1100
Message-Id: <1163395250.14517.38.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sam Vaughan <sjv@sgi.com>
Cc: xfs@oss.sgi.com

--=-Sxd6HlS88lQbZ5tP45OJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-11-13 at 15:53 +1100, Sam Vaughan wrote:
> Just to be clear, are we talking about intra-file fragmentation, i.e.=20=
=20
> file data laid out discontiguously on disk, or inter-file=20=20
> fragmentation where each file is continguous on disk but the files=20=20
> from different processes are getting interleaved?  Also, are there=20=20
> just a couple of user data files, each of them potentially much=20=20
> larger than the size of an AG, or do you split the data up into many=20=
=20
> files, e.g. datafile01.dat ... datafile99.dat ...?

an example:

/home/mysql/cluster/ndb_1_fs/datafile1.dat:
 EXT: FILE-OFFSET       BLOCK-RANGE        AG AG-OFFSET          TOTAL
   0: [0..63]:          32862376..32862439  8 (1405096..1405159)    64
   1: [64..127]:        32875992..32876055  8 (1418712..1418775)    64
   2: [128..191]:       33040112..33040175  8 (1582832..1582895)    64
   3: [192..255]:       33080136..33080199  8 (1622856..1622919)    64
   4: [256..319]:       33101416..33101479  8 (1644136..1644199)    64
   5: [320..383]:       33112624..33112687  8 (1655344..1655407)    64
   6: [384..447]:       32526608..32526671  8 (1069328..1069391)    64
   7: [448..511]:       31678920..31678983  8 (221640..221703)      64
/home/mysql/cluster/ndb_2_fs/datafile1.dat:
 EXT: FILE-OFFSET       BLOCK-RANGE        AG AG-OFFSET          TOTAL
   0: [0..63]:          32864704..32864767  8 (1407424..1407487)    64
   1: [64..127]:        32888544..32888607  8 (1431264..1431327)    64
   2: [128..191]:       33068832..33068895  8 (1611552..1611615)    64
   3: [192..255]:       33101168..33101231  8 (1643888..1643951)    64
   4: [256..319]:       33101656..33101719  8 (1644376..1644439)    64
   5: [320..383]:       33115784..33115847  8 (1658504..1658567)    64
   6: [384..447]:       33897200..33897263  8 (2439920..2439983)    64
   7: [448..511]:       33900896..33900959  8 (2443616..2443679)    64

on this fs:
 isize=3D256    agcount=3D32, agsize=3D491520 blks
         =3D                       sectsz=3D512   attr=3D0
data     =3D                       bsize=3D4096   blocks=3D15728640,
imaxpct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks, unwritte=
n=3D1
naming   =3Dversion 2              bsize=3D4096=20=20
log      =3Dinternal               bsize=3D4096   blocks=3D3840, version=3D1
         =3D                       sectsz=3D512   sunit=3D0 blks
realtime =3Dnone                   extsz=3D65536  blocks=3D0, rtextents=3D0

(somewhere between 5-15Gb free from this create IIRC)

these datafiles are fixed size, allocated by user. a DBA would run from
the SQL server something like:
CREATE TABLESPACE ts1
ADD DATAFILE 'datafile.dat'
USE LOGFILE GROUP lg1
INITIAL_SIZE 1G
ENGINE NDB;

to get a tablespace with 1GB data file (on each node).

we currently don't do any automatic extending.

> If you have the flexibility to break the data up at arbitrary points=20=
=20
> into separate files, you could get optimal allocation behaviour by=20=20
> starting a new directory as soon as the files in the current one are=20=
=20
> large enough to fill an AG.  The problem with the filestreams=20=20
> allocator is that it will only dedicate an AG to a directory for a=20=20
> fixed and short period of time after the last file was written to=20=20
> it.  This works well to limit the resource drain on AGs when running=20=
=20
> file-per-frame video captures, but not so well with a database that=20=20
> writes its data in a far less regimented and timely way.

for the data and undo files, we're just not changing their size except
at creation time, so that's okay.

> Now in your case you're using different directories, so your files=20=20
> are probably OK at the start of day.  Once the AGs they start in fill=20=
=20
> up though, the files for both processes will start getting allocated=20=
=20
> from the next available AG.  At that point, allocations that started=20=
=20
> out looking like the first test above will end up looking like the=20=20
> second.
>=20
> The filestreams allocator will stop this from happening for=20=20
> applications that write data regularly like video ingest servers, but=20=
=20
> I wouldn't expect it to be a cure-all for your database app because=20=20
> your writes could have large delays between them.  Instead, I'd look=20=
=20
> into ways to break up your data into AG-sized chunks, starting a new=20=
=20
> directory every time you go over that magic size.

I'll have to check our writing behaviour the files that change sizes...
but they're not too much of an issue (they're hardly ever read back, so
as long as writing them out is okay and reading isn't totally abismal,
we don't have to worry).
--=20
Stewart Smith, Software Engineer
MySQL AB, www.mysql.com
Office: +14082136540 Ext: 6616
VoIP: 6616@sip.us.mysql.com
Mobile: +61 4 3 8844 332

Jumpstart your cluster:
http://www.mysql.com/consulting/packaged/cluster.html

--=-Sxd6HlS88lQbZ5tP45OJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFWACxKglWCUL+FDoRAvMvAJ9xrLPWxGzuAk02gt2TwJu11pDUYwCbBWl8
in+PlEfZYHPHBODVw5yL1S0=
=qt5j
-----END PGP SIGNATURE-----

--=-Sxd6HlS88lQbZ5tP45OJ--
