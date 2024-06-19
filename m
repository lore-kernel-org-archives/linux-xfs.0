Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF941E495
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 06:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718778088; cv=none; b=JDK5UjE+ESeEBJVzYhz+9DroVHTUHv+EEez6xi3+I+mzzUaofe7svdU6l6Svj2FBh2gqNMs6Y0gKkxJWsjn2Pnu+fdflJBqM6O84oYa5FGKKHtsttlnsXNHlhQm0GKeVox7TLqDrEX1FA3CARH7yGWJ5F6X1X/m8NcIuFYnLFKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718778088; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jdcvPA70qLk8/mev7TCKVqUC1FzrTA+HTqsl+kSGG7yzVIK3BtKQVJMUp+cOELFdQ0qQnTeIa5T/lOIcj5GY87uI+jEXYZKFq3Cow2QjI0/j3bHLPjlRW7UAjYP3bcVMf75a3Djkq5fR83YZ+7Ca+JB9XwjSUCiZyZYg1XsMyZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=e0xxVJ4X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="e0xxVJ4X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=e0xxVJ4XIdpQFnYTunFZ1V434n
	SHL6Ul5nKylH/8eAddfHx/vZ3XUlzm2pSFMwU+kwFO7ImeKVkmytT6DkMk80bAMI0sItBzPwlqvfp
	LbVMYVw8ikWHa49M5UfQWtoNYV7ugDItkAttDyqnQwqn9JIXqCgRE1RDU7tyBT1xq++XcTjbdtCWi
	Rl5t7A/VwRxxgHucuAmt85xmT3FyeqKcPtPySofjXNtTkJ343s0T97PhQJGvP2icQP8uN2BB5hmr0
	tYeo615u1HVU31plyqM/9hQZ86twhNG4Zts9ipixYFCx2Htm9odTtUxv9gPxPM19gMQYtKC+JqExQ
	ZiAEWhmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJohA-000000002fG-0jn9;
	Wed, 19 Jun 2024 06:21:24 +0000
Date: Tue, 18 Jun 2024 23:21:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfile: fix missing error unlock in xfile_fcb_find
Message-ID: <ZnJ45JVJfrCSiVtK@infradead.org>
References: <20240618005703.GD103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240618005703.GD103034@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
