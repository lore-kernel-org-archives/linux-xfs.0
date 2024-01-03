Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9753818032
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HE4vAIvy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xCyzFdEXNVWwcu7HO/CZTaYtwqXjuU7WlohFfI4n5rg=; b=HE4vAIvyXeBUOh1RRBIVF1A7sz
	yFfWjHEtNCJ036M9phRGE3Jno+xheD7DCnLOVn/eoegI3B3t/uT7zTKf7KLxrnWdWOb8cZEOY0OU6
	R4AaDDJfr4RHuoxIesqIu8nC2RFdXlWOc4Pb9lUUm3YNr1jJBWRWmOxzYHFmF//E0DPTvrcTS/AKv
	IFx5eQ3Zd0CLK0ffrC0Jr0h/9u3Xavn9YrSa41JXq0jXE3SCXzTcgunixzY9hvIzdUJn4bYthG8Qs
	1/kMHLVjxkPMisQOFVRhHSwnM2hEZYL2Oj0JW+kdQ3UB2oGpcfP0LnpyIY4aw7qtZeH2LpeiS7oce
	mwzqupTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKwsm-00A7Lx-19;
	Wed, 03 Jan 2024 08:45:48 +0000
Date: Wed, 3 Jan 2024 00:45:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: use b_offset to support direct-mapping pages
 when blocksize < pagesize
Message-ID: <ZZUevG77RPkwNG0x@infradead.org>
References: <170404837590.1754104.3601847870577015044.stgit@frogsfrogsfrogs>
 <170404837630.1754104.9143395380611692112.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404837630.1754104.9143395380611692112.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:40:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Support using directly-mapped pages in the buffer cache when the fs
> blocksize is less than the page size.  This is not strictly necessary
> since the only user of direct-map buffers always uses page-sized
> buffers, but I included it here for completeness.

As mentioned on the main shmem mapping patch - let's not add code
that is guaranteed to be unused.

