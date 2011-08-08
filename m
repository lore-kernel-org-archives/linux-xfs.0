Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78DCfvY036066 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 08:12:41 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C2145363DD
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 06:12:39 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 9zoUAnE366AyX7Fh for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 06:12:39 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: "Corrupt dinode 6242615, (btree extents).  This is a bug."<o
Date: Mon, 8 Aug 2011 15:12:35 +0200
References: <alpine.OSX.1.00.1108081203550.26464@pegasus.binf.ku.dk>
	<201108081358.43727@zmi.at>
	<alpine.OSX.1.00.1108081422500.240@pegasus.binf.ku.dk>
In-Reply-To: <alpine.OSX.1.00.1108081422500.240@pegasus.binf.ku.dk>
MIME-Version: 1.0
Message-Id: <201108081512.36783@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1262802096092928884=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Hanne Munkholm <hanne@binf.ku.dk>
Cc: xfs@oss.sgi.com

--===============1262802096092928884==
Content-Type: multipart/signed;
  boundary="nextPart5467989.klFv2mMTx2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5467989.klFv2mMTx2
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Montag, 8. August 2011 Hanne Munkholm wrote:
> On Mon, 8 Aug 2011, Michael Monnerie wrote:
> > Yes, mount -L/umount once to replay the log, when you are sure the
> > block device works correctly again.
>=20
> Thank you very much for your reply.
>=20
> I don't see an -L option to the mount command meaning "replay
> log", I think if I was able to mount it, it would replay the log
> by itself? However, I cannot mount it.

Sorry, mixing up with xfs_repair -L. If mount doesn't work, then try to=20
xfs_repair -L.

> Trying with a newer kernel is possible but some trouble, is it
> likely to help?

Could be. Dave Chinner knows more. I'd say if a newer kernel is=20
problematic, try xfs_repair -L first, and keep the output for review. As=20
you have a backup anyway, you're on the safe side. I've needed=20
xfs_repair often and never had a problem because of it. YMMV though.
=20
> If I run an xfs_repair, will it get me anywhere even if it
> segfaults at the same point?

Yes, sometimes running it several times solves all problems.
=20
> Do you recommend that I run an xfs_repair with or without -L, or
> should I definetly try a new kernel first?

If you can quickly download a "live" CD with an actual kernel, do that=20
and try that. If that is problematic, e.g. you don't have access to the=20
server, just run xfs_repair -L.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart5467989.klFv2mMTx2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4/4MQACgkQzhSR9xwSCbRlKQCeMpnGzI5620SwZ0oMeCUv5AMw
+WgAnAgXndIMWC9zj7/X65U599CWBY2J
=j1oK
-----END PGP SIGNATURE-----

--nextPart5467989.klFv2mMTx2--


--===============1262802096092928884==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1262802096092928884==--
