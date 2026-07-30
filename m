Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFFD3B1EC8;
	Thu, 30 Jul 2026 08:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785401304; cv=none; b=Yc2BJCisdhcjGNz9XTcrdMtXH0HFZpWIWdVopavxuZbihCAwbE+Jr+0nnhiqq7/p/llgO7oppJSNZkkAKRg7Z/DeUEK8eaKrHsndfdWTr62xdP56ymk72n4K0KkSpykL0yQQS/cug11+O0If8G3LgiB1bZYaoL9IG6XYJQp4F7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785401304; c=relaxed/simple;
	bh=BtakAAUve3PMA5IFXydgJqW5IjeTYWoQy6pdrZ/FHZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qF5Wv6eWRv+NlZFgBUSLKVMMH4xs9flGfJiQsEe7X2061r94lZ3y05zC2Mp3xDAGCe0l+5XeK1i7TuEpcohppdQwOqkaXG4LBcOzhssuypZH6Mnk5GobMPmJvFo2DTJU95F1I0KFrqbzBCqvbbEyHhRo3B/mzE1vDtgBrI43MpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YA5e8whR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YA5e8whR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+A8ytL8cZbxsJETSDW8OclQQmUjO4XfXPb79wrZwXhk=; b=YA5e8whRlESW6P8rTnLRPM7bq4
	2m1q+Wzd1vXMZeyhBPagAIb4SgyZeHKh2ITZtC+Z63KBnzeiV9l4RCKbQ5L037/KPZxQ0TUZEN8KH
	GPX/lCRfbyao2cM4cBARrQhy+t3OsufOt2S7Nxzc7y5ABuoYw/FR1oQYSYCtFINAPvwo3tZhbr1CN
	+rIPf/yGPq3iXWrxwqZzbtdRo3pPtWasLeUzHTmBFK0yt2Hml7GvCkgxEd95z3qGO9nRDfpYJS3DL
	K/a5jX5ya8jU6ircrT3NjRm94q4zQTB+8IkXDkDHoL7IPiRUbbciOsg/KplSaaaICxMsd4aQeWKeh
	rUvQIdvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wpMRA-00000009v0N-30xt;
	Thu, 30 Jul 2026 08:48:20 +0000
Date: Thu, 30 Jul 2026 01:48:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: hch@infradead.org, cem@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhongling0719@126.com
Subject: Re: [PATCH v3] xfs: use file target for post-log fsync fallback flush
Message-ID: <amsP1P4IFexdfg4X@infradead.org>
References: <20260730084236.173288-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730084236.173288-1-zenghongling@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 30, 2026 at 04:42:36PM +0800, Hongling Zeng wrote:
> xfs_file_fsync() has a fallback flush for the case where the log force
> was a no-op, for example fdatasync/O_DSYNC writes that do not require
> metadata updates. The current fallback path is expressed in terms of the
> main data device and explicitly excludes realtime inodes.
> 
> Realtime files with a separate realtime device are flushed before the log
> force, because their data must reach stable storage before the log commit.
> For the internal realtime device used by the zoned allocator, writes are
> out-of-place and update inode and bmap metadata from I/O completion, so
> the overwrite-without-metadata-update case does not apply in the same way.
> 
> Even so, the current fallback condition is inconsistent because it is
> expressed as "non-realtime inode on the main data device" rather than in
> terms of the inode's actual file data target.
> 
> Use xfs_inode_buftarg() to obtain the target that stores this file's
> data, and issue the fallback flush when the log force did not flush
> anything and the log target is the same as that file target.
> 
> This preserves existing behavior for regular files while making the
> fallback logic consistent for files whose data target is selected by the
> inode.
> 
> Fixes: bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> Suggested-by: Christoph Hellwig <hch@infradead.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

