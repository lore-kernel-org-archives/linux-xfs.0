Received: from forward502a.mail.yandex.net (forward502a.mail.yandex.net [178.154.239.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0837D339705;
	Fri,  9 Jan 2026 11:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767956755; cv=none; b=hsonG8LUP0cvv1Hllomld+edyRwGDpr5x9tLqoseTpKrw7/BG5O5fEW++qhmeTHsD82rpj65cLqPCLH+Tp+pnwYPIwPnSRjVTg33KmlBpo7kSwOhXhyUCnHh7c1hmZ+w8dEvXNAUVOazCedyY+u4YmzFfRoLF4KFY3v1kfJB3nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767956755; c=relaxed/simple;
	bh=9/YxxR/HXhkR8WEEHc2OzMEtkpwZUKddsXABh16T0KU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WZkZnjQFlONcK3GyPpNZZ9+Vyck07/jCSAZ+8YVcfieeKc7MePrPO/ddJyTI3+XV/bzZSUNS90m3zqcCtF1IC3Al/mQAPQL1tXyr1HBRSN2+xGYW+dJYAqN9X0dwd6TGXiC7+/8K/RStH33wYwk1vifevT6B+wGMubFNgaZRKx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=U2x03vGA; arc=none smtp.client-ip=178.154.239.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="U2x03vGA"
Received: from mail-nwsmtp-smtp-production-main-94.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-94.vla.yp-c.yandex.net [IPv6:2a02:6b8:c15:290e:0:640:f317:0])
	by forward502a.mail.yandex.net (Yandex) with ESMTPS id 1DA80811D8;
	Fri, 09 Jan 2026 14:05:43 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-94.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id f5NLscOGqKo0-CFqranw5;
	Fri, 09 Jan 2026 14:05:42 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1767956742; bh=9/YxxR/HXhkR8WEEHc2OzMEtkpwZUKddsXABh16T0KU=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=U2x03vGA/9xWgQpTPAmREoFW2Ikwnnbp/5x+wizKpy1Cl2vDLMB+n3zNL7dy3sbNB
	 6czuodSgkDwO5ZzZu2C00ulE804azqW4ADLedcGzPGZKiL6ARQR0zx4GjJWtbJV20X
	 nX6F75kCRN0+BTPi/2sw87I3SlCroR3kVpYK4Dc4=
Authentication-Results: mail-nwsmtp-smtp-production-main-94.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <89207e33051803a21b0703987bf2a91208e8cf70.camel@yandex.ru>
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
  Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, Andrew
 Morton	 <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Date: Fri, 09 Jan 2026 14:05:41 +0300
In-Reply-To: <aWAPOyJwhpfKpqPy@smile.fi.intel.com>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
	 <aWAPOyJwhpfKpqPy@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-01-08 at 22:10 +0200, Andy Shevchenko wrote:

> Hmm... Why not -ERANGE (IIRC this what kstrto*() returns when it doesn't =
match
> the given range).

Well, I've always treated -ERANGE closer to formal math, i.e. "return -ERAN=
GE
if X is not in [A:B)", rather than using it to denote something which makes
no practical sense in some particular context, like negative amount of memo=
ry
or negative string length.

Dmitry
