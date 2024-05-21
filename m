Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA7B4C66
	for <linux-xfs@vger.kernel.org>; Tue, 21 May 2024 16:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716308681; cv=none; b=YIPxdOWy+AfhHvJc7AlUMTI8aIS96DOkg01hwA73ZgoCKHQp1JN6aDF1iuOkcLG20wXPU4ucqIDFg1qZBVw0cvju16zGWxhDBtZQvACPSbIkmKStiFMyKDLKiQvCcH1jCExlI9ueJG2vQe3Yo86AILt4nNEeEjpgPcXDxo3iwLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716308681; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQAccD/JjVaUGqhfXRMHUzJtlz+G5XqI/FeuU6y/52hkHgl4RG/84KeJU7cPb3EaJtGqi/2D8XaLUE87iTV1LiVHnceETV2O9g3aE5iC6jdm+LU7OF5I2meEYzyckagjbcUX8PK26Q1bMX7j1/rHIXMXQOL40cXybv7NR1CkpHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uO07Zooq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uO07Zooq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=uO07ZooqlNg6nFQHAc2O0x50h7
	rA/iG9T1GttI1mc+/iZRSFwOlinlxUqpb7swLIdu8rD1sI0OQ0s2ZlpBUF/s1j4ue34210EsIOTCL
	uPpIvoRn2voUv4h2RJioKhu4+lYvHXiB1qBWeJEx5FrjDlUFNQhSYhpdB2mD7P9R6Bzk/3S5orapQ
	aqLFBBJIPHL3/hyCF4+qxpinaASGr7+fTunRN+U9Gfhyn4gtjdwa19KbrRWsMC+1jZ33eYFAo7e04
	Ycy1eWGvUc4dyK8JqGveNBCl7hG3YKVWcLrEknZx7n1kU5KcEKaMRj3YvfVlHCpI2LtSdpM/Ewpem
	hiynyKQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s9SI3-00000000Ujc-1bUv;
	Tue, 21 May 2024 16:24:39 +0000
Date: Tue, 21 May 2024 09:24:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: fix xfs_init_attr_trans not handling explicit
 operation codes
Message-ID: <ZkzKx8rvz4EHZJxN@infradead.org>
References: <20240521010338.GL25518@frogsfrogsfrogs>
 <20240521160509.GR25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240521160509.GR25518@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

