Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8D14EB879;
	Wed, 30 Sep 2026 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.39.3.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790775032; cv=none; b=U0THTk8m2Hw0AfK2dPOe5frNcpkcJjzg9a6/1Xc+wp4SU39cCHGiOLQGQt3K3VR2SsijSFqDfuIcmeGt/+g7XYaM/q1xItQxE9kWx62Dz5tYt1Juk3vGEqFMGIvlP8b8vHuLpaOVEpPQ/f7PhFFvIxpaq3FQ9R109JppUg61Xpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790775032; c=relaxed/simple;
	bh=sVjABdqhjmuNkkzsMBu4c5TIHH/+v5t6dX2cIg2qfEw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ni90HSaX97nz/T1QGmYMRaXPZpXuJ+VCR8vPXa0c/1VyE1XcIgqYSebtFTynjz71wM+xdOVhRQSpU6xbMTGW7fSlOGe08vWf0PRCaT25i6bmUKdL1piismacbO3564XdY+VN8SrXegIPAq1UBY+Ulj4dlkOH/qBq5RDssSzzL9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com; spf=pass smtp.mailfrom=intellique.com; arc=none smtp.client-ip=66.39.3.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intellique.com
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with ESMTP id B188C164A03;
	Wed, 30 Sep 2026 09:24:11 -0400 (EDT)
Received: from harpe.intellique.com (841317934.box.freepro.com [45.80.20.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id 0F44E164A2B;
	Wed, 30 Sep 2026 09:24:10 -0400 (EDT)
Date: Wed, 30 Sep 2026 15:24:13 +0200
From: Emmanuel Florac <eflorac@intellique.com>
To: Steve Shoecraft <spshoecraft@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
Subject: Re: [RFC] MXFS: a shared-disk clustered filesystem derived from XFS
Message-ID: <20260930152413.65f75808@harpe.intellique.com>
In-Reply-To: <BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>
References: <56847E8D-EA83-4984-82F3-9BC93E4C02FF@gmail.com>
	<ardhDI-Ko7b5RccH@infradead.org>
	<BC228018-42A4-4715-B186-057AFDE8A4D0@gmail.com>
Organization: Intellique
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.31; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Arx9V7pPMExG+5daeoox3Y.";
 protocol="application/pgp-signature"; micalg=pgp-sha1
X-Scanned-By: mailmunge 3.10 on 66.39.3.162

--Sig_/Arx9V7pPMExG+5daeoox3Y.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Sat, 26 Sep 2026 07:32:27 -0500
Steve Shoecraft <spshoecraft@gmail.com> =C3=A9crivait:

> Intent is a good clustered FS for Proxmox to compete with vSphere and
> VMFS.  Yes, I=E2=80=99m aware of the differences in implementations.
>=20

What's wrong with OCFS2 and other already existing numerous cluster
filesystems?

--=20
------------------------------------------------------------------------
   Emmanuel Florac     |   Direction technique
------------------------------------------------------------------------
   https://intellique.com
   +33 6 16 30 15 95
------------------------------------------------------------------------
=20

--Sig_/Arx9V7pPMExG+5daeoox3Y.
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSAqoYluUD5h4D+mbZfeNBc1SJxVgUCar0NfQAKCRBfeNBc1SJx
VqX4AKCUbAD/ymmzuHv4XsTdkcnUZEtS6ACgumeUmy0Q5V6MqWoBrmziJ82GsOs=
=9y20
-----END PGP SIGNATURE-----

--Sig_/Arx9V7pPMExG+5daeoox3Y.--
