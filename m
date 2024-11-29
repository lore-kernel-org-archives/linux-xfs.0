Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD27138DD1
	for <linux-xfs@vger.kernel.org>; Fri, 29 Nov 2024 09:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.39.3.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732872816; cv=none; b=P6t8RBhMzmXb1O7XDMOnGJ0Mx0YaaqP3nStfdMsRtR21a/GI+RyW2RiJI8y+ZGjPTTBzbTHTbGL0SuD+g7EMDIn3IuW55SWxMqw1ueiCTBK1hWTocNq1uPhtofwo+K2GvonAP0OZpnsLZwdInKIkiwd0Fyqs0xxsY22ymWypybc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732872816; c=relaxed/simple;
	bh=Eq0CgW6SHg+qpsxOrsmP4Vktyb3rxx69Acy/dnZcXsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sEuj+t0Q7X7sWGZ4c2tOPNQESPdSKf6318TilfHCYp1974kz4lEQTo7oSFzi0/2/HJx6LoXA0xML3J8OgR51HdBxXBieHF97MydtL7Qs4rE5OnWeDs2KQwOWlEJpwdnnJISzD8FcceuO/g46Pgxk5y8du7ejfn/I++P41ZRL/gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com; spf=pass smtp.mailfrom=intellique.com; arc=none smtp.client-ip=66.39.3.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intellique.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intellique.com
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
	by mail1.g1.pair.com (Postfix) with ESMTP id 9C5E23AE64C;
	Fri, 29 Nov 2024 04:33:32 -0500 (EST)
Received: from harpe.intellique.com (labo.djinux.com [82.65.97.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail1.g1.pair.com (Postfix) with ESMTPSA id 2D6AF3FB1D7;
	Fri, 29 Nov 2024 04:33:32 -0500 (EST)
Date: Fri, 29 Nov 2024 10:33:32 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Weird behaviour with project quotas
Message-ID: <20241129103332.4a6b452e@harpe.intellique.com>
In-Reply-To: <Z0jbffI2A6Fn7LfO@dread.disaster.area>
References: <20241128171458.37dc80ed@harpe.intellique.com>
	<Z0jbffI2A6Fn7LfO@dread.disaster.area>
Organization: Intellique
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.31; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8bkI/qfuYBDJREsEG6CGFwG";
 protocol="application/pgp-signature"; micalg=pgp-sha1
X-Scanned-By: mailmunge 3.11 on 66.39.3.162

--Sig_/8bkI/qfuYBDJREsEG6CGFwG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Fri, 29 Nov 2024 08:07:09 +1100
Dave Chinner <david@fromorbit.com> =C3=A9crivait:

> > As far as I understand, and from my tests, on folders on which a
> > project quota is applied, either the available quota or the actually
> > avialable space should be reported when using "df". =20
>=20
> Only if you are using project quotas as directories quotas. i.e.
> the directory you are querying with df needs to have the
> XFS_DIFLAG_PROJINHERIT flag set on it for df to behave this way.

Interesting, and how is this set ? I basically set up quotas using
something like

xfs_quota -x -c 'project -s -p /mnt/raid/project1 10' /mnt/raid

xfs_quota -x -c "limit -p bhard=3D30000g 10" /mnt/raid


> > However on a
> > running system (Debian 12, kernel 6.1 Debian) I have incoherent
> > results: =20
>=20
> 32 bit or 64 bit architecture?

AMD64, the most common one.
=20
> > The volume /mnt/raid is 100 TB and has 500GB free.
> >=20
> > There are several folders like /mnt/raid/project1,
> > /mnt/raid/project2 etc with various quotas (20TB, 30TB, etc). =20
>=20
> Output of df and a project quota report showing usage and limits
> would be useful here.
>=20
> Then, for each of the top level project directories you are querying
> with df, also run `xfs_io -rxc "stat" <dir>` and post the output.
> This will tell us if the project quota is set up correctly for df to
> report quota limits for them.
>=20
> It would also be useful to know if the actual quota usage is correct
> - having the output of `du -s /mnt/raid/project1` to count the
> blocks and `find /mnt/raid/project1 -print |wc -l` to count the
> files in quota controlled directories. That'll give us some idea if
> there's a quota accounting issue.
>=20

OK, I'll run these as soon as I have a connection to the system. There
seemed to be no error with the reported used space though, only
available remaining space in quota'ed directories; however df reports
actually available space for directories without quota set.


--=20
------------------------------------------------------------------------
   Emmanuel Florac     |   Direction technique
------------------------------------------------------------------------
   https://intellique.com
------------------------------------------------------------------------
=20

--Sig_/8bkI/qfuYBDJREsEG6CGFwG
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQSAqoYluUD5h4D+mbZfeNBc1SJxVgUCZ0mKbAAKCRBfeNBc1SJx
VoRmAJ4kafAnimSSLmS5LvC+6rIc9xd5OwCeJ1fxqtRUoqsXVcSp91ZHlw3t+Nc=
=EkIN
-----END PGP SIGNATURE-----

--Sig_/8bkI/qfuYBDJREsEG6CGFwG--
