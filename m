Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8338A422E2E;
	Wed, 19 Aug 2026 08:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787129936; cv=none; b=g3I+SXRZ0Jo1lwTUOYdNmFYuK1o43zqFWOdyu9msscvwZbLMJO8HY19Y327EtJV141B+U9PMUMPcBTqUMTr1vp382xX5fiIvQaD3odJk6lPV0cQX5AXY+oEuKqssalpNlYckBLqvclblI8Bx1EnrJdW+ttNd1Zwi9SIHCbv3894=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787129936; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bo0CkpSYO4yMwGVh0kjRWUeGX3R1RfEN6qVRBW7P2+fRf89sMfELwNJkyXeD03ZSczfM5vYx0S7/w5j3aYDj2KVTVLBTtd82MAc3zWzH5JVeV0spo6SjZmNd8w34pQ4Zl7bTQEA8co+0YOvsz8/Gv+E246gsUJ8nM8mtLyeJtYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vAe4tlmr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vAe4tlmr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=vAe4tlmr2Osn9g1GM3o0hnz+pl
	YSs8mZOzxZaSeY35i3XvdjlOHnObUfMnSFviE9ct8sB7wPRJObFQNPsfHjUML8BY3pv5nbysNIpvK
	fETFpOBnb+NJ40EXqslcYzv/YBkD+pxuX2rqtqLuKJ1B93QrZkLmzp6k9M3bPHDZ1lS+Oxh3g9rNo
	fccvKIdBvhOrEh5BgKIdj8mQx8jKpIJb/LWHCNCR+6xuKpoZxGWhw7eeSoORTOoLJzkT4z0NVL9/8
	A852aukJ5fcIM1zhKs8bIeuF+9cRbnkBMQvI3DJPbT4P4kX1yBtzqdXM/FlJQ6nmRpvx6lpc5eQlC
	mxu70YAw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwc8B-00000009MHl-31Ge;
	Wed, 19 Aug 2026 08:58:43 +0000
Date: Wed, 19 Aug 2026 01:58:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	gost.dev@samsung.com, linux-xfs@vger.kernel.org,
	pankaj.raghav@linux.dev, ojaswin@linux.ibm.com
Subject: Re: [PATCH] iomap: remove the unused ifs parameter from
 ifs_find_dirty_range
Message-ID: <aoVwQ1d73alZEwx5@infradead.org>
References: <20260819084858.778285-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819084858.778285-1-p.raghav@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

