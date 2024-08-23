Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3C8171A7
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388645; cv=none; b=aBOSgx3OUIIcU0muc0oLGz4so6HJJnxWWycRe2OA8CLxlQNjo9wd2VeIhqyDY6Jw81B7itd3KZpUZvgBlg+8UbG6XoOM0hl0Seq6VNjDowkkdbuzw0OHZnuFcL0cz66MxN1qJmOxfdBoP2K5es3hMpFD3Tsq24AzcajBpc6754k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388645; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkyXZ7u/Q+5hcsNBLFqgEIBtL4TK1lGaEJaCD/ouskPDGtSlYwWmMIAMvhSFWZyZcg5nKsgDNuLzeC6BIH0tOJhyuBB5Zq+BZj4VQK3yS3rgHmFMFjDWGLRvsjDysAkpZi+7iVGgl8zUiifi3X9ZvzB1MRPqVquJJPDsJaGrEnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lF3SzY2O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lF3SzY2O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=lF3SzY2O4HSztFv+M8G3VHy8iK
	oC/m0VhZCGSzf/EHE2qlXLJNVQ+M2K5F/Q8h01WDCvhb2REGBKFITtixSZN66GGm63pjxcwaT9pX0
	xizVV9ZmWjQCMJs74eopS8a9qvxrpnYUk1marcARqKfnOWcxLyWMkBeKkrGiXIPGxUk1BVwwDLV7A
	S0oWVv1dJv6aK2udctTsoswWw3V9pIE48SpOkqhzkLyWNLgZ3IT3vewlyEx/XCFoia5hUkppggGgz
	Ai6IYHDL6xnMxWUrJqURdXVVvNZtf9YepPe2lNYXXK2tOiSDYziLUuagHZbYwId1d8UaoQugpOF2F
	Y+eRL16w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMG3-0000000FEJE-3S2I;
	Fri, 23 Aug 2024 04:50:43 +0000
Date: Thu, 22 Aug 2024 21:50:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/26] xfs: adjust parent pointer scrubber for sb-rooted
 metadata files
Message-ID: <ZsgVI4L4PduQsI-x@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085501.57482.6596528336134519104.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085501.57482.6596528336134519104.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

