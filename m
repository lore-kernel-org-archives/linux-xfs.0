Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2E615CD79
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135904; cv=none; b=YaMtsT3SvhBAYNpbU/TDeiVEEWGHcgmnwMiLFo5nrcsd6DVVJI9rhgzopHGJIBm3BbYtEqm9UuOxwWMSIygAJL0O2fYYtLVr6lrBV00CfvaWfULOV6VPNkO7ILV0o6X9rcI1IhcU826ZR+b20xOHcFtRW/wRwmBOmMy34WgXvq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135904; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yd6urwf8T3iB+7zRAdDSY9HvnJ+OpYJ1/iYn+7V1wAkZSxaJrwSTosXeP8Avryq710X0SzsEyJVks9dc5PiyVSTq0VnjiYQjAYxfTu2BTxQxPYKb6WmdxQGdhAWmn9GBzTdSvxjDfiKnPjOxZAxcVZ+qZ7mMDd5jO3wQPaupzwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SagDr9CR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SagDr9CR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=SagDr9CRqo3fAmVz6KrweBFLHr
	7fTUrnbT8ynrUmQUdS2J5/3I31WXxgYGgThvS88L7vZH9kahmb6JsAsWf3MxgzZZuXWzxqLO6t/sV
	Mf3sgkiLjy/QL5v4UHHjbbx3vwI+mZAcLbZIx5Pq1H0+AeQpAgCI3Of+6R/L0k9Afw4KVddbHUzPv
	ptuFonEAYVqbIinUea5rUjCw1TIqADZWgUYD1KPY9S1AAL/beHLNDx5xLrj7S4LYoIcdS3fQtZNP5
	aGLdASBB1jx7Hrx9VJ292JMW3CfniqMR+ul5rG2eNxrKlUkba6EGXsoivFQRwFGEyVpykPsqiO0V4
	rAP35B3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfMK6-0000000A0D2-1f0u;
	Wed, 28 Feb 2024 15:58:22 +0000
Date: Wed, 28 Feb 2024 07:58:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/9] xfs: validate directory leaf buffer owners
Message-ID: <Zd9YHpwkkt3MHMQA@infradead.org>
References: <170900013068.938940.1740993823820687963.stgit@frogsfrogsfrogs>
 <170900013193.938940.14203172002039358646.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900013193.938940.14203172002039358646.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
