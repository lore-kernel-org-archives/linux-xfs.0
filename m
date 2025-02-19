Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07971AF0DC;
	Wed, 19 Feb 2025 05:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739944537; cv=none; b=kM2qZd44u+Las4HmePYkrvbIafKFPNHzHdWJTT23qza0nlFMRhIPt4fxVsnNhuqmYeXB3p5JYIQzgZIeJCXxpBi9SiIACvFUG+dTdmMoSYGuUr+442nBBmQnkMMLQQl4eIFH99MQ6tdRCfds3DDGNHru86l3hPaXb7Q+xSZYtS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739944537; c=relaxed/simple;
	bh=PJyt9y+5bcYlH95suKiZB/BH+TBVH1qyfIWIE7N1tTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=ixFkZ2iL1tzN4JbJy7O4jUbO41V53Wy5rDsu+CoEWvUUhTqQ9sY/d21qtxLH+bIY6Vq11cwBNlpDm6Myf69AhDtnkm19WuP6GYadfA69RC3oPIdOpevj1JPlmjmX8TSC7+9icZzqJMGW3khZ9IaatnZHVSjh7OA9E1xyDwd8E4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OxNBxdxz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OxNBxdxz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding
	:Content-ID:Content-Description:References;
	bh=Qh/Bh+rgq3kSnekNj4aXy0Gdj9tu/XpCDwIedhZxEw4=; b=OxNBxdxzvTnkVVYxNRq1Dl5ED7
	tosOtCOV8QP6rvd7ERjBIgiLW/rOW1nCqxjt0aEFPPq5E1/lN9r3KVCpiF8edD7b8Hk11k890p0vT
	heac5nhQlkAavypcXrG8RD9nwVdXaI10VlS47QnWbJS0iGXtgjN6jpcpccPJhJkayDrn1il88aD7U
	g+zPU9K962nyc4DCN/kFlofxsngcfVfDyXq0XO+9Dabrk7Fjw9kikhwZZyD2CRfFBCvPTfI9PqhW5
	AWPDSc03sTviAy3zNlS2Dh8CVU1bGZDLpIeGthVZS9+XJzGgYIMPF0kcaOlnz0NQvV1M7dRbDnq2Q
	1Epjnkxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tkd3Y-0000000AxsB-0Tx7;
	Wed, 19 Feb 2025 05:55:36 +0000
Date: Tue, 18 Feb 2025 21:55:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCHSET 02/12] fstests: fix logwrites zeroing
Message-ID: <Z7VyWPjJM-M59wJc@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173992586956.4078081.15131555531444924972.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

I don't want to block this part as it's an improvement over the current
state, but all these games of trying to detect if discard zeroes all
data despite making no such guarantee whatsoever and being explicitly
allowed to zero some but not all data just feels wrong.

The right thing would be to use the BLKZEROOUT, but AFAIK the problem is
that dm-thin doesn't support that.  Given that the dm-thin discard
implementation seems do always zero, it should be able to just be
reusable for BLKZEROOUT.  Can the dm maintainers look into that as it
is a pretty glaring omission?

