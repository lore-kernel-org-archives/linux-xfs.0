Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xGHMWrL0"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFFD1723
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 22:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xGHMWrL018kkpYRsFPoqB3TsbG
	VXKgs2BAdiKWgo8cDjCikDJHtQe7vneMfh8I/6Jia2gGtLJ2GqNioRlUehQUQy1dZE+uzWvmAMBqj
	8OO1HuudqUBO8n2l3QVdElkx7NnknLVzXokIIcYNxB8Tj8vtfVsIWvLsf4UknLXhZm7R4/llP8jWY
	MQQ7y7ZYoLFFjN+OdvKX+ItRlmTfu+gxE88S1BcBrdwkC2Mmy8GIU8ZVGpzZ4Lq9zJfzM1E4yB3sK
	Kq3hGR0YIcDrFYDjbySad5HYfiIbWFHQWk7PZ4JWCXtyxeTjYCYytZgmpKrcxT91qb5BVIt+l5sS8
	CN/Xxi6Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6lvD-008f5Z-1H;
	Sat, 25 Nov 2023 06:13:43 +0000
Date: Fri, 24 Nov 2023 22:13:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: disable online repair quota helpers when quota
 not enabled
Message-ID: <ZWGQl0cRuLDXwzKh@infradead.org>
References: <170086927425.2771142.14267390365805527105.stgit@frogsfrogsfrogs>
 <170086927457.2771142.15924813255165832144.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086927457.2771142.15924813255165832144.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
