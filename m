Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34A5224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733807127; cv=none; b=EK7+8EJyKtQi6DZrgpe/9mJMnqdJBawXaBs8c/85iRXRB5bgJkput0oAs2SwKbHLDypz+XyW757cKmW1QUKfqqLqf/hIJ1IljFPfLnPX+UHGGSi6bmVB1fR5/6J6FOV/TA0hTRe9OXyExV5A2x9U/oT3GgWVyOknngduy3lO3xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733807127; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTRzIUL71aiCDqYLpEp1gc+25MWj/mr52xpykcMTGDj+ifY/TL2gIYDX+6scDZo/OKyn9Rw+WlxVZ0VibPhkRXF7VfMRoiMvmZOGLLCf/hzVIFdb+K2RNt9SIh7TRKzhnDDEK2r4OAV7LUcwMgvzfBDxIvjr/8IFKWL4EqxyyQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YC+vhyIK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YC+vhyIK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=YC+vhyIKMWih7uYAs4wfW00dnr
	ETCy9+fVUh1Uaqe+ziEjU1MAC9SIQ2KZbEcNLLCvRgLUIbcq4WZylA5ro38DrfCuti8jgE1Lpt43a
	SBcziChmf5N0fgNK+obNUdORcEzLbwTa7+Ek5rIK7mAdF9odXgf6Y2NXtKMVAnQKV5/hNqxyoCQT+
	Yb81wJL1/8G+id48jwjlrKffRrXGL+Mt/FCoVutY/mZjDxfIZMJNvuLEoe9a0i/OWB3ZL9ypbhXWV
	zhgxe1vwkUagolY1rgA85dOp5D0oPWeHxI4+9wMJyHt8MkEwKCwthplbxeKLVEehugwIWEAituD2c
	1Q3tnfLw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsR4-0000000AFFL-1l2Q;
	Tue, 10 Dec 2024 05:05:26 +0000
Date: Mon, 9 Dec 2024 21:05:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/41] xfs_repair: dont check metadata directory dirent
 inumbers
Message-ID: <Z1fMFlETIqD_5P0G@infradead.org>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748573.122992.10119337750632485982.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352748573.122992.10119337750632485982.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

