Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6568F3E8C5A;
	Tue, 31 Mar 2026 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774969503; cv=none; b=Ka2qHLtKootVBMmZWTk6Q0ICRUl+5jARgQyiUuETE/8Hs0WvnERLsIr2QywMtQaD7TVSW2UfPR3Wrc50O+NKkF/7YBiqc2G+0At0p+GkXSMTs62jWdovZVH8r+3q0ol/BEBVbjtQbuE6+DKZ5Ijt6OLRw4qO847QPmLwJXd66uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774969503; c=relaxed/simple;
	bh=1gxSqJB4cM0b6hbdsMAvU1cUNSpAqVWj9iaNxZm7Tyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taCTNeenQw9yFiN1Xz50fE+WY/G4tNwN2fkVpjUH5sCdnpmiXubnOQiR/a7t6w4OQSBzOuSYxvvOYU5fdXpE+vZ4/tO9AxiWBwXyhz71AHNS2s+s+bFJx5J+LiSDzjxA+IcxE5WZcCf7jjg3DPBRwkCTQvKrJ+Ct5R2Vz7juxDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eEKF2Vvz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eEKF2Vvz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W21krHdEirq0KODahs12rERsjoRq7XybNAvgs+seNXM=; b=eEKF2Vvzlz/S/LVCGvLb9/TM64
	S1CJUlDrGxbzwqaonGtyij6JRVkM6mTfSp06qKRL+r/4XQq5DFDCkcnfaxFavlC7WYmCZn7NlpKfx
	DOozBCnX2mB5Be9eTIEfcHK2gPuFA6ZhQcTpGsfzkGgwyLcsPYqAe6wcNVq+k+dVyBNHVaMn1fZAY
	C+pDBWbXPA1tSfmTk5Jxl4RiSClBoufD/bYRoZnh+qHeTInkMIVHdxfpq/biu7yNPnqUccyh2TTH9
	/H3jfCIcnlC5aZQt6lM8A61c2J1pZItVTdwaxVz736wkfPagMt3Xmlqj6mZHnVMOkO94PJAEdlhN7
	XlKu54YQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7aeL-0000000D91m-2EOH;
	Tue, 31 Mar 2026 15:05:01 +0000
Date: Tue, 31 Mar 2026 08:05:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix integer overflow in deferred intent sort
 comparators
Message-ID: <acvinWBQveITnmfK@infradead.org>
References: <20260328173407.43057-4-ytohnuki@amazon.com>
 <20260328173407.43057-5-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328173407.43057-5-ytohnuki@amazon.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Mar 28, 2026 at 05:34:09PM +0000, Yuto Ohnuki wrote:
> xfs_extent_free_diff_items(), xfs_refcount_update_diff_items(), and
> xfs_rmap_update_diff_items() subtract two uint32_t group numbers
> and return the result as int, which can overflow when the difference
> exceeds INT_MAX.
> 
> Use cmp_int() instead, as was done in commit 362c49098086 ("xfs:
> fix integer overflow in bmap intent sort comparator").

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
