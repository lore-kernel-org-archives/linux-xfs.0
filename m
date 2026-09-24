Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A97326928
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244327; cv=none; b=qbLyRgrH5zoTNIrGCT9YbcddPO5qPKUkSKvwnucn5jiAy6sqRhAGJEKq8msPKbxMvjn9H29l3N30F53uc+EkjWYRTKmSAoiiLJ9+gckw9tb6+pugZK9q/hdYIuns/34H5Gog0i77JeFDYifF2Z/yqeiuEnYeZ1KhtdZOGx0q3z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244327; c=relaxed/simple;
	bh=G3/hI8NCagm4TX+e8UPuFIPvHEXdECnTCGOkxN37FXY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gycoi6mfnfiHhSvdLb5Y4w4O/xtNxqJSvJUD8u1eMKhEWgwN0vQ7VbOZc1Qwwli6+A9Hf9jDa+eITQWMjQzXbgge2D+tCePCCQDWt1WVBihpv2HxUu423Z1oQ1EduJhn3CdsPZR+QaoDvO7pp8WKror3l450KIc8e5FZth3LOuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mN2WCp60; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mN2WCp60"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=revbcwee4RGkTQurYFQi8U8caYVE6/V0Yz5jp9OOcAA=; b=mN2WCp60XjxKhxfD5SELKHMpjs
	g+rUFMw+liRz3Mnm56hzo2cKaUcKLj3RaIRT51IwRXJt7nwmoGGWym5dnfrxyIXTg65/N1Dypd5JD
	YP9eriHBpoWKE8r/nVy/XwVwaBU4sWIPXstXuO7HyRV4+aZ89GnLRCbwNKBVUQ6sMtq2F4rI+kAMj
	K775m2CslYySRcPJzGOfZCuZGHLcVChRngJbwl+B0qP5gbp2gzDOGQQkCivo4aNQRjQOIwEhXtaYa
	tOPDs71G+jbt0OeLIzwJIXogw9T9p6rpTEt0spxjP35InE0fF5PePo/Mj5cQhWHvY4SeCndjeZhfE
	H1JLf/qQ==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKJ-0000000Af8j-1Jvf;
	Thu, 24 Sep 2026 10:05:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: xfsprogs support for RT data checksums
Date: Thu, 24 Sep 2026 12:03:50 +0200
Message-ID: <20260924100512.2733748-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series add support for RT data checksums to xfsprogs.

Much of this should be pretty straight forward, but the repair support
to rebuild the checksum metafiles isn't exactly great code.  I wonder
if it makes sense to even run this by default, or only under a special
option.  And if we run it, if we should parallelize it and/or come up
with a scheme to prefetch to the file data.
