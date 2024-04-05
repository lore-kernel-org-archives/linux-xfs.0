Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218FA21345
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 05:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712294276; cv=none; b=MuErVermW5QGLFCZoX4YwWUYEWXDN/tqHIyKrFM4irTqtHWVemhW627N4S0cJObm1Dj+WoNhEaX6N6KC0Mk3qn90xmERpZycv8VCu+MJmucYkNt8Uikn5uReKNdMLYiRvE+rFFVI9zis43fs7g5U7FxZjf3DjdUdb4JkIAg8oN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712294276; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nhI0UDgtu8gOTL5QDJw8lVheRJk/+LZ157RUcxdry53LP8zdI4rFxK/GZ/dIVJbyrxs9jwvQ2uB6YnLSxQPQzLsZvdbbbpSa8eyXW4SsusdsHquLcnBkGQz45vG2L1ThRVNPTuqZs2IlJE1q7nEem3BmtoSH6pfW9op/hVFSweA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dHNbHxcM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dHNbHxcM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=dHNbHxcM1/pIu05nwmN4CIM8Vz
	5VshTFGNxPYS89sT565MUXVy7EG8PkNBrbXHW3e9Yj+9Q5k2GMJHo3hFF4m83NteSzxe+msudAo90
	rTZl7tqBNNIwXuZOu8znOl3wy3CZOaXVAKtjWUgP9871u0JmtmM3RTDQBxMOzGTJQRAB+gPWrVaME
	3IMQTuzHMOaXK01Eoz5wPfYQ6CHlxj7WixG7Ov1O/a8KsbhxZyZC8dEvh2n7iFEkXL4enUwsYNMZR
	YS7V11fy5nUyTmn0E4UZOyfXSLWsMCTz3+Qbi4ATEmrQ4tMpU500xvtjQX6yI9EFBKyV0HGSxNKS8
	bVFOVYhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rsbxT-00000005H34-355n;
	Fri, 05 Apr 2024 05:17:47 +0000
Date: Thu, 4 Apr 2024 22:17:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/3] xfs: fix error bailout in xrep_abt_build_new_trees
Message-ID: <Zg-JexretjmgvTaE@infradead.org>
References: <171150379369.3216268.2525451022899750269.stgit@frogsfrogsfrogs>
 <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
 <20240405032716.GX6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240405032716.GX6390@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
