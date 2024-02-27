Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1A114AD1E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057915; cv=none; b=SUs+P2sdqJQF974VpVkxSlZiAi5UcaB6Ym7yrPruy2mh0QQdRIQeqAKslLnSA8+S4AzFbDbeYf4sp98fy1a78VyqDjDfQLw723+P31ROZWUCH/T72wkLJuf/nRdBbeuaDpZw4YAEA4rhiuGzwYMyGR9rv8ZFdvAKBs17WaMI5CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057915; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mBMbWfQCAJY8fFdWtaA0KKcNKJRLcgxXMyK9KRdMJifq4D50LSutpPw0/gSOAQ141RPp3Z6exhjHArZxv5rkxSOpvKQg0BPdxz8AEZN3E1sr9oJUsHwkpTiEULtxERKPF76A5Dzos+R5KQrxlNqRs/XY34CUGrBi24wxzl+xFzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=clqnEPmX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="clqnEPmX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=clqnEPmXU7aldJVXv13I6xkkz2
	rHXOzGyCwpFLP/4XCET7yoPBC1fQCyrELGD1mrw0Fq/S6GefKgHdCMZ3Ps2c2NYtvP7EK7Qc1EPG4
	7L6fWBXQZZlgJvAtWUIdvf1/aa3d8B5c+Imedg3DvAkwylIIigCzVAZD1bRFc3/6jj9gkzK7WIz9X
	zo+D6wHgxqHWjg3Ipu4W7Dgr7gjvl7A3IT+vNB9BmH5v4LJUBlpCfmqPA3QGRIICyDsJX6jIWFzNd
	O3cN4bb56gV2qEuLYMfDV+mqYSFWhO7q3eUo92WtqaA24f6jMgry73jPmXPA+bxBc7kU2ECpnY7Ys
	bfaRWRXw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rf22D-00000006PY6-2J8G;
	Tue, 27 Feb 2024 18:18:33 +0000
Date: Tue, 27 Feb 2024 10:18:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: teach the tempfile to set up atomic file
 content exchanges
Message-ID: <Zd4neSJLfwrXXhve@infradead.org>
References: <170900012647.938812.317435406248625314.stgit@frogsfrogsfrogs>
 <170900012687.938812.17754155412825394260.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900012687.938812.17754155412825394260.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

