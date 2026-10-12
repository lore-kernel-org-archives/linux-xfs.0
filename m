Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB489377AB1
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 13:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811143; cv=none; b=gBNmd309IVbxZV52p2u1IJHJeRsNAoOii1xnPFAuchdsWuvyjWdVEdp67h9AGzYAEUQ6Pr9MmfGjispCO2cWHstqueiFt+Al3Q6CmHh5ImJsHPrNKsESTbqOE9IWFbvVKYPbBBAs3cJL4aJmiyP7QuTdZvuks5iod+fxu3WFyBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811143; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8MNzQjte3oaESVaL0BAHEakrEHkKHskx7OTj0/fEoBJ981KNXJ100W9c7FIjFWjnG0egoa9k2Nci5/G5yO0oB34gvwFRi0hM2srb6m2pWF0Vt7nAStp0AUNNOs3sszJeUJO1oIbCC5yg2k/3z/9j+8YW2YIQP3sHyfTRqfTZw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xjyV/RMf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xjyV/RMf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xjyV/RMf5p8znirbU/tUX3TViP
	/nfYmBGZATrltIP+cM3yI157tRi20e+NwJCkE3WUW9kNRBT8nLtMxQAMEi/VxUCbMHtnp2DvpMtv8
	Z6m+8ufOw8VUhDG0ST7/QRZHx9pqn+dRgyp7Be0aVL2fZzQJWPkycYhDhgr+kWPexRuszUgvvl++O
	i9hw/KV72b1kI9iK1TrgT65fu3miqmxqOtnJNAHAtg5Q3HxEALfP1h9UjKz74a7GC+8RugU+2wZ3T
	AqwYW3ePXFA31tt12PmEUAUSph++uYql20o+6xi5SaEJ0SPGo//cnesJSQbsUXGuyWSiNKdjdxXak
	3EPkfqQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFvi-0000000AXxr-1Ciw;
	Mon, 12 Oct 2026 13:19:02 +0000
Date: Mon, 12 Oct 2026 06:19:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: drop unnecessary sr parameter from
 xrep_rtgroup init functions
Message-ID: <aszeRjMcqYEZatz8@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065991.1058822.9052075441979843165.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065991.1058822.9052075441979843165.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

