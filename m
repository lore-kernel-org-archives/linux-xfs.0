Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83F315383E
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 06:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996525; cv=none; b=mPRnqdC/zvG3K/u6upVW25laAI1JAVyayTgJaL/En5Q8i+rF5J1YnEly1jEmTV5xcXuROOLPs0lrtI1eCqC4+2OpKLLX6Fju7C4DUBsXlO40mD2LKfqC1I4EKMw1YlyLCTXLh9SHR4xMOOPUVNIx53d5EiHV5eVUc2fpIc0Ja/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996525; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIuemH7znQTvPSZkbPMJNccZZNf3Q8t7TMqzsYavri/aufn+nA+r113A5q8kBY3IwPzC7sNnP21fMd48DWX1HdCUXIR3jzl6xwMdbdSCBmIdI/gPFQAvWoyR7hYpdpfwUdYLucOQlPTBFYCfajVhLw0sVDLK0CFH7mOcwca8E7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H9PERbD1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H9PERbD1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=H9PERbD1dUynCFtwQJBuLXRA2a
	6dNN8xglOZxcacaSvFRzpHnq9ETeo6RvV/07/Lhogcfizk/5zqwj3ysNn7uO0KbXnez4EVKzS3EGg
	qgSLVyFUm/H1kZY3XKN8gG3Ez8R3iJTYmiN8DaYmC2LjVe320PjJ+qVMVUEtm4JXkj07xuNQS1upO
	yd2yG1KFeEEQe74bf621zC9etQdE23ulOK15NYrzd5Fw88+Z5rWTRWx7H/So2pyibCWd+3YNLYoTk
	GGUXk8R+XaQX7r8NTAGE57buj72I1GlxLy6uJEccqUsUpkBrNB/2ltERe+RWhX3lw6G7zcArRn3BA
	fNtnblgw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tDHPn-0000000BUhm-2fh6;
	Tue, 19 Nov 2024 06:08:43 +0000
Date: Mon, 18 Nov 2024 22:08:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: fix crasher in pf_queuing_worker
Message-ID: <Zzwra2-2kqRh-KZ1@infradead.org>
References: <173197107006.920975.13789855653344370340.stgit@frogsfrogsfrogs>
 <173197107024.920975.1049694801707645008.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173197107024.920975.1049694801707645008.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

