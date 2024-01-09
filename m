Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ADC370
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 04:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Eq5Njuaj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=v2F+6cirRzZkPFG2EWuw0kYBRWdxWCqxOrZMSM9u680=; b=Eq5NjuajJBMi5bKyfgq36ZfcIU
	9jZeuBae9LAm5xScnZBcohPh1mvNptRGZVCztdW2ZjieThK3qJoq8g7jvfiInEtnNHTLyRHjB7Bc+
	nS/Y5RHXQgUZcu/udhgZfHVLZugrkfPbxJqck0SegbEIO11u9l4rgDH5roWNVX2xlSf1gZctfmR6N
	s9KFJhYmBpUBE++/ZtrtYnhZFJ4yJk10jnwBmL32+cmBY7Q+MJdNGJ3VZL66X/8jT/vYCbvlKxEZ/
	8j0AfGrKCvXd40+zLXqTSy1LwsD8IgANeuuP0xwyaMOi59qBVS3MIYpLv02VC2blGjqiUKC/Iewg9
	ZIYONKkQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rN3qe-006v1C-03;
	Tue, 09 Jan 2024 04:36:20 +0000
Date: Mon, 8 Jan 2024 20:36:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Chandan Babu R <chandanrlinux@gmail.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix backwards logic in xfs_bmap_alloc_account
Message-ID: <ZZzNQ4/QkDxa0JIW@infradead.org>
References: <20240109021734.GB722975@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240109021734.GB722975@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 08, 2024 at 06:17:34PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We're only allocating from the realtime device if the inode is marked
> for realtime and we're /not/ allocating into the attr fork.

Hmm, interesting how this survived all my rtalloc tests.  How did you
find this?

Reviewed-by: Christoph Hellwig <hch@lst.de>
