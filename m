Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E6A20309
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729667; cv=none; b=XZ7pr7IrQx6Ned5ArpHdumv89zmz3akEkC/81TynhlABDWOqxuDOfl5P/3sGtoxmIwsNQjgoY/ADnxWuHRgEZ8lE4yfMKu6qJGS8ytDbzG/R/1CwWBQ/cvibYZXsnE9txGCrxsNx5Ab4fRJ8FYoq4ulbiDfPWB8TtsGTM++w+vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729667; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RbwnKtSh1B7SmCrVkuzaJC507wGQCLL6sFs4Kq1Wna1Q0PKMjy6VB6+cAIkUn0oPyn/G6VWjJkggIHFaDEfYi/wjR71cuWVfTIBtvCP4nfvH6L7Tge4hQ3hjl0jtzaarvsFYD85yJ4AGBthnGL1D7x5tKfP9F66GGmqvno9uqXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vkC+rm0w; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vkC+rm0w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vkC+rm0w4UUvAu0P+nqo9mV9my
	9ejRsI8rDumaD9FAg21hNamYShsBd84lE3nm/dnsPgLqiiSQ2157Bfix//d7S8azx4qHvpNj/2bqE
	gZWZVbBy0HakLDnKr4QaVQZ0ZJai7rl+01JxTJ37C41QDc2p2qdAN39BbIPVcMtOljpijnTvzoZ5Z
	/MLTsoflyXeOE2Apo8mYXMYLImtgldTuKlaL0cXJ0WkpsN4K9zKP4UOnD98eIeX7j2vwYmlPZQ77r
	Cxb1b6W6FEdH/TS1On2itMKm0D26yo8q0JdoBVOlKPwGfF5btv2djVAD7kL3+XggFWi19yy69719u
	44UUTQCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRE1-00000005L0L-0dUa;
	Wed, 10 Apr 2024 06:14:25 +0000
Date: Tue, 9 Apr 2024 23:14:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: walk directory parent pointers to determine
 backref count
Message-ID: <ZhYuQVC14gV7_vz3@infradead.org>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
 <171270970550.3632713.9842307177705801451.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270970550.3632713.9842307177705801451.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

