Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o95LRZP3003753 for <xfs@oss.sgi.com>; Tue, 5 Oct 2010 16:27:36 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CF4B18B93AF
	for <xfs@oss.sgi.com>; Tue,  5 Oct 2010 14:28:37 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id RapVGay8aG6tB0H9 for
	<xfs@oss.sgi.com>; Tue, 05 Oct 2010 14:28:37 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS Filename Hash and metadump
Date: Tue, 5 Oct 2010 23:28:33 +0200
References: <1286290547.1960.3.camel@doink>
In-Reply-To: <1286290547.1960.3.camel@doink>
MIME-Version: 1.0
Message-Id: <201010052328.34390@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1296430350933356675=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

--===============1296430350933356675==
Content-Type: multipart/signed;
  boundary="nextPart19497927.dixTAWZHFp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart19497927.dixTAWZHFp
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 5. Oktober 2010 Alex Elder wrote:
> PS  Two more observations:
>     - There is really no need for the characters to be truly random.
>       Making the generated name unique and different from the
>       original is sufficient.  So (with the exception of the last
>       five bytes) we can select the characters however we like.
>       They could be a sequential series of names, for example,
>       rather than computing a random value for each.

I was thinking the same when reading your description. Why not simply=20
"number" the file names from 1 to whatever count of files/dirs there is=20
within that dir?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart19497927.dixTAWZHFp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkyrmIIACgkQzhSR9xwSCbThjACgkFarpsQhnKg+ietMW0jkwYYv
r2YAoKLLxOKqrcvzED/K4o4BKaUjwp4C
=mBo4
-----END PGP SIGNATURE-----

--nextPart19497927.dixTAWZHFp--


--===============1296430350933356675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1296430350933356675==--
