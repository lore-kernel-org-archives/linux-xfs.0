Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341921FA270
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.39.3.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734544057; cv=none; b=W0g88S6vdEiubrWUs+4bFLG2uZDaXQ+wkS+i5DN30HFc2QD+/jMnOJRcFcGGrF/NvorjxcfLbNBu2KWl1QnXZyv3vBRk/Ej2x2jL/old57Pz/JTyp4RdOkcgaOUm0Q8bO8fXn28jAq3CK0/gStmr+UWdfgzFumQKODaQjufTlLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734544057; c=relaxed/simple;
	bh=LD2VDILyXpIF600JImrnkxc8lPn8OJNva8l5FdSws1k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MpNrm2xZpvI/4FnIurooziOFgTIGKn6ReHmAWghNUP4Ag83mPBZ0TC2YUyW8C0tRBcgq+cdp8jH2wmVPgFp9PVbUT2kRehQ18ZOKq1U+sc+98bRjsQUuRsU1b1dCyDroGOqgiyDp2fEJz2wTLM6wMft+DvcP1MMyaNboRbVQFak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com; spf=pass smtp.mailfrom=intellique.com; arc=none smtp.client-ip=66.39.3.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intellique.com
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with ESMTP id A28403AE5F5;
	Wed, 18 Dec 2024 12:47:27 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.65.97.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id EB1A63FAE97;
	Wed, 18 Dec 2024 12:47:26 -0500 (EST)
Date: Wed, 18 Dec 2024 18:47:32 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241218184732.4e38824f@harpe.intellique.com>
In-Reply-To: <20241217165042.GF6174@frogsfrogsfrogs>
References: <20241128171458.37dc80ed@harpe.intellique.com>
	<Z0jbffI2A6Fn7LfO@dread.disaster.area>
	<20241129103332.4a6b452e@harpe.intellique.com>
	<Z0o8vE4MlIg-jQeR@dread.disaster.area>
	<20241212163351.58dd1305@harpe.intellique.com>
	<20241212202547.GK6678@frogsfrogsfrogs>
	<20241213164251.361f8877@harpe.intellique.com>
	<20241213171537.GL6698@frogsfrogsfrogs>
	<20241216231851.7b265e06@harpe.intellique.com>
	<20241217165042.GF6174@frogsfrogsfrogs>
Organization: Intellique
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.31; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0am2KlM/QGfMPSzZhWzOJdt";
 protocol="application/pgp-signature"; micalg=pgp-sha1
X-Scanned-By: mailmunge 3.11 on 66.39.3.162

--Sig_/0am2KlM/QGfMPSzZhWzOJdt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Tue, 17 Dec 2024 08:50:42 -0800
"Darrick J. Wong" <djwong@kernel.org> =C3=A9crivait:

> > > xfs: don't over-report free space or inodes in statvfs =20
> >=20
> > I'll give it a try, but that looks like a patch for old weird RedHat
> > kernel, I'm running plain vanilla generally, and much higher
> > versions, I'll see how it applies :) =20
>=20
> That's from 6.13-rc3; I don't do RH kernels.

Sorry, I've seen the line=20

> Cc: <stable@vger.kernel.org> # v2.6.18

And thought it was about some RH7.x kernel or something :)

--=20
------------------------------------------------------------------------
   Emmanuel Florac     |   Direction technique
------------------------------------------------------------------------
   https://intellique.com
------------------------------------------------------------------------
=20

--Sig_/0am2KlM/QGfMPSzZhWzOJdt
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSAqoYluUD5h4D+mbZfeNBc1SJxVgUCZ2MKtAAKCRBfeNBc1SJx
VqtKAKDrIbzaXcrhk5VjfmSODgoVTxp1PgCg8hOYpSkUuPLXZyhOwwQuBfQRe4M=
=zRsx
-----END PGP SIGNATURE-----

--Sig_/0am2KlM/QGfMPSzZhWzOJdt--
