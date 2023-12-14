Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HhDHABQ1"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1411E3
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 20:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6o6Krwiihg7l0jFy7ZS7RWYMyfRmeUbYtSxw1vh8+Ho=; b=HhDHABQ1Xi82C3lTtzHHxFAp3L
	vhk4Regs+DTY7gEBiPZRVCryTZNAL7/OqWd4/4HDGyHvRkagHhSfbHXTX301RLo9R0uzGxC+P5k5G
	mxhsBj8gSTn8l7ixv5tQ+5TriabQSCIFxPeTU7hbZC9X3OURBlihiKphD9FyFYzeDjaZb2nSNXa3Q
	wz6lvRsDUFimuNHbWOCZfsNj0cif1Ir8oLgXafGHAMlPFPUSCw/9B3JL08k/YQZzQHWOpt23CmVea
	I2JgXpCslm/YztALeDntAiAoXyECp5NbngLotni+5n6nCh07Np47DcWiS7116VXjBlTV+ExxjvHSg
	u9Ri4ZFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rDdb9-00GjRc-0V;
	Thu, 14 Dec 2023 04:45:23 +0000
Date: Wed, 13 Dec 2023 20:45:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: set XBF_DONE on newly formatted btree block
 that are ready for writing
Message-ID: <ZXqIY5FvdPRPBzqQ@infradead.org>
References: <170250783010.1398986.18110802036723550055.stgit@frogsfrogsfrogs>
 <170250783054.1398986.4495796106537845155.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170250783054.1398986.4495796106537845155.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 13, 2023 at 02:52:13PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The btree bulkloading code calls xfs_buf_delwri_queue_here when it has
> finished formatting a new btree block and wants to queue it to be
> written to disk.  Once the new btree root has been committed, the blocks
> (and hence the buffers) will be accessible to the rest of the
> filesystem.  Mark each new buffer as DONE when adding it to the delwri
> list so that the next btree traversal can skip reloading the contents
> from disk.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
