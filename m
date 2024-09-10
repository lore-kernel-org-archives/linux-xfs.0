Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6820D18594B
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 08:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725955651; cv=none; b=nc6CuRp3xQzSgnT9NjJwalsrH8wKnSSkK6mK0jjO5aDQwiaXAsdYDu274VhPePAKZRHzTKOgoJ0nSvmYkjvBFD6aWf9NClcv1yLx3WC8PRF7wSKzqSfAUpiDzfjwxnaDCJx17h+/kApVmS9VXNzkgKduiI1I50/qdGz9jJ5Z49A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725955651; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R+r2aX1H61nqWR+krMPo9IdsViNFbo/sXegXcjeRVFe+amsMXcnL0bxMflrnlenfEe5dF50cAXoM26dsAlMzacAYiOveAAMaHr6vnFMBnv323O5SiadOZRwyDz68WqkvK1OTyu33ice9q9B791nFsQQ3/1gpFM4Ep92hQeQQXVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LcJrDsmY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LcJrDsmY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=LcJrDsmYLJB4F9r4o2jlCXpDQq
	eWfwh00fm31LlK9tWsX4DOoqaWonI0m1Py/lLpNnDpSlhOEpaHJjPxJYDU00bo7OlcLn54Up1DlxC
	GxkywxERvZOQzbqJdmZ+QeLUk1Bk9JDyb3Fe/3VSh4W0AuOkAFlnlXG3XWstNsJ6WMdlORXNV9SPQ
	5BoDiPHpD5yQ452sSI8kHP+be8UrI5c71Jl56TWJhg4UxTL2ePYlAfkOFibhWMfiQkH6jOXLj+NN3
	CaWD5R1HeRDYxp6R2tD32ZMHfxM3CVpefvpRUj2YrpRLQwNMoq7nsi8s3weNs1l475juPDsAB3wsF
	4YhpPdQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snvuL-00000004jkr-2pRM;
	Tue, 10 Sep 2024 08:07:29 +0000
Date: Tue, 10 Sep 2024 01:07:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Zhang Zekun <zhangzekun11@huawei.com>
Cc: chandan.babu@oracle.com, djwong@kernel.org, linux-xfs@vger.kernel.org,
	chenjun102@huawei.com
Subject: Re: [PATCH] xfs: Remove empty declartion in header file
Message-ID: <Zt_-QWDXnCHQYhot@infradead.org>
References: <20240906060243.4502-1-zhangzekun11@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906060243.4502-1-zhangzekun11@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

