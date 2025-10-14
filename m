Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54312BAF9
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 04:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760415230; cv=none; b=ouA5IizhQV4o8JY2MUTgWyJ+jDgvwFilY+jeW0VfMEVI28MmxOBcuem+REdeIQhsGYq1HDam7NQLVKxF/rKBxkpJARxkolgOtKU1FOWLw04buHMhnokd9SUqzWqCfQLSsANdwrtZF57t73abMt/2dXzLHvKIUErNiv6UlTm2x/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760415230; c=relaxed/simple;
	bh=VlAa40GHArXnP5H1ZUdveVsH2Lt/b0NhenIv41ZKdTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TkxQqJ1/ojt9b0lSWM5UrQac1r4bL10GaJUw5m3AXZm9BYpK20N2UFoRAxSSgrTD5TI217eIvKRBALX8uk8xtOAVnc9OQ/dyJud76BV55ggx59TPhAueVdSc2vzaiSaoCDfa+JGXFSFq29iPlTIqoVjw3kRtXXRRox6SW590gGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aRLA8L9s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aRLA8L9s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hHoNDWun4+lKqVtMC4htHxTx1tih+tKF+urOeSsmKp8=; b=aRLA8L9sBpPa8Lfy6ZxRx+MZz7
	kpro6/VTBR7sX9wA8ArGwwZ0D7c4dBFZVluGvlv939+1/PJJCES80lg1fNUHJwagYzIPP3U97spBQ
	kwFrN0T4c4q0I6ymSwxBpfKQ9eeciRoHBaPYYj9/jE63v2OyFy16Kbm8qyp1cYn1c+0zxRfHntWDG
	MwyUaB8STjYjLtFpoy5gkLqkldubpegyPsQ6Y352DkRXexwRIj19krv5O/VgOx9S2XFWBS6x2V76E
	6p7bqf8hyuUFkIpy+KMnvb1b+zHSX74dV4ZypNDWa9vqAgB51EFcly7rRb1mVxpNTuMvw6e5CZiTn
	6bve9G/w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v8WPy-0000000F5hz-14ax;
	Tue, 14 Oct 2025 04:13:46 +0000
Date: Mon, 13 Oct 2025 21:13:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Carlos Maiolino <cem@kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: don't set bt_nr_sectors to a negative number
Message-ID: <aO3N-pndkWtbkawz@infradead.org>
References: <20251013163310.GM6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013163310.GM6188@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 13, 2025 at 09:33:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_daddr_t is a signed type, which means that xfs_buf_map_verify is
> using a signed comparison.  This causes problems if bt_nr_sectors is
> never overridden (e.g. in the case of an xfbtree for rmap btree repairs)
> because even daddr 0 can't pass the verifier test in that case.
> 
> Define an explicit max constant and set the initial bt_nr_sectors to a
> positive value.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
