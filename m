Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8659C171BA
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 05:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712727931; cv=none; b=br/3THaOppTinKgkvH9B3p4TI79KerEXR6krwPCgvQ4PAiL8qqnTcBxHNmwke2UWEOOUIVlMmVi2RdFlFKOVo1iNcKXl3aSrnnTM+i2JQ+YTfTFnZKsuumQ2I0b8wRmquAaISZe5ykfw1tzCgATVejcqlzijwR9NJKnfzzdNjtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712727931; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q0sr6T6v0mXtkOiBytNdwz4CxELppSq2Qpa2WPRWSofDfI0a2OgFoqFIqGZckSS13EM32ya0lOESTelkBXOp6FKJprqj1+8CGXxi5dyrfYsMLR932mOqhIPWBkmddqxVAIk096QBllm+3/+wGSXzuskCPuBnQaYWatsEXdvIXgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vPrjI0/o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vPrjI0/o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vPrjI0/o6m0voP9OUPoIo4AR11
	LcOm5YZkAoVhBEtaGFmIdAnM3gZKLCpdu+1yLgAVNOuSNCt/2feqZ4wa0zvUmIzevj2KHKgwHprhT
	YSuOZL4OQKUnU34PRFlrhwa46+YdtLrRygY54gvaubDiOyEF4bd5IXiR8oCZmWzmXz2v07UJgjy3z
	M1OuUN4jfDJRSFSNIhHkbRJJVTfM6gAVZYJ/nCvMPbfbeDuvPN1Zm+NAGLkzLYBL0Z44HMlXeFiOY
	yst6oGXaCqurk+kIWy98bAAh2VMnf3hXEeJEP08zBS0YfPZwLZklckf/ullUwzvm/Xe4GR/WvzRa/
	MPpMNqyw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruQm2-00000005F93-0QqX;
	Wed, 10 Apr 2024 05:45:30 +0000
Date: Tue, 9 Apr 2024 22:45:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/32] xfs: add parent attributes to symlink
Message-ID: <ZhYnepMl_OCvNKVO@infradead.org>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
 <171270969874.3631889.4172660414607095925.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270969874.3631889.4172660414607095925.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
