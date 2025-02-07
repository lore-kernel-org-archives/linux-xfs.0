Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8E863D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905472; cv=none; b=t41retjWD6zTM1BOeTOQyoXTqi/akWzOk1jE0ZD6ruT8mLNUdphkywiXN3HkjbH3sv030rTPtaIWoT8e17mLAl8z47Yt274FV5H6ce3L4r6vWqZB9TzT22xUkRtUc5AzrBCil25Mz3ajuJ/B8qlbS8M6RbBMt6gh9aBFYr44Bmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905472; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aQnlZkgcYQMdpT1HJ/fyjna595dumHOj4AUdpy/vSIfhUY6FH9m3TeUuQLdOIKkWzKkEZivXr3wFVluX5OcEkDuMe+lXa5Ix7S5/M5P83a7fmpg5nK/ZX9WRqhm7m/BHR0SkjfShzaMA6D1rCk/oZREm9OhsLvAiqJjNLDHM4EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k3SOjTzc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k3SOjTzc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=k3SOjTzczFYh9f+j3Fp/dAn62H
	uOYCc1LDp6dDaKWx/n4opingaYobMCRNGPvOpXmFbUKlB61erQFhnN/E53lNykIWN4y1uOJ51nvqb
	nCLR8rrUNWvK5xF27Jrtih7YFpFnJPOV/A1i1IkcCTvxzp64r4q4PWmqkvUl1PiCmNPsnO7XqW6/E
	u/ORHXDrOKoN1a7YQWUrYUUQ0MNqP9wTG3Sbh8m6ckTLAH70FYYtS4lRUaodupI+cKtelFnvw1C34
	il1+VzVN/6IyWAJBLi35C3heOckgMHHPPBGCEFKHR6AQGBYuBdL6u9WhMcTgovgO9+NbQwRLV7SZy
	rfwR4vXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGkQ-00000008M8s-2S8H;
	Fri, 07 Feb 2025 05:17:50 +0000
Date: Thu, 6 Feb 2025 21:17:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/27] xfs_db: copy the realtime rmap btree
Message-ID: <Z6WXfq-xCl4VmeNL@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088234.2741033.11666132944549575171.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088234.2741033.11666132944549575171.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

