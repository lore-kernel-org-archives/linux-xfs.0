Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB5C1DD874
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738772899; cv=none; b=sU3jRTTAHrYTZJzL793WjjvwlNbFkMfOlBQi19mqeVjW4IcMpBG0IMyj7HRT5pxOpXGLKGpGA5wAG7OJVx+Nov3M+mP4HA4DganC+APzbHES8pJWzK86hWN9XoRvqkHiCZFLKw4kTlMukgCCm7nQgKgVlH3UYR+X0dsWYjVTnz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738772899; c=relaxed/simple;
	bh=bEH/s37JMHkOWGxeaB3WcAAF5VDOPogprLbAIjaBVDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oggk4lDZtlKZYujwjMtN6r8Zj28bu/Kj9QdrWfm5lBQ+UO53MAxodTrbzWzprJQ+mdo7qaMVLbZdGexEg5pd/Uu8eK8PH4fgCsMBA9A7t0ZgW8iNJiIikSXDHG2p1daJ3pOo04BbA15Haj1H38d2OCs3qTJgoAXlUPvIdcA45Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z2rKydKT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z2rKydKT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=1j/u9TrFCy8fi4/A/nsgUZ60AigFydHsLYRYLoinYXw=; b=z2rKydKT2GjRkp957cf+JC9fRU
	RvUB/8zb88/fVDHsrCZr96obONEQ1+UE4sYvn3vTLX6+YldTy09EF/+iSIwU80Pf60bVrWVcdRclK
	89g0uD7RlTaSgp91Gm+RE+pmyLV1ba/Pi/ehrEjfoqEmVt/dw7jYiaYBbEHZrPj7BxdEojHnBZgcn
	Xjky17LQsO5c8A/qKpf6gwZIaZV0945fF207Rm1vsOsUQVjRrDAqQj/wvWeZCR9YDjNVcL9Y9hMEx
	4zU+bRv09qATrsi5X9Ror7zXsPcDdlpjRjUOfIXo32ikTJAIF4DOblmxfUUSfBtv5IHBF8/M9nbfb
	2BvcM2wg==;
Received: from 2a02-8389-2341-5b80-839d-6dcb-449a-ed13.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:839d:6dcb:449a:ed13] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfiG9-00000003ymA-10WM;
	Wed, 05 Feb 2025 16:28:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix swapon for recently unshared blocks
Date: Wed,  5 Feb 2025 17:27:59 +0100
Message-ID: <20250205162813.2249154-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

the first patch fixes the recently added generic/370, and the
second one does a bit of naming cleanup in the area.

Diffstat:
 xfs_aops.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)
