Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62DC1EF13
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711539314; cv=none; b=txa2oNwKJn6d3QzuLkbfNW9fPrG+P4Q4BUi7AUBsdZnKSxZwVhG0PI215VlHuuEaQtJIpP6vXNH13Eyy+3CqiGINpJnXe1tKdkJ0FO9CqjYLpHWcoRzI/ohyVTJKR2xjWtD6F9/OcrbRSXvu3X7Twwa4Nyv58pS1RLmBM5fT070=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711539314; c=relaxed/simple;
	bh=avlsaJFAERouyJCGh7N/9RuU0rK+DWriFmCKItNT7+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SO04c95n3lT1Ri6nRZ4jCCuJjGxrZHMUuK4L2Ead7bsWj8d9aLEWs187tmiC8cJBtLGMQOk4zNyQ5c7SgucoTeTXmeV/7Wf/sH64efclaDfjtiqEUlHlw2o2eYkJWkjrxSBa9dOVp5RyCzpOLt59umpT9NlMZp59VS7Zc+7c5/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JjMuS52z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JjMuS52z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a26xyonBKqaHTj/RGR93LtEa34dkWWcypvAVfDBqBdI=; b=JjMuS52zV5nAeu0TSxgYAhOgfN
	2NM+v9y+giohsIW6UGWBUo+BihpdpzvuVxiLEbeNfUpQ8jj2TtM/UlWPEtdEVxFUvWTuT1J/T7zUN
	X15NJbL8YcOIrFFAg8oiegM2HkhzPwQ+Uft05EgVTj/fEug+1sijkrhr2z3PJqHPMJJPNMlABbR3N
	+oZBuDcPdgAr6uX7to/rGcQ+JGK5FIozHswPSW2oQnHolPpmgSl7dkIDDknMNTNKSudtIh4JhrtnM
	5OS88ARd8RrJX6Zhyx8h+Axacfu3PR3iMUgJxa2nSCGgR4EB911D8gnh+3Pcmmko5yuvKQAfC2JRG
	cW6cZu8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpRYm-00000008dRl-13VJ;
	Wed, 27 Mar 2024 11:35:12 +0000
Date: Wed, 27 Mar 2024 04:35:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fix severe performance problems when fstrimming
 a subset of an AG
Message-ID: <ZgQEcLACdVZSxJ1_@infradead.org>
References: <171150385517.3220448.15319110826705438395.stgit@frogsfrogsfrogs>
 <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171150385535.3220448.4852463781154330350.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 26, 2024 at 07:07:58PM -0700, Darrick J. Wong wrote:
> periodically to allow other threads to do work.  This implementation
> avoids the worst problems of the original code, though it lacks the
> desirable attribute of freeing the biggest chunks first.

Do we really care much about freeing larger area first?  I don't think
it really matters for FITRIM at all.

In other words, I suspect we're better off with only the by-bno
implementation.
