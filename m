Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD82226182
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733811530; cv=none; b=WaR7uyB/pC09ucS2nJTLbGFaEYiMbjzx0ngdYUAROpYXajTpKP6FKAyK82JFBkEMcEbH7rbSMkvv445QIwRn1FqMpcuP41TyXuQiItfrG8XQoeIBRD3d2hnFNBAu87YeCfLxedddzMtFPouf/n7uNUMD6Sc/90s3sXHz0UwSbcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733811530; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxvgVMS4NsLPZfpAEfVepYA671w3Ie5m9s/AptP12gd2ckDGzvOsGmUhbTz/K43D0K9bDwvXCcC3rKDBZ5X6x5Ad1oAAl+S/JykIp6xzT1m1xE5qELPuy81rXbk5pCbmWmkL8KqcbpOms3hI5qMxkE4flTlBJt4HflnFo0GFCpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CoLkmx53; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CoLkmx53"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CoLkmx5305/uzNaJNjGqWzrisf
	9jxGRUvo7zDFArNIKzhVq2CtSNPY9w5Z1S0ol3v4S+9RvNqYYxTn/1iHCqN32H3oPpbYBBcArk/we
	dCdecJp///QzK3+9v9qQPZ4fmFMQxtNm4fMBUSpajErQYhZH25g53I7H+cwvCGmugqaC0Nmu9a4Sm
	mACW0RCR+79T9Wav9EnMsQXJ6zclcNAF0dYVYjid8/lB8KvFhPnFw/vFjab+9xXUOnD/2Oy9TmvOg
	9CEHAcxtlUlwNv7jthl8CJfxGVLa2x1DGloiBFbwDrS6+a8SWAx4JcgqdokbPddkweqQz9usHb/DJ
	p99+q5hA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKta4-0000000AOZy-3BNG;
	Tue, 10 Dec 2024 06:18:48 +0000
Date: Mon, 9 Dec 2024 22:18:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] mkfs: enable rt quota options
Message-ID: <Z1fdSEerXHa6zOI0@infradead.org>
References: <173352753955.129972.8619019803110503641.stgit@frogsfrogsfrogs>
 <173352753987.129972.1053967457172318865.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352753987.129972.1053967457172318865.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

