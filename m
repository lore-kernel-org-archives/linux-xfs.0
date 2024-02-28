Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD7115CD5C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709135074; cv=none; b=LKO7npTkBIqwT527sxOkCpz9oWdtji4xDOjhh42Fw9vC2ztQ9CJ21DLMHs9kcI2Hc3S4x1/UblWOH/GpPENJ2ZaSNJzKyfbAw38cO+dUFPhu6hgo1L5Pk/fJc6xzMlq0nx7yhot3sAxB695r+u9+I2aXy0gsw9F2L6H69gG5rRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709135074; c=relaxed/simple;
	bh=TCIkT1SNUBHOD5OVXxx2Lz9To5mlkV4Br27S8Jho7HE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNarRR1/RFvJnTXzgZ8lGySg9mtn/08xvqdeM48RFh0tx5sIEbgq+jp6yMAemn0klA4n0fyl+q4OZAZ/6+Pw2zu5bfsR/Q+nTzB+DxAMsByt8qIBQk74rqXxV1EvI76zhhZwrYmfeqii/7nONRftwmYAhay+2dKtVlvGNfaqrSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MNDGCgZy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MNDGCgZy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=afZwvLLZ2HPieGgd+lEbJPJgx83LDZ7fBePeLkqZmj8=; b=MNDGCgZyHIZ//LuuRJhPK8zNNC
	9QlZtgUxNzhf8n/Td7hBa5HDDlpwlGW24iFP99CI4i7BvoFoPL2eMchttNG1h2aWab7C3edvY5XuM
	AMzJzlaSs+1JJFo3D1X/hcwLiMNnIE60SRcunYAJ7GvNQlDpJ1fcQ2QgjU5bCGXwN6B6B+XTATwY2
	5GFlU4XsNcWSTZhoZUBO0/N6CvedMic9W2m169UEfCpOTTPPUfml2kcMD3LkD/uS2D4LANKkvLTcB
	CLXgTGQZe2PPo3mtOzEhS0/ZtK2argtTwO65nKVw6m07bpVmYvC7xJ0V+mnPHzAxNwtltvJT+TU8G
	DVHVYsKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfM6i-00000009xVd-0q53;
	Wed, 28 Feb 2024 15:44:32 +0000
Date: Wed, 28 Feb 2024 07:44:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/14] xfs: introduce new file range exchange ioctls
Message-ID: <Zd9U4GAYxqw7zpXe@infradead.org>
References: <170900011604.938268.9876750689883987904.stgit@frogsfrogsfrogs>
 <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170900011673.938268.12940080187778287002.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 26, 2024 at 06:21:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Introduce a pair of new ioctls to handle exchanging ranges of bytes
> between files.  The goal here is to perform the exchange atomically with
> respect to applications -- either they see the file contents before the
> exchange or they see that A-B is now B-A, even if the kernel crashes.
> 
> The simpler of the two ioctls is XFS_IOC_EXCHANGE_RANGE, which performs
> the exchange unconditionally.  XFS_IOC_COMMIT_RANGE, on the other hand,
> requires the caller to sample the file attributes of one of the files
> participating in the exchange, and aborts the exchange if that file has
> changed in the meantime (presumably by another thread).

So per all the discussions, wouldn't it make sense to separate out
XFS_IOC_COMMIT_RANGE (plus the new start commit one later), and if
discussions are still going on just get XFS_IOC_EXCHANGE_RANGE
done ASAP to go on with online repair, and give XFS_IOC_COMMIT_RANGE
enough time to discuss the finer details?

> +struct xfs_exch_range {
> +	__s64		file1_fd;

I should have noticed this last time, by why are we passing a fd
as a 64-bit value when it actually just is a 32-bit value in syscalls?
(same for commit).

> +	if (((fxr->file1->f_flags | fxr->file2->f_flags) & (__O_SYNC | O_DSYNC)) ||

Nit: overly long line here.

> +	if (fxr->flags & ~(XFS_EXCHRANGE_ALL_FLAGS | __XFS_EXCHRANGE_CHECK_FRESH2))

.. and here

> +	/*
> +	 * The ioctl enforces that src and dest files are on the same mount.
> +	 * However, they only need to be on the same file system.
> +	 */
> +	if (inode1->i_sb != inode2->i_sb)
> +		return -EXDEV;

How about only doing this checks once further up?  As the same sb also
applies the same mount.
