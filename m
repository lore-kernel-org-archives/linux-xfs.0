Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4IBe2NM049688 for <xfs@oss.sgi.com>; Tue, 18 May 2010 06:40:03 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D22B1569EBE
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 04:43:21 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id MTWSPIsJvf4MnqK4 for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 04:43:21 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id ED5DD800183
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 13:42:17 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id AA35D83C804
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 13:42:17 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair 3.1.1 doesnt repair broken filesystem [solved]
Date: Tue, 18 May 2010 13:42:13 +0200
References: <201005180953.51892@zmi.at> <4BF2739B.6000509@email.it>
In-Reply-To: <4BF2739B.6000509@email.it>
MIME-Version: 1.0
Message-Id: <201005181342.17267@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2121770880056796509=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2121770880056796509==
Content-Type: multipart/signed;
  boundary="nextPart2856337.8KJTd9OaXF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2856337.8KJTd9OaXF
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 18. Mai 2010 Default User wrote:
> I think you have created the filesystem with -o inode64 and now you
>  are  remounting it without -o inode64.
> After you created one file or directory with the inode64 option you
>  NEED  to always specify inode64 option at subsequent mounts or you
>  won't be able to access such files/directories.
> (Not sure if forgetting to use the option can even cause data
>  corruption  upon write. Might inode32 writes overwrite the
>  inaccessible inode64 files/dirs? XFS developers might know this.)
=20
Ah! You're absolutely right, inode64 did the trick.

Isn't it a kind of bug? Of course normally you would mount filesystems=20
from fstab, but for a temporary one like this I didn't do that. Still,=20
having xfs issuing not even a warning smells like a bug, even if they=20
might say it's a "feature by design".

So if you have an external 2TB drive from a friend and mount it on your=20
PC, you can't tell if inode64 was used or not? And if you mount without=20
that option you could destroy contents? In my case it was "easy" to see=20
there are fs problems, but what if such inodes are only used in subdirs?=20
Even with this "easy seeable" problem I didn't have the idea of a=20
missing inode64 option.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2856337.8KJTd9OaXF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvyfRkACgkQzhSR9xwSCbTwRgCfUCWGWPAa1dSS+16LUNEOK3WU
JaQAn0qHvhEM0HivopFFfDwBXa+ERebv
=CDQb
-----END PGP SIGNATURE-----

--nextPart2856337.8KJTd9OaXF--


--===============2121770880056796509==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2121770880056796509==--
