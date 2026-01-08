Received: from forward501d.mail.yandex.net (forward501d.mail.yandex.net [178.154.239.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00FA218821;
	Thu,  8 Jan 2026 13:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767878554; cv=none; b=BUNJmcekDnDMwsCy259ZC4WLFN3IylkashB6UfSUzfLD4lEIYAJqD03jg/yMrMed7OMZ5quCYkgSjm+c/y3t+k+aslP8fSYSjGjvEUm1kbux3cAMX4b/WvlLY7xCPfcEY1SHT+l/hq4jiQ+wemIQx6OKL/gth3s5aHFbLODyFmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767878554; c=relaxed/simple;
	bh=rB/7dBYnjsXJysIoFU+ZXW1TEz/5v5zPCYllT69IJ6s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VZamc5+3tEhOha5Yjkj8wpuIqsmowxzlfWlibrjJUnHPtTxIpjvzqB1rJsHtBto1NBNhm5CyrEbUQe53lsFrSt0b8Qz3AJMx18K/+dBgbU/Q9V01tfxgjww6GG2PzFeofwiiOVEHQ8f0Z8gsewWr3rqcQZKs3vB58xwKVi4FIpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=SWiqU7Bs; arc=none smtp.client-ip=178.154.239.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="SWiqU7Bs"
Received: from mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2a21:0:640:9c41:0])
	by forward501d.mail.yandex.net (Yandex) with ESMTPS id 58B1C81129;
	Thu, 08 Jan 2026 16:14:37 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id ZEOOH9EGkeA0-4RhGBvzp;
	Thu, 08 Jan 2026 16:14:37 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1767878077; bh=rB/7dBYnjsXJysIoFU+ZXW1TEz/5v5zPCYllT69IJ6s=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=SWiqU7Bs11vrs8iEB5XaFT4NM6iTYpBgr2tTvrP+i3WY6inLkzZWovhUuRSCRhLhO
	 Uo/kNop5LzoioAtP1cqRqR+ginwO2OiM5xYyhBMvQucdjnmhFtLygRKm1Jka0QCsx8
	 uPVQbh5EFgOITOtkUa6AI0kAQ7dQ6JQR34RmtFgw=
Authentication-Results: mail-nwsmtp-smtp-production-main-95.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <5d38ad4fa77fc9c3c6a0c28d649d852ee889a172.camel@yandex.ru>
Subject: Re: [PATCH] lib: introduce simple error-checking wrapper for
 memparse()
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
  Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>,
 linux-xfs@vger.kernel.org, 	linux-hardening@vger.kernel.org
Date: Thu, 08 Jan 2026 16:14:35 +0300
In-Reply-To: <20260107104802.91735989425034c858730b8f@linux-foundation.org>
References: <20260107183614.782245-1-dmantipov@yandex.ru>
	 <20260107104802.91735989425034c858730b8f@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-01-07 at 10:48 -0800, Andrew Morton wrote:

> I'm not understanding why negative numbers get this treatment - could
> you please add the reasoning to the code comment?

Hm. I suppose that memvalue() may (and hopefully will) be used to parse
and return an amount of "actually used" (for some particular task) memory,
allowing 0 with possible "use some default value" treatment in the caller.
Negative values just introduces some confusion (and possible weird effects
caused by an erroneous conversion of negative values to huge positive ones)=
.=20
If someone needs some special treatment of, say, "memsize=3D-32M" somewhere=
,
there should be a kind of an extra handling beyond memvalue().=20

> Presumably it's because memvalue() returns ULL, presumably because
> memparse() returns ULL?=C2=A0 Maybe that's all wrong, and memparse() shou=
ld
> have returned LL - negative numbers are a bit odd, but why deny that
> option.=C2=A0 With the new memvalue() we get to partially address that?

I would rather try

int __must_check memvalue(const char *ptr, unsigned long long *addr);

as suggested by Kees.=20

Dmitry
