Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E0C376E9
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 04:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724388107; cv=none; b=qAa4hevRtfazlhVmoVSPQbQSEsr/VrtQqMq5rzikG6guKOEfBpnfljA83Q8mJIVSxXjFoYxfZc8F7Paxr6HNcAgPI8lRzOBerpMn89sHABwYv+0/BICxac0vrd9HnDpIzapjwthu9Yqekb5Ihe5QExUtUffbSfibuzMNND8Zbec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724388107; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cCj7Aj+hhTJaShGjDQyyVJiaCXQPkkj28r2odZRftUjB8y9uvnTXiPNZG1A412XXXe3pjGA2Ul4SxGbWODQt8bscIKNP3ZV1c6+i7Ee08aKpa9jMQ60SrkqhwUD5miFA9TumAmq4wakr3sOTBU/iCEthtAu06gFMeggiGsxXO8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qQgECqyq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qQgECqyq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=qQgECqyqdsVATAaQQfJ3kRCVjz
	ll1Xy++eaNQftrH8lgdFS8+mPg+Lyvby2mpk464X0jkvw/wfrQ+MEXcKt3+NWSEGD+BXRtiyX/516
	JjqxF2Q6fEDaIo4qN3y/6kj3KHZF8GKhgTpzsQIUHX+b2R+wtwqmQ9kgc9BntH/DeEVtarNJW8K6j
	IWzODgLLdLXQ7IWkS1LtUobv4ldAUkA+GbHMU9MjM2+lUUJE0mhjzBd05i3HVD9CF1Wzn7tF8nVDt
	7T53q+79wCIo9shMMZdYwjNl1I2wWDPCy4r3C8W5M5YgkJCTQ1+QqArQ1y75dokTJnbW1DFpjAmj1
	nI4B6Qvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shM7N-0000000FDV2-3LFL;
	Fri, 23 Aug 2024 04:41:45 +0000
Date: Thu, 22 Aug 2024 21:41:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/26] xfs: allow bulkstat to return metadata directories
Message-ID: <ZsgTCfqemPHJcx_N@infradead.org>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085347.57482.16756596720727226680.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437085347.57482.16756596720727226680.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

