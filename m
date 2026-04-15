Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FD62D5926;
	Wed, 15 Apr 2026 05:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776231268; cv=none; b=IrwDySz0mZfkiXpcNtOPyakdvLwpVceLw0BRL6X79XTLWMcac2mKfQv4vRoIAZr5/os/gHuU/6kkMDwMl1rTC/oSHQ3tD7u4Xb5uTWTO0Y61yCe3+v9MHnNsK09xdt0g6Ymg8jZI+Zu1ZGHQvViSAr58+9IyG/+T1UvU8FwhnVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776231268; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osuMvWQBT7OTuib83Ut1v3KDg5HOSNBKSxT5i7BLkZzUvOk2lcBBr2VUaUoS8yHfIAT5J+v2aNPJ4giM4SF7fWTZEv4xJCJRBlrHKTHxDyRi+wTI03wSicbtDwID0C17xO1UvHrmXJO/9u4PFQ77eRN5zA7nPfb22XAXf+W9/VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Pc2QAwgS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Pc2QAwgS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Pc2QAwgSK0JKkWgatITwWUZ1VC
	hDDAFeKjXjjuPqfv04ZWqHfqeZaJPg3+x4P0W8+V13b51PEckvFZhQhRjE2FI1DEq96AmUgLHjk7y
	NIOsUe2470BIPZGUquixnxGsAgFTs0c+VIsTxu7xz/gDX6tJ00gHm9XQgRgMplVhCTi8rOK6Sj9Rn
	UXGCQkLogPeBvgiBYvZVbCvi+ok7c2vWjTLTRe8VG9ZCos5vbDu1WLRmJbepGXqamhK5DXN+6GD0t
	MvxuFPqlc4NhhgvXHiHNe25oJZqSy5UfyT87lQcliv1Xi/3xbAGYT/+kmHb766FB9vRNesYuZU3rV
	24HVx83w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCstK-00000000baJ-3GiB;
	Wed, 15 Apr 2026 05:34:22 +0000
Date: Tue, 14 Apr 2026 22:34:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@kernel.org,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] check: capture dmesg of mount failures if test fails
Message-ID: <ad8jXkOWZAyJjCNx@infradead.org>
References: <177610262399.115381.16343458870133010450.stgit@frogsfrogsfrogs>
 <177610262444.115381.1847570200616394322.stgit@frogsfrogsfrogs>
 <ad3z0FFzJqhIiqVQ@infradead.org>
 <20260414171730.GA149968@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414171730.GA149968@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

