Received: from forward501d.mail.yandex.net (forward501d.mail.yandex.net [178.154.239.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3132EB876;
	Tue, 20 Jan 2026 16:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.209
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768928284; cv=none; b=tD/0hN/cnhwT6DOudbP0L+2oxXQ+h8E/CT3KUTNooQYPijqWd6lA6sVeoaCb1BTnry+EKSnHUsJ5YkCciszCrBnoFUwkjKpE2NNNVsAA8/9TzPGydv9+OIflnNjBXZrm6JdxlsuiI1+gjpvkxrGesKNFTDjtMfswwLwTPGCCC5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768928284; c=relaxed/simple;
	bh=7OLaa/PgkWKcDJgT1ipDgSZs7E5O4cdgkZ+uQ8h1UWI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b4+No1GzejITqhsgp/3VetahTa/nnObL7fTjESc5Gsui+wHkO++7jJhTdoMnu9TzTkgyjhB0Qy50we5dVlCjQ4dQT6JXoCiLVE/02bHquxKqUNLZxav4A2HjP6L0FagohpcLTT2mCpmcGK3v46ePiXUSYIJ5EhdCbHk5lyj9w80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=ndwVEYxp; arc=none smtp.client-ip=178.154.239.209
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="ndwVEYxp"
Received: from mail-nwsmtp-smtp-production-main-94.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-94.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2646:0:640:add0:0])
	by forward501d.mail.yandex.net (Yandex) with ESMTPS id DD2D282EDC;
	Tue, 20 Jan 2026 19:57:52 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-94.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id ovd3ivvG1Cg0-Wpet3x5Z;
	Tue, 20 Jan 2026 19:57:52 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1768928272; bh=7OLaa/PgkWKcDJgT1ipDgSZs7E5O4cdgkZ+uQ8h1UWI=;
	h=References:Date:In-Reply-To:Cc:To:From:Subject:Message-ID;
	b=ndwVEYxp9X8qeDjH03fhdYj++0P3xcnAe1nbI0ngTAQP8WgjjcH1HlkcPeIVLZVxc
	 E72rbhN4QTe0KJYLHKiDv2tee71WzWdcFi8vPBQCLkxGUb2v9bXKA8FwOdAbxW91vu
	 /0vcBbm6bBVBXO8DXZ85sfUcaQqVRxYUnOiGEMh8=
Authentication-Results: mail-nwsmtp-smtp-production-main-94.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <dd2b5f76c1acfb0ebb22585a5282d94e1d8c979e.camel@yandex.ru>
Subject: Re: [PATCH v4 3/3] xfs: adjust handling of a few numerical mount
 options
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
 Carlos Maiolino
	 <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Date: Tue, 20 Jan 2026 19:57:50 +0300
In-Reply-To: <aW-YP7wCEvRJzyfR@smile.fi.intel.com>
References: <20260119160623.a762c3d64f230936198dc17e@linux-foundation.org>
	 <20260120141229.356513-1-dmantipov@yandex.ru>
	 <20260120141229.356513-3-dmantipov@yandex.ru>
	 <aW-YP7wCEvRJzyfR@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-01-20 at 16:59 +0200, Andy Shevchenko wrote:

> With all this, I do not see the point of having a new API.
> Also, where are the test cases for it?

If there is no point, why worrying about tests?
Also, do you always communicate with the people
just like they're your (well-) paid personnel?

Dmitry
