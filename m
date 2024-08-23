Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD4A22EEF
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 05:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724389416; cv=none; b=CabqV89QNlX/MLQ6dQ1DzOTWZe8ZQCZcpC0+AQ0aDcE7jhywlPH0J2HkICHLCD2evJoA5WfkDWafsR+8GgVKemKC5T/M4EAauq0o04XJuF8hWIqDdrJvuzaqxzB78CQ0Lhli709G9TYNA6zxyw25AEFForFfzlDW86KdqBeT5JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724389416; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BUvPI8cXanf6sDX9T5TUm6f+KcmN4Jw2ByptNO8Q78cy7z5/J0GncosLV/a9LgL3waqeeFQqGqAbq+oT+QPZVbHJFk2KY/kEETAXZo5VqsX87xvI73O7mTIv3xL+oRJliQY+QMQKHGVuMq6k6BKE417UP/mtiEwGRwr+M5XHHCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JmBuh3PN; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JmBuh3PN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JmBuh3PNt7aymCFJ8+rqNTLJuX
	gL5CCHAbUYLaGBdyViIqyKYhv/EY7wAACdDUqdJamCQdHbUYfEDDxYP9Yr550mmsfbP0+jWz0fWUC
	Ysb9lrFTBTQdQDbAkXVeIwXvLsaUZ2gnyi9or2zNdjWx3cevCEUI2GEOVPHw4WTUVFn/yNugRYMbv
	7lo0aekOKJDW3VKrrqOAwETM2pxCup5xKLfvF51bAWdZBZmsfXLc0RWRLRe38npZjZ0uuonSCEKVv
	lH8ICTb5k9DpsT+gMXPFyxLiM46fLrAT0vCJ/To7RPHCX3bi0Jh6Ph7wE9CVE26zq8MqDAhmDhY67
	oi3RZ5nA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1shMSV-0000000FFow-1Hma;
	Fri, 23 Aug 2024 05:03:35 +0000
Date: Thu, 22 Aug 2024 22:03:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/24] xfs: add rtgroup-based realtime scrubbing context
 management
Message-ID: <ZsgYJ4g-0G4_NIhU@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087504.59588.10025312195068387840.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437087504.59588.10025312195068387840.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
