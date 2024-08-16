Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDA412CD96
	for <linux-xfs@vger.kernel.org>; Fri, 16 Aug 2024 08:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723796354; cv=none; b=YEVF4copLrxYTULDHh4HkHLDznNBu3qeN4d1BzetwpwvqOGwvXLQC96+lb7Ius+5S/dPRK7Re+We+5P6KDXP5K/d411PfrX46DleCN38f3BafhBoujWUb6N9jVfJtzw+mV29rXFmEUHdlUTf1bu0z6Z91iEA14Fptal0c3ZsR4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723796354; c=relaxed/simple;
	bh=dIRmeQmDx4tPOWY2wiks4dZPTzyE7o2YRXxHhEhDN/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qs40SFE2J6JaT1Iz/bMdOgpT5HwJmxXqcEhW9ShTTRUx6OMOlygQo8xP0oeB5AYKzKtRwij2DZVf5Em3cauYrzRaK42O921+UqyfhqEwikrpshBHUYKn+vtBsSZqO1fSs/lFUpYEg4onLILmdh8pwaLjTfe602UU0q8BBgAUrsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yq5ffzOm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yq5ffzOm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7ckIcmvMWG7RuraEJ4IJU/g6pM1llUm+0EFi8ujJxwY=; b=Yq5ffzOmmaEIhdWDmwSgNv/xRw
	RS45tnieLLbm7eQVTs/W3zq+DenSjLYUs3E2BloyktEtVZV1Cl0AvPe6zcKJaBKfi2dRfTUtr6QCs
	IMuci+rSgpKObeaiNyJJXmfux3gcAIK+2EmSkHfFpJWsbFmvl90DWcgn4LyxWWQtww/JEr3lb3UCz
	MaD98VN9qP5948Rh3QfNxDTF0r3IK7foJJoy0UJWXG3FqFuNUJVlWBddOzMvCUH+Ey3X2dswlUTG8
	Qi3miDNgMfV3cbPr3TjZeRam3eVxq3dJKN/zXXjptDWyZlxpoJ4fLusivW87qhA/SSdzUOVDTMJkA
	T9ZQHS3w==;
Received: from 2a02-8389-2341-5b80-2de7-24a4-8123-7c8f.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:2de7:24a4:8123:7c8f] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sesAx-0000000CEw1-1aio;
	Fri, 16 Aug 2024 08:19:12 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix FITRIM with non-discard capable RT device v2
Date: Fri, 16 Aug 2024 10:18:41 +0200
Message-ID: <20240816081908.467810-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series fixes FITRIM when an RT device that does not support
discards is present.

Changes since v1:
 - explicitly reject the discard capable RT device and non-discard capable
   main device case because it is too much of a mess to handle and not
   practically useful

Diffstat:
 xfs_discard.c |   57 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 26 deletions(-)
