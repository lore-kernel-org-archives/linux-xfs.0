Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D253169397;
	Wed, 19 Feb 2025 07:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739950338; cv=none; b=T31FZ/xqWTUXyH2wjVsjPjs7qUlrgxHJopgoYgS/2fn5DoFhtPFfX8xWIegEL41EjsG2dWP7i4uC6UPDuswFRAVr5Ry7yG0QQsG+r1nAziJZtQJpI5hw7M8c5irzdFjF9rQo/nVABV5f5qw684KTKkfB0jERQojHTIWKGf5NMKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739950338; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7pIT9MnU641YalU93lOfmggw2NU+xJuymTC0xaWjRFQk+a8A+jNw+kwqSs4LjtU3tHB190JLNTx0PDdg3r6o5Mlbv8gHy20QB8L17ekuPDQHCGEdYoIkh2AH2fTOVPFCX4PsjqIg/r331RFkdj4owk91pFZKlZHkQakdc/eQwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oXEborIt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oXEborIt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=oXEborIty7QTiscTqnWtjoWIoq
	Uo9UfzRrw+eBA55T5FCHYX0nfNGmIKbBzi0QPeqVoN4Ey3j579SccoNIYoXoUtulfes8Hq7qLP9Jf
	Sf/cTUTWEL8bpYqb2onRGN4LYFgnFLLIPRflZ1uyZIyU0/l6vgCfhkEtVZhGrI5WpZE9mNl4rjCmT
	mERXVslP8xWSj8F/5jhIy01OYIQAmBcC+0POfkWvYhZsB+bWnz88c1sXPuVUKh/EQb7FR8PRyAozi
	ef59sD/CiD/YyW2WB4JiSNiIJQ3jM+MtnW3vX6Uvv7N8ex6oZTLT86dJhkDGyD8lYhYdEhxyGnIrU
	LZ0O/dlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkeZ6-0000000BGPR-2vru;
	Wed, 19 Feb 2025 07:32:16 +0000
Date: Tue, 18 Feb 2025 23:32:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 12/13] populate: check that we created a realtime rmap
 btree of the given height
Message-ID: <Z7WJAEtSWdkV5eYu@infradead.org>
References: <173992591052.4080556.14368674525636291029.stgit@frogsfrogsfrogs>
 <173992591331.4080556.11286805171906703815.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992591331.4080556.11286805171906703815.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

