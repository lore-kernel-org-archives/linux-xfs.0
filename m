Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBFB24B39
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135549; cv=none; b=sif0sDlOl5cYcdBUfTi9faEVNNUatVL8IzyTmya1fHOUcoRT9Mz2VxefgrqDXEyrmqSu4OJf76Mr2FnxsHQZnC9QFT/0VDVWzChB7K0svNwNg+O/mQrH1slxDmVzClnslsIv5oR7LOzVUPkXVDBmhk2xlyNUcl6CZfqyiELCtWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135549; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ed8dAZA7gH06YJokFIjv1C7URODh5f26ndGlOAQGdQ1+ZeUq+TtnMg55oXXnEUzwKa1RcOGMrN34XA02AJtsHJY7OTuDM/TBd11R1RrFdonFVCc4nIwyL3OiB0LaVfxbeblMhkihBokbocJcDMQq4aDsbtQd3mDEoPDLlheUNi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WHulbVDH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WHulbVDH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=WHulbVDHz5TdJ4s/RwZjBbvlPw
	VijUiCLszIOt+SCWzZERzBz64k8RdrpOO4MuQPaPenDO2vm2wushsnGBLCSC6Hu/QKZmD6ptZDiCe
	x8TjECDg9O3wVsWp40IxYTknIDwSJPrG2LF5rV+j5clTIw0DEHhqWMsEuy1xDoTajQ2XatzNIrF6u
	FuNJlyozQLmMIHwQU+rsFqpNbO1P6/o0cO2Cuiljsn6p5wVqDvW3eW3L+pUxHWOAWggc4NfZSr/ri
	cgQ8VH3IPVxmiTHxhz2necN6PIpSuWVS62RaRNYPajJ+VU2bk3EyJHIEO/6+j3qL2qMdDUDYIPCXK
	bBCfq1lw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMEO-00000009z9k-087D;
	Wed, 28 Feb 2024 15:52:28 +0000
Date: Wed, 28 Feb 2024 07:52:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 14/14] xfs: enable logged file mapping exchange feature
Message-ID: <Zd9WvHK42zP-tXjB@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011871.938268.5781764407461752680.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011871.938268.5781764407461752680.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
