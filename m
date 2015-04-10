Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B80AA7F95
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 23:43:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5DD91AC003
	for <xfs@oss.sgi.com>; Thu,  9 Apr 2015 21:43:45 -0700 (PDT)
Received: from asuka.romanrm.net (asuka.romanrm.net [128.199.93.76]) by
	cuda.sgi.com with ESMTP id f39SW6TDxl1joo8D (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Apr 2015 21:43:40 -0700 (PDT)
Date: Fri, 10 Apr 2015 09:43:36 +0500
From: Roman Mamedov <rm@romanrm.net>
Subject: Re: interesting MD-xfs bug
Message-ID: <20150410094336.33cdba6b@natsu>
In-Reply-To: <20150410013156.GH15810@dastard>
References: <5526E8E9.3030805@gmail.com> <20150409221846.GG13731@dastard>
	<5526FB2A.8060704@gmail.com> <20150409225322.GH13731@dastard>
	<20150409231035.GI13731@dastard>
	<20150410093652.73204748@notabene.brown>
	<20150410013156.GH15810@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1031957267383969223=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, xfs <xfs@oss.sgi.com>, Joe Landman <joe.landman@gmail.com>

--===============1031957267383969223==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZzbDQ9jto2x/hOQhWcnDrTf"; protocol="application/pgp-signature"

--Sig_/ZzbDQ9jto2x/hOQhWcnDrTf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Apr 2015 11:31:57 +1000
Dave Chinner <david@fromorbit.com> wrote:

> RAID 0 on different sized devices should result in a device that is
> twice the size of the smallest devices

> Oh, "RAID0" is not actually RAID 0 - that's the size I'd expect from
> a linear mapping.

> it's actually a stripe for the first 10GB, then some kind of
> concatenated mapping of the remainder of the single device.

It might be not what you expected, but it's also not a bug of any kind, just
the regular behavior of mdadm RAID0 with different sized devices (man md):

       If devices in the array are not all the same size, then once the sma=
ll=E2=80=90
       est device has been  exhausted,  the  RAID0  driver  starts  collect=
ing
       chunks  into smaller stripes that only span the drives which still h=
ave
       remaining space.

Once or twice this came VERY handy for me in real life usage.

--=20
With respect,
Roman

--Sig_/ZzbDQ9jto2x/hOQhWcnDrTf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlUnVPgACgkQTLKSvz+PZwjkbwCeIoi2jyzrVKBj9c2u+Fsaom4e
9b0An157JtrqUfIAAtWz6bCp5RjJ11z0
=Un6C
-----END PGP SIGNATURE-----

--Sig_/ZzbDQ9jto2x/hOQhWcnDrTf--


--===============1031957267383969223==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1031957267383969223==--
