Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19A226ED28
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 06:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768804509; cv=none; b=FUF97GXmLLF5DbUHPc9+lIfN5EFKWPYbtlHWUazzeXlX8+EqJ0Vx9FPcgzDODqOkKNGtaia4yU070rZcF8PoYK1V3MEnfs/F57w82mkWwD2zXKoQ4UggHQRQ12knVrbTNKianFtAgrm/xkomMAPLpHnGf5CDNglCo8kdh/m4v+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768804509; c=relaxed/simple;
	bh=vZODrPLwb1o/c9VM+OsDbp7t6E+1jdxh09baywZyNQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tvNS00YXNhiibo65KMgygOWa3dNNqZ53eU+WNjGylwJ209NkHRq45SsYeZ3oKX7BiXxprqboCpDn9URNFbxUEh9cp9F2PBDsnj5Fb9FM7n6BO6fOM/x4akNnZLvnOQLPIdSwpYMvf/OpiiGkaCUBAqKrhPlykph9OKszsiC/GXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1tZkJFpT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1tZkJFpT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ve18xJiGkCCwvCKhn779s+mwkmUcdLQY24PqLCctcmk=; b=1tZkJFpTJMPeqjmMUY5OzEpmQ3
	13Fpdos0CAkaGhYtWGohw8VBT52nLtGps0CTorHYttyFAunoGGl75Wa5x56w12ZK8gUeelQG7iRs4
	KKTJ+2X/SIJ8PDDTuS1lvM7DgfnquCNFIY8RpYiv2L5c4pXESIGWT6P4whzmO6ac+twXL6mQpc1tr
	9it8H3k94pVD/A2qUfOc9apTFG/bfrnpC2gglm1/NOBq5rVBMaOAynzkK9z6KIpKyKkTvk3jC8cMM
	gPtDQRkXvnk9vnFya5ExVQF0aBQ83hiK6JID2CN/f9YixcIBqy1e2EheXKB5TFmxRg6XChPEO3gsu
	7jx9SOMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhiqw-00000001PJM-15cM;
	Mon, 19 Jan 2026 06:35:06 +0000
Date: Sun, 18 Jan 2026 22:35:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Wenwu Hou <hwenwur@gmail.com>,
	linux-xfs@vger.kernel.org, cem@kernel.org, dchinner@redhat.com
Subject: Re: [PATCH] xfs: fix incorrect context handling in xfs_trans_roll
Message-ID: <aW3QmibHRf49gZYd@infradead.org>
References: <20260116103807.109738-1-hwenwur@gmail.com>
 <aWpYhpNFTfMqdh-r@infradead.org>
 <20260116161133.GW15551@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116161133.GW15551@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 16, 2026 at 08:11:33AM -0800, Darrick J. Wong wrote:
> Also it might be a nice cleanup if we could avoid touching the PF_ flags
> at all, at least if the transaction can be rolled successfully.

That would mean passing a flag to not clear them into __xfs_trans_commit
and xfs_trans_free.  Which sounds pretty ugly to me, just to avoid to
clear and reset a flag.

> 
