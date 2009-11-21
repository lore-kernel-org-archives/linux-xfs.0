Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nALLHtMP058992 for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 15:17:55 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84996A35DC
	for <xfs@oss.sgi.com>; Sat, 21 Nov 2009 13:18:17 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3DbLG0hUw34eABpd for
	<xfs@oss.sgi.com>; Sat, 21 Nov 2009 13:18:17 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS, NFS and inode64 on 2.6.27
Date: Sat, 21 Nov 2009 22:17:57 +0100
References: <200911201152.43809@zmi.at> <20091121131657.GA2095@infradead.org>
In-Reply-To: <20091121131657.GA2095@infradead.org>
MIME-Version: 1.0
Message-Id: <200911212217.57407@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1360807509492341918=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============1360807509492341918==
Content-Type: multipart/signed;
  boundary="nextPart8026098.NuoB2sy1VS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart8026098.NuoB2sy1VS
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 21. November 2009 Christoph Hellwig wrote:
> So your NFS exports are not the roots of their respsective
>  filesystems?=20

That's the way it works with NFSv4. You create an NFS root dir with a=20
special entry in /etc/exports:
/nfsserver 10.0.0.0/8(fsid=3D0,rw,insecure,no_subtree_check,crossmnt)

and if you want other parts exported, create a dir there and mount it:
mkdir /nfsserver/data
mount --bind /mydata /nfsserver/data

This just takes the inodes from there and creates something like a view=20
into this dir. From the client, you

mount -t nfs4 server:/data /serverdata
and you get the /nfsserver/data mounted there.

>  This means NFSD uses non-standard filesystem IDs in the
>  filehandles which have to encode the inode number of the export
>  root.  Your best option is to simplify switch to exporting a whole
>  filesystem,=20

That's how it worked until NFSv3. I tried that also, didn't work either.
The whole thing worked before I reinstalled it (this server now runs=20
virtualized within XENserver), and maybe that made some subdirs have=20
inodes > 32bit.

>  alternatively you can try making sure NFSD uses the
>  16byte wide UUID style export. =20

How'd I do that?

>  Note thast either way will only work
>  with a 64bit kernel as the fs has no say in encoding the filesystem
>  part of the handle and ino_t is always 32bit on 32bit platforms.=20
>  This will also affect any other filesystem with 64bit inode numbers.

Not my problem, everything 64bit here. I use the kernel-nfsd, and that's=20
why I was wondering to have this problem.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart8026098.NuoB2sy1VS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksIWQUACgkQzhSR9xwSCbRXXACeNX3kDWOUgAsE4FJM7pskR4qt
ElgAn06YHxQK0E3jmzTSHxMh66nJGnWA
=/Cvg
-----END PGP SIGNATURE-----

--nextPart8026098.NuoB2sy1VS--


--===============1360807509492341918==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1360807509492341918==--
