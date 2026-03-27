Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9B238B7DE;
	Fri, 27 Mar 2026 06:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774592846; cv=none; b=BkJDm88pMrqw5ZVHmfpwKJ4LzPmdMV/5rHoWofVmnHFUrtx9QCd39uWs9Cv/qBpjc7Zr07ydij+uj7oIGNTpRLt/nGZyw2r+tjZjIIOMSqO4yglOtW/47uMW4OLNzx9h8OHHqrkRkilZ/gs/8Ty1y+sh5MKxbuBpH55ksE4Plp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774592846; c=relaxed/simple;
	bh=HC+Bdkwl7K6LiIyuxB7VtyPJr1cnDQ3hdaukOnUHjfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lKzuO4Pt8MOOPvfS/jwvZG2TUT8nOvjtyaPCQv+IYxBDcoDX8o0W/zquAcs5EUjYR9PAEGaETdHRDxXpesc00U8prDGilxIoU1TJt8K3c1XMLWiRAtsK5FRCE5dPdI0+EonvBxXiZEeZ/m86LBl9G3fwbLcVlEUHk9OelZNeC4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3ozzZMNI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3ozzZMNI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G7w/DjtHh6UU1dKA9LsKeKfhy2A9T6huT5mWVhBMMqQ=; b=3ozzZMNIwG7iBmBHIggRh8/DLu
	8x+FlaRDvryUNTt7u7s70BsPfBhzLzqJcly52Sj8EZXyBrLhdpCOCL8iuerychQUTJuHQGPkibYdX
	GS2ScIm0cdDILYGgjoitivuR6YBcB0QRpTlt6rYa7PHKjqDsmyqNbCO0YC3wdURLu5RXaTEPQc5c1
	Gk+hNp2DXUh+QSndqK8RULVt5f1o2qqnQA2d73cN673EvDHwModjWdMqCjgfM4BPlkCcKKq5jhfRz
	4gGaPd7jnOf2B9gVXAEIbxNgQMKIY9VTlhJmAk3gYl/596taDXr+MU4G1eZOZijYf73mgUF8AiCC8
	1lq7qTxw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w60fA-00000006p8d-1NCq;
	Fri, 27 Mar 2026 06:27:20 +0000
Date: Thu, 26 Mar 2026 23:27:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
	Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acYjSMkz9MdWQKoJ@infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
 <acRG5f9QjdEKg2JB@dread>
 <acYe1oCInkDLWGGu@infradead.org>
 <9e8061a5-980e-4e6a-a349-8a89f9eb1ba6@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e8061a5-980e-4e6a-a349-8a89f9eb1ba6@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 27, 2026 at 02:24:02PM +0800, Gao Xiang wrote:
>  - use EROFS directly, in that case, we still need process
>    contexts to decompress, but due to Android latency
>    requirements, they really need per-cpu RT threads instead,
>    otherwise it will cause serious regression too; but I'm not
>    sure that case can be replaced by this work since workqueues
>    don't support RT threads and I guess generic block layer
>    won't be bothered with that too.

All of the I/O completions should be latency sensitive.  So I think it
would be great if you could help out here with the requirements and
implementation.

