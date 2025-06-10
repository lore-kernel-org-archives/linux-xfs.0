Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0870243954;
	Tue, 10 Jun 2025 04:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749529939; cv=none; b=V7TMU4Z8BD7xYYLgCYMFQYULvZxBIF4cpLPiUwsdyUsu2c+0FyFgPEttszGIYpd7IJvyn4gUiNni6Ysq7zyoFIjwj6Jcs9ud8Jp7JapKkpfrrPL+WzhnJraqwwNVApsQH+NzhyUyT+C3eVpdGdVunYWi5qZjm8yAzrlks2TSmdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749529939; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msOmViYHPQJ9t0tTfrPWnDeYOUnBUUtb5hkohfznhVGzLNxczukfDfxoXGuVGEkxNpdMJFBqNQZ17c2mVntjQwpUwMtkNXShqstdiUI9nDWYdobiup5/+Q+s5e7Lu5Z4+e2jtGC5lQpicdQZ6PPYoM9oa4GQUbKUYtN7OKLddKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SLiq3xL3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SLiq3xL3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SLiq3xL3yEsDvfLyAhsXh3FBkk
	6bWlCXTJ49rGeI+E3sB4dbLd7HteVdW3j6fQDB2F8aUNIvCZ/KXpXWIE20of9WOAbvlYixL77ZUWl
	vMfcabD2q8Mq8sEH6GmiV41RW5nO5Nlb6d0YsB0VgjEywjcZuhWLVz5lBEXTdkDC/h7LgfLDPF8BN
	lL9+u0ArZeDNitWWF0bytU9MTWwFMT7oP8tMEZSjFTBDLKv4V/F+cegsqj4wfSJQvSAjW/4iBSWAA
	jUUS3/t4A5rHOlZ5PKdc8nipLG5eH+SfZdjyqYTm6vN13yflgaPCcg/GK/smbM1AUj3/LohrS7VGL
	G9R+X57w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOqem-00000005kwf-47kJ;
	Tue, 10 Jun 2025 04:32:16 +0000
Date: Mon, 9 Jun 2025 21:32:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/7] iomap: remove old partial eof zeroing optimization
Message-ID: <aEe1UE9b2mMh4SXq@infradead.org>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-7-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605173357.579720-7-bfoster@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

