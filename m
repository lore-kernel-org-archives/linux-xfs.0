Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96JWRB6087520 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 14:32:28 -0500
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB0B3121D350
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 12:33:53 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id 5VFTi4SHL6SuDfrp for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 12:33:53 -0700 (PDT)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: moving libhandle to /usr
Date: Tue, 6 Oct 2009 15:33:46 -0400
References: <20091006154249.GA1411@infradead.org>
In-Reply-To: <20091006154249.GA1411@infradead.org>
MIME-Version: 1.0
Message-Id: <200910061533.51365.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7074347719199667841=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: nathans@debian.org, sandeen@sandeen.net, xfs@oss.sgi.com

--===============7074347719199667841==
Content-Type: multipart/signed;
  boundary="nextPart2603824.SWRfn6bpEd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2603824.SWRfn6bpEd
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 06 October 2009 11:42:49 Christoph Hellwig wrote:
> Currently we install the versioned libhandle into /lib by default,
> and all other libraries into /usr.  Given that no program in / actually
> uses libhandle this seems rather awkward to me.  From Mike's comments
> in the past I think Gentoo already installs it into /usr anyway.
>=20
> Is there anything speaking against moving all libraries to /usr and
> switching Debian/Fedora to that aswell?

xfsdump uses it and xfsdump is installed into / by default right ?  so=20
libhandle needs to be in /lib so long as xfsdump is in /sbin.
=2Dmike

--nextPart2603824.SWRfn6bpEd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iQIcBAABAgAGBQJKy5ufAAoJEEFjO5/oN/WBfckP/iWhB90mqzpx2lxcJPteJkLb
f7tuCMAbvEh3JR2VQGNbxZXG4KDn7f9eekiAK/8/fitfdliuLDo9iBhf+ADBmCIF
iNZh9K/MrDpgg80cbIMDqNHYld6CrP0YI5KfoA0Toc3ATqB3fkLiPcU74srJI2IJ
X9nZSdMryRL79/SySHTUNYqSxVcAndglN4jKP97SjZQsihyylnS/2Ydbna4R5tto
+WK6OrlEBC7uGbMC0EcotXKFw1l5xwBGNcyzCrs9yYKNJk/C4asfzTj29v+4GuAh
6gLooEQSPXxmkBgfr/ffeUG9IDorx/qw05vGxUTbIuA/5yF27CVY5WrslW6zBXBy
akPq4dZA/IBHU5gKMSF2BgYj6Sh/dv0irrwpOYarzf3iND2Qu4Rof4nrXGy/VCeN
yyusJSd6AM9WaTTPCUstZOeMy2oxqK5aOsc2pjdW1849BA+7t27gC5ctwS+qcXY3
vB6BTcgsGSFFgGbbApjpNN2SE3wDZPpfqs0g481SXEExlvo8q3eEIfZ0TNOWpbVo
m7rtqxOy3XA+8rG19uNFSFYvds7XrzDzqkr+MErlHRs5PQmidBMD6/u0qW0hTtkd
ne/6mboLrziV2e9ELFuNhExxSINIp1X3JZHvrZNC37j1gcvdkimAy0CXG2Ul3JwO
rlDWuT8TxJeT1vPqhJcq
=5w0q
-----END PGP SIGNATURE-----

--nextPart2603824.SWRfn6bpEd--


--===============7074347719199667841==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7074347719199667841==--
