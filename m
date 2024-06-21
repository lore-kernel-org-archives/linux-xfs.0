Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAEAEBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944642; cv=none; b=JUhA1BbWqyDKitBXHwjQyWeJ+tBdSKpcj7/Vhz13KxRQWnQL8Ak/tQS07ar5o3Y8Q6X5onG+C5QI2jbbT2Iqas/Vvl8Od1y0SdB6j2pyXV5wAIMG2/6H1CR/qB0o33AZU0HdjQrfHnbeGdMj2mkpgle9rBvDNNtSfVjLQb24pms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944642; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOSh+TacqGZTshd2LF4B/xvEE8uGy7xHNeKqSeKYSFzkq3DEWhcr+ls/1pWXrOC8PpR28GIbS/HqJfgRcGl+Fr9Pt+eobc/9ec5OeemocSEXHeEqn0uKoconNUhucWwOw/ov2/3WW4cIXV+z+BdoE1rQDUhu0CfAY0Fb4IDrb/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wh0vG34m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wh0vG34m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wh0vG34mTzulXCgp73VCM3RMxu
	pJ2N8zxsWqkfZxdCmmYuaebUmv1MgdpiRrnreESA+gjRJlfwRcFq20H6UyZSLyRrqFR3zJB6FAQZD
	/9HeZ33W4g1dKdVSzy0WSktMB8YSlOrjcSv+id4Mpim2xkQw+1o6kjeuQcKsKkLcsmU5TpQU4IfJK
	4l66ON7eOSRGEesuOyh/aq8CrxGf/Qv1fmjIe31eUFbm9LUYyk1qPxCvL8HJEOdAc3IQVdwATU4N8
	uopTdFA9khQVb9XncFw8GC551t1kUZjzhRYD8xslTvK8ExKgRvuRq39Jh5Zsf1li0vLTN0Hi0obr3
	4/XUZEng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW1Y-00000007f8C-3BmQ;
	Fri, 21 Jun 2024 04:37:20 +0000
Date: Thu, 20 Jun 2024 21:37:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/24] xfs: use consistent uid/gid when grabbing dquots
 for inodes
Message-ID: <ZnUDgPaKsy0uLyzM@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892417910.3183075.14464477192227662952.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892417910.3183075.14464477192227662952.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

