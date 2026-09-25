Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C26A4C2275
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790349671; cv=none; b=DJvkdF/PiszjvaBs2gR3DjLABsMbMTkLu3D4gwLtGp8qhd3lXg1/AjY0zic0Hp0HU2urIWaGQ1RhH0mVjv7xLM61GFHCtlZ3lZv74J97Tz2xYokP8pFEh3cL0Dfxftrl7yy+P2bvAb9xO3CTmKkmeyPr6UWgz0GYQxUZIkpXPok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790349671; c=relaxed/simple;
	bh=DHL7FzMrEWccGsWOM827TibKNx4dA7NS+G/ZNu7JF6g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UcGXnLsPUozw7LXtIH9L5gI/jUUEJ5svdO9Nq6C+joWTJga9GHrr/dYgw2SeUOmfvYUtWMlVOcXL73l5UUitzTJ4i0gpDE7fM1XKpwgLmabLP+Kjyi0CVM31cXaf1cQk4LThl4grxnFEsHLh8W3dtdvdLGSbVPS3OsYv5EIEY8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZiK4bwwJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZiK4bwwJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=DHL7FzMrEWccGsWOM827TibKNx4dA7NS+G/ZNu7JF6g=; b=ZiK4bwwJEAniIDewlwqR3XLB7c
	9DGD7pn9lnnyl8M1xUfc7EqhNRCYqB5sYt0ERYKBEGZaFLQeFXEyxdKzjivnHe0SKe6PRTUxwcFaL
	0XyrUNdyoOMC2joVtEO6h1frMrknU+UbtNwxC8lGgwUxRQopJfqerP5VTc2cxIj0ssw9TXI7CnWnC
	kcyenKlBPUQkMdKEtTJ6gOTPHYp4HNQdTC+Km7recY0nxraaWtggf3UJO+9zmeDfNDe/gVeE4FXcj
	IaI1wcjfv3xwUesShAauHcmwjOsbBUcxHSuRPffB2BC4xn4Pq5iU7DFYCu5bjwJk/FYRnbvnGgVob
	g9e5dNVA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xA7jZ-0000000DlaF-2lPM;
	Fri, 25 Sep 2026 15:21:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: reduce libxfs to kernel differences
Date: Fri, 25 Sep 2026 17:20:19 +0200
Message-ID: <20260925152107.3386097-1-hch@lst.de>
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

this series cleans up libxfs to further reduce the difference to
the kernel version, and to reuse xfs_trans.h and the various log item
headers that my kernel series moved to libxfs.

Note that in this series, it uses the Linux 7.2 versions of the kernel
headers as libxfs hasn't been resynced with 7.3 yet.

