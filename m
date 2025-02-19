Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FDC17A2F0;
	Wed, 19 Feb 2025 07:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950306; cv=none; b=fDpTIao9XhAF2YEZYbce891aTlmndSzTAQXDM5I2A6Nxt6a8fSGBEBWrrqnaULtjHSPxYH2XIi4Cgw/CZH+ab80bLJJCDXP4ghQKnWdWS8NP+JzzpkdTp1jRzaBoYoYSiUPZN+tWKljdM7jcQfIYWxjSwAQMA4RMBgXbmuVwB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950306; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S0qOnBEHyrMNzQXw+6ViwyJ68rrz9jQqso+Uw+6g0WuanNqKU5a+Bs0nB4GmpOX9o4TjXRL8ECnl6UIFG4Ka+pjEnKhQk7j0r1H/Y26GNngLalNrj1s7jc4kS8TyTnKQx/SKUKwddRsYWtobaXVQXvDWLubXBRQ88yC580FwZow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z3EJqS/e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z3EJqS/e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Z3EJqS/e9FXtALnJ6EOiue3H9L
	ubwiHeNWaZtzHA9s3pdLFtafWG+Q8GVnm0cXEwPssFyjcprWhPTNvr8zMqamFdHzCgwvb8fjvlePN
	aKnIiyfgNyV887AbS0paa/zBmTyjcXPiNlUvN4DhAPVvmJdIY9fQgcVnGwdkKJTwfNK4XSeGrxvQd
	xs9gAGjS0x21YfphiznNmYZDd3itGYnzyqseKOrut1Czv0gB871y7NsmNwneCuaydnXeXDVyLFqm6
	oroQutG2HrNosLcnTD3JTYXgX5ZGs9LpXUBXOG7L/Zc2TrrBISbOcZn8nl2p+Gao6MHrLe8jX9lmw
	+wN7r6ZA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeYa-0000000BGCd-49Ft;
	Wed, 19 Feb 2025 07:31:44 +0000
Date: Tue, 18 Feb 2025 23:31:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 10/13] xfs/443: use file allocation unit, not dbsize
Message-ID: <Z7WI4IDCzpCrCzlP@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591294.4080556.4260451757807530626.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591294.4080556.4260451757807530626.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
