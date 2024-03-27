Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABCC54FB2
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537925; cv=none; b=USe3QX/BTKZkawftTTfwniy9bvrhn+gZMBBeIwzLfdCKKCRNCNdFMDhoBRf0dl1oVxChbQ8Zb/nG7gKngUt+TQfTdRD40lXgLWwULMWVjnmieP/+E3lVRwm6mcP3F9APa4AET0KCt1N/3AaKuOzYAosQSASairlZnmJF4ewD0BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537925; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m3vgknuMrcRpzZVAiKbfDkhBFqe7BAw5nL+0bIqcWfiP9rdZPeSuzvave30n+FXQKLsvCfbWdaAHPB8p/GgJXOaencSNqWJFxLXNsts608wDr8a8DuMBsliMVySvc1e/qqGSNi8oIC3ZjbjCZbOhCzp3i9mHVf0byv2Bn8YkfB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EfFYScEx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EfFYScEx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=EfFYScExveBvfMo3isOXS4Dqch
	8aj4KZPk4B0NPPcZTxpsobuMvar0QmOXJ6LkQtav9V+EXmXsk9mB2U0nmvxG4bLNKoZ982b12z+PN
	A9pWbVmr+W7IAhve+Htt8pSRxaxZJCJRi0rHZIIbUNbqTg9dUdOHcmF7H5WwWJH7P5U5qP2OafJD3
	LZrzFrYbGF23VmTNLj/yckEw27z1JDIdgnG0LrJad9wvyKcjl8wr4xiK2oSVfnOz8Avh4xNEnAlNU
	q6+cjjz1snmJLF3vffHxWQG1uYHo/HSNY+zp00kUKSMyX0yIDmH79ynHXx/tIict3TIi8B6ZItQZU
	i49/sl4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRCN-00000008Yu2-2dkQ;
	Wed, 27 Mar 2024 11:12:03 +0000
Date: Wed, 27 Mar 2024 04:12:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/15] xfs: introduce new file range exchange ioctl
Message-ID: <ZgP_A94O2On_KSPf@infradead.org>
References: <171150380628.3216674.10385855831925961243.stgit@frogsfrogsfrogs>
 <171150380699.3216674.11785679164141136105.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150380699.3216674.11785679164141136105.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
