Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F39E84D0D
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 05:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711432699; cv=none; b=YtG5UsIv3I3WRaPc84djUKyhY0+w8dfDvbUYT9aemx5DwUgny8E/GOWKf66gN481BroN8tnCfcYDmTxUuwhUSuZAt/8k+4SwID0lFoVGpjsIJGTWZPKQHlX6hGDHtMtckbl8kuiUQKWsuCTp98ywK78Vl7NiUgFVAYxJ1s3izzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711432699; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nV6bAKb7X/vNqKb2IkrxVBejwK+EoFZ6ZjqoluA5tnChVeU0gg3Canfed3rpkifxfnabSJmYgrQ1ocUg9wfcE5KVSrNSgHJVObXEd2vsrhL4OgI5ECEZrf1xcVBcRePj0nbDIwhPaClJU6dZE0d6id3T4kG+cAZpchgj7GKCzn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=shtO/k8l; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="shtO/k8l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=shtO/k8lBXv5uueXzDJcpDJmt/
	0uUakZ1x9zcx6AGytnvtf5cUo09CjcdQ1jxQjsd438Jg79j26fRZ242J4ako4oyQTDTHLTNFHUZqn
	TN/dadP1pCcEOYycAKYapWgciF5o4A96lE/3q7dNLVz+D12vZtLilqzJCrpCjhG7FPjr6lTJgChAG
	YlMzM4TT7Cmp48xUifdhSbzhfg+FJr6+1rC0uNPfTAsgfLqdpLAxokiBjSt+ygBAVRl9bokmt7QeU
	VSvZ2Rx+nPkMuLQKKrHc0sWKiQl4ddYQ7e//15Ua5oH0XKXUt5wUqR1Yh78Z4Vwp9fDuh7GPMEocZ
	QkXRFNCg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rozpB-00000003ClK-38cg;
	Tue, 26 Mar 2024 05:58:17 +0000
Date: Mon, 25 Mar 2024 22:58:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_repair: create refcount bag
Message-ID: <ZgJj-ZtnxtjuN4kP@infradead.org>
References: <171142135076.2220204.9878243275175160383.stgit@frogsfrogsfrogs>
 <171142135109.2220204.3997484486890202762.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171142135109.2220204.3997484486890202762.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
