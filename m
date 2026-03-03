Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC91D5160
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548918; cv=none; b=Pj3QgXkBwUPbzqOo1e/EFNY5n2hAHYmXyhYTQZDGTwdEvdRRiW7GrRvZ4NxMEpHoUJVXOfE7jXVBqh3HYkrGei3+ZrHDvQ9TMg7lDRYvtWm/KTz4yue837IqsN6r+7xk+kayKcIUeSv1zCi2Zxu1FigeCr34jAJnYwYkI0SYqLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548918; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4QVNXDGwMRNvx5wBUi+8eXSL9aea38mlwz71krPyYYRcHpcqaHGu/CaADRYDWGZzasqXJ9KcU33iVdswMFZeSkZAJCfRuJbQiegHSKc1BI48EXkWZ2lv0AHjU7JByXzP1p5+ogGncrXfxV8MOqJ9FWJGgcenPMDUnWx7LCmQcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tcCwEZpf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tcCwEZpf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=tcCwEZpfQz+k0ifI9KjXp+708l
	5nput/rsBs/vVbGjvCjXltuiSjbzjNH7wVRYOzR14+tA4zGxjY5NSAI4CHseVZYryjgqgPrpgu9tV
	Flq0ef1qNbQBUQF6UpP7f7oYy1Gm19EaFK+x1ouVkOO5t+/HPbhBMHWMNiSxgU8Q7TC7JQOLr8rwG
	OFvuSD/Xmi287AAxQ/wFmAfue+DLnctZuZ0/xmCHvfWOcTHcjSFIy6oU5bAtI6Pyr9rk2MbwCHjjU
	kM0I/9b3eTOFQGrAMUOnMJMpYu6DNct/ruA8GlWRdUJuXOvgEB/AJTjbHX8MRVfteiWVcmBUQS8f+
	W7OHSIoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxQwf-0000000FLbR-1Zin;
	Tue, 03 Mar 2026 14:41:57 +0000
Date: Tue, 3 Mar 2026 06:41:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/36] libfrog: hoist some utilities from libxfs
Message-ID: <aabzNYw54yeYkNh9@infradead.org>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249637795.457970.6552712137048900310.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249637795.457970.6552712137048900310.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

