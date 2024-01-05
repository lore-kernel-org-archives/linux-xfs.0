Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A30524B
	for <linux-xfs@vger.kernel.org>; Fri,  5 Jan 2024 05:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="obLkAf0v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=obLkAf0vnpmn/lvbNkgQDCyOIK
	NBcaHUZNUkb8kMzdtDBKokzMl/IlfqhbrDDWFfaZUuXqaGspiZ/lrZWfCGIzzxuq0Bmezj+0koQTe
	w5QgJ2KzDHHkUuGVgB1HAEYdKq9jBYvYbWh8KdjAb138rTwg1IRNB4fzpbUf+408NHfVCj3J8hrI6
	fv5ySuYalTdSVa0v71GaNDdw3lnwOugiM3vOzRGa4YczBlF9O86yq9cA7e4PPn7dxQwPH2w/JB5ss
	fBbOHRozevhC4wnC0zwsUHO/jiPs/m3UGAosFxgstWTGOvpZEnSKk6s31TWV6jQkkE/FRFefxJN7d
	eR44kt6w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLcL7-00Fwlo-34;
	Fri, 05 Jan 2024 05:01:49 +0000
Date: Thu, 4 Jan 2024 21:01:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs_scrub: use repair_item to direct repair
 activities
Message-ID: <ZZeNPUV6kyK/sDB4@infradead.org>
References: <170404999439.1797790.8016278650267736019.stgit@frogsfrogsfrogs>
 <170404999472.1797790.14608691085754775710.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404999472.1797790.14608691085754775710.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
