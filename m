Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE4B17555
	for <linux-xfs@vger.kernel.org>; Fri,  2 Feb 2024 06:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706854950; cv=none; b=AkCMN8NODgw7VSl0EmidSuqNjDGp/YY41kxuOpPoOdnehBT64HooPBtBslLy9tMM1NqMqEiDJHolKuy1VWVnkYfZWm4Wyh6RviKe2acxWSHcyheKuLdVKJfvXJ+314qYNXTs793xyA2WFY2srNKIbtbIC+b4zNKAj0hmrQPQISo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706854950; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dE6naQvMddWVlO5/edW+MoK1hLX/ISZ4WH9KZEnkfNBlcm+aKwwLXkDv20LkZNUXwv4B8z1UleZjYgPJwwNrCnhaJdZzePp0V4wcD16y4faij66mOjC06sl/b+hgAUKTuT4YBQgIXf4LfGqV8Kgf0ZHIrkb/Ps8/9CouuN96ZTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bx62/oot; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bx62/oot"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Bx62/ooth/Wnz8jNpIVY/o+pPK
	zGWnA2eggATF2Vg1g2jCPHP+jRZc7IdWnkR0iux30zMjt19wlsJEfDeKxTcrnQfNbzecFcSh3Ms07
	rLDQW4jXVD6a4mIoNZb2d5AZLjzOaROyYdUur24vEU1orV9t9MfLneSZDXlvQZCMZ09weh/isQZMd
	mnDN0jCXWbwQm0l/xG4uxsm3il2TJ6f6q5dxEmEAuBOfT+D0BPLZDpKAWHRIW4G/jor1AFMHSbdSn
	7RTyIfRARheR6vBa94+c7w/XhGLG3FA88n+RAz+/6cNPHz98C3qVRCUOM7uAYvNm1AGkjEbM+3cOW
	aiwd7gUg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rVmwU-0000000APC3-2G46;
	Fri, 02 Feb 2024 06:22:26 +0000
Date: Thu, 1 Feb 2024 22:22:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/23] xfs: fix imprecise logic in
 xchk_btree_check_block_owner
Message-ID: <ZbyKIu7FQlFTqLjq@infradead.org>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
 <170681334018.1604831.5903341339229401614.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170681334018.1604831.5903341339229401614.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
