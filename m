Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433A11E525
	for <linux-xfs@vger.kernel.org>; Sun, 17 Mar 2024 21:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710709910; cv=none; b=QEl8pfBT7/6a5kRCAbEe5RNc8N7Egn6S7tUW4fV0rbW0Cwrxh4V4kKUDTHTcf3ljL5/dEaQEM1u0GL1/aAv36v9uH7ehaU/BjsFLp1E17B7UVsT5AZqxLNmmRof0F4sKtEaLrn3xej2Hhgq7sLXJyoWH/J5qU7rohF2mk7MY9rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710709910; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgY4/uQ9R3TVgi7yQi1jtnPothr5W5FwNraai7haTwKTQEyIbUXp9yK6rdvcHVIelMl7bK5/WQGt6X11TPjT8P6qeyStOF3BWu8t9kS6qNECHI9RgAuCRtBCthuWQEyS3AGLy7ta3G94JL8o8xEjmTV1QDFPmZOuCaUfbha7qDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fo/0Y11o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fo/0Y11o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=fo/0Y11oQ8ZIMUffwvdmCHvJPQ
	gPVCnGscIE8uxlc3SO8jqtS3YaJEmjV0fkto+ucM+Zs0L3m1uaSkV1B1YHEnNuNmCButsdg66HEah
	eQGvZJ5SBk0gip16M8oY2JfS+7YrYeuyVG2C6Y0Qjf0qO0JCCdcH9lD2W5f0Bbz86DWPZI/pfU/OY
	IshPTwW3mZnk9yURZeMsOVsLt7wp1hDnb5LAiERL5+foN8l01Le1L6xCK3BN+FbeFndMHHYQA1tBH
	SquvnKwrjMF9OiW1pTnntEC76oMQd1zWuFFzkPP6sF02x9QUG4V9onrkCFUNAlKMmUNieM+hBQCWZ
	QmQ1FM2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rlxnI-00000006Say-2Q9Q;
	Sun, 17 Mar 2024 21:11:48 +0000
Date: Sun, 17 Mar 2024 14:11:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH] xfs: quota radix tree allocations need to be NOFS on
 insert
Message-ID: <ZfdclHynV-teMJqh@infradead.org>
References: <20240315011639.2129658-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240315011639.2129658-1-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
