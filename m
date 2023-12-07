Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GxqJddfQ"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81111A4
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=X1BTCclTvQ8z/mqWn2z3c9hRd4xzGNcX+JEM7uxIaU8=; b=GxqJddfQMTNd22wUHoKD0PDSas
	GHSLFMv3aPr1QhMQ4A+Q5nxgBzUl0wlh819+INBmOHUAfwYzLExLpE3wlQp3TWOxs2u5kA9J4T1/u
	M2f/KpYIGhxjBC5jJZJjKKiL7x+yu7STbg+aFiegm3s5tLr10G1Zf/NPX6W01+nsts8ki3qQHA17e
	9xf+tXIoxkpCm69iwLN25kc1e0iXOZSlEM+h24CR8u7mMYVA9KhBn7NN1yVxLBA6lyJx93xLwDZKb
	hdxA+NKWemDRjVq3V85I5Tp9LGaLgue0NqSKz2SnAqFxC3lIW9GA1bUbbdTLPx7aRgOFPqu0wV0PU
	6UD+zF2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB6ti-00BtW8-1H;
	Thu, 07 Dec 2023 05:26:06 +0000
Date: Wed, 6 Dec 2023 21:26:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: set XBF_DONE on newly formatted btree block
 that are ready for writing
Message-ID: <ZXFXbhzVv2wlBEbX@infradead.org>
References: <170191665134.1180191.6683537290321625529.stgit@frogsfrogsfrogs>
 <170191665178.1180191.7709444254217822674.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191665178.1180191.7709444254217822674.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 06:38:50PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The btree bulkloading code calls xfs_buf_delwri_queue_here when it has
> finished formatting a new btree block and wants to queue it to be
> written to disk.  Once the new btree root has been committed, the blocks
> (and hence the buffers) will be accessible to the rest of the
> filesystem.  Mark each new buffer as DONE when adding it to the delwri
> list so that the next btree traversal can skip reloading the contents
> from disk.

This still seems like the wrong place to me - it really is the caller
that fills it out that should set the DONE flag, not a non-standard
delwri helper that should hopefully go away in the future.

