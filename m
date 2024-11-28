Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427721C2DC8
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.39.3.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732810924; cv=none; b=trsCAn1xVIHA/dB8quscClaHWlgARCslFvixbJj1gbcaE7HrwBo6WY9YZcBvL67QFAd8K4+J2KzXwzKxHAn9G9ei4vvenQRZX74ibtu8MT/aeNGTDzZ2SJf1nCPqkPBqstz9ZBA9DBa634g8cRI126GC6Z1ejlDpIju/h4u8Pnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732810924; c=relaxed/simple;
	bh=y2389uiQyST4uinBcUMyu89uQOlMwDh107/7iw1M4Pg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=bD2HrsrvRQB8kXMKrUypKen0qljF1rTobbqXvrn7iSf5PY6hlZ/2SnQ7a0LkkUfDrAOPXTiqGzismmxF6UcoHsZQKBvgjJ6WhXqRzYAnUHrVp95sTBatzYPfzaHPQeJZbWpfShdvnDOgxK9b4IWKN4quMdyVJruGC4sPimclblw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com; spf=pass smtp.mailfrom=intellique.com; arc=none smtp.client-ip=66.39.3.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intellique.com
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with ESMTP id 9656B3AE401
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 11:14:54 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.65.97.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id 2BA643FAED8
	for <linux-xfs@vger.kernel.org>; Thu, 28 Nov 2024 11:14:54 -0500 (EST)
Date: Thu, 28 Nov 2024 17:14:58 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: linux-xfs@vger.kernel.org
Subject: Weird behaviour with project quotas
Message-ID: <20241128171458.37dc80ed@harpe.intellique.com>
Organization: Intellique
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.31; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//vF.iOvxpenp5WyBM90fWT.";
 protocol="application/pgp-signature"; micalg=pgp-sha1
X-Scanned-By: mailmunge 3.11 on 66.39.3.162

--Sig_//vF.iOvxpenp5WyBM90fWT.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hello,

As far as I understand, and from my tests, on folders on which a
project quota is applied, either the available quota or the actually
avialable space should be reported when using "df". However on a
running system (Debian 12, kernel 6.1 Debian) I have incoherent results:

The volume /mnt/raid is 100 TB and has 500GB free.

There are several folders like /mnt/raid/project1, /mnt/raid/project2
etc with various quotas (20TB, 30TB, etc).

Though there are only 500 GB free on the whole filesystem, "df
/mnt/raid/project1" etc reports several TB available, which is the
remaining quota for the folder. Of course the users are led to believe
there is more space available than what's actually the case (in fact
that's why the volume is down to so little space) which causes all sort
of problems.

What's strange is that I can't reproduce this behaviour on another
system. Every time I try to reproduce it, available space reported by
df on a project quota folder matches actual available space.

Any idea on what could be going wrong ?

--=20
------------------------------------------------------------------------
   Emmanuel Florac     |   Direction technique
------------------------------------------------------------------------
   https://intellique.com
   +33 6 16 30 15 95
------------------------------------------------------------------------
=20

--Sig_//vF.iOvxpenp5WyBM90fWT.
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSAqoYluUD5h4D+mbZfeNBc1SJxVgUCZ0iXAgAKCRBfeNBc1SJx
VnLqAKDuFKcYBAsv9xY2a2SMXwgpZbWXegCg3goN1rGLG9wUJiRGpUXznsusptk=
=bP5s
-----END PGP SIGNATURE-----

--Sig_//vF.iOvxpenp5WyBM90fWT.--
