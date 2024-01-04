Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794421CA97
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 06:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qB4HU40u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kESxReSNJhviqxccoR4T/iESkWi+dupPeH2woQsnt+s=; b=qB4HU40uNKmxgPqe5d/DlPqcO2
	Qms0Xq+MTUB2+Or6ZiEn2M4FXy5fgUhnYi2euUQShGd1OpUOnRob2AcQ5k3rQxOdq2w3pg/LBUn9E
	UtdQ54LnhA1jm0fht+M23i0m4RNODmYKYmVamk7ImG6VceF6P2mjk7+AolHs1A5ELjke5V9V8Eax2
	gT5CJkO79WIXVhfWF75SwmD2FqC4BqicCtl1UkCnQ23FSCwltvbNsc6Tp/f9rQUOxs73fn1BSZLzn
	I3M872/LeANnD6/Q68/mS4f46BbcmZmOwvkZftOmSnP9kbVcAZU1cJUvtS1S73Hak8AkkjysW9Mfj
	nxnEHU4Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rLH4j-00CyU8-1V;
	Thu, 04 Jan 2024 06:19:29 +0000
Date: Wed, 3 Jan 2024 22:19:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	willy@infradead.org
Subject: Re: [PATCH 6/9] xfs: consolidate btree block freeing tracepoints
Message-ID: <ZZZN8UV67XGa1J+q@infradead.org>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
 <170404829675.1748854.18135934618780501542.stgit@frogsfrogsfrogs>
 <ZZUgfWT3ktuE9F5j@infradead.org>
 <20240103193705.GS361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103193705.GS361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 03, 2024 at 11:37:05AM -0800, Darrick J. Wong wrote:
> Removing these two tracepoints reduces the size of the ELF segments by
> 264 bytes.  I'll add this note to the commit message.

Yeah.  Maybe just say memory usage - segment size feels awfully specific
to an implementation detail.
