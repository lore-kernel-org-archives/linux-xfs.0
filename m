Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A611B12C7F9
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718944719; cv=none; b=BrinVygGTlI3TYWMxdRxb0u3Y/SrmF1Dkh0WhwT67MLSWLpV8Kbmzktw033mhw468BXA11mywzXyXaFFmSIbtg4/pf5ClrCCqipvmpem2yOCs43EzcXNWRP5tUMm52K8EtkrQqOwqH6K33alVSjjl7nnQY8xCYetL03iGSqB7ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718944719; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xf4Gvh/fJAxUE+pLGzoIvEbhLPmwpL/v13j9yasoT7I2mNff44mXp0enwj3TWrFrJ0rrJUdStCUhQ1CMHrFvMd420gf1BF9XaOznpUuutd2EPCVSSyvJMGDUpgF9dsSUuvAP9pOOI8lLB237tBpPx5fOhprZFzPURVdeHxYSlhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Im8+UlKQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Im8+UlKQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Im8+UlKQ0GihFBMLH+3QSSqfoT
	OR0r6kGGzqvhzjFRdv7RCpF0bpUiZPw0Jb/P1t4+ffQ6/PlA9gKb1svjyLqFT9h9QBHkLk6Otq2Qf
	Bu2OkvIuNl/5WhXTe6n/0PCv93e1WLjvF5fCTAxz+87bYPKoNc0QkHcmnyShIMjj5Ac+1jw5ktwg3
	D/vxyaJYUOnnxmVl2OlkN23XUz73HegFiiCi5eel1nGo5DF0faJQ4gXeme+CPfBycuTfAWn3hz3lH
	wUGyqPxufml6L7YKh0UbuOkXnxI5+wZmaiZ/eYd6gNpPrIVVUJ9TqGIoPAp+ZIi7TwkpKfwKGxIW5
	XaelOOJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW2o-00000007fHs-1DDV;
	Fri, 21 Jun 2024 04:38:38 +0000
Date: Thu, 20 Jun 2024 21:38:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/24] xfs: hoist project id get/set functions to libxfs
Message-ID: <ZnUDzgLO62eBuwP9@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892417981.3183075.2780737496009319760.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892417981.3183075.2780737496009319760.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

