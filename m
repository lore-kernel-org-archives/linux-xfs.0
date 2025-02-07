Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C7FD26D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 06:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738908023; cv=none; b=i+dN2rmwrXxI0KFMbTyimkTbISwmDZSvoKF7xpwsQDJMvhD0x7o7UwGvQGI6HEiWoNtnfnG4ayZuu5boTJhkXmeBeKthqTlyobLKvqjYswt6LblPJfOdE9VzXfuILrHRQUu5xwNwCZa6MorydG77t4xqerW64MFE4HIwEmCg5Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738908023; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ezjzZZ2OTtO/GQyv26VAo4GOzGmC+vpGh8rOu/wT7PO5zWuvEDeQ1/GQ+hMmY8yxBVgPaYZkWszufDvViULinKiG1U+JsmlOzVhNBxkiVHinSxZnDX+cU3JP1WD8HCJzPMJEd/zp959bvcGqxXpb3Xrcyip9Z/C+y+C4KkEZRkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i+zC79VW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i+zC79VW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=i+zC79VWEy0poixzunlvQBKvZE
	LLEKj2kJInik0hGp+Y6CuL4GMBoUBnjwjbVIrQSMSmyFzdulOt/jKwwPVzjIfFEmf2FxidfugkYnw
	bblvpuptblesWKhLb75s5zEYDH+6i1o0xUQB7EaUgNGu8DTaTDtEpk1cwolj2WhAy/QLPTN7ya3cY
	EGtUR201Okp70ta7FRg6hd/2kOZiCpIMRI9SRBzXH679ftQOsnHpwDkx3/N5ob7SS66qouwOQApuK
	GgPvgC8F3Y3q/40UJlgo9nSfHerIwkFj3b/kFsZTbh6IOPUEzFnwxOSzOQGrQe+ptFF/w4AjMMBLB
	sjupA34A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgHPZ-00000008RQh-2Dbx;
	Fri, 07 Feb 2025 06:00:21 +0000
Date: Thu, 6 Feb 2025 22:00:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 27/27] mkfs: create the realtime rmap inode
Message-ID: <Z6WhdQBlJMkK3KyI@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088511.2741033.12591731083152285550.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088511.2741033.12591731083152285550.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

