Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5D757895
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 08:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706601945; cv=none; b=DR/+PZTsv9IWDa8oqnkewP46ejWHYWG8hQ7+HcZENPid++rmIpznfkUn/xqkiITSwU7M1oRaR7sg84jpMVuGmRff3d7QnJks8ucz7i3F+OCUCLxQ7CE7ufTiZtBX342K/n+1irhPAG8JzK4a+eV0TEaFhRbXV61zbNO00OZEHuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706601945; c=relaxed/simple;
	bh=jPHCpyjUHn2UxRCCuNAiJ3szIgj/c/lGSc2nJz2Y1sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1QB1myAYucyJwAgCooyuSh6IEQJSPSpMnwp7IMTCiNznzsff9oCusPu4Md5cTr8hcGfjYLhA8LKw1V0Y36JS6ib1+rBhjIJk3AChvsp2vHgNaQWD+k56imIcjNQnPtposoZxKOph/9+Hmr1wMeSG6MTsMTy6KipNZaKvm4A7ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ACC2C68C4E; Tue, 30 Jan 2024 09:05:40 +0100 (CET)
Date: Tue, 30 Jan 2024 09:05:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/20] shmem: document how to "persist" data when using
 shmem_*file_setup
Message-ID: <20240130080540.GB22621@lst.de>
References: <20240129143502.189370-1-hch@lst.de> <20240129143502.189370-8-hch@lst.de> <ZbiR1Jj0gwxAPVSA@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbiR1Jj0gwxAPVSA@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 30, 2024 at 06:06:12AM +0000, Matthew Wilcox wrote:
> take that out as part of the shmem conversion to buffered_write_ops.

Oh, and I think shmem is actually a good candidate for
iomap_file_buffered_write.  I think it just needs to
plug shmem_get_folio into iomap_folio_ops ->get_folio and provide
an identify mapped iomap like the block device.

