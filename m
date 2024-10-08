Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4812B9BB
	for <linux-xfs@vger.kernel.org>; Tue,  8 Oct 2024 04:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728362099; cv=none; b=J+rs4mqMKyrrYWC2bknP7FYvK9RQW3zNWQ0OcTHphGIPd9R+DOuGNo4wqoFSCjvdgYTRuMbFl5izpMqTu+pl9b00gyHnQURkkXBogeK+IzQDr5TKvzWBpJGIq9LQhs1MH+PTa9K8VuMJJpyhxG9Lmbt7lsj3/0FRxlWJHP1rUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728362099; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W8SZlZQBc3uTzqK7eejm3vF/QpeMyXL4XeqPh6rmm3gztEhQEalHczrRzZssLYk6EKelXOdAPqFFaHbANaaXqUE7KdbnJ4wtGrnnVZFPIBURA/HZ+W7NxOBkPilO7FQl8p/jxjG/cyNrY2kJEkGOJITZnLLzPEO4gzv2SNWAoXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c2larVqN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c2larVqN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=c2larVqNG0eh5co7Kmj0FJYFq0
	2PWbkdX7yqBOiP314cQGA2qQQe4OwsWYNN6wRHVsvddywT8Glmsu4vWyel8gVa4rt550vWfJnp+uz
	tmX9JmhR7skDsiKC5NjmGdLzCDbwHtnGd+1o03Y+7ilk/7eP1pwkEcyDyhMCOsIVXfJwWzw4nPR+Y
	WueBJyewp4+js0mMREvRnHeJ3Osc2/dcKGkOE5WH9oYZj4rWSL4eyD5F3/3Pb7njepvnN3qMJQC45
	agqppqhqjY/VedszCxLzC3+Px9GPfZ19X+wvn40gIh1wvTvq+BXZWT3TDdA0mFg6Hj6o4WnqJpPQN
	pIgFgo0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sy1w1-00000004Uuc-1IyO;
	Tue, 08 Oct 2024 04:34:57 +0000
Date: Mon, 7 Oct 2024 21:34:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: Re: [PATCH v4 1/2] xfsprogs: fix permissions on files installed by
 libtoolize
Message-ID: <ZwS2cTOSp3JbM6Nx@infradead.org>
References: <20241004115704.2105777-1-aalbersh@redhat.com>
 <20241004115704.2105777-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004115704.2105777-2-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

