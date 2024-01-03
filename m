Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EEA182A2
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uKcs/iMB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wRebWYCc655O+FLIow316NTa/y2yEETA6iE+HEsvp3g=; b=uKcs/iMBRPMRSLlKYr4lblGZGt
	oGpzYU2bLrlRWmk26iLin5EfXkH8nzUXGhmLJaZewewDGvcQcReKbLLq1FRkxMWhdXH3kQONunRi3
	TbUdHVADYd4OFLnnEjNPLoBMwyDQlcoxe0Z6TL5dqf75tJLayDKa+xvh0Tzuj8KEPZ2Z8J/Ul7wqE
	2hoNN8PNB23BMwY66BM1m77d3A2jtAyGR8o7uWRTOeUx5OVKDybSih62XVCQr8ZqYDvLT1O966Jq0
	Of3WccZePOkqpNxvo7RlwUaZ/Mm89L4pH6uXzTq61LAszpXY1RFmHk5/uL2t7GG/bzd+EXaK470l+
	xbnQBHwQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwYJ-00A4N0-2u;
	Wed, 03 Jan 2024 08:24:39 +0000
Date: Wed, 3 Jan 2024 00:24:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: map xfile pages directly into xfs_buf
Message-ID: <ZZUZx6aNB68kbRLo@infradead.org>
References: <170404997957.1797094.11986631367429317912.stgit@frogsfrogsfrogs>
 <170404997970.1797094.13056398021609108212.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404997970.1797094.13056398021609108212.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 02:35:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Map the xfile pages directly into xfs_buf to reduce memory overhead.
> It's silly to use memory to stage changes to shmem pages for ephemeral
> btrees that don't care about transactionality.

Looking at the users if seems like this is in fact the online use
case - PAGE_SIZE sized btree blocks, which by nature of coming from
shmem must be aligned.  So I'd suggest we remove the non-mapped
file path and just always use this one with sufficient sanity checks
to trip over early if that assumption doesn't hold true.

The users also alway just has a single map per buffer, and a single
page per buffer so it really shouldn't support anything else.

Writing it directly to shmemfs will probably simply things as well
as it just needs to do a shmem_read_mapping_page_gfp to read the one
page per buffer, and then a set_page_dirty on the locked page when
releasing it.

Talking about relasing it:  this now gets us back to the old pagebuf
problem of competing LRUs, one for the xfs_buf, and then anothr for
the shmemfs page in the page cache.  I suspect not putting the shmemfs
backed buffers onto the LRU at all might be a good thing, but that
requires careful benchmarking.

