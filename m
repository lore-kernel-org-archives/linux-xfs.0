Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3834430CC3;
	Wed,  8 Jul 2026 11:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783508626; cv=none; b=KqcdnRnDImYoCPSD8d39w9lF18q2f2goNAd2dLcgLYTY4xzFY4FQHEA4oYRnO4TpoWZAlhB4e8dBpz2R9RMS9xwGi5imfoA3zyvoAQUuMO0X8j5Al1mC8mDkWmbEKDtBxWib2N4IQ4LJMxQZE2BDv9GaFrv8y4GVrRmeUV3GIPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783508626; c=relaxed/simple;
	bh=yHUAgSb1eEb16AxJ3bFNu0aKeWlymPSXV9A6YO9rDbY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mcAxMrYWNUt0buFwS3Lw3OGVy2/vOh+6O9eaN0DnYF0PKazD4zqHX/l6D7rNZsm4BViELffNkeSzCpENcfCKULA2pRt/q0sYEVdOL4qi6xjNFL3dL5IDx5Eh3NQD7XRDD7bIar1nB39sSrfaa0LTv7bctpqSfAnJBhXXezytJik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dXz0W/Ni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dXz0W/Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70181F000E9;
	Wed,  8 Jul 2026 11:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783508617;
	bh=gZgEIFbhhHDurNxAcIf/gZP35cPhQ7y90F4O//WE7lg=;
	h=Date:From:To:Cc:Subject;
	b=dXz0W/Ni0nRLCN/+Wowigmkq5xcYjB/Z1V5QQAspVDxd4Xmq54rpqhtXeDRoJZLQa
	 5gQsw7OsGNbU0ZAbXdpndmkavssK7UeY+PMd+Tmw3mQe8hzN/KrZOlWoLaLJEyulpA
	 pYYcczBdp0MeO6q36cgIfUvHZIz6Z45j7jTH6KIrXlgx8dOFSKpe5lR1/cCPDTfKj8
	 w5eOt3ZKSU8HHQS+qAqd/zKgJD51qrF0vHtP7W0FS7N/Vfgk7gHcSy+2RijvuK315S
	 MMsTaLtMmUcYTkPpM4h5ToU873XYMSi4Ye3h83+wk242qIp8eJ9Z+4MqBw81F4tnWP
	 K74zi4ohn58Dg==
Date: Wed, 8 Jul 2026 12:03:33 +0100
From: Mark Brown <broonie@kernel.org>
To: David Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Missing signoff in the xfs tree
Message-ID: <ak4uhSXlLF3Gr576@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ltQvj/Dg9EBdH3wv"
Content-Disposition: inline


--ltQvj/Dg9EBdH3wv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit

  92d2d133c6cb3 ("xfs: fail recovery on a committed log item with no regions")

is missing a Signed-off-by from its committer

--ltQvj/Dg9EBdH3wv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpOLoQACgkQJNaLcl1U
h9Cw5gf9HgrJw/QU3D1goK8S3V8Nz+v1sVnAarTvOnh9jLW2un7ixu7+0lNdVMVV
M0zp4YihK14dgaPHxuNqLEhkUYYpYXqkhtdsNX2MAVGEcDXpxQus234amq3HTW4r
YuNqGbUTLuyxv3tH7SufUvGqQColVqe5BQCXHBbOSQagDtzHP2YtXuYv7QTyjqlz
0XApgBd3Y6XQdvPVY0QDlF4VFs2WGtVT8Ykg0pUX0vsnnqtO4tSx0N68rUPTl+sc
TXm9fPVYGydV73HK8dgBUAhEEzSBonjlNXIWW4CW7blISGFMXn5sUtaREyP52cgR
aXeNmcOFH+Dcg7mkbQLpu6AXkFy5fw==
=jehh
-----END PGP SIGNATURE-----

--ltQvj/Dg9EBdH3wv--
