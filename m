Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CE53FBA5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389245; cv=none; b=o0cnnKq7jjhbV8J4VGZM+uehKoQwgHS2uglBR/SswsRcMKPOzzAvMi9bygrSYiuSZjZo6V7AAdgzCZ9Pz9pEHxPs0KVY1NLpVFLX3RuEXrS7vP4EEspDqfRniVxXOYsXVx8uTWoKtX6OZhb/mvPWLtuP9plXUU/d1coVkou7h5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389245; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nNwHh0m7EIWlJnWLQ25Dn3U+5VEHUKQlK6gFDJJlJ/0UPtPMtzN7t4qqjNNyfwlCKHRl14Ysp1Ouul6jsLTLNE2mvewX1zMtr9Qh6/Zxtzpif/EVNMSvI4xwITrE3qS3P+nYARk+LyhUAEKNtXnVFsD+KF5MIiV30dClGq3skOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D/nb3HzX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D/nb3HzX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D/nb3HzX/1Ot+wkgPn6xePiZ9T
	ggIkEAme8q7vlNP5o8F3RTdH4baXQT50sz/MJpllCYXKziNF1A5b8kMadGMU2RrS9rcj+VntP9hII
	fEi1ZLWp66fSKMoBVy1hOL7TjEs1C9DKbIjPz/ET4CxTs0+llSQ6h97AO825Ex/FfafTUlUMOnQPh
	d5zvuGNSfKnve/zMIl6T86QprhE1Je7p/Tfj2mAyhIyy0nN5XiU1A6GGqaZH7or8nDdJXyj/90v9o
	8efHvfn+bVtYOBbdJoM53n56t9pY+eUirRjdg3bF2IFSnOx9iSmGuCGjce8KvGc2Q3o7/Q1kbrW+F
	uhvLm/Kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMPj-0000000FFDk-2VW8;
	Fri, 23 Aug 2024 05:00:43 +0000
Date: Thu, 22 Aug 2024 22:00:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/24] xfs: add xchk_setup_nothing and xchk_nothing
 helpers
Message-ID: <ZsgXezoBTvirC4nQ@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087346.59588.5144524048217225071.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087346.59588.5144524048217225071.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

