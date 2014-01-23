Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEDEC7F6F
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 08:29:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7C701AC003
	for <xfs@oss.sgi.com>; Thu, 23 Jan 2014 06:29:57 -0800 (PST)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id 0mwZgfh7ypAKnXes for
	<xfs@oss.sgi.com>; Thu, 23 Jan 2014 06:29:52 -0800 (PST)
Date: Thu, 23 Jan 2014 15:29:35 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Weird XFS Corruption Error
Message-ID: <20140123152935.0f555074@harpe.intellique.com>
In-Reply-To: <20140123151943.281baa04@harpe.intellique.com>
References: <CDBC891F-BCF6-4B9B-ADDB-9E143973D188@inovex.de>
	<20140123151943.281baa04@harpe.intellique.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4417191431603377394=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Sascha Askani <saskani@inovex.de>, xfs@oss.sgi.com

--===============4417191431603377394==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pdTAmy/2EJBkN0dAd.r5nrH"; protocol="application/pgp-signature"

--Sig_/pdTAmy/2EJBkN0dAd.r5nrH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Thu, 23 Jan 2014 15:19:43 +0100
Emmanuel Florac <eflorac@intellique.com> =E9crivait:

> OTOH it looks really similar to an older bug :
>=20
> http://oss.sgi.com/archives/xfs/2013-02/msg00482.html
>=20
> AFAIK this one could be related to the current Ubuntu LTS lvm stack...
> We need Dave's advice on this one.
>=20

Yes, I guess we're getting closer:
https://www.redhat.com/archives/dm-devel/2013-February/msg00113.html

"It's reproducable on lots of different kernels, apparently - 3.8,
3.4.33, CentOS 6.3, debian sid/wheezy and Fedora 18 were mentioned
specifically by the OP - so it doesn't look like a recent
regression or constrained to a specific kernel."

And
https://www.redhat.com/archives/dm-devel/2013-February/msg00122.html :

"Was issue_discards enabled in lvm.conf?

If so, as Alasdair said, this lvm2 2.02.97 fix is needed:
http://git.fedorahosted.org/cgit/lvm2.git/commit/?id=3D07a25c249b3e "


What is the version of lvm ( dpkg -l lvm2 )?


--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/pdTAmy/2EJBkN0dAd.r5nrH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlLhJ08ACgkQX3jQXNUicVYiRACglx4OHXmPvU1dVJrYKO3ysbla
5vkAnjZewUX0YVyjLBGrwcxMVsZ4Jo8r
=zqen
-----END PGP SIGNATURE-----

--Sig_/pdTAmy/2EJBkN0dAd.r5nrH--


--===============4417191431603377394==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4417191431603377394==--
