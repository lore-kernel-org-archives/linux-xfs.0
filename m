Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9T7um44117894 for <xfs@oss.sgi.com>; Fri, 29 Oct 2010 02:56:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BBE219AE30E
	for <xfs@oss.sgi.com>; Fri, 29 Oct 2010 00:58:06 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id gO9y4bVlTBB0KlkH for
	<xfs@oss.sgi.com>; Fri, 29 Oct 2010 00:58:06 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS journaling position
Date: Fri, 29 Oct 2010 09:58:02 +0200
References: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>
	<201010281144.39307@zmi.at> <4CCA0834.8040703@hardwarefreak.com>
In-Reply-To: <4CCA0834.8040703@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201010290958.03513@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6927327742429245564=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

--===============6927327742429245564==
Content-Type: multipart/signed;
  boundary="nextPart3334121.c5ahA3UjF7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3334121.c5ahA3UjF7
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 29. Oktober 2010 Stan Hoeppner wrote:
> So as we move to a totally virtualized guest OS, we then lose the
> stripe width and stripe size information.  How much performance does
> this really cost us WRT XFS filesystem layout? =20

This is still a very straightforward config. When you use a NetApp=20
storage with virtualization, you normally use thin provisioning. So you=20
put one VM with it's root FS on that system, and assign a data disk of=20
1.4TB. You then "flexclone" that VM 9 times, so you have 10 VMs running=20
but they only use the diskspace of one. Then you upgrade or modify one=20
VM, and only the blocks that are modified get copied on the disks.=20
You fill 5 VMs in parallel with data, and it gets stored totally=20
"fragmented" on the storage. Now do a snapshot of a VM, so it's old=20
contents are frozen and every write gets written to a new place.
There are companies who do a snapshot of every VM every hour, so their=20
users can by themself recover files that they deleted/modifed wrongly.

And now take into account that NetApp uses WAFL - write anywhere file=20
layout. It means that even if you have a VM straight on disk, as soon as=20
you modify a block it can be written in a totally different place on the=20
storage.

I'd say this is such a "total mess" where you know exactly *nothing*=20
about the layout of anything. You cannot even optimize for stripe size.

> How many folks are running their
> critical core business databases in virtual machine guests?  How
> about core email systems? Other performance/business critical
> applications?

I don't know which country you are from, I'm from Austria/Europe (not=20
the kangaroo country :-). On every single tech talk and presentation I=20
visited this year, every single speaker talked about virtualization.=20
Depending on who spoke, either 2009 or 2010 were the years where more=20
virtual servers were deployed than physical ones, with a sharp increase=20
each year. We didn't sell a single server running bare-metal OS, all had=20
VMware or XenServer.

And for business critical: SAP uses virtualization everywhere in-house,=20
=D6BB (Austrian Railways) use Xen for virtualized central accounting=20
program since 2001 exclusively. These are just the 2 companies who were=20
speaking on last weeks presentation, there are far more.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3334121.c5ahA3UjF7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzKfosACgkQzhSR9xwSCbSx+ACfRT+2oMfx2ynOjTtDZbTaRDBZ
c4kAn0UX30gm1KRnSfB/I9v6diczcKrR
=8xo+
-----END PGP SIGNATURE-----

--nextPart3334121.c5ahA3UjF7--


--===============6927327742429245564==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6927327742429245564==--
