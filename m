Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF377AE72
	for <linux-xfs@vger.kernel.org>; Tue, 12 Mar 2024 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254752; cv=none; b=ZpltdtvQ8YIi5Ojg9dD2Y9hgYv+QSzrb6NeGm6BdxZehzYHxQ2OoP3Lx3Fycxwa4k7fGFS7u73x6DXF7ABPQzn8iSEMB9guPwd/SrPSKcf9XOrhCxjvMEKpsAR7M0ZOdGLQYRE3/ha7ZsCqedFQkGmlCB4dw0GVZwFtdnvLrb6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254752; c=relaxed/simple;
	bh=t0cFqoV0fjb8tTDlSnL2xTUwybfl/OIZ/8TZiWlMg4I=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=pQjcAIWswJMymqgtGsUW/bKrzPm2fu3/CyG4Xs2XO5hzLIqTzVvFhbH8mt46y4++mtmXIzhqhfucmxbitVIVGONwPOhkPZRL2Pi4Q38Ez778dWAB5YiuNkpn01Ohwi8SpzTkcmi4xLI9ZMavOGwi2ni9cAsKhuhVFmNv6oHPbE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me; spf=pass smtp.mailfrom=maiolino.me; dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b=LkGs+muB; arc=none smtp.client-ip=185.70.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=maiolino.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maiolino.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maiolino.me header.i=@maiolino.me header.b="LkGs+muB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maiolino.me;
	s=protonmail; t=1710254742; x=1710513942;
	bh=4p2Nv5powM353qdvqRtZyVy1FELLETWD5xFTK/nI4ZM=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=LkGs+muBK990UBEKj6QR2Wk/XJNfCiPsJ57l7bRY7cgMhNeH2cj9yJYXHK5mPYHf6
	 HNUiYQgDGPcJzXAnDEtK5HJWD4mRbhYIyC0Nnv19LCHYnxkKmZkZdj2JtpWHnecnab
	 ybaFJ62d6jvYosPRJUD8sBaEtITJlVZa+k+42LcQxTffbBEuUKFO3l6lx1KmM56BcW
	 PGsfsGYs32yIKt4jX8RqZMOKe5i4g2uOYdouLGq4mkCZp18JNy+jGM02TkskxPenc8
	 BWobpAMB2ugPFwjn3oM+YFubeNpGjM7Ezfey8fvEFtHOw1/6V2p9ezyedvzVF5QXya
	 wxfJiBMseGBtg==
Date: Tue, 12 Mar 2024 14:45:14 +0000
To: linux-xfs@vger.kernel.org
From: Carlos Maiolino <carlos@maiolino.me>
Subject: [ANNOUNCE] xfsdump: for-next updated to 252b097
Message-ID: <pbubbjeox7a6zkgxytxlr6h3j45smcswbnyhpth2lv4fc4gvw6@5s34pvajqn3s>
Feedback-ID: 28765827:user:proton
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------a6c56bd5c124c3463cf2cbf11f868fb44765e78fd7b76e9eaa278994e30ac345"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------a6c56bd5c124c3463cf2cbf11f868fb44765e78fd7b76e9eaa278994e30ac345
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Mar 2024 15:45:11 +0100
From: Carlos Maiolino <carlos@maiolino.me>
To: linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsdump: for-next updated to 252b097
Message-ID: <pbubbjeox7a6zkgxytxlr6h3j45smcswbnyhpth2lv4fc4gvw6@5s34pvajqn3s>
MIME-Version: 1.0
Content-Disposition: inline

Hello.

The xfsdump for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

252b0979e97b23a17cafae303040c4a7f942bb3b

2 new commits:

Christoph Hellwig (1):
      [252b097] xfsdump/xfsrestore: don't use O_DIRECT on the RT device

Pavel Reichl (1):
      [577e51a] xfsdump: Fix memory leak

Code Diffstat:

 doc/xfsdump.html  |  1 -
 dump/content.c    | 46 +++++++++-------------------------------------
 restore/content.c | 41 +----------------------------------------
 restore/tree.c    | 15 ++++++++++++++-
 4 files changed, 24 insertions(+), 79 deletions(-)

--------a6c56bd5c124c3463cf2cbf11f868fb44765e78fd7b76e9eaa278994e30ac345
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wnUEARYIACcFAmXwanoJEOk12U/828uvFiEEj32Dn/1+aNUZzl9s6TXZT/zb
y68AAK3YAQDeBrmRbLVPuhyXBYlk7wy5n+lLt6CDgW/01uGdDTS/8QD/TWiy
MteqMV04/GcPj9rrKLVcdjsGnEhvwu5iDcostAM=
=XfO0
-----END PGP SIGNATURE-----


--------a6c56bd5c124c3463cf2cbf11f868fb44765e78fd7b76e9eaa278994e30ac345--

