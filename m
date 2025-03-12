Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C66F1F426C;
	Wed, 12 Mar 2025 07:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741765168; cv=none; b=XnjU4eQcC8Ww3+VgYm1+GxVlzv8LFaCha9kSGn1a4kpq0fUkCtOa1S5k+7dkqaNPiaJ/sNZtTG2cBSJMhHAECLGUPyrPWbey7glzegI0+gOvoaHEEc/cRDpdU83RqcXY58wjAPxBDxGj5/tLH32+0pzmQ2XLHVsmmhQ2K0Ua9Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741765168; c=relaxed/simple;
	bh=7+eQ/bxV/FsnyJfAPNsCIuzNkF8f1My+Qx/DwvN2qfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtdSoGiQqtWaDCjlqqTSFRF3nNiKFF99IU0gMnWxa2PSkmzcZ5Yg8K/z1Q5GZqzwPRlhpp6tfsLn9I+Nxvfn7BUzdrb0mkFJVU54Px7uLQIyO4mLFswqqC7DLsq8DTi2ryOxLx/0j2WzxiVfMLa8jHyuAtzg9gNca4haAuoJ70Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h4BhQC2Z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h4BhQC2Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SV+J3vjGNu8yosP3unAvnQxwC7lVZQJIuTPPqse8sjQ=; b=h4BhQC2ZNcoyI9VUbRp0/piVd6
	v1ptmJFhsgZNHEEr0Jlsg1FCyLwugyumNlZGjo9xZvfig7PUj8iVi5NuQ/GeOJzRgvGgX5rb2oMAo
	VQ5Ef1IlQNbAsF9nIMx+0q7hCyZ0YczxsyZwW+cHmr6irlyZvtQI/5plTmASVXHH80RxoiGb9tDYO
	XWymJey2ZA/jrBiNandBfnSBT0da6qIj9VztLHtVfnmcFF9K2cd8pPautbX8i/a/16KE/yLP24zxW
	8SkY33oRrfEAEG8pskTpCEiIqIjPqnpeEB6XfxoWAgRLGvk/oo58pKP71QbSJfc0ITrhV4ulfMlqs
	xJLqr3AQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tsGgY-00000007iqM-2hD8;
	Wed, 12 Mar 2025 07:39:26 +0000
Date: Wed, 12 Mar 2025 00:39:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: John Garry <john.g.garry@oracle.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, martin.petersen@oracle.com
Subject: Re: [PATCH v5 07/10] xfs: Commit CoW-based atomic writes atomically
Message-ID: <Z9E6LmV1PHOoEME7@infradead.org>
References: <20250310183946.932054-1-john.g.garry@oracle.com>
 <20250310183946.932054-8-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310183946.932054-8-john.g.garry@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 10, 2025 at 06:39:43PM +0000, John Garry wrote:
> When completing a CoW-based write, each extent range mapping update is
> covered by a separate transaction.
> 
> For a CoW-based atomic write, all mappings must be changed at once, so
> change to use a single transaction.

As already mentioned in a previous reply:  "all" might be to much.
The code can only support a (relatively low) number of extents
in a single transaction safely.

> +int
> +xfs_reflink_end_atomic_cow(
> +	struct xfs_inode		*ip,
> +	xfs_off_t			offset,
> +	xfs_off_t			count)

Assuming we could actually to the multi extent per transaction
commit safely, what would be the reason to not always do it?

