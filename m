Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Jun 2007 23:15:03 -0700 (PDT)
Received: from smtpout.eastlink.ca (smtpout.eastlink.ca [24.222.0.30])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5L6Esdo009363
	for <xfs@oss.sgi.com>; Wed, 20 Jun 2007 23:14:58 -0700
Received: from ip03.eastlink.ca ([24.222.10.15])
 by mta01.eastlink.ca (Sun Java System Messaging Server 6.2-4.03 (built Sep 22
 2005)) with ESMTP id <0JJZ00MGV2OVAZT0@mta01.eastlink.ca> for xfs@oss.sgi.com;
 Thu, 21 Jun 2007 03:14:55 -0300 (ADT)
Received: from peter by llama.cordes.ca with local (Exim 3.36 #1 (Debian))
	id 1I1FwP-0000X2-00	for <xfs@oss.sgi.com>; Thu, 21 Jun 2007 03:14:49 -0300
Date: Thu, 21 Jun 2007 03:14:49 -0300
From: Peter Cordes <peter@cordes.ca>
Subject: Re: XFS_IOC_RESVSP64 for swap files
In-reply-to: <20070619043333.GJ86004887@sgi.com>
Message-id: <20070621061449.GB11200@cordes.ca>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=vkogqOf2sHV7VnPd
Content-disposition: inline
References: <20070617100822.GA4586@cordes.ca>
 <20070619043333.GJ86004887@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 19, 2007 at 02:33:33PM +1000, David Chinner wrote:
> On Sun, Jun 17, 2007 at 07:08:23AM -0300, Peter Cordes wrote:
> >  Hi XFS list.  I'm not subscribed, please CC me.
> >=20
> >  Programs such as swapspace and swapd create new swap files when vmem r=
uns
> > low.  They would benefit hugely from being able to create a swapfile wi=
thout
> > any significant disk I/O.  (If a process grabs a lot of memory quickly,=
 the
> > system will be swapping hard while swapspace(8) is writing a swapfile.)


> > but it [exposing stale data] would still be useful for making swap files
> > even if only root could do it.
>=20
> Still a potential security hole.

 Root can read the device file, so how is letting root expose stale data any
worse?  If a program run by root makes a file with mode 0600, and then calls
XFS_IOC_EXPOSE_MY_STALE_DATA_TO_EVERYONE, where's the security problem?


> >  Could swapon(2) in the kernel be made to work on XFS files with reserv=
ed
> > space?
>=20
> Basically, the swapon syscall calls bmap() for the block mapping of the
> file and XFS returns "holes" [...]

 Yeah, bad idea to put special case stuff in the kernel.

> > i.e. call something that would give XFS a chance to mark all the
> > extents as written, even though they're not.
>=20
> You mean like XFS_IOC_EXPOSE_MY_STALE_DATA_TO_EVERYONE? ;)
>=20
> That's not going to happen.
>=20
> In fact, I plan to make unwritten extents non-optional soon (i.e. I've al=
ready
> got preliminary patches to do this) so that filesystems that have it turn=
ed
> off will get them turned on automatically.
>=20
> The reasons?
>=20
> 	a) there is no good reason for unwritten=3D0 from a performance
> 	   perspective
> 	b) there is good reason for unwritten=3D1 from a security perspective
> 	c) we need to use unwritten extents in place of written extents
> 	   during delayed allocation to prevent stale data exposure on
> 	   crash and when using extent size hints.
>=20
> So soon unwritten=3D0 is likely to go the way of the dodo.....

 Ok.  I didn't really want to recreate my /var/tmp filesystem with
unwritten=3D0, but I really wish I had
XFS_IOC_EXPOSE_MY_STALE_DATA_TO_EVERYONE on my desktop machine.  I think
dynamic swap file creation is a cool idea, and that ioctl would make it work
perfectly.

 This ioctl is only useful for making swap files.  Nothing else cares if the
file has "holes" or not.  But for that one application, it's great.  There
are lots of ways root can shoot himself in the foot, and I don't think
adding one more is enough reason to not add an ioctl.

 Is it just that you don't want to take time to implement such a feature, or
would you reject a patch that added it?  (Not that I'm volunteering,
necessarily.)

 BTW, thanks for taking the time to respond.

--=20
#define X(x,y) x##y
Peter Cordes ;  e-mail: X(peter@cor , des.ca)

"The gods confound the man who first found out how to distinguish the hours!
 Confound him, too, who in this place set up a sundial, to cut and hack
 my day so wretchedly into small pieces!" -- Plautus, 200 BC

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iQC1AwUBRnoXWQWkmhLkWuRTAQIWtQT/Sn2Yn/q8+zPexe/V51wd9ZqQsIX1j3jT
4YFg0OMVI3uCKtFVnuFmvQVH2FPg6JrIU+uxfgC7HnzL8AaBXw29zuvKNYDMCOQd
f4IBSBnS2BlDmvz0McD5Bnhqm7gAvFsAJRpYcQPp1TyXMbPOBR9qYE5XlH97QvNK
+Dv2knnRHEmHexMc7r9Y/L4oHp8UFh+D+etZG8NQDTxYPJYHwYEeEw==
=Dqdd
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
