Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9438D1D517E
	for <linux-xfs@vger.kernel.org>; Mon, 16 Dec 2024 22:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.39.3.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734387534; cv=none; b=f+SfMu09GNC8yKpuoRZFrK/p7AHLQChjyv8PvoYix1Zn5R1B2klJCujLpjY4aGToe0gEBh3zVjOLWpcD84UlKq1C9iN0w0Q60f7LhpetFRRpsGenrta/dk0PtHGugf9avgnHEhQzI+FXRjn6l+of/WrrMwmnXz9uXZBkPnWpmO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734387534; c=relaxed/simple;
	bh=iIpak9iBtJBGAKEhsa5pPGQLONJBmB8xiWD1AJEtx/s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzKs4NrSomI4/VUUdBCk2Zz1KgJpSLDWmWbpN5eVd9bCcuAXwZf4hKhB7Wqt8DxLgxTDbwkx7Hwx92enhaz7UYlXXDWArtkJc4myYEqp4q8B/9PsKuoMOeWtuQUckPnI37ZN3WrELlnL+zSyMH8LYgkG/G56syVy7MrLWSVvWGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com; spf=pass smtp.mailfrom=intellique.com; arc=none smtp.client-ip=66.39.3.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intellique.com
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with ESMTP id 647EC3AE774;
	Mon, 16 Dec 2024 17:18:45 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.65.97.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id B5E143FAE72;
	Mon, 16 Dec 2024 17:18:44 -0500 (EST)
Date: Mon, 16 Dec 2024 23:18:51 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241216231851.7b265e06@harpe.intellique.com>
In-Reply-To: <20241213171537.GL6698@frogsfrogsfrogs>
References: <20241128171458.37dc80ed@harpe.intellique.com>
	<Z0jbffI2A6Fn7LfO@dread.disaster.area>
	<20241129103332.4a6b452e@harpe.intellique.com>
	<Z0o8vE4MlIg-jQeR@dread.disaster.area>
	<20241212163351.58dd1305@harpe.intellique.com>
	<20241212202547.GK6678@frogsfrogsfrogs>
	<20241213164251.361f8877@harpe.intellique.com>
	<20241213171537.GL6698@frogsfrogsfrogs>
Organization: Intellique
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.31; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/DvXTfK7+8gc9K1oU8hM2.0o";
 protocol="application/pgp-signature"; micalg=pgp-sha1
X-Scanned-By: mailmunge 3.11 on 66.39.3.162

--Sig_/DvXTfK7+8gc9K1oU8hM2.0o
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 13 Dec 2024 09:15:37 -0800
"Darrick J. Wong" <djwong@kernel.org> =C3=A9crivait:

> No, I don't think that changes anything.  If you can build your own
> kernel, can you try this out?
>=20
> --D
>=20
> xfs: don't over-report free space or inodes in statvfs

I'll give it a try, but that looks like a patch for old weird RedHat
kernel, I'm running plain vanilla generally, and much higher versions,
I'll see how it applies :)

--=20
------------------------------------------------------------------------
   Emmanuel Florac     |   Direction technique
------------------------------------------------------------------------
   https://intellique.com
   +33 6 16 30 15 95
------------------------------------------------------------------------
=20

--Sig_/DvXTfK7+8gc9K1oU8hM2.0o
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSAqoYluUD5h4D+mbZfeNBc1SJxVgUCZ2CnSwAKCRBfeNBc1SJx
Vv50AKCASfhFJbEK5pQpBmxbfFX6zR0xjgCcCKN3Wrr2rv1QIIB7/9U8F3vtKf4=
=yWpc
-----END PGP SIGNATURE-----

--Sig_/DvXTfK7+8gc9K1oU8hM2.0o--
