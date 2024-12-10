Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF85224CC
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809091; cv=none; b=cN7QWeBP1IpxwYXObOERxqmjmjZXh3a9UeXDxa0oeEAr1kWu+7PMoZW78rAk1jr17AHwUmZJRxcDOYI0Mp6Mt+Q5fINspgy3WjY0IvggILMKx5ZYvIq1ncifH/Hxu0qA0isSSZMLTUMVOYQSJSbDq/9xnqE5o+CAiMMtp/mpohM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809091; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lFtP7w+XtODH8PocvdGYQjD1WY7wYbJsO1h6V13ToFxKYewqGKV0cdzJdGzWVzgNvzydJH9vFQgeXV/VdH6AHi9FU6lf5qYWtCjDal0r+C8PTSim7Emjd8eCHa5We7U0wLrYl1r3/uwr+fRW6fgrw/uFbtcyNQdLHYjua5SKF6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m/zycRxL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m/zycRxL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=m/zycRxLPguq7Yn1YcOirtk0rB
	YYJdrP2VVVunROpdmXe85lrpasw4PBqebXd2ycO8C8bWMCe7yTjDN9YLLSmQ3CJMVkO4+fOTy61yB
	AWyil8w4rOjnBAxlnPXGc1yX/CvzjIcdoOKEud1YfHdh/PKhLPi89LxQkWphTTAUgDtwPW6WnIouq
	23SGtV0YS8C+uUR+Rg8nFVuuxMN3tgSOXCnymLBdTskFIvohC3Dk+Yig3xqv1VBKQbrvKhibcZz9o
	bA3nh+O2UBtHx1Hzm5zO121cxpNWNlNTSFx4IZtKyiwVjV/CpnQidMpZCXdDy9uChYCMsRJosljDH
	6MgU61sg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKswj-0000000AIIx-2TEb;
	Tue, 10 Dec 2024 05:38:09 +0000
Date: Mon, 9 Dec 2024 21:38:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/50] xfs_repair: support realtime superblocks
Message-ID: <Z1fTwZCtWtw3GkOI@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752281.126362.11077683700931989988.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752281.126362.11077683700931989988.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

