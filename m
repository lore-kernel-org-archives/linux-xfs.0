Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD5B15CD60
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135466; cv=none; b=jvtILQKekx8gW2XvG7v3U4Xp5fK2rwsXPwenwBVARSj1iwqIC+M+GX1HRVVWzlwNdQHnL+XKYJy4LJFQWbTr6JF1mtMfCDYkdl0rlwMIjKXK6O1nYF/R0k0/i2n/pZZfSQcqxjUEI/1fgFgWPyf+lSDJ5a82jR+R3GVxLgrNH+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135466; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dW4hMGAGGs6j1FJCjPstxKzneqsG7kHSRcK/TEGRClqsqIEyUgyIdf4QENFNMOq/Dgb+hNwzfrkx/UAVbPtkf2fDmf+B+BtYs1f8rKURswjN5PLz3QsbiQCD7eunEILfT6eL3xHYYF591SCnzwqlOk0tyW3/OkepnVdMzy7O3lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=C45f7axY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C45f7axY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=C45f7axYDWISjRjFdeyOkFNWEN
	qZRDb29HPn13OOuEA6zbZH/CYeQv6l269D8RAkclE+WFj7Md/94oCanJPGv0PeWFMo6KyLplgQCpu
	0MJcJ9ED/13OyLOqkvjMdXFfkjyuu5docBJmJId+q1WHqf/tBPypMru/MEtptp+ETt1H+WG/Shpzx
	afIpnhY7f/Ia3IIfbnE6CnNCslDWbMvIiroaWmX6hnbdm0Lr2y3SVUeaIf1djD6+6P8LnvCqxWuEE
	Xy/KsW3mKKEWzAlQPbyttUqTVFG9R7IagWbpOioovecUxZeGGAm/1ED9m+0eHdrgB+Nuqe21WNsQZ
	vilVkczg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMD2-00000009yux-0v1m;
	Wed, 28 Feb 2024 15:51:04 +0000
Date: Wed, 28 Feb 2024 07:51:04 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/14] xfs: condense directories after a mapping exchange
 operation
Message-ID: <Zd9WaGOtC9RFzmZZ@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011790.938268.507293694895114250.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011790.938268.507293694895114250.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
