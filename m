Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3+2Vk8+p"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263E3D0
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 20:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=3+2Vk8+p50yDPRx1VKrUUzpz4I
	bsw843DXj3KZuxOuVdXPyhCs5VSwjRd5WeiRzCm87DoIl5ucZpnkj+dvBbqtpWQDiLjU1L9EBABuT
	cnu2bfJvbRvYMwMySiAZrAlC9yDk9rd6BTdT90uYliaGN6oqBnHzjrHbB7rIUHvoVWCEteYbOyJ70
	xYCrRFY/lvL8oimMyssN8anCgY9EG1MBbyb4ufJxA1qniAGyswTpwzNNbTFHn30iThL8VX6hP8PWh
	OXsaucPVJ4TApeYoYjlS8ZJ1YF0wx+LFQrvBErYb0utaYi5yJyhwWPKJHC9COHwtkdXUPzdSXmDV+
	v0tVdjiA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdgN-00GkLo-2Q;
	Thu, 14 Dec 2023 04:50:47 +0000
Date: Wed, 13 Dec 2023 20:50:47 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: repair inode records
Message-ID: <ZXqJp5/BLu0kpELN@infradead.org>
References: <170250783447.1399182.12936206088783796234.stgit@frogsfrogsfrogs>
 <170250783563.1399182.9678836893515889571.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250783563.1399182.9678836893515889571.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
