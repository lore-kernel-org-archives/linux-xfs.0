Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E192205E3B
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 04:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739420987; cv=none; b=OCS+Bim34tEH0pzOavXzX7uRPvq1Qusntjxr2XAHHnJY2F1imNE64k6dh3jTldljXSlt+GR53gTklitBFie6iLfC/HdAhvfYBYHrO1kQm1NsN0X09+qsSCuSLuDz4Dm5+vixrnaNi6cmnWWcBbxEAl3/kSEhW4ND4Wps1SLu5H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739420987; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qSL1MFiWzFQkpAZeaCgSKkH9qKR4nxcfq2YMY2xX4Y9xI7Hga/hoF8WpaXmyXbjFDXXWLXbyW/dcUWTXFUE9FmHuJ6B3zQQFYSc/mfFr4joo+SPLoUQzVQhs1j/8juehNmz+yzTQLaWTf+edDGww8Arx2/2pOBVbEYChmWfsdWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V9iq66Kf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V9iq66Kf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=V9iq66KfCeB+CwDGLJMM67Ezgl
	V8J5zaUH1i79YXed4fYZECq4qkqZ2FWaU8KH6Jy3Za1ncvO4OY4uz9eDbaGQDooU4Ezi5qZKV0Yuy
	Amst0imlP1IfWhunH+bSyhMOvcjRTqix1BNX1kize9+wnn9ZBZK5Xbj61lUM//CabbXV5kF7g7Wif
	rZo107cxiC2Cb5iVVlTii1zuspwY7sqHdOTTLE24pqu1PdOSygQsZqfT+RM/KCJHjW4GQ4Cr43SWj
	2VSujUz/GYVqrEvgBlYhAJYFi0db8vzMVdYTeL+MqlcJvXB6ZZwz3M0UHEgOHU6HYO4awBxwABvtD
	TwZ+aaIQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tiQrB-00000009ifG-2k3F;
	Thu, 13 Feb 2025 04:29:45 +0000
Date: Wed, 12 Feb 2025 20:29:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_db: use an empty transaction to try to prevent
 livelocks in path_navigate
Message-ID: <Z611ORr3fCkWp-nS@infradead.org>
References: <173888089597.2742734.4600497543125166516.stgit@frogsfrogsfrogs>
 <173888089633.2742734.3613652081068410996.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888089633.2742734.3613652081068410996.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

