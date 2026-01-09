Received: from forward501a.mail.yandex.net (forward501a.mail.yandex.net [178.154.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3782B33A9E9;
	Fri,  9 Jan 2026 11:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767958925; cv=none; b=ppVhyAR9sLhvRhCNJecpUKhNec76PYAtReFUK2s+hxDJIYggtmjqtWWyTRx5fhXMd9WHTY7v61fRZ1bg9hYClpFS/782/OawmnmW0dwTMeZ5km2UpYAlPzI6nWEtH7BNQ/hVDJPX8U9KyLv7lkwFS6Z28ygxZSmvh716XKZFgcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767958925; c=relaxed/simple;
	bh=OJ5+kCVHrwZ7qcAY/9cMyrPlfB4uDznlIyDNF5f25aE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NzpKs6rYw5JEGNtEWFD588MKP1uaqTP56Nksmsh4G9acJAfuHoHLjJ2fgiU8+q0WeLP0sOl0umoewGZmp/dWBmEsgIbQb/wlKZ4RPVfjyWjmgQA/Kb7CWSD7YSca3gyj83yO3GIrm0jV+cNQRPzL9vM1H1VqjZ7fhEG2M2HNtNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=IK7brvHG; arc=none smtp.client-ip=178.154.239.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="IK7brvHG"
Received: from mail-nwsmtp-smtp-production-main-92.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-92.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:251b:0:640:cb7f:0])
	by forward501a.mail.yandex.net (Yandex) with ESMTPS id 74852809E7;
	Fri, 09 Jan 2026 14:41:57 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-92.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id tfNaxHQGnmI0-iEHs3OFX;
	Fri, 09 Jan 2026 14:41:56 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1767958916; bh=OJ5+kCVHrwZ7qcAY/9cMyrPlfB4uDznlIyDNF5f25aE=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=IK7brvHGbQgKX1TIdz7jqAaGhPPWGx1a8curZGGbSIRC1luMHqt7vHUl9Tp3ZJ3MI
	 YX405XCZTmh7fU3zvozQmvWK0TlcJtoCwqac6DexsI9PFghtEAlDVsl/i7e0/jpFPa
	 REH6W5/emR02cFC7NyrBvY4pDw6ufJSAg9o8BIq8=
Authentication-Results: mail-nwsmtp-smtp-production-main-92.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <a0fb5777b167803debb2c6b77f41e82967fba3b7.camel@yandex.ru>
Subject: Re: [PATCH v3 1/2] lib: introduce simple error-checking wrapper for
 memparse()
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
  Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, Andrew
 Morton	 <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Date: Fri, 09 Jan 2026 14:41:55 +0300
In-Reply-To: <aWAOJwMURdOl_lqG@smile.fi.intel.com>
References: <20260108165216.1054625-1-dmantipov@yandex.ru>
	 <aWAOJwMURdOl_lqG@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-01-08 at 22:05 +0200, Andy Shevchenko wrote:

> 1) inherited one with strange indentation;

Hm...where? AFAICS everything is properly indented with TABs.

> 2) missing Return section (run kernel-doc validator with -Wreturn,
> for example).

Good point. Should checkpatch.pl call kernel-doc (always or perhaps
if requested using command-line option)?

OTOH 1) lib/cmdline.c violates kernel-doc -Wreturn almost everywhere
:-( and 2) IIUC this patch is already queued by Andrew. I would
prefer to fix kernel-doc glitches immediately after memvalue() and
its first real use case (presumably XFS) both reaches an upstream.

Dmitry
