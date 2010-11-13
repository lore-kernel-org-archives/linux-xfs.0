Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oADFOIRd012847 for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 09:24:18 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 812C51776B0
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 07:25:46 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 2kL7k3Z7IY6CLLbp for
	<xfs@oss.sgi.com>; Sat, 13 Nov 2010 07:25:46 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair of critical volume
Date: Sat, 13 Nov 2010 16:25:42 +0100
References: <75C248E3-2C99-426E-AE7D-9EC543726796@ucsc.edu>
	<201011121422.28993@zmi.at>
	<BE08758D-20B4-48F1-8BF7-FCD0341D38C2@ucsc.edu>
In-Reply-To: <BE08758D-20B4-48F1-8BF7-FCD0341D38C2@ucsc.edu>
MIME-Version: 1.0
Message-Id: <201011131625.43576@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2957589349603072173=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eli Morris <ermorris@ucsc.edu>

--===============2957589349603072173==
Content-Type: multipart/signed;
  boundary="nextPart3964445.bVSuBY1gDW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3964445.bVSuBY1gDW
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 13. November 2010 Eli Morris wrote:
> This is a small University lab setup. We do not have access to a lot
> of resources. We do have a partial tape backup of this data, but...

Yes, Eli, I understand you. We also have universities as customers, and=20
I know there's no money. But you're definitely deep in shit now. Isn't=20
there another department with tape backup that you could "borrow" in=20
this state of crisis?
=20
> a) tape backup

So, if you can't do that, we forget it.
=20
> b) I don't have another system to copy the files to. (disk backup)

So, you can't even copy the rest of the still-existing data away.

The way you describe it, you will have to mess around with the existing=20
data. So first, did you run xfs-repair without "-n", so that it actually=20
repairs whatever it can? Maybe run it several times, until no more error=20
shows up. You need to ensure you are in a clean state.

Then, try to access the files that are still there. A simple script like
find /mydestroyedfs -exec dd if=3D{} of=3D/dev/null bs=3D1024k \;
would read all files once. If this causes errors, either remove the=20
problematic files, or maybe xfs-repair will clean those out then.

Now try to access the data with your application, and see which contents=20
are still valid. I guess there will be files that are truncated, or=20
partly overwritten, or otherwise badly messed. Delete all those files.

Maybe, if you're lucky, you can still use some of that data. I've once=20
had a filesystem where the first 1/3rd of the disks has been zeroed, and=20
till most files could be recovered. But then again, another customer had=20
only about 5-10% overwritten, and could drop all data because an index=20
was destroyed so the data was worthless.
It definitely depends on your app. Hopefully that app uses checksums,=20
that would make your life easier now.

> c) We are working on making sure everything is working OK. I think
> the power output from our UPS might be problematic. We are
> definitely investigating that, because it could be behind all these
> crazy problems.

I generally do the following, if only one UPS is available: put one=20
power supply on the UPS, and the other on the normal line. I hope you=20
have redundant PS, do you? That helps whenever the UPS is crazy, at=20
least the normal power is available. Better would be two different=20
UPSes, but budget is scarce very often.

> d) Checking every files' content manually is not something that is
> going to work. It would, literally, take years.

OK, so what you want to do? Just use it and hope the data is valid? If=20
you don't check the files, every calculation you do with that broken=20
data is *bogus*, so you better delete it than have wrong data, or no?
=20
> Would de-fraging the filesystem remove those zeroed files from the
> filesystem? Does anyone make a XFS utility program that might help?
> Maybe an XFS utility that can be used to remove zeroed files from
> the filesystem? Or remove files that are stored in that one bad LVM
> volume?

Maybe xfs_db can help you find and identify files that had parts or all=20
of their data in that area, and remove them.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart3964445.bVSuBY1gDW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzerfcACgkQzhSR9xwSCbTPfgCbB+z33M+oIwb2kcXcoiEpBqm8
8nQAoMoKkysL0XbOtfMldUENELs0jE+B
=rEfM
-----END PGP SIGNATURE-----

--nextPart3964445.bVSuBY1gDW--


--===============2957589349603072173==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2957589349603072173==--
