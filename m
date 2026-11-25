Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585698;
	b=nGl5VI65Cy/bOCUCb26HciyAz12N6E8CIjEhrHxwjUZnbCJZo9w8zZvFt8AMSBw00EQA
	 F2rr1s3Xat+m0Nf+B4Vv5ralXaI4p2Q3NIGYRIhlcCDGuzWQJAh6sckuMhm1c8ACtgI/c
	 COQ8BOxmdxx5EfQZHvYk9WalerXFSfsBdn8vzEcKuAPyspFJpxdhteahAoefl6BiCfVeM
	 dkN345UXoX9Lh1OTcynm2Mz4ya2bSFOJT++96se/8ZSujNbR+J+YX5aGkDETpy4tXJa1G
	 f76tuY/fluwaPBLC0jICM+rBhyCS1kTyI/DBaSz6hpEpZQm27Q24v8rFmR2NT9FVf8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585698;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=XMTTnUVnekXsBCzMHYIoQgsgJRY5Zj+8OZvvB9sy4rI=;
	b=5UhbhU51OPFf1TLvZpE5isKSE9shpywEtHR9reIhHEda5TW6A59mhiDZoKhHLqsLAfDD
	 x8Jl2ez+SgbW/+KtjTe/ZS3zZoI1YT5fzxp467qOJlZZEjxKGVyAMtMwsdekXGI7YA0T6
	 ovV7zfsjfF6A+D9WNVbySNNjNYtu/9XjMOsRDkrqL9w5gB5+kr3wJvn3SZUWwCu9TWXeS
	 UUPzIhTXVwVCXwGhwC7fz85L1VqrHOASHkjNJg5VmsIGIW9oCqBiY1DFMeKwJvwTjRebA
	 9kaXLnAg/K95+0IaL9qYxfMla2tGpnucdhyoVp1u+nIZw+8K7lty/RBpKkAlglbq1bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136A4606A326;
	Wed, 25 Nov 2026 05:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 136A4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 686F368AFE; Wed, 25 Nov 2026 06:48:14 +0100 (CET)
Date: Wed, 25 Nov 2026 06:48:14 +0100
From: Christoph Hellwig <hch@lst.de>
To: ernest.borowski.git@proton.me
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
	Baolin Liu <liubaolin12138@163.com>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng1024@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/11] iomap: punch out a run of clean blocks in one
 call
Message-ID: <20261125054814.GA20604@lst.de>
References: <20261124-b4-ntfs-delalloc-fixes-v2-0-f394c800ec03@proton.me> <20261124-b4-ntfs-delalloc-fixes-v2-1-f394c800ec03@proton.me>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-b4-ntfs-delalloc-fixes-v2-1-f394c800ec03@proton.me>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 24, 2026 at 11:49:35PM +0100, Ernest Borowski via B4 Relay wrote:
> +		unsigned int next_blk = ifs_next_dirty_block(folio,
> +				first_blk + 1, last_blk);
> +
>  		punch(inode, folio_pos(folio) + (first_blk << blkbits),
> -				1 << blkbits, iomap);
> -		first_blk++;
> +				(loff_t)(next_blk - first_blk) << blkbits, iomap);

Overly long line.

Otherwise this looks fine, but did you test this on ext4 and XFS?

