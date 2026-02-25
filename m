Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1621B24DCF9;
	Wed, 25 Feb 2026 11:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772018378; cv=none; b=bEUpRJN91EtRSM2CuL7Und+Z7+sm1e0NzQODmyGZwWvQBDRlEcR2AV7Cn1d9q+Ym6ogOzRVhLMlWHDXUdLXoo2dFfYOxMS/8/fAVHSPOQvxfVi00kuavMK3aaO3NwiK6K77d2hexfloiTvzFD81iemMALLpW//V8peABTCYxb9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772018378; c=relaxed/simple;
	bh=N/K2uCq6NUduyEgCdEL1GBvdgprFIfL2UyWPq6xAWhA=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LO6E+mhK6gxfsieRZvvx4fF1fo5UdEbIRY57E0VtAqxKuejxkzQPYQv3gCjfxqUp4EMheuOBRBaNZGbB4W4I9LrRseHUr6o0mkZe/GPiYoGfcajmRuC0LGceph161t6kv5NzJit8rj5X1fK1tHbCEUFBmf48+Bk0rhprT6oWqvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOYtWjWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOYtWjWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82189C116D0;
	Wed, 25 Feb 2026 11:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772018377;
	bh=N/K2uCq6NUduyEgCdEL1GBvdgprFIfL2UyWPq6xAWhA=;
	h=Date:From:To:Cc:Subject:From;
	b=TOYtWjWJbXuKbrrbbwBi7y0M73WAkgMzs78FQX4ZriMpVLRPX0ENdjhZZ8JAPRU1Y
	 dlt5qOE70niP4ARiQTsfCjNQMI7R2UAQYd2Y1laa81OKN8QvxfVzXqFTMZq7n8g+NM
	 EVC0cK5GAAs3RxWWnA0fdeR0DaZ3LYJ84IAjcx1bB8t5J0sB5fwv54Y8b7ATOkvl4P
	 2wvM3X1XHni3viWlpYSwcWWYE0rkVKDbYZ2OSw5btEgP1J/kudwU0pIWsmssHBeE26
	 i6SfbUZO091n0dTUNHf2aeOPDKoAJmNkO9JJ5/k2QY2EZ+ESXU110nh+4oF6bP48+F
	 ANz7cwh5JHo4g==
Date: Wed, 25 Feb 2026 11:19:33 +0000
From: Mark Brown <broonie@kernel.org>
To: David Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Missing signoff in the xfs tree
Message-ID: <aZ7axQdS829sxNtl@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Gk5Qg0g6IDFwkxyc"
Content-Disposition: inline


--Gk5Qg0g6IDFwkxyc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commits

  d412c65646d37 ("xfs: don't report half-built inodes to fserror")
  d33f104ea40e7 ("xfs: don't report metadata inodes to fserror")
  253b1a2ac9db6 ("xfs: fix potential pointer access race in xfs_healthmon_get")
  fd992a409aef6 ("xfs: fix xfs_group release bug in xfs_dax_notify_dev_failure")
  61a02d38303fa ("xfs: fix xfs_group release bug in xfs_verify_report_losses")
  9ee0cb71de74b ("xfs: fix copy-paste error in previous fix")

are missing a Signed-off-by from their committers

--Gk5Qg0g6IDFwkxyc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmme2sUACgkQJNaLcl1U
h9BQGwf/ccDGX1KJTn+mRkLyVXY2lYgV1pXS4IQv1iIagiVOdHxOOIe5YD6OO1at
REYebAoPdMW/AAXMFfMAQgioAapFh92NAo3VrgF3QBNNupLYA+g1NuhPIB7Ig//z
idBnGyU6A/lyUm23/K4Cv8SkrOMKYb2Ka6FbjCJiuNkBfXwnAYZNAQv2xj5JhSEN
/ADqywtrZ+SUg5ZyAR/KAuAMP0zvUaNthjuCCLsRGjtQnSHWu9cPdJvVSOuLYlqZ
pEBjCvSlscKuxEjWi2OyBQEl6cgB/f+xzg2UEOn4p4Hky1Wa7OpOdCTP5bB9Qn59
gHefvBilmdouw1Tjgnc1tnMs54QXQg==
=W9Rw
-----END PGP SIGNATURE-----

--Gk5Qg0g6IDFwkxyc--
