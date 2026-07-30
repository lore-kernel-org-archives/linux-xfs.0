Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE8C38886B;
	Thu, 30 Jul 2026 08:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399226; cv=none; b=d1k7fGLwH69UKEQWUU/RI5sSsjCpFgTCmIRvrOrXFQssf93+vaZg/zhRcEAfSE+fB/6CDIEPz2lgaPGY1keK+5P7ZtbSPe7FsRozSAtWcwjpEx9EAbiqE7QsnPdfG5nc4r7/mj6T0+PWCaLVPZ2yZwMFP+KST3+qsY1Raj72E3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399226; c=relaxed/simple;
	bh=7d+OiMVibrNoHtU7HdP7nPkOx09h2+kzDzC5vlkrKDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QQtXzEK3f/sImy/IGPi6IKAT1W6x6Z7xDV6F19oyLV5WHyHI/Z/YmgqqbyEQOKSfz+GfdNku235vj++l2zevSSVLgvDhWTI+Dn9SxqaihjCsUHXssWCwrBeIYrqyUdlarLiE1HZ6Su9X5tX8XYqfQHm61bMm29TaEhx632kDqIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HXnE18tZ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HXnE18tZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=STnZe2MMCF/BzC03VvW9KYRg64vjJ4C3hF7Nl3+7RDA=; b=HXnE18tZYg3z1yOR/vmkbR0e8+
	owNT0191K6/UHsvHlua/zgTPNh+47Mrlet9VRkD9YOmskNQ/80p4l1obKzRYpCGKFK2MtYU7TtyBE
	QK7pHvVOLyKoFlcEqf53voXwTboFbLoHobPt7cmSzgai4XWYpKfuBTiEBa8cJdaoV2k/2DjgijOrz
	47Y58aaxz3ZmSK/0K3lIEgqq5eMANYzbG5Dun1BhAiFZooTUwdLf1QlnI3zuvXNZB5kjfpSVqgnsz
	B1rb3EeP5hQ3vjcheeUz7cCvXG4m0YUzgFz2zFCUn8ORPE8USQ0kcGerQGWURqWi+FHR+hqLmdE8F
	LLVAXE1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpLtV-00000009pHc-2Lu2;
	Thu, 30 Jul 2026 08:13:33 +0000
Date: Thu, 30 Jul 2026 01:13:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Hillf Danton <hdanton@sina.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-erofs@lists.ozlabs.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 3/5] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <amsHrVCJnuXzeGG1@infradead.org>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-3-3e8e6850068d@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 02:57:53AM -0400, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when a dropbehind folio
> is added. This ensures that bi_end_io runs in task context, where
> folio_end_dropbehind() can safely invalidate folios.
> 
> With the bio layer now handling task-context deferral generically,
> IOMAP_IOEND_DONTCACHE is no longer needed, as XFS no longer needs to
> route DONTCACHE ioends through its completion workqueue. Remove the flag
> and its NOMERGE entry.
> 
> Without the NOMERGE, regular I/Os that get merged with a dropbehind
> folio will also have their completion deferred to task context.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

This seems to be missing the bug fix you identified for the double
deferral?

I although thought a bit how that could be done cleaner, see below:

>  		ioend_flags |= IOMAP_IOEND_SHARED;
> -	if (folio_test_dropbehind(folio))
> -		ioend_flags |= IOMAP_IOEND_DONTCACHE;

I'd keep this flag.

>  	if (pos == wpc->iomap.offset && (wpc->iomap.flags & IOMAP_F_BOUNDARY))
>  		ioend_flags |= IOMAP_IOEND_BOUNDARY;
>  
> @@ -256,6 +254,9 @@ ssize_t iomap_add_to_ioend(struct iomap_writepage_ctx *wpc, struct folio *folio,
>  	if (!bio_add_folio(&ioend->io_bio, folio, map_len, poff))
>  		goto new_ioend;
>  
> +	if (folio_test_dropbehind(folio))
> +		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);

And move setting the flag to iomap_ioend_writeback_submit, and only
for the case where no io_bio.bi_end_io is already assigned.

