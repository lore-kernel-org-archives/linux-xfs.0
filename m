Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDC14A1D;
	Wed, 19 Jun 2024 06:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777780; cv=none; b=r13r9c0S+qVRtJLl0I+RrgiFjHvE0WdzegVmRJn34suwfmM9GzndhWjrV1Gw2zzbVIKNnS+YSdomv9Ni4iiGLJ8AfdGIquiNCaqVYiMWtKUOHWOyXWf0witBuU69WR0jQbxssntty4K9wFzHNxdYlshnVZyoVQv5jL2tYjS+CuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777780; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDFNGURHbpKvdweUJFK2BKZN6aEsUxIUqWc7sIQbiGMPnsSTUl7GegPcG2e0EQ2q5yzyeyn6kxKclOtNzakfy480a5rrEOur6gkr7CWtF99P3WOgFvLs5rqFh55P7MmJab8xRw7g9z1p+RBLnt0R7iEzSh1WQSpeEzYSowLSKy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y6n7VTWi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y6n7VTWi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Y6n7VTWiG2Q1YrZNerv+g39aGJ
	dJh77RUcfBNrY3FpAOm1dDjwOxp7YV2z4ZYct3N+hJDeqiNuUqaQ+Dmd3izGyBvcVo7kO+tZ+yyMN
	Rx3ZE6o42jddJctdLr5AYCODCqIlrQlstKLKlei6fqNCMLpyhy0LJQvD2IEIKO1/oaLe11cZVsWda
	r8jo4O4xF1NZuefXjwDUl6uW1K2/rggiJOVSBpjLazQPHFYJ9SDJ6ukHAFKoKemNbXzMf5dX9tPD6
	xId4fQO6d9FzfkPK5w6xdKGVF7ryzi14yRYco6/VdfHme1J0EGI59PhU2xFe0ZrOoQZOyn3W+9Y8n
	Dy3kYB/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJocF-000000001sE-0Wv9;
	Wed, 19 Jun 2024 06:16:19 +0000
Date: Tue, 18 Jun 2024 23:16:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
	catherine.hoang@oracle.com
Subject: Re: [PATCH 07/11] xfs/306: fix formatting failures with parent
 pointers
Message-ID: <ZnJ3s5Jb8IxhCFuX@infradead.org>
References: <171867145793.793846.15869014995794244448.stgit@frogsfrogsfrogs>
 <171867145914.793846.1014062264186581717.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145914.793846.1014062264186581717.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
