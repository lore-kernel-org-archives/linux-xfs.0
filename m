Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Nov 2006 20:11:16 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAD4B6aG024479
	for <xfs@oss.sgi.com>; Sun, 12 Nov 2006 20:11:07 -0800
Received: from mailgate.mysql.com (mailgate-out2.mysql.com [213.136.52.68])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB01751A283
	for <xfs@oss.sgi.com>; Sun, 12 Nov 2006 20:10:18 -0800 (PST)
Subject: Re: XFS_IOC_RESVSP64 versus XFS_IOC_ALLOCSP64 with multiple threads
From: Stewart Smith <stewart@mysql.com>
In-Reply-To: <965ECEF2-971D-46A1-B3F2-C6C1860C9ED8@sgi.com>
References: <1163381602.11914.10.camel@localhost.localdomain>
	 <965ECEF2-971D-46A1-B3F2-C6C1860C9ED8@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rOZV1sXgWb3qfQz5RbKS"
Date: Mon, 13 Nov 2006 15:09:02 +1100
Message-Id: <1163390942.14517.12.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sam Vaughan <sjv@sgi.com>
Cc: xfs@oss.sgi.com

--=-rOZV1sXgWb3qfQz5RbKS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-11-13 at 13:58 +1100, Sam Vaughan wrote:
> Are the two processes in your test writing files to the same=20=20
> directory as each other?  If so then their allocations will go into=20=20
> the same AG as the directory by default, hence the fragmentation.  If=20=
=20
> you can limit yourself to an AG's worth of data per directory then=20=20
> you should be able to avoid fragmentation using the default=20=20
> allocator.  If you need to reserve more than that per AG, then the=20=20
> files will most likely start interleaving again once they spill out=20=20
> of their original AGs.  If that's the case then the upcoming=20=20
> filestreams allocator may be your best bet.

I do predict that the filestreams allocator will be useful for us (and
also on my MythTV box...).

The two processes write to their own directories.

The structure of the "filesystem" for the process (ndbd) is:

ndb_1_fs/ (the 1 refers to node id, so there is a ndb_2_fs for a 2 node
setup)
	D8/, D9/, D10/, D11/
		all have a DBLQH subdirectory. In here there are several
		S0.FragLog files (the number changes). These are 16MB
		files used for logging.
		We (currently) don't do any xfsctl allocation on these.
		We should though. In fact, we're writing them in a way
		to get holes (which probably affects performance).
		These files are write only (except during a full cluster
		restart - a very rare event).

	LCP/0/T0F0.Data
		(there is at least 0,1,2 for that first number,
		T0 is table 0 - can be thousands of tables.
		f0 is fragment 0, can be a few of them too, typically
		2-4 though)
		These are an on-disk copy of in-memory tables, variably
		sized files (as big or as small as tables in a DB)
		The above log files are for changes occuring during the
		writing of these files.

	datafile01.dat, undofile01.dat etc
	whatever files the user creates for disk based tables
		the datafiles and undofiles that i've done the special
		allocation for.
		Typical deployments will have anything from a few
		hundred MB per file to few GB to many many GB.

"typical" installations are probably now evenly split between 1 process
per physical machine and several (usually 2).=20
--=20
Stewart Smith, Software Engineer
MySQL AB, www.mysql.com
Office: +14082136540 Ext: 6616
VoIP: 6616@sip.us.mysql.com
Mobile: +61 4 3 8844 332

Jumpstart your cluster:
http://www.mysql.com/consulting/packaged/cluster.html

--=-rOZV1sXgWb3qfQz5RbKS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBFV+/eKglWCUL+FDoRAgeaAJ9VyoAYPbdCbkiqDla2XjAAFkAQOACdHuCG
XvoepUZ5I/+6U2xy2FgCNRs=
=VKoX
-----END PGP SIGNATURE-----

--=-rOZV1sXgWb3qfQz5RbKS--
