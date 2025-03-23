Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A264501A
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 06:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742711681; cv=none; b=dELU6KcKYVMEKY2GaNLwCEqGfNQVwX1sYCsdGb5XL1qaxJyfmGuA5mMkg9L3K/KhfQ8jGOrfdE/gIu3u3yY05psFdIOwbIRVaG7HVDdJDSf3tKGgI+0QkvdAhV/US+bUSDcRxzLSkbXyZJ2iLWVxzWCceclBzb7H7UyOlD8cuTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742711681; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rh2ZhK97Q49uStWDjq7NAWS32+AGLVN0tClqKUwHdkdFwwRfGAbVs2M/C2kSUEumrZF7lB7TdpBxx/zihS+bgTUuJyUTIZb31JWJCtC2ZBeq6g6FK2H2yL5ujuUgpze1h4cshlIelqUM5MR5CujeVxCRWY6AOtWgfrVa9QvwQo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l1WV0/jJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l1WV0/jJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=l1WV0/jJ3m5X7q/QKNQExYOnkh
	xvKH1mNSHQoL5Y9APRPg7RZkBXZfAaYpt0CjUZNVkwlUcocbTY3GmqkIXTBwUFPJlt58YIlweaqgr
	3omK8/Ebns+s/wtTNbUSs/ZP5gx8izpIIoUdy5ykusOltA4gFLhSzI2kegXxCVhrE7qIsGjBlwv+v
	YAcr8hHr2LA6ge5uCqpTsHfPLfIEHwZcA0p700aPGF6LRiNtbp5lro0spauKSjObwrnJ9xo/2ShUV
	sAlvkULEI67GaGdTbgq4vHQMXJ1++5QF5KsSU0HB91yLkVwjs8iicND1AsX2MYKUVye0MwY933ZL+
	mNl9pI/A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1twEuu-00000000lkm-0011;
	Sun, 23 Mar 2025 06:34:40 +0000
Date: Sat, 22 Mar 2025 23:34:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: fix infinite loop in
 longform_dir2_entry_check*
Message-ID: <Z9-rf8NfiPLhXJ-h@infradead.org>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
 <174257453651.474645.12262367407953457434.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174257453651.474645.12262367407953457434.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
