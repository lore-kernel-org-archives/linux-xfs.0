Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23CA1547CC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 06:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734070343; cv=none; b=Lmu1IjiPGwo4Qd6plCNUNkNYjWAEGCGoFGaFx0U10IPBal+nHynWrFftViUFGE9FERe8v0AnvcbcFNqsSzqOetkktak+WpjdLKgN6/RY1umO0+sjaqPwsoBCHXcp4Bwv5uWvT7x85xERHbfS0D732iur1QvW5tnnWRaLhui4Q4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734070343; c=relaxed/simple;
	bh=pjFz+/AdZ2VqJIZsdUPWUKczSRvZFjGDxlB7lHbobkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SYldSCCxZr4t3gl/VTEx43EaNZ4VheSFf8REjAI7q7MdQela1l7ZYsgyg2zJ1H1lnTKZKjA2VFoWpD4zsop54F1L7gb4CYP1JJtSmlCloyk3M7OHrkdZk5SaINPfswIlK+qn/HWMjhWK/Z7K9sW2UVBGDDy3PFPtUBL+ow/lJog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XQnW0MeC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XQnW0MeC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=URp9DYEu1QMEm6XjLBsNktN1ITMu2gb/lD3imPwVMkY=; b=XQnW0MeCe7wHoDMuPzJXpSm5+p
	2MN+HK3dGKWq8y4d2k5f3OKfdXwkLy4cl1gkD85n8APICsQlvGiMo84vuPyMwLnByPT5w7P5LfMj3
	3bdmHNsZ+qJcNAqNvwLgSGfvkjMcJPIrskC77yGfVBCNgnnUBCHLOLODInyELF4K3Z18oIUIutEd2
	5maaCgeqUoEgPiQInZ30x9i2ubQJEoPM+kldE9K/jfukVvkvL7/GRQUOn6+CzSjuqT0DWsDGPW05v
	OVnMmItLAadW5wCz0dMxcAtrmmrn4Ge91bxb/pyRi/8SCqua0UUc4Kna4TnUNofwF5mlvYNGN68/T
	uB+gKkJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLyuT-00000002qRS-2ZJQ;
	Fri, 13 Dec 2024 06:12:21 +0000
Date: Thu, 12 Dec 2024 22:12:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/37] xfs: prepare rmap btree cursor tracepoints for
 realtime
Message-ID: <Z1vQRZ8cVW7-YLVu@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123347.1181370.69471894031928674.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123347.1181370.69471894031928674.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 12, 2024 at 05:01:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Rework the rmap btree cursor tracepoints in preparation to handle the
> realtime rmap btree cursor.  Mostly this involves renaming the field to
> "gbno" and extracting the group number from the cursor.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

