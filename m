Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFD8316180;
	Wed, 19 Nov 2025 06:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763532869; cv=none; b=hTTQUM62uB6twNr94y8xB68BCDRc/voorjnRVEfA8+N10qGzRBEo6VJA88GJZZnamsllXns8THn8p76YhrZRuDUP7NL5o13Vu6Wi44cuh2+CQ1uUEBS96rYFxBJ7tPfaJG0cY98hV0tBQNpMz+p7WA9QYxGxH9tdOcXav7xxFtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763532869; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f89mC/F2+GS/6eQYTXn7nelu4hmfzXW2LB1lpmgm2+VvsssNbDLRENtgNBv34E24Wk7VKLry9fYH/yEU8Z7alqf+qThD0vKLhPT//1zoqyKRwkY9hN0GdE6XeD2fEHIr2GCYE1FZig0NEqlpPw2MSjFsD5rwbnc8/YjTS+pyE4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nCZi5sm+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nCZi5sm+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=nCZi5sm+mc/1WlIU9t0ehK/fYy
	ZhI5o3qBglmgYQCwx1z3ojU5UHtQdEaD3wc8aLMIKjnPYU/lMnCA2KzunyIfkmsSXWDc0mtUQ/X6U
	y9ak7cm3maXKX+9sHpQz/O0kGJeDi/DhEBH6i3Qxpg9jSHEhvKRK8LO7N86QpMQFIBnX3dKk9wlXp
	7+V59GnBcluvgaR45r/VCnXXbBxqbROmEjkYYp1cj6rQ7zQ1HbEtch1I8jnKPHazcQneoBxq0ApKb
	2DkdaSPGnvb+mUTCSOUcy5LecjKjU37qv469nNKdupkBupmyELY5XqjAxHymJ++CJy+bg6Tv/G+1O
	S/mZ2/qQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLbSS-00000002cmD-3Wbs;
	Wed, 19 Nov 2025 06:14:24 +0000
Date: Tue, 18 Nov 2025 22:14:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Donald Douwsma <ddouwsma@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Zorro Lang <zlang@kernel.org>
Subject: Re: [PATCH v3] xfs: test case for handling io errors when reading
 extended attributes
Message-ID: <aR1gQC0ZhOHoxHby@infradead.org>
References: <20251119041210.2385106-1-ddouwsma@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119041210.2385106-1-ddouwsma@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

