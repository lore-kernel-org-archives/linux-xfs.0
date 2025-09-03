Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EB92D7398;
	Wed,  3 Sep 2025 06:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756879452; cv=none; b=e2GlixjbJwKCvdChADPAeQQAAinfQCj0T01Goi5bTxAHNKSoi/bC3zlMqjqZBaAlHR6ycU56sNiwGy4xZJlAmmdKNLMli8KrM9AuUJwDpi7rXV0to0sCmCeOc3NsqmJGIkCtqIbdCVKbuXd7/Lo6qzPL1yGWrkUuW7CLJDvXDBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756879452; c=relaxed/simple;
	bh=IRo7a+nxcjuvrsKtxlNoqN9R/9Jaa9ywStnefdyYtEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PmhUO7U+ztpRUvjhfMnADF07YsBF0OC29cTUdlNo25Aoo4G+5l9wTYnt+4LDzhIdxS5bhdhq1aMFxZjrjE5ewXBOJry3T/Qh2ynmOBbYORyN/kDWv2lld7Jc6mQG0W55CEiSJ62CyaJ96nGIMLLr3N/fo0JNHGag3mxcfsieohg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0IhduU68; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0IhduU68"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IRo7a+nxcjuvrsKtxlNoqN9R/9Jaa9ywStnefdyYtEo=; b=0IhduU68+VwEZSkpU29K9RJcPF
	gg/3ZnneuJOuEctugEC+hrdr9Oiql/voPkBLXaRasIoOiRL3U0i71G/+ApmqbrEoOFO5GqHr4iGV9
	TDGuMthvfvn4E9WyJBYocyd9r4PzKgMoX5INDcl13KCQQbq+EJQav2hmBqXG2SebOLWJj6heVoXnE
	nq3cCIOR/JyjNOB6EZTFD4gptzv5MJfZS1gI38ipoJiC9F5UgfFXqeDHodA1icKw0vsX34g+zir/m
	0XAQjYttmMY3IWrWVlPWDvC2ofYtJ4VOZtKcQhNamXNtviDxCLiF7LS6dGAh8LFKXjFeqB7Y01F5o
	Ji6Cl1Ew==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1utgbK-00000004Rjf-01kI;
	Wed, 03 Sep 2025 06:04:10 +0000
Date: Tue, 2 Sep 2025 23:04:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: syzbot <syzbot+ab02e4744b96de7d3499@syzkaller.appspotmail.com>
Cc: cem@kernel.org, hch@infradead.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [xfs?] WARNING in xfs_trans_alloc
Message-ID: <aLfaWUYaqDk1d85i@infradead.org>
References: <68a28720.050a0220.e29e5.0080.GAE@google.com>
 <68b33cf4.a00a0220.1337b0.0025.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68b33cf4.a00a0220.1337b0.0025.GAE@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

#syz test v6.17-rc4

