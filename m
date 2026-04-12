Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F981A275
	for <linux-xfs@vger.kernel.org>; Sun, 12 Apr 2026 06:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775975926; cv=none; b=uGSrhuqlnbpzqWuLr/8uyxK5w5c6T64jCZ2fnDNerEJ+RBO8AYGpt8VMrQIoKYFTwe6Zjkv7msRv+qW9aQpXkgl4KVwnmtpjUWDLzTu6P1+j+pDVeM4PqxT03+3DR6l+QhMdBO6WvghzU2JvJj5Xz7pDOMN1EdZLvWaC4MQSJQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775975926; c=relaxed/simple;
	bh=tsim9DZLwoSHrmChnO/Fw7Os6nWn4T3V9JZCCgYCPvI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=U+NmY8/5KzxVK/4ccz+zN/WKBg3TRz46sl7xUgNBAqT5YBu2QX5ULWvLyB9PQPTCDwL+oLDs6aXX4ToxAeUbQR+H3RGjD9nJ3C9feNamGdd8W26L1wCQXYEqBmJJgEO3hHt6q5U6x4vl6P9YRHM1boNjP6g3Ijkj8yCugQtLCrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=hRrZgDWh; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="hRrZgDWh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=nqVJkr8vWf956I2tX5/n5Ff6i5qPhfe5kj47p+RdD8M=; b=hRrZgDWh8+NdzmADPuPirrilla
	L4piCUAOT1UgnsNTZIQwRKXqAXZpAB4Mbim6XGx6nLzZtVWVafqmFN3zo9NUpU+Yi+ufx70XDIM/w
	fN1er/wbd81LRhfwXCRdIl5QS7hYCP8YGErRYW0fBCe6E0lOdAQfb3/SYzUkcLDJDuOixNtnFpvsH
	lEPYyNWePgsYeeiDdpFeZj6514/egGAhltDgbuomgXjplL4SjGaMUjPbDaAgyrSki6qC11yniVUGd
	8coMNoeIQ7iYKvKlfcQ9F55AdUhlLajPuwKfK99SxPtFfIAAGbJdn+pAgD52LWSVhYMMuqE8oH05C
	XChKh1TA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <tille@debian.org>)
	id 1wBoSq-00BKr1-0e;
	Sun, 12 Apr 2026 06:38:36 +0000
Received: from andreas by mail.an3as.eu with local (Exim 4.96)
	(envelope-from <tille@debian.org>)
	id 1wBoSp-009MYT-1g;
	Sun, 12 Apr 2026 08:38:35 +0200
Date: Sun, 12 Apr 2026 08:38:35 +0200
From: Andreas Tille <tille@debian.org>
To: XFS Development Team <linux-xfs@vger.kernel.org>
Cc: Anibal Monsalve Salazar <anibal@debian.org>,
	Nathan Scott <nathans@debian.org>
Subject: Please migrate xfsdump and xfsprogs Debian packaging to Salsa
Message-ID: <ads96yii8bij-UQQ@an3as.eu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Debian-User: tille

Hi XFS Development Team,

I'm currently reviewing team-maintained packages that are not exposing
Vcs fields.  I assume for some efficient team work you are maintaining

  xfsdump
  xfsprogs 

in some Git repository, but the Vcs fields are not set and I could not
find corresponding repositories on Salsa.  I'm not even sure whether you
might have some team space there or whether the Debian team might
sufficiently fulfill your needs.

I'd be happy if these packages could be maintained in a publicly visible
Git repository on Salsa, with appropriate Vcs fields set.

If there are specific reasons why this is currently not the case, I
would be interested to understand them as well.

If you need any help with creating some Git repository I can happily
do so since I have developed some training in doing this.

Thanks for your work on XFS in Debian, and best regards,
   Andreas.

-- 
https://fam-tille.de
