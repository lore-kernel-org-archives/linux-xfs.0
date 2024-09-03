Received: from mail.flyingcircus.io (mail.flyingcircus.io [212.122.41.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE591C766C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Sep 2024 09:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.122.41.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725355415; cv=none; b=BnfQgt799WCgRZFHRaE3OPReue05uSEhsFVo5E3WghUsZGk4fKJgSrk3sUTG4cQRmWK7ejricGzgx6YDz/q4Qouk+IWdhcnUntBjG175aWUmlZH+13HMMYF2jGrWMqQq/b8rRuORywwpilW0iix1hfCD+BxwQsoO2HC2mPRqBXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725355415; c=relaxed/simple;
	bh=sDJPZ7dWRLgn3DK8a8UmemnQ3gzEzJvs7Ix5kRL41o0=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=bh/A6ZS3rZ2BCKWuIBnHJGRBPq7T9zwytGqaj8rPdK73asxecTavsItansMy+7gq7qRQIQsF0MyTze5/MDIuM5y038jm+YicNIJmr9rU8ljf9jC85/PqL0HFLUGbn6cJAhjP2DnsXfIEjdn5XKUDx3Yrm4Ex1ELsn/GFXnG/Ac4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io; spf=pass smtp.mailfrom=flyingcircus.io; dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b=cFDnMpho; arc=none smtp.client-ip=212.122.41.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flyingcircus.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=flyingcircus.io header.i=@flyingcircus.io header.b="cFDnMpho"
From: Christian Theune <ct@flyingcircus.io>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flyingcircus.io;
	s=mail; t=1725355402;
	bh=sDJPZ7dWRLgn3DK8a8UmemnQ3gzEzJvs7Ix5kRL41o0=;
	h=From:Subject:Date:Cc:To;
	b=cFDnMphogOn0FdO/SBGNd5rzYo3GMbdO6TmTdnq4wecf7yO1Ja5tdfK7n59bsz9TT
	 H91tsBkpvA/ZXl+6GDrvbH7kDq9YOKOR9eB5X3Y35rcM9YxeLbyXLgOutJFU/x2Xok
	 NvZSGsL2O5z+TBiW6d52BAXWah9Bb7rlJKSXeo2E=
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Any new insights on large folio issues causing data loss?
Message-Id: <666A596B-9C9D-4D59-83EA-7DB2B2C3867E@flyingcircus.io>
Date: Tue, 3 Sep 2024 11:23:02 +0200
Cc: Daniel Dao <dqminh@cloudflare.com>
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Hi,

I=E2=80=99ve been trying to hunt down an XFS issue last year that Daniel =
was (and is) also experiencing:
=
https://lore.kernel.org/lkml/CA+wXwBS7YTHUmxGP3JrhcKMnYQJcd6=3D7HE+E1v-guk=
01L2K3Zw@mail.gmail.com/T/

I did also register a kernel bug back then:
https://bugzilla.kernel.org/show_bug.cgi?id=3D217572#c7

The overall impression was that this is related to large folios and =
Daniel told me he=E2=80=99s currently running 6.1/6.6 with large folios =
disabled, by applying a revert for this patch: =
https://github.com/torvalds/linux/commit/6795801366da0cd3d99e27c37f020a8f1=
6714886

We=E2=80=99re currently still running on 5.15 but this is getting long =
in the tooth and we=E2=80=99re now experiencing issues where backports =
are starting to slow down so that we get bitten by other issues.

I=E2=80=99m generally rather happy to upgrade, but we=E2=80=99ve had =
multiple instances of data loss with 6.1 last year and we=E2=80=99d like =
to avoid running into that again =E2=80=A6 but I also don=E2=80=99t feel =
so good about reverting the folio support indiscriminately =E2=80=A6=20

As the issue was quite fuzzy I wonder whether someone has a gut feeling =
whether this should have improved over time or maybe this issue triggers =
someones memory where it might be related to a fix that isn=E2=80=99t =
obvious?

Thanks!
Christian

--=20
Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian Zagrodnick

