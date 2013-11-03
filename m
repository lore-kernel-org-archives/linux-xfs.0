Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 83DC07F54
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 02:17:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BE85304062
	for <xfs@oss.sgi.com>; Sun,  3 Nov 2013 01:17:08 -0700 (PDT)
Received: from kazi.fit.vutbr.cz (kazi.fit.vutbr.cz [147.229.8.12]) by
	cuda.sgi.com with ESMTP id S28aeq6dQHfm5KWz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 03 Nov 2013 01:17:05 -0700 (PDT)
Received: from kazi.fit.vutbr.cz (localhost [127.0.0.1])
	by kazi.fit.vutbr.cz (8.14.7/8.14.6) with ESMTP id rA38H4QR007999
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 3 Nov 2013 09:17:04 +0100 (CET)
Received: (from kasparek@localhost)
	by kazi.fit.vutbr.cz (8.14.7/8.14.5/Submit) id rA38H4DU007998
	for xfs@oss.sgi.com; Sun, 3 Nov 2013 09:17:04 +0100 (CET)
	(envelope-from kasparek@fit.vutbr.cz)
Date: Sun, 3 Nov 2013 09:17:04 +0100
From: Kasparek Tomas <kasparek@fit.vutbr.cz>
Subject: How to use increased number of ACL entries?
Message-ID: <20131103081704.GE9974@fit.vutbr.cz>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0546940201054847936=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============0546940201054847936==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pQhZXvAqiZgbeUkD"
Content-Disposition: inline


--pQhZXvAqiZgbeUkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'm trying to get more then 25 ACLs entries to work according to
http://oss.sgi.com/pipermail/xfs/2013-May/026544.html . I'm running 3.10.x
kernel which seems to contain these changes. I understand, that this is
on-disk format change, so I expect to need new xfsprogs too. I tried the
version from CentOS 6.4 (3.1.1) and one from git repo (
git://oss.sgi.com/xfs/cmds/xfsprogs), but still it fails to create more then
25 ACL entries (21 user defined). Is there something I'm still missing?

Thanks

--=20

  Tomas Kasparek               E-mail: kasparek@fit.vutbr.cz
  CVT FIT VUT Brno, L127       Web:    http://www.fit.vutbr.cz/~kasparek
  Bozetechova 1, 612 66        Fax:    +420 54114-1270
  Brno, Czech Republic         Phone:  +420 54114-1220

  jabber: tomas.kasparek@jabber.cz
  GPG:    2F1E 1AAF FD3B CFA3 1537  63BD DCBE 18FF A035 53BC

  May the command line live forever!

--pQhZXvAqiZgbeUkD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (FreeBSD)

iEYEARECAAYFAlJ2BoAACgkQFiofPpFRnYjycgCgtTUCZz9/mmPTFnRvavuH818g
JMwAn238y7IhhFgQF+6+Z+YkHFrjJEN0
=Ut44
-----END PGP SIGNATURE-----

--pQhZXvAqiZgbeUkD--


--===============0546940201054847936==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0546940201054847936==--
