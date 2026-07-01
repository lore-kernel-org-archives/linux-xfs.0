Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85EB32470E
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 11:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903700; cv=none; b=phXFT1Cja2vJI31tXVhws0bZtt2RQQq6g0UihIAuHZL7U98NHhKaP9TshIQd+GPlNOM7S3PfV277Xgpy60CB9zDMbFFA57vyYY454YTX7BRTU7A3WHfkE9TW9uE8JYpb9zID3l5VnkiAbu+eVxk6GwKAEG+f1yAYiMMxq+PXe9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903700; c=relaxed/simple;
	bh=ReMviAppF30N+yR99wOTvAXPM0agnJjw+f2izecRSYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YkDyEeLT32P9Bu1vsSqBrQYAGOM8a8Qr7nztYP2b5gHIXdaWrRVHqawma901/gCJyQu6+QSaHBLz05X14Rt+gCSEjGHPt8Gh95TLZ9kCVr0ezyTl2UY+BNpreZJ1DPglnWSbgAG5VnciuNC1HPKgL9XBTFFpvKf+S4HkXV0c9p4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SXOD7Xks; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SXOD7Xks"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/3jq+EPUWDnaZnlrlhjACYha3mLRDhXNXnrxGhYIn8g=; b=SXOD7Xks4WixQocdhPieKapN2u
	xGk7smGMpPMDpCQ1wurm5hYTv6tMF2DK9b4A4nbEvcu37PTJsCjDAAleer/gk+CKgYnnCTMLOOEnS
	VoYcTwbkiPsx6zWRfr5iKCvS9sXxLBDgU9T5BClON2BcYhtBYo8mwnP1S2dzaKDK/E+NTx3zToQjW
	bA3x34AHjB59SlfqY1XJpxYwlbVjgrVwn9OuBrE+fsk7nsjLfus9fGpF/xe6IBBB94gSHTC8DXKI8
	X2JJ3Metqjr4NNUucJ2CxCarlPOsr5JngixM/uQd7hV7Iw9UW+CLDSWu4t2Kk1T+YNkHHl8lfnRn1
	+gdHVk2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weshG-00000001Or1-1vBh;
	Wed, 01 Jul 2026 11:01:39 +0000
Date: Wed, 1 Jul 2026 04:01:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH] xfs: fail recovery on a committed log item with no
 regions
Message-ID: <akTzkmAwaDkAK_mM@infradead.org>
References: <20260629162452.2566242-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629162452.2566242-2-bestswngs@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 29, 2026 at 09:24:53AM -0700, Weiming Shi wrote:
> xlog_recover_add_to_trans() turns the first op of a transaction into a
> recovery item.  If that op is a bare transaction header
> (len == sizeof(struct xfs_trans_header)), xlog_recover_add_item() adds
> an item but attaches no region, so it sits on r_itemq with ri_cnt == 0
> and ri_buf == NULL.
> 
> When the following op is a commit, xlog_recover_reorder_trans() runs
> ITEM_TYPE() on each item to look up its ops vector.  ITEM_TYPE() reads
> *(unsigned short *)item->ri_buf[0].iov_base, which faults on the
> NULL ri_buf.  The commit handlers dereference ri_buf[0] too, so reorder
> is the first place that trips over it.
> 
> This is reachable at mount time from a crafted image whose log holds the
> op sequence START_TRANS / bare-header / COMMIT_TRANS:

Given that the log is checksummed this vould be a maliciously
tweaked image and not a corruption.  It would be good to state
this thread model.

>  
> +		/* corrupt log: an item with no regions has a NULL ri_buf */
> +		if (!item->ri_cnt || !item->ri_buf) {
> +			xfs_warn(log->l_mp,
> +				"%s: committed log item has no regions",
> +				__func__);
> +			ASSERT(0);
> +			if (!list_empty(&sort_list))
> +				list_splice_init(&sort_list, &trans->r_itemq);
> +			error = -EFSCORRUPTED;
> +			break;
> +		}

That being said, handling this sounds fine, but duplicating the
code for the listing splicing feels a bit annoying.

Also I think the ASSERT(0) for on-disk corruption might be a bit
backwards these days with all the fuzzing and injecting.

So maybe as a prep-patch remove the existing ASSERT(0), then as
a second prep patch move the list splicing after the loop:

	if (error) {
		/*
		 * Return the remaining items back to the transaction item list
		 * so they can be freed in caller.
                 */
		if (!list_empty(&sort_list))
			list_splice_init(&sort_list, &trans->r_itemq);
	} else {
		ASSERT(list_empty(&sort_list));
	}

and then add the new check.

