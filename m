Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC3F20304
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712730014; cv=none; b=KCrdouTISY7ARVUWR7lvg7QuL4qMmxCRxkvcHYghRGZgsuynVR8UCF+t74rRrgu31sIoaxNNa53A1x1l/crRjxlsDSJqcZZAGvltvBZdeTBVGAhJJURU9MCYzMTwml90/hQZi4CapSRenBeSyQLkcyn+px6yqcYQHllf7L2D1eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712730014; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fPOy25XXnCt44J6AmiqGGlSrVZ+XKzFEL2VzbkDksWcb0xPgBez9KtGwhYxFl6manQ4P6wdXO6CDHB1ryesTOFHVS/OaHeGeTWiv+ri1TDx0/oTx7rP8ChE/UtJwr1VLHz0wOyFj+bE8p6M5CC3pPvgP4Mc3XAstOvFpqZOWCKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YVyLBZ2E; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YVyLBZ2E"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YVyLBZ2E7Cm4HU5bn69UlS1bG+
	N8YlQ4u5zv7Wyvi0EFRW7sKhbomn4whr07cpP4GnJspO/xXmtO85x6A9iUSioaCGySo19sfiBIMd8
	pWeYvemMs0PE5ERUMVpL6Q6fmlt/fmj6nEzXWfTkAooIWG8lZgGEzCEL3RU8L9e1Sp1//e0ueH8Wt
	X7hLdDx+KURGJqwBEYWrZpxXv71KV00kh0pxqJvRIa9UQew7hzvbpyEZFPLpdveut4nJOrjuYSNbq
	zzrlu/2FmxvnvfHyvgs7FlvkbRklAAHHn1cWFRUe7b/e+H+Tg6UekJqipkopD8SdwGnpN+uom+WpZ
	yzqB2bWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRJc-00000005M4e-1oKM;
	Wed, 10 Apr 2024 06:20:12 +0000
Date: Tue, 9 Apr 2024 23:20:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/14] xfs: repair directory parent pointers by scanning
 for dirents
Message-ID: <ZhYvnLzUZmFew4VO@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971087.3632937.9783454600528014218.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971087.3632937.9783454600528014218.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

