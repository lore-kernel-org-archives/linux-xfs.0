Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n817JSRe159400 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 02:19:38 -0500
Received: from mailsrv5.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 29DC6159ADB9
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 00:19:55 -0700 (PDT)
Received: from mailsrv5.zmi.at (mailsrv5.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 4ve91BzIwDGKCtyz for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 00:19:55 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv5.zmi.at (Postfix) with ESMTP id 7F92D689
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 09:19:18 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id A33C940015E
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 09:19:20 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: zero size file after power failure with kernel 2.6.30.5
Date: Tue, 1 Sep 2009 09:18:30 +0200
References: <200908292102.21710@zmi.at> <4A99A80C.9010307@sandeen.net>
	<19100.22644.149019.555685@tree.ty.sabi.co.uk>
In-Reply-To: <19100.22644.149019.555685@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Message-Id: <200909010918.37886@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6821851644789405840=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6821851644789405840==
Content-Type: multipart/signed;
  boundary="nextPart9961981.iA24zTgTkV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9961981.iA24zTgTkV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Dienstag 01 September 2009 Peter Grandi wrote:
> Then 'mount' with '-o sync'
[snip]

Yes. I could also simply switch back to reiserfs, where I never had this=20
kind of issue, despite lots of crashes etc. I'm not here to blame the=20
devs, just wanted to report that this kind of problem still exists, and=20
maybe someone taps into the problem and can improve it.

There was a similar problem with the change from ext3 to ext4, with a=20
big discussion. Ext4 has been improved, I don't know how good it is now.
And I know lots of discussions whether the app or the kernel is wrong,=20
and whether you should fsync() after rename(). In ext4 they reorganized=20
the way metaupdates are done, maybe that can help xfs too.

It seems kmail writes its config every 7 minutes, so it is vulnerable=20
for 3 seconds then. I've set
vm.dirty_expire_centisecs =3D 1000
now to improve the situation a bit.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart9961981.iA24zTgTkV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkqcys0ACgkQzhSR9xwSCbR90gCg79ZmRZA9/cM81r8aiofBvnCR
gV8AmwXkwcpvitkkmsnBt4bPRh0jOioc
=eA5E
-----END PGP SIGNATURE-----

--nextPart9961981.iA24zTgTkV--


--===============6821851644789405840==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6821851644789405840==--
