Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2QCWB3x235175 for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 07:32:12 -0500
Received: from mailsrv13.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75ABB15303FF
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 05:33:53 -0700 (PDT)
Received: from mailsrv13.zmi.at (mailsrv1.zmi.at [195.202.151.133]) by
	cuda.sgi.com with ESMTP id KFhdrOzIcaCPrHEf for
	<xfs@oss.sgi.com>; Fri, 26 Mar 2010 05:33:53 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv13.zmi.at (Postfix) with ESMTP id 5234519612
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 13:33:52 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 234AB83C804
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 13:33:52 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair 3.0.3 crash and abort
Date: Fri, 26 Mar 2010 13:33:46 +0100
References: <201003261257.41233@zmi.at>
In-Reply-To: <201003261257.41233@zmi.at>
MIME-Version: 1.0
Message-Id: <201003261333.51599@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0327369226730497563=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0327369226730497563==
Content-Type: multipart/signed;
  boundary="nextPart1384500.X0qBcudUDC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1384500.X0qBcudUDC
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Freitag, 26. M=C3=A4rz 2010 Michael Monnerie wrote:
> What can I do?
=20
Tried to metadump, but it also crashed:

# xfs_metadump /dev/sharestore/public=20
/disks/vmshared/metadump.sharestore1
xfs_db: metadump.c:471: generate_obfuscated_name: Zusicherung=20
=C2=BBxfs_da_hashname(newname, namelen) =3D=3D hash=C2=AB nicht erf=C3=BCll=
t.
/usr/bin/xfs_metadump: Zeile 31:  3299 Abgebrochen            =20
xfs_db$DBOPTS -F -i -p xfs_metadump -c "metadump$OPTS $2" $1

I found xfsprogs 3.1.1 now, just downloaded & compiled, and running the=20
disk check again. Will report later. Hope it works!

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1384500.X0qBcudUDC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkusqa8ACgkQzhSR9xwSCbQN1ACghQUBTbck7uxFbzdbc244w8h1
fVoAnjzQIeeUFRvrwYGuZntwJ2tOmmbw
=YcM1
-----END PGP SIGNATURE-----

--nextPart1384500.X0qBcudUDC--


--===============0327369226730497563==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0327369226730497563==--
