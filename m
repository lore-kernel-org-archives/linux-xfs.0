Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5753D2F83AE
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990770; cv=none; b=D5RReGXJOLJ+cBIsG2ole4zdAoEKKL1GQWlrq/xbJK2Tm5b7y8ss31AL6im5OLDCGRvr5iFuHouuy9dODdtBiCIYa3qCK9wU/jebznFrIaCqE1UOhSrC98mqRWG95+PKiXkPInkyD7oH9U41Rl1FudeKkF4KjaXpabo/PMk6Ov4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990770; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PB9lDAXs9buh562aseus+j34TcWOmz56GLGJK5rrk4IdWLOO6I5hfnYhY5wdpsMi/tYUhsuEf7dhvvDkeoR+PNmTLUHjCzxAy948S8uBha82qFNsmB8qJJp7TQpVCABEbn2GOtzR0zVYj21lQNgRrkR6S3nSYH846w+1yVYPFKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iQrCnigA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iQrCnigA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iQrCnigA/WhWtYaga2MFjYnr0D
	jpWezmCS4Le/tOdHhTF66UgBg9MGGVt/8PudY9xrYyJSIgT3s32SpjTHREIgIFQtHPlANbIvPLdDZ
	8ToG0dyy/EVt7aWABmKUvplaIraHKgpunFOVm/tg7jhPeFzWwUeebzGTCH1aYBZ1K9JMuSLK2KnHZ
	aUJzNufUd3B6yukJvdNXuMa97jvXILa6D+GSZ+xj/3Zq2PUl9kfH7dKbn1JVcOb3S6XZ8loLujEhM
	kqajDvzCfivX7qFNUbZQn46nB47pQxgVXClXkPDIT+Fpm93ylWTFMND8Nistxax0486lrCEoTepku
	hf2VYi9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U2K-0000000CDQ2-3sFJ;
	Fri, 20 Mar 2026 07:12:48 +0000
Date: Fri, 20 Mar 2026 00:12:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/22] libfrog: lift *BYTES helpers to convert.h
Message-ID: <abzzcC0TZ6JgP_qR@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389506995.3681140.10591224413177383851.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389506995.3681140.10591224413177383851.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

