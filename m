Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailer.gwdg.de ([134.76.10.26]:37861 "EHLO mailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbfEBP1k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 May 2019 11:27:40 -0400
Date: Thu, 2 May 2019 17:27:36 +0200
From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190502152736.GW2780@tuebingen.mpg.de>
References: <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
 <20190501165933.GF2780@tuebingen.mpg.de>
 <20190501171529.GB28949@kroah.com>
 <20190501175129.GH2780@tuebingen.mpg.de>
 <20190501192822.GM5207@magnolia>
 <20190501221107.GI29573@dread.disaster.area>
 <20190502114440.GB21563@kroah.com>
 <20190502132027.GF11584@sasha-vm>
 <20190502141025.GB13141@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="p51eBkY87UC7w4vh"
Content-Disposition: inline
In-Reply-To: <20190502141025.GB13141@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, stable@vger.kernel.org


--p51eBkY87UC7w4vh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 02, 16:10, Greg Kroah-Hartman wrote
> Ok, then how about we hold off on this patch for 4.9.y then.  "no one"
> should be using 4.9.y in a "server system" anymore, unless you happen to
> have an enterprise kernel based on it.  So we should be fine as the
> users of the older kernels don't run xfs.

Well, we do run xfs on top of bcache on vanilla 4.9 kernels on a few
dozen production servers here. Mainly because we ran into all sorts
of issues with newer kernels (not necessary related to xfs). 4.9,
OTOH, appears to be rock solid for our workload.

But I'm OK with holding off on the patch. According to Darrick, the
issue that is fixed by the patch should not cause serious problems
anyway if xfs debugging is turned off.

Best
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--p51eBkY87UC7w4vh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMsMZQAKCRBa2jVAMQCT
D1twAKCHlJmKSEhsDdu3KQ1I3VhMI0R/SgCeICxAgVEHs43F4Q5AL+8Se1Mjr9U=
=gd6x
-----END PGP SIGNATURE-----

--p51eBkY87UC7w4vh--
