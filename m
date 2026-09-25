Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063E62E173D
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313224; cv=none; b=EjHDr/yCN3PHjNBG5b6fXazJZJczw0NZ9TaxzX0vdY991DyfEccJzu1nGMM0vmuRUilTT7ttW8uhrtc6oFMoxzjmnh1YoAWEPSKCBgkpqUb2NpXbOdg5dO6kX0d36rIaa1DGG2KBpo1x9jUJoZRR6odqZm+kgssEvSF/a/FVywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313224; c=relaxed/simple;
	bh=6XYRDzS5xheb6UFhZFZypCjplIR+zU4dqUaSbz6KtMc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A1hm3+RAjKD7J9BZNnfmzTbrlcq8sRvGkuWdJfSbJA1RI90uwWSaHPEdiAyH/+0AHqGsl2GIM7axkxz/3MBVtasEO+LJY71BlANOF0YlCgdLxHfEOUJVA9SloIGuhmtX1tfRvUxMfkxBVbXuHltRCx1z2xAAThQ7fEeSuDarAw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Pfmkahm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Pfmkahm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=9eejlzSbApD1dDnsgJC1aX59gEFxdsRUtoZr886Uoig=; b=3PfmkahmYRoVwe+0GgaZ4AdUvz
	dusideqeCxnWn6+OH7Aa2B2QTrKIWSxclI79OWIP2j8ZvQWeSjrfH1xCKMb/zetRiDwvykYct85Xd
	tSbRUa+/xCszOdfqAmpCjLESqpFTK8qlf6oQ8qZGnUTfNNlj9bHqX1w9TCj9QnwajeovV92m6s+zl
	LRPMYATMs4fORUeawc81S3ADk/iMb8S60BwlVhl48uhBrUAnjGhB7idWopErr+DYrAri8UuHTFOyQ
	4FYVZK1Oj7OJVnP26ELRFKAeE0gJuzaueTpj8pnFo22oxvpLZwWHRib3DkApmxUiRKZPp/kWxW2+6
	lSS7Hfew==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yFg-0000000CgbF-0g6o;
	Fri, 25 Sep 2026 05:13:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: fix missing RT detection in libxfs v2
Date: Fri, 25 Sep 2026 07:12:46 +0200
Message-ID: <20260925051336.2997014-1-hch@lst.de>
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

this series fixes the detection of a missing rtdev specification in
libxfs, and cleans up some lose ends.  Compared to v1 this is a
major rework as the old version broke internal rtdevs, and further
review uncovered a lot of other lingering issues in this part of
libxfs.
