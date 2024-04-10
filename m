Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE65720DDB
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 06:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712729944; cv=none; b=Yhp/qdpR+HlPP4SjJtVdBPIXHKXnXf6UfijFdNgCt+q2Y/wBaT4jnzsc5H95mOkjfLjb5utFSFtmTHfYep12TF0+MldUmUS/VsXsrU6Ccimp8L1nze1K4HxqzptUlyeQPJV2ocr6eBGGkX37diJfrriQ5vlQ5lm1cnJEwZUj6sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712729944; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lL6OUzkqfEAmbIffVjk5/QVTlGALbrNj/LlXmoZ4arHZqYrZ0HLTBTUvsABtO2fFdm6OVUJMDYGpDbJuxRfjC+3O+HvtiAZWHtbzooIiCbvPEJASTFNeB68je/u3vDWCqn5miTEGIoNfCAee+9JKx2dDNe1bx+vroz5UeylXmX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BY+2gkaD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BY+2gkaD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=BY+2gkaDU8YNJCis5vtQAvdQr/
	Qevl8palYwly47j1Em/IrgBaZ8wBcK1Ig0D0vXmhh1OGXB6QZnOmhSvPX6SeoWiAsvwnGln5BkepS
	wrnsLnSlKjIvACuN4IBC3a+ozsWQBFg9TftnDnm9pwLll5tmoj1fUUafd+5i42CdT0YneTzxycRAT
	i1GcruNgsignA4FAONoSPpT63Xe5TcYBRVprKitCGQ++lRTUujG6HXI9NSljbh1Np+gyWfZi2IrBg
	ZbhJDQaQlDb0li4a8qS4w/C2uqkehoCMdssXIWXmcN2rUi8BGqknz/+VbSSewC4C29mjj9kwLOWlf
	3c5Gva0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruRIV-00000005Lqx-1QUM;
	Wed, 10 Apr 2024 06:19:03 +0000
Date: Tue, 9 Apr 2024 23:19:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/14] xfs: repair directories by scanning directory
 parent pointers
Message-ID: <ZhYvVxDoQk_JDZox@infradead.org>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
 <171270971037.3632937.13617384622023653070.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171270971037.3632937.13617384622023653070.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

