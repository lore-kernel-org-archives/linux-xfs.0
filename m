Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409943;
	b=x+Xd/k+AMI8syhl7FWIPtX0bYQWBB8W/uBY5BbJs/9R/1dInvuwzgBNsZrXxNKLQe7kz
	 bhLFHQL/IvBMx5Dih9Z7klmuHeF/u6as/8G4VwPlgAm2/x/5X8+ZkJU6xsrJVagE6EXFi
	 /CSrC3lPnzO6jmh6c4l0CdQMt4Ef8xwebNMQiSkFCF7TT1prsAQef+gNnRQJIi9bCrJb7
	 AeQhZTzx/er6o5CLZb3zpZKuREgcIjYYpIeEYj0uyWf7jeO5siFcbyvXkSn2XsM/LRhOo
	 9kedaaoAvtCFDnxdtG+TWV0q0f1ghmkTQhkmvoyeWwgvOEV3GijqU82hwL+ThVqOiZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409943;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=AADWlP1B0CD0po1LPWlpbmD1OwW8cEm7IXpKhg4vFrKPeTZwH13FSgFPk74yIGA/c/zr
	 bQExd7RXpCrlcinlB0VD1NY56tiDuPMipDx0Yk5CCwdSlTUQjd7hG18i1Y+P6n5Is/v2t
	 x63wMloNVXEy2YmsJnRZLTjWEzx5hG+7i7/JWrKNezSgBVs4JWeKu35s1J7E3TH+wCD3M
	 2ifvMv5UJtA6E8zfny/OjHslt9n+LpCkujO520oJ5Wo/2bs2gs5qKddyChh9Iq0AQlj6Z
	 IWCP+FQOBjOwkDUKtpFeW26bb9ttfpqAAa8IQDIepC41962xV7w1h/Dhbb+NMbVl0Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TQyoVBUv;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C247606A33A;
	Wed, 11 Nov 2026 15:12:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C247606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TQyoVBUv
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=TQyoVBUvCuhLDB5+tnjCSVk1u9
	sP83rGOLICYzOG4D8vtaB54+WwffxUw0tAfL89p6D0gVu8bnrj2q/5MEa8scZon2Zpq1RTE7NJDe4
	IgrS3qdpgwapVJuRIkBW/WP7wmiFFOLJp90UgpAFVqxflndXQCXdIuZwbDZJxJHXHkAeMAM0W/Quw
	VaFHdeNq/Jb22GtIG7eerOekpyEhnZh+bSGaJ92uT7LdPBDfOrAlqkrOKKlwKIHTyZizqqQzOVNcm
	R/97BEdPspD9A25PnsvLbZBRwljSFj0mIz1T7Ie4iQz3SEkQvdHjoZniS7q9vMcOjASSe6IOBPcpH
	mXE9ACxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xR9zr-000000073o7-0LQn;
	Wed, 11 Nov 2026 15:12:23 +0000
Date: Wed, 11 Nov 2026 07:12:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: wait for direct I/O before swapping extents
Message-ID: <avSF1_5Ewf-eysfG@infradead.org>
References: <20261110-xfs-swapext-dio-wait-v1-1-b8ccc5d5ef3c@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-xfs-swapext-dio-wait-v1-1-b8ccc5d5ef3c@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

