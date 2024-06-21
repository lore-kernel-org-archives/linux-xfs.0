Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F24EBE
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945043; cv=none; b=K1Z/CBoaED/KZOScNa5/pr/UZxaqoX2SrdZ+alV6OlLLRRz2gu7p3xy9/2neSUeSyjYSOLG9BNUP+5LZPsh99eUSH7x5zkI0NSEAOarnVi3D/ddGYP8nhRrItz9waEDgRsgbqNjzzlnHhxczHuBluZU7b89FYjsIGDtDBluJYq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945043; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdUQAQVaLBkvny/2V7WJulSDIOXx66PClJTcoTflnUWPJJSiIH0FMUjxxGYUOpgBdb7xt74H+pQGNazofK4tNKg0HFzRMu2JSfoSTQy1kEssv45s120vpC97UnjlFQ9uOO6XY+sjoN5BIsRxHikeY0yNZdz35zCequP7G3LNy8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Qh/apLVH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Qh/apLVH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Qh/apLVHvrHj2W86IVxfzzjtbR
	1Fod6Cz0sG0JRIj3FAgraR9hP3R4ZEvZnU0z8oE3kV0fDez8NWtQAhiD59qOkMULPFNzunewRd/1E
	xiUk4vbpS3KME6eZnVLjvnHfk/Ua/ACH3FQUgc3px/IQF0/RaobiUPPivh/R8Yt0Hg+hMfrHDaQHa
	QGMfK/+HSS/defXsQpr8rNCzQFHbMg0dQYXpQVBVPl7BPxU1ZH/lqVDdwwRWDihShvQxBe9xwW57E
	ccX6THkZziyJV3wu422qjd7fBiV4tTwbu/mLbQb+2Cgk542yxh3D+dazhgigwO+W7I8mncXR5ce82
	0MUglg1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW82-00000007fr9-0aVJ;
	Fri, 21 Jun 2024 04:44:02 +0000
Date: Thu, 20 Jun 2024 21:44:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/24] xfs: create libxfs helper to link an existing
 inode into a directory
Message-ID: <ZnUFEoDcFnn4YnKw@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418191.3183075.12556823901451535807.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418191.3183075.12556823901451535807.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

