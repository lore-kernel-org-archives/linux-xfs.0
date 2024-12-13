Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A161AF0A4
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 09:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734081519; cv=none; b=mo68Qs84TZs2+kM/3nCGNLzVOv/O0Kwrecsr7DNEDI/JHlY3pvCBtCbb5E/S8igvBel2povJ+eLVhshwnoowLscRiQtvaaCHTcnSy5ShX+RG8tyvBujttL/zMu42A0/4Yt/BOa8US0t3Bvx98q766h2u5PZrX5g9460IoJg92ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734081519; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtRQC27Ieg/vsah02mu6R/ueZxT+teppPVii/pznQulaJPQHiqF5i9bemAOV0aGVRtleRcNW22x3H0C6p9pWyEcJ6QIk43O1LAkULrT34gSYfbhqHqA9fKjDFdHJcddjVWw54Va/zfnEpIzExJuddrCmGZD/IFycRjEENSImdjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wcMShCa+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wcMShCa+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wcMShCa+K+Vz5l06qKVdqETGs9
	mW+ABsu1yJnwxFs20RrF6Teu4WwBfshm+jfbyOijIs0bz3lzKWQKnHHkKzPI9ApIAKab0x62VVVLW
	F/JmltcnN3IcqtS7eQs7anwZL1taWuiaBL0LU9y52v50YraypByzvGvbODlo1TXHirRSra8hf7LWx
	Dx1IdeoqB/9gmOr228xAdf0L4cghysemu3hTUEkHbtlgOKIv4jMzVXSNb8d93B1ZZKBZhOxhuymxl
	cAxWQIo4gYXfXD3C8+lUKNJozZUXbqprmLV0BhFMunRPTOz8n2fFzSLrS0gZFUViL+EoWKUVvAzEA
	Wp0csiwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM1ok-00000003DnO-0GMe;
	Fri, 13 Dec 2024 09:18:38 +0000
Date: Fri, 13 Dec 2024 01:18:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/43] xfs: cross-reference checks with the rt refcount
 btree
Message-ID: <Z1v77k7NGOXajKG4@infradead.org>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405125064.1182620.4358632903814082823.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405125064.1182620.4358632903814082823.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

