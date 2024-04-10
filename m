Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8164A
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712725912; cv=none; b=TsAEGNGyF5rVg9cE/9auzWQVeiLSj15PAG1hfY6ZG7Fa23J1Vk0yeTlLfTGyPWr6z8HZBoqvo0hZjrv7Dn3leiUm6egXR4NrrjJFHKo++UED7EZjKJPwqHzf3ru22yFs6gCuTAOwSV1qK7gmk5ZkliFkzm9/el1drZKwXAdlWx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712725912; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uIMd2NAIG5oVJMQBg6lv0YaocWEjrBiydhx9fCKPDs6Q2FSGUBRS+mAczNYLMWYNcb+sFRbfgA/ckgdQPCJV5DgmHoXPAwR1xiUBxFaVa2u0GdOBrdZVc29COMCQ/0LQO4Zk7AvYf9MBsQpYdT+o29aVbPCev+zRRGoQqNxbDkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ba7jHFyh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ba7jHFyh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ba7jHFyhrB50eURv3UDYmghaJ2
	uvvHmaAFpoplgE1H0BZKdSuzzRxmiq7UlUZ06yvP4TnlPXF1CsTJHu/iXUw/7HQAfV5VmNQxF5A3x
	EkEK/fAalE0djXOfoMVCkYHYwrwpgrLybNgK2BBMGrFbr8i8ygK0bu9AQz0uODyHPMG/q5ojn3ERn
	s7I202EAfuNHPar5CjAdn7FJ2Oe1d+amKXgA0EygQkQvPbCt8fgZs5Ya3xXTwAHKa2kWCMVEimfMl
	6PpMdMG1Q5VjfUKDb/EWPWCEWKsxJtyFhbp1ig3bAejOm/3RH8o9tk0h7EltsvLIGDhHfed0ROaIx
	WXwxa8YQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQFR-000000058FL-3JRU;
	Wed, 10 Apr 2024 05:11:49 +0000
Date: Tue, 9 Apr 2024 22:11:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Mark Tinguely <mark.tinguely@oracle.com>,
	Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/32] xfs: add parent pointer support to attribute code
Message-ID: <ZhYflc28DMzQZ3Gv@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969640.3631889.7554917757452786883.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969640.3631889.7554917757452786883.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
