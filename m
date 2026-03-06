Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C9237B41F
	for <linux-xfs@vger.kernel.org>; Fri,  6 Mar 2026 14:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772806827; cv=none; b=at7TtnSNFAl658//CmyNsHELkc0OdKAmLSmhtmcQPgd/QDmU80uovLf+0hNzi7B66Ul5UD66KsakPuID+S8flzNT8qn0oLmrOsvuxXSr6E/NAZV88c4MPziz/B2wQnOdCDQin1c/YWzGlot7hfeSuUULK/72Pi9GNujPv7eMflE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772806827; c=relaxed/simple;
	bh=GsmiZJ5u04ajA748IkQY0IMrNgdmmjeHMe3TeB3GV1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qR8jv4O5szRYC8Vtv6tVJOY/eOem0h573PfOGdz+eqcnxz1RJYuYgJtm9+/HsOXkdcN+I9FEh2emiL5cGck7RbnsGlDgKi1NrJHz6ocZcKnMtQOBm5PdtMFbzOzcy8rwFtPWv1PErrHxhh4hYU46g3nXsVM/WiSqt1K7b0DpYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N8EYT3sM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N8EYT3sM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SVTTVO0j6/MpR1LboTqX4XbDNzuyeKPEScAXtWQZUP4=; b=N8EYT3sMvT+kt7bRCYT5ByH5sT
	giJVlxaFJukcFYCNy9r/oUL5ckByXMA1DbBKxHSxIU/86MKHrYn2ygHnN3AGH019mv7fpgoNtug3D
	LefHLe68RoRYbVv2snWfMwtZgThxy3bLJ8tRyG+YfpCHmgGzH+ePZEMe1qCLQqBg7iXGuNvpZrqFZ
	RBV6TDzoqWojGrik6PtiKBoTADIR6OTzOuosrSQTwHHeKs+ndmvw33VXPXl6/GSQkAiR4kNOOURjz
	VQCyceBbZ8KLgCMoaUkWnsH8HF3WDEM5yUt+VZUzfERks8LAQOH5Alwx62G+aQnD8oBG2ccjGFldx
	GeT12vHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyW2P-00000003tbf-2E2s;
	Fri, 06 Mar 2026 14:20:21 +0000
Date: Fri, 6 Mar 2026 06:20:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <aaripVrvxgo003ya@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
 <20260303172916.GR57948@frogsfrogsfrogs>
 <aagt0pZTkqysyjQJ@infradead.org>
 <20260304163502.GV57948@frogsfrogsfrogs>
 <aamLP5UnWiPhvKqh@infradead.org>
 <20260305220051.GG57948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305220051.GG57948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Mar 05, 2026 at 02:00:51PM -0800, Darrick J. Wong wrote:
> > Still seems totally out of place for something not touching the
> > on-disk structures.  What's the problem with adding a new trivial
> > binary for it?  Or even just publishing the name in a file in
> > /usr/share?
> 
> Eh I'll just put it in xfs_{scrub,healer} as a --svcname argument.

I think I proposed something like this before, and I really like
that!

