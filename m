Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6043BED07
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 15:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772552886; cv=none; b=E3ACZ2s7sLVKgZZI4eqvlzPvMhUGwbq2v8gIpbe8D3n9w74csj9v/yezhvLt02b4PQdjnDL7JuEL1H/JAyrmVtSrrtw8YLfta7Q0pRcygGZMn5R5n7lF2KGNIWGJt5FArMCUSkIBOpS/TY2QvkpMQ3EYkNQWyjAbSb8sKc/O+Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772552886; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0Bis8JIVE2JhNkz14tFgx3Wm8ODmNi9MXzvxKohhnFkojY+NkTeqKvvwvT6jry4+0FTjNklpQX+tsnmQ2vQPrW5Zh+xnQ3udHlzYmoVZlUZEe3AshKa3pBw0K8sy4ut4STEgj7mLfdm6ETZFwGBp5W4ZwVWcYzrJzx1Fw0ysW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GBCkmIdi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GBCkmIdi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=GBCkmIdi2FCbW5NexJNvaideje
	ar71Ij3ubSKjwLYP45mC4bKNTNM99Zwl4mlVjxH1ungu85jWRCLoMuuSG1adyTlk96pNfdqTkSrx7
	IwnmJxLSX0y+qAVhNiRdSVHL/Z3iCK0+79L6+GHmT7LBFd+wt12QUK+gtBSfXGBWoz0HPiFbcbfk7
	yQMAjgpEXIanK0U90vO/R3+yfNZKrQHglbz25dqlfuQl9o+hYPYwivd3cPn1yxqqRtjeDwp/CkfS9
	UN+yKr/YabqSFrzZgYBUYFVTXoF8rE4BHQonsyPwalpMoijmqwMwGcxCVn5d8UvqXFxAP/2/725UW
	KTgLzR3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxRye-0000000FSn4-430n;
	Tue, 03 Mar 2026 15:48:04 +0000
Date: Tue, 3 Mar 2026 07:48:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/26] xfs_healer: use getparents to look up file names
Message-ID: <aacCtCzCSq2q1pfW@infradead.org>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783490.482027.6355392425600511229.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177249783490.482027.6355392425600511229.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

