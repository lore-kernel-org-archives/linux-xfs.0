Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A830EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945161; cv=none; b=i6wrpTF01ul2zZodYMLieKIR/HGOEQgPXuVQiGmjIeHhkavZp20shI9mJrWT6tmOvLT01x3wlbJ6fa1hRnKtEQe1CuQVea9+TH4jt4JDZEssxENunp8K8o0iDO1QboxgT/qoUmNMkrOsBl6hPqOIFqjgP+sEhmKptSJysKKJKNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945161; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8rkzhJ6Dp0QbBYDiwUmY0uBvAzGe0cgLodutBTCFvqaox2h2nQaa20A31IXqz8lg4nHvQIbLFmeyDDSo9HiDBB47PRZB7t2J36BDxjifHj5ZkJ7cviI5f+fxR8Wm/NhQPUmmS/N2gltke9LPJmCtOALYWL8kes085aeqoa+ApE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3FePgtOB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3FePgtOB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3FePgtOBP0b3q17ihi9aYXhkal
	XHEtNr4+pB0OGD3RxOVAsZuRnf2Fyo6RpJ4GRTV8vSNNwcBrq+2d0ahg5tQXWEgcNCzmmVixUupqm
	YTTSOoqGN3E78cEGxrSdHEndeZn7NcXKoLlFk7nv3nmDJI0ZhOnVVjTbFedlF2iOJRXJ2qhtV4OOv
	DuHnqu4Rw9d5nJDtWmjmYIIbfdPDG3nxbpcFvvNcIUR9KkX9wXYYXjXm3OT/LRH0omcAdY3GBpbNz
	pa+hAhk2ojL85Rm9d9rphFDIQPhceNfr5RzXy7e1VyUBxC3FbM9FzX6pk35Ve844uUDEeItTUq1fn
	6YOfTigA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKW9v-00000007g0b-3Mvo;
	Fri, 21 Jun 2024 04:45:59 +0000
Date: Thu, 20 Jun 2024 21:45:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/24] xfs: get rid of trivial rename helpers
Message-ID: <ZnUFh9coaTJ60aGN@infradead.org>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
 <171892418295.3183075.6650817239063763087.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892418295.3183075.6650817239063763087.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
