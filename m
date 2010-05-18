Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4IGnuGi062551 for <xfs@oss.sgi.com>; Tue, 18 May 2010 11:49:56 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A289913F9460
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 09:52:11 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id bEDEGnAe6LDGD36H for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 09:52:11 -0700 (PDT)
Date: Tue, 18 May 2010 18:52:04 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: rsync from xfs to nfs+xfs and ACL problems
Message-ID: <20100518185204.186258c0@harpe.intellique.com>
In-Reply-To: <201005181350.15308@zmi.at>
References: <201005181350.15308@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6204462754945785848=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

--===============6204462754945785848==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G6itQV1tEoqSE0p2KtcbUCo"; protocol="application/pgp-signature"

--Sig_/G6itQV1tEoqSE0p2KtcbUCo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Tue, 18 May 2010 13:50:15 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> Does it mean I can't sync ACLs? How could I do it? I need a full
> backup including ACLs, as I want to move all data and then restore.

Use nfs4 instead, should be fine. Exports structure is different. The
simple way is to simply add "fsid=3D0" in /etc/exports :

/mnt/whatever *(fsid=3D0,rw,async,no_root_squash,no_subtree_check)

Restart your nfs daemons, then mount (notice the / instead
of /mnt/whatever ) :

mount -t nfs4 server:/ /mnt/nfsmount

regards,
--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/G6itQV1tEoqSE0p2KtcbUCo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvyxbQACgkQX3jQXNUicVZpZACglubOu26W1DE40MahKILYXLcV
d2wAnAmPXdWmZgdNbXWE7O7eNGxe1cm8
=viE9
-----END PGP SIGNATURE-----

--Sig_/G6itQV1tEoqSE0p2KtcbUCo--


--===============6204462754945785848==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6204462754945785848==--
