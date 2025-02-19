Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D228C0B;
	Wed, 19 Feb 2025 07:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739949392; cv=none; b=gn9mfqgOSkWAUVEq1WhC91XF7+MvLeiBNMyir+HrkaCHmswr2VQIzl3LqUxNgW9x0pbTewLHOe4eBdlrVAnF/xfpeIhoCisVw3aLPA5Qfj+LAc3Ux2rIQNJD1VX4DY5ikKkLiXSxGSd7s80cFTCvCGaZ9G3EgmoVKvQUeskIA+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739949392; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qL2ZSZWjxKl1ApMn48VSvZ73vL0XfZZNVF+b1aV4kuE4KK2UIwnAzEsvSf8KNZuN58Sa5RTnH4hxj09wXSqWMgbq5jxQe5N7ZTPa0+rFI28oh9Hjs36ET4Yow+YnJsBUZzeyNibTPQZHLJp/kIxTinfWgUdFIozhIMw8rvBznDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iBuzeNCA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iBuzeNCA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iBuzeNCAWm31Nt96xQnUTEuExM
	ZbUD6YDGkvHIA4UgzBVYDwjJXnfYtCKXcAQqqLu9uKhAI86LVMY2CXp1znjC6zhR1TmIkuB2uFbp5
	At7BNhmYutpOQPlx1i8+ly6uHeFaJUpkP6XhfHtLOns/hBWPHaLzECj/SSRU5AlR2Fwo0LkJvE1Xm
	Uq9NcX+Py0nrpA53pd+kJxk+FgawW9qOR2HGCTj/1IFvBQCrqezz/7/sTh6w/XtZxukqYHqSkIpjC
	HQBzJ8RXJcwGd2zEzGYBhs8qRYTK2aHd1OBniA2yc8gMtBhM9DFOX/3lEsL6ce6BjkTF4EbY2pFZq
	+kInzKUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeJr-0000000BC9A-05yi;
	Wed, 19 Feb 2025 07:16:31 +0000
Date: Tue, 18 Feb 2025 23:16:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 10/15] xfs/185: update for rtgroups
Message-ID: <Z7WFTuiwCDLWIVsl@infradead.org>
References: <173992589108.4079457.2534756062525120761.stgit@frogsfrogsfrogs>
 <173992589364.4079457.14192019317087260403.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992589364.4079457.14192019317087260403.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

