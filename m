Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 15ECB7CA0
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 12:11:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76F28AC023
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 10:11:22 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id FLTq5BgPUHsqROoP
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 04 Jun 2016 10:11:19 -0700 (PDT)
Message-ID: <1465060270.2847.149.camel@decadent.org.uk>
Subject: Re: XFS hole punch races
From: Ben Hutchings <ben@decadent.org.uk>
Date: Sat, 04 Jun 2016 18:11:10 +0100
In-Reply-To: <20160322155740.GB28772@quack.suse.cz>
References: <20160322155740.GB28772@quack.suse.cz>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5321950525829243333=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Cc: xfs@oss.sgi.com


--===============5321950525829243333==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DkW9dkZvWpfg5goUO7kh"


--=-DkW9dkZvWpfg5goUO7kh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-03-22 at 16:57 +0100, Jan Kara wrote:

Hi,

similarly to ext4 also XFS had races between hole punching and page faults
which could result in data corruption. The fixes were merged in 4.1-rc1 but
it might make sense to backport them to older stable releases given the
nature of the issue.

Relevant fixes are:

de0e8c20ba3a65b0f15040aabbefdc1999876e6b
075a924d45cc69c75a35f20b4912b85aa98b180a
e8e9ad42c1f1e1bfbe0e8c32c8cac02e9ebfb7ef
0f9160b444e4de33b65dfcd3b901358a3129461a
723cac48473358939759885a18e8df113ea96138
ec56b1f1fdc69599963574ce94cc5693d535dd64


You missed the first in that sequence:

653c60b633a9 xfs: introduce mmap/truncate lock

For 3.16, I've queued up all=C2=A0those fixes with one further=C2=A0prerequ=
isite:

812176832169 xfs: fix swapext ilock deadlock

For 3.2, I've queued up all but 723cac484733, with these additional
prerequisites:

f38996f57687 xfs: reduce ilock hold times in xfs_setattr_size
bc4010ecb8f4 xfs: use iolock on XFS_IOC_ALLOCSP calls
76ca4c238cf5 xfs: always take the iolock around xfs_setattr_size
5f8aca8b43f4 xfs: always hold the iolock when calling xfs_change_file_space
I realise I'll need to check for regressions with xfstests.

Ben.

--=20
Ben Hutchings
The most exhausting thing in life is being insincere. - Anne Morrow
Lindberg

--=-DkW9dkZvWpfg5goUO7kh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXUwuuAAoJEOe/yOyVhhEJYTMP/1d8PwM5Xw+FrAnZd7znk5ZY
HLa3GV5PBB1joWQsk4mttnzKnaHdKQNmVIDlN1f0Z5vg7BDnBqLj98R0idNkBLOo
1ZXQ7IEj4BHMtGPqyIj3cZk+E+hfkenI72LXrNaRmELCRsTX2mNwzJ+O2vvDYY6t
EuYxZymHujVaGyU55sjszMN9XkfZKlyF6ZV1Duq0qA7Wwuv57Meb+6oCoevZusIG
s+UX0L9uOrA136kiW9XROIdeTzlWcwd0I0Y0atqQ2rsPnzzBJip40KW+SsJjzJWN
LYSBIOHGYPHsuw7U+GfEzffxmjPi9MN6qlI7/E8jc/M7rCgQOnJDlRMzXT3L+MwV
UsQFzJfcAECVoxB9Xikksa8YF+NYOEtha+zuyMdhJKnpZOtWmdl8AAL8IuXSCyPi
kTIMe4X25aFjcfEcMVfgAaJOw1Zhxw63oq2/lLmFgU4/PYOcQ9VApYf6VA6c1uCT
D1GIqxBWo/QW3Yk4e/Z05KFOumRqP3nfCULDpAEHDStkaG44JHKcAyWJBKSEmlVH
KfrUQZ/KIPjyuEWOWcK2RN26MwXNKbrUitRG390yY+LrsvXyil8Ezinj07xAbm2C
R/Ra81nvYB3OhcxBJPp/FY+pLJP2KQ17RPGUFxLZNXwZkcdTP9JhXmNTT5GOUwNG
5zXfEUaTCBaKj+Oin/CZ
=VpAB
-----END PGP SIGNATURE-----

--=-DkW9dkZvWpfg5goUO7kh--


--===============5321950525829243333==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5321950525829243333==--
