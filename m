Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JHHQQkji"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1134010D1
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=JHHQQkjipHRQJxZ05LOzVcDy7h
	S010rd3RKnihq73zT8aDpuozbEqHlhrkZbh3LbnQT8I+J4MkvHE2tmeUAxK9+dzHUUqf8eKLbcMa/
	VIagnXzakxNLoQatjj4wii1zUfD+K7FrWIqPmm4jvHz6i80Ri57o+RgBGKWbIgf4ikv3M3Y6FNAx4
	vHMftIBm8XTfVdG3F3J2vgKVNM3QaB0oq+oegb1/r9d6/mgHpq9yYcWdOU5GlINj1Fv2evQGMEac9
	jqbJ0rTbz9cORHCz6mTa/wWqBtLQwNfYUPy4gqX881kvxwsdZNARVY8iAzfivppi34gdol9aWMAnS
	id73hHPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6uA-00Bta5-33;
	Thu, 07 Dec 2023 05:26:34 +0000
Date: Wed, 6 Dec 2023 21:26:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: read leaf blocks when computing keys for
 bulkloading into node blocks
Message-ID: <ZXFXikLEofQgHnnd@infradead.org>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665194.1180191.14732920823825360410.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665194.1180191.14732920823825360410.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
