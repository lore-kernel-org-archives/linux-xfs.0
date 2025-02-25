Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C26F21D3EB
	for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2025 20:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740515256; cv=none; b=ZXlZlDeccDO9y/ObOn2yfvqbS5HhlUORz+nCLnaWeM8MnfWfHf/6pOvRUw0m0DzGnM6PK8vQqCRa7VwpK4N1rCdOckfi7R5tG/6mPkBezysCwf4/caXeAAFeGSvNMzbJjpKS1P295M0GfnqRBURBA9qb4lytYbuyzI2KUTFvTtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740515256; c=relaxed/simple;
	bh=oZERClqfDLXmFStpZ87ci452EiykCqig6u/w5s9tfXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W2kuRla+ye597NwSLKS0/omktCCnRC5+Qnn4ek0WRVdnAR1dgqpn35zYRAcFGYWeR3s+ZN1WP20UghXUeYEkXrszDHHKCtAGwmDC1+JnuF/8bQN2SHQSh5VL5a+9pT1gPGP6f15veXzyfNcQTYybRU1JAs5qe7DHhrgN1mOnw6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <mkl@pengutronix.de>)
	id 1tn1WT-00041c-9F; Tue, 25 Feb 2025 21:27:21 +0100
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
	by drehscheibe.grey.stw.pengutronix.de with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <mkl@pengutronix.de>)
	id 1tn1WS-002pgN-2s;
	Tue, 25 Feb 2025 21:27:20 +0100
Received: from pengutronix.de (p5b164285.dip0.t-ipconnect.de [91.22.66.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	(Authenticated sender: mkl-all@blackshift.org)
	by smtp.blackshift.org (Postfix) with ESMTPSA id 461863CBC72;
	Tue, 25 Feb 2025 20:27:20 +0000 (UTC)
Date: Tue, 25 Feb 2025 21:27:18 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yaron Avizrat <yaron.avizrat@intel.com>, Oded Gabbay <ogabbay@kernel.org>, 
	Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>, 
	James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Chris Mason <clm@fb.com>, 
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	Jens Axboe <axboe@kernel.dk>, Xiubo Li <xiubli@redhat.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Sebastian Reichel <sre@kernel.org>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Frank Li <Frank.Li@nxp.com>, Mark Brown <broonie@kernel.org>, 
	Shawn Guo <shawnguo@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, Fabio Estevam <festevam@gmail.com>, 
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, Hans de Goede <hdegoede@redhat.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, 
	Selvin Xavier <selvin.xavier@broadcom.com>, Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-xfs@vger.kernel.org, linux-nvme@lists.infradead.org, 
	cocci@inria.fr, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-spi@vger.kernel.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-sound@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net, ceph-devel@vger.kernel.org, 
	platform-driver-x86@vger.kernel.org, imx@lists.linux.dev, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 13/16] spi: spi-imx: convert timeouts to
 secs_to_jiffies()
Message-ID: <20250225-cuddly-cobalt-hoatzin-e51fa3-mkl@pengutronix.de>
References: <20250225-converge-secs-to-jiffies-part-two-v3-0-a43967e36c88@linux.microsoft.com>
 <20250225-converge-secs-to-jiffies-part-two-v3-13-a43967e36c88@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="u45zipechepd67vw"
Content-Disposition: inline
In-Reply-To: <20250225-converge-secs-to-jiffies-part-two-v3-13-a43967e36c88@linux.microsoft.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-xfs@vger.kernel.org


--u45zipechepd67vw
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 13/16] spi: spi-imx: convert timeouts to
 secs_to_jiffies()
MIME-Version: 1.0

On 25.02.2025 20:17:27, Easwar Hariharan wrote:
> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> secs_to_jiffies().  As the value here is a multiple of 1000, use
> secs_to_jiffies() instead of msecs_to_jiffies() to avoid the multiplicati=
on
>=20
> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
> the following Coccinelle rules:
>=20
> @depends on patch@
> expression E;
> @@
>=20
> -msecs_to_jiffies
> +secs_to_jiffies
> (E
> - * \( 1000 \| MSEC_PER_SEC \)
> )
>=20
> Acked-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--u45zipechepd67vw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEn/sM2K9nqF/8FWzzDHRl3/mQkZwFAme+J6EACgkQDHRl3/mQ
kZxJmwgAjTBuQGjYsvjY3usfUGQlEX04CIIY/fXUbuNzg4k+rDZYBJVygyeWMSjH
P09FwLbjh/3LifMz41UC89WtofRA/pYz/koXNfKNHmOgy3F49mc9hZdB5bWYREeh
pt/7hAditNxNFMWvhHfZTFosdWI0f8QzpbcRF1N2bpFG+XIbVNCkzo7FD1IWzvtR
GOEwRfExkjtczf6yPcr0Lt5Fvh/Z2kD8uSH227AVm5XLZ9mTp9IzOmS6B2LTYfDi
YMDx5tD4fzYZ5KakPtBlEogWj3yg2pX6DpQETIHYrH7G5Or7uM9m8vWp9e29TGNH
hi/ia9fePGWAvvBB/1tngbAZUlNvSA==
=n4uD
-----END PGP SIGNATURE-----

--u45zipechepd67vw--
