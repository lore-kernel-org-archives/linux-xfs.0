Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5H84ppk167719 for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 03:04:52 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7444C14F02EC
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 01:07:28 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Fk7MpH9kERTkFWDB for
	<xfs@oss.sgi.com>; Thu, 17 Jun 2010 01:07:28 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id C217317A
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 10:07:26 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 13A5B83C829
	for <xfs@oss.sgi.com>; Thu, 17 Jun 2010 10:07:14 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] xfsqa: test open_by_handle() on unlinked and freed inode
	clusters V2
Date: Thu, 17 Jun 2010 10:07:25 +0200
References: <1276756659-12338-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1276756659-12338-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Message-Id: <201006171007.26040@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3933649823140019804=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3933649823140019804==
Content-Type: multipart/signed;
  boundary="nextPart3473232.CNg3zXGhNV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3473232.CNg3zXGhNV
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 17. Juni 2010 Dave Chinner wrote:
> Hence if we get a cold cache lookup from a stale handle that
> references such an inode, we can read the inode off disk even though
> it has been deleted because we don't check if the inode is allocated
> or not.  If the inode chunk has not been overwritten, then the inode
> read will succeed and the handle-to-dentry conversion will not error
> out like it is supposed to. The result is that stale NFS filehandles
> and open_by_handle() will succeed incorrectly on unlinked files for
> cold cache lookups.
=20
Wouldn't that qualify as a security problem and be handled as such?=20
There should be back ports for "long term support" kernels of security-
sensitive people, and so on.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3473232.CNg3zXGhNV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwZ170ACgkQzhSR9xwSCbTrmQCgmkB3M3EZ0nDTth3DEykv3QpG
/e8An3CQvLR8hu4vLJGHJqLcFgDRmHne
=ZQA0
-----END PGP SIGNATURE-----

--nextPart3473232.CNg3zXGhNV--


--===============3933649823140019804==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3933649823140019804==--
