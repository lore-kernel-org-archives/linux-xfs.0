Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FA24C65
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 01:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rj4X+21n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 592D4C433C7;
	Thu,  4 Jan 2024 01:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704331679;
	bh=rFYL5B2k9JVe6d+rlqEO/30Eac2fIaK7eBhaHgrtNvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rj4X+21nnk1IwkdaqdRlAmQnMZX9sEY7ckPT/FIzMU+ZBxXWvkO7DXnmHY5to9GAZ
	 E8EkiWl7ZT9n+mw5QBgktb8+hhDE7L3rZJ+ONNJtGFE5lGy1181VkbrrwWeiERh9S5
	 1E4/Wj6aR7TqRwjpl2P2Jiwwhf7VAJx/rabFJ6h4EuaDkxAQMDlR+BfqUCafJo3VOu
	 LdwXNKzlUc94Wq8C2sO+XavlYNhsHrU44bWrXqTyx0N8YXbt/ActVadT2Ll28dmBrK
	 g3EhqkOZU6qaRv5qpSLDWoW1OiV0U6fJ1ws/PBX7osIGdnFUAb4pu2xBUCygjHg7TJ
	 alCTBd0xrkVCw==
Date: Wed, 3 Jan 2024 17:27:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: use b_offset to support direct-mapping pages
 when blocksize < pagesize
Message-ID: <20240104012758.GO361584@frogsfrogsfrogs>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837630.1754104.9143395380611692112.stgit@frogsfrogsfrogs>
 <ZZUevG77RPkwNG0x@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZUevG77RPkwNG0x@infradead.org>

On Wed, Jan 03, 2024 at 12:45:48AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:40:24PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Support using directly-mapped pages in the buffer cache when the fs
> > blocksize is less than the page size.  This is not strictly necessary
> > since the only user of direct-map buffers always uses page-sized
> > buffers, but I included it here for completeness.
> 
> As mentioned on the main shmem mapping patch - let's not add code
> that is guaranteed to be unused.

Ok.  I'll drop this one then.

--D
