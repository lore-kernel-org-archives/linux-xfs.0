Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA345FFA3;
	Fri, 16 Oct 2026 09:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142626; cv=none; b=MyLVJvWegKzNMYzJxKZLBMkNuNQPY3cmpezssPW2hciBMKlN7YTvnD/QcYjrdSw8wZgevWue2Rcyuh9La2eVcIVgQcqCGUfMeMF/7Lh02v84LrUSLK0C58+5rDoCekY9/ZuhfzzK2tLpPD7QrsCsIvqeAxpelQyPR5IJGSmOXis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142626; c=relaxed/simple;
	bh=udkudyfqti5wGQWRR8BSrMTOVOLhnqmvhBWoyQO9U8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1BVksjj34H2V0LwmNUaSh9taVxNU2kdOysiQptfTlt5U3EDI3zFjRB80ZF4fNIItCbQVdWyxKWCCWdxIt8K0fytLQCPgeTCMptaCG7LqvDANXCjj65qDNkj5vi9rd7wcTw4QjVEDSYEy23Rn27wuOpwWvYCl4dUpi642WlM83s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 035E768BFE; Fri, 16 Oct 2026 11:23:37 +0200 (CEST)
Date: Fri, 16 Oct 2026 11:23:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: asml.silence@gmail.com, hch@lst.de, djwong@kernel.org, cem@kernel.org,
	brauner@kernel.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, anuj20.g@samsung.com, nj.shetty@samsung.com
Subject: Re: [RFC 1/4] block: factor out bdev_init_dma_buf_io_ctx()
Message-ID: <20261016092337.GA23141@lst.de>
References: <20261016091919.971295-1-anuj1072538@gmail.com> <20261016091919.971295-2-anuj1072538@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016091919.971295-2-anuj1072538@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 16, 2026 at 02:49:11PM +0530, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Factor the checks and driver setup into an exported helper that takes
> an explicit block device, so filesystems can initialize a dma-buf I/O
> context for the device backing a regular file. The block-device file
> operation becomes a wrapper using file_bdev(), so its behavior is
> unchanged.

Please move hte helper out of block/fops.c, as that only is for
the block device file operations.

