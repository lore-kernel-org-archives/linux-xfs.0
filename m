Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2149E12E4A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 04:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713243396; cv=none; b=DaZ2a+zzMOpJc6gw7yaDkMpBhMegMNAjNIZPHOAOw2DMQZk8h5Y+FNwQIaZ02XtDVcMpN7ntn44rM2323W0j3UXP9si0vs8SIoB37x5VWAgQWmf19MBuM+mTfU652ekb2oeZVdk3oTkoz/yAa4ubDWYY6vpG/ZUBFOZsJN7iooM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713243396; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WHdet9C2PnzvmYZ0lvHYqZWgGSGgYto6GLt/egTgSChDC6x2ENY9Yh7n+Ur745xte2mw+7CvVUBBdswjqzA8RtfkKLBm8VF/R3a+0fyS4E2Rq54GL6EtXrK0Maj1u3dR3xzCGtNMSkQ/tIObiiqyjyCmsLX6PTQfWjF4t4RPRHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A6ZM6F40; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A6ZM6F40"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=A6ZM6F40coCHYwYSMv86iI3ZKN
	5BMqCss0qQLNGFP+5xKalJU+kZYCq5Unw7Q9AF9oJD9SXH1jyi3fokR5o2PnH0UFY4Ov8he4qWVNf
	+RjfYycj+cKulcuAQD//F/R+v1UtE+UWcvLXL4XKfSHWpPJUP9cetrLVFL3MopS2TKro+u3ILYqO6
	UDn7N2kDtNwJYKb0D00Zet2o/B9WAR96vx3KjiTkUpcS7qCYBHbk0o94TtjG9pFgKqS3voW3mHEjw
	lNO9PHCXM/qZbJmFgArf0TnGmQ6mKZXZir0RHD1nyi0EGYk9LosutTY89BSvY46bCu+oZGrwF5aYl
	zRj9MRvA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwary-0000000AsFe-3CyS;
	Tue, 16 Apr 2024 04:56:34 +0000
Date: Mon, 15 Apr 2024 21:56:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, cmaiolino@redhat.com, linux-xfs@vger.kernel.org,
	hch@infradead.org
Subject: Re: [PATCH 1/1] xfs_repair: check num before bplist[num]
Message-ID: <Zh4FAqPBwuKKdkw9@infradead.org>
References: <171322884439.214909.5121967705551682559.stgit@frogsfrogsfrogs>
 <171322884453.214909.10319162748738486901.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171322884453.214909.10319162748738486901.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

