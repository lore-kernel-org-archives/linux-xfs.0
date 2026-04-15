Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7428D2FDC38
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 05:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776231344; cv=none; b=TpuDzIZArrBLPRZ/arJ1Dp/r4wWBcGohtN24VjMy3TJ9xdgc/xxd3D/+K8P1WwdyfDUCg9rz0MwT//68gB7TbtFgYiMbh8xkkh3rvA7/XnrCeAQBTc7j7epjR2Pg35xNx7F2jd0MnxXahf72bVJ27P3HsHp3Va7lsykGiOmNHVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776231344; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qm408497xmP4FzD+DYwhdIMMdX5OAA2W9mQJLUd3+6GHgVXzj+gy4gAae14LRZMXQ7s2cODPUettgtmWLV47DuUDmxIMTxqoYrob25FVfQW0mWXXjxnDK96zUWofEua8DPoWji1I9FLuMZFkYxeCsVQtqUyhwQfVFsnDjvRp+do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3Q6W15Hg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3Q6W15Hg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3Q6W15HgywECGclXWUa88xY9r2
	/aK8RdNhU8PaP8tVqdf/GreWCPIjGRQglJon2BzrjB87M9hMkpksy62mju9RujEw4g4aaGGpL+BwO
	WipgSFO+y9CCdaxBBmaczKCQRYkJX5zPNgiQ5IpO0277JqYVz3t2lNVaZOz2mHQ/YlAsmjSvnFfzm
	BYDXOG8msrMNVt7/ekxZ5GXCar2+Av6LNaK7NNR73xev5fIxIMXuyoUVobVqfFau4mdjxV3R5pLRm
	jA+9zSuOE6QAAXgNTI8AEIkIg0JY/qemD9YE0SZRORqmf76cTUOT1LIO9lwPkxxhxu/eLWhoNHElq
	YA4tHTKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCsub-00000000bdS-1Oo4;
	Wed, 15 Apr 2026 05:35:41 +0000
Date: Tue, 14 Apr 2026 22:35:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_healer: update weakhandle mountpoint when
 reconnecting
Message-ID: <ad8jreOZ32NlLN-N@infradead.org>
References: <20260413035650.GG1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413035650.GG1048989@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

