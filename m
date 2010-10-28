Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9S9c2UJ005920 for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 04:38:03 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C31C136A153
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 02:55:01 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3Tl4GhNYE4ak5Ckc for
	<xfs@oss.sgi.com>; Thu, 28 Oct 2010 02:55:01 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Pid: 8345, comm: rsync Not tainted 2.6.32.22intel #1
Date: Thu, 28 Oct 2010 11:39:15 +0200
References: <4CC67450.9020602@profihost.ag> <201010271258.45965@zmi.at>
	<20101027205955.GB2715@dastard>
In-Reply-To: <20101027205955.GB2715@dastard>
MIME-Version: 1.0
Message-Id: <201010281139.15612@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6430747286182429486=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6430747286182429486==
Content-Type: multipart/signed;
  boundary="nextPart3669896.hilC8ngFOL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3669896.hilC8ngFOL
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 27. Oktober 2010 Dave Chinner wrote:
> > Also, I'd need to find information and learn how to tweak udev
> > hotplug  rules.
>=20
> GIYF.

Thanks, I know how to search ;-)
*Finding* the information doesn't mean *understanding* how to do it. It=20
takes time.

> You'd need one regex per device type you want to tweak with
> different values.
> This is not "cool new stuff" - I've seen it used for exactly this
> purpose for several years by distros. e.g. pulling the identifier
> string from the device to set hardware device specific tunables,
> changing default dm/md readahead, etc. It's not new, and is easy to
> configure generically so it works on a wide array of different
> machines.

I meant: When upgrading the system from 11.1 to 11.2, I'm sure the=20
system replaces the correspondig script, or at least messes around with=20
them. I know /etc/init.d/boot.local stays the same.
=20
> And if you hotplug devices, it just works automatically - you don't
> need to rerun a script after every hotplug...

Now that indeed is a pretty good advantage.

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

--nextPart3669896.hilC8ngFOL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzJRMMACgkQzhSR9xwSCbTt8ACdEbCWqJd0KUtUjrwPNXpDFvAP
NOMAnjHalSdVLDVJ8MGmNUA1Z5QIjVrP
=2S5r
-----END PGP SIGNATURE-----

--nextPart3669896.hilC8ngFOL--


--===============6430747286182429486==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6430747286182429486==--
