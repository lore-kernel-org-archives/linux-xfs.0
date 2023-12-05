Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2RWVsCTz"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187ACAA
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2+0K6wWUQ0esEKY8AlkTLUm1AYngM23n0FGP1DW6hX4=; b=2RWVsCTzXu4/LRVM5W4sBMXOQD
	iZodQoxTdQF59irWa4LekC9WTi7v3kB0ADI5rmncf8KeiYfp14S6lEJ7TKIcvIah1jNHzN2mB0wOX
	DitDc2RLD9JrM1DXGksZz01jr1Q4WDdfUdn1hO9nrPo0Mj3W0MY0InVUy+wBGKJGLjBTOgBbgcygV
	Jx55Rk8PTnaPnZLLRCW2PaMTJoWz55sKwpMHNXpiWT9fIbNu2xeM8mc5vhBQlGCRg8CCZ+dfXpgb9
	tiVUj4fc6EBokdoeRcSk336AzT7TyxdmCRvVRrKI8FGzHOOKhMwACrM4ucQ+LTjBcq8w0hgefc/2Z
	dq9m0lVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAN9I-006ETH-05;
	Tue, 05 Dec 2023 04:35:08 +0000
Date: Mon, 4 Dec 2023 20:35:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 1/2] xfs: add lock protection when remove perag from
 radix tree
Message-ID: <ZW6ofJp3zRn/X3Mc@infradead.org>
References: <20231204043911.1273667-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204043911.1273667-1-leo.lilong@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 04, 2023 at 12:39:10PM +0800, Long Li wrote:
> Look at the perag insertion into the radix tree, protected by
> mp->m_perag_lock. When the file system is unmounted, the perag is
> removed from the radix tree, also protected by mp->m_perag_lock.
> Therefore, mp->m_perag_lock is also added when removing a perag
> from the radix tree in error path in xfs_initialize_perag().

There really can't be anything we are racing with at this point.
That beeing said I think clearing locking rules are always a good
thing.  So maybe reword the above as:

"Take mp->m_perag_lock for deletions from the perag radix tree in
 xfs_initialize_perag to be consistent with additions to it even
 if there can't be concurrent modifications to it at this point"

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
