Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D790228507E
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990877; cv=none; b=EeEOyih/KY2WHkVI5wx2RL09mLi1IGuqxjQl7nvNwMgum2Pf4ivOR/lyBbTGDJOA75R7mSMAYXTr0JBxnavemoe2Sd/pUnDSjZJkm68DpTQSulAtP0gtZE5o0nfkk16DtvpOUHc/pxrB1Ul/4OZi+GcuAUl5Pyn/aWqsXG3MJeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990877; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbYGU2uEGiwL/S/O7f+MlyDjBP6yciRT0qei4T0Sp0vq9J3VbS2YuybJRGd4qXSg97sN6/SsAFRy5NrnyEatcdVEyBjNwcFUgN8VOtEPkzJXb0PSlDy/VDgREMK5YFSOPTjV2raJI+L8nGt0t5ZC8DsN8ntC9G0mrJCdUfDA8Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WbYcgQj+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WbYcgQj+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WbYcgQj+1xxogNq2gbesq/1lty
	nW7Z/uROCsN4d/92BpZnK5QsKHuYP25PxElnQllErxBp1WEjD2+Rij64W1ExkvaHv20DnXghHrz8l
	JgyRdDS0UHy6rn07QcxKMMdXmaZjxRJijvXvT9qhP89kJwVqZxbjRgoMdh9zErmu2tbav04us2EJ6
	X2qPBnWfVpJekt11Ks2DdRGQxTNou7d7nXFV+G0NwRP1NsTh6eTfc3BYni0aS5D1IXVfdyZ/c0WeO
	IEZM1kJJKwmD0lWg0yRwYoW5GiYbvI2cVU+1Fp3KQmagp7eFJ0P7MvRKqH3RBMBTODcylI1Ej4wqk
	qQJJYHbg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U44-0000000CDTp-2D3Y;
	Fri, 20 Mar 2026 07:14:36 +0000
Date: Fri, 20 Mar 2026 00:14:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/22] xfs_scrub: rename nr_io_threads
Message-ID: <abzz3PcT_vowdKNK@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507141.3681140.14458592412302448426.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507141.3681140.14458592412302448426.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

