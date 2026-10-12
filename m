Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CB33AAF49;
	Mon, 12 Oct 2026 12:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808956; cv=none; b=Hc7JyET90Nskqd8YxGg9JPK0eMrg0CYeSACJThm8P5sSxBdEp+4FVPKKlwBh92jExkRw6XsvSixVKKtvGRJolC48rPnrDaAaOnYF9Rj62fPOWBk9nw3dOhm92wiNQ1m8b/ARW7tXvpIn3qJH6y0dkMznZakjYRTbz1XzBu7PrpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808956; c=relaxed/simple;
	bh=+e1HsHqefZ6nkVe0ASUF6WDgd3eX8MPfFn/KeXF1zts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F3KEbhJjxPp9hSrLK9CGCEZcZiXkHiqL31uIPq98qRXk5yEJbUUAK5p7WYfncws4NHiUGqjNaPn+Wjl97MV92xtzBNQBREufAFQxHpFXbg0wjorNHBLTOR+o4SCr2FD8Fu/WgS6HDxTfLQDjrfEvcq29f2oXfc/Y8fg7jvsX/O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BvdRpw08; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BvdRpw08"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jPz5eO+OVPKH29/hK7MS+3ukMTQhnyjk/8i4BdFMSY4=; b=BvdRpw08Vm5L2OidRZIBbQu+S5
	nOnw6OM0p7t808sBxx7x+Uy/xZ3C4RmmpTTqhOoLeeqTnB5jkUqV6/QBcI9F6Kd9oKfB3Pto55/V7
	NsUBO/vILAtLp/mMmQZtxcq0h2SW/t0ZTVDYbodOI/KlNrfu6Ka0LN27HbHYh5vDhLBspMD3F/0bc
	2xlSOO0cl+W8293/yPmgnnjyry4cyS+ifvaDfQxn2nSY/kfn/XPWNe9jxzS8vMUW/NHmg8JHPu8aM
	ipwBPtdUZTFE80josSveG2vivY/Woqb7S/9E62aeNXr3RZ7j8y4QvlQECi5jrgXtG4mYlk4zPCo96
	mjH7Hnow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFMR-0000000AUZA-0nk2;
	Mon, 12 Oct 2026 12:42:35 +0000
Date: Mon, 12 Oct 2026 05:42:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/13] xfs: don't subtract excess usage twice when
 computing agf_btreeblks
Message-ID: <aszVuwacxvW7iLb4@infradead.org>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
 <179151614663.3163896.1335957242495736456.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179151614663.3163896.1335957242495736456.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 08, 2026 at 11:15:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that the free space btree repair code calculates
> agf_btreeblks from the number of blocks we wrote to rebuild the free
> space btrees (minus the roots).  That's correct.  However, it observes
> that we subtract the "excess" reservation, which is not correct.  Fix
> this accounting problem.
> 
> Cc: <stable@vger.kernel.org> # v6.8
> Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Assisted-by: LOLLM # finding obvious bugs

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

