Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E200341661
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765809923; cv=none; b=oIEqaXmdG128vcEOAce+rDct0NsS4ZQm0ZyjJRrJRh5wR/V0hHdgy4MFfctrFtmTbTuoV/V83/bNIWWgNznNzo7hnkAeHi5gpwNMZdNdju/QpBZrxKCd7lVrP15RsV0R9WLRerQGVo4htM5e8fBqsrv2f/7zhn5IYBMZxsmc6fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765809923; c=relaxed/simple;
	bh=wG+8C9GqbiGgyzVT0S6iMdvLngbulJhjjZuh3aKtGew=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H6IJvNiTCwpnDOySgLhAMj1j9RgDn3mwqwcZL8dIidfqvRJvwoOxUjGNJ/WwJXeZkYCsAVLNoo/hwKeZnLkUWRbzUF82WQjIyyM0tZWLVAbnpd4WKQmAv46IAumB35j5PinTnF8lGcR0JUkJv7v8tYZ9dpKttb1xRYxyFlYUN2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LlbspmP3; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LlbspmP3"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4777771ed1aso26926715e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 06:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765809920; x=1766414720; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wG+8C9GqbiGgyzVT0S6iMdvLngbulJhjjZuh3aKtGew=;
        b=LlbspmP3j2m2L/KsnOCwlLLZIcBUUsg5wWUfEJA42N06wwsAmcVzT8o1bLfOmtrp54
         nrngZWS1fgsWGZmxM5UARRzc8g8MG8lc6E+ar0VmQxelBEO8IeVfXdgnWi9JsKFUQkey
         qCnexXHUISTcRjPjaWKfas1dtVoPodZBzhXxmBYD1Kr/NdjtL+N/SXv+guNaWRW8kvon
         TUH1iTVEkiJ/OG5nti1yRGSXp8CTOOCF72oQn1v+ox4vX3f922i7s9wfUkYvMA82pxMe
         +Q/rTpAt1ujxbS1Ur6kcghcD+nXmK5c0c2ltiBHKvsVZq21rmPcpfStw7MEd6JofQfZE
         c7uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765809920; x=1766414720;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wG+8C9GqbiGgyzVT0S6iMdvLngbulJhjjZuh3aKtGew=;
        b=eLX2jx9peaz7xNkpieGHjFEScTZIABvo4ujktINh6wMoZxESwwFR3ZL68RVEqqupvD
         5WZyDv8mB5pVn6qZhJsRzMIBgy1U928fux0HazhSVoWzoFBjBQnFDWtKf8Wa3md7GzLp
         1ICyN4wn3FprUo2Yh8Hecao3s1hrkXvyi1gwDacFIsIX6C3nLXmE5gVZy5c4uv/YxFFZ
         fs1GZeiGouE4fIyTz282z6OTtM59i8rMulrHC4ucOMpMcaE26vQgnYC51nNTMca76f0S
         YduTcLv5wpz6dgBYdxqjti0XCUVokZ31w+uvqskFtgtz0ANvFfscnCdzDD6aCxCwyYVv
         pnZg==
X-Gm-Message-State: AOJu0YzmeDe9OqidPlqSxJaF1V3ANDWNkoEhmDUVyrbLB96VUQygukeY
	WAxgyu2NUT+EtMvyQQwUM4TxHtb3XybOT7vG1vRZpzMO9fAMb0N7QJYh607d9g==
X-Gm-Gg: AY/fxX4EoTmYxTXohovjyqXd9xiLIgc6wwlpR/ugBumIKwtVyFTDPlWWPkfXrDqKRZW
	3/BWuDcCIFJdt84g4xBmXxWs7ouFGRZdwx4DDjwySr3KwvxwgBekR/Hj+w6BEMSF3HrlFnnEA/c
	SkiW8B4epapEO8pMPpUq6bQIzFQ2R/Hm0c5j/3fhn1oUIbH5aeCkEE09K08/t+vvgSu8yRCpy1s
	xPOncxOKy/2IonW3/FDBmYp97D+mK7xObqP2kQ1CSic3tlvhi/5/0mCbr90vzXb1QTt095NcfzQ
	YnIdEIXIPWQXJg5DRW95eyzWY3EhPQyMiSHT4xUglepiwatIXOICLVDsd/QDdKlM9bwkKbOB02Z
	6NC75aGNMFztw6GarWADyH7fW2KHo61jgBr/UjE9+f0muw5s42eLlo9KskUHBqyiqFuGAaPmnku
	XCGJvmRyQzi3U0f719cvZSZA==
X-Google-Smtp-Source: AGHT+IGcZMsE71+RlgnlxNEVmFDTwtNK2CwCj2ulj7mz8b620/wSfwqdpoGq4Cyj95p2LqjIiKwAng==
X-Received: by 2002:a05:600c:3b8d:b0:477:55ce:f3c3 with SMTP id 5b1f17b1804b1-47a8f89c8a3mr125317335e9.5.1765809920209;
        Mon, 15 Dec 2025 06:45:20 -0800 (PST)
Received: from [10.171.116.235] ([78.213.157.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b188sm187116625e9.1.2025.12.15.06.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 06:45:19 -0800 (PST)
Message-ID: <24ed3227da4b2c23222cc1790196202168dc8f40.camel@gmail.com>
Subject: Re: [PATCH v1] xfs: test reproducible builds
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, djwong@kernel.org
Date: Mon, 15 Dec 2025 15:45:18 +0100
In-Reply-To: <aT-eKSYrB_MFQeZY@infradead.org>
References: <20251211172531.334474-1-luca.dimaio1@gmail.com>
	 <aTun4Qs_X1NpNoij@infradead.org>
	 <hxcrjuiglg4qjn4qzgnwdtxpcv6v47rpjrkxaxhmanhxvvwzpx@rz4ytlnsjlcm>
	 <aTvOQqfpiJDCw7e5@infradead.org>
	 <sgb56cw7mzdeebmugn5czivs7ei3g23bfosir6bb66pytuidyo@4irrwmmz4rel>
	 <aT-eKSYrB_MFQeZY@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2025-12-14 at 21:35 -0800, Christoph Hellwig wrote:
> On Fri, Dec 12, 2025 at 05:56:02PM +0100, Luca Di Maio wrote:
> > > I mean stick to md5sum for now.=C2=A0 We should eventually migrate
> > > all md5sum user over when introducing a new dependency anyway.
> > > Combine that with proper helpers.=C2=A0 If that's something you want
> > > to do it would be great work, but it should not be requirement
> > > for this.
> > >=20
> >=20
> > Sorry read this too late and v2 I've moved to sha256sum
> > Hopefully it's ok?
>=20
> Let's ask Zorro as the maintainer.=C2=A0 My main issue would be adding a
> new dependency, but it seems both md5sum and sha256sum are part of
> coreutil and have been for a while, so we should be ok.

Yes, at least on Fedora and Debian both are part of the same coreutils
package.=20
