Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5717E126BFF;
	Thu,  1 May 2025 13:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746106984; cv=none; b=Ik3SoTZPZ+TtbBCL/sjd+cisHtNvUAlVeqzFRIydkO9DNflB2ZUbRfMA4XO1h/6+HdtEx0og0qKx7vdVYesSX17daC445LM2RjVppaJZINZ+seU2XDa7zm+bvLWGaoTptFH89ImXYfgm9lDJ2+Kr5fk98P3n8LGAlHBlaAMyszE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746106984; c=relaxed/simple;
	bh=52yu4sv3HgNLNm3494tG8RRD1WgIAAoOU00xaej99Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QbV8avOhqm/aCUh90zxOKmSsySUQwVdPXDIYO1qGBGqAfB2PzKFCAAFHPxmqA6+YBgmL+mYOmQTdxcR7UA1u2aZaZCwjcane9SfAvEL+k8EDz3XXPEDyPqDb1EOcOnuLaW/ZWSajRWhpLxeA/2Mh60ZHfjSRx8R9h90RYbFFq90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1LlkvdG+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1LlkvdG+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=52yu4sv3HgNLNm3494tG8RRD1WgIAAoOU00xaej99Hw=; b=1LlkvdG+ZsJqTfhoX7YD8tGs5S
	/PbWYvEMK1vNlVZ0nfFyMRSZYEaHgrMD2pHqL2uu63adXNd1zizXO5ERl1QgwnMoGGx/APNv/KnAe
	kSB2nHGHYidGEt7J+PZIu3zqdNsOUtJmxKJLMbwPxDNV13FP3/z5hmH8/mFAI/eRc22gIePqsakmc
	nEiJk712JPRp25qDA8JyaZVhWKuwa7nPxRwpeeG8U0NHe6nVB9WhYdijytq4aantpAF256APnECaK
	3lBUvt5+rYKVIaPAU+aRMx/pO8uJsBQJyHxq0RYzUUIg9w20lt+ewDVp+xsykUimHjXB83/NhJCR9
	7N+5kKHQ==;
Received: from [104.254.106.146] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAUBq-0000000FrPE-3cYU;
	Thu, 01 May 2025 13:43:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: new tests for zoned xfs
Date: Thu,  1 May 2025 08:42:37 -0500
Message-ID: <20250501134302.2881773-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds the various new tests for zoned xfs, including testing
data placement.
