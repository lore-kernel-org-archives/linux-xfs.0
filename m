Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B14347509
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990903; cv=none; b=sy7lCmKYdAs6ifN1e5P8b9KqrOobXuNJt2bNsAtW5N0fyr0aE/hQoADtt5l7JcPW9AqiE02tecGLU/TMZU+LyuBZxfNNN3h3kCrEdEISOFi/adzlusR/zW+/MGCnookR9iG/NwJrz1PKaffvnul2Yy8I4OsOpneILG5Tn24wzNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990903; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTPB9o+Vn4YB6t5N3OghE+pm4QB7kfli2Z/nJqQJaXnr+pu2Mba5qTRJ5VJ80MV9XAtWJFlbFzbMz1Cw2snP6ps8OimWzLq53vmLs4uRA1IENi8RfKf5NOcjNXdJO2K2TOmJvRgzsnLKXXn3jhFo8kmz8mbInxdamipO1ys/fyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ap+egM13; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ap+egM13"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ap+egM13lZLpTj+HLu7bq3fDcc
	v3hHThDWm6CE7HNAPHWfBuT5ZIOKR9+NpQhjhCEPYe6N0mWpn0E7QbxOtQKY7mJXf5ZKBGsEHGU2N
	ml+mz+izXTsY6jG0n2K2BE5cZqfHqUOByuoYNyO+E2o981AKfHl/8C95AUobVvYk1f8kbhhms5a8H
	XXduyshcTzOG2sdFsufaA+17XoflWBZoldjwrgKuZMirSAl53cMfSHgL32JDNKSk6X6QMxBLZ+Y6t
	t5OClUwnoSktyAQC3WWCInb9mVy5pvfETF2keH0y1CXw8tmSFpwlkIC91TKKpNd47l1cCyGOoitvJ
	09k9mzjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U4T-0000000CDW7-0zqS;
	Fri, 20 Mar 2026 07:15:01 +0000
Date: Fri, 20 Mar 2026 00:15:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/22] xfs_scrub: perform media scanning of the log region
Message-ID: <abzz9WIAySMvvLwq@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507234.3681140.9786567058827431897.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507234.3681140.9786567058827431897.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

