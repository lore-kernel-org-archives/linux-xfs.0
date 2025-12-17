Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AE92D3ECF
	for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 11:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765969537; cv=none; b=nfCdxhPBVNsDJUt7XWQuAA/xpFU1+Q01jRiIcNmf1IJLlmOwCjpa9kfRKW09lmHz3AOui1YMXn6R2sHRj04WqJEtIAocd3KDradsbRoBShzDVZDxRqdMJZEaGvYO+Q14XuULWaDm5ut2hg4O9pR8KTY+di+oa2lNshppZ8kl+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765969537; c=relaxed/simple;
	bh=jOOzeFuskF0b3zMzCDtJ6Ai0vdEn2bofpH4NBDxvHuw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EP9LfbB+PbiMrC6+PbukZun6wwtYd/xbzbLfqMOlVnF1dZ3NwcZZ1dmKXnV0bbc+OWOPouZrV6ggSGigcN3y8W+fQtkJqkplsLTwKX2PolU0yyZrxXeBxLLFgtJPAvIp77tBgUKsiVJS++/+K/nvNEhZa+lRW0mc7oPwN8RFlYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CKBLNqIN; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKBLNqIN"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42fb3801f7eso2939540f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 17 Dec 2025 03:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765969534; x=1766574334; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=45cJBFn49fooodTuJeINIViCiKdrVjM2e94b8Jp9iuM=;
        b=CKBLNqINHOxpoNdDxHXlnmwFubhwPo9JmMYPyYMnV8ItEcGUK5cuG5CQxTKaOytXYu
         aM6AA2Hjs5iGJjoOc4CJoGaU4foaicYrePyZvpjn/1LFtcx1UMySmWSe/QSkLtyUpQrY
         iHh02InvyIv+3gd9KGIYHS6ztDKlTBttvQJaNo8F6ETxVNiVFxBMKn892Dlz5NNMFXPh
         MEMse/tHCvi9hST53kX5Lqjrxt49c5ljja6ZfPUzF41sSKmMKIsvy8GbLQ5Fcf4KILou
         9vw4IzdNcN4B4ayGr7BXmtTAyYJUU/cyuOoexa2ThTsSts33hIIYdcYM8J6HteFuPcx7
         wJJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765969534; x=1766574334;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=45cJBFn49fooodTuJeINIViCiKdrVjM2e94b8Jp9iuM=;
        b=ACQfU75OhrlwXUON46+E7pE+7FufKuqe7a0WfWOWPtYPWfES9bInVmbTkNgOBLS4Fk
         eIvOGE6phQgnmOKdUGHjTh8ZIHpLg3NG6GSWyKdffykwxq7qFEdjxbBLp6oF3/1pS4B9
         Ql+SmWR3bwZZQGwJ/8eIMH5CDvsaTt1rv7n7vXmez+hQhgwMxGddeIEa8/6pRu3ZrCQ1
         UovVM9FJN1hD10bvhPIfeCjsN6TnScQb89AMjRrWam0T52ZOIuyphQay1XtDKjqGUTqr
         yxslT5qeJmAZyzL6BcNB3lxzH9BuQawni6PF1oIXLH6LVVe9OnT5SnNxJNrBZMNqjd+8
         qiEg==
X-Gm-Message-State: AOJu0YzdVq5uitf4Inoc9GjyKjVx9hbdx6yq3VMV9DTTX2k/rmwpzHGp
	5SbexTZPQV4QjvWqgtz0yMj9UP4a06hhw8PP63hF5Kn/C76elWmt4qE4
X-Gm-Gg: AY/fxX5qIxiw9XXwkS9GLwwYsnWFp7ljAsdFvCVdWJhWl+AvoklUekgPe/AGejPHmoH
	DaMu8znwtoujP/8WoVIOvexBEXp+OxKa4aoNaxWaw0fQw9QIeQT1PgZ0rqClrtvjju9v6QlKo9L
	Kn2hp/rKHwl0S2aNKDsb0QRrwRpi+8muZxLBZuZNzS+FB5Co9d+pCs/7HF9e9XDPkn8SyorHhUv
	EK7i6+ZMhTFry9PBDgGMO9Orjmcx6zujYmeoPY4ofjlO/ucVgGz8ZwaMpat01+I0Xw7X+AkkYYZ
	oU9jrAV4p0DcR1wbUlap/Qs+lHbWLZpP63ueWJ2CPnn2zEkRMXGsH4SW6lU1nRTWlQMfnIvjxfu
	nKnGHgcZrI75yhenTircB8CVq1P3PytUGEAeiTdPJfMOpISeowPvISfbMKtIu1U9M/iXDSkxokr
	S+4xdT8HWX/wars1tOeMklVDlcdXoDbTdSqIujCnSmNE0SpZ9mxitdHs0=
X-Google-Smtp-Source: AGHT+IHydv075/K0K8RdjWg6S1iUJcEnm5byGWJgVTrHrILSp8ZictR/JV8yGOvpJnBppEnDrbh8ag==
X-Received: by 2002:a05:6000:2f83:b0:431:907:f307 with SMTP id ffacd0b85a97d-4310907f51bmr4603411f8f.48.1765969533610;
        Wed, 17 Dec 2025 03:05:33 -0800 (PST)
Received: from ?IPv6:2a01:e11:3:1ff0:8936:c18c:c9ea:69ff? ([2a01:e11:3:1ff0:8936:c18c:c9ea:69ff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310ade7fc2sm4100677f8f.22.2025.12.17.03.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 03:05:33 -0800 (PST)
Message-ID: <d2ca8c4a0e268821ed0268c8d6613215ed5a6499.camel@gmail.com>
Subject: Re: [PATCH v4] xfs: test reproducible builds
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Date: Wed, 17 Dec 2025 12:05:31 +0100
In-Reply-To: <aUHSk4SqAS2RS0Xy@dread.disaster.area>
References: <20251215193313.2098088-1-luca.dimaio1@gmail.com>
	 <aUCSSuowzrs480pw@dread.disaster.area> <aUDryjk9wdZZQ5dz@infradead.org>
	 <aUHSk4SqAS2RS0Xy@dread.disaster.area>
Autocrypt: addr=luca.dimaio1@gmail.com; prefer-encrypt=mutual;
 keydata=mQINBGGqRu4BEACybdvi9+LqKuWA/P9HW7+wzGtIbFL2PR/vgJZqLzAscGrJB3ZvpdT2h
 daDdjRX7Maod9EAZceZYl2YVLZ6Q54qhm1hlEp4Iw6/adryfzulrJPX39mvqpJNE6gSkatwUDekhC
 AJpBbpq2aB79wOF08++KofqNW1r0xMIQ/KVoPryE4jNL2y99bEvUpe4S9TEyWTwsv/I0nEIX4SMgf
 VmW9XY842p9Bj6lws5U2dENIU8OD3cgK4uhfueb/ggkYg/5ZcblIBdVY0xDiFCqyTDr8+TVK2Algr
 M+r5MDPUKQXpIxh+gD84PcX8VXDHsmZaWsZmdkryiZ5RFammebqoIdxLF0oqwgUpaA8Ed4hlPAzmd
 TdVjMwFo01IHzFkZvS0g90qVXTf1fTSVG4JZU2gAasKVl0VDh4yJlzK3c1rWueqISv6AiD+BA6sPu
 4zscdBckK6diftYINuGV6Bfw+v+2AFvjCq8isfCQPXY8XHTg+5lktGN6+45SUEghDpeacSM+G/q25
 qCLKbi6dzAtjCDeR8b6o0lRQ645/5fMU4CSyanfsf7YRkw2RqA6pRM3q/i4nlvznMLxR42iNc1BMY
 A3t1jv6RIEE36eke9Ube0p0TsEisGGYo4NTVO4RUeMeSG3waYfLB0eXHe9Ph/K0FrTBq6XE65KwRO
 Bwk0tB6lU0+jwARAQABtCVMdWNhIERpIE1haW8gPGx1Y2EuZGltYWlvMUBnbWFpbC5jb20+iQJOBB
 MBCgA4FiEECdpUF1+FXVXQxDERHMOHTl7ICj4FAmGqRu4CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgE
 CF4AACgkQHMOHTl7ICj5gag/+JtIKsPwWRJWnnexbGS/gGaZ81GtZ4skW/UHhQqfc44//ntToy3uw
 2PFaPB+5WLlA/XAzpLBFjLD5ZscFtHW7/ICGxrBqB/Q6AULoz0zsDhJ8YmO68A5YYNkGCLbWzando
 vrY/GykUEMT1EsReaIHhLpL/+3jsXGyIsztFi6qkjfDsFT+306+llIhIxgY+ZI/B/wlI41BKmSae+
 5WOR4oZb080Famy/5hjx/Mi0AYu2A6cRpw2k+l2/u+aEvunmkgkgB186tA/JhoOPYQvT5xVQ5GYRu
 vcX1kHscYD+Tgx3DhkMS1XqZihH4UE9Ec6QeOJTWrK1czRFTJpTOgPAMmksMdgU8YKKHj0dafCNl3
 /2gld0Q2s5/tAGPpPuOPJf5GUtcOn1Qxr7Re2pyrQdcdr/jUdy1GVHAldzOZlBID3u0dTUGWLsPDA
 dvwGyiwdZiNgnHxTEWchpFo0mwi5S/3+sWcPWAJO2zEVfkqyNhmHSW5EBrwe9nhCT5uqF8dEKb4tf
 FxAAgPAiFfnLhweVxkPIvPK6/rIZo8F6t6qSXibbTIjdi9pLSDMY0m8u/fRZ06DsciFIfrWG1LXlu
 14mDpr4zQSUELe1RRU1NEfD87TyYehjPvEewM6bZlRJ4SLaWQFoRW3OKH7IN1ODUn7T9TIx1uuzs4
 4ViZ2BeR0ow9RQc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-12-17 at 08:43 +1100, Dave Chinner wrote:
> On Mon, Dec 15, 2025 at 09:19:06PM -0800, Christoph Hellwig wrote:
> > On Tue, Dec 16, 2025 at 09:57:14AM +1100, Dave Chinner wrote:
> > > > +_cleanup() {
> > > > +	rm -r -f "$PROTO_DIR" "$IMG_FILE"
> > > > +}
> > >=20
> > > After test specific cleanup, this needs to call
> > > _generic_cleanup()
> > > to handle all the internal test state cleanup requirements.
> >=20
> > There's no such thing as _generic_cleanup, and none of the
> > _cleanup()-using tests that I've looked at recently hooks into any
> > kind of generic cleanup routine.
>=20
> I forgot to mention: the lack of _generic_cleanup() doesn't mean my
> review comment should be ignored - the new custom _cleanup()
> function above still needs to do the relevant generic cleanup work
> that is done in common/preamble::_cleanup()...
>=20
> -Dave.

Ack, incoming thanks for the review
L.
