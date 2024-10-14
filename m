Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4B15852E
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 08:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728894515; cv=none; b=lDGyC5RXczAu+f6q6mmne4m0P6UOoQPrp9Pby+Ai0H/uu5XyeLY3HMtDOZjPwM9ouVK76ZgtV2OeJzpmvrk0H22lVEuZb4FZPQ4KllFDGFDx9DVEIblU6ilqkov4kQ1GTdakF/HYCyQ3n8eUn9SigEnNXIW6MlXexXUvGDot3cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728894515; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMBmjHbrkQZ765pHCLxd0cyLR4+TgqoOAmN9WlMgLw6byjf8qN3A96MH6hNtcu9YMJBDmOpYjx4JkDCDNykZx5X2bdUMopIbo9xIdd9wFPfBaRWa9mQGrmwGGkvbOc+TydnqDrtPB2TyeHu2dDA78qifgckga8uTWCVi1QGvPU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XxjQg++7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XxjQg++7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XxjQg++7br/Ba8O5SluC/GWUBU
	ZtGmFJJSJQBKiJEnWe+7mwJPv9VDkmuA2ohzlYWub5JGu1lNj9+2sAme5sMIcMXTAbrx7yehvqtfp
	x4LmzQkNP4SZkXQYAH5tzjcDcw5kpwdMZfACi5liAzUfjuiCXZDEyAf7wPMuhl0X9JH3Znf6BUPyA
	spiFkJMYwDhkYUeTxePQuF6M1dALL1H1BEukFjpeHjyzqvnpH1wr3emP5WQQolMdgZeVUWsABBbFK
	NJM7VsC6lcnWwhj7sJCjolhfGFV3tnxdVSnCLK6Y7xlFnanu8J/ivGRlADTsUarYQ9E1Ae1f5Hkyc
	99GkW+4A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0GRN-00000004Hfv-2nt8;
	Mon, 14 Oct 2024 08:28:33 +0000
Date: Mon, 14 Oct 2024 01:28:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 5/6] xfs: reserve quota for realtime files correctly
Message-ID: <ZwzWMSohessbl054@infradead.org>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
 <172860645763.4180109.14022183245293865679.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860645763.4180109.14022183245293865679.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
