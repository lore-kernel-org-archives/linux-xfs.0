Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A1535958
	for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2026 06:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774333106; cv=none; b=Jr6fqcw3kJLJB7s2pJcUpVgNIy9v8SNmtAZ6Rr2SHBHV40iGadgK1EhQRpJlGNbpY9/io9mcQjjKoXl4lmMFTkm7coCh3MgXaNXocJJ1piphp9JliSaMlAFBJCm++/81AfgwYyi1XLLa4cbW9/dQf8j9xA/vWIHzTzDSRTlrhmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774333106; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YFvhRpjw756J3onMMKbHLNc6TSLXsYe9kpVvltsNbalEmEfNDHjzk4i72DuhsXduvjwCQInxqoworylOTwP2hR2MeLvxCIW2HFVDz8yJTzAdsGmYDdVr0Sggu9prDdzz8esFR6CLDysfVR5Zc3jZNlPr2LEJPj49GIF8RxTxj5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CwC60P7v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CwC60P7v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CwC60P7vBIXrPotsbXA1TeMU6D
	BcDOOG57viu7TCZlxxXE+4eVCIocnsoNKEPnlildw8iU2VDfa0wJy9Hmkt94ce0SGC0Iu7HmLVj9G
	Kk9Xh0B02at6ZFeCVKQm4ZyY172/mjpn3lx1/PXNsOVQk/wS1b4LyYOZ7T85uwaSbTo85o4pbGD62
	yTzS9r0i+IUYAlyVxQ1HoNHEmxS5593WcThhQeWB9J+YAue4BvUUGEZDUYVklO8r5rpWjHZrekcEM
	oNzdjehdAgJ61+yNC2/QNMrmswMMQdjrtRUvynsenFnQlGkzeHAN5D9RVKzOsRMqlucJmxoDq5Zn8
	h6uaJ6sA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4v5o-00000000g06-0RAe;
	Tue, 24 Mar 2026 06:18:20 +0000
Date: Mon, 23 Mar 2026 23:18:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
	david.laight.linux@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH 3/3] xfs: remove file_path tracepoint data
Message-ID: <acIsrBRwGFMaxBLo@infradead.org>
References: <20260323210157.GM6223@frogsfrogsfrogs>
 <20260323210433.GO6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323210433.GO6223@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

