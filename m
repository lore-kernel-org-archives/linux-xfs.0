Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED2077F61
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 10:46:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74E76AC001
	for <xfs@oss.sgi.com>; Thu,  5 Nov 2015 08:46:42 -0800 (PST)
Received: from zucker2.schokokeks.org (zucker2.schokokeks.org [178.63.68.90])
	by cuda.sgi.com with ESMTP id eENsDuAbIiFa6hmV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 Nov 2015 08:46:38 -0800 (PST)
Date: Thu, 5 Nov 2015 17:47:32 +0100
From: Hanno =?UTF-8?B?QsO2Y2s=?= <hanno@hboeck.de>
Subject: Several bugs in xfs-progs when parsing invalid input
Message-ID: <20151105174732.2378bc35@pc1>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1645677135700776495=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--===============1645677135700776495==
Content-Type: multipart/signed; micalg=pgp-sha512; protocol="application/pgp-signature"; boundary="=_zucker.schokokeks.org-22612-1446741996-0001-2"

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_zucker.schokokeks.org-22612-1446741996-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

A while ago I reported a couple of bugs into your bugtracker about
issues in xfs_repair that I found through fuzzing (with the tool
american fuzzy lop).

http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D1119
null pointer access

http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D1120
out of bounds heap read access

http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D1121
http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D1122
2x assert

When opening these bugs I got an error message. I then contacted your
support and almost two months(!) later I got a reply telling me that I
should not use bugzilla, instead I should report bugs to this mailing
list.

Your webpage however clearly states that I should use bugzilla:
http://oss.sgi.com/projects/xfs/

This is all a bit ridiculous. If you don't want people to use your
bugzilla don't say so on your webpage and preferrably disable the
creation of new bugs.

Anyway: Please have a look at the bugs I reported (and once they're
fixed I'll happily re-test the code to see if there are more issues
that can be found via fuzzing).

--=20
Hanno B=C3=B6ck
http://hboeck.de/

mail/jabber: hanno@hboeck.de
GPG: BBB51E42

--=_zucker.schokokeks.org-22612-1446741996-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJWO4gkAAoJEKWIAHK7tR5C+wwP/j1hhfcCHf0mHC2fK5Yldwjq
nrIdfg2oVHLLno8UUrwiOJTdfsefj0mX4FxTOzqO/WxQDD9Md9me37/YOme5TRgN
CSTjOrVTN9oie1m2PjOpSrfFrX1IwbkkaX/xN4YiFOs86lBY5enf4KZCfWhRjWgA
mqJhgTvgKLOR87Cmz6gQijZ1plRloEkEejVqEbC1dBQ1AiiJUc648AzbVStp6LVM
+9Jr16F1ctHmDbsb6zKlRSFBre1MX/JsTCn+E3H4MiabiRBoigU+/Ie8P0jX9WoT
ML/0ix85eOQH6S/q4aEnUjNiSC71oovvOZ6wIQeCg2r+wNjtAtVdxD5ADx7kNOxI
GD6ASU+dAfE4i65tklWXAu6WdCKF5YbHJez/aoLcxYQDPbUSw1hK1V/agQtvRgjk
LbRwfYeLcykIV2IxidPsjg71opBjqdZrzbu96uiQDdY9xbKL5RFf2Jt8hjF8z6xo
seLNokg7cHZd2eBEbmOS1WGgjnEWboVDn3zdu9s2mnMgpAaR/JPtpS95qP+uYHWV
RR2rL865plrReFfUZYpj7dTHKXcgP8KknHyTC1zE+AYoNyoJvH2j/WeCrsBLYkYw
WfzacmLGrMfhApvi7+wrqpWW6J2wDnZ6KBhgx4KAtGeIJIUr2O/zA12dTm0VrVvZ
i+DP92wP9RY1VyuV6/vJ
=c32S
-----END PGP SIGNATURE-----

--=_zucker.schokokeks.org-22612-1446741996-0001-2--


--===============1645677135700776495==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1645677135700776495==--
