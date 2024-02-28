Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BA015E5A8
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709142102; cv=none; b=cOcjMskz+n1A6YOQ5jGt5bNLd3AVIY4oPyiH6b3ImGodqbPNcPCnn966BPhiRu+EU3vvFrYAGOMbq7j6BDwC+WFCctaHNSN6Ecclbe6Fe5Oc+RsmLPs1K8d/vW+QEub4EM+BqNwyXshxEKEPBqPW0y4JTO5SzN4JOFBdSjEZny4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709142102; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBxWde3g1a7VJc8TG/bIeqObSMjWbNKdLasPMjbjQtR1DDjzVvd4sXsQpBi5GRkrFvssdTWE+r72slxQZeD8wKLqJMd1G3eDzrzZ6anG1xX5QtkTtiFi1nP/xH1o5F/0hh/Hu07vSr5357Ut0hiNtJ+o+f9OZMhS8FdhaTg68JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D75CV/37; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D75CV/37"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=D75CV/37D4J5ucb0WSegSg3iR/
	2+UjjS24GKu7djHZKiEKZ6lAylXgi1TAcv6fBpdKISlhkJF2SqDDhkBJ3p1ECYn1P/FkTgvFjXp9N
	kFPwWJ3kDiNGA4frsUmeBgw0lZVV/KETCPzVRf1heZWWPTcJUzKBTmb+au/2EkIx9cRF8ibjL/K3r
	80kZwCu8UxtneLuvmDyPlajbAtXYS3XxTx6FMe+Kjd5GmoqGMkhS+ic7aTHBYIIIxzx4uf2xtEHYS
	9NQkwMrOc4yVjQ7ooLF3CgomK66/JEcEJIian3BFHj0YyAS568IZ3uFABbuIdRn3ARpGSc5Xrt6hE
	Hf/dsLtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfNw4-0000000AKl1-3Yb1;
	Wed, 28 Feb 2024 17:41:40 +0000
Date: Wed, 28 Feb 2024 09:41:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] xfs: repair AGI unlinked inode bucket lists
Message-ID: <Zd9wVGUJCo70KKyf@infradead.org>
References: <170900015625.939876.13962340231526041298.stgit@frogsfrogsfrogs>
 <170900015681.939876.818149743308450270.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900015681.939876.818149743308450270.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
